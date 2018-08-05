## <!--Handle errors correctly in main--> メインで正しくエラーを処理する

<!--[!][error-chain]-->
[！][error-chain]
<!--[error-chain-badge] [!][cat-rust-patterns]-->
[error-chain-badge] [！][cat-rust-patterns]
[cat-rust-patterns-badge]
<!--Handles error that occur when trying to open a file that does not exist.-->
存在しないファイルを開くときに発生するエラーを処理します。
<!--It is achieved by using [error-chain], a library that takes care of a lot of boilerplate code needed in order to [handle errors in Rust].-->
これは[handle errors in Rust]を[handle errors in Rust]ために必要な定型コードを大量に[handle errors in Rust]するライブラリである[error-chain]を使用することで実現し[error-chain]。

<!--`Io(std::io::Error)` inside [`foreign_links`] allows automatic conversion from [`std::io::Error`] into [`error_chain!`] defined type implementing the [`Error`] trait.-->
[`foreign_links`]中の`Io(std::io::Error)`、 [`std::io::Error`]から[`error_chain!`]定義型への[`Error`]特性を実装する自動変換を可能にします。

<!--The below recipe will tell how long the system has been running by opening the Unix file `/proc/uptime` and parse the content to get the first number.-->
以下のレシピでは、Unixファイル`/proc/uptime`を開き、最初の数字を取得するためにコンテンツを解析することによって、システムが実行されている`/proc/uptime`。
<!--Returns uptime unless there is an error.-->
エラーがない限り、稼働時間を返します。

<!--Other recipes in this book will hide the [error-chain] boilerplate, and can be seen by expanding the code with the ⤢ button.-->
このマニュアルの他のレシピでは、[error-chain]ボイラープレートが隠され、⤢ボタンでコードを展開すると表示されます。

```rust
#[macro_use]
extern crate error_chain;

use std::fs::File;
use std::io::Read;

error_chain!{
    foreign_links {
        Io(std::io::Error);
        ParseInt(::std::num::ParseIntError);
    }
}

fn read_uptime() -> Result<u64> {
    let mut uptime = String::new();
    File::open("/proc/uptime")?.read_to_string(&mut uptime)?;

    Ok(uptime
        .split('.')
        .next()
        .ok_or("Cannot parse uptime data")?
        .parse()?)
}

fn main() {
    match read_uptime() {
        Ok(uptime) => println!("uptime: {} seconds", uptime),
        Err(err) => eprintln!("error: {}", err),
    };
}
```

<!--[`error_chain!`]: https://docs.rs/error-chain/*/error_chain/macro.error_chain.html
 [`Error`]: https://doc.rust-lang.org/std/error/trait.Error.html
 [`foreign_links`]: https://docs.rs/error-chain/*/error_chain/#foreign-links
 [`std::io::Error`]: https://doc.rust-lang.org/std/io/struct.Error.html
-->
[`error_chain!`]: https://docs.rs/error-chain/*/error_chain/macro.error_chain.html
 [`Error`]: https://doc.rust-lang.org/std/error/trait.Error.html
 [`foreign_links`]: https://docs.rs/error-chain/*/error_chain/#foreign-links
 [`std::io::Error`]: https://doc.rust-lang.org/std/io/struct.Error.html


[handle errors in Rust]: https://doc.rust-lang.org/book/second-edition/ch09-00-error-handling.html
