# <!--Conventions--> コンベンション

<!--In the previous chapter, we saw the following directory hierarchy:-->
前の章では、次のディレクトリ階層を確認しました。

```txt
foo
├── Cargo.toml
└── src
    └── main.rs
```

<!--Suppose that we wanted to have two binaries in the same project, though.-->
しかし、同じプロジェクトに2つのバイナリがあるとします。
<!--What then?-->
それでは？

<!--It turns out that `cargo` supports this.-->
`cargo`がこれをサポートしていることが判明しました。
<!--The default binary name is `main.rs`, as we saw before, but you can add additional binaries by placing them in a `bin/` directory:-->
前に見たように、デフォルトのバイナリ名は`main.rs`ですが、バイナリを`bin/`ディレクトリに置くことでバイナリを追加できます：

```txt
foo
├── Cargo.toml
└── src
    ├── main.rs
    └── bin
        └── my_other_bin.rs
```

<!--To tell `cargo` to compile or run this binary as opposed to the default or other binaries, we just pass `cargo` the `--bin my_other_bin` flag, where `my_other_bin` is the name of the binary we want to work with.-->
伝えるために`cargo`デフォルトまたは他のバイナリとは対照的に、このバイナリをコンパイルまたは実行するために、私達はちょうど通過し`cargo` `--bin my_other_bin`フラグ、`my_other_bin`我々が仕事をしたいバイナリの名前です。

<!--In addition to extra binaries, `cargo` supports [more features] such as benchmarks, tests, and examples.-->
余分なバイナリに加えて、`cargo`はベンチマーク、テスト、サンプルなどの[more features]サポートし[more features]。

<!--In the next chapter, we will look more closely at tests.-->
次の章では、テストをより詳しく見ていきます。

[more features]: https://doc.rust-lang.org/cargo/guide/project-layout.html
