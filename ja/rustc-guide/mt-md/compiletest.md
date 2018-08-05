# `compiletest`
## <!--Introduction--> 前書き

<!--`compiletest` is the main test harness of the Rust test suite.-->
`compiletest`は、Rustテストスイートの主要なテストハーネスです。
<!--It allows test authors to organize large numbers of tests (the Rust compiler has many thousands), efficient test execution (parallel execution is supported), and allows the test author to configure behavior and expected results of both individual and groups of tests.-->
これにより、テスト作成者は多数のテスト（Rustコンパイラには数千ものものがあります）、効率的なテスト実行（並列実行がサポートされています）を構成することができ、テスト作成者は個々のテストおよびグループのテストの動作と期待される結果を設定できます。

<!--`compiletest` tests may check test code for success, for failure or in some cases, even failure to compile.-->
`compiletest`テストは、テストコードが成功したかどうか、失敗したかどうか、場合によってはコンパイルが失敗したかどうかをチェックします。
<!--Tests are typically organized as a Rust source file with annotations in comments before and/or within the test code, which serve to direct `compiletest` on if or how to run the test, what behavior to expect, and more.-->
テストは、典型的には、直接のに役立つの前および/またはテストコード内のコメントで注釈を錆ソースファイルとして編成され`compiletest`、IFまたはどのようにテストを実行するのを期待するのはどのような行動、そしてより多くの。
<!--If you are unfamiliar with the compiler testing framework, see [this chapter](./tests/intro.html) for additional background.-->
コンパイラのテストフレームワークに慣れていない場合は、[この章](./tests/intro.html)で追加の背景を参照してください。

<!--The tests themselves are typically (but not always) organized into "suites"– for example, `run-pass`, a folder representing tests that should succeed, `run-fail`, a folder holding tests that should compile successfully, but return a failure (non-zero status), `compile-fail`, a folder holding tests that should fail to compile, and many more.-->
テスト自体は、通常、`run-pass`、成功するテストを表すフォルダ、 `run-fail`、正常にコンパイルされるべきテストを保持するフォルダ、失敗を返すフォルダなど、（必ずしもそうではない） -zeroステータス）、`compile-fail`、 `compile-fail`したテストを保持するフォルダなどがあります。
<!--The various suites are defined in [src/tools/compiletest/src/common.rs][common] in the `pub struct Config` declaration.-->
さまざまなスイートは、`pub struct Config`宣言の[src/tools/compiletest/src/common.rs][common]に定義されています。
<!--And a very good introduction to the different suites of compiler tests along with details about them can be found in [Adding new tests](./tests/adding.html).-->
コンパイラテストのさまざまなスイートとその詳細については、「 [新しいテストの追加」](./tests/adding.html)を参照してください。

## <!--Adding a new test file--> 新しいテストファイルを追加する

<!--Briefly, simply create your new test in the appropriate location under [src/test][test].-->
簡単に言うと、新しいテストを[src/test][test]適切な場所に作成するだけです。
<!--No registration of test files is necessary as `compiletest` will scan the [src/test][test] subfolder recursively, and will execute any Rust source files it finds as tests.-->
`compiletest`が[src/test][test]サブフォルダを再帰的にスキャンし、[src/test][test]として見つかったRustソースファイルを実行するため、テストファイルの登録は必要ありません。
<!--See [`Adding new tests`](./tests/adding.html) for a complete guide on how to adding new tests.-->
[`Adding new tests`](./tests/adding.html)を[`Adding new tests`](./tests/adding.html)方法の完全なガイドについては、[`Adding new tests`](./tests/adding.html)参照してください。

## <!--Header Commands--> ヘッダーコマンド

