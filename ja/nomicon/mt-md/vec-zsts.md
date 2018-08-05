# <!--Handling Zero-Sized Types--> ゼロサイズの型の処理

<!--It's time.-->
時間です。
<!--We're going to fight the specter that is zero-sized types.-->
我々はゼロサイズのタイプである幽霊と戦うつもりです。
<!--Safe Rust *never* needs to care about this, but Vec is very intensive on raw pointers and raw allocations, which are exactly the two things that care about zero-sized types.-->
Safe Rust *は*これを気にする必要*はありません*が、Vecはrawポインタとrawアロケーションに非常に集中しています。これはちょうどゼロサイズのタイプを気にする2つのものです。
<!--We need to be careful of two things:-->
我々は2つのことに注意する必要があります：

* <!--The raw allocator API has undefined behavior if you pass in 0 for an allocation size.-->
   未割り当てのアロケータAPIは、割り当てサイズとして0を渡すと未定義の動作をします。
* <!--raw pointer offsets are no-ops for zero-sized types, which will break our C-style pointer iterator.-->
   生のポインタオフセットは、ゼロサイズの型に対してはno-opsであり、Cスタイルのポインタイテレータを壊します。

<!--Thankfully we abstracted out pointer-iterators and allocating handling into RawValIter and RawVec respectively.-->
ありがたいことに、ポインタイテレータを抽象化し、それぞれRawValIterとRawVecにハンドリングを割り当てました。
<!--How mysteriously convenient.-->
どのように神秘的に便利です。




## <!--Allocating Zero-Sized Types--> ゼロサイズの型の割り当て

<!--So if the allocator API doesn't support zero-sized allocations, what on earth do we store as our allocation?-->
したがって、アロケータAPIがゼロサイズのアロケーションをサポートしていない場合、アロケータとして何を保存しますか？
<!--`Unique::empty()` of course!-->
`Unique::empty()`もちろん！
<!--Almost every operation with a ZST is a no-op since ZSTs have exactly one value, and therefore no state needs to be considered to store or load them.-->
ZSTはほぼ正確に1つの値を持つため、ZSTを使用するほとんどの操作はノーオペレーションであるため、それらを格納またはロードする必要はありません。
<!--This actually extends to `ptr::read` and `ptr::write`: they won't actually look at the pointer at all.-->
これは実際には`ptr::read`と`ptr::write`に拡張されます。実際にはポインタをまったく見ないでしょう。
<!--As such we never need to change the pointer.-->
したがって、ポインタを変更する必要はありません。

<!--Note however that our previous reliance on running out of memory before overflow is no longer valid with zero-sized types.-->
ただし、以前のオーバーフローの前にメモリが使い果たされていたことはゼロサイズの型では無効になりました。
<!--We must explicitly guard against capacity overflow for zero-sized types.-->
ゼロサイズのタイプの容量オーバーフローを明示的に守る必要があります。

<!--Due to our current architecture, all this means is writing 3 guards, one in each method of RawVec.-->
私たちの現在のアーキテクチャのおかげで、このすべての手段はRawVecの各メソッドに3つのガードを作成しています。

```rust,ignore
impl<T> RawVec<T> {
    fn new() -> Self {
#        // !0 is usize::MAX. This branch should be stripped at compile time.
        // ！0はusize:: MAXです。コンパイル時にこのブランチを削除する必要があります。
        let cap = if mem::size_of::<T>() == 0 { !0 } else { 0 };

#        // Unique::empty() doubles as "unallocated" and "zero-sized allocation"
        //  Unique:: empty（）は、「未割り当て」と「サイズゼロの割り当て」を兼ね備えています。
        RawVec { ptr: Unique::empty(), cap: cap }
    }

    fn grow(&mut self) {
        unsafe {
            let elem_size = mem::size_of::<T>();

#            // since we set the capacity to usize::MAX when elem_size is
#            // 0, getting to here necessarily means the Vec is overfull.
            //  elem_sizeが0のときにusize:: MAXに容量を設定しているので、ここに到達するということは必然的にVecが大量であることを意味します。
            assert!(elem_size != 0, "capacity overflow");

            let align = mem::align_of::<T>();

            let (new_cap, ptr) = if self.cap == 0 {
                let ptr = heap::allocate(elem_size, align);
                (1, ptr)
            } else {
                let new_cap = 2 * self.cap;
                let ptr = heap::reallocate(self.ptr.as_ptr() as *mut _,
                                            self.cap * elem_size,
                                            new_cap * elem_size,
                                            align);
                (new_cap, ptr)
            };

#            // If allocate or reallocate fail, we'll get `null` back
            //  allocateまたはreallocateが失敗すると、`null`戻されます。
            if ptr.is_null() { oom() }

            self.ptr = Unique::new(ptr as *mut _);
            self.cap = new_cap;
        }
    }
}

impl<T> Drop for RawVec<T> {
    fn drop(&mut self) {
        let elem_size = mem::size_of::<T>();

#        // don't free zero-sized allocations, as they were never allocated.
        // 割り当てられていないので、ゼロサイズの割り当てを解放しないでください。
        if self.cap != 0 && elem_size != 0 {
            let align = mem::align_of::<T>();

            let num_bytes = elem_size * self.cap;
            unsafe {
                heap::deallocate(self.ptr.as_ptr() as *mut _, num_bytes, align);
            }
        }
    }
}
```

