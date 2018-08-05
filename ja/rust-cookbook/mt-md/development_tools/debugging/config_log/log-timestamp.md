## <!--Include timestamp in log messages--> ログメッセージにタイムスタンプを含める

<!--[!][log]-->
[！][log]
<!--[log-badge] [!][env_logger]-->
[log-badge] [！][env_logger]
<!--[env_logger-badge] [!][chrono]-->
[env_logger-badge] [！][chrono]
<!--[chrono-badge] [!][cat-debugging]-->
[chrono-badge] [！][cat-debugging]
[cat-debugging-badge]
<!--Creates a custom logger configuration with [`Builder`].-->
[`Builder`]カスタムロガー設定を作成します。
<!--Each log entry calls [`Local::now`] to get the current [`DateTime`] in local timezone and uses [`DateTime::format`] with [`strftime::specifiers`] to format a timestamp used in the final log.-->
各ログエントリは[`Local::now`]を呼び出してローカルタイムゾーンで現在の[`DateTime`]を取得し、[`strftime::specifiers`] [`DateTime::format`]で[`strftime::specifiers`] [`DateTime::format`]を使用して最終ログで使用されるタイムスタンプをフォーマットします。

<!--The example calls [`Builder::format`] to set a closure which formats each message text with timestamp, [`Record::level`] and body ([`Record::args`]).-->
この例では、[`Builder::format`]を呼び出して[`Builder::format`]各メッセージテキストをタイムスタンプ[`Record::level`]と本文（[`Record::args`]）でフォーマットするクロージャを設定します。

```rust
#[macro_use]
extern crate log;
extern crate chrono;
extern crate env_logger;

use std::io::Write;
use chrono::Local;
use env_logger::Builder;
use log::LevelFilter;

fn main() {
    Builder::new()
        .format(|buf, record| {
            writeln!(buf,
                "{} [{}] - {}",
                Local::now().format("%Y-%m-%dT%H:%M:%S"),
                record.level(),
                record.args()
            )
        })
        .filter(None, LevelFilter::Info)
        .init();

    warn!("warn");
    info!("info");
    debug!("debug");
}
```
<!--stderr output will contain ` ``2017-05-22T21:57:06 [WARN] - warn 2017-05-22T21:57:06 [INFO] - info`` `-->
stderr出力には ` ``2017-05-22T21:57:06 [WARN] - warn 2017-05-22T21:57:06 [INFO] - info``が含まれます``2017-05-22T21:57:06 [WARN] - warn 2017-05-22T21:57:06 [INFO] - info``

<!--[`DateTime::format`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.format
 [`DateTime`]: https://docs.rs/chrono/*/chrono/datetime/struct.DateTime.html
 [`Local::now`]: https://docs.rs/chrono/*/chrono/offset/struct.Local.html#method.now
 [`Builder`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html
 [`Builder::format`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html#method.format
 [`Record::args`]: https://docs.rs/log/*/log/struct.Record.html#method.args
 [`Record::level`]: https://docs.rs/log/*/log/struct.Record.html#method.level
 [`strftime::specifiers`]: https://docs.rs/chrono/*/chrono/format/strftime/index.html#specifiers
-->
[`DateTime::format`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.format
 [`DateTime`]: https://docs.rs/chrono/*/chrono/datetime/struct.DateTime.html
 [`Local::now`]: https://docs.rs/chrono/*/chrono/offset/struct.Local.html#method.now
 [`Builder`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html
 [`Builder::format`]: https://docs.rs/env_logger/*/env_logger/struct.Builder.html#method.format
 [`Record::args`]: https://docs.rs/log/*/log/struct.Record.html#method.args
 [`Record::level`]: https://docs.rs/log/*/log/struct.Record.html#method.level
 [`strftime::specifiers`]: https://docs.rs/chrono/*/chrono/format/strftime/index.html#specifiers

