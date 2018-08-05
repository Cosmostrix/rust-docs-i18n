# <!--`T: 'a` inference in structs--> `T: 'a`構造体の推論

<!--An annotation in the form of `T: 'a`, where `T` is either a type or another lifetime, is called an *"outlives"* requirement.-->
`T: 'a`形式の注釈は、`T`がタイプまたは別の生涯のいずれかである場合、*「アウト*ライフ*」*要件と呼ばれます。
<!--Note that *"outlives"* also implies `'a: 'a`.-->
*「生存期間」*は`'a: 'a`意味することに注意してください。

<!--One way in which edition 2018 helps you out in maintaining flow when writing programs is by removing the need to explicitly annotate these `T: 'a` outlives requirements in `struct` definitions.-->
エディション2018を使用すると、プログラムを書くときにフローを維持することができます。これは、`struct`定義のTl `T: 'a` Outlives要件を明示的に注釈する必要を取り除くことによるものです。
<!--Instead, the requirements will be inferred from the fields present in the definitions.-->
代わりに、要件は定義に存在するフィールドから推定されます。

<!--Consider the following `struct` definitions in Rust 2015:-->
Rust 2015の次の`struct`定義を考えてみましょう：

```rust
#// Rust 2015
//  2015年の錆

struct Ref<'a, T: 'a> {
    field: &'a T
}

#// or written with a `where` clause:
// または`where`句で記述します。

struct WhereRef<'a, T> where T: 'a {
    data: &'a T
}

#// with nested references:
// ネストされた参照を持つ：

struct RefRef<'a, 'b: 'a, T: 'b> {
    field: &'a &'b T,
}

#// using an associated type:
// 関連する型を使用する：

struct ItemRef<'a, T: Iterator>
where
    T::Item: 'a
{
    field: &'a T::Item
}
```

<!--In Rust 2018, since the requirements are inferred, you can instead write:-->
Rust 2018では、要件が推測されるので、代わりに次のように書くことができます。

```rust,ignore
#// Rust 2018
// 錆2018

struct Ref<'a, T> {
    field: &'a T
}

struct WhereRef<'a, T> {
    data: &'a T
}

struct RefRef<'a, 'b, T> {
    field: &'a &'b T,
}

struct ItemRef<'a, T: Iterator> {
    field: &'a T::Item
}
```

<!--If you prefer to be more explicit in some cases, that is still possible.-->
場合によっては明示的にすることを好む場合は、それでも可能です。

## <!--More details--> 詳細

<!--For more details, see [the tracking issue](https://github.com/rust-lang/rust/issues/44493) and [the RFC](https://github.com/rust-lang/rfcs/pull/2093).-->
詳細については[、追跡の問題](https://github.com/rust-lang/rust/issues/44493)と[RFCを](https://github.com/rust-lang/rfcs/pull/2093)参照してください。
