# `?` <!--in `fn main()` and `#[test]` s--> `fn main()`と`#[test]`

<!--Rust's error handling revolves around returning `Result` and using `?`-->
Rustのエラー処理は、`Result`を返すことと、使用することを中心に行われ`?`
<!--to propagate errors.-->
エラーを伝播する。
<!--For those who write many small programs and, hopefully, many tests, one common paper cut has been mixing entry points such as `main` and `#[test]` s with error handling.-->
小さなプログラムをたくさん書いていて、うまくいけば多くのテストを書いている人のために、`main`と`#[test]`のようなエントリポイントとエラー処理を混在させた一般的なペーパーカットがあります。

<!--As an example, you might have tried to write:-->
たとえば、次のように記述しようとした可能性があります。

```rust,ignore
use std::fs::File;

fn main() {
    let f = File::open("bar.txt")?;
}
```

<!--Since `?`-->
それ以来`?`
<!--works by propagating the `Result` with an early return to the enclosing function, the snippet above does not work, and results today in the following error:-->
初期の戻り値を囲む関数に`Result`を伝播することで動作しますが、上のスニペットは機能せず、今日の結果は次のようになります。

```rust,ignore
error[E0277]: the `?` operator can only be used in a function that returns `Result`
              or `Option` (or another type that implements `std::ops::Try`)
 --> src/main.rs:5:13
  |
5 |     let f = File::open("bar.txt")?;
  |             ^^^^^^^^^^^^^^^^^^^^^^ cannot use the `?` operator in a function that returns `()`
  |
  = help: the trait `std::ops::Try` is not implemented for `()`
  = note: required by `std::ops::Try::from_error`
```

<!--To solve this problem in Rust 2015, you might have written something like:-->
Rust 2015でこの問題を解決するには、次のような記述があります。

```rust
#// Rust 2015
//  2015年の錆

# use std::process;
# use std::error::Error;

fn run() -> Result<(), Box<Error>> {
#    // real logic..
    // 本当の論理..
    Ok(())
}

fn main() {
    if let Err(e) = run() {
        println!("Application error: {}", e);
        process::exit(1);
    }
}
```

<!--However, in this case, the `run` function has all the interesting logic and `main` is just boilerplate.-->
しかし、この場合、`run`関数はすべて興味深いロジックを持ち、`main`は単なる定型文です。
<!--The problem is even worse for `#[test]` s, since there tend to be a lot more of them.-->
`#[test]` sの問題はさらに深刻になるので、この問題はさらに悪化します。

<!--In Rust 2018 you can instead let your `#[test]` s and `main` functions return a `Result`:-->
Rust 2018では、代わりに`#[test]`と`main`関数が`Result`返すようにすることができます：

```rust,no_run
#// Rust 2018
// 錆2018

use std::fs::File;

fn main() -> Result<(), std::io::Error> {
    let f = File::open("bar.txt")?;

    Ok(())
}
```

<!--In this case, if say the file doesn't exist and there is an `Err(err)` somewhere, then `main` will exit with an error code (not `0`) and print out a `Debug` representation of `err`.-->
この場合、ファイルが存在せず、どこかに`Err(err)`場合、`main`はエラーコード（`0`はない）で終了し、`err` `Debug`表現を出力します。

## <!--More details--> 詳細

<!--Getting `-> Result<..>` to work in the context of `main` and `#[test]` s is not magic.-->
入門`-> Result<..>`のコンテキストで動作するように`main`と`#[test]` sが魔法ではありません。
<!--It is all backed up by a `Termination` trait which all valid return types of `main` and testing functions must implement.-->
すべての有効な戻りタイプの`main`関数とテスト関数が実装しなければならない`Termination`特性によってバックアップされます。
<!--The trait is defined as:-->
形質は次のように定義されます：

```rust
pub trait Termination {
    fn report(self) -> i32;
}
```

<!--When setting up the entry point for your application, the compiler will use this trait and call `.report()` on the `Result` of the `main` function you have written.-->
アプリケーションのエントリーポイントを設定するとき、コンパイラーはこの特性を使用し、あなたが書いた`main`関数の`Result`に対して`.report()`を呼び出します。

<!--Two simplified example implementations of this trait for `Result` and `()` are:-->
`Result`および`()`に対するこの特性の2つの単純化された実施例は、

```rust
# #![feature(process_exitcode_placeholder, termination_trait_lib)]
# use std::process::ExitCode;
# use std::fmt;
#
# pub trait Termination { fn report(self) -> i32; }

impl Termination for () {
    fn report(self) -> i32 {
        # use std::process::Termination;
        ExitCode::SUCCESS.report()
    }
}

impl<E: fmt::Debug> Termination for Result<(), E> {
    fn report(self) -> i32 {
        match self {
            Ok(()) => ().report(),
            Err(err) => {
                eprintln!("Error: {:?}", err);
                # use std::process::Termination;
                ExitCode::FAILURE.report()
            }
        }
    }
}
```

<!--As you can see in the case of `()`, a success code is simply returned.-->
`()`の場合に見られるように、単に成功コードが返されます。
<!--In the case of `Result`, the success case delegates to the implementation for `()` but prints out an error message and a failure exit code on `Err(..)`.-->
`Result`の場合、成功事例は`()`の実装に委譲しますが、エラーメッセージと`Err(..)`失敗終了コードを出力し`Err(..)`。

<!--To learn more about the finer details, consult either [the tracking issue](https://github.com/rust-lang/rust/issues/43301) or [the RFC](https://github.com/rust-lang/rfcs/blob/master/text/1937-ques-in-main.md).-->
より詳細な詳細については[、追跡の問題](https://github.com/rust-lang/rust/issues/43301)または[RFCを](https://github.com/rust-lang/rfcs/blob/master/text/1937-ques-in-main.md)参照してください。
