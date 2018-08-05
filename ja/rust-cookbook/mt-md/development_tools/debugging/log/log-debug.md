## <!--Log a debug message to the console--> コンソールにデバッグメッセージを記録する

<!--[!][log]-->
[！][log]
<!--[log-badge] [!][env_logger]-->
[log-badge] [！][env_logger]
<!--[env_logger-badge] [!][cat-debugging]-->
[env_logger-badge] [！][cat-debugging]
[cat-debugging-badge]
<!--The `log` crate provides logging utilities.-->
`log`ボックスは、ログユーティリティを提供します。
<!--The `env_logger` crate configures logging via an environment variable.-->
`env_logger`、環境変数を使用してロギングを設定します。
<!--The [`debug!`] macro works like other [`std::fmt`] formatted strings.-->
[`debug!`]マクロは、他の[`std::fmt`]形式の文字列のように動作します。

```rust
#[macro_use]
extern crate log;
extern crate env_logger;

fn execute_query(query: &str) {
    debug!("Executing query: {}", query);
}

fn main() {
    env_logger::init();

    execute_query("DROP TABLE students");
}
```

<!--No output prints when running this code.-->
このコードを実行すると、出力はプリントされません。
<!--By default, the log level is `error`, and any lower levels are dropped.-->
デフォルトでは、ログレベルは`error`です。下位レベルは削除されます。

<!--Set the `RUST_LOG` environment variable to print the message:-->
メッセージを`RUST_LOG`するために`RUST_LOG`環境変数を設定します：

```
$ RUST_LOG=debug cargo run
```

<!--Cargo prints debugging information then the following line at the very end of the output:-->
Cargoはデバッグ情報を出力し、出力の最後に次の行を表示します。

```
DEBUG:main: Executing query: DROP TABLE students
```

<!--[`debug!`]: https://docs.rs/log/*/log/macro.debug.html
 [`std::fmt`]: https://doc.rust-lang.org/std/fmt/
-->
[`debug!`]: https://docs.rs/log/*/log/macro.debug.html
 [`std::fmt`]: https://doc.rust-lang.org/std/fmt/

