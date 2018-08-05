# `Option`
<!--Sometimes it's desirable to catch the failure of some parts of a program instead of calling `panic!`;-->
時には`panic!`を呼び出すのではなく、プログラムの一部の失敗をキャッチすることが望ましい場合もあります。
<!--this can be accomplished using the `Option` enum.-->
`Option` enumを使用してこれを行うことができます。

<!--The `Option<T>` enum has two variants:-->
`Option<T>`列挙型には2つのバリエーションがあります：

* <!--`None`, to indicate failure or lack of value, and-->
   `None`障害または値の欠如を示すために、そして
* <!--`Some(value)`, a tuple struct that wraps a `value` with type `T`.-->
   `Some(value)`、 `T`型の`value`をラップするタプル構造体。

```rust,editable,ignore,mdbook-runnable
#// An integer division that doesn't `panic!`
//  `panic!`ならない整数除算
fn checked_division(dividend: i32, divisor: i32) -> Option<i32> {
    if divisor == 0 {
#        // Failure is represented as the `None` variant
        // 障害は、[ `None`バリアントとして表されます。
        None
    } else {
#        // Result is wrapped in a `Some` variant
        // 結果は`Some`亜種に包まれています
        Some(dividend / divisor)
    }
}

#// This function handles a division that may not succeed
// この関数は、成功しない可能性のある除算を処理します。
fn try_division(dividend: i32, divisor: i32) {
#    // `Option` values can be pattern matched, just like other enums
    //  `Option`値は他の列挙型と同様にパターンマッチングできます
    match checked_division(dividend, divisor) {
        None => println!("{} / {} failed!", dividend, divisor),
        Some(quotient) => {
            println!("{} / {} = {}", dividend, divisor, quotient)
        },
    }
}

fn main() {
    try_division(4, 2);
    try_division(1, 0);

#    // Binding `None` to a variable needs to be type annotated
    // 変数へのバインディング`None`型の注釈を付ける必要があります
    let none: Option<i32> = None;
    let _equivalent_none = None::<i32>;

    let optional_float = Some(0f32);

#    // Unwrapping a `Some` variant will extract the value wrapped.
    // アンラップ`Some`の変異体は、包まれた値を抽出します。
    println!("{:?} unwraps to {:?}", optional_float, optional_float.unwrap());

#    // Unwrapping a `None` variant will `panic!`
    // アンラップ`None`バリアントはなり`panic!`
    println!("{:?} unwraps to {:?}", none, none.unwrap());
}
```
