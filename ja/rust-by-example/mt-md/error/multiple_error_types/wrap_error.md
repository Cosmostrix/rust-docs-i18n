# <!--Wrapping errors--> 折り返しエラー

<!--An alternative to boxing errors is to wrap them in your own error type.-->
ボクシングエラーの代わりに、あなた自身のエラータイプでそれらをラップすることです。

```rust,editable
use std::error;
use std::num::ParseIntError;
use std::fmt;

type Result<T> = std::result::Result<T, DoubleError>;

#[derive(Debug)]
enum DoubleError {
    EmptyVec,
#    // We will defer to the parse error implementation for their error.
#    // Supplying extra info requires adding more data to the type.
    // 私たちは、エラーの解析エラーの実装を延期します。余分な情報を入力するには、そのデータ型にデータを追加する必要があります。
    Parse(ParseIntError),
}

impl fmt::Display for DoubleError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            DoubleError::EmptyVec =>
                write!(f, "please use a vector with at least one element"),
#            // This is a wrapper, so defer to the underlying types' implementation of `fmt`.
            // これはラッパーなので、基になる型の`fmt`の実装を延期します。
            DoubleError::Parse(ref e) => e.fmt(f),
        }
    }
}

impl error::Error for DoubleError {
    fn description(&self) -> &str {
        match *self {
            DoubleError::EmptyVec => "empty vectors not allowed",
#            // This already impls `Error`, so defer to its own implementation.
            // これはすでに`Error`意味しているので、独自の実装を延期します。
            DoubleError::Parse(ref e) => e.description(),
        }
    }

    fn cause(&self) -> Option<&error::Error> {
        match *self {
            DoubleError::EmptyVec => None,
#            // The cause is the underlying implementation error type. Is implicitly
#            // cast to the trait object `&error::Error`. This works because the
#            // underlying type already implements the `Error` trait.
            // 原因は、基本となる実装エラータイプです。暗黙的に特性オブジェクト`&error::Error`キャストされます。これは、基になる型が既に`Error`特性を実装しているために機能します。
            DoubleError::Parse(ref e) => Some(e),
        }
    }
}

#// Implement the conversion from `ParseIntError` to `DoubleError`.
#// This will be automatically called by `?` if a `ParseIntError`
#// needs to be converted into a `DoubleError`.
//  `ParseIntError`から`DoubleError`への変換を実装し`DoubleError`。これは自動的に`?` `ParseIntError` `DoubleError`変換する必要がある場合。
impl From<ParseIntError> for DoubleError {
    fn from(err: ParseIntError) -> DoubleError {
        DoubleError::Parse(err)
    }
}

fn double_first(vec: Vec<&str>) -> Result<i32> {
    let first = vec.first().ok_or(DoubleError::EmptyVec)?;
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

<!--This adds a bit more boilerplate for handling errors and might not be needed in all applications.-->
これにより、エラーを処理するための定型文が少し追加され、すべてのアプリケーションで必要とされることはありません。
<!--There are some libraries that can take care of the boilerplate for you.-->
ボイラープレートの世話をするライブラリがいくつかあります。

### <!--See also:--> 参照：

<!--[`From::from`][from] and [`Enums`][enums]-->
[`From::from`][from]と[`Enums`][enums]

<!--[from]: https://doc.rust-lang.org/std/convert/trait.From.html
 [enums]: custom_types/enum.html
-->
[enums]: custom_types/enum.html
 [from]: https://doc.rust-lang.org/std/convert/trait.From.html

