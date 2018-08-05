# <!--Iterating over `Result` s--> `Result`反復する

<!--An `Iter::map` operation might fail, for example:-->
`Iter::map`操作が失敗する可能性があります。たとえば、次のようになります。

```rust,editable
fn main() {
    let strings = vec!["tofu", "93", "18"];
    let possible_numbers: Vec<_> = strings
        .into_iter()
        .map(|s| s.parse::<i32>())
        .collect();
    println!("Results: {:?}", possible_numbers);
}
```

<!--Let's step through strategies for handling this.-->
これを処理するための戦略を進めましょう。

## <!--Ignore the failed items with `filter_map()`--> `filter_map()`失敗した項目を無視する

<!--`filter_map` calls a function and filters out the results that are `None`.-->
`filter_map`は関数を呼び出し、`None`結果をフィルタリングします。

```rust,editable
fn main() {
    let strings = vec!["tofu", "93", "18"];
    let numbers: Vec<_> = strings
        .into_iter()
        .map(|s| s.parse::<i32>())
        .filter_map(Result::ok)
        .collect();
    println!("Results: {:?}", numbers);
}
```

## <!--Fail the entire operation with `collect()`--> `collect()`操作全体を失敗させる

<!--`Result` implements `FromIter` so that a vector of results (`Vec<Result<T, E>>`) can be turned into a result with a vector (`Result<Vec<T>, E>`).-->
`Result`は、結果のベクトル（`Vec<Result<T, E>>`）をベクトル（ `Result<Vec<T>, E>`）で結果に変換できるように`FromIter`実装します。
<!--Once an `Result::Err` is found, the iteration will terminate.-->
`Result::Err`が見つかると、繰り返しは終了します。

```rust,editable
fn main() {
    let strings = vec!["tofu", "93", "18"];
    let numbers: Result<Vec<_>, _> = strings
        .into_iter()
        .map(|s| s.parse::<i32>())
        .collect();
    println!("Results: {:?}", numbers);
}
```

<!--This same technique can be used with `Option`.-->
これと同じ手法を`Option`で使用できます。

## <!--Collect all valid values and failures with `partition()`--> `partition()`ですべての有効な値と失敗を収集する

```rust,editable
fn main() {
    let strings = vec!["tofu", "93", "18"];
    let (numbers, errors): (Vec<_>, Vec<_>) = strings
        .into_iter()
        .map(|s| s.parse::<i32>())
        .partition(Result::is_ok);
    println!("Numbers: {:?}", numbers);
    println!("Errors: {:?}", errors);
}
```

<!--When you look at the results, you'll note that everything is still wrapped in `Result`.-->
結果を見ると、すべてがまだ`Result`ラップされていることに気付くでしょう。
<!--A little more boilerplate is needed for this.-->
これにはもう少しの定型文が必要です。

```rust,editable
fn main() {
    let strings = vec!["tofu", "93", "18"];
    let (numbers, errors): (Vec<_>, Vec<_>) = strings
        .into_iter()
        .map(|s| s.parse::<i32>())
        .partition(Result::is_ok);
    let numbers: Vec<_> = numbers.into_iter().map(Result::unwrap).collect();
    let errors: Vec<_> = errors.into_iter().map(Result::unwrap_err).collect();
    println!("Numbers: {:?}", numbers);
    println!("Errors: {:?}", errors);
}
```
