## <!--Procedural Macros--> 手続き型マクロ

<!--*Procedural macros* allow creating syntax extensions as execution of a function.-->
*手続き型マクロ*では、関数の実行として構文拡張を作成できます。
<!--Procedural macros can be used to implement custom [derive] on your own types.-->
手続き型マクロを使用して、独自の型でカスタム[derive]を実装できます。
<!--See [the book][procedural%20macros] for a tutorial.-->
チュートリアル[の本][procedural%20macros]を参照してください。

<!--Procedural macros involve a few different parts of the language and its standard libraries.-->
手続き型マクロには、言語とその標準ライブラリのいくつかの異なる部分が含まれています。
<!--First is the `proc_macro` crate, included with Rust, that defines an interface for building a procedural macro.-->
まずプロシージャマクロを構築するためのインタフェースを定義する、Rustに含まれている`proc_macro`クレートです。
<!--The `#[proc_macro_derive(Foo)]` attribute is used to mark the deriving function.-->
`#[proc_macro_derive(Foo)]`属性は、導出関数をマークするために使用されます。
<!--This function must have the type signature:-->
この関数は型シグネチャを持たなければなりません：

```rust,ignore
use proc_macro::TokenStream;

#[proc_macro_derive(Hello)]
pub fn hello_world(input: TokenStream) -> TokenStream
```

<!--Finally, procedural macros must be in their own crate, with the `proc-macro` crate type.-->
最後に、手続き型マクロは、`proc-macro` crate型を`proc-macro`して独自のクレートになければなりません。

<!--[derive]: attributes.html#derive
 [procedural macros]: ../book/first-edition/procedural-macros.html
-->
[procedural macros]: ../book/first-edition/procedural-macros.html
 [derive]: attributes.html#derive
 [procedural macros]: ../book/first-edition/procedural-macros.html

