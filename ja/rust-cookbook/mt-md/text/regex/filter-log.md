## <!--Filter a log file by matching multiple regular expressions--> 複数の正規表現を照合してログファイルをフィルタリングする

<!--[!][regex]-->
[！][regex]
<!--[regex-badge] [!][cat-text-processing]-->
[regex-badge] [！][cat-text-processing]
[cat-text-processing-badge]
<!--Reads a file named `application.log` and only outputs the lines containing “version XXX”, some IP address followed by port 443 (eg “192.168.0.1:443”), or a specific warning.-->
`application.log`という名前のファイルを読み込み、「バージョンXXX」、IPアドレスのあとにポート443（「192.168.0.1:443」など）、または特定の警告を含む行だけを出力します。

<!--A [`regex::RegexSetBuilder`] composes a [`regex::RegexSet`].-->
[`regex::RegexSetBuilder`]構成[`regex::RegexSet`]。
<!--Since backslashes are very common in regular expressions, using [raw string literals] makes them more readable.-->
バックスラッシュは正規表現では非常に一般的なので、[raw string literals]を使用すると読みやすくなります。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate regex;

use std::fs::File;
use std::io::{BufReader, BufRead};
use regex::RegexSetBuilder;

# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#         Regex(regex::Error);
#     }
# }
#
fn run() -> Result<()> {
    let log_path = "application.log";
    let buffered = BufReader::new(File::open(log_path)?);

    let set = RegexSetBuilder::new(&[
        r#"version "\d\.\d\.\d""#,
        r#"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:443"#,
        r#"warning.*timeout expired"#,
    ]).case_insensitive(true)
        .build()?;

    buffered
        .lines()
        .filter_map(|line| line.ok())
        .filter(|line| set.is_match(line.as_str()))
        .for_each(|x| println!("{}", x));

    Ok(())
}
#
# quick_main!(run);
```

<!--[`regex::RegexSet`]: https://docs.rs/regex/*/regex/struct.RegexSet.html
 [`regex::RegexSetBuilder`]: https://docs.rs/regex/*/regex/struct.RegexSetBuilder.html
-->
[`regex::RegexSet`]: https://docs.rs/regex/*/regex/struct.RegexSet.html
 [`regex::RegexSetBuilder`]: https://docs.rs/regex/*/regex/struct.RegexSetBuilder.html


[raw string literals]: https://doc.rust-lang.org/reference/tokens.html#raw-string-literals