<!--That's it.-->
それでおしまい。
<!--We support pushing and popping zero-sized types now.-->
ゼロサイズの型のプッシュとポップをサポートしています。
<!--Our iterators (that aren't provided by slice Deref) are still busted, though.-->
私たちのイテレーター（Derefスライスでは提供されていない）のイテレーターはまだ破棄されています。




## <!--Iterating Zero-Sized Types--> ゼロサイズ型の繰り返し

<!--Zero-sized offsets are no-ops.-->
ゼロサイズのオフセットはno-opsです。
<!--This means that our current design will always initialize `start` and `end` as the same value, and our iterators will yield nothing.-->
つまり、現在のデザインでは常に`start`値と`end`値が同じ値として初期化され、イテレータは何も返されません。
<!--The current solution to this is to cast the pointers to integers, increment, and then cast them back:-->
現在の解決策は、ポインタを整数にキャストし、インクリメントしてからキャストすることです。

```rust,ignore
impl<T> RawValIter<T> {
    unsafe fn new(slice: &[T]) -> Self {
        RawValIter {
            start: slice.as_ptr(),
            end: if mem::size_of::<T>() == 0 {
                ((slice.as_ptr() as usize) + slice.len()) as *const _
            } else if slice.len() == 0 {
                slice.as_ptr()
            } else {
                slice.as_ptr().offset(slice.len() as isize)
            }
        }
    }
}
```

<!--Now we have a different bug.-->
今度は別のバグがあります。
<!--Instead of our iterators not running at all, our iterators now run *forever*.-->
イテレータはまったく動作していないのではなく、*永遠に*動作し*ます*。
<!--We need to do the same trick in our iterator impls.-->
私たちはイテレータのimplsにおいて同じトリックを行う必要があります。
<!--Also, our size_hint computation code will divide by 0 for ZSTs.-->
また、私たちのsize_hint計算コードは、ZSTのために0で割ります。
<!--Since we'll basically be treating the two pointers as if they point to bytes, we'll just map size 0 to divide by 1.-->
基本的には、2つのポインタをバイトを指しているかのように扱うため、サイズ0をマップして1で割ります。

```rust,ignore
impl<T> Iterator for RawValIter<T> {
    type Item = T;
    fn next(&mut self) -> Option<T> {
        if self.start == self.end {
            None
        } else {
            unsafe {
                let result = ptr::read(self.start);
                self.start = if mem::size_of::<T>() == 0 {
                    (self.start as usize + 1) as *const _
                } else {
                    self.start.offset(1)
                };
                Some(result)
            }
        }
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        let elem_size = mem::size_of::<T>();
        let len = (self.end as usize - self.start as usize)
                  / if elem_size == 0 { 1 } else { elem_size };
        (len, Some(len))
    }
}

impl<T> DoubleEndedIterator for RawValIter<T> {
    fn next_back(&mut self) -> Option<T> {
        if self.start == self.end {
            None
        } else {
            unsafe {
                self.end = if mem::size_of::<T>() == 0 {
                    (self.end as usize - 1) as *const _
                } else {
                    self.end.offset(-1)
                };
                Some(ptr::read(self.end))
            }
        }
    }
}
```

<!--And that's it.-->
以上です。
<!--Iteration works!-->
反復作業！
