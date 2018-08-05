# <!--Enums--> 列挙型

<!--The `enum` keyword allows the creation of a type which may be one of a few different variants.-->
`enum`キーワードは、いくつかの異なる亜種のうちの1つであるかもしれないタイプの作成を可能にします。
<!--Any variant which is valid as a `struct` is also valid as an `enum`.-->
`struct`として有効なバリアントも`enum`として有効です。

```rust,editable
#// An attribute to hide warnings for unused code.
// 未使用コードの警告を隠す属性。
#![allow(dead_code)]

#// Create an `enum` to classify a web event. Note how both
#// names and type information together specify the variant:
#// `PageLoad != PageUnload` and `KeyPress(char) != Paste(String)`.
#// Each is different and independent.
//  Webイベントを分類する`enum`を作成します。名前と型情報の両方がバリアントをどのように指定するかに注意してください`PageLoad != PageUnload`と`KeyPress(char) != Paste(String)`。それぞれ異なる、独立しています。
enum WebEvent {
#    // An `enum` may either be `unit-like`,
    //  `enum`は、`unit-like`、
    PageLoad,
    PageUnload,
#    // like tuple structs,
    // タプル構造体のように、
    KeyPress(char),
    Paste(String),
#    // or like structures.
    // または同様の構造を有する。
    Click { x: i64, y: i64 },
}

#// A function which takes a `WebEvent` enum as an argument and
#// returns nothing.
//  `WebEvent` enumを引数としてとり、何も返さない関数。
fn inspect(event: WebEvent) {
    match event {
        WebEvent::PageLoad => println!("page loaded"),
        WebEvent::PageUnload => println!("page unloaded"),
#        // Destructure `c` from inside the `enum`.
        // エニュムの内側から`c`を`enum`ます。
        WebEvent::KeyPress(c) => println!("pressed '{}'.", c),
        WebEvent::Paste(s) => println!("pasted \"{}\".", s),
#        // Destructure `Click` into `x` and `y`.
        //  Destructure `x`と`y` `Click`します。
        WebEvent::Click { x, y } => {
            println!("clicked at x={}, y={}.", x, y);
        },
    }
}

fn main() {
    let pressed = WebEvent::KeyPress('x');
#    // `to_owned()` creates an owned `String` from a string slice.
    //  `to_owned()`は、文字列sliceから所有する`String`を作成します。
    let pasted  = WebEvent::Paste("my text".to_owned());
    let click   = WebEvent::Click { x: 20, y: 80 };
    let load    = WebEvent::PageLoad;
    let unload  = WebEvent::PageUnload;

    inspect(pressed);
    inspect(pasted);
    inspect(click);
    inspect(load);
    inspect(unload);
}

```

### <!--See also:--> 参照：

<!--[`attributes`][attributes], [`match`][match], [`fn`][fn], and [`String`][str]-->
[`attributes`][attributes]、 [`match`][match]、 [`fn`][fn]、および[`String`][str]

<!--[attributes]: attribute.html
 [c_struct]: https://en.wikipedia.org/wiki/Struct_(C_programming_language)
 [match]: flow_control/match.html
 [fn]: fn.html
 [str]: std/str.html
-->
[attributes]: attribute.html
 [c_struct]: https://en.wikipedia.org/wiki/Struct_(C_programming_language)
 [match]: flow_control/match.html
 [fn]: fn.html
 [str]: std/str.html