<!--Source file annotations which appear in comments near the top of the source file *before* any test code are known as header commands.-->
テストコードの*前に*ソースファイルの先頭近くのコメントに表示されるソースファイルの注釈は、ヘッダコマンドと呼ばれます。
<!--These commands can instruct `compiletest` to ignore this test, set expectations on whether it is expected to succeed at compiling, or what the test's return code is expected to be.-->
これらのコマンドは、`compiletest`にこのテストを無視し、コンパイル時に成功するかどうか、またはテストの戻りコードがどのようになるかについての期待値を設定するように指示できます。
<!--Header commands (and their inline counterparts, Error Info commands) are described more fully [here](./tests/adding.html#header-commands-configuring-rustc).-->
ヘッダーコマンド（およびそのインラインの対応、エラー情報コマンド）については、[here](./tests/adding.html#header-commands-configuring-rustc)詳しく説明し[here](./tests/adding.html#header-commands-configuring-rustc)。

### <!--Adding a new header command--> 新しいヘッダーコマンドを追加する

<!--Header commands are defined in the `TestProps` struct in [src/tools/compiletest/src/header.rs][header].-->
ヘッダーコマンドは、[src/tools/compiletest/src/header.rs][header]の`TestProps`構造体で定義されています。
<!--At a high level, there are dozens of test properties defined here, all set to default values in the `TestProp` struct's `impl` block.-->
高レベルでは、ここで定義された数十のテストプロパティがあり、すべてが`TestProp`構造体の`impl`ブロックのデフォルト値に設定されています。
<!--Any test can override this default value by specifying the property in question as header command as a comment (`//`) in the test source file, before any source code.-->
どのテストでも、このデフォルト値をオーバーライドするには、問題のプロパティをヘッダ・コマンドとしてテスト・ソース・ファイル内のコメント（`//`）としてソース・コードの前に指定します。

#### <!--Using a header command--> ヘッダーコマンドの使用

<!--Here is an example, specifying the `must-compile-successfully` header command, which takes no arguments, followed by the `failure-status` header command, which takes a single argument (which, in this case is a value of 1).-->
ここでは、引数をとらない`must-compile-successfully`ヘッダーコマンドを指定する例を示します.1つの引数（この場合は値1）を取る`failure-status`ヘッダーコマンドが続きます。
<!--`failure-status` is instructing `compiletest` to expect a failure status of 1 (rather than the current Rust default of 101 at the time of this writing).-->
`failure-status`は、`compiletest`に対して、現在のRustのデフォルト値101が、この執筆時点ではなく、1というエラーステータスを期待するように指示しています。
<!--The header command and the argument list (if present) are typically separated by a colon:-->
ヘッダーコマンドと引数リスト（存在する場合）は、通常、コロンで区切られます。

```rust,ignore
#// Copyright 2018 The Rust Project Developers. See the COPYRIGHT
#// file at the top-level directory of this distribution and at
#// http://rust-lang.org/COPYRIGHT.
// 著作権2018錆プロジェクトの開発者。このディストリビューションのトップレベルのディレクトリであるCOPYRIGHTファイルとhttp://rust-lang.org/COPYRIGHTを参照してください。
//
#// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
#// http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
#// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
#// option. This file may not be copied, modified, or distributed
#// except according to those terms.
//  Apache License、Version 2.0でライセンスまたはMITライセンス、あなたの選択で。このファイルは、これらの条項を除き、コピー、変更、または配布することはできません。

#// must-compile-successfully
#// failure-status: 1
//  must-compile-successful失敗ステータス：1

#![feature(termination_trait)]

use std::io::{Error, ErrorKind};

fn main() -> Result<(), Box<Error>> {
    Err(Box::new(Error::new(ErrorKind::Other, "returned Box<Error> from main()")))
}
```

#### <!--Adding a new header command property--> 新しいヘッダーコマンドプロパティを追加する

<!--One would add a new header command if there is a need to define some test property or behavior on an individual, test-by-test basis.-->
個々のテストプロパティまたは動作をテストごとに定義する必要がある場合は、新しいヘッダーコマンドを追加します。
<!--A header command property serves as the header command's backing store (holds the command's current value) at runtime.-->
ヘッダーコマンドプロパティは、実行時にヘッダーコマンドのバッキングストアとして機能します（コマンドの現在の値を保持します）。

<!--To add a new header command property: 1. Look for the `pub struct TestProps` declaration in [src/tools/compiletest/src/header.rs][header] and add the new public property to the end of the declaration.-->
新しいヘッダーコマンドプロパティを追加するには：1. [src/tools/compiletest/src/header.rs][header] `pub struct TestProps`宣言を探し、宣言の最後に新しいパブリックプロパティを追加します。
<!--2. Look for the `impl TestProps` implementation block immediately following the struct declaration and initialize the new property to its default value.-->
2.構造体宣言の直後にある`impl TestProps`実装ブロックを探し、新しいプロパティーをデフォルト値に初期化します。

#### <!--Adding a new header command parser--> 新しいヘッダーコマンドパーサーを追加する

<!--When `compiletest` encounters a test file, it parses the file a line at a time by calling every parser defined in the `Config` struct's implementation block, also in [src/tools/compiletest/src/header.rs][header] (note the `Config` struct's declaration block is found in [src/tools/compiletest/src/common.rs][common]. `TestProps` 's `load_from()` method will try passing the current line of text to each parser, which, in turn typically checks to see if the line begins with a particular commented (`//`) header command such as `// must-compile-successfully` or `// failure-status`. Whitespace after the comment marker is optional.-->
`compiletest`がテストファイルに遭遇すると、[src/tools/compiletest/src/header.rs][header]の`Config`構造体の実装ブロックで定義されたすべてのパーサーを呼び出すことで、一度に1行ずつファイルを解析します（`Config`構造体の宣言ブロックが見つかります`TestProps`の`load_from()`メソッドは、現在のテキスト行を各パーサに渡してみます。各パーサは、通常、その行が特定のコメント付きで始まるかどうかを確認します[src/tools/compiletest/src/common.rs][common] `//`）ヘッダーコマンド（ `// must-compile-successfully`または`// failure-status`。コメントマーカーの後の空白はオプションです。

<!--Parsers will override a given header command property's default value merely by being specified in the test file as a header command or by having a parameter value specified in the test file, depending on the header command.-->
パーサーは、ヘッダーコマンドとしてテストファイルで指定されるか、ヘッダーコマンドに応じてテストファイルで指定されたパラメーター値を持つことによって、特定のヘッダーコマンドプロパティーのデフォルト値をオーバーライドします。

<!--Parsers defined in `impl Config` are typically named `parse_<header_command>` (note kebab-case `<header-command>` transformed to snake-case `<header_command>`).-->
`impl Config`定義されたパーサーは、通常、`parse_<header_command>`という名前に`parse_<header_command>`（ `parse_<header_command>` -case `<header-command>`はsnake-case `<header_command>`変換され`<header_command>`）。
<!--`impl Config` also defines several 'low-level' parsers which make it simple to parse common patterns like simple presence or not (`parse_name_directive()`), header-command:parameter(s) (`parse_name_value_directive()`), optional parsing only if a particular `cfg` attribute is defined (`has_cfg_prefix()`) and many more.-->
`impl Config`、単純な存在またはしないような一般的なパターンを解析することを簡単にいくつかの「低レベル」パーサーを定義する（ `parse_name_directive()`ヘッダコマンド：パラメータ（複数可）（`parse_name_value_directive()`オプションの解析のみ、特定の場合`cfg`属性が定義されています（`has_cfg_prefix()`）。
<!--The low-level parsers are found near the end of the `impl Config` block;-->
低レベルのパーサーは、`impl Config`ブロックの終わり近くにあります。
<!--be sure to look through them and their associated parsers immediately above to see how they are used to avoid writing additional parsing code unneccessarily.-->
すぐ上にあるそれらとそれに関連するパーサを調べて、追加の解析コードを不必要に書き込むのを避けるためにどのように使用されているかを確認してください。

<!--As a concrete example, here is the implementation for the `parse_failure_status()` parser, in [src/tools/compiletest/src/header.rs][header]:-->
具体的な例として、[src/tools/compiletest/src/header.rs][header]の`parse_failure_status()`パーサーの実装を次に`parse_failure_status()` [src/tools/compiletest/src/header.rs][header]。

```diff
@@ -232,6 +232,7 @@ pub struct TestProps {
#     // customized normalization rules
     // カスタマイズされた正規化ルール
     pub normalize_stdout: Vec<(String, String)>,
     pub normalize_stderr: Vec<(String, String)>,
+    pub failure_status: i32,
 }

 impl TestProps {
@@ -260,6 +261,7 @@ impl TestProps {
             run_pass: false,
             normalize_stdout: vec![],
             normalize_stderr: vec![],
+            failure_status: 101,
         }
     }

@@ -383,6 +385,10 @@ impl TestProps {
             if let Some(rule) = config.parse_custom_normalization(ln, "normalize-stderr") {
                 self.normalize_stderr.push(rule);
             }
+
+            if let Some(code) = config.parse_failure_status(ln) {
+                self.failure_status = code;
+            }
         });

         for key in &["RUST_TEST_NOCAPTURE", "RUST_TEST_THREADS"] {
@@ -488,6 +494,13 @@ impl Config {
         self.parse_name_directive(line, "pretty-compare-only")
     }

+    fn parse_failure_status(&self, line: &str) -> Option<i32> {
+        match self.parse_name_value_directive(line, "failure-status") {
+            Some(code) => code.trim().parse::<i32>().ok(),
+            _ => None,
+        }
+    }
```

## <!--Implementing the behavior change--> 行動変更の実装

<!--When a test invokes a particular header command, it is expected that some behavior will change as a result.-->
テストで特定のヘッダーコマンドが呼び出されると、結果としていくつかの動作が変わることが予想されます。
<!--What behavior, obviously, will depend on the purpose of the header command.-->
明らかに、どのような振る舞いがヘッダーコマンドの目的に依存するでしょうか。
<!--In the case of `failure-status`, the behavior that changes is that `compiletest` expects the failure code defined by the header command invoked in the test, rather than the default value.-->
`failure-status`場合、変更される動作は、`compiletest`が、デフォルト値ではなく、テストで呼び出されたヘッダーコマンドによって定義された失敗コードを予期していることです。

<!--Although specific to `failure-status` (as every header command will have a different implementation in order to invoke behavior change) perhaps it is helpful to see the behavior change implementation of one case, simply as an example.-->
`failure-status`特有です（すべてのヘッダーコマンドが動作変更を呼び出すために異なる実装を持つため）場合がありますが、たぶん例として、1つのケースの動作変更実装を確認すると役に立ちます。
<!--To implement `failure-status`, the `check_correct_failure_status()` function found in the `TestCx` implementation block, located in [src/tools/compiletest/src/runtest.rs](https://github.com/rust-lang/rust/tree/master/src/tools/compiletest/src/runtest.rs), was modified as per below:-->
`failure-status`を実装する`failure-status`に、[src/tools/compiletest/src/runtest.rs](https://github.com/rust-lang/rust/tree/master/src/tools/compiletest/src/runtest.rs)にある`TestCx`実装ブロックにある`check_correct_failure_status()`関数を以下のように変更しました：

```diff
@@ -295,11 +295,14 @@ impl<'test> TestCx<'test> {
     }

     fn check_correct_failure_status(&self, proc_res: &ProcRes) {
#//-        // The value the rust runtime returns on failure
-        // 錆ランタイムが失敗したときに返す値
-        const RUST_ERR: i32 = 101;
-        if proc_res.status.code() != Some(RUST_ERR) {
+        let expected_status = Some(self.props.failure_status);
+        let received_status = proc_res.status.code();
+
+        if expected_status != received_status {
             self.fatal_proc_rec(
-                &format!("failure produced the wrong error: {}", proc_res.status),
+                &format!("Error: expected failure status ({:?}) but received status {:?}.",
+                         expected_status,
+                         received_status),
                 proc_res,
             );
         }
@@ -320,7 +323,6 @@ impl<'test> TestCx<'test> {
         );

         let proc_res = self.exec_compiled_test();
-
         if !proc_res.status.success() {
             self.fatal_proc_rec("test run failed!", &proc_res);
         }
@@ -499,7 +501,6 @@ impl<'test> TestCx<'test> {
                 expected,
                 actual
             );
-            panic!();
         }
     }
```
<!--Note the use of `self.props.failure_status` to access the header command property.-->
`self.props.failure_status`を使用してheaderコマンド・プロパティにアクセスすることに注意してください。
<!--In tests which do not specify the failure status header command, `self.props.failure_status` will evaluate to the default value of 101 at the time of this writing.-->
failure status headerコマンドを指定しないテストでは、`self.props.failure_status`はこの書き込みの時点でデフォルト値の101に評価されます。
<!--But for a test which specifies a header command of, for example, `// failure-status: 1`, `self.props.failure_status` will evaluate to 1, as `parse_failure_status()` will have overridden the `TestProps` default value, for that test specifically.-->
しかし、例えば、ヘッダのコマンドを指定し、テストするための、`// failure-status: 1`、 `self.props.failure_status`として、1と評価される`parse_failure_status()`オーバーライドされているであろう`TestProps`具体その試験のために、デフォルト値。

<!--[test]: https://github.com/rust-lang/rust/tree/master/src/test
 [header]: https://github.com/rust-lang/rust/tree/master/src/tools/compiletest/src/header.rs
 [common]: https://github.com/rust-lang/rust/tree/master/src/tools/compiletest/src/common.rs
-->
[test]: https://github.com/rust-lang/rust/tree/master/src/test
 [header]: https://github.com/rust-lang/rust/tree/master/src/tools/compiletest/src/header.rs
 [common]: https://github.com/rust-lang/rust/tree/master/src/tools/compiletest/src/common.rs

