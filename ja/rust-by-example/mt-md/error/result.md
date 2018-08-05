# `Result`
<!--[`Result`][result] is a richer version of the [`Option`][option] type that describes possible *error* instead of possible *absence*.-->
[`Result`][result]は、*存在しない*可能性のある*エラーでは*なく可能性のある*エラー*を記述する[`Option`][option]タイプの豊富なバージョンです。

<!--That is, `Result<T, E>` could have one of two outcomes:-->
つまり、`Result<T, E>`は2つの結果のうちの1つを持つ可能性があります。

* <!--`Ok<T>`: An element `T` was found-->
   `Ok<T>`：要素`T`が見つかりました
* <!--`Err<E>`: An error was found with element `E`-->
   `Err<E>`：要素`E`エラーが見つかりました

<!--By convention, the expected outcome is `Ok` while the unexpected outcome is `Err`.-->
慣例により、予期される結果は`Err`が、期待される結果は`Ok`である。

<!--Like `Option`, `Result` has many methods associated with it.-->
`Option`と同様に、`Result`は多くのメソッドが関連付けられています。
<!--`unwrap()`, for example, either yields the element `T` or `panic` s.-->
たとえば、`unwrap()`は、要素`T`または`panic`生成します。
<!--For case handling, there are many combinators between `Result` and `Option` that overlap.-->
ケース処理のために、`Result`と`Option`間に重複する多くのコンビネータがあります。

<!--In working with Rust, you will likely encounter methods that return the `Result` type, such as the [`parse()`][parse] method.-->
Rustを操作する際には、[`parse()`][parse]メソッドなどの`Result`型を返すメソッドが発生する可能性があります。
<!--It might not always be possible to parse a string into the other type, so `parse()` returns a `Result` indicating possible failure.-->
文字列を他の型にパースすることは必ずしも可能ではない可能性があるので、`parse()`は失敗の可能性を示す`Result`を返します。

<!--Let's see what happens when we successfully and unsuccessfully `parse()` a string:-->
文字列を正常に`parse()`し、失敗したときに何が起こるかを見てみましょう。

```rust,editable,ignore,mdbook-runnable
fn multiply(first_number_str: &str, second_number_str: &str) -> i32 {
#    // Let's try using `unwrap()` to get the number out. Will it bite us?
    //  `unwrap()`を使って番号を取得しようとしましょう。それは私たちをかむでしょうか？
    let first_number = first_number_str.parse::<i32>().unwrap();
    let second_number = second_number_str.parse::<i32>().unwrap();
    first_number * second_number
}

fn main() {
    let twenty = multiply("10", "2");
    println!("double is {}", twenty);

    let tt = multiply("t", "2");
    println!("double is {}", tt);
}
```

<!--In the unsuccessful case, `parse()` leaves us with an error for `unwrap()` to `panic` on.-->
失敗した場合、`parse()`は`unwrap()`が`panic`というエラーを`unwrap()`ます。
<!--Additionally, the `panic` exits our program and provides an unpleasant error message.-->
さらに、`panic`がプログラムを終了し、不快なエラーメッセージが表示されます。

<!--To improve the quality of our error message, we should be more specific about the return type and consider explicitly handling the error.-->
エラーメッセージの品質を向上させるには、戻り値の型をより具体的にし、エラーを明示的に処理することを検討する必要があります。

<!--[option]: https://doc.rust-lang.org/std/option/enum.Option.html
 [result]: https://doc.rust-lang.org/std/result/enum.Result.html
 [parse]: https://doc.rust-lang.org/std/primitive.str.html#method.parse
-->
[option]: https://doc.rust-lang.org/std/option/enum.Option.html
 [result]: https://doc.rust-lang.org/std/result/enum.Result.html
 [parse]: https://doc.rust-lang.org/std/primitive.str.html#method.parse

