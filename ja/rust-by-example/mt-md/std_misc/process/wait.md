# <!--Wait--> 待つ

<!--If you'd like to wait for a `process::Child` to finish, you must call `Child::wait`, which will return a `process::ExitStatus`.-->
`process::Child`が終了するのを待つ場合は、`Child::wait`呼び出す必要があります。これは、`process::ExitStatus`ます。

```rust,ignore
use std::process::Command;

fn main() {
    let mut child = Command::new("sleep").arg("5").spawn().unwrap();
    let _result = child.wait().unwrap();

    println!("reached end of main");
}
```

```bash
$ rustc wait.rs && ./wait
# `wait` keeps running for 5 seconds until the `sleep 5` command finishes
reached end of main
```
