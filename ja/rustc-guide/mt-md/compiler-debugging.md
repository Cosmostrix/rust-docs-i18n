<!--**Note: This is copied from the [rust-forge](https://github.com/rust-lang-nursery/rust-forge).**-->
**注：これは[rust-forge]（https://github.com/rust-lang-nursery/rust-forge）からコピーされています。**
<!--**If anything needs updating, please open an issue or make a PR on the github repo.**-->
**何か更新が必要な場合は、問題を開いたりgithubリポジトリにPRをしてください。**

# <!--Debugging the compiler--> コンパイラのデバッグ
[debugging]: #debugging

<!--Here are a few tips to debug the compiler:-->
コンパイラをデバッグするためのヒントを次に示します。

## <!--Getting a backtrace--> バックトレースの取得
[getting-a-backtrace]: #getting-a-backtrace

<!--When you have an ICE (panic in the compiler), you can set `RUST_BACKTRACE=1` to get the stack trace of the `panic!` like in normal Rust programs.-->
ICE（コンパイラでパニック）が発生した場合、通常のRustプログラムのように`panic!`スタックトレースを取得するために`RUST_BACKTRACE=1`を設定できます。
<!--IIRC backtraces **don't work** on Mac and on MinGW, sorry.-->
IIRCのバックトレース**は** MacとMinGWで動作しません。
<!--If you have trouble or the backtraces are full of `unknown`, you might want to find some way to use Linux or MSVC on Windows.-->
問題がある場合やバックトレースが`unknown`場合は、Windows上でLinuxまたはMSVCを使用する方法を見つけることができます。

<!--In the default configuration, you don't have line numbers enabled, so the backtrace looks like this:-->
デフォルトの設定では、行番号が有効になっていないので、バックトレースは次のようになります。

```text
stack backtrace:
   0: std::sys::imp::backtrace::tracing::imp::unwind_backtrace
   1: std::sys_common::backtrace::_print
   2: std::panicking::default_hook::{{closure}}
   3: std::panicking::default_hook
   4: std::panicking::rust_panic_with_hook
   5: std::panicking::begin_panic
   (~~~~ LINES REMOVED BY ME FOR BREVITY ~~~~)
  32: rustc_typeck::check_crate
  33: <std::thread::local::LocalKey<T>>::with
  34: <std::thread::local::LocalKey<T>>::with
  35: rustc::ty::context::TyCtxt::create_and_enter
  36: rustc_driver::driver::compile_input
  37: rustc_driver::run_compiler
```

<!--If you want line numbers for the stack trace, you can enable `debuginfo-lines=true` or `debuginfo=true` in your config.toml and rebuild the compiler.-->
スタックトレースの行番号が必要な`debuginfo=true`は、config.tomlで`debuginfo-lines=true`または`debuginfo=true`を有効にしてコンパイラを再構築することができます。
<!--Then the backtrace will look like this:-->
そうすればバックトレースは次のようになります：

```text
stack backtrace:
   (~~~~ LINES REMOVED BY ME FOR BREVITY ~~~~)
             at /home/user/rust/src/librustc_typeck/check/cast.rs:110
   7: rustc_typeck::check::cast::CastCheck::check
             at /home/user/rust/src/librustc_typeck/check/cast.rs:572
             at /home/user/rust/src/librustc_typeck/check/cast.rs:460
             at /home/user/rust/src/librustc_typeck/check/cast.rs:370
   (~~~~ LINES REMOVED BY ME FOR BREVITY ~~~~)
  33: rustc_driver::driver::compile_input
             at /home/user/rust/src/librustc_driver/driver.rs:1010
             at /home/user/rust/src/librustc_driver/driver.rs:212
  34: rustc_driver::run_compiler
             at /home/user/rust/src/librustc_driver/lib.rs:253
```

## <!--Getting a backtrace for errors--> エラーのバックトレースを取得する
[getting-a-backtrace-for-errors]: #getting-a-backtrace-for-errors

<!--If you want to get a backtrace to the point where the compiler emits an error message, you can pass the `-Z treat-err-as-bug`, which will make the compiler panic on the first error it sees.-->
コンパイラがエラーメッセージを出すまでのバックトレースを取得したい場合は、`-Z treat-err-as-bug`を渡すことができます。これにより、最初のエラーでコンパイラのパニックが発生します。

<!--This can also help when debugging `delay_span_bug` calls -it will make the first `delay_span_bug` call panic, which will give you a useful backtrace.-->
これは、`delay_span_bug`呼び出しをデバッグする際にも役立ちます。最初の`delay_span_bug`呼び出しパニックが発生し、有用なバックトレースが得られます。

<!--For example:-->
例えば：

```bash
$ cat error.rs
fn main() {
    1 + ();
}
```

```bash
$ ./build/x86_64-unknown-linux-gnu/stage1/bin/rustc error.rs
error[E0277]: the trait bound `{integer}: std::ops::Add<()>` is not satisfied
 --> error.rs:2:7
  |
2 |     1 + ();
  |       ^ no implementation for `{integer} + ()`
  |
  = help: the trait `std::ops::Add<()>` is not implemented for `{integer}`

error: aborting due to previous error

$ # Now, where does the error above come from?
$ RUST_BACKTRACE=1 \
    ./build/x86_64-unknown-linux-gnu/stage1/bin/rustc \
    error.rs \
    -Z treat-err-as-bug
error[E0277]: the trait bound `{integer}: std::ops::Add<()>` is not satisfied
 --> error.rs:2:7
  |
2 |     1 + ();
  |       ^ no implementation for `{integer} + ()`
  |
  = help: the trait `std::ops::Add<()>` is not implemented for `{integer}`

error: internal compiler error: unexpected panic

note: the compiler unexpectedly panicked. this is a bug.

note: we would appreciate a bug report: https://github.com/rust-lang/rust/blob/master/CONTRIBUTING.md#bug-reports

note: rustc 1.24.0-dev running on x86_64-unknown-linux-gnu

note: run with `RUST_BACKTRACE=1` for a backtrace

thread 'rustc' panicked at 'encountered error with `-Z treat_err_as_bug',
/home/user/rust/src/librustc_errors/lib.rs:411:12
note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose
backtrace.
stack backtrace:
  (~~~ IRRELEVANT PART OF BACKTRACE REMOVED BY ME ~~~)
   7: rustc::traits::error_reporting::<impl rustc::infer::InferCtxt<'a, 'gcx,
             'tcx>>::report_selection_error
             at /home/user/rust/src/librustc/traits/error_reporting.rs:823
   8: rustc::traits::error_reporting::<impl rustc::infer::InferCtxt<'a, 'gcx,
             'tcx>>::report_fulfillment_errors
             at /home/user/rust/src/librustc/traits/error_reporting.rs:160
             at /home/user/rust/src/librustc/traits/error_reporting.rs:112
   9: rustc_typeck::check::FnCtxt::select_obligations_where_possible
             at /home/user/rust/src/librustc_typeck/check/mod.rs:2192
  (~~~ IRRELEVANT PART OF BACKTRACE REMOVED BY ME ~~~)
  36: rustc_driver::run_compiler
             at /home/user/rust/src/librustc_driver/lib.rs:253
$ # Cool, now I have a backtrace for the error
```

## <!--Getting logging output--> ログ出力の取得
[getting-logging-output]: #getting-logging-output

<!--The compiler has a lot of `debug!` calls, which print out logging information at many points.-->
コンパイラには多くの`debug!`機能があり、多くの点でログ情報を出力します。
<!--These are very useful to at least narrow down the location of a bug if not to find it entirely, or just to orient yourself as to why the compiler is doing a particular thing.-->
これらは、少なくともバグの場所を絞り込むことができない場合には、少なくともコンパイラが特定のことをしている理由について自分自身を知るためには非常に便利です。

<!--To see the logs, you need to set the `RUST_LOG` environment variable to your log filter, eg to get the logs for a specific module, you can run the compiler as `RUST_LOG=module::path rustc my-file.rs`.-->
ログを見るには、`RUST_LOG`環境変数をログフィルタに設定する必要があります。たとえば、特定のモジュールのログを取得するには、`RUST_LOG=module::path rustc my-file.rs`としてコンパイラを実行します。
<!--The Rust logs are powered by [env-logger], and you can look at the docs linked there to see the full `RUST_LOG` syntax.-->
Rustログは[env-logger]によって動かされ、そこにリンクされているドキュメントを見れば完全な`RUST_LOG`構文を見ることが`RUST_LOG`ます。
<!--All `debug!` output will then appear in standard error.-->
すべての`debug!`出力が標準エラーで表示されます。

<!--Note that unless you use a very strict filter, the logger will emit a *lot* of output -so it's typically a good idea to pipe standard error to a file and look at the log output with a text editor.-->
非常に厳密なフィルタを使用しない限り、ロガーは*多く*の出力を出すので、通常は標準エラーをファイルに渡し、テキスト出力でログ出力を調べることをお勧めします。

<!--So to put it together.-->
だからそれをまとめる。

```bash
# This puts the output of all debug calls in `librustc/traits` into
# standard error, which might fill your console backscroll.
$ RUST_LOG=rustc::traits rustc +local my-file.rs

# This puts the output of all debug calls in `librustc/traits` in
# `traits-log`, so you can then see it with a text editor.
$ RUST_LOG=rustc::traits rustc +local my-file.rs 2>traits-log

# Not recommended. This will show the output of all `debug!` calls
# in the Rust compiler, and there are a *lot* of them, so it will be
# hard to find anything.
$ RUST_LOG=debug rustc +local my-file.rs 2>all-log

# This will show the output of all `info!` calls in `rustc_trans`.
#
# There's an `info!` statement in `trans_instance` that outputs
# every function that is translated. This is useful to find out
# which function triggers an LLVM assertion, and this is an `info!`
# log rather than a `debug!` log so it will work on the official
# compilers.
$ RUST_LOG=rustc_trans=info rustc +local my-file.rs
```

<!--While calls to `info!` are included in every build of the compiler, calls to `debug!` are only included in the program if the `debug-assertions=yes` is turned on in config.toml (it is turned off by default), so if you don't see `DEBUG` logs, especially if you run the compiler with `RUST_LOG=rustc rustc some.rs` and only see `INFO` logs, make sure that `debug-assertions=yes` is turned on in your config.toml.-->
`info!`呼び出しはコンパイラのすべてのビルドに含まれていますが、`debug!`呼び出しはconfig.tomlで`debug-assertions=yes`がオンになっている場合にのみプログラムに含まれます（デフォルトではオフになっています）。`DEBUG`ログが表示されない、特に`RUST_LOG=rustc rustc some.rs`コンパイラを実行し、`INFO`ログしか表示しない場合は、config.tomlで`debug-assertions=yes`がオンになっていることを確認してください。

<!--I also think that in some cases just setting it will not trigger a rebuild, so if you changed it and you already have a compiler built, you might want to call `x.py clean` to force one.-->
場合によっては再構築をトリガしない設定もあるので、変更してすでにコンパイラをビルドしている場合は、`x.py clean`を呼び出して強制的に呼び出すことをお勧めします。

### <!--Logging etiquette--> ロギングエチケット

<!--Because calls to `debug!` are removed by default, in most cases, don't worry about adding "unnecessary"calls to `debug!` and leaving them in code you commit -they won't slow down the performance of what we ship, and if they helped you pinning down a bug, they will probably help someone else with a different one.-->
`debug!`呼び出しはデフォルトでは削除されているため、ほとんどの場合、`debug!` 「不要な」呼び出しを追加したり、コミットしたコードに残したりする心配はありません。彼らはあなたがバグを固定するのを助けました、彼らはおそらく別のものを持つ他の誰かを助けるでしょう。

<!--However, there are still a few concerns that you might care about:-->
しかし、あなたが心配するかもしれないいくつかの心配がまだあります：

### <!--Expensive operations in logs--> ログの高価な操作

<!--A note of caution: the expressions *within* the `debug!` call are run whenever RUST_LOG is set, even if the filter would exclude the log.-->
注意事項：RUST_LOGが設定されている場合は常に、フィルタがログを除外していても、`debug!`コール*内*の式が実行されます。
<!--This means that if in the module `rustc::foo` you have a statement-->
これは、モジュール`rustc::foo`文がある場合

```Rust
debug!("{:?}", random_operation(tcx));
```

<!--Then if someone runs a debug `rustc` with `RUST_LOG=rustc::bar`, then `random_operation()` will still run -even while it's output will never be needed!-->
その後、誰かが`RUST_LOG=rustc::bar`を`RUST_LOG=rustc::bar`てデバッグ`rustc`を実行すると、`random_operation()`はまだ実行されます。出力は必要ないでしょう！

<!--This means that you should not put anything too expensive or likely to crash there -that would annoy anyone who wants to use logging for their own module.-->
つまり、あまりにも高価なものやクラッシュする可能性のあるものを置くべきではありません。それは、自分のモジュール用のロギングを使用したいと思う人には迷惑をかけることになります。
<!--Note that if `RUST_LOG` is unset (the default), then the code will not run -this means that if your logging code panics, then no-one will know it until someone tries to use logging to find *another* bug.-->
`RUST_LOG`が設定されていない場合（デフォルト）、コードは実行されません。つまり、ロギングコードがパニックの場合、誰かがロギングを使用して*別の*バグを見つけようとするまで、誰も知りません。

<!--If you *need* to do an expensive operation in a log, be aware that while log expressions are *evaluated* even if logging is not enabled in your module, they are not *formatted* unless it *is*.-->
ログで高価な操作を行う*必要*がある場合は、モジュールでログが有効になっていなくてもログ式が*評価さ*れますが、そうでない場合*は* *フォーマットさ*れません。
<!--This means you can put your expensive/crashy operations inside an `fmt::Debug` impl, and they will not be run unless your log is enabled:-->
つまり、高価な/クラッシュした操作を`fmt::Debug` implの中に置くことができ、ログが有効になっていなければ実行されません。

```Rust
use std::fmt;

struct ExpensiveOperationContainer<'a, 'gcx, 'tcx>
    where 'tcx: 'gcx, 'a: 'tcx
{
    tcx: TyCtxt<'a, 'gcx, 'tcx>
}

impl<'a, 'gcx, 'tcx> fmt::Debug for ExpensiveOperationContainer<'a, 'gcx, 'tcx> {
    fn fmt(&self, fmt: &mut fmt::Formatter) -> fmt::Result {
        let value = random_operation(tcx);
        fmt::Debug::fmt(&value, fmt)
    }
}

debug!("{:?}", ExpensiveOperationContainer { tcx });
```

## <!--Formatting Graphviz output (.dot files)--> Graphviz出力のフォーマット（.dotファイル）
[formatting-graphviz-output]: #formatting-graphviz-output

<!--Some compiler options for debugging specific features yield graphviz graphs -eg the `#[rustc_mir(borrowck_graphviz_postflow="suffix.dot")]` attribute dumps various borrow-checker dataflow graphs.-->
特定の機能をデバッグするためのコンパイラオプションの中には、graphvizグラフを生成するものがあります。`#[rustc_mir(borrowck_graphviz_postflow="suffix.dot")]`属性は、さまざまな`#[rustc_mir(borrowck_graphviz_postflow="suffix.dot")]` -Checkerデータフローグラフをダンプします。

<!--These all produce `.dot` files.-->
これらはすべて`.dot`ファイルを生成します。
<!--To view these files, install graphviz (eg `apt-get install graphviz`) and then run the following commands:-->
これらのファイルを表示するには、graphviz（たとえば、`apt-get install graphviz`）を`apt-get install graphviz`、次のコマンドを実行します。

```bash
$ dot -T pdf maybe_init_suffix.dot > maybe_init_suffix.pdf
$ firefox maybe_init_suffix.pdf # Or your favorite pdf viewer
```

## <!--Debugging LLVM--> LLVMのデバッグ
[debugging-llvm]: #debugging-llvm

> <!--NOTE: If you are looking for info about code generation, please see [this chapter][codegen] instead.-->
> 注：コード生成に関する情報をお探しの場合は、[this chapter][codegen]を参照し[this chapter][codegen]ください。

[codegen]: codegen.html

<!--This section is about debugging compiler bugs in code generation (eg why the compiler generated some piece of code or crashed in LLVM).-->
このセクションでは、コード生成におけるコンパイラのバグのデバッグについて説明します（コンパイラがコードを生成したり、LLVMでクラッシュした理由など）。
<!--LLVM is a big project on its own that probably needs to have its own debugging document (not that I could find one).-->
LLVMは独自の大きなプロジェクトで、おそらく独自のデバッグドキュメントを必要とするでしょう（私が見つけ出すことはできません）。
<!--But here are some tips that are important in a rustc context:-->
しかし、ここではさとうな状況で重要ないくつかのヒントがあります：

<!--As a general rule, compilers generate lots of information from analyzing code.-->
原則として、コンパイラは解析コードから多くの情報を生成します。
<!--Thus, a useful first step is usually to find a minimal example.-->
したがって、有用な第1のステップは、通常、最小限の例を見つけることである。
<!--One way to do this is to-->
これを行う1つの方法は、

1. <!--create a new crate that reproduces the issue (eg adding whatever crate is-->
    問題を再現する新しいクレートを作成します（たとえば、クレートを追加するなど）。
<!--at fault as a dependency, and using it from there)-->
依存としての不具合で、そこからそれを使用する）

2. <!--minimize the crate by removing external dependencies;-->
    外部の依存関係を削除してクレートを最小化する。
<!--that is, moving-->
    つまり、動いている
<!--everything relevant to the new crate-->
新しいクレートに関連するすべて

3. <!--further minimize the issue by making the code shorter (there are tools that-->
    コードを短くすることで問題をさらに最小限に抑えます（
<!--help with this like `creduce`)-->
このような`creduce`助けて`creduce`）

<!--The official compilers (including nightlies) have LLVM assertions disabled, which means that LLVM assertion failures can show up as compiler crashes (not ICEs but "real"crashes) and other sorts of weird behavior.-->
公式コンパイラ（ナイトリーを含む）は、LLVMアサーションを無効にしています。つまり、LLVMアサーションの失敗は、ICEではなく実際のクラッシュやその他の奇妙な動作であるコンパイラクラッシュとして表示されます。
<!--If you are encountering these, it is a good idea to try using a compiler with LLVM assertions enabled -either an "alt"nightly or a compiler you build yourself by setting `[llvm] assertions=true` in your config.toml -and see whether anything turns up.-->
これらの問題が発生した場合は、LLVMアサーションを有効にしたコンパイラを使用することをお勧めします。「alt」夜間、またはconfig.tomlに`[llvm] assertions=true`を設定して自分自身を構築するコンパイラ何かが現れます。

<!--The rustc build process builds the LLVM tools into `./build/<host-triple>/llvm/bin`.-->
rustcのビルドプロセスはLLVMツールを`./build/<host-triple>/llvm/bin`ます。
<!--They can be called directly.-->
彼らは直接呼び出すことができます。

<!--The default rustc compilation pipeline has multiple codegen units, which is hard to replicate manually and means that LLVM is called multiple times in parallel.-->
デフォルトのrustcコンパイルパイプラインには複数のcodegenユニットがあります。これは手動で複製するのが難しく、LLVMが複数回並列に呼び出されることを意味します。
<!--If you can get away with it (ie if it doesn't make your bug disappear), passing `-C codegen-units=1` to rustc will make debugging easier.-->
バグが消えない場合は、`-C codegen-units=1`をrustcに渡すと、デバッグが簡単になります。

<!--To rustc to generate LLVM IR, you need to pass the `--emit=llvm-ir` flag.-->
LLVM IRを生成するには、-`--emit=llvm-ir`フラグを渡す必要があります。
<!--If you are building via cargo, use the `RUSTFLAGS` environment variable (eg `RUSTFLAGS='--emit=llvm-ir'`).-->
貨物を使って`RUSTFLAGS`する場合は、環境変数`RUSTFLAGS`使用して`RUSTFLAGS`（例： `RUSTFLAGS='--emit=llvm-ir'`）。
<!--This causes rustc to spit out LLVM IR into the target directory.-->
これにより、rustcはLLVM IRをターゲットディレクトリに吐き出します。

<!--`cargo llvm-ir [options] path` spits out the LLVM IR for a particular function at `path`.-->
`cargo llvm-ir [options] path`にある特定の関数のLLVM IRを吐き出し`path`。
<!--(`cargo install cargo-asm` installs `cargo asm` and `cargo llvm-ir`).-->
（`cargo install cargo-asm` `cargo asm`、 `cargo llvm-ir`と`cargo llvm-ir`設置する）。
<!--`--build-type=debug` emits code for debug builds.-->
`--build-type=debug`は、デバッグビルド用のコードを出力します。
<!--There are also other useful options.-->
その他の便利なオプションもあります。
<!--Also, debug info in LLVM IR can clutter the output a lot: `RUSTFLAGS="-C debuginfo=0"` is really useful.-->
また、LLVM IRのデバッグ情報は出力をたくさん乱雑にする可能性があります： `RUSTFLAGS="-C debuginfo=0"`は本当に便利です。

<!--`RUSTFLAGS="-C save-temps"` outputs LLVM bitcode (not the same as IR) at different stages during compilation, which is sometimes useful.-->
`RUSTFLAGS="-C save-temps"`は、コンパイル中のさまざまな段階でLLVMビットコード（IRと同じではない）を出力します。これは便利なこともあります。
<!--One just needs to convert the bitcode files to `.ll` files using `llvm-dis` which should be in the target local compilation of rustc.-->
1つは、`llvm-dis`を使用して`.ll`コードファイルを`.ll`ファイルに変換する必要があります。これは、rustcのターゲットローカルコンパイルに含める必要があります。

<!--If you want to play with the optimization pipeline, you can use the `opt` tool from `./build/<host-triple>/llvm/bin/` with the LLVM IR emitted by rustc.-->
最適化パイプラインを使いたい場合は、./ `opt` `./build/<host-triple>/llvm/bin/`の`opt`ツールを`./build/<host-triple>/llvm/bin/`したLLVM IRとともに使用できます。
<!--Note that rustc emits different IR depending on whether `-O` is enabled, even without LLVM's optimizations, so if you want to play with the IR rustc emits, you should:-->
rustcは、LLVMの最適化がなくても、`-O`が有効かどうかによって異なるIRを発するので、IR rustcで再生したい場合は、次のようにする必要があります。

```bash
$ rustc +local my-file.rs --emit=llvm-ir -O -C no-prepopulate-passes \
    -C codegen-units=1
$ OPT=./build/$TRIPLE/llvm/bin/opt
$ $OPT -S -O2 < my-file.ll > my
```

<!--If you just want to get the LLVM IR during the LLVM pipeline, to eg see which IR causes an optimization-time assertion to fail, or to see when LLVM performs a particular optimization, you can pass the rustc flag `-C llvm-args=-print-after-all`, and possibly add `-C llvm-args='-filter-print-funcs=EXACT_FUNCTION_NAME` (eg `-C llvm-args='-filter-print-funcs=_ZN11collections3str21_$LT$impl$u20$str$GT$\ 7replace17hbe10ea2e7c809b0bE'`).-->
LLVMパイプライン中にLLVM IRを取得する場合、どのIRが最適化時間アサーションを失敗させるか、LLVMが特定の最適化を実行するかどうかを確認する場合は、rustcフラグ`-C llvm-args=-print-after-all`（例： `-C llvm-args='-filter-print-funcs=_ZN11collections3str21_$LT$impl$u20$str$GT$\ 7replace17hbe10ea2e7c809b0bE'` `-C llvm-args=-print-after-all`追加し、場合によっては`-C llvm-args='-filter-print-funcs=EXACT_FUNCTION_NAME` `-C llvm-args='-filter-print-funcs=_ZN11collections3str21_$LT$impl$u20$str$GT$\ 7replace17hbe10ea2e7c809b0bE'`）。

<!--That produces a lot of output into standard error, so you'll want to pipe that to some file.-->
これは標準エラーに多くの出力を生成するので、そのファイルをいくつかのファイルにパイプしたいと思うでしょう。
<!--Also, if you are using neither `-filter-print-funcs` nor `-C codegen-units=1`, then, because the multiple codegen units run in parallel, the printouts will mix together and you won't be able to read anything.-->
また、`-C codegen-units=1` `-filter-print-funcs`も`-C codegen-units=1`も使用しない場合は、複数のコードジェネルユニットが並列に実行されるため、印刷物が混ざり合って何も読み取れません。

<!--If you want just the IR for a specific function (say, you want to see why it causes an assertion or doesn't optimize correctly), you can use `llvm-extract`, eg-->
IRを特定の関数（例えば、なぜアサーションを引き起こすか、正しく最適化しないかを見たいと思っている）にしたいのであれば、`llvm-extract`使うことができます。

```bash
$ ./build/$TRIPLE/llvm/bin/llvm-extract \
    -func='_ZN11collections3str21_$LT$impl$u20$str$GT$7replace17hbe10ea2e7c809b0bE' \
    -S \
    < unextracted.ll \
    > extracted.ll
```

### <!--Filing LLVM bug reports--> LLVMバグレポートの提出

<!--When filing an LLVM bug report, you will probably want some sort of minimal working example that demonstrates the problem.-->
LLVMのバグレポートを提出する際には、問題を示す最小限の作業例が必要になるでしょう。
<!--The Godbolt compiler explorer is really helpful for this.-->
Godboltコンパイラエクスプローラはこれに本当に役立ちます。

1. <!--Once you have some LLVM IR for the problematic code (see above), you can-->
    問題のあるコードのLLVM IRを取得したら（上記を参照）、次のことができます。
<!--create a minimal working example with Godbolt.-->
Godboltとの最小限の作業例を作成します。
<!--Go to [gcc.godbolt.org](https://gcc.godbolt.org).-->
[gcc.godbolt.org](https://gcc.godbolt.org)して[gcc.godbolt.org](https://gcc.godbolt.org)。

2. <!--Choose `LLVM-IR` as programming language.-->
    プログラミング言語として`LLVM-IR`を選択します。

3. <!--Use `llc` to compile the IR to a particular target as is:-->
    IRを特定のターゲットにコンパイルするには、次のように`llc`を使用します。
    - <!--There are some useful flags: `-mattr` enables target features, `-march=` selects the target, `-mcpu=` selects the CPU, etc.-->
       いくつかの有用なフラグがあります。`-mattr`はターゲット機能を有効にし、`-march=`はターゲットを選択し、`-mcpu=`はCPUを選択します。
    - <!--Commands like `llc -march=help` output all architectures available, which is useful because sometimes the Rust arch names and the LLVM names do not match.-->
       `llc -march=help`ようなコマンドは、使用可能なすべてのアーキテクチャー`llc -march=help`出力します。これは、Rustのアーチ名とLLVM名が一致しないことがあるため便利です。
    - <!--If you have compiled rustc yourself somewhere, in the target directory you have binaries for `llc`, `opt`, etc.-->
       あなたがどこかでrustcをコンパイルしていれば、ターゲットディレクトリに`llc`、 `opt`などのバイナリがあり`opt`。

4. <!--If you want to optimize the LLVM-IR, you can use `opt` to see how the LLVM optimizations transform it.-->
    LLVM-IRを最適化する場合は、`opt`を使用して、LLVM最適化がどのように変換するかを確認できます。

5. <!--Once you have a godbolt link demonstrating the issue, it is pretty easy to fill in an LLVM bug.-->
    問題を示すゴッドボルトのリンクがあれば、LLVMのバグを埋めるのは簡単です。


[env-logger]: https://docs.rs/env_logger/0.4.3/env_logger/
