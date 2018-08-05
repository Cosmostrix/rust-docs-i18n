# <!--`Box` ing errors--> `Box`エラー

<!--A way to write simple code while preserving the original errors is to [`Box`][box] them.-->
元のエラーを保存しながら簡単なコードを書く方法は、それらを[`Box`][box]ことです。
<!--The drawback is that the underlying error type is only known at runtime and not [statically determined][dynamic_dispatch].-->
欠点は、基になるエラータイプが実行時にのみ認識され、[静的には決定され][dynamic_dispatch]ない[こと][dynamic_dispatch]です。

<!--The stdlib helps in boxing our errors by having `Box` implement conversion from any type that implements the `Error` trait into the trait object `Box<Error>`, via [`From`][from].-->
stdlibは、`Error`特性を実装する任意のタイプから、特性オブジェクト`Box<Error>`に[`From`][from]を使用して`Box`変換を実装することによって、エラーをボクシングするのに役立ちます。

```rust,editable
use std::error;
use std::fmt;
use std::num::ParseIntError;

#// Change the alias to `Box<error::Error>`.
// エイリアスを`Box<error::Error>`ます。
type Result<T> = std::result::Result<T, Box<error::Error>>;

#[derive(Debug, Clone)]
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

fn double_first(vec: Vec<&str>) -> Result<i32> {
    vec.first()
#//       .ok_or_else(|| EmptyVec.into())  // Converts to Box
       .ok_or_else(|| EmptyVec.into())  // ボックスに変換する
       .and_then(|s| s.parse::<i32>()
#//            .map_err(|e| e.into())  // Converts to Box
            .map_err(|e| e.into())  // ボックスに変換する
            .map(|i| 2 * i))
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

### <!--See also:--> 参照：

<!--[Dynamic dispatch][dynamic_dispatch] and [`Error` trait][error]-->
[動的ディスパッチ][dynamic_dispatch]と[`Error`特性][error]

<!--[box]: https://doc.rust-lang.org/std/boxed/struct.Box.html
 [dynamic_dispatch]: https://doc.rust-lang.org/book/second-edition/ch17-02-trait-objects.html#trait-objects-perform-dynamic-dispatch
 [error]: https://doc.rust-lang.org/std/error/trait.Error.html
 [from]: https://doc.rust-lang.org/std/convert/trait.From.html
-->
[box]: https://doc.rust-lang.org/std/boxed/struct.Box.html
 [dynamic_dispatch]: https://doc.rust-lang.org/book/second-edition/ch17-02-trait-objects.html#trait-objects-perform-dynamic-dispatch
 [error]: https://doc.rust-lang.org/std/error/trait.Error.html
 [from]: https://doc.rust-lang.org/std/convert/trait.From.html

