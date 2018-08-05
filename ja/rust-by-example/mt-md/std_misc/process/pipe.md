# <!--Pipes--> パイプ

<!--The `std::Child` struct represents a running child process, and exposes the `stdin`, `stdout` and `stderr` handles for interaction with the underlying process via pipes.-->
`std::Child`構造体は実行中の子プロセスを表し、`stdin`、 `stdout`、および`stderr`ハンドルをパイプを介して基礎となるプロセスとのやりとりのために公開します。

```rust,ignore
use std::error::Error;
use std::io::prelude::*;
use std::process::{Command, Stdio};

static PANGRAM: &'static str =
"the quick brown fox jumped over the lazy dog\n";

fn main() {
#    // Spawn the `wc` command
    //  `wc`コマンドを生成する
    let process = match Command::new("wc")
                                .stdin(Stdio::piped())
                                .stdout(Stdio::piped())
                                .spawn() {
        Err(why) => panic!("couldn't spawn wc: {}", why.description()),
        Ok(process) => process,
    };

#    // Write a string to the `stdin` of `wc`.
    //  `wc`の`stdin`に文字列を書き込みます。
    //
#    // `stdin` has type `Option<ChildStdin>`, but since we know this instance
#    // must have one, we can directly `unwrap` it.
    //  `stdin`は`Option<ChildStdin>`型を持ちますが、このインスタンスには1つが必要であることがわかっているので、直接それを`unwrap`することができます。
    match process.stdin.unwrap().write_all(PANGRAM.as_bytes()) {
        Err(why) => panic!("couldn't write to wc stdin: {}",
                           why.description()),
        Ok(_) => println!("sent pangram to wc"),
    }

#    // Because `stdin` does not live after the above calls, it is `drop`ed,
#    // and the pipe is closed.
    // 上記の呼び出しの後で`stdin`は実行されないため、`drop`、パイプは閉じられます。
    //
#    // This is very important, otherwise `wc` wouldn't start processing the
#    // input we just sent.
    // これは非常に重要です。さもなければ、`wc`は今送信した入力の処理を開始しません。

#    // The `stdout` field also has type `Option<ChildStdout>` so must be unwrapped.
    //  `stdout`フィールドには`Option<ChildStdout>`タイプもありますので、アンラップする必要があります。
    let mut s = String::new();
    match process.stdout.unwrap().read_to_string(&mut s) {
        Err(why) => panic!("couldn't read wc stdout: {}",
                           why.description()),
        Ok(_) => print!("wc responded with:\n{}", s),
    }
}
```
