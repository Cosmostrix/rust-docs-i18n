# <!--Early returns--> 早期返品

<!--In the previous example, we explicitly handled the errors using combinators.-->
前の例では、コンビネータを使用して明示的にエラーを処理しました。
<!--Another way to deal with this case analysis is to use a combination of `match` statements and *early returns*.-->
このケース分析に対処する別の方法は、`match`ステートメントと*早期リターンの*組み合わせを使用することです。

<!--That is, we can simply stop executing the function and return the error if one occurs.-->
つまり、関数の実行を停止し、エラーが発生した場合にはエラーを返すことができます。
<!--For some, this form of code can be easier to both read and write.-->
いくつかの場合、この形式のコードは読み込みと書き込みの両方が簡単です。
<!--Consider this version of the previous example, rewritten using early returns:-->
初期のリターンを使用して書き直した、前の例のこのバージョンを考えてみましょう。

```rust,editable
use std::num::ParseIntError;

fn multiply(first_number_str: &str, second_number_str: &str) -> Result<i32, ParseIntError> {
    let first_number = match first_number_str.parse::<i32>() {
        Ok(first_number)  => first_number,
        Err(e) => return Err(e),
    };

    let second_number = match second_number_str.parse::<i32>() {
        Ok(second_number)  => second_number,
        Err(e) => return Err(e),
    };

    Ok(first_number * second_number)
}

fn print(result: Result<i32, ParseIntError>) {
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

<!--At this point, we've learned to explicitly handle errors using combinators and early returns.-->
この時点で、コンビネータと早期リターンを使用してエラーを明示的に処理する方法を学びました。
<!--While we generally want to avoid panicking, explicitly handling all of our errors is cumbersome.-->
私たちは一般にパニックを避けたいが、明示的にすべてのエラーを処理するのは面倒である。

<!--In the next section, we'll introduce `?`-->
次のセクションでは、紹介しますか`?`
<!--for the cases where we simply need to `unwrap` without possibly inducing `panic`.-->
おそらく`panic`誘発することなく`unwrap`する必要がある場合に適しています。
