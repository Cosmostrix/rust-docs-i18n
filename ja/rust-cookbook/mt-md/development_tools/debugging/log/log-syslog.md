## <!--Log to the Unix syslog--> Unixのsyslogに記録する

<!--[!][log]-->
[！][log]
<!--[log-badge] [!][syslog]-->
[log-badge] [！][syslog]
<!--[syslog-badge] [!][cat-debugging]-->
[syslog-badge] [！][cat-debugging]
[cat-debugging-badge]
<!--Logs messages to [UNIX syslog].-->
[UNIX syslog]メッセージを記録し[UNIX syslog]。
<!--Initializes logger backend with [`syslog::init`].-->
[`syslog::init`]ロガーバックエンドを初期化します。
<!--[`syslog::Facility`] records the program submitting the log entry's classification, [`log::LevelFilter`] denotes allowed log verbosity and `Option<&str>` holds optional application name.-->
[`syslog::Facility`]はログエントリの分類を提出するプログラムを記録し、[`log::LevelFilter`]は許可されたログの冗長性を示し、`Option<&str>`はオプションのアプリケーション名を保持します。

```rust
# #![allow(unused_imports)]
# #[macro_use]
# extern crate error_chain;
#[macro_use]
extern crate log;
# #[cfg(target_os = "linux")]
extern crate syslog;

# #[cfg(target_os = "linux")]
use syslog::Facility;
#
# #[cfg(target_os = "linux")]
# error_chain! {
#     foreign_links {
#         SetLogger(syslog::Error);
#     }
# }

# #[cfg(target_os = "linux")]
fn run() -> Result<()> {
    syslog::init(Facility::LOG_USER,
                 log::LevelFilter::Debug,
                 Some("My app name"))?;
    debug!("this is a debug {}", "message");
    error!("this is an error!");
    Ok(())
}
#
# #[cfg(not(target_os = "linux"))]
# error_chain! {}
# #[cfg(not(target_os = "linux"))]
# fn run() -> Result<()> {
#     Ok(())
# }
#
# quick_main!(run);
```

<!--[`log::LevelFilter`]: https://docs.rs/log/*/log/enum.LevelFilter.html
 [`syslog::Facility`]: https://docs.rs/syslog/*/syslog/enum.Facility.html
 [`syslog::init`]: https://docs.rs/syslog/*/syslog/fn.init.html
-->
[`log::LevelFilter`]: https://docs.rs/log/*/log/enum.LevelFilter.html
 [`syslog::Facility`]: https://docs.rs/syslog/*/syslog/enum.Facility.html
 [`syslog::init`]: https://docs.rs/syslog/*/syslog/fn.init.html


[UNIX syslog]: https://www.gnu.org/software/libc/manual/html_node/Overview-of-Syslog.html
