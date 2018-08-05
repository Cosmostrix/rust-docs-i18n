## <!--Use a custom environment variable to set up logging--> カスタム環境変数を使用してログを設定する

<!--[!][log]-->
[！][log]
<!--[log-badge] [!][env_logger]-->
[log-badge] [！][env_logger]
<!--[env_logger-badge] [!][cat-debugging]-->
[env_logger-badge] [！][cat-debugging]
[cat-debugging-badge]
<!--[`Builder`] configures logging.-->
[`Builder`]ロギングを設定します。

<!--[`Builder::parse`] parses `MY_APP_LOG` environment variable contents in the form of [`RUST_LOG`] syntax.-->
[`Builder::parse`] `MY_APP_LOG`は、`MY_APP_LOG`環境変数の内容を[`RUST_LOG`]構文の形式で[`Builder::parse`]します。
<!--Then, [`Builder::init`] initializes the logger.-->
次に、[`Builder::init`]はロガーを初期化します。
<!--All these steps are normally done internally by [`env_logger::init`].-->
これらのすべてのステップは、通常、[`env_logger::init`]によって内部的に実行されます。

```rust
#[macro_use]
extern crate log;
extern crate env_logger;

use std::env;
use env_logger::Builder;

fn main() {
    Builder::new()
        .parse(&env::var("MY_APP_LOG").unwrap_or_default())
        .init();

    info!("informational message");
    warn!("warning message");
    error!("this is an error {}", "message");
}
```

<!--[`env_logger::init`]: https://docs.rs/env_logger/*/env_logger/fn.init.html
 [`Builder`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html
 [`Builder::init`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html#method.init
 [`Builder::parse`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html#method.parse
 [`RUST_LOG`]: https://docs.rs/env_logger/*/env_logger/#enabling-logging
-->
[`env_logger::init`]: https://docs.rs/env_logger/*/env_logger/fn.init.html
 [`Builder`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html
 [`Builder::init`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html#method.init
 [`Builder::parse`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html#method.parse
 [`RUST_LOG`]: https://docs.rs/env_logger/*/env_logger/#enabling-logging

