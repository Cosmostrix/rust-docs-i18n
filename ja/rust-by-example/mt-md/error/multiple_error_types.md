# <!--Multiple error types--> 複数のエラータイプ

<!--The previous examples have always been very convenient;-->
これまでの例は、常に非常に便利でした。
<!--`Result` s interact with other `Result` s and `Option` s interact with other `Option` s.-->
`Result`は他の`Result`と相互作用し、`Option`は他の`Option`と相互作用する。

<!--Sometimes an `Option` needs to interact with a `Result`, or a `Result<T, Error1>` needs to interact with a `Result<T, Error2>`.-->
時には`Option`と対話する必要`Result`、または`Result<T, Error1>`と対話する必要が`Result<T, Error2>`
<!--In those cases, we want to manage our different error types in a way that makes them composable and easy to interact with.-->
そのような場合、我々は異なるエラータイプを、それらを構成可能で相互作用しやすい方法で管理したいと考えています。

<!--In the following code, two instances of `unwrap` generate different error types.-->
次のコードでは、`unwrap` 2つのインスタンスが異なるエラータイプを生成します。
<!--`Vec::first` returns an `Option`, while `parse::<i32>` returns a `Result<i32, ParseIntError>`:-->
`Vec::first`は`Option`返し、`parse::<i32>`は`Result<i32, ParseIntError>`返します。

```rust,editable,ignore,mdbook-runnable
fn double_first(vec: Vec<&str>) -> i32 {
#//    let first = vec.first().unwrap(); // Generate error 1
    let first = vec.first().unwrap(); // エラー1を生成する
#//    2 * first.parse::<i32>().unwrap() // Generate error 2
    2 * first.parse::<i32>().unwrap() // エラー2を生成する
}

fn main() {
    let numbers = vec!["42", "93", "18"];
    let empty = vec![];
    let strings = vec!["tofu", "93", "18"];

    println!("The first doubled is {}", double_first(numbers));

    println!("The first doubled is {}", double_first(empty));
#    // Error 1: the input vector is empty
    // エラー1：入力ベクトルが空です

    println!("The first doubled is {}", double_first(strings));
#    // Error 2: the element doesn't parse to a number
    // エラー2：要素は数値に解析されません
}
```

<!--Over the next sections, we'll see several strategies for handling these kind of problems.-->
次のセクションでは、これらの問題を処理するための戦略をいくつか見ていきます。
