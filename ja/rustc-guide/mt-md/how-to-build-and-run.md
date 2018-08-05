# <!--How to build the compiler and run what you built--> コンパイラをビルドし、ビルドしたものを実行する方法

<!--The compiler is built using a tool called `x.py`.-->
コンパイラは`x.py`というツールを使ってビルドされています。
<!--You will need to have Python installed to run it.-->
Pythonをインストールして実行する必要があります。
<!--But before we get to that, if you're going to be hacking on `rustc`, you'll want to tweak the configuration of the compiler.-->
しかし、それに`rustc`する前に、もしあなたが`rustc`ハッキングしようとする`rustc`、あなたはコンパイラの設定を微調整したいでしょう。
<!--The default configuration is oriented towards running the compiler as a user, not a developer.-->
既定の構成は、開発者ではなくユーザーとしてコンパイラを実行することを目的としています。

### <!--Create a config.toml--> config.tomlを作成する

<!--To start, copy [`config.toml.example`] to `config.toml`:-->
コピー、開始するには[`config.toml.example`]する`config.toml`：

[`config.toml.example`]: https://github.com/rust-lang/rust/blob/master/config.toml.example

```bash
> cd $RUST_CHECKOUT
> cp config.toml.example config.toml
```

<!--Then you will want to open up the file and change the following settings (and possibly others, such as `llvm.ccache`):-->
次に、ファイルを開いて、次の設定を変更します（おそらく`llvm.ccache`など）。

```toml
[llvm]
# Enables LLVM assertions, which will check that the LLVM bitcode generated
# by the compiler is internally consistent. These are particularly helpful
# if you edit `trans`.
assertions = true

[rust]
# This enables some assertions, but more importantly it enables the `debug!`
# logging macros that are essential for debugging rustc.
debug-assertions = true

# This will make your build more parallel; it costs a bit of runtime
# performance perhaps (less inlining) but it's worth it.
codegen-units = 0

# I always enable full debuginfo, though debuginfo-lines is more important.
debuginfo = true

# Gives you line numbers for backtraces.
debuginfo-lines = true

# Using the system allocator (instead of jemalloc) means that tools
# like valgrind and memcache work better.
use-jemalloc = false
```

### <!--Running x.py and building a stage1 compiler--> x.pyを実行し、stage1コンパイラを構築する

<!--One thing to keep in mind is that `rustc` is a  _bootstrapping_  compiler.-->
心に留めておくべきことの1つは、`rustc`が _ブートストラッピング_ コンパイラであることです。
<!--That is, since `rustc` is written in Rust, we need to use an older version of the compiler to compile the newer version.-->
つまり、`rustc`はRustで書かれているので、古いバージョンのコンパイラを使用して新しいバージョンをコンパイルする必要があります。
<!--In particular, the newer version of the compiler, `libstd`, and other tooling may use some unstable features internally.-->
特に、新しいバージョンのコンパイラ、`libstd`、およびその他のツールでは、内部的に不安定な機能が使用される可能性があります。
<!--The result is the compiling `rustc` is done in stages.-->
その結果、コンパイルされた`rustc`が段階的に実行されます。

- <!--**Stage 0:** the stage0 compiler can be your existing (perhaps older version of) Rust compiler, the current  _beta_  compiler or you may download the binary from the internet.-->
   **ステージ0：** stage0コンパイラは、既存の（おそらく古いバージョンの）Rustコンパイラ、現在の _ベータ_ コンパイラ、またはインターネットからバイナリをダウンロードすることができます。
- <!--**Stage 1:** the code in your clone (for new version) is then compiled with the stage0 compiler to produce the stage1 compiler.-->
   **ステージ1：**クローン内のコード（新しいバージョン用）はstage0コンパイラでコンパイルされ、stage1コンパイラが生成されます。
<!--However, it was built with an older compiler (stage0), so to optimize the stage1 compiler we go to next stage.-->
   しかし、それは古いコンパイラ（stage0）で構築されています。したがって、stage1コンパイラを最適化するために、次の段階に進みます。
