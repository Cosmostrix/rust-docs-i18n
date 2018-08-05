# <!--Type Conversions--> タイプ変換

<!--At the end of the day, everything is just a pile of bits somewhere, and type systems are just there to help us use those bits right.-->
その日の終わりには、すべてがどこかのビットの束であり、タイプ・システムは、それらのビットを正しく使用するのに役立ちます。
<!--There are two common problems with typing bits: needing to reinterpret those exact bits as a different type, and needing to change the bits to have equivalent meaning for a different type.-->
これらの正確なビットを別のタイプとして再解釈する必要があり、ビットを変更して異なるタイプの同等の意味を持つようにする必要があります。
<!--Because Rust encourages encoding important properties in the type system, these problems are incredibly pervasive.-->
Rustは型システムの重要なプロパティをエンコードすることを奨励するので、これらの問題は非常に広がっています。
<!--As such, Rust consequently gives you several ways to solve them.-->
そのため、Rustは結果的にそれらを解決するいくつかの方法を提供します。

<!--First we'll look at the ways that Safe Rust gives you to reinterpret values.-->
最初に、Safe Rustが値を再解釈する方法を見ていきます。
<!--The most trivial way to do this is to just destructure a value into its constituent parts and then build a new type out of them.-->
これを行う最も簡単な方法は、価値をその構成要素に分解し、その中から新しいタイプを構築することです。
<!--eg-->
例えば

```rust
struct Foo {
    x: u32,
    y: u16,
}

struct Bar {
    a: u32,
    b: u16,
}

fn reinterpret(foo: Foo) -> Bar {
    let Foo { x, y } = foo;
    Bar { a: x, b: y }
}
```

<!--But this is, at best, annoying.-->
しかし、これは、せいぜい、迷惑です。
<!--For common conversions, Rust provides more ergonomic alternatives.-->
一般的なコンバージョンの場合、Rustは人間工学に優れた代替品を提供します。

