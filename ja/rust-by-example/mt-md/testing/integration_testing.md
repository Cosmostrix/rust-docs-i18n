# <!--Integration testing--> 統合テスト

<!--[Unit tests][unit] are testing one module in isolation at a time: they're small and can test private code.-->
[単体テスト][unit]は、一度に1つのモジュールを単独でテストしています。それらは小さく、プライベートコードをテストできます。
<!--Integration tests are external to your crate and use only its public interface in the same way any other code would.-->
統合テストは、あなたのクレートの外部にあり、他のコードと同じ方法でパブリックインターフェイスのみを使用します。
<!--Their purpose is to test that many parts of your library work correctly together.-->
その目的は、図書館の多くの部分が正しく機能することをテストすることです。

<!--Cargo looks for integration tests in `tests` directory next to `src`.-->
Cargoは、`src`隣の`tests`ディレクトリで統合テストを探します。

<!--File `src/lib.rs`:-->
ファイル`src/lib.rs`：

```rust,ignore
#// Assume that crate is called adder, will have to extern it in integration test.
// クレートは加算器と呼ばれ、積分テストでそれをexternする必要があると仮定します。
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

<!--File with test: `tests/integration_test.rs`:-->
テストファイル： `tests/integration_test.rs`：

```rust,ignore
#// extern crate we're testing, same as any other code would do.
// 私たちがテストしている外部クレートは、他のコードと同じです。
extern crate adder;

#[test]
fn test_add() {
    assert_eq!(adder::add(3, 2), 5);
}
```

<!--Running tests with `cargo test` command:-->
`cargo test`コマンドによる`cargo test`実行：

```bash
$ cargo test
running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

     Running target/debug/deps/integration_test-bcd60824f5fbfe19

running 1 test
test test_add ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

<!--Each Rust source file in `tests` directory is compiled as a separate crate.-->
`tests`ディレクトリー内の各Rustソースファイルは、個別のクレートとしてコンパイルされます。
<!--One way of sharing some code between integration tests is making module with public functions, importing and using it within tests.-->
統合テストの間にいくつかのコードを共有する方法の1つは、パブリック関数を持つモジュールを作成し、テスト内でインポートして使用することです。

<!--File `tests/common.rs`:-->
ファイル`tests/common.rs`：

```rust,ignore
pub fn setup() {
#    // some setup code, like creating required files/directories, starting
#    // servers, etc.
    // 必要なファイルやディレクトリの作成、サーバーの起動など、いくつかのセットアップコード
}
```

<!--File with test: `tests/integration_test.rs`-->
テストファイル： `tests/integration_test.rs`

```rust,ignore
#// extern crate we're testing, same as any other code will do.
// 私たちがテストしている外部クレートは、他のコードと同じです。
extern crate adder;

#// importing common module.
// 共通モジュールをインポートする。
mod common;

#[test]
fn test_add() {
#    // using common code.
    // 共通コードを使用します。
    common::setup();
    assert_eq!(adder::add(3, 2), 5);
}
```

<!--Modules with common code follow the ordinary [modules][mod] rules, so it's ok to create common module as `tests/common/mod.rs`.-->
共通のコードを持つモジュールは通常の[modules][mod]ルールに従います。したがって、共通のモジュールを`tests/common/mod.rs`として作成することはできます。

<!--[unit]: testing/unit_testing.html
 [mod]: mod.html
-->
[unit]: testing/unit_testing.html
 [mod]: mod.html

