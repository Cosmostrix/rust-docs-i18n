## <!--Log messages to a custom location--> メッセージをカスタムロケーションに記録する

<!--[!][log]-->
[！][log]
<!--[log-badge] [!][log4rs]-->
[log-badge] [！][log4rs]
<!--[log4rs-badge] [!][cat-debugging]-->
[log4rs-badge] [！][cat-debugging]
[cat-debugging-badge]
<!--[log4rs] configures log output to a custom location.-->
[log4rs]ログ出力をカスタムの場所に設定します。
<!--[log4rs] can use either an external YAML file or a builder configuration.-->
[log4rs]は、外部YAMLファイルまたはビルダー構成のいずれかを使用できます。

<!--Create the log configuration with [`log4rs::append::file::FileAppender`].-->
[`log4rs::append::file::FileAppender`]ログ設定を作成します。
<!--An appender defines the logging destination.-->
アペンダはロギング先を定義します。
<!--The configuration continues with encoding using a custom pattern from [`log4rs::encode::pattern`].-->
設定は[`log4rs::encode::pattern`]カスタムパターンを使ってエンコーディングを続けます。
<!--Assigns the configuration to [`log4rs::config::Config`] and sets the default [`log::LevelFilter`].-->
設定を[`log4rs::config::Config`]、デフォルトの[`log::LevelFilter`]を設定します。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
#[macro_use]
extern crate log;
extern crate log4rs;

use log::LevelFilter;
use log4rs::append::file::FileAppender;
use log4rs::encode::pattern::PatternEncoder;
use log4rs::config::{Appender, Config, Root};
#
# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#         LogConfig(log4rs::config::Errors);
#         SetLogger(log::SetLoggerError);
#     }
# }

fn run() -> Result<()> {
    let logfile = FileAppender::builder()
        .encoder(Box::new(PatternEncoder::new("{l} - {m}\n")))
        .build("log/output.log")?;

    let config = Config::builder()
        .appender(Appender::builder().build("logfile", Box::new(logfile)))
        .build(Root::builder()
                   .appender("logfile")
                   .build(LevelFilter::Info))?;

    log4rs::init_config(config)?;

    info!("Hello, world!");

    Ok(())
}
#
# quick_main!(run);
```

<!--[`log4rs::append::file::FileAppender`]: https://docs.rs/log4rs/*/log4rs/append/file/struct.FileAppender.html
 [`log4rs::config::Config`]: https://docs.rs/log4rs/*/log4rs/config/struct.Config.html
 [`log4rs::encode::pattern`]: https://docs.rs/log4rs/*/log4rs/encode/pattern/index.html
 [`log::LevelFilter`]: https://docs.rs/log/*/log/enum.LevelFilter.html
-->
[`log4rs::append::file::FileAppender`]: https://docs.rs/log4rs/*/log4rs/append/file/struct.FileAppender.html
 [`log4rs::config::Config`]: https://docs.rs/log4rs/*/log4rs/config/struct.Config.html
 [`log4rs::encode::pattern`]: https://docs.rs/log4rs/*/log4rs/encode/pattern/index.html
 [`log::LevelFilter`]: https://docs.rs/log/*/log/enum.LevelFilter.html

