
# <!--RawVec--> RawVec

<!--We've actually reached an interesting situation here: we've duplicated the logic for specifying a buffer and freeing its memory in Vec and IntoIter.-->
VecとIntoIterでバッファを指定し、そのメモリを解放するロジックを複製しました。
<!--Now that we've implemented it and identified *actual* logic duplication, this is a good time to perform some logic compression.-->
これを実装し、*実際の*ロジックの重複を特定したので、これはロジック圧縮を行う良いタイミングです。

<!--We're going to abstract out the `(ptr, cap)` pair and give them the logic for allocating, growing, and freeing:-->
私たちは`(ptr, cap)`ペアを抽象化して、割り当て、成長、解放のロジックを与えます：

```rust,ignore
struct RawVec<T> {
    ptr: Unique<T>,
    cap: usize,
}

impl<T> RawVec<T> {
    fn new() -> Self {
        assert!(mem::size_of::<T>() != 0, "TODO: implement ZST support");
        RawVec { ptr: Unique::empty(), cap: 0 }
    }

#    // unchanged from Vec
    //  Vecから変わらない
    fn grow(&mut self) {
        unsafe {
            let align = mem::align_of::<T>();
            let elem_size = mem::size_of::<T>();

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
        if self.cap != 0 {
            let align = mem::align_of::<T>();
            let elem_size = mem::size_of::<T>();
            let num_bytes = elem_size * self.cap;
            unsafe {
                heap::deallocate(self.ptr.as_mut() as *mut _, num_bytes, align);
            }
        }
    }
}
```

<!--And change Vec as follows:-->
Vecを次のように変更します。

```rust,ignore
pub struct Vec<T> {
    buf: RawVec<T>,
    len: usize,
}

impl<T> Vec<T> {
    fn ptr(&self) -> *mut T { self.buf.ptr.as_ptr() }

    fn cap(&self) -> usize { self.buf.cap }

    pub fn new() -> Self {
        Vec { buf: RawVec::new(), len: 0 }
    }

#    // push/pop/insert/remove largely unchanged:
#    // * `self.ptr -> self.ptr()`
#    // * `self.cap -> self.cap()`
#    // * `self.grow -> self.buf.grow()`
    //  * `self.ptr -> self.ptr()` * `self.cap -> self.cap()` * `self.grow -> self.buf.grow()`
}

impl<T> Drop for Vec<T> {
    fn drop(&mut self) {
        while let Some(_) = self.pop() {}
#        // deallocation is handled by RawVec
        // 割り当て解除はRawVecによって処理されます
    }
}
```

<!--And finally we can really simplify IntoIter:-->
そして最後に、IntoIterを実際に単純化することができます：

```rust,ignore
struct IntoIter<T> {
#//    _buf: RawVec<T>, // we don't actually care about this. Just need it to live.
    _buf: RawVec<T>, // 私たちは実際にこれに気をつけません。ただそれが生きるために必要です。
    start: *const T,
    end: *const T,
}

#// next and next_back literally unchanged since they never referred to the buf
//  nextとnext_backはbufを参照していないので文字通り変更されません

impl<T> Drop for IntoIter<T> {
    fn drop(&mut self) {
#        // only need to ensure all our elements are read;
#        // buffer will clean itself up afterwards.
        // すべての要素を確実に読み取る必要があります。バッファは後で自身をクリーンアップします。
        for _ in &mut *self {}
    }
}

impl<T> Vec<T> {
    pub fn into_iter(self) -> IntoIter<T> {
        unsafe {
#            // need to use ptr::read to unsafely move the buf out since it's
#            // not Copy, and Vec implements Drop (so we can't destructure it).
            // それはコピーではないのでbufを安全に動かすためにptr:: readを使う必要があります.VecはDropを実装していますので、それを解体することはできません。
            let buf = ptr::read(&self.buf);
            let len = self.len;
            mem::forget(self);

            IntoIter {
                start: *buf.ptr,
                end: buf.ptr.offset(len as isize),
                _buf: buf,
            }
        }
    }
}
```

<!--Much better.-->
ずっといい。
