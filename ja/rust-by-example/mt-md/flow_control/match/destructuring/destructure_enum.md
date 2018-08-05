# <!--enums--> 列挙型

<!--An `enum` is destructured similarly:-->
`enum`も同様に破棄されます。

```rust,editable
#// `allow` required to silence warnings because only
#// one variant is used.
//  `allow`唯一のバリアントが使用されているので、警告を黙らせる必要がありました。
#[allow(dead_code)]
enum Color {
#    // These 3 are specified solely by their name.
    // これらの3は、その名前によってのみ指定されます。
    Red,
    Blue,
    Green,
#    // These likewise tie `u32` tuples to different names: color models.
    // これらは同様に`u32`タプルを色々な名前に結びつけます：カラーモデル。
    RGB(u32, u32, u32),
    HSV(u32, u32, u32),
    HSL(u32, u32, u32),
    CMY(u32, u32, u32),
    CMYK(u32, u32, u32, u32),
}

fn main() {
    let color = Color::RGB(122, 17, 40);
#    // TODO ^ Try different variants for `color`
    //  TODO ^さまざまな`color`試してみてください

    println!("What color is it?");
#    // An `enum` can be destructured using a `match`.
    //  `enum`は`match`を使用して非構造化することができます。
    match color {
        Color::Red   => println!("The color is Red!"),
        Color::Blue  => println!("The color is Blue!"),
        Color::Green => println!("The color is Green!"),
        Color::RGB(r, g, b) =>
            println!("Red: {}, green: {}, and blue: {}!", r, g, b),
        Color::HSV(h, s, v) =>
            println!("Hue: {}, saturation: {}, value: {}!", h, s, v),
        Color::HSL(h, s, l) =>
            println!("Hue: {}, saturation: {}, lightness: {}!", h, s, l),
        Color::CMY(c, m, y) =>
            println!("Cyan: {}, magenta: {}, yellow: {}!", c, m, y),
        Color::CMYK(c, m, y, k) =>
            println!("Cyan: {}, magenta: {}, yellow: {}, key (black): {}!",
                c, m, y, k),
#        // Don't need another arm because all variants have been examined
        // すべての亜種が検査されているので別の腕は必要ありません
    }
}
```

### <!--See also:--> 参照：

<!--[`#[allow(...)]`][allow], [color models][color_models] and [`enum`][enum]-->
[`#[allow(...)]`][allow]、 [カラーモデル][color_models]と[`enum`][enum]

<!--[allow]: attribute/unused.html
 [color_models]: https://en.wikipedia.org/wiki/Color_model
 [enum]: custom_types/enum.html
-->
[color_models]: https://en.wikipedia.org/wiki/Color_model
 [enum]: custom_types/enum.html
 [allow]: attribute/unused.html

