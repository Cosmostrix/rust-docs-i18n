# <!--`From` and `Into`--> `From` `Into`

<!--The [`From`] and [`Into`] traits are inherently linked, and this is actually part of its implementation.-->
[`From`]と[`Into`]特性は本質的にリンクされており、実際にはその実装の一部です。
<!--If you are able to convert type A from type B, then it should be easy to believe that we should be able to convert type B to type A.-->
タイプAをタイプBから変換できる場合は、タイプBをタイプAに変換できるはずです。

## `From`
<!--The [`From`] trait allows for a type to define how to create itself from another type, hence providing a very simple mechanism for converting between several types.-->
[`From`]特性は、型が他の型からそれ自身を作成する方法を定義することを可能にし、したがって、いくつかの型間で変換するための非常に簡単なメカニズムを提供します。
<!--There are numerous implementations of this trait within the standard library for conversion of primitive and common types.-->
プリミティブ型と共通型の変換のために、標準ライブラリ内にこの特性の実装が数多くあります。

<!--For example we can easily convert a `str` into a `String`-->
たとえば、`str`を`String`簡単に変換でき`str`

```rust
let my_str = "hello";
let my_string = String::from(my_str);
```

<!--We can do similar for defining a conversion for our own type.-->
独自のタイプのコンバージョンを定義する場合も同様です。

```rust,editable
use std::convert::From;

#[derive(Debug)]
struct Number {
    value: i32,
}

impl From<i32> for Number {
    fn from(item: i32) -> Self {
        Number { value: item }
    }
}

fn main() {
    let num = Number::from(30);
    println!("My number is {:?}", num);
}
```

## `Into`
<!--The [`Into`] trait is simply the reciprocal of the `From` trait.-->
[`Into`]形質は単に`From`形質の逆数である。
<!--That is, if you have implemented the `From` trait for your type you get the `Into` implementation for free.-->
つまり、あなたのタイプの`From`特性を実装していれば、`Into`実装を無料で入手できます。

<!--Using the `Into` trait will typically require specification of the type to convert into as the compiler is unable to determine this most of the time.-->
`Into`特性を使用すると、通常、コンパイラがこの時間の大部分を判断できないため、変換する型の指定が必要になります。
<!--However this is a small trade-off considering we get the functionality for free.-->
しかし、私たちが無料で機能を提供することを考えると、これは小さなトレードオフです。

```rust,editable
use std::convert::From;

#[derive(Debug)]
struct Number {
    value: i32,
}

impl From<i32> for Number {
    fn from(item: i32) -> Self {
        Number { value: item }
    }
}

fn main() {
    let int = 5;
#    // Try removing the type declaration
    // 型宣言を削除してみてください
    let num: Number = int.into();
    println!("My number is {:?}", num);
}
```

<!--[`From`]: https://doc.rust-lang.org/std/convert/trait.From.html
 [`Into`]: https://doc.rust-lang.org/std/convert/trait.Into.html
-->
[`From`]: https://doc.rust-lang.org/std/convert/trait.From.html
 [`Into`]: https://doc.rust-lang.org/std/convert/trait.Into.html

