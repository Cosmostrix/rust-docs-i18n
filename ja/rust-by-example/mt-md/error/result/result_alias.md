# <!--aliases for `Result`--> `Result`エイリアス

<!--How about when we want to reuse a specific `Result` type many times?-->
特定の`Result`型を何回も再利用したいときはどうでしょうか？
<!--Recall that Rust allows us to create [aliases][typealias].-->
Rustは[aliases][typealias]を作成できることを思い出してください。
<!--Conveniently, we can define one for the specific `Result` in question.-->
好都合なことに、問題の特定の`Result`に対して1つを定義することができます。

<!--At a module level, creating aliases can be particularly helpful.-->
モジュールレベルでは、エイリアスを作成すると特に効果的です。
<!--Errors found in a specific module often have the same `Err` type, so a single alias can succinctly define *all* associated `Results`.-->
特定のモジュールで見つかったエラーは、同じ`Err`タイプを持つことが多いため、単一のエイリアスで*すべての*関連する`Results`簡潔に定義できます。
<!--This is so useful that the `std` library even supplies one: [`io::Result`][io_result]!-->
これは非常に便利なので、`std`ライブラリは[`io::Result`][io_result]！

<!--Here's a quick example to show off the syntax:-->
構文を示す簡単な例を次に示します。

```rust,editable
use std::num::ParseIntError;

#// Define a generic alias for a `Result` with the error type `ParseIntError`.
// エラータイプ`ParseIntError`を持つ`Result`ジェネリックエイリアスを定義します。
type AliasedResult<T> = Result<T, ParseIntError>;

#// Use the above alias to refer to our specific `Result` type.
// 特定の`Result`型を参照するには、上記の別名を使用します。
fn multiply(first_number_str: &str, second_number_str: &str) -> AliasedResult<i32> {
    first_number_str.parse::<i32>().and_then(|first_number| {
        second_number_str.parse::<i32>().map(|second_number| first_number * second_number)
    })
}

#// Here, the alias again allows us to save some space.
// ここで、もう一度エイリアスを使用すると、スペースを節約できます。
fn print(result: AliasedResult<i32>) {
    match result {
        Ok(n)  => println!("n is {}", n),
        Err(e) => println!("Error: {}", e),
    }
}

fn main() {
    print(multiply("10", "2"));
    print(multiply("t", "2"));
}
```

### <!--See also:--> 参照：

[`io::Result`][io_result]
<!--[typealias]: types/alias.html
 [io_result]: https://doc.rust-lang.org/std/io/type.Result.html
-->
[typealias]: types/alias.html
 [io_result]: https://doc.rust-lang.org/std/io/type.Result.html

