# <!--Push and Pop--> プッシュアンドポップ

<!--Alright.-->
よかった。
<!--We can initialize.-->
私たちは初期化することができます。
<!--We can allocate.-->
我々は割り当てることができます。
<!--Let's actually implement some functionality!-->
実際にいくつかの機能を実装しよう！
<!--Let's start with `push`.-->
`push`始めましょう。
<!--All it needs to do is check if we're full to grow, unconditionally write to the next index, and then increment our length.-->
私たちが成長するのに十分であるかどうかをチェックし、無条件に次のインデックスに書き込んだ後、長さを増やすだけです。

<!--To do the write we have to be careful not to evaluate the memory we want to write to.-->
書き込みを行うには、書き込みたいメモリを評価しないように注意する必要があります。
<!--At worst, it's truly uninitialized memory from the allocator.-->
最悪の場合、それは本当にアロケータからの初期化されていないメモリです。
<!--At best it's the bits of some old value we popped off.-->
最高でも、私たちが沸き起こった古い価値のビットです。
<!--Either way, we can't just index to the memory and dereference it, because that will evaluate the memory as a valid instance of T. Worse, `foo[idx] = x` will try to call `drop` on the old value of `foo[idx]`!-->
いずれかの方法では、我々はそれを悪化さTの有効なインスタンスとしてメモリを評価しますので、メモリにそれを間接参照だけではなく、インデックス、できる`foo[idx] = x`呼び出すようにしようと`drop`の古い値に`foo[idx]`！

<!--The correct way to do this is with `ptr::write`, which just blindly overwrites the target address with the bits of the value we provide.-->
これを行う正しい方法は`ptr::write`で、ターゲットアドレスを盲目的に私たちが提供する値のビットで上書きします。
<!--No evaluation involved.-->
評価は必要ありません。

<!--For `push`, if the old len (before push was called) is 0, then we want to write to the 0th index.-->
`push`場合、古いlen（pushが呼び出される前）が0なら、0番目のインデックスに書きたいと思う。
<!--So we should offset by the old len.-->
だから私は古いlenによって相殺すべきです。

```rust,ignore
pub fn push(&mut self, elem: T) {
    if self.len == self.cap { self.grow(); }

    unsafe {
        ptr::write(self.ptr.offset(self.len as isize), elem);
    }

#    // Can't fail, we'll OOM first.
    // 失敗することはできません、私たちはまずOOMをします。
    self.len += 1;
}
```

<!--Easy!-->
簡単！
<!--How about `pop`?-->
`pop`どうですか？
<!--Although this time the index we want to access is initialized, Rust won't just let us dereference the location of memory to move the value out, because that would leave the memory uninitialized!-->
今回は、アクセスしたいインデックスが初期化されていますが、Rustは値を移動するためにメモリの位置を逆参照させません。これは、メモリが初期化されていないためです。
<!--For this we need `ptr::read`, which just copies out the bits from the target address and interprets it as a value of type T. This will leave the memory at this address logically uninitialized, even though there is in fact a perfectly good instance of T there.-->
このためには、ターゲットアドレスからビットをコピーしてT型の値として解釈する`ptr::read`が必要です。実際には完全に良いインスタンスがあっても、このアドレスのメモリは論理的に初期化されませんそこにTの。

<!--For `pop`, if the old len is 1, we want to read out of the 0th index.-->
`pop`場合、古いlenが1の場合は、0番目のインデックスを読み込みます。
<!--So we should offset by the new len.-->
だから私たちは新しいlenによって相殺すべきです。

```rust,ignore
pub fn pop(&mut self) -> Option<T> {
    if self.len == 0 {
        None
    } else {
        self.len -= 1;
        unsafe {
            Some(ptr::read(self.ptr.offset(self.len as isize)))
        }
    }
}
```
