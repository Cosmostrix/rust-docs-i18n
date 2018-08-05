# `dead_code`
<!--The compiler provides a `dead_code` [*lint*][lint] that will warn about unused functions.-->
コンパイラは、未使用の関数について警告する`dead_code` [*lint*][lint]を提供します。
<!--An *attribute* can be used to disable the lint.-->
*属性*を使用してlintを無効にすることができます。

```rust,editable
fn used_function() {}

#// `#[allow(dead_code)]` is an attribute that disables the `dead_code` lint
//  `#[allow(dead_code)]`は、`dead_code` lintを無効にする属性です
#[allow(dead_code)]
fn unused_function() {}

fn noisy_unused_function() {}
#// FIXME ^ Add an attribute to suppress the warning
//  FIXME ^警告を抑制する属性を追加する

fn main() {
    used_function();
}
```

<!--Note that in real programs, you should eliminate dead code.-->
実際のプログラムでは、デッドコードを除去する必要があります。
<!--In these examples we'll allow dead code in some places because of the interactive nature of the examples.-->
これらの例では、例の対話的な性質のために、いくつかの場所でデッドコードを許可します。

[lint]: https://en.wikipedia.org/wiki/Lint_%28software%29
