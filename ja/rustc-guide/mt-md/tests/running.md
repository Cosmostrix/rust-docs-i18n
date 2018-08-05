# <!--Running tests--> テストの実行

<!--You can run the tests using `x.py`.-->
`x.py`を使用してテストを実行できます。
<!--The most basic command – which you will almost never want to use!-->
最も基本的なコマンド -あなたはほとんど使用したくないでしょう！
<!--– is as follows:-->
-以下のとおりであります：

```bash
> ./x.py test
```

<!--This will build the full stage 2 compiler and then run the whole test suite.-->
これにより、完全なステージ2コンパイラが構築され、テストスイート全体が実行されます。
<!--You probably don't want to do this very often, because it takes a very long time, and anyway bors / travis will do it for you.-->
非常に長い時間がかかり、とにかく犬やトラヴィスがあなたのためにやってくれるので、これを頻繁にやりたいとは思わないでしょう。
<!--(Often, I will run this command in the background after opening a PR that I think is done, but rarely otherwise. -nmatsakis)-->
（しばしば、私は完了したと思われるPRを開いた後、バックグラウンドでこのコマンドを実行しますが、めったにそうではありません。-nmatsakis）

<!--The test results are cached and previously successful tests are `ignored` during testing.-->
テスト結果はキャッシュされ、以前に成功したテストはテスト中に`ignored`れます。
<!--The stdout/stderr contents as well as a timestamp file for every test can be found under `build/ARCH/test/`.-->
stdout / stderrの内容と各テストのタイムスタンプファイルは、`build/ARCH/test/`ます。
<!--To force-rerun a test (eg in case the test runner fails to notice a change) you can simply remove the timestamp file.-->
テストを強制的に再実行するには（たとえば、テストランナーが変更に気付かなかった場合など）、タイムスタンプファイルを削除するだけです。

## <!--Running a subset of the test suites--> テストスイートのサブセットの実行

<!--When working on a specific PR, you will usually want to run a smaller set of tests, and with a stage 1 build.-->
特定のPRで作業する場合は、通常、より小さなテストセットを実行し、ステージ1のビルドを実行したいと考えています。
<!--For example, a good "smoke test"that can be used after modifying rustc to see if things are generally working correctly would be the following:-->
たとえば、正常に動作しているかどうかを確認するためにrustcを変更した後に使用できる良い「スモークテスト」は、次のようになります。

```bash
> ./x.py test --stage 1 src/test/{ui,compile-fail,run-pass}
```

<!--This will run the `ui`, `compile-fail`, and `run-pass` test suites, and only with the stage 1 build.-->
これは、`ui`、 `compile-fail`、および`run-pass`テストスイートを`run-pass`し、ステージ1のビルドのみを`run-pass`ます。
<!--Of course, the choice of test suites is somewhat arbitrary, and may not suit the task you are doing.-->
もちろん、テストスイートの選択はやや恣意的であり、あなたがやっている仕事に合わないかもしれません。
<!--For example, if you are hacking on debuginfo, you may be better off with the debuginfo test suite:-->
たとえば、debuginfoをハッキングしている場合は、debuginfoテストスイートを使用する方がよい場合があります。

```bash
> ./x.py test --stage 1 src/test/debuginfo
```

<!--**Warning:** Note that bors only runs the tests with the full stage 2 build;-->
**警告：** borsは、完全なステージ2ビルドのテストのみを実行します。
<!--therefore, while the tests **usually** work fine with stage 1, there are some limitations.-->
したがって、テスト**は通常**ステージ1で正常に動作しますが、いくつかの制限があります。
<!--In particular, the stage1 compiler doesn't work well with procedural macros or custom derive tests.-->
特に、stage1コンパイラは手続き型マクロやカスタム導出テストではうまく機能しません。

## <!--Running an individual test--> 個別のテストの実行

<!--Another common thing that people want to do is to run an **individual test**, often the test they are trying to fix.-->
人々がやりたいことのもう一つの共通点は、**個々のテスト**を実行することです。これは、しばしば修正しようとしているテストです。
<!--One way to do this is to invoke `x.py` with the `--test-args` option:-->
これを行う1つの方法は、--`--test-args`オプションを`x.py`して`--test-args`を起動すること`x.py`。

```bash
> ./x.py test --stage 1 src/test/ui --test-args issue-1234
```

<!--Under the hood, the test runner invokes the standard rust test runner (the same one you get with `#[test]`), so this command would wind up filtering for tests that include "issue-1234"in the name.-->
フードの下では、テストランナーが標準の錆試験ランナー（`#[test]`と同じもの）を呼び出します。このコマンドは、名前に「issue-1234」を含むテストのフィルタリングを行います。

<!--Often, though, it's easier to just run the test by hand.-->
しかし、しばしば手作業でテストを実行するほうが簡単です。
<!--Most tests are just `rs` files, so you can do something like-->
ほとんどのテストは`rs`ファイルなので、次のようなことができます

```bash
> rustc +stage1 src/test/ui/issue-1234.rs
```

<!--This is much faster, but doesn't always work.-->
これははるかに高速ですが、常に機能するとは限りません。
<!--For example, some tests include directives that specify specific compiler flags, or which rely on other crates, and they may not run the same without those options.-->
たとえば、特定のコンパイラフラグを指定するディレクティブや、他のクレートに依存するディレクティブが含まれます。

