# <!--Display--> 表示

<!--`fmt::Debug` hardly looks compact and clean, so it is often advantageous to customize the output appearance.-->
`fmt::Debug`はコンパクトでクリーンに見えにくいので、出力の外観をカスタマイズすることがしばしば役に立ちます。
<!--This is done by manually implementing [`fmt::Display`][fmt], which uses the `{}` print marker.-->
これは、`{}`印字マーカーを使用する[`fmt::Display`][fmt]手動で実装することによって行われます。
<!--Implementing it looks like this:-->
実装は次のようになります。

```rust
#// Import (via `use`) the `fmt` module to make it available.
//  `fmt`モジュールをインポートして（`use`） `use`可能にします。
use std::fmt;

#// Define a structure which `fmt::Display` will be implemented for. This is simply
#// a tuple struct containing an `i32` bound to the name `Structure`.
//  `fmt::Display`が実装される構造体を定義します。これは単にタプルの構造体である`i32`名前にバインドされた`Structure`。
struct Structure(i32);

#// In order to use the `{}` marker, the trait `fmt::Display` must be implemented
#// manually for the type.
//  `{}`マーカーを使用するには、`fmt::Display`の特性を型に対して手動で実装する必要があります。
impl fmt::Display for Structure {
#    // This trait requires `fmt` with this exact signature.
    // この特性は、この正確なシグネチャで`fmt`を必要とします。
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
#        // Write strictly the first element into the supplied output
#        // stream: `f`. Returns `fmt::Result` which indicates whether the
#        // operation succeeded or failed. Note that `write!` uses syntax which
#        // is very similar to `println!`.
        // 指定された出力ストリームに最初の要素を厳密に書き込みます`f`。操作が成功したか失敗したかを示す`fmt::Result`を返します。`write!`は`println!`とよく似た構文を使用することに注意してください。
        write!(f, "{}", self.0)
    }
}
```

<!--`fmt::Display` may be cleaner than `fmt::Debug` but this presents a problem for the `std` library.-->
`fmt::Display`は`fmt::Debug`よりもクリーンかもしれませんが、これは`std`ライブラリの問題です。
<!--How should ambiguous types be displayed?-->
どのようにあいまいなタイプを表示するべきですか？
<!--For example, if the `std` library implemented a single style for all `Vec<T>`, what style should it be?-->
たとえば、`std`ライブラリがすべての`Vec<T>`に対して単一のスタイルを実装した場合、どのようなスタイルにする必要がありますか？
<!--Either of these two?-->
これらの2つのどちらか？

* <!--`Vec<path>`: `/:/etc:/home/username:/bin` (split on `:`)-->
   `Vec<path>`： `/:/etc:/home/username:/bin`（上のスプリット`:`）
* <!--`Vec<number>`: `1,2,3` (split on `,`)-->
   `Vec<number>`： `1,2,3`（上のスプリット`,`）

<!--No, because there is no ideal style for all types and the `std` library doesn't presume to dictate one.-->
いいえ。すべてのタイプに理想的なスタイルはなく、`std`ライブラリはそれを指示するものではありません。
<!--`fmt::Display` is not implemented for `Vec<T>` or for any other generic containers.-->
`fmt::Display`は`Vec<T>`や他の汎用コンテナには実装されていません。
<!--`fmt::Debug` must then be used for these generic cases.-->
これらの一般的な場合には、`fmt::Debug`使用する必要があります。

<!--This is not a problem though because for any new *container* type which is *not* generic, `fmt::Display` can be implemented.-->
しかし、これは問題ではありません。なぜなら、汎用では*ない*新しい*コンテナ*型では、`fmt::Display`を実装できるからです。

```rust,editable
#//use std::fmt; // Import `fmt`
use std::fmt; // インポート`fmt`

#// A structure holding two numbers. `Debug` will be derived so the results can
#// be contrasted with `Display`.
//  2つの数字を持つ構造体。`Debug`が導出されるので、結果は`Display`と対比させることができます。
#[derive(Debug)]
struct MinMax(i64, i64);

#// Implement `Display` for `MinMax`.
//  `MinMax`ための`Display`を実装してください。
impl fmt::Display for MinMax {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
#        // Use `self.number` to refer to each positional data point.
        // 各位置データポイントを参照するには、`self.number`を使用します。
        write!(f, "({}, {})", self.0, self.1)
    }
}

#// Define a structure where the fields are nameable for comparison.
// 比較のために名前を付けることができる構造体を定義します。
#[derive(Debug)]
struct Point2D {
    x: f64,
    y: f64,
}

#// Similarly, implement for Point2D
// 同様に、Point2D
impl fmt::Display for Point2D {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
#        // Customize so only `x` and `y` are denoted.
        // カスタマイズすると、`x`と`y`だけが表示されます。
        write!(f, "x: {}, y: {}", self.x, self.y)
    }
}

fn main() {
    let minmax = MinMax(0, 14);

    println!("Compare structures:");
    println!("Display: {}", minmax);
    println!("Debug: {:?}", minmax);

    let big_range =   MinMax(-300, 300);
    let small_range = MinMax(-3, 3);

    println!("The big range is {big} and the small is {small}",
             small = small_range,
             big = big_range);

    let point = Point2D { x: 3.3, y: 7.2 };

    println!("Compare points:");
    println!("Display: {}", point);
    println!("Debug: {:?}", point);

#    // Error. Both `Debug` and `Display` were implemented but `{:b}`
#    // requires `fmt::Binary` to be implemented. This will not work.
#    // println!("What does Point2D look like in binary: {:b}?", point);
    // エラー。`Debug`と`Display`両方が実装されましたが、`{:b}`は`fmt::Binary`を実装する必要があります。これは動作しません。println！（"Point2Dはバイナリのように見える：{：b}？"、ポイント）;
}
```

<!--So, `fmt::Display` has been implemented but `fmt::Binary` has not, and therefore cannot be used.-->
したがって、`fmt::Display`は実装されていますが、`fmt::Binary`は実装されていないため、使用できません。
<!--`std::fmt` has many such [`traits`][traits] and each requires its own implementation.-->
`std::fmt`は多くのこのような[`traits`][traits]あり、それぞれ独自の実装が必要です。
<!--This is detailed further in [`std::fmt`][fmt].-->
これは[`std::fmt`][fmt]で詳しく説明しています。

### <!--Activity--> アクティビティ

<!--After checking the output of the above example, use the `Point2D` struct as guide to add a Complex struct to the example.-->
上記の例の出力を確認した後、`Point2D`構造体をガイドとして使用して、この例にComplex構造体を追加します。
<!--When printed in the same way, the output should be:-->
同じ方法で印刷すると、出力は次のようになります。

```txt
Display: 3.3 +7.2i
Debug: Complex { real: 3.3, imag: 7.2 }
```

### <!--See also--> も参照してください

<!--[`derive`][derive], [`std::fmt`][fmt], [macros], [`struct`][structs], [`trait`][traits], and [use][use]-->
[`derive`][derive]、 [`std::fmt`][fmt]、 [macros]、 [`struct`][structs]、 [`trait`][traits]、および[use][use]

<!--[derive]: trait/derive.html
 [fmt]: https://doc.rust-lang.org/std/fmt/
 [macros]: macros.html
 [structs]: custom_types/structs.html
 [traits]: trait.html
 [use]: mod/use.html
-->
[fmt]: https://doc.rust-lang.org/std/fmt/
 [macros]: macros.html
 [structs]: custom_types/structs.html
 [traits]: trait.html
 [derive]: trait/derive.html
 [use]: mod/use.html

