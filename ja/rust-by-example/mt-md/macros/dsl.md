# <!--Domain Specific Languages (DSLs)--> ドメイン固有言語（DSL）

<!--A DSL is a mini "language"embedded in a Rust macro.-->
DSLはRustマクロに埋め込まれたミニ言語です。
<!--It is completely valid Rust because the macro system expands into normal Rust constructs, but it looks like a small language.-->
マクロシステムは通常のRust構造に拡張されるため、完全に有効なRustですが、小さな言語のように見えます。
<!--This allows you to define concise or intuitive syntax for some special functionality (within bounds).-->
これにより、（境界内の）いくつかの特別な機能に対して、簡潔または直観的な構文を定義することができます。

<!--Suppose that I want to define a little calculator API.-->
ちょっとした計算機APIを定義したいとします。
<!--I would like to supply an expression an have the output printed to console.-->
私は出力をコンソールに出力させた表現を提供したいと思います。

```rust,editable
macro_rules! calculate {
    (eval $e:expr) => {{
        {
#//            let val: usize = $e; // Force types to be integers
            let val: usize = $e; // 型を強制的に整数にする
            println!("{} = {}", stringify!{$e}, val);
        }
    }};
}

fn main() {
    calculate! {
#//        eval 1 + 2 // hehehe `eval` is _not_ a Rust keyword!
        eval 1 + 2 //  hehehe `eval`はRustキーワードではあり _ません_ ！
    }

    calculate! {
        eval (1 + 2) * (3 / 4)
    }
}
```

<!--Output:-->
出力：

```txt
1 + 2 = 3
(1 + 2) * (3 / 4) = 0
```

<!--This was a very simple example, but much more complex interfaces have been developed, such as [`lazy_static`](https://crates.io/crates/lazy_static) or [`clap`](https://crates.io/crates/clap).-->
これは非常に簡単な例でしたが、[`lazy_static`](https://crates.io/crates/lazy_static)や[`clap`](https://crates.io/crates/clap)など、はるかに複雑なインターフェースが開発されています。
