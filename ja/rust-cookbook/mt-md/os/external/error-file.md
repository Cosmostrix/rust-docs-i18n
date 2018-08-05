## <!--Redirect both stdout and stderr of child process to the same file--> 子プロセスのstdoutとstderrの両方を同じファイルにリダイレクトする

<!--[!][std]-->
[！][std]
<!--[std-badge] [!][cat-os]-->
[std-badge] [！][cat-os]
[cat-os-badge]
<!--Spawns a child process and redirects `stdout` and `stderr` to the same file.-->
子プロセスを生成し、`stdout`と`stderr`を同じファイルにリダイレクトします。
<!--It follows the same idea as [run piped external commands](#run-piped-external-commands), however [`process::Stdio`] writes to a specified file.-->
これは[pipedの外部コマンド](#run-piped-external-commands)を[実行](#run-piped-external-commands)するのと同じ考え方に従い[ますが](#run-piped-external-commands)、 [`process::Stdio`]は指定されたファイルに書き込みます。
<!--[`File::try_clone`] references the same file handle for `stdout` and `stderr`.-->
[`File::try_clone`]は`stdout`と`stderr`と同じファイルハンドルを参照します。
<!--It will ensure that both handles write with the same cursor position.-->
両方のハンドルが同じカーソル位置で確実に書き込まれます。

<!--The below recipe is equivalent to run the Unix shell command `ls . oops >out.txt 2>&1`-->
以下のレシピは、Unixシェルコマンド`ls . oops >out.txt 2>&1`を実行するのと等価`ls . oops >out.txt 2>&1`
<!--`ls . oops >out.txt 2>&1`.-->
`ls . oops >out.txt 2>&1`。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
#
use std::fs::File;
use std::process::{Command, Stdio};

# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#     }
# }
#
fn run() -> Result<()> {
    let outputs = File::create("out.txt")?;
    let errors = outputs.try_clone()?;

    Command::new("ls")
        .args(&[".", "oops"])
        .stdout(Stdio::from(outputs))
        .stderr(Stdio::from(errors))
        .spawn()?
        .wait_with_output()?;

    Ok(())
}
#
# quick_main!(run);
```

<!--[`File::try_clone`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.try_clone
 [`process::Stdio`]: https://doc.rust-lang.org/std/process/struct.Stdio.html
-->
[`File::try_clone`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.try_clone
 [`process::Stdio`]: https://doc.rust-lang.org/std/process/struct.Stdio.html

