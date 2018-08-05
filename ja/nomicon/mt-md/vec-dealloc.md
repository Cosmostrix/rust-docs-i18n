# <!--Deallocating--> 割当解除

<!--Next we should implement Drop so that we don't massively leak tons of resources.-->
次に、たくさんのリソースが大量に漏れないようにDropを実装する必要があります。
<!--The easiest way is to just call `pop` until it yields None, and then deallocate our buffer.-->
一番簡単な方法は、Noneを`pop`まで`pop`呼び出してから、バッファを割り当て解除することです。
<!--Note that calling `pop` is unneeded if `T: !Drop`.-->
`T: !Drop`場合、`pop`呼び出しは不要です。
<!--In theory we can ask Rust if `T` `needs_drop` and omit the calls to `pop`.-->
理論的には、もし`T` `needs_drop`ならRustに問い合わせて、`pop`呼び出す呼び出しを省略することができます。
<!--However in practice LLVM is *really* good at removing simple side-effect free code like this, so I wouldn't bother unless you notice it's not being stripped (in this case it is).-->
しかし、実際にはLLVMは、このような単純な副作用のないコードを除去するのに*本当に*良いですので、あなたはそれが（それは、この場合には）取り除かれていない気づかない限り、私は気にしないでしょう。

<!--We must not call `heap::deallocate` when `self.cap == 0`, as in this case we haven't actually allocated any memory.-->
`self.cap == 0`ときは`heap::deallocate` `self.cap == 0`ないでください。この場合、実際にはメモリは割り当てられていません。


```rust,ignore
impl<T> Drop for Vec<T> {
    fn drop(&mut self) {
        if self.cap != 0 {
            while let Some(_) = self.pop() { }

            let align = mem::align_of::<T>();
            let elem_size = mem::size_of::<T>();
            let num_bytes = elem_size * self.cap;
            unsafe {
                heap::deallocate(self.ptr.as_ptr() as *mut _, num_bytes, align);
            }
        }
    }
}
```
