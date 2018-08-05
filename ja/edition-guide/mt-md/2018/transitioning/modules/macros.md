# <!--Macro changes--> マクロの変更

<!--In Rust 2018, you can import specific macros from external crates via `use` statements, rather than the old `#[macro_use]` attribute.-->
Rust 2018では、古い`#[macro_use]`属性ではなく、`use`文を`use`特定のマクロを外部クレートからインポートできます。

<!--For example, consider a `bar` crate that implements a `baz!` macro.-->
たとえば、`baz!`マクロを実装する`bar`枠を考えてみましょう。
<!--In `src/lib.rs`:-->
`src/lib.rs`：

```rust
#[macro_export]
macro_rules! baz {
    () => ()
}
```

<!--In your crate, you would have written-->
あなたの木枠では、あなたは書いたでしょう

```rust,ignore
#// Rust 2015
//  2015年の錆

#[macro_use]
extern crate bar;

fn main() {
    baz!();
}
```

<!--Now, you write:-->
今、あなたは次のように書く：

```rust,ignore
#// Rust 2018
// 錆2018
#![feature(rust_2018_preview, use_extern_macros)]

use bar::baz;

fn main() {
    baz!();
}
```

<!--This moves `macro_rules` macros to be a bit closer to other kinds of items.-->
これにより、`macro_rules`マクロは他の種類の項目に少し近づくように移動します。

## <!--More details--> 詳細

<!--This only works for macros defined in external crates.-->
これは、外部クレートで定義されたマクロに対してのみ機能します。
<!--For macros defined locally, `#[macro_use] mod foo;`-->
ローカルで定義されたマクロの場合、`#[macro_use] mod foo;`
<!--is still required, as it was in Rust 2015.-->
2015年のRustにあるように、まだ必要です。
