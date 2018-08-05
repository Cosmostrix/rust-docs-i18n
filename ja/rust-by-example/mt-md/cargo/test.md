# <!--Testing--> テスト

<!--As we know testing is integral to any piece of software!-->
私たちが知っているように、テストはソフトウェアのあらゆる部分に不可欠です！
<!--Rust has first-class support for unit and integration testing ([see this chapter](https://doc.rust-lang.org/book/second-edition/ch11-00-testing.html) in TRPL).-->
Rustは、ユニットテストと統合テストの第一級サポートを提供しています（TRPLの[この章](https://doc.rust-lang.org/book/second-edition/ch11-00-testing.html)を参照）。

<!--From the testing chapters linked above, we see how to write unit tests and integration tests.-->
上にリンクされたテストの章から、単体テストと統合テストの記述方法を見ていきます。
<!--Organizationally, we can place unit tests in the modules they test and integration tests in their own `tests/` directory:-->
組織的には、単体テストをモジュール内に置くことができます。単体テストは、自分自身の`tests/`ディレクトリ内のテストと統合テストに配置でき`tests/`。

```txt
foo
├── Cargo.toml
├── src
│   └── main.rs
└── tests
    ├── my_test.rs
    └── my_other_test.rs
```

<!--Each file in `tests` is a separate integration test.-->
`tests`各ファイルは別々の統合テストです。

<!--`cargo` naturally provides an easy way to run all of your tests!-->
自然に`cargo`があなたのテストをすべて実行する簡単な方法を提供します！

```sh
cargo test
```

<!--You should see output like this:-->
次のような出力が表示されます。

```txt
$ cargo test
   Compiling blah v0.1.0 (file:///nobackup/blah)
    Finished dev [unoptimized + debuginfo] target(s) in 0.89 secs
     Running target/debug/deps/blah-d3b32b97275ec472

running 3 tests
test test_bar ... ok
test test_baz ... ok
test test_foo_bar ... ok
test test_foo ... ok

test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

<!--You can also run tests whose name matches a pattern:-->
名前がパターンに一致するテストを実行することもできます。

```sh
cargo test test_foo
```

```txt
$ cargo test test_foo
   Compiling blah v0.1.0 (file:///nobackup/blah)
    Finished dev [unoptimized + debuginfo] target(s) in 0.35 secs
     Running target/debug/deps/blah-d3b32b97275ec472

running 2 tests
test test_foo ... ok
test test_foo_bar ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured; 2 filtered out
```

<!--One word of caution: Cargo may run multiple tests concurrently, so make sure that they don't race with each other.-->
1つの注意点：貨物は複数のテストを同時に実行する可能性があるため、互いに競合しないように注意してください。
<!--For example, if they all output to a file, you should make them write to different files.-->
たとえば、ファイルにすべて出力する場合は、別のファイルに書き込むようにする必要があります。
