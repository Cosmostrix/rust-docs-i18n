# <!--IntoIter--> イントロター

<!--Let's move on to writing iterators.-->
イテレータの作成に移りましょう。
<!--`iter` and `iter_mut` have already been written for us thanks to The Magic of Deref.-->
`iter`と`iter_mut`はすでに`iter_mut`の魔法のおかげで私たちのために書かれています。
<!--However there's two interesting iterators that Vec provides that slices can't: `into_iter` and `drain`.-->
しかし、Vecが提供する2つの面白いイテレータは、スライスではできません： `into_iter`と`drain`。

<!--IntoIter consumes the Vec by-value, and can consequently yield its elements by-value.-->
IntoIterはVecの値を消費し、その結果、値ごとに要素を出力できます。
<!--In order to enable this, IntoIter needs to take control of Vec's allocation.-->
これを可能にするためにIntoIterはVecの割り当てを管理する必要があります。

<!--IntoIter needs to be DoubleEnded as well, to enable reading from both ends.-->
両方から読み込みを可能にするには、IntoIterをDoubleEndedにする必要があります。
<!--Reading from the back could just be implemented as calling `pop`, but reading from the front is harder.-->
背中からの読書は`pop`を呼び出すように実装できますが、正面からの読書は難しくなります。
<!--We could call `remove(0)` but that would be insanely expensive.-->
`remove(0)`呼び出すことができますが、それは非常に高価です。
<!--Instead we're going to just use ptr::read to copy values out of either end of the Vec without mutating the buffer at all.-->
代わりに、バッファをまったく変更せずにVecの両端から値をコピーするためにptr:: readを使用するだけです。

<!--To do this we're going to use a very common C idiom for array iteration.-->
これを行うために、配列の繰り返しに非常に共通のCイディオムを使用します。
<!--We'll make two pointers;-->
私たちは2つの指針を作成します。
<!--one that points to the start of the array, and one that points to one-element past the end.-->
1つは配列の先頭を指し、もう1つは最後の要素を指します。
<!--When we want an element from one end, we'll read out the value pointed to at that end and move the pointer over by one.-->
一方の端から要素を取得する場合は、その端で指し示されている値を読み込み、ポインタを1つ上に移動します。
<!--When the two pointers are equal, we know we're done.-->
2つのポインタが等しい場合、完了したことがわかります。

<!--Note that the order of read and offset are reversed for `next` and `next_back` For `next_back` the pointer is always after the element it wants to read next, while for `next` the pointer is always at the element it wants to read next.-->
readとoffsetの順序は`next`と`next_back`逆になることに注意してください`next_back`場合、ポインタは次に読みたい要素の`next_back`ありますが、`next`ではポインタは常に次に読みたい要素にあります。
<!--To see why this is, consider the case where every element but one has been yielded.-->
これがなぜであるかを見るには、1つを除くすべての要素が生成された場合を考えてみましょう。

<!--The array looks like this:-->
配列は次のようになります。

```text
          S  E
[X, X, X, O, X, X, X]
```

<!--If E pointed directly at the element it wanted to yield next, it would be indistinguishable from the case where there are no more elements to yield.-->
Eが次に得たい要素を指している場合、それ以上の要素がない場合と区別できません。

<!--Although we don't actually care about it during iteration, we also need to hold onto the Vec's allocation information in order to free it once IntoIter is dropped.-->
反復処理中は実際には気にしませんが、IntoIterを削除するとVecの割り当て情報を保持して解放する必要があります。

<!--So we're going to use the following struct:-->
したがって、次の構造体を使用します。

```rust,ignore
struct IntoIter<T> {
    buf: Unique<T>,
    cap: usize,
    start: *const T,
    end: *const T,
}
```

<!--And this is what we end up with for initialization:-->
これが初期化のためのものです。

```rust,ignore
impl<T> Vec<T> {
    fn into_iter(self) -> IntoIter<T> {
#        // Can't destructure Vec since it's Drop
        // ドロップしてからVecを破棄することはできません
        let ptr = self.ptr;
        let cap = self.cap;
        let len = self.len;

#        // Make sure not to drop Vec since that will free the buffer
        // バッファを解放するのでVecを落とさないようにしてください
        mem::forget(self);

        unsafe {
            IntoIter {
                buf: ptr,
                cap: cap,
                start: *ptr,
                end: if cap == 0 {
#                    // can't offset off this pointer, it's not allocated!
                    // このポインタをオフセットすることはできません。割り当てられません。
                    *ptr
                } else {
                    ptr.offset(len as isize)
                }
            }
        }
    }
}
```

<!--Here's iterating forward:-->
ここでは前進を繰り返す：

```rust,ignore
impl<T> Iterator for IntoIter<T> {
    type Item = T;
    fn next(&mut self) -> Option<T> {
        if self.start == self.end {
            None
        } else {
            unsafe {
                let result = ptr::read(self.start);
                self.start = self.start.offset(1);
                Some(result)
            }
        }
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        let len = (self.end as usize - self.start as usize)
                  / mem::size_of::<T>();
        (len, Some(len))
    }
}
```

<!--And here's iterating backwards.-->
ここでは逆向きに繰り返します。

```rust,ignore
impl<T> DoubleEndedIterator for IntoIter<T> {
    fn next_back(&mut self) -> Option<T> {
        if self.start == self.end {
            None
        } else {
            unsafe {
                self.end = self.end.offset(-1);
                Some(ptr::read(self.end))
            }
        }
    }
}
```

<!--Because IntoIter takes ownership of its allocation, it needs to implement Drop to free it.-->
IntoIterは割り当ての所有権を取得するため、Dropを実装して解放する必要があります。
<!--However it also wants to implement Drop to drop any elements it contains that weren't yielded.-->
しかし、Dropを実装して、含まれていない要素を削除したい場合もあります。


```rust,ignore
impl<T> Drop for IntoIter<T> {
    fn drop(&mut self) {
        if self.cap != 0 {
#            // drop any remaining elements
            // 残りの要素をすべて削除する
            for _ in &mut *self {}

            let align = mem::align_of::<T>();
            let elem_size = mem::size_of::<T>();
            let num_bytes = elem_size * self.cap;
            unsafe {
                heap::deallocate(self.buf.as_ptr() as *mut _, num_bytes, align);
            }
        }
    }
}
```
