# <!--Literals and operators--> リテラルと演算子

<!--Integers `1`, floats `1.2`, characters `'a'`, strings `"abc"`, booleans `true` and the unit type `()` can be expressed using literals.-->
整数`1`、浮遊`1.2`、文字`'a'`、文字列`"abc"`、ブール`true`とユニットタイプ`()`リテラルを使用して発現させることができます。

<!--Integers can, alternatively, be expressed using hexadecimal, octal or binary notation using either of these prefixes: `0x`, `0o` or `0b`.-->
代わりに、整数は、これらの接頭辞のいずれか（`0x`、 `0o`または`0b`いずれかを使用して、16進、8進または2進表記を使用して表現することができます。

<!--Underscores can be inserted in numeric literals to improve readability, eg `1_000` is the same as `1000`, and `0.000_001` is the same as `0.000001`.-->
たとえば、`1_000`は`1000`と同じで、`0.000_001`は`0.000001`と同じです。たとえば、可読性を向上させるためにアンダースコアを数値リテラルに挿入できます。

<!--We need to tell the compiler the type of the literals we use.-->
私たちが使用するリテラルの型をコンパイラに伝える必要があります。
<!--For now, we'll use the `u32` suffix to indicate that the literal is an unsigned 32-bit integer, and the `i32` suffix to indicate that it's a signed 32-bit integer.-->
ここでは、`u32`サフィックスを使用して、リテラルが符号なし32ビット整数であることを示し、`i32`サフィックスが符号付き32ビット整数であることを示します。

<!--The operators available and their precedence [in Rust][rust%20op-prec] are similar to other [C-like languages][op-prec].-->
利用できる演算子と[Rustの][rust%20op-prec]優先順位[は][rust%20op-prec]、他の[C言語のようなものです][op-prec]。

```rust,editable
fn main() {
#    // Integer addition
    // 整数加算
    println!("1 + 2 = {}", 1u32 + 2);

#    // Integer subtraction
    // 整数減算
    println!("1 - 2 = {}", 1i32 - 2);
#    // TODO ^ Try changing `1i32` to `1u32` to see why the type is important
    //  TODO ^ `1i32`を`1u32`に変更して、そのタイプが重要である理由を`1u32`してください

#    // Short-circuiting boolean logic
    // ブール論理を短絡する
    println!("true AND false is {}", true && false);
    println!("true OR false is {}", true || false);
    println!("NOT true is {}", !true);

#    // Bitwise operations
    // ビット演算
    println!("0011 AND 0101 is {:04b}", 0b0011u32 & 0b0101);
    println!("0011 OR 0101 is {:04b}", 0b0011u32 | 0b0101);
    println!("0011 XOR 0101 is {:04b}", 0b0011u32 ^ 0b0101);
    println!("1 << 5 is {}", 1u32 << 5);
    println!("0x80 >> 2 is 0x{:x}", 0x80u32 >> 2);

#    // Use underscores to improve readability!
    // 読みやすくするためにアンダースコアを使用してください。
    println!("One million is written as {}", 1_000_000u32);
}
```

<!--[rust op-prec]: https://doc.rust-lang.org/reference/expressions.html#expression-precedence
 [op-prec]: https://en.wikipedia.org/wiki/Operator_precedence#Programming_languages
-->
[rust op-prec]: https://doc.rust-lang.org/reference/expressions.html#expression-precedence
 [op-prec]: https://en.wikipedia.org/wiki/Operator_precedence#Programming_languages

