# <!--Other uses of `?`--> その他の用途は`?`

<!--Notice in the previous example that our immediate reaction to calling `parse` is to `map` the error from a library error into a boxed error:-->
前の例では、`parse`を呼び出すための即座の反応は、ライブラリエラーのエラーをボックス化されたエラーに`map`することです。

```rust,ignore
.and_then(|s| s.parse::<i32>()
    .map_err(|e| e.into())
```

<!--Since this is a simple and common operation, it would be convenient if it could be elided.-->
これは簡単で一般的な操作なので、省略できれば便利です。
<!--Alas, because `and_then` is not sufficiently flexible, it cannot.-->
悲しいかな、`and_then`は十分柔軟ではないので、できません。
<!--However, we can instead use `?`-->
しかし、代わりに`?`
<!--.-->
。

`?` <!--was previously explained as either `unwrap` or `return Err(err)`.-->
以前は`unwrap`または`return Err(err)`いずれかと説明されていました。
<!--This is only mostly true.-->
これは主に真実です。
<!--It actually means `unwrap` or `return Err(From::from(err))`.-->
これは実際に`unwrap`または`return Err(From::from(err))`ます。
<!--Since `From::from` is a conversion utility between different types, this means that if you `?`-->
以来`From::from`異なるタイプ間の変換ユーティリティがあり、これはつまり、あなたの場合は`?`
<!--where the error is convertible to the return type, it will convert automatically.-->
エラーが戻り値の型に変換可能な場合は、自動的に変換されます。

<!--Here, we rewrite the previous example using `?`-->
ここでは、前の例を`?`
<!--.-->
。
<!--As a result, the `map_err` will go away when `From::from` is implemented for our error type:-->
その結果、`map_err`は、`From::from`がエラータイプとして実装されたときに消えてしまいます：

```rust,editable
use std::error;
use std::fmt;
use std::num::ParseIntError;

#// Change the alias to `Box<error::Error>`.
// エイリアスを`Box<error::Error>`ます。
type Result<T> = std::result::Result<T, Box<error::Error>>;

#[derive(Debug)]
struct EmptyVec;

impl fmt::Display for EmptyVec {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "invalid first item to double")
    }
}

impl error::Error for EmptyVec {
    fn description(&self) -> &str {
        "invalid first item to double"
    }

    fn cause(&self) -> Option<&error::Error> {
#        // Generic error, underlying cause isn't tracked.
        // 一般的なエラー、根本的な原因は追跡されません。
        None
    }
}

#// The same structure as before but rather than chain all `Results`
#// and `Options` along, we `?` to get the inner value out immediately.
// 前と同じ構造`?`、すべての`Results`と`Options`連鎖するのではなく、すぐに内部の価値を引き出す。
fn double_first(vec: Vec<&str>) -> Result<i32> {
    let first = vec.first().ok_or(EmptyVec)?;
    let parsed = first.parse::<i32>()?;
    Ok(2 * parsed)
}

fn print(result: Result<i32>) {
    match result {
        Ok(n)  => println!("The first doubled is {}", n),
        Err(e) => println!("Error: {}", e),
    }
}

fn main() {
    let numbers = vec!["42", "93", "18"];
    let empty = vec![];
    let strings = vec!["tofu", "93", "18"];

    print(double_first(numbers));
    print(double_first(empty));
    print(double_first(strings));
}
```

<!--This is actually fairly clean now.-->
これは実際にはかなりきれいです。
<!--Compared with the original `panic`, it is very similar to replacing the `unwrap` calls with `?`-->
元の`panic`と比較して、`unwrap`コールを交換するのと非常に似てい`?`
<!--except that the return types are `Result`.-->
戻り値の型は`Result`です。
<!--As a result, they must be destructured at the top level.-->
結果として、それらはトップレベルで破壊されなければならない。

### <!--See also:--> 参照：

<!--[`From::from`][from] and [`?`][q_mark]-->
[`From::from`][from] [`?`][q_mark]

<!--[from]: https://doc.rust-lang.org/std/convert/trait.From.html
 [q_mark]: https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-question-mark-operator
-->
[q_mark]: https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-question-mark-operator
 [from]: https://doc.rust-lang.org/std/convert/trait.From.html

