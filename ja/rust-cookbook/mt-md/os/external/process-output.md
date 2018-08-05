## <!--Run an external command and process stdout--> 外部コマンドを実行してstdoutを処理する

<!--[!][regex]-->
[！][regex]
<!--[regex-badge] [!][cat-os]-->
[regex-badge] [！][cat-os]
<!--[cat-os-badge] [!][cat-text-processing]-->
[cat-os-badge] [！][cat-text-processing]
[cat-text-processing-badge]
<!--Runs `git log --oneline` as an external [`Command`] and inspects its [`Output`] using [`Regex`] to get the hash and message of the last 5 commits.-->
`git log --oneline`を外部の[`Command`] `git log --oneline`として実行し、最後の5つのコミットのハッシュとメッセージを得るために[`Regex`]を使って[`Output`]を検査します。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate regex;

use std::process::Command;
use regex::Regex;
#
# error_chain!{
#     foreign_links {
#         Io(std::io::Error);
#         Regex(regex::Error);
#         Utf8(std::string::FromUtf8Error);
#     }
# }

#[derive(PartialEq, Default, Clone, Debug)]
struct Commit {
    hash: String,
    message: String,
}

fn run() -> Result<()> {
    let output = Command::new("git").arg("log").arg("--oneline").output()?;

    if !output.status.success() {
        bail!("Command executed with failing error code");
    }

    let pattern = Regex::new(r"(?x)
                               ([0-9a-fA-F]+) # commit hash
                               (.*)           # The commit message")?;

    String::from_utf8(output.stdout)?
        .lines()
        .filter_map(|line| pattern.captures(line))
        .map(|cap| {
                 Commit {
                     hash: cap[1].to_string(),
                     message: cap[2].trim().to_string(),
                 }
             })
        .take(5)
        .for_each(|x| println!("{:?}", x));

    Ok(())
}
#
# quick_main!(run);
```

<!--[`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [`Output`]: https://doc.rust-lang.org/std/process/struct.Output.html
 [`Regex`]: https://docs.rs/regex/*/regex/struct.Regex.html
-->
[`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [`Output`]: https://doc.rust-lang.org/std/process/struct.Output.html
 [`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [`Output`]: https://doc.rust-lang.org/std/process/struct.Output.html
 [`Regex`]: https://docs.rs/regex/*/regex/struct.Regex.html