- <!--**Stage 2:** we rebuild our stage1 compiler with itself to produce the stage2 compiler (ie it builds itself) to have all the  _latest optimizations_ .-->
   **ステージ2：** stage1コンパイラを再構築して、 _最新の最適化_ をすべて行うためにstage2コンパイラを作成します（つまり、自身をビルドします）。
- <!-- _(Optional)_  **Stage 3**: to sanity check of our new compiler, we can build it again with stage2 compiler which must be identical to itself, unless something has broken.-->
    _（オプション）_  **ステージ3**：新しいコンパイラのサニティチェックには、何かが壊れていない限り、それ自身と同じでなければならないstage2コンパイラで再度ビルドすることができます。

<!--For hacking, often building the stage 1 compiler is enough, but for final testing and release, the stage 2 compiler is used.-->
ハッキングのために、しばしばステージ1コンパイラを構築するだけで十分ですが、最終的なテストとリリースでは、ステージ2コンパイラが使用されます。

<!--`./x.py check` is really fast to build the rust compiler.-->
`./x.py check`はrustコンパイラを構築するのに本当に速いです。
<!--It is, in particular, very useful when you're doing some kind of "type-based refactoring", like renaming a method, or changing the signature of some function.-->
これは、メソッド名の変更や関数のシグネチャの変更など、「タイプベースのリファクタリング」を実行しているときに特に便利です。

<!--Once you've created a config.toml, you are now ready to run `x.py`.-->
config.tomlを作成したら、`x.py`を実行する準備が整いました。
<!--There are a lot of options here, but let's start with what is probably the best "go to"command for building a local rust:-->
ここにはたくさんのオプションがありますが、おそらく地方の錆を作るための最良の "行く"コマンドで始めるでしょう：

```bash
> ./x.py build -i --stage 1 src/libstd
```

<!--What this command will do is the following:-->
このコマンドが実行する内容は次のとおりです。

- <!--Using the beta compiler (also called stage 0), it will build the standard library and rustc from the `src` directory.-->
   ベータコンパイラ（ステージ0とも呼ばれる）を使用して、`src`ディレクトリから標準ライブラリとrustcをビルドします。
<!--The resulting compiler is called the "stage 1"compiler.-->
   結果のコンパイラは、「ステージ1」コンパイラと呼ばれます。
  - <!--During this build, the `-i` (or `--incremental`) switch enables incremental compilation, so that if you later rebuild after editing things in `src`, you can save a bit of time.-->
     このビルド中に、`-i`（または`--incremental`）スイッチを使用するとインクリメンタルコンパイルが可能になります。そのため、後で`src`での編集後に再構築すると、少し時間を節約できます。
- <!--Using this stage 1 compiler, it will build the standard library.-->
   このステージ1コンパイラを使用して、標準ライブラリを構築します。
<!--(this is what the `src/libstd`) means.-->
   （これは`src/libstd`意味です）。

<!--This is just a subset of the full rustc build.-->
これは完全なrustcビルドの一部です。
<!--The **full** rustc build (what you get if you just say `./x.py build`) has quite a few more steps:-->
（あなただけ言うならば何を得る**のフル** rustcビルド`./x.py build`）かなりの数より多くのステップがあります：

- <!--Build stage1 rustc with stage0 compiler.-->
   ステージ0コンパイラでステージ1を構築します。
- <!--Build libstd with stage1 compiler (up to here is the same).-->
   stage1コンパイラでlibstdをビルドします（ここまでは同じです）。
- <!--Build rustc from `src` again, this time with the stage1 compiler (this part is new).-->
   再度`src`からrustcをビルドします。今回はstage1コンパイラを使用します（この部分は新しくなりました）。
  - <!--The resulting compiler here is called the "stage2"compiler.-->
     ここで得られたコンパイラは、"stage2"コンパイラと呼ばれます。
- <!--Build libstd with stage2 compiler.-->
   stage2コンパイラでlibstdをビルドします。
- <!--Build librustdoc and a bunch of other things.-->
   librustdocと他のものを作りなさい。

### <!--Creating a rustup toolchain--> 錆びたツールチェーンを作成する

