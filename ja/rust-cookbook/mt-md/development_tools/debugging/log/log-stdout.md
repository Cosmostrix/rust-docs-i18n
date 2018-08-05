## <!--Log to stdout instead of stderr--> stderrの代わりにstdoutにログを記録する

<!--[!][log]-->
[！][log]
<!--[log-badge] [!][env_logger]-->
[log-badge] [！][env_logger]
<!--[env_logger-badge] [!][cat-debugging]-->
[env_logger-badge] [！][cat-debugging]
[cat-debugging-badge]
<!--Creates a custom logger configuration using the [`Builder::target`] to set the target of the log output to [`Target::Stdout`].-->
ログ出力の[`Target::Stdout`]を[`Target::Stdout`]設定するために、[`Builder::target`]を使ってカスタムロガー設定を作成します。

```rust
#[macro_use]
extern crate log;
extern crate env_logger;

use env_logger::{Builder, Target};

fn main() {
    Builder::new()
        .target(Target::Stdout)
        .init();

    error!("This error has been printed to Stdout");
}
```

<!--[`Builder::target`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html#method.target
 [`Target::Stdout`]: https://docs.rs/env_logger/*/env_logger/fmt/enum.Target.html
-->
[`Builder::target`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html#method.target
 [`Target::Stdout`]: https://docs.rs/env_logger/*/env_logger/fmt/enum.Target.html

