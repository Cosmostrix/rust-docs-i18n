# <!--Debug--> デバッグ

<!--All types which want to use `std::fmt` formatting `traits` require an implementation to be printable.-->
`std::fmt`書式設定`traits`を使用するすべての型では、実装が印刷可能である必要があります。
<!--Automatic implementations are only provided for types such as in the `std` library.-->
自動実装は、`std`ライブラリなどの型に対してのみ提供されます。
<!--All others *must* be manually implemented somehow.-->
その他のもの*は*何とか手動で実装する*必要*が*あり*ます。

<!--The `fmt::Debug` `trait` makes this very straightforward.-->
`fmt::Debug` `trait`はこれを非常に簡単にします。
<!--*All* types can `derive` (automatically create) the `fmt::Debug` implementation.-->
*すべての*型は`fmt::Debug`実装を`derive`（自動的に作成）でき`derive`。
<!--This is not true for `fmt::Display` which must be manually implemented.-->
手動で実装する必要がある`fmt::Display`、これは当てはまりません。

```rust
#// This structure cannot be printed either with `fmt::Display` or
#// with `fmt::Debug`
// この構造体は、`fmt::Display`または`fmt::Debug`どちらでも印刷できません
struct UnPrintable(i32);

#// The `derive` attribute automatically creates the implementation
#// required to make this `struct` printable with `fmt::Debug`.
//  `derive`属性は、この`struct`を`fmt::Debug`印刷可能にするために必要な実装を自動的に作成します。
#[derive(Debug)]
struct DebugPrintable(i32);
```

<!--All `std` library types automatically are printable with `{:?}` too:-->
すべての`std`ライブラリタイプは自動的に`{:?}`印刷可能`{:?}`：

```rust,editable
#// Derive the `fmt::Debug` implementation for `Structure`. `Structure`
#// is a structure which contains a single `i32`.
//  `Structure` `fmt::Debug`実装を導出します。`Structure`は、単一の`i32`を含む構造体です。
#[derive(Debug)]
struct Structure(i32);

#// Put a `Structure` inside of the structure `Deep`. Make it printable
#// also.
// 置く`Structure`構造体の内側に`Deep`。印刷可能にする。
#[derive(Debug)]
struct Deep(Structure);

fn main() {
#    // Printing with `{:?}` is similar to with `{}`.
    // で印刷する`{:?}`と同様です`{}`
    println!("{:?} months in a year.", 12);
    println!("{1:?} {0:?} is the {actor:?} name.",
             "Slater",
             "Christian",
             actor="actor's");

#    // `Structure` is printable!
    //  `Structure`は印刷可能です！
    println!("Now {:?} will print!", Structure(3));
    
#    // The problem with `derive` is there is no control over how
#    // the results look. What if I want this to just show a `7`?
    //  `derive`問題は、結果の見方を制御できないことです。これで`7`表示したいのですが？
    println!("Now {:?} will print!", Deep(Structure(7)));
}
```

<!--So `fmt::Debug` definitely makes this printable but sacrifices some elegance.-->
だから、`fmt::Debug`確実にこれを印刷可能にしますが、優雅さを犠牲にします。
<!--Rust also provides "pretty printing"with `{:#?}`.-->
錆は`{:#?}` 「きれいな印刷」を提供します。

```rust,editable
#[derive(Debug)]
struct Person<'a> {
    name: &'a str,
    age: u8
}

fn main() {
    let name = "Peter";
    let age = 27;
    let peter = Person { name, age };

#    // Pretty print
    // かなりプリント
    println!("{:#?}", peter);
}
```

<!--One can manually implement `fmt::Display` to control the display.-->
`fmt::Display`を手動で実装して、`fmt::Display`を制御することができます。

### <!--See also--> も参照してください

<!--[attributes][attributes], [`derive`][derive], [`std::fmt`][fmt], and [`struct`][structs]-->
[attributes][attributes]、 [`derive`][derive]、 [`std::fmt`][fmt]、 [`struct`][structs]

<!--[attributes]: https://doc.rust-lang.org/reference/attributes.html
 [derive]: trait/derive.html
 [fmt]: https://doc.rust-lang.org/std/fmt/
 [structs]: custom_types/structs.html
-->
[attributes]: https://doc.rust-lang.org/reference/attributes.html
 [derive]: trait/derive.html
 [fmt]: https://doc.rust-lang.org/std/fmt/
 [structs]: custom_types/structs.html
 [derive]: trait/derive.html
 [attributes]: https://doc.rust-lang.org/reference/attributes.html


