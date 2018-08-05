# <!--Elision--> エリシオン

<!--Some lifetime patterns are overwelmingly common and so the borrow checker will implicitly add them to save typing and to improve readability.-->
一部の生涯パターンは圧倒的に一般的なので、借用チェッカーは暗黙的にそれらを追加してタイピングを省略し、可読性を向上させます。
<!--This process of implicit addition is called elision.-->
暗黙の追加のこのプロセスはelisionと呼ばれます。
<!--Elision exists in Rust solely because these patterns are common.-->
これらのパターンは共通しているため、ElisionはRustのみに存在します。

<!--The following code shows a few examples of elision.-->
次のコードは、elisionのいくつかの例を示しています。
<!--For a more comprehensive description of elision, see [lifetime elision][elision] in the book.-->
elisionのより包括的な説明については、本の[lifetime elision][elision]を参照してください。

```rust,editable
#// `elided_input` and `annotated_input` essentially have identical signatures
#// because the lifetime of `elided_input` is elided by the compiler:
//  `elided_input`と`annotated_input`本質的なシグネチャは、コンパイラによって`elided_input`の存続期間が省略されているためです。
fn elided_input(x: &i32) {
    println!("`elided_input`: {}", x);
}

fn annotated_input<'a>(x: &'a i32) {
    println!("`annotated_input`: {}", x);
}

#// Similarly, `elided_pass` and `annotated_pass` have identical signatures
#// because the lifetime is added implicitly to `elided_pass`:
// 同様に、`elided_pass`と`annotated_pass`は、生涯が`elided_pass`暗黙的に追加されるため、同じシグニチャを`elided_pass`ます。
fn elided_pass(x: &i32) -> &i32 { x }

fn annotated_pass<'a>(x: &'a i32) -> &'a i32 { x }

fn main() {
    let x = 3;

    elided_input(&x);
    annotated_input(&x);

    println!("`elided_pass`: {}", elided_pass(&x));
    println!("`annotated_pass`: {}", annotated_pass(&x));
}
```

### <!--See also:--> 参照：

[elision][elision]
[elision]: https://doc.rust-lang.org/book/second-edition/ch10-03-lifetime-syntax.html#lifetime-elision
