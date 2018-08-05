# <!--Aliasing--> エイリアス

<!--The `type` statement can be used to give a new name to an existing type.-->
`type`ステートメントを使用すると、既存のタイプに新しい名前を付けることができます。
<!--Types must have `CamelCase` names, or the compiler will raise a warning.-->
型には`CamelCase`名前が必要です。そうしないと、コンパイラによって警告が発生します。
<!--The exception to this rule are the primitive types: `usize`, `f32`, etc.-->
このルールの例外は、プリミティブ型`usize`、 `f32`などです。

```rust,editable
#// `NanoSecond` is a new name for `u64`.
//  `NanoSecond`のための新しい名前です`u64`。
type NanoSecond = u64;
type Inch = u64;

#// Use an attribute to silence warning.
// アトリビュートを使用して警告を消す。
#[allow(non_camel_case_types)]
type u64_t = u64;
#// TODO ^ Try removing the attribute
//  TODO ^属性を削除してみる

fn main() {
#    // `NanoSecond` = `Inch` = `u64_t` = `u64`.
    //  `NanoSecond` = `Inch` = `u64_t` = `u64`。
    let nanoseconds: NanoSecond = 5 as u64_t;
    let inches: Inch = 2 as u64_t;

#    // Note that type aliases *don't* provide any extra type safety, because
#    // aliases are *not* new types
    // エイリアスは新しい型では*ない*ので、型エイリアス*は*余分な型の安全性を提供*しない*ことに注意してください
    println!("{} nanoseconds + {} inches = {} unit?",
             nanoseconds,
             inches,
             nanoseconds + inches);
}
```

<!--The main use of aliases is to reduce boilerplate;-->
エイリアスの主な用途は定型文を減らすことです。
<!--for example the `IoResult<T>` type is an alias for the `Result<T, IoError>` type.-->
たとえば、`IoResult<T>`型は`Result<T, IoError>`型の別名です。

### <!--See also:--> 参照：

[Attributes](attribute.html)