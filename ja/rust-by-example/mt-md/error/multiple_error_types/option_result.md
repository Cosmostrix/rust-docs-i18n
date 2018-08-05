# <!--Pulling `Result` s out of `Option` s--> `Option` sから`Result` sを引き出す

<!--The most basic way of handling mixed error types is to just embed them in each other.-->
混在したエラータイプを処理する最も基本的な方法は、それらをお互いに埋め込むことです。

```rust,editable
use std::num::ParseIntError;

fn double_first(vec: Vec<&str>) -> Option<Result<i32, ParseIntError>> {
    vec.first().map(|first| {
        first.parse::<i32>().map(|n| 2 * n)
    })
}

fn main() {
    let numbers = vec!["42", "93", "18"];
    let empty = vec![];
    let strings = vec!["tofu", "93", "18"];

    println!("The first doubled is {:?}", double_first(numbers));

    println!("The first doubled is {:?}", double_first(empty));
#    // Error 1: the input vector is empty
    // エラー1：入力ベクトルが空です

    println!("The first doubled is {:?}", double_first(strings));
#    // Error 2: the element doesn't parse to a number
    // エラー2：要素は数値に解析されません
}
```

<!--There are times when we'll want to stop processing on errors (like with [`?`][enter_question_mark]) but keep going when the `Option` is `None`.-->
エラーの処理（[`?`][enter_question_mark]）を停止したいが、 `Option`が`None`場合は続けることがある。
<!--A couple of combinators come in handy to swap the `Result` and `Option`.-->
`Result`と`Option`を交換するためには、いくつかのコンビネータが便利です。

```rust,editable
use std::num::ParseIntError;

fn double_first(vec: Vec<&str>) -> Result<Option<i32>, ParseIntError> {
    let opt = vec.first().map(|first| {
        first.parse::<i32>().map(|n| 2 * n)
    });

    let opt = opt.map_or(Ok(None), |r| r.map(Some))?;

    Ok(opt)
}

fn main() {
    let numbers = vec!["42", "93", "18"];
    let empty = vec![];
    let strings = vec!["tofu", "93", "18"];

    println!("The first doubled is {:?}", double_first(numbers));
    println!("The first doubled is {:?}", double_first(empty));
    println!("The first doubled is {:?}", double_first(strings));
}
```

[enter_question_mark]: error/result/enter_question_mark.html
