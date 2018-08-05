# <!--Adding new tests--> 新しいテストの追加

<!--**In general, we expect every PR that fixes a bug in rustc to come accompanied by a regression test of some kind.**-->
**一般的に、rustcのバグを修正したすべてのPRには、何らかの回帰テストが伴うことが予想されます。**
<!--This test should fail in master but pass after the PR.-->
このテストはマスターで失敗しますが、PRの後に合格します。
<!--These tests are really useful for preventing us from repeating the mistakes of the past.-->
これらのテストは、私たちが過去の過ちを繰り返さないようにするのに役立ちます。

<!--To add a new test, the first thing you generally do is to create a file, typically a Rust source file.-->
新しいテストを追加するには、最初に一般的に行うのは、ファイル、通常はRustソースファイルを作成することです。
<!--Test files have a particular structure:-->
テストファイルの構造は次のとおりです。

- <!--They always begin with the [copyright notice](./conventions.html#copyright);-->
   彼らは常に[著作権表示](./conventions.html#copyright)から始まります。
- <!--then they should have some kind of [comment explaining what the test is about](#explanatory_comment);-->
   [テストの内容を説明するコメント](#explanatory_comment)が必要です。
- <!--next, they can have one or more [header commands](#header_commands), which are special comments that the test interpreter knows how to interpret.-->
   次に、1つ以上の[ヘッダコマンドを](#header_commands)持つことができ[ます](#header_commands)。これは、テストインタープリタが解釈する方法を知っている特別なコメントです。
- <!--finally, they have the Rust source.-->
   最後に、彼らは錆源を持っています。
<!--This may have various [error annotations](#error_annotations) which indicate expected compilation errors or warnings.-->
   これには、予想されるコンパイルエラーまたは警告を示すさまざまな[エラー注釈](#error_annotations)が含まれている可能性があります。

<!--Depending on the test suite, there may be some other details to be aware of: -For [the `ui` test suite](#ui), you need to generate reference output files.-->
テストスイートによっては、注意すべきいくつかの他の詳細があるかもしれません： -のため[`のUI`テストスイート](#ui)には、リファレンス出力ファイルを生成する必要があります。

## <!--What kind of test should I add?--> どんなテストを追加すればいいですか？

<!--It can be difficult to know what kind of test to use.-->
使用するテストの種類を知ることは難しいかもしれません。
<!--Here are some rough heuristics:-->
ここにいくつかの大まかなヒューリスティックがあります：

- <!--Some tests have specialized needs:-->
   いくつかのテストには特別なニーズがあります。
  - <!--need to run gdb or lldb?-->
     gdbまたはlldbを実行する必要がありますか？
<!--use the `debuginfo` test suite-->
     `debuginfo`テストスイートを使用する
  - <!--need to inspect LLVM IR or MIR IR?-->
     LLVM IRまたはMIR IRを検査する必要がありますか？
<!--use the `codegen` or `mir-opt` test suites-->
     `codegen`または`mir-opt`テストスイートを使用する
  - <!--need to run rustdoc?-->
     rustdocを実行する必要がありますか？
<!--Prefer a `rustdoc` test-->
     `rustdoc`テストを好む
  - <!--need to inspect the resulting binary in some way?-->
     結果のバイナリを何らかの方法で検査する必要がありますか？
<!--Then use `run-make`-->
     次に、`run-make`使用し`run-make`
- <!--For most other things, [a `ui` (or `ui-fulldeps`) test](#ui) is to be preferred:-->
   ほとんどの場合[、`ui`（または`ui-fulldeps`）のテスト](#ui)が優先されます。
  - <!--`ui` tests subsume both run-pass, compile-fail, and parse-fail tests-->
     `ui`テストは、実行パス、コンパイル失敗、および解析失敗テストの両方を含む
  - <!--in the case of warnings or errors, `ui` tests capture the full output, which makes it easier to review but also helps prevent "hidden"regressions in the output-->
     警告またはエラーが発生した場合、`ui`テストは完全な出力をキャプチャします。これにより、レビューが容易になりますが、出力の「隠れた」回帰を防ぐのにも役立ちます

## <!--Naming your test--> テストの名前付け

<!--We have not traditionally had a lot of structure in the names of tests.-->
私たちは伝統的にテストの名前に多くの構造を持っていませんでした。
<!--Moreover, for a long time, the rustc test runner did not support subdirectories (it now does), so test suites like [`src/test/run-pass`] have a huge mess of files in them.-->
さらに、長い間、rustcテストランナーはサブディレクトリをサポートしていませんでした（現在はそうです）。したがって、[`src/test/run-pass`]ようなテストスイートには、ファイルの大混乱があります。
<!--This is not considered an ideal setup.-->
これは理想的な設定ではありません。

[`src/test/run-pass`]: https://github.com/rust-lang/rust/tree/master/src/test/run-pass/

<!--For regression tests – basically, some random snippet of code that came in from the internet – we often just name the test after the issue.-->
回帰テスト -基本的に、インターネットから入ったコードのランダムな断片 -私たちはしばしば問題の後にテストの名前をつけます。
<!--For example, `src/test/run-pass/issue-12345.rs`.-->
たとえば、`src/test/run-pass/issue-12345.rs`ます。
<!--If possible, though, it is better if you can put the test into a directory that helps identify what piece of code is being tested here (eg, `borrowck/issue-12345.rs` is much better), or perhaps give it a more meaningful name.-->
可能であれば、ここでテストされているコードの識別に役立つディレクトリにテストを入れることができれば（例えば、`borrowck/issue-12345.rs`がはるかに優れています）、もっと意味のある名。
<!--Still, **do include the issue number somewhere**.-->
それでも、**どこかに問題番号を記載してください**。

<!--When writing a new feature, **create a subdirectory to store your tests**.-->
新しいフィーチャーを**作成する**ときは**、テストを保管するサブディレクトリーを作成します**。
<!--For example, if you are implementing RFC 1234 ("Widgets"), then it might make sense to put the tests in directories like:-->
たとえば、RFC 1234（「Widgets」）を実装している場合は、次のようなディレクトリにテストを置くことができます。

- `src/test/ui/rfc1234-widgets/`
- `src/test/run-pass/rfc1234-widgets/`
- <!--etc-->
   等

<!--In other cases, there may already be a suitable directory.-->
それ以外の場合は、既に適切なディレクトリが存在する可能性があります。
<!--(The proper directory structure to use is actually an area of active debate.)-->
（使用する適切なディレクトリ構造は実際には活発な議論の領域です。）

<span id="explanatory_comment"></span>
## <!--Comment explaining what the test is about--> テストの内容を説明するコメント

<!--When you create a test file, **include a comment summarizing the point of the test immediately after the copyright notice**.-->
テストファイルを作成するときは**、著作権表示の直後にテストポイントを要約するコメントを入れて**ください。
<!--This should highlight which parts of the test are more important, and what the bug was that the test is fixing.-->
これは、テストのどの部分がより重要であるか、そしてテストが修正しているバグが何かを強調する必要があります。
<!--Citing an issue number is often very helpful.-->
発行番号を引用すると、多くの場合非常に役立ちます。

<!--This comment doesn't have to be super extensive.-->
このコメントは、非常に広範である必要はありません。
<!--Just something like "Regression test for #18060: match arms were matching in the wrong order."-->
「＃18060の回帰テスト：マッチした武器が間違った順番で一致していました。
<!--might already be enough.-->
すでに十分かもしれない。

<!--These comments are very useful to others later on when your test breaks, since they often can highlight what the problem is.-->
これらのコメントは、後でテストが中断したときに他の人に非常に役立ちます。なぜなら、問題の内容を強調することが多いからです。
<!--They are also useful if for some reason the tests need to be refactored, since they let others know which parts of the test were important (often a test must be rewritten because it no longer tests what is was meant to test, and then it's useful to know what it *was* meant to test exactly).-->
何らかの理由でテストをリファクタリングする必要がある場合は、テストのどの部分が重要であるかを他の人に知らせるので便利です（多くの場合、テストの対象となったものをテストしないためにテストを書き直す必要があります。それ*が*正確にテスト*される*ことを意図してい*た*ことを知る）。

<span id="header_commands"></span>
## <!--Header commands: configuring rustc--> ヘッダーコマンド：rustcの設定

<!--Header commands are special comments that the test runner knows how to interpret.-->
ヘッダーコマンドは、テストランナーが解釈する方法を知っている特別なコメントです。
<!--They must appear before the Rust source in the test.-->
テストでRustソースの前に現れなければなりません。
<!--They are normally put after the short comment that explains the point of this test.-->
彼らは通常このテストのポイントを説明する短いコメントの後に置かれます。
<!--For example, this test uses the `// compile-flags` command to specify a custom flag to give to rustc when the test is compiled:-->
たとえば、このテストでは、`// compile-flags`に`// compile-flags`コマンドを使用してrustcに与えるカスタムフラグを指定します。

```rust,ignore
#// Copyright 2017 The Rust Project Developers. blah blah blah.
#// ...
#// except according to those terms.
// 著作権2017錆プロジェクトの開発者。何とか何とか何とか。...それらの用語による以外は...

#// Test the behavior of `0 - 1` when overflow checks are disabled.
// オーバーフローチェックが無効の場合、`0 - 1`動作をテストします。

#// compile-flags: -Coverflow-checks=off
// コンパイルフラグ：-Coverflow-checks = off

fn main() {
    let x = 0 - 1;
    ...
}
```

### <!--Ignoring tests--> テストを無視する

<!--These are used to ignore the test in some situations, which means the test won't be compiled or run.-->
これらは、状況によってはテストを無視するために使用されます。つまり、テストはコンパイルまたは実行されません。

* <!--`ignore-X` where `X` is a target detail or stage will ignore the test accordingly (see below)-->
   `ignore-X`ここで、`X`はターゲットのディテールまたはステージであり、それに応じてテストが無視されます（下記参照）
* <!--`only-X` is like `ignore-X`, but will *only* run the test on that target or stage-->
   `only-X`は`ignore-X` `only-X`と似ていますが、そのターゲットまたはステージで*のみ*テストを実行します
* <!--`ignore-pretty` will not compile the pretty-printed test (this is done to test the pretty-printer, but might not always work)-->
   `ignore-pretty`はpretty-printedテストをコンパイルしません（これはpretty-printerをテストするために行われますが、必ずしもうまくいかないかもしれません）
* <!--`ignore-test` always ignores the test-->
   `ignore-test`常に`ignore-test`を無視します
* <!--`ignore-lldb` and `ignore-gdb` will skip a debuginfo test on that debugger.-->
   `ignore-lldb`と`ignore-gdb`はそのデバッガでdebuginfoテストをスキップします。

<!--Some examples of `X` in `ignore-X`:-->
`ignore-X` `X`例をいくつか示します。

* <!--Architecture: `aarch64`, `arm`, `asmjs`, `mips`, `wasm32`, `x86_64`, `x86`,...-->
   アーキテクチャ： `aarch64`、 `arm`、 `asmjs`、 `mips`、 `wasm32`、 `x86_64`、 `x86`、...
* <!--OS: `android`, `emscripten`, `freebsd`, `ios`, `linux`, `macos`, `windows`,...-->
   OS： `android`、 `emscripten`、 `freebsd`、 `ios`、 `linux`、 `macos`、 `windows`、...
* <!--Environment (fourth word of the target triple): `gnu`, `msvc`, `musl`.-->
   環境（ターゲットの3番目の単語の4番目の単語）： `gnu`、 `msvc`、 `musl`。
* <!--Pointer width: `32bit`, `64bit`.-->
   ポインタの幅： `32bit`、 `64bit`。
* <!--Stage: `stage0`, `stage1`, `stage2`.-->
   ステージ： `stage0`、 `stage1`、 `stage2`。

### <!--Other Header Commands--> その他のヘッダーコマンド

<!--Here is a list of other header commands.-->
他のヘッダーコマンドの一覧を示します。
<!--This list is not exhaustive.-->
このリストは網羅的ではありません。
<!--Header commands can generally be found by browsing the `TestProps` structure found in [`header.rs`] from the compiletest source.-->
ヘッダーコマンドは、通常、コンパイル元からの[`header.rs`]ある`TestProps`構造体をブラウズすることで見つけることができます。

* <!--`run-rustfix` for UI tests, indicates that the test produces structured suggestions.-->
   UIテストの`run-rustfix`は、テストが構造化された提案を生成することを示します。
<!--The test writer should create a `.fixed` file, which contains the source with the suggestions applied.-->
   テストライターは、`.fixed`が適用されたソースを含む`.fixed`ファイルを作成する`.fixed`ます。
<!--When the test is run, compiletest first checks that the correct lint/warning is generated.-->
   テストが実行されると、compiletestは最初に正しいlint / warningが生成されていることをチェックします。
<!--Then, it applies the suggestion and compares against `.fixed` (they must match).-->
   次に、提案を適用し、`.fixed`と比較し`.fixed`（一致する必要があります）。
<!--Finally, the fixed source is compiled, and this compilation is required to succeed.-->
   最後に、固定ソースがコンパイルされ、このコンパイルが成功する必要があります。
<!--The `.fixed` file can also be generated automatically with the `--bless` option, discussed [below](#bless).-->
   `.fixed`ファイルは、[below](#bless) `--bless`オプションを使用して自動的に生成することもでき[below](#bless)。
* `min-{gdb,lldb}-version`
* `min-llvm-version`
* <!--`compile-pass` for UI tests, indicates that the test is supposed to compile, as opposed to the default where the test is supposed to error out.-->
   UIテストの`compile-pass`は、テストがエラーアウトされるはずのデフォルトではなく、テストがコンパイルされることを示します。
* <!--`compile-flags` passes extra command-line args to the compiler, eg `compile-flags -g` which forces debuginfo to be enabled.-->
   `compile-flags`は、追加のコマンドライン引数をコンパイラに渡し`compile-flags`。例えば、 `compile-flags -g`、debuginfoを強制的に有効にします。
* <!--`should-fail` indicates that the test should fail;-->
   `should-fail`は、テストが失敗`should-fail`ことを示します。
<!--used for "meta testing", where we test the compiletest program itself to check that it will generate errors in appropriate scenarios.-->
   "メタテスト"のために使用されます。そこで、コンパイル・プログラム自体をテストして、適切なシナリオでエラーを生成するかどうかをチェックします。
<!--This header is ignored for pretty-printer tests.-->
   このヘッダは、きれいなプリンタのテストでは無視されます。
* <!--`gate-test-X` where `X` is a feature marks the test as "gate test"for feature X. Such tests are supposed to ensure that the compiler errors when usage of a gated feature is attempted without the proper `#![feature(X)]` tag.-->
   `gate-test-X`ここで、`X`はフィーチャです。フィーチャXの "ゲートテスト"としてマークされます。このようなテストでは、適切な`#![feature(X)]`せずにゲーテッドフィーチャを使用しようとすると、`#![feature(X)]`タグ。
<!--Each unstable lang feature is required to have a gate test.-->
   それぞれの不安定なラング機能にはゲートテストが必要です。

[`header.rs`]: https://github.com/rust-lang/rust/tree/master/src/tools/compiletest/src/header.rs

<span id="error_annotations"></span>
## <!--Error annotations--> エラー注釈

<!--Error annotations specify the errors that the compiler is expected to emit.-->
エラー注釈は、コンパイラが発行すると予想されるエラーを指定します。
<!--They are "attached"to the line in source where the error is located.-->
それらは、エラーが存在するソースの行に「接続」されています。

* <!--`~`: Associates the following error level and message with the current line-->
   `~`：次のエラーレベルとメッセージを現在の行に関連付けます。
* `~|` <!--: Associates the following error level and message with the same line as the previous comment-->
   ：次のエラーレベルとメッセージを前のコメントと同じ行に関連付けます
* <!--`~^`: Associates the following error level and message with the previous line.-->
   `~^`：次のエラーレベルとメッセージを前の行に関連付けます。
<!--Each caret (`^`) that you add adds a line to this, so `~^^^^^^^` is seven lines up.-->
   あなたが追加する各キャレット（`^`）はこれに行を追加するので、 `~^^^^^^^`は7行上です。

<!--The error levels that you can have are:-->
エラーレベルは次のとおりです。

1. `ERROR`
2. `WARNING`
3. `NOTE`
4. <!--`HELP` and `SUGGESTION` *\* **Note**: `SUGGESTION` must follow immediately after `HELP`.-->
    `HELP`と`SUGGESTION` *\* **注意**： `HELP`直後には`SUGGESTION`を続ける必要があります。

## <!--Revisions--> リビジョン

<!--Certain classes of tests support "revisions"(as of the time of this writing, this includes run-pass, compile-fail, run-fail, and incremental, though incremental tests are somewhat different).-->
特定のクラスのテストは "リビジョン"をサポートしています（この記事の執筆時点では、ランパス、コンパイル・フェイル、ラン・フェイル、インクリメンタル・テストが含まれますが、インクリメンタル・テストは若干異なります）。
<!--Revisions allow a single test file to be used for multiple tests.-->
リビジョンでは、複数のテストに1つのテストファイルを使用できます。
<!--This is done by adding a special header at the top of the file:-->
これは、ファイルの先頭に特別なヘッダーを追加することによって行われます。

```rust
#// revisions: foo bar baz
// リビジョン：foo bar baz
```

<!--This will result in the test being compiled (and tested) three times, once with `--cfg foo`, once with `--cfg bar`, and once with `--cfg baz`.-->
これにより、テストは3回、--`--cfg foo`で1回、--`--cfg bar`で1回、--`--cfg baz`で1回、コンパイル（テスト）されます。
<!--You can therefore use `#[cfg(foo)]` etc within the test to tweak each of these results.-->
したがって、テスト中に`#[cfg(foo)]`などを使用して、これらの結果をそれぞれ微調整することができます。

<!--You can also customize headers and expected error messages to a particular revision.-->
ヘッダーと予想されるエラーメッセージを特定のリビジョンにカスタマイズすることもできます。
<!--To do this, add `[foo]` (or `bar`, `baz`, etc) after the `//` comment, like so:-->
これを行うには、`//`あとに`[foo]`（または`bar`、 `baz`など）を追加し`bar`。

```rust
#// A flag to pass in only for cfg `foo`:
//  cfg `foo`に対してのみ渡すフラグ：
//[foo]compile-flags: -Z verbose

#[cfg(foo)]
fn test_foo() {
    let x: usize = 32_u32; //[foo]~ ERROR mismatched types
}
```

<!--Note that not all headers have meaning when customized to a revision.-->
リビジョンに合わせてカスタマイズした場合、すべてのヘッダが意味を持つわけではないことに注意してください。
<!--For example, the `ignore-test` header (and all "ignore"headers) currently only apply to the test as a whole, not to particular revisions.-->
たとえば、`ignore-test`ヘッダー（およびすべての「無視」ヘッダー）は現在、特定のリビジョンではなく、テスト全体にのみ適用されます。
<!--The only headers that are intended to really work when customized to a revision are error patterns and compiler flags.-->
リビジョンにカスタマイズされたときに実際に動作するように意図されているヘッダーは、エラーパターンとコンパイラフラグのみです。

<span id="ui"></span>
## <!--Guide to the UI tests--> UIテストのガイド

<!--The UI tests are intended to capture the compiler's complete output, so that we can test all aspects of the presentation.-->
UIテストは、プレゼンテーションのすべての側面をテストできるように、コンパイラの完全な出力を取得することを目的としています。
<!--They work by compiling a file (eg, [`ui/hello_world/main.rs`][hw-main]), capturing the output, and then applying some normalization (see below).-->
それらは、ファイル（例えば、[`ui/hello_world/main.rs`][hw-main]）をコンパイルし、出力をキャプチャし、正規化を適用します（下記参照）。
<!--This normalized result is then compared against reference files named `ui/hello_world/main.stderr` and `ui/hello_world/main.stdout`.-->
この正規化された結果は、`ui/hello_world/main.stderr`および`ui/hello_world/main.stdout`という参照ファイルと比較されます。
<!--If either of those files doesn't exist, the output must be empty (that is actually the case for [this particular test][hw]).-->
それらのファイルのいずれかが存在しない場合、出力は空でなければなりません（実際には[この特定のテストの][hw]場合です）。
<!--If the test run fails, we will print out the current output, but it is also saved in `build/<target-triple>/test/ui/hello_world/main.stdout` (this path is printed as part of the test failure message), so you can run `diff` and so forth.-->
テスト実行が失敗した場合、現在の出力を出力しますが、`build/<target-triple>/test/ui/hello_world/main.stdout`も保存されます（このパスはテスト失敗メッセージの一部として出力されます）、`diff`などを実行することができます。

<!--[hw-main]: https://github.com/rust-lang/rust/blob/master/src/test/ui/hello_world/main.rs
 [hw]: https://github.com/rust-lang/rust/blob/master/src/test/ui/hello_world/
-->
[hw-main]: https://github.com/rust-lang/rust/blob/master/src/test/ui/hello_world/main.rs
 [hw]: https://github.com/rust-lang/rust/blob/master/src/test/ui/hello_world/


### <!--Tests that do not result in compile errors--> コンパイルエラーにならないテスト

<!--By default, a UI test is expected **not to compile** (in which case, it should contain at least one `//~ ERROR` annotation).-->
デフォルトでは、UIテストは**コンパイル**され**ないこと**が予想さ**れます**（この場合、少なくとも1つの`//~ ERROR`注釈が含まれている必要があります）。
<!--However, you can also make UI tests where compilation is expected to succeed, and you can even run the resulting program.-->
ただし、コンパイルが成功すると予想されるUIテストを作成し、結果のプログラムを実行することもできます。
<!--Just add one of the following [header commands](#header_commands):-->
次の[ヘッダコマンドの](#header_commands)いずれかを追加するだけです：

- <!--`// compile-pass` – compilation should succeed but do not run the resulting binary-->
   `// compile-pass` -コンパイルは成功するはずですが、結果のバイナリを実行しません
- <!--`// run-pass` – compilation should succeed and we should run the resulting binary-->
   `// run-pass` -コンパイルは成功するはずです。結果のバイナリを実行する必要があります

<span id="bless"></span>
### <!--Editing and updating the reference files--> 参照ファイルの編集と更新

<!--If you have changed the compiler's output intentionally, or you are making a new test, you can pass `--bless` to the test subcommand.-->
コンパイラの出力を意図的に変更した場合、または新しいテストを作成している場合は、testサブコマンドに`--bless`を渡すことができます。
<!--Eg if some tests in `src/test/ui` are failing, you can run-->
たとえば、`src/test/ui`内のいくつかのテストが失敗した場合は、実行することができます

```text
./x.py test --stage 1 src/test/ui --bless
```

<!--to automatically adjust the `.stderr`, `.stdout` or `.fixed` files of all tests.-->
すべてのテストの`.stderr`、 `.stdout`または`.fixed`ファイルを自動的に調整します。
<!--Of course you can also target just specific tests with the `--test-args your_test_name` flag, just like when running the tests.-->
もちろん、テストを実行するときと同じように、特定のテストだけを`--test-args your_test_name`フラグでターゲットにすることもできます。

### <!--Normalization--> 正規化

<!--The normalization applied is aimed at eliminating output difference between platforms, mainly about filenames:-->
適用される正規化は、主にファイル名に関するプラットフォーム間の出力の差をなくすことを目的としています。

- <!--the test directory is replaced with `$DIR`-->
   テストディレクトリは`$DIR`置き換えられます
- <!--all backslashes (`\`) are converted to forward slashes (`/`) (for Windows)-->
   すべてのバックスラッシュ（`\`）はスラッシュ（ `/`）に変換されます（Windowsの場合）
- <!--all CR LF newlines are converted to LF-->
   すべてのCR LF改行はLFに変換されます

<!--Sometimes these built-in normalizations are not enough.-->
これらの組み込み正規化では不十分な場合があります。
<!--In such cases, you may provide custom normalization rules using the header commands, eg-->
このような場合は、ヘッダコマンドを使用してカスタム正規化ルールを提供することができます。

```rust
#// normalize-stdout-test: "foo" -> "bar"
#// normalize-stderr-32bit: "fn\(\) \(32 bits\)" -> "fn\(\) \($$PTR bits\)"
#// normalize-stderr-64bit: "fn\(\) \(64 bits\)" -> "fn\(\) \($$PTR bits\)"
//  normalize-stderr-test： "foo"-> "bar"normalize-stderr-32bit： "fn \（\）\（32ビット\）"-> "fn \（\）\（Math DisplayMath " PTR\12499\12483\12488\65289 normalize-stderr-64bit\65306 \"fn \\\65288\\\65289\\\65288\&64\12499\12483\12488\\\65289\"  - > \"fn \\\65288\\\65289\\\65288" PTRビット\）"
```

<!--This tells the test, on 32-bit platforms, whenever the compiler writes `fn() (32 bits)` to stderr, it should be normalized to read `fn() ($PTR bits)` instead.-->
これは、コンパイラが`fn() (32 bits)`をstderrに書き込むたびに、代わりに`fn() ($PTR bits)`を読み取るように正規化する必要があります。
<!--Similar for 64-bit.-->
64ビットに似ています。
<!--The replacement is performed by regexes using default regex flavor provided by `regex` crate.-->
置き換えは、`regex` crateによって提供されるデフォルト正規表現フレーバを使用して正規表現によって実行されます。

<!--The corresponding reference file will use the normalized output to test both 32-bit and 64-bit platforms:-->
対応する参照ファイルは、正規化された出力を使用して、32ビットおよび64ビットの両方のプラットフォームをテストします。

```text
...
   |
   = note: source type: fn() ($PTR bits)
   = note: target type: u16 (16 bits)
...
```

<!--Please see [`ui/transmute/main.rs`][mrs] and [`main.stderr`][] for a concrete usage example.-->
具体的な使用例については、[`ui/transmute/main.rs`][mrs]と[`main.stderr`][]を参照してください。

<!--[mrs]: https://github.com/rust-lang/rust/blob/master/src/test/ui/transmute/main.rs
 [`main.stderr`]: https://github.com/rust-lang/rust/blob/master/src/test/ui/transmute/main.stderr
-->
[mrs]: https://github.com/rust-lang/rust/blob/master/src/test/ui/transmute/main.rs
 [`main.stderr`]: https://github.com/rust-lang/rust/blob/master/src/test/ui/transmute/main.stderr


<!--Besides `normalize-stderr-32bit` and `-64bit`, one may use any target information or stage supported by `ignore-X` here as well (eg `normalize-stderr-windows` or simply `normalize-stderr-test` for unconditional replacement).-->
`normalize-stderr-32bit`と`-64bit`、ここでも`ignore-X`でサポートされているターゲット情報やステージを使用することができます（例： `normalize-stderr-windows`または無条件置換の`normalize-stderr-test`）。
