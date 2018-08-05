# <!--Custom--> カスタム

<!--Some conditionals like `target_os` are implicitly provided by `rustc`, but custom conditionals must be passed to `rustc` using the `--cfg` flag.-->
以下のようないくつかの条件文`target_os`暗黙のうちから提供されている`rustc`が、カスタムの条件文はに渡さなければなりません`rustc`使用`--cfg`フラグを。

```rust,editable,ignore,mdbook-runnable
#[cfg(some_condition)]
fn conditional_function() {
    println!("condition met!");
}

fn main() {
    conditional_function();
}
```

<!--Try to run this to see what happens without the custom `cfg` flag.-->
これを実行して、カスタム`cfg`フラグなしで何が起こるかを確認してください。

<!--With the custom `cfg` flag:-->
カスタム`cfg`フラグを使用すると：

```bash
$ rustc --cfg some_condition custom.rs && ./custom
condition met!
```