<!--Once you have successfully built rustc, you will have created a bunch of files in your `build` directory.-->
rustcを正常に`build`すると、`build`ディレクトリに一連のファイルが作成されます。
<!--In order to actually run the resulting rustc, we recommend creating rustup toolchains.-->
結果として生じる錆びを実際に実行するには、錆びたツールチェーンを作成することをお勧めします。
<!--The first one will run the stage1 compiler (which we built above).-->
最初のものはstage1コンパイラを実行します（上記で作成しました）。
<!--The second will execute the stage2 compiler (which we did not build, but which you will likely need to build at some point; for example, if you want to run the entire test suite).-->
2番目はstage2コンパイラを実行します（これはビルドしませんでしたが、テストスイート全体を実行する場合など、ある時点でビルドする必要があります）。

```bash
> rustup toolchain link stage1 build/<host-triple>/stage1
> rustup toolchain link stage2 build/<host-triple>/stage2
```

<!--Now you can run the rustc you built with.-->
今では、あなたが構築したrustcを実行することができます。
<!--If you run with `-vV`, you should see a version number ending in `-dev`, indicating a build from your local environment:-->
`-vV`を指定して実行すると、ローカル環境のビルドを示す`-dev`で終わるバージョン番号が表示されます。

```bash
> rustc +stage1 -vV
rustc 1.25.0-dev
binary: rustc
commit-hash: unknown
commit-date: unknown
host: x86_64-unknown-linux-gnu
release: 1.25.0-dev
LLVM version: 4.0
```

### <!--Other x.py commands--> その他のx.pyコマンド

<!--Here are a few other useful x.py commands.-->
他にも便利なx.pyコマンドがあります。
<!--We'll cover some of them in detail in other sections:-->
いくつかの部分については、他のセクションで詳しく説明します。

- <!--Building things:-->
   建築物：
  - <!--`./x.py clean` – clean up the build directory (`rm -rf build` works too, but then you have to rebuild LLVM)-->
     `./x.py clean` -ビルドディレクトリをクリーンアップします（`rm -rf build`動作しますが、LLVMを再構築する必要があります）
  - <!--`./x.py build --stage 1` – builds everything using the stage 1 compiler, not just up to libstd-->
     `./x.py build --stage 1` -`./x.py build --stage 1`だけでなく、ステージ1コンパイラを使ってすべてをビルドします
  - <!--`./x.py build` – builds the stage2 compiler-->
     `./x.py build` -stage2コンパイラをビルドする
- <!--Running tests (see the [section on running tests](./tests/running.html) for more details):-->
   テストの実行（詳細はテストの実行[に関する節を](./tests/running.html)参照）：
  - <!--`./x.py test --stage 1 src/libstd` – runs the `#[test]` tests from libstd-->
     `./x.py test --stage 1 src/libstd` -libstdから`#[test]`テストを実行する
  - <!--`./x.py test --stage 1 src/test/run-pass` – runs the `run-pass` test suite-->
     `./x.py test --stage 1 src/test/run-pass` -`./x.py test --stage 1 src/test/run-pass`テストスイートを`run-pass`

### <!--ctags--> ctags

<!--One of the challenges with rustc is that the RLS can't handle it, making code navigation difficult.-->
rustcの課題の1つは、RLSがそれを処理できず、コードのナビゲーションが難しいことです。
<!--One solution is to use `ctags`.-->
1つの解決策は`ctags`を使用する`ctags`です。
<!--The following script can be used to set it up: [https://github.com/nikomatsakis/rust-etags][etags].-->
次のスクリプトを使用して設定することができます： [https://github.com/nikomatsakis/rust-etags][etags]: [https://github.com/nikomatsakis/rust-etags][etags]。

<!--CTAGS integrates into emacs and vim quite easily.-->
CTAGSはemacsとvimに非常に簡単に統合されています。
<!--The following can then be used to build and generate tags:-->
次に、タグを作成して生成するために、以下を使用できます。

```console
$ rust-ctags src/lib* && ./x.py build <something>
```

<!--This allows you to do "jump-to-def"with whatever functions were around when you last built, which is ridiculously useful.-->
これにより、最後にビルドされたときにどのような関数があっても、"jump-to-def"を行うことができます。これは非常に便利です。

[etags]: https://github.com/nikomatsakis/rust-etags
