## <!--Continuously process child process' outputs--> 子プロセスの出力を継続的に処理する

<!--[!][std]-->
[！][std]
<!--[std-badge] [!][cat-os]-->
[std-badge] [！][cat-os]
[cat-os-badge]
<!--In [Run an external command and process stdout](#run-an-external-command-and-process-stdout), processing doesn't start until external [`Command`] is finished.-->
[外部コマンドを実行してstdout](#run-an-external-command-and-process-stdout)を処理すると、外部の[`Command`]が終了するまで処理が開始されません。
<!--The recipe below calls [`Stdio::piped`] to create a pipe, and reads `stdout` continuously as soon as the [`BufReader`] is updated.-->
以下のレシピは[`Stdio::piped`]を呼び出してパイプを作成し、[`BufReader`]が更新されるとすぐに`stdout`を読み込みます。

<!--The below recipe is equivalent to the Unix shell command `journalctl | grep usb`-->
以下のレシピは、Unixシェルコマンドの`journalctl | grep usb`
<!--`journalctl | grep usb`.-->
`journalctl | grep usb`。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
#
use std::process::{Command, Stdio};
use std::io::{BufRead, BufReader};

# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#     }
# }
#
fn run() -> Result<()> {
    let stdout = Command::new("journalctl")
        .stdout(Stdio::piped())
        .spawn()?
        .stdout
        .ok_or_else(|| "Could not capture standard output.")?;

    let reader = BufReader::new(stdout);

    reader
        .lines()
        .filter_map(|line| line.ok())
        .filter(|line| line.find("usb").is_some())
        .for_each(|line| println!("{}", line));

     Ok(())
}
#
# quick_main!(run);
```

<!--[`BufReader`]: https://doc.rust-lang.org/std/io/struct.BufReader.html
 [`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [`Stdio::piped`]: https://doc.rust-lang.org/std/process/struct.Stdio.html
-->
[`BufReader`]: https://doc.rust-lang.org/std/io/struct.BufReader.html
 [`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [`Stdio::piped`]: https://doc.rust-lang.org/std/process/struct.Stdio.html

