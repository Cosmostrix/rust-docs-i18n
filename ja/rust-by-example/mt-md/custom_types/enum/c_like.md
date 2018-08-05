# <!--C-like--> Cのような

<!--`enum` can also be used as C-like enums.-->
`enum`はCのようなenumとしても使用できます。

```rust,editable
#// An attribute to hide warnings for unused code.
// 未使用コードの警告を隠す属性。
#![allow(dead_code)]

#// enum with implicit discriminator (starts at 0)
// 暗黙的な弁別子を持つ列挙型（0から始まる）
enum Number {
    Zero,
    One,
    Two,
}

#// enum with explicit discriminator
// 明示的な弁別子で列挙する
enum Color {
    Red = 0xff0000,
    Green = 0x00ff00,
    Blue = 0x0000ff,
}

fn main() {
#    // `enums` can be cast as integers.
    //  `enums`は整数としてキャストできます。
    println!("zero is {}", Number::Zero as i32);
    println!("one is {}", Number::One as i32);

    println!("roses are #{:06x}", Color::Red as i32);
    println!("violets are #{:06x}", Color::Blue as i32);
}
```

### <!--See also:--> 参照：

[casting][cast]
[cast]: types/cast.html
