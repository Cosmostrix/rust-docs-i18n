# <!--`map` for `Result`--> `Result` `map`

<!--Panicking in the previous example's `multiply` does not make for robust code.-->
前の例の中でパニック`multiply`堅牢なコードを作成しません。
<!--Generally, we want to return the error to the caller so it can decide what is the right way to respond to errors.-->
一般的に、エラーを呼び出し側に返して、エラーに応答する正しい方法が何であるかを判断する必要があります。

<!--We first need to know what kind of error type we are dealing with.-->
まず、どのような種類のエラーを処理しているのかを知る必要があります。
<!--To determine the `Err` type, we look to [`parse()`][parse], which is implemented with the [`FromStr`][from_str] trait for [`i32`][i32].-->
`Err`型を判別するために、[`i32`][i32] [`FromStr`][from_str]特性で実装されている[`parse()`][parse]を調べます。
<!--As a result, the `Err` type is specified as [`ParseIntError`][parse_int_error].-->
その結果、`Err`型は[`ParseIntError`][parse_int_error]として指定されます。

<!--In the example below, the straightforward `match` statement leads to code that is overall more cumbersome.-->
以下の例では、単純な`match`ステートメントは、全体的に面倒なコードにつながります。

```rust,editable
use std::num::ParseIntError;

#// With the return type rewritten, we use pattern matching without `unwrap()`.
// 戻り値の型を書き換えると、`unwrap()`使わないパターンマッチングが使用されます。
fn multiply(first_number_str: &str, second_number_str: &str) -> Result<i32, ParseIntError> {
    match first_number_str.parse::<i32>() {
        Ok(first_number)  => {
            match second_number_str.parse::<i32>() {
                Ok(second_number)  => {
                    Ok(first_number * second_number)
                },
                Err(e) => Err(e),
            }
        },
        Err(e) => Err(e),
    }
}

fn print(result: Result<i32, ParseIntError>) {
    match result {
        Ok(n)  => println!("n is {}", n),
        Err(e) => println!("Error: {}", e),
    }
}

fn main() {
#    // This still presents a reasonable answer.
    // これはまだ合理的な答えを提示します。
    let twenty = multiply("10", "2");
    print(twenty);

#    // The following now provides a much more helpful error message.
    // 次のように、より有用なエラーメッセージが表示されます。
    let tt = multiply("t", "2");
    print(tt);
}
```

<!--Luckily, `Option` 's `map`, `and_then`, and many other combinators are also implemented for `Result`.-->
幸いなことに、`Option`の`map`、 `and_then`、および他の多くのコンビネータも`Result`ために実装されています。
<!--[`Result`][result] contains a complete listing.-->
[`Result`][result]には完全なリストが含まれています。

```rust,editable
use std::num::ParseIntError;

#// As with `Option`, we can use combinators such as `map()`.
#// This function is otherwise identical to the one above and reads:
#// Modify n if the value is valid, otherwise pass on the error.
//  `Option`と同様に、`map()`などのコンビネータも使用できます。この関数は、それ以外は上記と同じです。値が有効な場合はnを修正し、そうでない場合はエラーを渡します。
fn multiply(first_number_str: &str, second_number_str: &str) -> Result<i32, ParseIntError> {
    first_number_str.parse::<i32>().and_then(|first_number| {
        second_number_str.parse::<i32>().map(|second_number| first_number * second_number)
    })
}

fn print(result: Result<i32, ParseIntError>) {
    match result {
        Ok(n)  => println!("n is {}", n),
        Err(e) => println!("Error: {}", e),
    }
}

fn main() {
#    // This still presents a reasonable answer.
    // これはまだ合理的な答えを提示します。
    let twenty = multiply("10", "2");
    print(twenty);

#    // The following now provides a much more helpful error message.
    // 次のように、より有用なエラーメッセージが表示されます。
    let tt = multiply("t", "2");
    print(tt);
}
```

<!--[parse]: https://doc.rust-lang.org/std/primitive.str.html#method.parse
 [from_str]: https://doc.rust-lang.org/std/str/trait.FromStr.html
 [i32]: https://doc.rust-lang.org/std/primitive.i32.html
 [parse_int_error]: https://doc.rust-lang.org/std/num/struct.ParseIntError.html
 [result]: https://doc.rust-lang.org/std/result/enum.Result.html
-->
[parse]: https://doc.rust-lang.org/std/primitive.str.html#method.parse
 [from_str]: https://doc.rust-lang.org/std/str/trait.FromStr.html
 [i32]: https://doc.rust-lang.org/std/primitive.i32.html
 [parse_int_error]: https://doc.rust-lang.org/std/num/struct.ParseIntError.html
 [result]: https://doc.rust-lang.org/std/result/enum.Result.html

