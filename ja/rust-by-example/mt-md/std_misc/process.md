# <!--Child processes--> 子プロセス

<!--The `process::Output` struct represents the output of a finished child process, and the `process::Command` struct is a process builder.-->
`process::Output`構造体は完成した子プロセスの出力を表し、`process::Command`構造体はプロセスビルダーです。

```rust,editable,ignore
use std::process::Command;

fn main() {
    let output = Command::new("rustc")
        .arg("--version")
        .output().unwrap_or_else(|e| {
            panic!("failed to execute process: {}", e)
    });

    if output.status.success() {
        let s = String::from_utf8_lossy(&output.stdout);

        print!("rustc succeeded and stdout was:\n{}", s);
    } else {
        let s = String::from_utf8_lossy(&output.stderr);

        print!("rustc failed and stderr was:\n{}", s);
    }
}
```

<!--(You are encouraged to try the previous example with an incorrect flag passed to `rustc`)-->
（`rustc`渡された不正なフラグを使って前の例を試してみることをお勧めします）
