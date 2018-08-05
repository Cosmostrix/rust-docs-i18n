# <!--The compiler testing framework--> コンパイラテストフレームワーク

<!--The Rust project runs a wide variety of different tests, orchestrated by the build system (`x.py test`).-->
Rustプロジェクトは、さまざまな異なるテストを実行し、ビルドシステム（`x.py test`）によって調整されます。
<!--The main test harness for testing the compiler itself is a tool called compiletest (sources in the [`src/tools/compiletest`]).-->
コンパイラ自体をテストするための主なテストハーネスは、compiletestというツールです（[`src/tools/compiletest`]）。
<!--This section gives a brief overview of how the testing framework is setup, and then gets into some of the details on [how to run tests](./tests/running.html#ui) as well as [how to add new tests](./tests/adding.html).-->
このセクションでは、テストフレームワークの設定方法の概要を説明し、次に[テストを実行する](./tests/running.html#ui) [方法と新しいテストを追加する](./tests/adding.html) [方法](./tests/running.html#ui)の詳細をいくつか取り上げ[ます](./tests/adding.html)。

[`src/tools/compiletest`]: https://github.com/rust-lang/rust/tree/master/src/tools/compiletest

## <!--Compiletest test suites--> Compiletestテストスイート

<!--The compiletest tests are located in the tree in the [`src/test`] directory.-->
compiletestテストはツリーの[`src/test`]ディレクトリにあります。
<!--Immediately within you will see a series of subdirectories (eg `ui`, `run-make`, and so forth).-->
すぐに一連のサブディレクトリ（たとえば、`ui`、 `run-make`など）が表示されます。
<!--Each of those directories is called a **test suite** – they house a group of tests that are run in a distinct mode.-->
これらのディレクトリのそれぞれは、**テストスイート**と呼ばれ、異なるモードで実行される一連のテストを格納します。

[`src/test`]: https://github.com/rust-lang/rust/tree/master/src/test

<!--Here is a brief summary of the test suites as of this writing and what they mean.-->
ここに、この執筆時点でのテストスイートの概要とその意味を示します。
<!--In some cases, the test suites are linked to parts of the manual that give more details.-->
場合によっては、テストスイートはマニュアルの一部にリンクされています。

- <!--[`ui`](./tests/adding.html#ui) – tests that check the exact stdout/stderr from compilation and/or running the test-->
   [`ui`](./tests/adding.html#ui) -コンパイルからの正確なstdout / stderrを確認するテスト、および/またはテストを実行するテスト
- <!--`run-pass` – tests that are expected to compile and execute successfully (no panics)-->
   `run-pass` -正常にコンパイルされて実行されると予想されるテスト（パニックは発生しません）
  - <!--`run-pass-valgrind` – tests that ought to run with valgrind-->
     `run-pass-valgrind` -`run-pass-valgrind`テスト
- <!--`run-fail` – tests that are expected to compile but then panic during execution-->
   `run-fail` -コンパイルが予想されるが実行中にパニックするテスト
- <!--`compile-fail` – tests that are expected to fail compilation.-->
   `compile-fail` -`compile-fail`予想されるテスト。
- <!--`parse-fail` – tests that are expected to fail to parse-->
   `parse-fail` -`parse-fail`予想されるテスト
- <!--`pretty` – tests targeting the Rust "pretty printer", which generates valid Rust code from the AST-->
   `pretty` -ASTから有効なRustコードを生成するRust "pretty printer"をターゲットにしたテスト
- <!--`debuginfo` – tests that run in gdb or lldb and query the debug info-->
   `debuginfo` -gdbまたはlldbで実行され、デバッグ情報を照会するテスト
- <!--`codegen` – tests that compile and then test the generated LLVM code to make sure that the optimizations we want are taking effect.-->
   `codegen` -生成されたLLVMコードをコンパイルしてテストし、必要な最適化が有効になっていることを確認します。
- <!--`mir-opt` – tests that check parts of the generated MIR to make sure we are building things correctly or doing the optimizations we expect.-->
   `mir-opt` -生成されたMIRの一部をチェックして、物事を正しく構築していることを確認したり、期待される最適化を行ったりすることをテストし`mir-opt`。
- <!--`incremental` – tests for incremental compilation, checking that when certain modifications are performed, we are able to reuse the results from previous compilations.-->
   `incremental` -インクリメンタルコンパイルのテストで、特定の変更が行われたときに以前のコンパイルの結果を再利用できることを確認します。
- <!--`run-make` – tests that basically just execute a `Makefile`;-->
   `run-make` -基本的には`Makefile`実行するテスト。
<!--the ultimate in flexibility but quite annoying to write.-->
   柔軟性は究極ですが、書くのは非常に面倒です。
- <!--`rustdoc` – tests for rustdoc, making sure that the generated files contain the expected documentation.-->
   `rustdoc` -`rustdoc`テストし、生成されたファイルに期待されるドキュメントが含まれていることを確認します。
- <!--`*-fulldeps` – same as above, but indicates that the test depends on things other than `libstd` (and hence those things must be built)-->
   `*-fulldeps` -上記と同じですが、テストが`libstd`以外のものに依存していることを示しています（したがって、`libstd`する必要があります）

## <!--Other Tests--> その他のテスト

<!--The Rust build system handles running tests for various other things, including:-->
Rustビルドシステムは、次のようなさまざまなテストの実行を処理します。

- <!--**Tidy** – This is a custom tool used for validating source code style and formatting conventions, such as rejecting long lines.-->
   **Tidy** -これは、長い行を拒否するなどのソースコードスタイルと書式設定規則を検証するために使用されるカスタムツールです。
<!--There is more information in the [section on coding conventions](./conventions.html#formatting).-->
   [コーディング規則に関するセクションに](./conventions.html#formatting)は、より多くの情報があります。

<!--Example: `./x.py test src/tools/tidy`-->
例： `./x.py test src/tools/tidy`

- <!--**Unit tests** – The Rust standard library and many of the Rust packages include typical Rust `#[test]` unittests.-->
   **ユニットテスト** -Rust標準ライブラリと多くのRustパッケージには、典型的なRust `#[test]` **ユニットテストが**含まれています。
<!--Under the hood, `x.py` will run `cargo test` on each package to run all the tests.-->
   フードの下で、`x.py`はすべてのテストを実行する`cargo test`に各パッケージに対して`cargo test`を実行します。

<!--Example: `./x.py test src/libstd`-->
例： `./x.py test src/libstd`

- <!--**Doc tests** – Example code embedded within Rust documentation is executed via `rustdoc --test`.-->
   **Docテスト** -Rustドキュメントに埋め込まれているサンプルコードは`rustdoc --test`実行されます。
<!--Examples:-->
   例：

<!--`./x.py test src/doc` – Runs `rustdoc --test` for all documentation in `src/doc`.-->
`./x.py test src/doc` -`src/doc`内のすべてのドキュメントに対して`rustdoc --test` -`./x.py test src/doc`実行します。

<!--`./x.py test --doc src/libstd` – Runs `rustdoc --test` on the standard library.-->
`./x.py test --doc src/libstd` -実行`rustdoc --test`標準ライブラリ上を。

- <!--**Link checker** – A small tool for verifying `href` links within documentation.-->
   **リンクチェッカー** -ドキュメント内の`href`リンクを確認するための小さなツールです。

<!--Example: `./x.py test src/tools/linkchecker`-->
例： `./x.py test src/tools/linkchecker`

- <!--**Dist check** – This verifies that the source distribution tarball created by the build system will unpack, build, and run all tests.-->
   **Dist check** -ビルドシステムで作成されたソース配布用のtarballが、すべてのテストを展開してビルドして実行することを確認します。

<!--Example: `./x.py test distcheck`-->
例： `./x.py test distcheck`

- <!--**Tool tests** – Packages that are included with Rust have all of their tests run as well (typically by running `cargo test` within their directory).-->
   **ツールテスト** -Rustに含まれるパッケージには、すべてのテストが実行されます（通常、ディレクトリ内で`cargo test`実行します）。
<!--This includes things such as cargo, clippy, rustfmt, rls, miri, bootstrap (testing the Rust build system itself), etc.-->
   これには、貨物、clippy、rustfmt、rls、miri、bootstrap（Rustビルドシステム自体のテスト）などが含まれます。

- <!--**Cargo test** – This is a small tool which runs `cargo test` on a few significant projects (such as `servo`, `ripgrep`, `tokei`, etc.) just to ensure there aren't any significant regressions.-->
   **カーゴテスト** -これは、重大な後退がないことを保証するために、いくつかの重要なプロジェクト（`servo`、 `ripgrep`、 `tokei`など）で`cargo test`を実行する小さなツールです。

<!--Example: `./x.py test src/tools/cargotest`-->
例： `./x.py test src/tools/cargotest`

## <!--Testing infrastructure--> インフラストラクチャのテスト

<!--When a Pull Request is opened on Github, [Travis] will automatically launch a build that will run all tests on a single configuration (x86-64 linux).-->
Githubでプルリクエストを開くと、[Travis]は自動的に単一の設定（x86-64 linux）ですべてのテストを実行するビルドを起動します。
<!--In essence, it runs `./x.py test` after building.-->
本質的に、`./x.py test`後に`./x.py test`を実行します。

<!--The integration bot [bors] is used for coordinating merges to the master branch.-->
統合ボット[bors]は、マスターブランチへのマージを調整するために使用されます。
<!--When a PR is approved, it goes into a [queue] where merges are tested one at a time on a wide set of platforms using Travis and [Appveyor] (currently over 50 different configurations).-->
PRが承認されると、それはに入る[queue]マージはトラヴィスと使用のプラットフォームの広いセットに一度に一つのテストをしている[Appveyor]（現在、50以上の異なる構成を）。
<!--Most platforms only run the build steps, some run a restricted set of tests, only a subset run the full suite of tests (see Rust's [platform tiers]).-->
ほとんどのプラットフォームはビルドステップのみを実行し、一部は制限されたテストセットを実行し、一部のセットはすべてのテストを実行します（Rustの[platform tiers]参照）。

<!--[Travis]: https://travis-ci.org/rust-lang/rust
 [bors]: https://github.com/servo/homu
 [queue]: https://buildbot2.rust-lang.org/homu/queue/rust
 [Appveyor]: https://ci.appveyor.com/project/rust-lang/rust
 [platform tiers]: https://forge.rust-lang.org/platform-support.html
-->
[Travis]: https://travis-ci.org/rust-lang/rust
 [bors]: https://github.com/servo/homu
 [queue]: https://buildbot2.rust-lang.org/homu/queue/rust
 [Appveyor]: https://ci.appveyor.com/project/rust-lang/rust
 [platform tiers]: https://forge.rust-lang.org/platform-support.html


## <!--Testing with Docker images--> Dockerイメージによるテスト

<!--The Rust tree includes [Docker] image definitions for the platforms used on Travis in [src/ci/docker].-->
Rustツリーには、[src/ci/docker] Travisで使用されるプラットフォーム用の[Docker]イメージ定義が含まれています。
<!--The script [src/ci/docker/run.sh] is used to build the Docker image, run it, build Rust within the image, and run the tests.-->
スクリプト[src/ci/docker/run.sh]は、Dockerイメージを構築し、実行し、イメージ内にRustを構築し、テストを実行するために使用されます。

> <!--TODO: What is a typical workflow for testing/debugging on a platform that you don't have easy access to?-->
> TODO：簡単にアクセスできないプラットフォームでのテスト/デバッグの典型的なワークフローは何ですか？
> <!--Do people build Docker images and enter them to test things out?-->
> 人々はDockerの画像を作成し、それを入力して物事をテストしますか？

<!--[Docker]: https://www.docker.com/
 [src/ci/docker]: https://github.com/rust-lang/rust/tree/master/src/ci/docker
 [src/ci/docker/run.sh]: https://github.com/rust-lang/rust/blob/master/src/ci/docker/run.sh
-->
[Docker]: https://www.docker.com/
 [src/ci/docker]: https://github.com/rust-lang/rust/tree/master/src/ci/docker
 [src/ci/docker/run.sh]: https://github.com/rust-lang/rust/blob/master/src/ci/docker/run.sh


## <!--Testing on emulators--> エミュレータでのテスト

<!--Some platforms are tested via an emulator for architectures that aren't readily available.-->
一部のプラットフォームは、容易に入手できないアーキテクチャ用のエミュレータを介してテストされています。
<!--There is a set of tools for orchestrating running the tests within the emulator.-->
エミュレータ内でテストを実行するための一連のツールが用意されています。
<!--Platforms such as `arm-android` and `arm-unknown-linux-gnueabihf` are set up to automatically run the tests under emulation on Travis.-->
`arm-android`や`arm-unknown-linux-gnueabihf`などの`arm-unknown-linux-gnueabihf`は、Travis上のエミュレーション下でテストを自動的に実行するように設定されています。
<!--The following will take a look at how a target's tests are run under emulation.-->
以下では、ターゲットのテストがどのようにエミュレーションで実行されるかを見ていきます。

<!--The Docker image for [armhf-gnu] includes [QEMU] to emulate the ARM CPU architecture.-->
[armhf-gnu]のDockerイメージには、ARM CPUアーキテクチャをエミュレートする[QEMU]が含まれています。
<!--Included in the Rust tree are the tools [remote-test-client] and [remote-test-server] which are programs for sending test programs and libraries to the emulator, and running the tests within the emulator, and reading the results.-->
Rustツリーには、テストプログラムやライブラリをエミュレータに送信し、エミュレータ内でテストを実行し、結果を読み取るためのツールである[remote-test-client]および[remote-test-server]ツールが含まれています。
<!--The Docker image is set up to launch `remote-test-server` and the build tools use `remote-test-client` to communicate with the server to coordinate running tests (see [src/bootstrap/test.rs]).-->
Dockerイメージは`remote-test-server`を起動するようにセットアップされ、ビルドツールは`remote-test-client`を使用してサーバーと通信し、実行中のテストを調整します（[src/bootstrap/test.rs]参照）。

> <!--TODO: What are the steps for manually running tests within an emulator?-->
> TODO：エミュレータ内で手動でテストを実行する手順は何ですか？
> <!--`./src/ci/docker/run.sh armhf-gnu` will do everything, but takes hours to run and doesn't offer much help with interacting within the emulator.-->
> `./src/ci/docker/run.sh armhf-gnu`はすべてを行いますが、実行に時間がかかり、エミュレータ内でのやりとりに多くの助けをしません。
> 
> <!--Is there any support for emulating other (non-Android) platforms, such as running on an iOS emulator?-->
> iOSエミュレータでの実行など、他の（Android以外の）プラットフォームをエミュレートするサポートはありますか？
> 
> <!--Is there anything else interesting that can be said here about running tests remotely on real hardware?-->
> 実際のハードウェア上でリモートでテストを実行することについてここで言える面白いことがありますか？
> 
> <!--It's also unclear to me how the wasm or asm.js tests are run.-->
> wasmまたはasm.jsテストがどのように実行されるかは、私には不明です。

<!--[armhf-gnu]: https://github.com/rust-lang/rust/tree/master/src/ci/docker/armhf-gnu
 [QEMU]: https://www.qemu.org/
 [remote-test-client]: https://github.com/rust-lang/rust/tree/master/src/tools/remote-test-client
 [remote-test-server]: https://github.com/rust-lang/rust/tree/master/src/tools/remote-test-server
 [src/bootstrap/test.rs]: https://github.com/rust-lang/rust/tree/master/src/bootstrap/test.rs
-->
[armhf-gnu]: https://github.com/rust-lang/rust/tree/master/src/ci/docker/armhf-gnu
 [QEMU]: https://www.qemu.org/
 [remote-test-client]: https://github.com/rust-lang/rust/tree/master/src/tools/remote-test-client
 [remote-test-server]: https://github.com/rust-lang/rust/tree/master/src/tools/remote-test-server
 [src/bootstrap/test.rs]: https://github.com/rust-lang/rust/tree/master/src/bootstrap/test.rs


## <!--Crater--> クレーター

<!--[Crater](https://github.com/rust-lang-nursery/crater) is a tool for compiling and running tests for  _every_  crate on [crates.io](https://crates.io/) (and a few on GitHub).-->
[Crater](https://github.com/rust-lang-nursery/crater)は[crates.io](https://crates.io/)（およびGitHubのいくつか）の _すべての_ クレートのテストをコンパイルおよび実行するためのツールです。
<!--It is mainly used for checking for extent of breakage when implementing potentially breaking changes and ensuring lack of breakage by running beta vs stable compiler versions.-->
これは主に、潜在的に破損している変更を実装する際に破損の程度をチェックし、安定版コンパイラバージョンとベータ版を実行することによって破損がないことを保証するために使用されます。

### <!--When to run Crater--> クレーターを実行するタイミング

<!--You should request a crater run if your PR makes large changes to the compiler or could cause breakage.-->
PRがコンパイラに大きな変更を加えた場合、または破損の原因となる可能性がある場合は、クレーター実行を要求する必要があります。
<!--If you are unsure, feel free to ask your PR's reviewer.-->
あなたが不明な場合は、PRの査読者にお気軽にお問い合わせください。

### <!--Requesting Crater Runs--> クレーターランの要求

<!--The rust team maintains a few machines that can be used for running crater runs on the changes introduced by a PR.-->
錆のチームは、PRによって導入された変更にクレーターランを実行するために使用できるいくつかのマシンを維持しています。
<!--If your PR needs a crater run, leave a comment for the triage team in the PR thread.-->
あなたのPRにクレーターが必要な場合は、PRスレッドにトリアージチームのコメントを残してください。
<!--Please inform the team whether you require a "check-only"crater run, a "build only"crater run, or a "build-and-test"crater run.-->
「チェックのみ」のクレーターラン、「ビルドのみ」のクレーターラン、または「ビルドアンドテスト」のクレーターランが必要かどうかをチームに知らせてください。
<!--The difference is primarily in time;-->
その違いは主に時間的なものです。
<!--the conservative (if you're not sure) option is to go for the build-and-test run.-->
保守的な（あなたがわからない場合）オプションはビルドアンドテストの実行に向かうことです。
<!--If making changes that will only have an effect at compile-time (eg, implementing a new trait) then you only need a check run.-->
コンパイル時に変更を加えるだけの場合（例えば、新しい特性を実装する場合）、チェックを実行するだけです。

<!--Your PR will be enqueued by the triage team and the results will be posted when they are ready.-->
あなたのPRはトリアージチームによってエンキューされ、結果が準備ができたら掲示されます。
<!--Check runs will take around ~3-4 days, with the other two taking 5-6 days on average.-->
チェックランは約3-4日かかり、他の2人は平均5-6日かかります。

<!--While crater is really useful, it is also important to be aware of a few caveats:-->
クレーターは本当に便利ですが、いくつかの点に注意することも重要です。

- <!--Not all code is on crates.io!-->
   すべてのコードがcrates.ioにあるわけではありません！
<!--There is a lot of code in repos on GitHub and elsewhere.-->
   GitHubや他の場所でreposにはたくさんのコードがあります。
<!--Also, companies may not wish to publish their code.-->
   また、企業はコードを公開したくないかもしれません。
<!--Thus, a successful crater run is not a magically green light that there will be no breakage;-->
   したがって、成功したクレーター・ランは、魔法の緑色の光ではなく、破損することはありません。
<!--you still need to be careful.-->
   あなたはまだ注意する必要があります。

- <!--Crater only runs Linux builds on x86_64.-->
   Craterはx86_64上でのみLinuxビルドを実行します。
<!--Thus, other architectures and platforms are not tested.-->
   したがって、他のアーキテクチャおよびプラットフォームはテストされません。
<!--Critically, this includes Windows.-->
   クリティカルには、これにはWindowsも含まれます。

- <!--Many crates are not tested.-->
   多くの箱は試験されていません。
<!--This could be for a lot of reasons, including that the crate doesn't compile any more (eg used old nightly features), has broken or flaky tests, requires network access, or other reasons.-->
   これは、クレートがもうコンパイルされない（古い夜間の機能を使用するなど）、テストが壊れているか、薄れている、ネットワークアクセスが必要な、その他の理由など、さまざまな理由が考えられます。

- <!--Before crater can be run, `@bors try` needs to succeed in building artifacts.-->
   クレーターを実行する前に、`@bors try`成果物を構築することに成功する必要性を。
<!--This means that if your code doesn't compile, you cannot run crater.-->
   つまり、コードがコンパイルされなければ、クレーターを実行することはできません。

## <!--Perf runs--> 実行回数

<!--A lot of work is put into improving the performance of the compiler and preventing performance regressions.-->
コンパイラのパフォーマンスを向上させ、パフォーマンスの低下を防ぐために多くの作業が行われます。
<!--A "perf run"is used to compare the performance of the compiler in different configurations for a large collection of popular crates.-->
"perf run"は、さまざまな構成のコンパイラのパフォーマンスを、人気のあるクレートの大量のコレクションと比較するために使用されます。
<!--Different configurations include "fresh builds", builds with incremental compilation, etc.-->
異なる構成には、「新鮮なビルド」、インクリメンタルコンパイルによるビルドなどが含まれます。

<!--The result of a perf run is a comparison between two versions of the compiler (by their commit hashes).-->
perf実行の結果、2つのバージョンのコンパイラ（コミットハッシュによる）の比較が行われます。

<!--You should request a perf run if your PR may affect performance, especially if it can affect performance adversely.-->
PRがパフォーマンスに影響を及ぼす可能性がある場合は、特にパフォーマンスに悪影響を与える可能性がある場合は、perf実行をリクエストする必要があります。

## <!--Further reading--> 参考文献

<!--The following blog posts may also be of interest:-->
以下のブログ記事も興味深いかもしれません：

- <!--brson's classic ["How Rust is tested"][howtest]-->
   brsonの古典的な["どのように錆がテストされている"][howtest]

[howtest]: https://brson.github.io/2017/07/10/how-rust-is-tested
