# <!--macro_rules!--> マクロ_ルール！

<!--Rust provides a powerful macro system that allows metaprogramming.-->
Rustはメタプログラミングを可能にする強力なマクロシステムを提供します。
<!--As you've seen in previous chapters, macros look like functions, except that their name ends with a bang `!`, but instead of generating a function call, macros are expanded into source code that gets compiled with the rest of the program.-->
あなたは前の章で見てきたように、マクロはその名前がビッグバンで終わることを除いて、関数のように見える`!`、代わりに関数呼び出しを生成する、マクロはプログラムの残りの部分とコンパイルされるソースコードに展開されています。
<!--However, unlike macros in C and other languages, Rust macros are expanded into abstract syntax trees, rather than string preprocessing, so you don't get unexpected precedence bugs.-->
しかし、Cやその他の言語のマクロとは異なり、Rustマクロは文字列前処理ではなく抽象構文木に展開されるため、予期しない優先順位のバグは発生しません。

<!--Macros are created using the `macro_rules!` macro.-->
マクロは`macro_rules!`マクロを使用して作成されます。

```rust,editable
#// This is a simple macro named `say_hello`.
// これは`say_hello`という単純なマクロ`say_hello`。
macro_rules! say_hello {
#    // `()` indicates that the macro takes no argument.
    //  `()`はマクロが引数を取らないことを示します。
    () => (
#        // The macro will expand into the contents of this block.
        // マクロはこのブロックの内容に展開されます。
        println!("Hello!");
    )
}

fn main() {
#    // This call will expand into `println!("Hello");`
    // この呼び出しは`println!("Hello");`展開され`println!("Hello");`
    say_hello!()
}
```

<!--So why are macros useful?-->
では、マクロはなぜ有用なのですか？

1. <!--Don't repeat yourself.-->
    繰り返さないでください。
<!--There are many cases where you may need similar functionality in multiple places but with different types.-->
    同様の機能を複数の場所で必要とする場合がありますが、種類は異なります。
<!--Often, writing a macro is a useful way to avoid repeating code.-->
    しばしば、マクロを書くことは、コードを繰り返さないようにする便利な方法です。
<!--(More on this later)-->
    （詳細は後で）

2. <!--Domain-specific languages.-->
    ドメイン固有の言語
<!--Macros allow you to define special syntax for a specific purpose.-->
    マクロを使用すると、特定の目的のために特殊な構文を定義できます。
<!--(More on this later)-->
    （詳細は後で）

3. <!--Variadic interfaces.-->
    Variadicインターフェース。
<!--Sometime you want to define an interface that takes a variable number of arguments.-->
    いつかは、可変数の引数を取るインターフェースを定義したいと思っています。
<!--An example is `println!` which could take any number of arguments, depending on the format string!.-->
    たとえば、書式文字列に応じて、任意の数の引数を取ることができる`println!`という例があります。
<!--(More on this later)-->
    （詳細は後で）
