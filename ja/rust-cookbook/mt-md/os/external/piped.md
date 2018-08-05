## <!--Run piped external commands--> パイプされた外部コマンドを実行する

<!--[!][std]-->
[！][std]
<!--[std-badge] [!][cat-os]-->
[std-badge] [！][cat-os]
[cat-os-badge]
<!--Shows up to the 10  __th__  biggest files and subdirectories in the current working directory.-->
現在の作業ディレクトリにある最大10  __番目__ のファイルとサブディレクトリを表示します。
<!--It is equivalent to running: `du -ah . | sort -hr | head -n 10`-->
これはrunning： `du -ah . | sort -hr | head -n 10`と同じ`du -ah . | sort -hr | head -n 10`
`du -ah . | sort -hr | head -n 10` <!--`du -ah . | sort -hr | head -n 10`.-->
`du -ah . | sort -hr | head -n 10`。

<!--[`Command`] s represent a process.-->
[`Command`]はプロセスを表します。
<!--Output of a child process is captured with a [`Stdio::piped`] between parent and child.-->
子プロセスの出力は親と子の間の[`Stdio::piped`]捕捉されます。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
#
use std::process::{Command, Stdio};
#
# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#         Utf8(std::string::FromUtf8Error);
#     }
# }

fn run() -> Result<()> {
    let directory = std::env::current_dir()?;
    let mut du_output_child = Command::new("du")
        .arg("-ah")
        .arg(&directory)
        .stdout(Stdio::piped())
        .spawn()?;

    if let Some(du_output) = du_output_child.stdout.take() {
        let mut sort_output_child = Command::new("sort")
            .arg("-hr")
            .stdin(du_output)
            .stdout(Stdio::piped())
            .spawn()?;

        du_output_child.wait()?;

        if let Some(sort_output) = sort_output_child.stdout.take() {
            let head_output_child = Command::new("head")
                .args(&["-n", "10"])
                .stdin(sort_output)
                .stdout(Stdio::piped())
                .spawn()?;

            let head_stdout = head_output_child.wait_with_output()?;

            sort_output_child.wait()?;

            println!(
                "Top 10 biggest files and directories in '{}':\n{}",
                directory.display(),
                String::from_utf8(head_stdout.stdout).unwrap()
            );
        }
    }

    Ok(())
}
#
# quick_main!(run);
```

<!--[`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [`Stdio::piped`]: https://doc.rust-lang.org/std/process/struct.Stdio.html
-->
[`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [`Stdio::piped`]: https://doc.rust-lang.org/std/process/struct.Stdio.html
 [`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [`Stdio::piped`]: https://doc.rust-lang.org/std/process/struct.Stdio.html

