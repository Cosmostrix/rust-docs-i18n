## <!--Log an error message to the console--> コンソールにエラーメッセージを記録する

<!--[!][log]-->
[！][log]
<!--[log-badge] [!][env_logger]-->
[log-badge] [！][env_logger]
<!--[env_logger-badge] [!][cat-debugging]-->
[env_logger-badge] [！][cat-debugging]
[cat-debugging-badge]
<!--Proper error handling considers exceptions exceptional.-->
適切なエラー処理は、例外的な例外を考慮します。
<!--Here, an error logs to stderr with `log` 's convenience macro [`error!`].-->
ここでは、エラーがログの便利なマクロ[`error!`] stderrに`log`。

```rust
#[macro_use]
extern crate log;
extern crate env_logger;

fn execute_query(_query: &str) -> Result<(), &'static str> {
    Err("I'm afraid I can't do that")
}

fn main() {
    env_logger::init();

    let response = execute_query("DROP TABLE students");
    if let Err(err) = response {
        error!("Failed to execute query: {}", err);
    }
}
```

[`error!`]: https://docs.rs/log/*/log/macro.error.html
