# <!--Defining an error type--> エラータイプの定義

<!--Sometimes it simplifies the code to mask all of the different errors with a single type of error.-->
時々、単一のタイプのエラーですべての異なるエラーをマスクするコードを単純化します。
<!--We'll show this with a custom error.-->
これをカスタムエラーで表示します。

<!--Rust allows us to define our own error types.-->
Rustでは、独自のエラータイプを定義できます。
<!--In general, a "good"error type:-->
一般に、「良い」エラータイプ：

* <!--Represents different errors with the same type-->
   同じ種類の異なるエラーを表します。
* <!--Presents nice error messages to the user-->
   ユーザーに良いエラーメッセージを表示する
* <!--Is easy to compare with other types-->
   他のタイプと比較しやすい
    - <!--Good: `Err(EmptyVec)`-->
       良い： `Err(EmptyVec)`
    - <!--Bad: `Err("Please use a vector with at least one element".to_owned())`-->
       Bad： `Err("Please use a vector with at least one element".to_owned())`
* <!--Can hold information about the error-->
   エラーに関する情報を保持できる
    - <!--Good: `Err(BadChar(c, position))`-->
       良い： `Err(BadChar(c, position))`
    - <!--Bad: `Err("+ cannot be used here".to_owned())`-->
       悪い： `Err("+ cannot be used here".to_owned())`
* <!--Composes well with other errors-->
   他のエラーもうまくいきます

```rust,editable
use std::error;
use std::fmt;
use std::num::ParseIntError;

type Result<T> = std::result::Result<T, DoubleError>;

#[derive(Debug, Clone)]
#// Define our error types. These may be customized for our error handling cases.
#// Now we will be able to write our own errors, defer to an underlying error
#// implementation, or do something in between.
// エラーの種類を定義します。これらは、エラー処理の場合にカスタマイズできます。今度は、独自のエラーを書き込んだり、基礎となるエラーの実装を延期したり、その間に何かをすることができます。
struct DoubleError;

#// Generation of an error is completely separate from how it is displayed.
#// There's no need to be concerned about cluttering complex logic with the display style.
// エラーの発生は、エラーの表示方法とは完全に異なります。表示スタイルで複雑なロジックが混乱するのを心配する必要はありません。
//
#// Note that we don't store any extra info about the errors. This means we can't state
#// which string failed to parse without modifying our types to carry that information.
// エラーに関する追加情報は保存しません。これは、その情報を運ぶために私たちの型を変更することなく、どの文字列が解析に失敗したかを示すことができないことを意味します。
impl fmt::Display for DoubleError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "invalid first item to double")
    }
}

#// This is important for other errors to wrap this one.
// これは、他のエラーがこれをラップするために重要です。
impl error::Error for DoubleError {
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
#       // Change the error to our new type.
       // エラーを新しいタイプに変更してください。
       .ok_or(DoubleError)
       .and_then(|s| s.parse::<i32>()
#            // Update to the new error type here also.
            // ここでも新しいエラータイプに更新してください。
            .map_err(|_| DoubleError)
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
