# <!--Introducing `?`--> ご紹介`?`

<!--Sometimes we just want the simplicity of `unwrap` without the possibility of a `panic`.-->
時には、`panic`可能性なしに簡単に`unwrap`ことが必要な場合もあります。
<!--Until now, `unwrap` has forced us to nest deeper and deeper when what we really wanted was to get the variable *out*.-->
今まで、`unwrap`は、私たちが本当に必要としていたものが変数を*取り出す*ことになったときに、より深く深く入れ子にするよう強制*しました*。
<!--This is exactly the purpose of `?`-->
これはまさに目的`?`
<!--.-->
。

<!--Upon finding an `Err`, there are two valid actions to take:-->
`Err`を見つけ`Err`、取るべき2つの有効な処置があります：

1. <!--`panic!` which we already decided to try to avoid if possible-->
    可能であれば避けようと既に決めた`panic!`
2. <!--`return` because an `Err` means it cannot be handled-->
    `Err`は処理できないという意味で`return`れます

`?` <!--is *almost* [^†] exactly equivalent to an `unwrap` which `return` s instead of `panic` s on `Err` s.-->
*ほぼ* [^†]は`Err`の`panic`の代わりにsを`return` `unwrap`とまったく同じです。
<!--Let's see how we can simplify the earlier example that used combinators:-->
コンビネータを使用した以前の例を単純化する方法を見てみましょう。

```rust,editable
use std::num::ParseIntError;

fn multiply(first_number_str: &str, second_number_str: &str) -> Result<i32, ParseIntError> {
    let first_number = first_number_str.parse::<i32>()?;
    let second_number = second_number_str.parse::<i32>()?;

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

## <!--The `try!` macro--> `try!`マクロ

<!--Before there was `?`-->
それがある前に`?`
<!--, the same functionality was achieved with the `try!` macro.-->
同じ機能が`try!`マクロで実現されました。
<!--The `?`-->
`?`
<!--operator is now recommended, but you may still find `try!` when looking at older code.-->
演算子は現在推奨されていますが、古いコードを見ても`try!`ことができます。
<!--The same `multiply` function from the previous example would look like this using `try!`:-->
前の例と同じ`multiply`関数は、`try!`を使って次のようになります：

```rust,editable
use std::num::ParseIntError;

fn multiply(first_number_str: &str, second_number_str: &str) -> Result<i32, ParseIntError> {
    let first_number = try!(first_number_str.parse::<i32>());
    let second_number = try!(second_number_str.parse::<i32>());

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


[^†]: See%20%5Bre-enter%20?%5D%5Bre_enter_?%5D%20for%20more%20details.

[re_enter_?]: error/multiple_error_types/reenter_question_mark.html
