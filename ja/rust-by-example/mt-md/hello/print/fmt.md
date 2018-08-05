# <!--Formatting--> 書式設定

<!--We've seen that formatting is specified via a *format string*:-->
書式設定は*書式文字列で*指定されてい*ます*。

* <!--`format!("{}", foo)` -> `"3735928559"`-->
   `format!("{}", foo)` -> `"3735928559"`
* <!--`format!("0x{:X}", foo)` -> [`"0xDEADBEEF"`][deadbeef]-->
   `format!("0x{:X}", foo)` -> [`"0xDEADBEEF"`][deadbeef]
* <!--`format!("0o{:o}", foo)` -> `"0o33653337357"`-->
   `format!("0o{:o}", foo)` -> `"0o33653337357"`

<!--The same variable (`foo`) can be formatted differently depending on which *argument type* is used: `X` vs `o` vs *unspecified*.-->
同じ変数（`foo`）は、どの*引数型*が使われている*かに*応じて異なったフォーマットにすることができます： `X` vs `o` vs *unspecified*。

<!--This formatting functionality is implemented via traits, and there is one trait for each argument type.-->
この書式設定機能は、特性を使用して実装され、各引数タイプごとに1つの特性があります。
<!--The most common formatting trait is `Display`, which handles cases where the argument type is left unspecified: `{}` for instance.-->
最も一般的な書式設定の特性は`Display`。これは、引数の型が指定されていない場合（ `{}`を処理します。

```rust,editable
use std::fmt::{self, Formatter, Display};

struct City {
    name: &'static str,
#    // Latitude
    // 緯度
    lat: f32,
#    // Longitude
    // 経度
    lon: f32,
}

impl Display for City {
#    // `f` is a buffer, this method must write the formatted string into it
    //  `f`はバッファです。このメソッドは、書式設定された文字列をバッファに書き込む必要があります
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        let lat_c = if self.lat >= 0.0 { 'N' } else { 'S' };
        let lon_c = if self.lon >= 0.0 { 'E' } else { 'W' };

#        // `write!` is like `format!`, but it will write the formatted string
#        // into a buffer (the first argument)
        //  `write!`と同じ`format!`が、フォーマットされた文字列をバッファに書き出します（最初の引数）
        write!(f, "{}: {:.3}°{} {:.3}°{}",
               self.name, self.lat.abs(), lat_c, self.lon.abs(), lon_c)
    }
}

#[derive(Debug)]
struct Color {
    red: u8,
    green: u8,
    blue: u8,
}

fn main() {
    for city in [
        City { name: "Dublin", lat: 53.347778, lon: -6.259722 },
        City { name: "Oslo", lat: 59.95, lon: 10.75 },
        City { name: "Vancouver", lat: 49.25, lon: -123.1 },
    ].iter() {
        println!("{}", *city);
    }
    for color in [
        Color { red: 128, green: 255, blue: 90 },
        Color { red: 0, green: 3, blue: 254 },
        Color { red: 0, green: 0, blue: 0 },
    ].iter() {
#        // Switch this to use {} once you've added an implementation
#        // for fmt::Display
        //  fmt:: Displayの実装を追加したら、これを{}を使用するように切り替えます
        println!("{:?}", *color);
    }
}
```

<!--You can view a [full list of formatting traits][fmt_traits] and their argument types in the [`std::fmt`][fmt] documentation.-->
[書式設定の特性][fmt_traits]とその引数の種類の[完全な一覧は][fmt_traits]、 [`std::fmt`][fmt]ドキュメントを参照してください。

### <!--Activity--> アクティビティ
<!--Add an implementation of the `fmt::Display` trait for the `Color` struct above so that the output displays as:-->
出力が次のように表示されるように、上記の`Color`構造体の`fmt::Display`特性の実装を追加します。

```text
RGB (128, 255, 90) 0x80FF5A
RGB (0, 3, 254) 0x0003FE
RGB (0, 0, 0) 0x000000
```

<!--Two hints if you get stuck: * You [may need to list each color more than once][argument_types], * You can [pad with zeros to a width of 2][fmt_width] with `:02`.-->
2つのヒント：あなた[は、各色を2回以上列記する必要][argument_types]がある[かもしれ][argument_types]ません。* `:02` [幅2の0を塗りつぶす][fmt_width]ことができます。

### <!--See also--> も参照してください

[`std::fmt`][fmt]
<!--[argument_types]: https://doc.rust-lang.org/std/fmt/#argument-types
 [deadbeef]: https://en.wikipedia.org/wiki/Deadbeef#Magic_debug_values
 [fmt]: https://doc.rust-lang.org/std/fmt/
 [fmt_traits]: https://doc.rust-lang.org/std/fmt/#formatting-traits
 [fmt_width]: https://doc.rust-lang.org/std/fmt/#width
-->
[argument_types]: https://doc.rust-lang.org/std/fmt/#argument-types
 [deadbeef]: https://en.wikipedia.org/wiki/Deadbeef#Magic_debug_values
 [fmt]: https://doc.rust-lang.org/std/fmt/
 [fmt_traits]: https://doc.rust-lang.org/std/fmt/#formatting-traits
 [fmt_width]: https://doc.rust-lang.org/std/fmt/#width

