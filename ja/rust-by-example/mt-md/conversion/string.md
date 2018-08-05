# <!--To and from Strings--> 文字列とのやりとり

## `ToString`
<!--To convert any type to a `String` it is as simple as implementing the [`ToString`] trait for the type.-->
任意の型を`String`変換するには、型の[`ToString`]特性を実装するのと同じくらい簡単です。

```rust,editable
use std::string::ToString;

struct Circle {
    radius: i32
}

impl ToString for Circle {
    fn to_string(&self) -> String {
        format!("Circle of radius {:?}", self.radius)
    }
}

fn main() {
    let circle = Circle { radius: 6 };
    println!("{}", circle.to_string());
}
```

## <!--Parsing a String--> 文字列の解析

<!--One of the more common types to convert a string into is a number.-->
文字列を変換する一般的な型の1つが数値です。
<!--The idiomatic approach to this is to use the [`parse`] function and provide the type for the function to parse the string value into, this can be done either without type inference or using the 'turbofish' syntax.-->
これに対する慣用的なアプローチは、[`parse`]関数を使用して文字列値を解析する関数の型を提供することです。これは、型推論なしで、または 'turbofish'構文を使用して行うことができます。

<!--This will convert the string into the type specified so long as the [`FromStr`] trait is implemented for that type.-->
これは、[`FromStr`]特性がその型に対して実装されている限り、指定された型に文字列を変換します。
<!--This is implemented for numerous types within the standard library.-->
これは、標準ライブラリ内の多くの型に対して実装されています。
<!--To obtain this functionality on a user defined type simply implement the [`FromStr`] trait for that type.-->
ユーザ定義型でこの機能を得るには、その型の[`FromStr`]特性を実装するだけです。

```rust
fn main() {
    let parsed: i32 = "5".parse().unwrap();
    let turbo_parsed = "10".parse::<i32>().unwrap();

    let sum = parsed + turbo_parsed;
    println!{"Sum: {:?}", sum};
}
```

<!--[`ToString`]: https://doc.rust-lang.org/std/string/trait.ToString.html
 [`parse`]: https://doc.rust-lang.org/std/primitive.str.html#method.parse
 [`FromStr`]: https://doc.rust-lang.org/std/str/trait.FromStr.html
-->
[`ToString`]: https://doc.rust-lang.org/std/string/trait.ToString.html
 [`parse`]: https://doc.rust-lang.org/std/primitive.str.html#method.parse
 [`FromStr`]: https://doc.rust-lang.org/std/str/trait.FromStr.html

