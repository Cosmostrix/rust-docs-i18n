# <!--Unit testing--> 単体テスト

<!--Tests are Rust functions that verify that the non-test code is functioning in the expected manner.-->
テストは、非テストコードが期待どおりに機能していることを検証するRust関数です。
<!--The bodies of test functions typically perform some setup, run the code we want to test, then assert whether the results are what we expect.-->
テスト関数の本体は、通常、いくつかのセットアップを実行し、テストしたいコードを実行し、結果が期待どおりかどうかをアサートします。

<!--Most unit tests go into a `tests` [mod][mod] with the `#[cfg(test)]` [attribute][attribute].-->
ほとんどの単体テストは`#[cfg(test)]` [attribute][attribute]を持つ`tests` [mod][mod]入り[attribute][attribute]。
<!--Test functions are marked with the `#[test]` attribute.-->
テスト関数は`#[test]`属性でマークされています。

<!--Tests fail when something in the test function [panics][panic].-->
テスト機能で何かが[panics][panic]すると、テストは失敗します。
<!--There are some helper [macros][macros]:-->
いくつかのヘルパー[macros][macros]があり[macros][macros]：

* <!--`assert!(expression)` -panics if expression evaluates to `false`.-->
   `assert!(expression)` -式が`false`評価された場合のパニック。
* <!--`assert_eq!(left, right)` and `assert_ne!(left, right)` -testing left and right expressions for equality and inequality respectively.-->
   `assert_eq!(left, right)`と`assert_ne!(left, right)` -左右の式を等価と不等式のそれぞれについてテストする。

```rust,ignore
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#// This is a really bad adding function, its purpose is to fail in this
#// example.
// これは本当に悪い追加関数です、その目的はこの例では失敗することです。
#[allow(dead_code)]
fn bad_add(a: i32, b: i32) -> i32 {
    a - b
}

#[cfg(test)]
mod tests {
#    // Note this useful idiom: importing names from outer (for mod tests) scope.
    // この便利なイディオムに注意してください：外部（modテスト用）スコープからの名前のインポート。
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(1, 2), 3);
    }

    #[test]
    fn test_bad_add() {
#        // This assert would fire and test will fail.
#        // Please note, that private functions can be tested too!
        // この主張は発砲し、テストは失敗するでしょう。プライベートな機能もテストできることに注意してください。
        assert_eq!(bad_add(1, 2), 3);
    }
}
```

<!--Tests can be run with `cargo test`.-->
テストは`cargo test`で実行できます。

```bash
$ cargo test

running 2 tests
test tests::test_bad_add ... FAILED
test tests::test_add ... ok

failures:

---- tests::test_bad_add stdout ----
        thread 'tests::test_bad_add' panicked at 'assertion failed: `(left == right)`
  left: `-1`,
 right: `3`', src/lib.rs:21:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.


failures:
    tests::test_bad_add

test result: FAILED. 1 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out
```

## <!--Testing panics--> テストパニック

<!--To check functions that should panic under certain circumstances, use attribute `#[should_panic]`.-->
特定の状況下でパニックする機能をチェックするには、attribute `#[should_panic]`使用します。
<!--This attribute accepts optional parameter `expected =` with the text of the panic message.-->
この属性は、オプションのパラメータ`expected =`をパニックメッセージのテキストとともに受け付けます。
<!--If your function can panic in multiple ways, it helps make sure your test is testing the correct panic.-->
関数が複数の方法でパニックに陥る可能性がある場合は、テストが正しいパニックをテストしていることを確認するのに役立ちます。

```rust,ignore
pub fn divide_non_zero_result(a: u32, b: u32) -> u32 {
    if b == 0 {
        panic!("Divide-by-zero error");
    } else if a < b {
        panic!("Divide result is zero");
    }
    a / b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_divide() {
        assert_eq!(divide_non_zero_result(10, 2), 5);
    }

    #[test]
    #[should_panic]
    fn test_any_panic() {
        divide_non_zero_result(1, 0);
    }

    #[test]
    #[should_panic(expected = "Divide result is zero")]
    fn test_specific_panic() {
        divide_non_zero_result(1, 10);
    }
}
```

<!--Running these tests gives us:-->
これらのテストを実行すると、

```bash
$ cargo test

running 3 tests
test tests::test_any_panic ... ok
test tests::test_divide ... ok
test tests::test_specific_panic ... ok

test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

   Doc-tests tmp-test-should-panic

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

## <!--Running specific tests--> 特定のテストの実行

<!--To run specific tests one may specify the test name to `cargo test` command.-->
特定のテストを実行するには、`cargo test`コマンドにテスト名を指定します。

```bash
$ cargo test test_any_panic
running 1 test
test tests::test_any_panic ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 2 filtered out

   Doc-tests tmp-test-should-panic

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

<!--To run multiple tests one may specify part of a test name that matches all the tests that should be run.-->
複数のテストを実行するには、実行する必要があるすべてのテストに一致するテスト名の一部を指定します。

```bash
$ cargo test panic
running 2 tests
test tests::test_any_panic ... ok
test tests::test_specific_panic ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured; 1 filtered out

   Doc-tests tmp-test-should-panic

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

## <!--Ignoring tests--> テストを無視する

<!--Tests can be marked with the `#[ignore]` attribute to exclude some tests.-->
いくつかのテストを除外するには、`#[ignore]`属性を付けてテストすることができます。
<!--Or to run them with command `cargo test -- --ignored`-->
またはコマンド`cargo test -- --ignored`それらを実行する`cargo test -- --ignored`

```rust
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 2), 4);
    }

    #[test]
    fn test_add_hundred() {
        assert_eq!(add(100, 2), 102);
        assert_eq!(add(2, 100), 102);
    }

    #[test]
    #[ignore]
    fn ignored_test() {
        assert_eq!(add(0, 0), 0);
    }
}
```

```bash
$ cargo test
running 1 test
test tests::ignored_test ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out

   Doc-tests tmp-ignore

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

$ cargo test -- --ignored
running 1 test
test tests::ignored_test ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

   Doc-tests tmp-ignore

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

<!--[attribute]: attribute.html
 [panic]: std/panic.html
 [macros]: macros.html
 [mod]: mod.html
-->
[attribute]: attribute.html
 [panic]: std/panic.html
 [macros]: macros.html
 [mod]: mod.html

