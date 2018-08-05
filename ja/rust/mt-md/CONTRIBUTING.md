# <!--Contributing to Rust--> 錆に貢献する
[contributing-to-rust]: #contributing-to-rust

<!--Thank you for your interest in contributing to Rust!-->
Rustに貢献していただきありがとうございます。
<!--There are many ways to contribute, and we appreciate all of them.-->
貢献する方法はたくさんありますが、そのすべてに感謝しています。
<!--This document is a bit long, so here's links to the major sections:-->
この文書は少し長いので、主要なセクションへのリンクは次のとおりです：

* <!--[Feature Requests](#feature-requests)-->
   [機能リクエスト](#feature-requests)
* <!--[Bug Reports](#bug-reports)-->
   [バグレポート](#bug-reports)
* <!--[The Build System](#the-build-system)-->
   [ビルドシステム](#the-build-system)
* <!--[Pull Requests](#pull-requests)-->
   [プルリクエスト](#pull-requests)
* <!--[Writing Documentation](#writing-documentation)-->
   [ドキュメントの作成](#writing-documentation)
* <!--[Issue Triage](#issue-triage)-->
   [発行トリアージ](#issue-triage)
* <!--[Out-of-tree Contributions](#out-of-tree-contributions)-->
   [ツリーからの寄稿](#out-of-tree-contributions)
* <!--[Helpful Links and Information](#helpful-links-and-information)-->
   [役に立つリンクと情報](#helpful-links-and-information)

<!--If you have questions, please make a post on [internals.rust-lang.org][internals] or hop on [#rust-internals][pound-rust-internals].-->
ご質問がある場合は、上のポストを作ってください[internals.rust-lang.org][internals]かに飛び乗っ[#rust-internals][pound-rust-internals]。

<!--As a reminder, all contributors are expected to follow our [Code of Conduct][coc].-->
思い出させるように、すべての貢献者は[行動規範][coc]に従うことが期待されます。

<!--[pound-rust-internals]: https://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-internals
 [internals]: https://internals.rust-lang.org
 [coc]: https://www.rust-lang.org/conduct.html
-->
[pound-rust-internals]: https://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-internals
 [internals]: https://internals.rust-lang.org
 [coc]: https://www.rust-lang.org/conduct.html


## <!--Feature Requests--> 機能リクエスト
[feature-requests]: #feature-requests

<!--To request a change to the way the Rust language works, please head over to the [RFCs repository](https://github.com/rust-lang/rfcs) and view the [README](https://github.com/rust-lang/rfcs/blob/master/README.md) for instructions.-->
Rust言語の変更を要求するには、[RFCsリポジトリに](https://github.com/rust-lang/rfcs)進み、[README](https://github.com/rust-lang/rfcs/blob/master/README.md)を参照してください。

## <!--Bug Reports--> バグレポート
[bug-reports]: #bug-reports

<!--While bugs are unfortunate, they're a reality in software.-->
バグは残念ですが、ソフトウェアでは現実的です。
<!--We can't fix what we don't know about, so please report liberally.-->
私たちは知らないことを修正することはできませんので、自由に報告してください。
<!--If you're not sure if something is a bug or not, feel free to file a bug anyway.-->
バグかどうか分からない場合は、とにかくバグを報告してください。

<!--**If you believe reporting your bug publicly represents a security risk to Rust users, please follow our [instructions for reporting security vulnerabilities](https://www.rust-lang.org/security.html)**.-->
**あなたのバグがRustユーザのセキュリティ上のリスクを公然と表していると思われる場合は、[セキュリティ上の脆弱性を報告する方法]（https://www.rust-lang.org/security.html）に従ってください**。

<!--If you have the chance, before reporting a bug, please [search existing issues](https://github.com/rust-lang/rust/search?q=&type=Issues&utf8=%E2%9C%93), as it's possible that someone else has already reported your error.-->
チャンスがある場合は、バグを報告する前に、[既存の問題](https://github.com/rust-lang/rust/search?q=&type=Issues&utf8=%E2%9C%93)を[検索し](https://github.com/rust-lang/rust/search?q=&type=Issues&utf8=%E2%9C%93)てください。他の誰かがすでにあなたのエラーを報告している可能性があります。
<!--This doesn't always work, and sometimes it's hard to know what to search for, so consider this extra credit.-->
これは常に機能するとは限りません。また、何を検索するのかを知ることが難しい場合もありますので、この余分なクレジットを考慮してください。
<!--We won't mind if you accidentally file a duplicate report.-->
間違って重複レポートを提出した場合は気にしません。

<!--Similarly, to help others who encountered the bug find your issue, consider filing an issue with a descriptive title, which contains information that might be unique to it.-->
同様に、バグに遭遇した他の人があなたの問題を見つけるのを助けるために、固有の情報が含まれている説明的なタイトルで問題を提出することを検討してください。
<!--This can be the language or compiler feature used, the conditions that trigger the bug, or part of the error message if there is any.-->
これは、使用されている言語やコンパイラの機能、バグを引き起こす条件、エラーメッセージがある場合はエラーメッセージの一部になります。
<!--An example could be: **"impossible case reached"on lifetime inference for impl Trait in return position**.-->
例としては**、リターンポジションのインプットTraitの生涯推論で「不可能なケースに達した」**などがあります。

<!--Opening an issue is as easy as following [this link](https://github.com/rust-lang/rust/issues/new) and filling out the fields.-->
問題を開くことは、[this link](https://github.com/rust-lang/rust/issues/new)をたどってフィールドを入力するのと同じくらい簡単です。
<!--Here's a template that you can use to file a bug, though it's not necessary to use it exactly:-->
バグを記録するために使用できるテンプレートはありますが、正確に使う必要はありません：

RawInline (Format "html") "<short summary of the bug>"
<!--I tried this code:-->
私はこのコードを試した：


<!--I expected to see this happen:-->
私はこれが起こるのを期待しました：
RawInline (Format "html") "<explanation>"
<!--Instead, this happened:-->
代わりに、これは起こった：
RawInline (Format "html") "<explanation>"
<!--## Meta-->
##メタ

<!--`rustc --version --verbose`:-->
`rustc --version --verbose`：

<!--Backtrace:-->
バックトレース：

<!--All three components are important: what you did, what you expected, what happened instead.-->
3つの要素はすべて重要です。あなたがしたこと、期待したこと、代わりに何が起こったのか。
<!--Please include the output of `rustc --version --verbose`, which includes important information about what platform you're on, what version of Rust you're using, etc.-->
`rustc --version --verbose`出力を含めてください。これには、あなたが使っているプラ​​ットフォーム、使用しているRustのバージョンなどに関する重要な情報が含まれています。

<!--Sometimes, a backtrace is helpful, and so including that is nice.-->
時にはバックトレースが役立ち、それも含めていいです。
<!--To get a backtrace, set the `RUST_BACKTRACE` environment variable to a value other than `0`.-->
バックトレースを取得するには、`RUST_BACKTRACE`環境変数を`0`以外の値に設定します。
<!--The easiest way to do this is to invoke `rustc` like this:-->
これを行う最も簡単な方法は、`rustc`を`rustc`ように起動すること`rustc`。

```bash
$ RUST_BACKTRACE=1 rustc ...
```

## <!--The Build System--> ビルドシステム
[the-build-system]: #the-build-system

<!--Rust's build system allows you to bootstrap the compiler, run tests & benchmarks, generate documentation, install a fresh build of Rust, and more.-->
Rustのビルドシステムでは、コンパイラをブートストラップしたり、テストとベンチマークを実行したり、ドキュメントを生成したり、Rustの新鮮なビルドをインストールしたりできます。
<!--It's your best friend when working on Rust, allowing you to compile & test your contributions before submission.-->
Rustに取り組んでいるときはあなたの親友です。提出する前にあなたの投稿をコンパイル＆テストすることができます。

<!--The build system lives in [the `src/bootstrap` directory][bootstrap] in the project root.-->
ビルドシステムは、プロジェクトルートの[`src/bootstrap`ディレクトリ][bootstrap]にあります。
<!--Our build system is itself written in Rust and is based on Cargo to actually build all the compiler's crates.-->
私たちのビルドシステムはRustで書かれており、実際にすべてのコンパイラの箱を作るためにCargoをベースにしています。
<!--If you have questions on the build system internals, try asking in [`#rust-internals`][pound-rust-internals].-->
ビルドシステムの内部構造について質問がある場合は、[`#rust-internals`][pound-rust-internals]問い合わせてください。

[bootstrap]: https://github.com/rust-lang/rust/tree/master/src/bootstrap/

### <!--Configuration--> 構成
[configuration]: #configuration

<!--Before you can start building the compiler you need to configure the build for your system.-->
コンパイラーのビルドを開始する前に、システムのビルドを構成する必要があります。
<!--In most cases, that will just mean using the defaults provided for Rust.-->
ほとんどの場合、これは単にRustに提供されているデフォルトの使用を意味します。

<!--To change configuration, you must copy the file `config.toml.example` to `config.toml` in the directory from which you will be running the build, and change the settings provided.-->
設定を変更するには、ビルドを実行するディレクトリの`config.toml`ファイルを`config.toml.example`にコピーし、提供されている設定を変更する必要があります。

<!--There are large number of options provided in this config file that will alter the configuration used in the build process.-->
この設定ファイルには、ビルドプロセスで使用される設定を変更する多数のオプションが用意されています。
<!--Some options to note:-->
いくつかの注意すべきオプション：

#### <!--`[llvm]`:--> `[llvm]`：
- <!--`assertions = true` = This enables LLVM assertions, which makes LLVM misuse cause an assertion failure instead of weird misbehavior.-->
   `assertions = true` =これは、LLVMのアサーションを有効にします。これにより、LLVMの誤用により、奇妙な不正行為ではなくアサーションの失敗が引き起こされます。
<!--This also slows down the compiler's runtime by ~20%.-->
   これによりコンパイラのランタイムも20％遅くなります。
- <!--`ccache = true` -Use ccache when building llvm-->
   `ccache = true` -llvmをビルドするときにccacheを使用する

#### <!--`[build]`:--> `[build]`：
- <!--`compiler-docs = true` -Build compiler documentation-->
   `compiler-docs = true` -コンパイラのドキュメントをビルドする

#### <!--`[rust]`:--> `[rust]`：
- <!--`debuginfo = true` -Build a compiler with debuginfo.-->
   `debuginfo = true` -debuginfoでコンパイラをビルドします。
<!--Makes building rustc slower, but then you can use a debugger to debug `rustc`.-->
   rustcの構築を遅くしますが、デバッガを使って`rustc`をデバッグすることができます。
- <!--`debuginfo-lines = true` -An alternative to `debuginfo = true` that doesn't let you use a debugger, but doesn't make building rustc slower and still gives you line numbers in backtraces.-->
   `debuginfo-lines = true` -`debuginfo = true`の代わりに、デバッガを使用させることはできませんが、rustcの構築を遅くすることはなく、バックトレースにも行番号を与えます。
- <!--`debuginfo-tools = true` -Build the extended tools with debuginfo.-->
   `debuginfo-tools = true` -debuginfoで拡張ツールをビルドします。
- <!--`debug-assertions = true` -Makes the log output of `debug!` work.-->
   `debug-assertions = true` -`debug!`出力のログ出力を行います。
- <!--`optimize = false` -Disable optimizations to speed up compilation of stage1 rust, but makes the stage1 compiler x100 slower.-->
   `optimize = false` -最適化を無効にしてstage1 rustのコンパイルを高速化しますが、stage1コンパイラを100倍遅くします。

<!--For more options, the `config.toml` file contains commented out defaults, with descriptions of what each option will do.-->
さらに多くのオプションについては、`config.toml`ファイルにコメントアウトされたデフォルトが含まれています。それぞれのオプションについて説明しています。

<!--Note: Previously the `./configure` script was used to configure this project.-->
注：以前は`./configure`スクリプトを使用してこのプロジェクトを設定していました。
<!--It can still be used, but it's recommended to use a `config.toml` file.-->
引き続き使用できますが、`config.toml`ファイルを使用することをお勧めします。
<!--If you still have a `config.mk` file in your directory -from `./configure` -you may need to delete it for `config.toml` to work.-->
`./configure`ディレクトリにまだ`config.mk`ファイルがある場合は、`config.toml`を削除する必要があります。

### <!--Building--> 建物
[building]: #building

<!--A default configuration requires around 3.5 GB of disk space, whereas building a debug configuration may require more than 30 GB.-->
既定の構成では約3.5 GBのディスク容量が必要ですが、デバッグ構成を構築するには30 GB以上が必要です。

<!--Dependencies -[build dependencies](README.md#building-from-source) -`gdb` 6.2.0 minimum, 7.1 or later recommended for test builds-->
依存関係 -[ビルド依存関係](README.md#building-from-source) -`gdb` 6.2.0最低、7.1またはそれ以降のテストビルドの推奨

<!--The build system uses the `x.py` script to control the build process.-->
ビルドシステムは、`x.py`スクリプトを使用してビルドプロセスを制御します。
<!--This script is used to build, test, and document various parts of the compiler.-->
このスクリプトは、コンパイラのさまざまな部分をビルド、テスト、およびドキュメント化するために使用されます。
<!--You can execute it as:-->
次のように実行することができます：

```sh
python x.py build
```

<!--On some systems you can also use the shorter version:-->
いくつかのシステムでは、短いバージョンを使うこともできます：

```sh
./x.py build
```

<!--To learn more about the driver and top-level targets, you can execute:-->
ドライバとトップレベルのターゲットの詳細については、以下を実行してください。

```sh
python x.py --help
```

<!--The general format for the driver script is:-->
ドライバスクリプトの一般的な形式は次のとおりです。

```sh
python x.py <command> [<directory>]
```

<!--Some example commands are `build`, `test`, and `doc`.-->
コマンドの例は、`build`、 `test`、および`doc`です。
<!--These will build, test, and document the specified directory.-->
これらは、指定されたディレクトリの構築、テスト、および文書化を行います。
<!--The second argument, `<directory>`, is optional and defaults to working over the entire compiler.-->
2番目の引数`<directory>`はオプションで、デフォルトはコンパイラ全体を処理します。
<!--If specified, however, only that specific directory will be built.-->
ただし、指定した場合は、その特定のディレクトリだけが作成されます。
<!--For example:-->
例えば：

```sh
# build the entire compiler
python x.py build

# build all documentation
python x.py doc

# run all test suites
python x.py test

# build only the standard library
python x.py build src/libstd

# test only one particular test suite
python x.py test src/test/rustdoc

# build only the stage0 libcore library
python x.py build src/libcore --stage 0
```

<!--You can explore the build system through the various `--help` pages for each subcommand.-->
各サブコマンドのさまざまな`--help`ページを使用してビルドシステムを調べることができます。
<!--For example to learn more about a command you can run:-->
たとえば、実行可能なコマンドの詳細については、次を参照してください。

```
python x.py build --help
```

<!--To learn about all possible rules you can execute, run:-->
実行可能なすべてのルールについては、以下を実行してください。

```
python x.py build --help --verbose
```

<!--Note: Previously `./configure` and `make` were used to build this project.-->
注：以前は`./configure`と`make`を使ってこのプロジェクトをビルドしていました。
<!--They are still available, but `x.py` is the recommended build system.-->
それらはまだ利用可能ですが、推奨されるビルドシステムは`x.py`です。

### <!--Useful commands--> 便利なコマンド
[useful-commands]: #useful-commands

<!--Some common invocations of `x.py` are:-->
`x.py`一般的な呼び出しは`x.py`です。

- <!--`x.py build --help` -show the help message and explain the subcommand-->
   `x.py build --help` -ヘルプメッセージを表示し、サブコマンドを説明する
- <!--`x.py build src/libtest --stage 1` -build up to (and including) the first stage.-->
   `x.py build src/libtest --stage 1` -最初のステージまで構築します。
<!--For most cases we don't need to build the stage2 compiler, so we can save time by not building it.-->
   ほとんどの場合、stage2コンパイラをビルドする必要はないので、ビルドしないことで時間を節約できます。
<!--The stage1 compiler is a fully functioning compiler and (probably) will be enough to determine if your change works as expected.-->
   stage1コンパイラは完全に機能するコンパイラであり、変更が期待どおりに機能するかどうかを判断するのに十分です（おそらく）。
- <!--`x.py build src/rustc --stage 1` -This will build just rustc, without libstd.-->
   `x.py build src/rustc --stage 1` -これはlibstdなしでrustcだけをビルドします。
<!--This is the fastest way to recompile after you changed only rustc source code.-->
   これは、rustcソースコードのみを変更した後に再コンパイルする最も速い方法です。
<!--Note however that the resulting rustc binary won't have a stdlib to link against by default.-->
   ただし、結果として生じるrustcバイナリには、デフォルトでリンクするstdlibはありません。
<!--You can build libstd once with `x.py build src/libstd`, but it is only guaranteed to work if recompiled, so if there are any issues recompile it.-->
   `x.py build src/libstd`を`x.py build src/libstd` libstdを一度ビルドすることはできますが、再コンパイルした場合にのみ動作することが保証されています。
- <!--`x.py test` -build the full compiler & run all tests (takes a while).-->
   `x.py test` -完全なコンパイラをビルドし、すべてのテストを実行します（しばらく時間がかかります）。
<!--This is what gets run by the continuous integration system against your pull request.-->
   これは、継続的統合システムによってプル要求に対して実行されるものです。
<!--You should run this before submitting to make sure your tests pass & everything builds in the correct manner.-->
   テストをパスしてすべてが正しい方法でビルドされていることを確認するために、これを実行する必要があります。
- <!--`x.py test src/libstd --stage 1` -test the standard library without recompiling stage 2.-->
   `x.py test src/libstd --stage 1` -ステージ2を再コンパイルせずに標準ライブラリをテストします。
- <!--`x.py test src/test/run-pass --test-args TESTNAME` -Run a matching set of tests.-->
   `x.py test src/test/run-pass --test-args TESTNAME` -一致する一連のテストを実行します。
  - <!--`TESTNAME` should be a substring of the tests to match against eg it could be the fully qualified test name, or just a part of it.-->
     `TESTNAME`は、一致するテストの部分文字列でなければなりません。たとえば、完全修飾テスト名、またはその一部だけを指定できます。
<!--`TESTNAME=collections::hash::map::test_map::test_capacity_not_less_than_len` or `TESTNAME=test_capacity_not_less_than_len`.-->
     `TESTNAME=collections::hash::map::test_map::test_capacity_not_less_than_len`または`TESTNAME=test_capacity_not_less_than_len`。
- <!--`x.py test src/test/run-pass --stage 1 --test-args <substring-of-test-name>` -Run a single rpass test with the stage1 compiler (this will be quicker than running the command above as we only build the stage1 compiler, not the entire thing).-->
   `x.py test src/test/run-pass --stage 1 --test-args <substring-of-test-name>` -stage1コンパイラで単一のrpassテストを実行します（これは上記のコマンドを実行するよりも速くなります）。私たちはstage1コンパイラをビルドします。
<!--You can also leave off the directory argument to run all stage1 test types.-->
   また、directory引数を省略して、すべてのstage1テスト・タイプを実行することもできます。
- <!--`x.py test src/libcore --stage 1` -Run stage1 tests in `libcore`.-->
   `x.py test src/libcore --stage 1` -でstage1のテストを実行します`libcore`。
- <!--`x.py test src/tools/tidy` -Check that the source code is in compliance with Rust's style guidelines.-->
   `x.py test src/tools/tidy` -ソースコードがRustのスタイルガイドラインに準拠していることを確認します。
<!--There is no official document describing Rust's full guidelines as of yet, but basic rules like 4 spaces for indentation and no more than 99 characters in a single line should be kept in mind when writing code.-->
   Rustの完全なガイドラインについてはまだ公式な文書はありませんが、インデント用の4つのスペースや1行に99文字以下の基本ルールは、コードを記述する際に留意してください。

### <!--Using your local build--> ローカルビルドを使用する
[using-local-build]: #using-local-build

<!--If you use Rustup to manage your rust install, it has a feature called ["custom toolchains"][toolchain-link] that you can use to access your newly-built compiler without having to install it to your system or user PATH.-->
あなたのrustインストールを管理するためにRustupを使用している場合、それはあなたのシステムやユーザのPATHにインストールすることなく、新しく構築されたコンパイラにアクセスするのに使うことができる["custom toolchains"][toolchain-link]と呼ばれる機能を持っています。
<!--If you've run `python x.py build`, then you can add your custom rustc to a new toolchain like this:-->
もしあなたが`python x.py build`を実行していれば、カスタムのrustcを次のように新しいツールチェーンに追加することができます：

[toolchain-link]: https://github.com/rust-lang-nursery/rustup.rs#working-with-custom-toolchains-and-local-builds

```
rustup toolchain link <name> build/<host-triple>/stage2
```

<!--Where `<host-triple>` is the build triple for the host (the triple of your computer, by default), and `<name>` is the name for your custom toolchain.-->
`<host-triple>`は`<host-triple>`のビルドトリプル（デフォルトではコンピュータの3倍）で、`<name>`はカスタムツールチェーンの名前です。
<!--(If you added `--stage 1` to your build command, the compiler will be in the `stage1` folder instead.) You'll only need to do this once -it will automatically point to the latest build you've done.-->
（ビルドコマンドに`--stage 1`を追加した場合は、代わりに`stage1`フォルダにコンパイラが`stage1`ます）。これは一度行う必要があります。これは自動的に実行した最新のビルドを自動的に`stage1`ます。

<!--Once this is set up, you can use your custom toolchain just like any other.-->
これが設定されたら、他のカスタムツールチェーンと同じようにカスタムツールチェーンを使用できます。
<!--For example, if you've named your toolchain `local`, running `cargo +local build` will compile a project with your custom rustc, setting `rustup override set local` will override the toolchain for your current directory, and `cargo +local doc` will use your custom rustc and rustdoc to generate docs.-->
たとえば、toolchainを`local`に指定した場合、`cargo +local build`を実行`cargo +local build`とカスタムrustcでプロジェクトがコンパイルされ、`rustup override set local`カレントディレクトリのtoolchainが上書きされ、`cargo +local doc`カスタムrustcが使用されますrustdocを使ってドキュメントを生成します。
<!--(If you do this with a `--stage 1` build, you'll need to build rustdoc specially, since it's not normally built in stage 1. `python x.py build --stage 1 src/libstd src/tools/rustdoc` will build rustdoc and libstd, which will allow rustdoc to be run with that toolchain.)-->
（`--stage 1`ビルドでこれを行う場合は、通常は第1段階ではビルドされていないので、特にrustdocをビルドする必要があります`python x.py build --stage 1 src/libstd src/tools/rustdoc` build rustdocとlibstdは、そのツールチェーンでrustdocを実行できるようになります）。

### <!--Out-of-tree builds--> ツリーからのビルド
[out-of-tree-builds]: #out-of-tree-builds

<!--Rust's `x.py` script fully supports out-of-tree builds -it looks for the Rust source code from the directory `x.py` was found in, but it reads the `config.toml` configuration file from the directory it's run in, and places all build artifacts within a subdirectory named `build`.-->
Rustの`x.py`スクリプトはツリー外のビルドを完全にサポートしています -`x.py`ディレクトリ`x.py` Rustソースコードを`x.py`ますが、実行されているディレクトリから`config.toml`設定ファイルを読み込み、buildという名前のサブディレクトリ内に成果物を`build`ます。

<!--This means that if you want to do an out-of-tree build, you can just do it: ` ``$ cd my/build/dir $ cp ~/my-config.toml config.toml # Or fill in config.toml otherwise $ path/to/rust/x.py build ... $ # This will use the Rust source code in `path/to/rust`, but build $ # artifacts will now be in ./build`` `-->
つまり、アウトオブツリービルドをしたいのであれば、それを行うだけです： ` ``$ cd my/build/dir $ cp ~/my-config.toml config.toml # Or fill in config.toml otherwise $ path/to/rust/x.py build ... $ # This will use the Rust source code in `path/to/rust`, but build $ # artifacts will now be in ./build``

<!--It's absolutely fine to have multiple build directories with different `config.toml` configurations using the same code.-->
同じコードを使用して異なる`config.toml`設定を持つ複数のビルドディレクトリを持つことは絶対に賢明です。

## <!--Pull Requests--> プルリクエスト
[pull-requests]: #pull-requests

<!--Pull requests are the primary mechanism we use to change Rust.-->
プルリクエストは、Rustを変更するために使用する主なメカニズムです。
<!--GitHub itself has some [great documentation][about-pull-requests] on using the Pull Request feature.-->
GitHub自体には、プルリクエスト機能の使用に関する[素晴らしいドキュメント][about-pull-requests]があります。
<!--We use the "fork and pull"model [described here][development-models], where contributors push changes to their personal fork and create pull requests to bring those changes into the source repository.-->
[ここ][development-models]では、寄稿者が個人のフォークに変更をプッシュし、その変更をソースリポジトリに持ち込むためのプルリクエストを作成する「フォークアンドプル」モデルを使用します。

<!--[about-pull-requests]: https://help.github.com/articles/about-pull-requests/
 [development-models]: https://help.github.com/articles/about-collaborative-development-models/
-->
[about-pull-requests]: https://help.github.com/articles/about-pull-requests/
 [development-models]: https://help.github.com/articles/about-collaborative-development-models/


<!--Please make pull requests against the `master` branch.-->
`master`ブランチに対してプルリクエストをしてください。

<!--Compiling all of `./x.py test` can take a while.-->
すべての`./x.py test`コンパイルするには`./x.py test`がかかります。
<!--When testing your pull request, consider using one of the more specialized `./x.py` targets to cut down on the amount of time you have to wait.-->
プルリクエストをテストするときは、より専門的な`./x.py`ターゲットの1つを使用して、待たなければならない時間を減らすことを検討してください。
<!--You need to have built the compiler at least once before running these will work, but that's only one full build rather than one each time.-->
これらを実行する前に少なくとも1回はコンパイラをビルドする必要がありますが、毎回1つではなく1つの完全ビルドです。

<!--$ python x.py test --stage 1-->
$ python x.py test --stage 1

<!--is one such example, which builds just `rustc`, and then runs the tests.-->
そのような例の1つで、それはちょうど`rustc`、テストを実行します。
<!--If you're adding something to the standard library, try-->
標準ライブラリに何かを追加する場合は、

<!--$ python x.py test src/libstd --stage 1-->
$ python x.py test src / libstd --stage 1

<!--Please make sure your pull request is in compliance with Rust's style guidelines by running-->
プルリクエストがRustのスタイルガイドラインに準拠していることを確認してください。

<!--$ python x.py test src/tools/tidy-->
$ python x.py test src / tools / tidy

<!--Make this check before every pull request (and every new commit in a pull request);-->
このチェックは、すべてのプルリクエスト（およびプルリクエスト内のすべての新しいコミット）の前に行います。
<!--you can add [git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) before every push to make sure you never forget to make this check.-->
すべてのpushの前に[gitフック](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)を追加して、このチェックを忘れないようにしてください。

<!--All pull requests are reviewed by another person.-->
すべてのプルリクエストは、他の人によってレビューされます。
<!--We have a bot, @rust-highfive, that will automatically assign a random person to review your request.-->
あなたのリクエストを見直すために自動的にランダムな人物を割り当てるボット@ rust-highfiveがあります。

<!--If you want to request that a specific person reviews your pull request, you can add an `r?`-->
特定の人がプルリクエストを確認するように要求したい場合は、`r?`
<!--to the message.-->
メッセージに。
<!--For example, Steve usually reviews documentation changes.-->
たとえば、Steveは通常、ドキュメントの変更を確認します。
<!--So if you were to make a documentation change, add-->
したがって、ドキュメントの変更を行う場合は、

<!--r?-->
r？
<!--@steveklabnik-->
@steveklabnik

<!--to the end of the message, and @rust-highfive will assign @steveklabnik instead of a random person.-->
@ rust-highfiveはランダムな人の代わりに@steveklabnikを割り当てます。
<!--This is entirely optional.-->
これは完全にオプションです。

<!--After someone has reviewed your pull request, they will leave an annotation on the pull request with an `r+`.-->
誰かがあなたのプルリクエストを見直した後、プルリクエストの注釈を`r+`残します。
<!--It will look something like this:-->
それは次のようになります：

<!--@bors: r+ 38fe8d2-->
@bors：r + 38fe8d2

<!--This tells @bors, our lovable integration bot, that your pull request has been approved.-->
これは私たちの愛らしい統合ボット@borsにあなたのプルリクエストが承認されたことを伝えます。
<!--The PR then enters the [merge queue][merge-queue], where @bors will run all the tests on every platform we support.-->
PRは[マージキュー][merge-queue]に入り[ます][merge-queue]。ここで@borsはサポートしているすべてのプラットフォームですべてのテストを実行します。
<!--If it all works out, @bors will merge your code into `master` and close the pull request.-->
すべてがうまくいけば、@borsはあなたのコードを`master`マージし、プルリクエストを閉じます。

[merge-queue]: https://buildbot2.rust-lang.org/homu/queue/rust

<!--Speaking of tests, Rust has a comprehensive test suite.-->
テストについて言えば、Rustには包括的なテストスイートがあります。
<!--More information about it can be found [here](https://github.com/rust-lang/rust/blob/master/src/test/COMPILER_TESTS.md).-->
詳細は[here](https://github.com/rust-lang/rust/blob/master/src/test/COMPILER_TESTS.md)。

### <!--External Dependencies--> 外部依存関係
[external-dependencies]: #external-dependencies

<!--Currently building Rust will also build the following external projects:-->
現在Rustをビルドすると、以下の外部プロジェクトも構築されます。

* [clippy](https://github.com/rust-lang-nursery/rust-clippy)
* [miri](https://github.com/solson/miri)
* [rustfmt](https://github.com/rust-lang-nursery/rustfmt)
* [rls](https://github.com/rust-lang-nursery/rls/)

<!--We allow breakage of these tools in the nightly channel.-->
私たちは、夜間チャンネルでこれらのツールの破損を許可します。
<!--Maintainers of these projects will be notified of the breakages and should fix them as soon as possible.-->
これらのプロジェクトの管理者は、破損の通知を受け、できるだけ早く修正する必要があります。

<!--After the external is fixed, one could add the changes with-->
外部が修正された後、

```sh
git add path/to/submodule
```

<!--outside the submodule.-->
サブモジュールの外側にある。

<!--In order to prepare your tool-fixing PR, you can run the build locally by doing `./x.py build src/tools/TOOL`.-->
あなたのツール固定PRを準備するには、. `./x.py build src/tools/TOOL`を実行してビルドをローカルで実行できます。
<!--If you will be editing the sources there, you may wish to set `submodules = false` in the `config.toml` to prevent `x.py` from resetting to the original branch.-->
そこでソースを編集する場合は、`config.toml`に`submodules = false`を設定して、`x.py`が元のブランチにリセットされないようにすることができます。

<!--Breakage is not allowed in the beta and stable channels, and must be addressed before the PR is merged.-->
ブレークは、ベータ版と安定版のチャンネルでは許可されていません.PRがマージされる前に対処しなければなりません。

#### <!--Breaking Tools Built With The Compiler--> コンパイラで構築されたブレークツール
[breaking-tools-built-with-the-compiler]: #breaking-tools-built-with-the-compiler

<!--Rust's build system builds a number of tools that make use of the internals of the compiler.-->
Rustのビルドシステムは、コンパイラの内部を利用する多くのツールを構築します。
<!--This includes clippy, [RLS](https://github.com/rust-lang-nursery/rls) and [rustfmt](https://github.com/rust-lang-nursery/rustfmt).-->
これには、clippy、[RLS](https://github.com/rust-lang-nursery/rls)、 [rustfmt](https://github.com/rust-lang-nursery/rustfmt)含まれます。
<!--If these tools break because of your changes, you may run into a sort of "chicken and egg"problem.-->
あなたの変更のためにこれらのツールが壊れると、一種の「鶏と卵」の問題に遭遇するかもしれません。
<!--These tools rely on the latest compiler to be built so you can't update them to reflect your changes to the compiler until those changes are merged into the compiler.-->
これらのツールは、最新のコンパイラを使用してコンパイラにマージされるまでコンパイラの変更を反映するように更新することはできません。
<!--At the same time, you can't get your changes merged into the compiler because the rust-lang/rust build won't pass until those tools build and pass their tests.-->
同時に、テストがビルドされてテストに合格するまで、rust-lang / rustビルドが実行されないため、変更をコンパイラにマージすることはできません。

<!--That means that, in the default state, you can't update the compiler without first fixing rustfmt, rls and the other tools that the compiler builds.-->
つまり、デフォルト状態では、まずrustfmt、rls、およびコンパイラが構築する他のツールを修正せずにコンパイラを更新することはできません。

<!--Luckily, a feature was [added to Rust's build](https://github.com/rust-lang/rust/issues/45861) to make all of this easy to handle.-->
幸いなことに、[Rustのビルド](https://github.com/rust-lang/rust/issues/45861)に機能が[追加され](https://github.com/rust-lang/rust/issues/45861)、これをすべて簡単に処理できるようになりました。
<!--The idea is that we allow these tools to be "broken", so that the rust-lang/rust build passes without trying to build them, then land the change in the compiler, wait for a nightly, and go update the tools that you broke.-->
アイデアは、これらのツールを「壊れた」ようにして、rust-lang / rustビルドがビルドしようとせずに通過し、コンパイラに変更を適用し、夜間待機し、壊れた
<!--Once you're done and the tools are working again, you go back in the compiler and update the tools so they can be distributed again.-->
作業が完了してツールが再び動作すると、コンパイラに戻ってツールを更新し、再度配布することができます。

<!--This should avoid a bunch of synchronization dances and is also much easier on contributors as there's no need to block on rls/rustfmt/other tools changes going upstream.-->
これは同期ダンスの束を避けるべきであり、rls / rustfmt /他のツールの変更を上流にブロックする必要がないので、コントリビュータでははるかに簡単です。

<!--Here are those same steps in detail:-->
以下、同じ手順を詳しく説明します。

1. <!--(optional) First, if it doesn't exist already, create a `config.toml` by copying `config.toml.example` in the root directory of the Rust repository.-->
    （オプション）まず、存在しない場合は、Rustリポジトリのルートディレクトリに`config.toml`をコピーして`config.toml.example`作成します。
<!--Set `submodules = false` in the `[build]` section.-->
    `[build]`セクションで`submodules = false`を設定します。
<!--This will prevent `x.py` from resetting to the original branch after you make your changes.-->
    これにより、変更した後に`x.py`が元のブランチにリセットされなくなります。
<!--If you need to [update any submodules to their latest versions][updating-submodules], see the section of this file about that for more information.-->
    [サブモジュールを最新バージョン][updating-submodules]に[更新][updating-submodules]する必要がある場合は、詳細については、このファイルのセクションを参照してください。
2. <!--(optional) Run `./x.py test src/tools/rustfmt` (substituting the submodule that broke for `rustfmt`).-->
    （オプション）を実行し`./x.py test src/tools/rustfmt`（のために壊したサブモジュールの代わり`rustfmt`）。
<!--Fix any errors in the submodule (and possibly others).-->
    サブモジュール（およびその他のモジュール）のエラーを修正します。
3. <!--(optional) Make commits for your changes and send them to upstream repositories as a PR.-->
    （オプション）変更をコミットして、それらを上流のリポジトリにPRとして送信します。
4. <!--(optional) Maintainers of these submodules will **not** merge the PR.-->
    （オプション）これらのサブモジュールのメンテナはPRをマージし**ません**。
<!--The PR can't be merged because CI will be broken.-->
    CIは壊れてしまうため、PRをマージすることはできません。
<!--You'll want to write a message on the PR referencing your change, and how the PR should be merged once your change makes it into a nightly.-->
    変更を参照しているPRにメッセージを書きたいのですが、その変更が夜間に反映されたらPRをマージする必要があります。
5. <!--Wait for your PR to merge.-->
    あなたのPRがマージするのを待ってください。
6. <!--Wait for a nightly-->
    夜間を待つ
7. <!--(optional) Help land your PR on the upstream repository now that your changes are in nightly.-->
    （オプション）変更が夜間になるように、PRを上流のレポジトリに登録するのを助けます。
8. <!--(optional) Send a PR to rust-lang/rust updating the submodule.-->
    （オプション）サブモジュールを更新するrust-lang / rustにPRを送ります。

#### <!--Updating submodules--> サブモジュールの更新
[updating-submodules]: #updating-submodules

<!--These instructions are specific to updating `rustfmt`, however they may apply to the other submodules as well.-->
これらの命令は`rustfmt`更新に`rustfmt`が、他のサブモジュールにも適用される可能性があります。
<!--Please help by improving these instructions if you find any discrepancies or special cases that need to be addressed.-->
矛盾や特別なケースが見つかった場合は、この手順を改善して対応してください。

<!--To update the `rustfmt` submodule, start by running the appropriate [`git submodule` command](https://git-scm.com/book/en/v2/Git-Tools-Submodules).-->
`rustfmt`サブモジュールを更新するには、適切な[`git submodule`コマンドを](https://git-scm.com/book/en/v2/Git-Tools-Submodules)実行します。
<!--For example, to update to the latest commit on the remote master branch, you may want to run: ` ``git submodule update --remote src/tools/rustfmt`` `If you run`./x.py build` now, and you are lucky, it may just work.-->
たとえば、リモートマスターブランチ上の最新のコミットに更新するには、` ``git submodule update --remote src/tools/rustfmt`` `If you run`よいでしょう。今すぐ./x.py build` `If you run`と、それだけでうまくいくかもしれません。
<!--If you see an error message about patches that did not resolve to any crates, you will need to complete a few more steps which are outlined with their rationale below.-->
クレートに解決されなかったパッチに関するエラーメッセージが表示された場合は、以下の根拠に基づいて説明されているいくつかの手順を完了する必要があります。

<!--*(This error may change in the future to include more information.)* ` ``error: failed to resolve patches for `https://github.com/rust-lang-nursery/rustfmt` Caused by: patch for `rustfmt-nightly` in `https://github.com/rust-lang-nursery/rustfmt` did not resolve to any crates failed to run: ~/rust/build/x86_64-unknown-linux-gnu/stage0/bin/cargo build --manifest-path ~/rust/src/bootstrap/Cargo.toml`` `-->
*（このエラーは将来的に変更される可能性があります）* ` ``error: failed to resolve patches for `https://github.com/rust-lang-nursery/rustfmt` Caused by: patch for `rustfmt-nightly` in `https://github.com/rust-lang-nursery/rustfmt` did not resolve to any crates failed to run: ~/rust/build/x86_64-unknown-linux-gnu/stage0/bin/cargo build --manifest-path ~/rust/src/bootstrap/Cargo.toml`` `

<!--If you haven't used the `[patch]` section of `Cargo.toml` before, there is [some relevant documentation about it in the cargo docs](http://doc.crates.io/manifest.html#the-patch-section).-->
以前に`Cargo.toml` `[patch]`セクションを使用していない場合[は、それに関する関連文書が貨物文書にあり](http://doc.crates.io/manifest.html#the-patch-section)ます。
<!--In addition to that, you should read the [Overriding dependencies](http://doc.crates.io/specifying-dependencies.html#overriding-dependencies) section of the documentation as well.-->
それに加えて、ドキュメンテーションの「 [依存関係](http://doc.crates.io/specifying-dependencies.html#overriding-dependencies)の[オーバーライド」も](http://doc.crates.io/specifying-dependencies.html#overriding-dependencies)参照してください。

<!--Specifically, the following [section in Overriding dependencies](http://doc.crates.io/specifying-dependencies.html#testing-a-bugfix) reveals what the problem is:-->
具体的には、[依存関係の上書き](http://doc.crates.io/specifying-dependencies.html#testing-a-bugfix)の次の[セクションで](http://doc.crates.io/specifying-dependencies.html#testing-a-bugfix)は、問題の内容を明らかにする：

> <!--Next up we need to ensure that our lock file is updated to use this new version of uuid so our project uses the locally checked out copy instead of one from crates.io.-->
> 次に、uuidの新しいバージョンを使用するようにロックファイルが更新されるようにして、プロジェクトがcrates.ioのものではなくローカルでチェックアウトされたコピーを使用するようにする必要があります。
> <!--The way [patch] works is that it'll load the dependency at../path/to/uuid and then whenever crates.io is queried for versions of uuid it'll also return the local version.-->
> [patch]仕組みは、../path/to/uuidに依存関係をロードし、crates.ioにuuidのバージョンがあるかどうか問い合わせると、ローカルバージョンも返されます。
> 
> <!--This means that the version number of the local checkout is significant and will affect whether the patch is used.-->
> つまり、ローカルチェックアウトのバージョン番号が重要であり、パッチが使用されているかどうかに影響します。
> <!--Our manifest declared uuid = "1.0"which means we'll only resolve to >= 1.0.0, < 2.0.0, and Cargo's greedy resolution algorithm also means that we'll resolve to the maximum version within that range.-->
> 私たちのマニフェストは、uuid = "1.0"と宣言しました。これは、= 1.0.0、<2.0.0に解決されることを意味し、Cargoの貪欲分解アルゴリズムは、その範囲内の最大バージョンに解決することを意味します。
> <!--Typically this doesn't matter as the version of the git repository will already be greater or match the maximum version published on crates.io, but it's important to keep this in mind!-->
> 一般的に、gitリポジトリのバージョンは既にcrates.ioに公開されている最大バージョンと同じかそれ以上になるので問題はありませんが、これを覚えておくことが重要です！

<!--This says that when we updated the submodule, the version number in our `src/tools/rustfmt/Cargo.toml` changed.-->
これは、サブモジュールを更新したときに`src/tools/rustfmt/Cargo.toml`のバージョン番号が変更されたことを示しています。
<!--The new version is different from the version in `Cargo.lock`, so the build can no longer continue.-->
新しいバージョンは`Cargo.lock`バージョンとは異なるので、ビルドはもはや続行できません。

<!--To resolve this, we need to update `Cargo.lock`.-->
これを解決するには、`Cargo.lock`を更新する必要があります。
<!--Luckily, cargo provides a command to do this easily.-->
幸いにも、貨物はこれを簡単に行うためのコマンドを提供します。

<!--First, go into the `src/` directory since that is where `Cargo.toml` is in the rust repository.-->
まず、`Cargo.toml`が錆のリポジトリにあるので、`src/`ディレクトリに移動します。
<!--Then run, `cargo update -p rustfmt-nightly` to solve the problem.-->
次に、`cargo update -p rustfmt-nightly`を実行して問題を解決します。

```
$ cd src
$ cargo update -p rustfmt-nightly
```

<!--This should change the version listed in `src/Cargo.lock` to the new version you updated the submodule to.-->
これにより、`src/Cargo.lock`にリストされているバージョンが、サブモジュールを更新した新しいバージョンに変更されます。
<!--Running `./x.py build` should work now.-->
今すぐ`./x.py build`を実行`./x.py build`必要があります。

## <!--Writing Documentation--> ドキュメントの作成
[writing-documentation]: #writing-documentation

<!--Documentation improvements are very welcome.-->
ドキュメントの改善は大歓迎です。
<!--The source of `doc.rust-lang.org` is located in `src/doc` in the tree, and standard API documentation is generated from the source code itself.-->
`doc.rust-lang.org`のソースはツリーの`src/doc`にあり、標準APIドキュメントはソースコード自体から生成されます。

<!--Documentation pull requests function in the same way as other pull requests, though you may see a slightly different form of `r+`:-->
ドキュメンテーションのプルリクエストは、他のプルリクエストと同じように機能しますが、わずかに異なる形式の`r+`が表示されることがあります。

<!--@bors: r+ 38fe8d2 rollup-->
@bors：r + 38fe8d2ロールアップ

<!--That additional `rollup` tells @bors that this change is eligible for a 'rollup'.-->
追加の`rollup`は、この変更が 'ロールアップ'に適格であることを@borsに伝えます。
<!--To save @bors some work, and to get small changes through more quickly, when @bors attempts to merge a commit that's rollup-eligible, it will also merge the other rollup-eligible patches too, and they'll get tested and merged at the same time.-->
@borsがいくつかの作業を節約し、より迅速に小さな変更を得るために、@borsがロールアップ対象のコミットをマージしようとすると、他のロールアップ適格なパッチもマージします。同じ時間。

<!--To find documentation-related issues, sort by the [T-doc label][tdoc].-->
ドキュメントに関する問題を見つけるには、[T-docラベル][tdoc]でソートします。

[tdoc]: https://github.com/rust-lang/rust/issues?q=is%3Aopen%20is%3Aissue%20label%3AT-doc

<!--You can find documentation style guidelines in [RFC 1574][rfc1574].-->
[RFC 1574][rfc1574]でドキュメントスタイルガイドラインを見つけることができます。

[rfc1574]: https://github.com/rust-lang/rfcs/blob/master/text/1574-more-api-documentation-conventions.md#appendix-a-full-conventions-text

<!--In many cases, you don't need a full `./x.py doc`.-->
多くの場合、完全な`./x.py doc`は必要ありません。
<!--You can use `rustdoc` directly to check small fixes.-->
`rustdoc`直接使用して小さな修正をチェックすることができます。
<!--For example, `rustdoc src/doc/reference.md` will render reference to `doc/reference.html`.-->
例えば、`rustdoc src/doc/reference.md`への参照レンダリングする`doc/reference.html`。
<!--The CSS might be messed up, but you can verify that the HTML is right.-->
CSSがうまくいかないかもしれませんが、HTMLが正しいかどうかを確認できます。

## <!--Issue Triage--> 発行トリアージ
[issue-triage]: #issue-triage

<!--Sometimes, an issue will stay open, even though the bug has been fixed.-->
場合によっては、バグが修正されているにもかかわらず、問題が開いたままになることがあります。
<!--And sometimes, the original bug may go stale because something has changed in the meantime.-->
その間に何かが変わったため、元のバグが古くなることがあります。

<!--It can be helpful to go through older bug reports and make sure that they are still valid.-->
より古いバグレポートを調べ、それらがまだ有効であることを確認することは役に立ちます。
<!--Load up an older issue, double check that it's still true, and leave a comment letting us know if it is or is not.-->
古い問題を読み込んで、それが本当であることを再度確認して、それがあるかどうかを知らせるコメントを残してください。
<!--The [least recently updated sort][lru] is good for finding issues like this.-->
[最も最近に更新されたソート][lru]は、このような問題を見つけるのに適しています。

<!--Contributors with sufficient permissions on the Rust repo can help by adding labels to triage issues:-->
Rustリポジトリに十分な権限を持つコントリビュータは、トリアージ問題にラベルを追加することによって役立ちます。

* <!--Yellow, **A** -prefixed labels state which **area** of the project an issue relates to.-->
   黄色、**A**プレフィックス付きのラベルは、プロジェクトのどの**領域**に問題が関連しているかを示します。

* <!--Magenta, **B** -prefixed labels identify bugs which are **blockers**.-->
   マゼンタ、**B -**プレフィックス付きのラベルは**ブロッカーである**バグを識別します。

* <!--Dark blue, **beta-** labels track changes which need to be backported into the beta branches.-->
   ダークブルーの**ベータ**ラベルは、ベータブランチにバックポートする必要がある変更を追跡します。

* <!--Light purple, **C** -prefixed labels represent the **category** of an issue.-->
   明るい紫色の**C**プレフィックス付きラベルは、問題の**カテゴリ**を表し**ます**。

* <!--Green, **E** -prefixed labels explain the level of **experience** necessary to fix the issue.-->
   緑、**E**プレフィックス付きラベルは、問題を解決するために必要な**経験**のレベルを説明します。

* <!--The dark blue **final-comment-period** label marks bugs that are using the RFC signoff functionality of [rfcbot][rfcbot] and are currenty in the final comment period.-->
   ダークブルーの**最終コメント期間**ラベルは、[rfcbot][rfcbot] RFCサインオフ機能を使用しているバグをマークし、最終的なコメント期間にcurrentyです。

* <!--Red, **I** -prefixed labels indicate the **importance** of the issue.-->
   赤、**I-**プレフィックス付きラベルは、問題の**重要性**を示します。
<!--The [I-nominated][inom] label indicates that an issue has been nominated for prioritizing at the next triage meeting.-->
   [I-nominated][inom]ラベルは、問題が次のトリアージ会議で優先順位をつけるために[I-nominated][inom]たことを示しています。

* <!--The purple **metabug** label marks lists of bugs collected by other categories.-->
   紫**メタボックスの**ラベルは、他のカテゴリで収集されたバグのリストです。

* <!--Purple gray, **O** -prefixed labels are the **operating system** or platform that this issue is specific to.-->
   紫色の灰色の**O**接頭語は、この問題が固有の**オペレーティングシステム**またはプラットフォームです。

* <!--Orange, **P** -prefixed labels indicate a bug's **priority**.-->
   オレンジ色、**P**プレフィックス付きのラベルは、バグの**優先順位を**示し**ます**。
<!--These labels are only assigned during triage meetings, and replace the [I-nominated][inom] label.-->
   これらのラベルは、トリアージ会議でのみ割り当てられ、[I-nominated][inom]ラベルを置き換えます。

* <!--The gray **proposed-final-comment-period** label marks bugs that are using the RFC signoff functionality of [rfcbot][rfcbot] and are currently awaiting signoff of all team members in order to enter the final comment period.-->
   **提案された最後のコメント期間**ラベルは、[rfcbot][rfcbot] RFCサインオフ機能を使用しているバグをマークし、最終的なコメント期間を入力するために現在すべてのチームメンバーのサインオフを待っています。

* <!--Pink, **regression** -prefixed labels track regressions from stable to the release channels.-->
   ピンク、**回帰式**プレフィックス付きラベルは、安定した状態からリリースチャンネルまで回帰を追跡します。

* <!--The light orange **relnotes** label marks issues that should be documented in the release notes of the next release.-->
   明るいオレンジ色の**RELNOTESラベル**は、次のリリースのリリースノートに記載されなければならない問題点をマーク。

* <!--Gray, **S** -prefixed labels are used for tracking the **status** of pull requests.-->
   灰色の**S**字の付いたラベルは、プル要求の**状態**を追跡するために使用されます。

* <!--Blue, **T** -prefixed bugs denote which **team** the issue belongs to.-->
   青、**Tの**付いたバグは、問題が属する**チームを**示します。

<!--If you're looking for somewhere to start, check out the [E-easy][eeasy] tag.-->
開始する場所を探している場合は、[E-easy][eeasy]タグを確認してください。

<!--[inom]: https://github.com/rust-lang/rust/issues?q=is%3Aopen+is%3Aissue+label%3AI-nominated
 [eeasy]: https://github.com/rust-lang/rust/issues?q=is%3Aopen+is%3Aissue+label%3AE-easy
 [lru]: https://github.com/rust-lang/rust/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-asc
 [rfcbot]: https://github.com/anp/rfcbot-rs/
-->
[inom]: https://github.com/rust-lang/rust/issues?q=is%3Aopen+is%3Aissue+label%3AI-nominated
 [eeasy]: https://github.com/rust-lang/rust/issues?q=is%3Aopen+is%3Aissue+label%3AE-easy
 [lru]: https://github.com/rust-lang/rust/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-asc
 [rfcbot]: https://github.com/anp/rfcbot-rs/


## <!--Out-of-tree Contributions--> ツリーからの寄稿
[out-of-tree-contributions]: #out-of-tree-contributions

<!--There are a number of other ways to contribute to Rust that don't deal with this repository.-->
Rustに貢献するには、このリポジトリを扱わない他の多くの方法があります。

<!--Answer questions in [#rust][pound-rust], or on [users.rust-lang.org][users], or on [StackOverflow][so].-->
[#rust][pound-rust]、 [users.rust-lang.org][users]、または[StackOverflow][so]質問に答えて[#rust][pound-rust]。

<!--Participate in the [RFC process](https://github.com/rust-lang/rfcs).-->
[RFCプロセスに](https://github.com/rust-lang/rfcs)参加[する](https://github.com/rust-lang/rfcs)。

<!--Find a [requested community library][community-library], build it, and publish it to [Crates.io](http://crates.io).-->
[要求されたコミュニティライブラリ][community-library]を見つけてビルドし、それを[Crates.io](http://crates.io)公開し[Crates.io](http://crates.io)。
<!--Easier said than done, but very, very valuable!-->
簡単に言ったが、非常に、非常に貴重！

<!--[pound-rust]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
 [users]: https://users.rust-lang.org/
 [so]: http://stackoverflow.com/questions/tagged/rust
 [community-library]: https://github.com/rust-lang/rfcs/labels/A-community-library
-->
[pound-rust]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
 [users]: https://users.rust-lang.org/
 [so]: http://stackoverflow.com/questions/tagged/rust
 [community-library]: https://github.com/rust-lang/rfcs/labels/A-community-library


## <!--Helpful Links and Information--> 役に立つリンクと情報
[helpful-info]: #helpful-info

<!--For people new to Rust, and just starting to contribute, or even for more seasoned developers, some useful places to look for information are:-->
錆に慣れていて、貢献し始めたばかりの人や、経験豊かな開発者にとっては、情報を探す便利な場所は次のとおりです。

* <!--The [rustc guide] contains information about how various parts of the compiler work-->
   [rustc guide]には、コンパイラがどのように動作するかについての情報が含まれています
* <!--[Rust Forge][rustforge] contains additional documentation, including write-ups of how to achieve common tasks-->
   [Rust Forgeに][rustforge]は、一般的なタスクを達成するための覚書
* <!--The [Rust Internals forum][rif], a place to ask questions and discuss Rust's internals-->
   [Rust Internalsフォーラム][rif]。Rustの内部について質問し、議論する場所。
* <!--The [generated documentation for rust's compiler][gdfrustc]-->
   [錆のコンパイラのために生成されたドキュメント][gdfrustc]
* <!--The [rust reference][rr], even though it doesn't specifically talk about Rust's internals, it's a great resource nonetheless-->
   [錆の参照][rr]は、それが特にRustの内部について話すわけではありませんが、それにもかかわらず素晴らしいリソースです
* <!--Although out of date, [Tom Lee's great blog article][tlgba] is very helpful-->
   時代遅れですが、[Tom Leeの素晴らしいブログ記事][tlgba]はとても役に立ちます
* <!--[rustaceans.org][ro] is helpful, but mostly dedicated to IRC-->
   [rustaceans.org][ro]は役に立ちますが、主にIRC専用です
* <!--The [Rust Compiler Testing Docs][rctd]-->
   [錆コンパイラのテスト文書][rctd]
* <!--For @bors, [this cheat sheet][cheatsheet] is helpful (Remember to replace `@homu` with `@bors` in the commands that you use.)-->
   @borsの場合、[このチートシート][cheatsheet]は参考になります（使用するコマンドの`@homu`を`@bors`に置き換えることを忘れないでください）。
* <!--**Google!**-->
   **Google！**
<!--([search only in Rust Documentation][gsearchdocs] to find types, traits, etc. quickly)-->
   （タイプ、特性などをすばやく見つけるため[にRust Documentationでのみ検索][gsearchdocs]する）
* <!--Don't be afraid to ask!-->
   聞くのを恐れるな！
<!--The Rust community is friendly and helpful.-->
   Rustコミュニティは、フレンドリーで役立ちます。

<!--[rustc guide]: https://rust-lang-nursery.github.io/rustc-guide/about-this-guide.html
 [gdfrustc]: http://manishearth.github.io/rust-internals-docs/rustc/
 [gsearchdocs]: https://www.google.com/search?q=site:doc.rust-lang.org+your+query+here
 [rif]: http://internals.rust-lang.org
 [rr]: https://doc.rust-lang.org/book/README.html
 [rustforge]: https://forge.rust-lang.org/
 [tlgba]: http://tomlee.co/2014/04/a-more-detailed-tour-of-the-rust-compiler/
 [ro]: http://www.rustaceans.org/
 [rctd]: ./src/test/COMPILER_TESTS.md
 [cheatsheet]: https://buildbot2.rust-lang.org/homu/
-->
[rustc guide]: https://rust-lang-nursery.github.io/rustc-guide/about-this-guide.html
 [gdfrustc]: http://manishearth.github.io/rust-internals-docs/rustc/
 [gsearchdocs]: https://www.google.com/search?q=site:doc.rust-lang.org+your+query+here
 [rif]: http://internals.rust-lang.org
 [rr]: https://doc.rust-lang.org/book/README.html
 [rustforge]: https://forge.rust-lang.org/
 [tlgba]: http://tomlee.co/2014/04/a-more-detailed-tour-of-the-rust-compiler/
 [ro]: http://www.rustaceans.org/
 [rctd]: ./src/test/COMPILER_TESTS.md
 [cheatsheet]: https://buildbot2.rust-lang.org/homu/

