# <!--Working with Unsafe--> 危険な作業

<!--Rust generally only gives us the tools to talk about Unsafe Rust in a scoped and binary manner.-->
錆は、一般的に、Unsafe Rustについてスコープとバイナリの方法で話すツールを提供します。
<!--Unfortunately, reality is significantly more complicated than that.-->
残念ながら、現実はそれよりもはるかに複雑です。
<!--For instance, consider the following toy function:-->
たとえば、次のようなおもちゃ関数を考えてみましょう。

```rust
fn index(idx: usize, arr: &[u8]) -> Option<u8> {
    if idx < arr.len() {
        unsafe {
            Some(*arr.get_unchecked(idx))
        }
    } else {
        None
    }
}
```

<!--This function is safe and correct.-->
この機能は安全で正確です。
<!--We check that the index is in bounds, and if it is, index into the array in an unchecked manner.-->
インデックスが境界内にあるかどうかを確認し、インデックスがある場合は、チェックされていない方法で配列にインデックスを付けます。
<!--But even in such a trivial function, the scope of the unsafe block is questionable.-->
しかし、このような小さな機能であっても、安全でないブロックの範囲は疑わしい。
<!--Consider changing the `<` to a `<=`:-->
`<`を`<=`変更することを検討してください：

```rust
fn index(idx: usize, arr: &[u8]) -> Option<u8> {
    if idx <= arr.len() {
        unsafe {
            Some(*arr.get_unchecked(idx))
        }
    } else {
        None
    }
}
```

<!--This program is now unsound, and yet *we only modified safe code*.-->
このプログラムは今や*安全では*ありませんが、*安全なコードだけを修正しました*。
<!--This is the fundamental problem of safety: it's non-local.-->
これは安全性の根本的な問題です。非ローカルなのです。
<!--The soundness of our unsafe operations necessarily depends on the state established by otherwise "safe"operations.-->
安全でない操作の健全性は、必然的に「安全な」操作によって確立された状態に依存します。

<!--Safety is modular in the sense that opting into unsafety doesn't require you to consider arbitrary other kinds of badness.-->
安全性は、安全ではないことを選択することは、あなたが任意の他の種類の悪いことを考慮する必要がないという意味でモジュラーです。
<!--For instance, doing an unchecked index into a slice doesn't mean you suddenly need to worry about the slice being null or containing uninitialized memory.-->
たとえば、スライスにチェックされていないインデックスを作成しても、スライスがヌルであるか、または初期化されていないメモリが含まれていることを心配する必要はありません。
<!--Nothing fundamentally changes.-->
根本的に変化するものはありません。
<!--However safety *isn't* modular in the sense that programs are inherently stateful and your unsafe operations may depend on arbitrary other state.-->
しかし、プログラムは本質的にステートフルであり、安全でない操作は任意の他の状態に依存するという意味で、安全性*は*モジュール式で*はありません*。

<!--This non-locality gets much worse when we incorporate actual persistent state.-->
この非局所性は、実際の永続状態を組み込むときにはるかに悪化します。
<!--Consider a simple implementation of `Vec`:-->
`Vec`簡単な実装を考えてみましょう。

```rust
use std::ptr;

#// Note: This definition is naive. See the chapter on implementing Vec.
// 注：この定義は単純です。Vecの実装に関する章を参照してください。
pub struct Vec<T> {
    ptr: *mut T,
    len: usize,
    cap: usize,
}

#// Note this implementation does not correctly handle zero-sized types.
#// See the chapter on implementing Vec.
// この実装はゼロサイズの型を正しく処理しないことに注意してください。Vecの実装に関する章を参照してください。
impl<T> Vec<T> {
    pub fn push(&mut self, elem: T) {
        if self.len == self.cap {
#            // not important for this example
            // この例では重要ではない
            self.reallocate();
        }
        unsafe {
            ptr::write(self.ptr.offset(self.len as isize), elem);
            self.len += 1;
        }
    }
    # fn reallocate(&mut self) { }
}

# fn main() {}
```

<!--This code is simple enough to reasonably audit and informally verify.-->
このコードは、合理的に監査し、非公式に検証するのに十分単純です。
<!--Now consider adding the following method:-->
次のメソッドを追加することを検討してください。

```rust,ignore
fn make_room(&mut self) {
#    // grow the capacity
    // 能力を伸ばす
    self.cap += 1;
}
```

<!--This code is 100% Safe Rust but it is also completely unsound.-->
このコードは100％Safe Rustですが、完全に安全ではありません。
<!--Changing the capacity violates the invariants of Vec (that `cap` reflects the allocated space in the Vec).-->
容量を変更するとVecの不変量に​​違反します（その`cap`はVecの割り当てられたスペースを反映します）。
<!--This is not something the rest of Vec can guard against.-->
Vecの残りの部分を守ることはできません。
<!--It *has* to trust the capacity field because there's no way to verify it.-->
それを確認する方法はありませんので、それは容量フィールドを信頼する必要*があります*。

<!--Because it relies on invariants of a struct field, this `unsafe` code does more than pollute a whole function: it pollutes a whole *module*.-->
構造体フィールドの不変量に​​依存するため、この`unsafe`コードは関数全体を汚染する以上のことを行い*ます*。 *モジュール*全体を汚染し*ます*。
<!--Generally, the only bullet-proof way to limit the scope of unsafe code is at the module boundary with privacy.-->
一般的に、安全でないコードの範囲を制限する唯一の防弾方法は、プライバシーを持つモジュールの境界です。

<!--However this works *perfectly*.-->
しかし、これは*完全に動作し*ます。
<!--The existence of `make_room` is *not* a problem for the soundness of Vec because we didn't mark it as public.-->
`make_room`の存在はVecの健全性にとって問題ではあり*ません*。なぜなら私たちはそれを公にしていないからです。
<!--Only the module that defines this function can call it.-->
この関数を定義するモジュールだけが呼び出すことができます。
<!--Also, `make_room` directly accesses the private fields of Vec, so it can only be written in the same module as Vec.-->
また、`make_room`はVecのプライベートフィールドに直接アクセスするため、Vecと同じモジュールにしか書き込めません。

<!--It is therefore possible for us to write a completely safe abstraction that relies on complex invariants.-->
したがって、複雑な不変量に依存する完全に安全な抽象化を書くことが可能です。
<!--This is *critical* to the relationship between Safe Rust and Unsafe Rust.-->
これは、安全な錆と安全でない錆の関係*にとって非常に重要*です。

<!--We have already seen that Unsafe code must trust *some* Safe code, but shouldn't trust *generic* Safe code.-->
安全でないコードは*いくつかの*セーフコードを信頼*する*必要がありますが、*一般的*なセーフコードは信頼できません。
<!--Privacy is important to unsafe code for similar reasons: it prevents us from having to trust all the safe code in the universe from messing with our trusted state.-->
プライバシーは安全でないコードにとっても同様の理由から重要です。それは、宇宙のすべての安全なコードを信頼できる状態に陥らせることから私たちを守ることを妨げるからです。

<!--Safety lives!-->
安全ライフ！

