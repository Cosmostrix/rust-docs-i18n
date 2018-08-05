# <!--Appendix A: A tutorial on creating a drop-in replacement for rustc--> 付録A：rustcのドロップイン置換の作成に関するチュートリアル

> <!--**Note:** This is a copy of `@nrc` 's amazing [stupid-stats].-->
> **注：**これは`@nrc`の素晴らしい[stupid-stats]のコピーです。
> <!--You should find a copy of the code on the GitHub repository although due to the compiler's constantly evolving nature, there is no guarantee it'll compile on the first go.-->
> GitHubリポジトリにコードのコピーがあるはずですが、コンパイラが常に進化している性質のため、最初にコンパイルする保証はありません。

<!--Many tools benefit from being a drop-in replacement for a compiler.-->
多くのツールは、コンパイラの代わりに使用できます。
<!--By this, I mean that any user of the tool can use `mytool` in all the ways they would normally use `rustc` -whether manually compiling a single file or as part of a complex make project or Cargo build, etc. That could be a lot of work;-->
これにより、ツールのどのユーザーも、手動で単一のファイルをコンパイルするか、複雑なmakeプロジェクトやCargoビルドの一部として、通常`rustc`使用するすべての方法で`mytool`を使用できることを意味します。作業;
<!--rustc, like most compilers, takes a large number of command line arguments which can affect compilation in complex and interacting ways.-->
rustcは、ほとんどのコンパイラと同様に、複雑で相互作用的な方法でコンパイルに影響するコマンドライン引数を多数取ります。
<!--Emulating all of this behaviour in your tool is annoying at best, especically if you are making many of the same calls into librustc that the compiler is.-->
あなたのツールでこのような動作をすべてエミュレートするのは、せいぜい厄介なことです。特に、コンパイラと同じ呼び出しを多数作成している場合は特にそうです。

<!--The kind of things I have in mind are tools like rustdoc or a future rustfmt.-->
私が念頭に置いているのは、rustdocやfuture rustfmtのようなツールです。
<!--These want to operate as closely as possible to real compilation, but have totally different outputs (documentation and formatted source code, respectively).-->
これらは、実際のコンパイルとできるだけ近いところで動作したいが、全く異なる出力（それぞれドキュメントと書式化されたソースコード）を持っている。
<!--Another use case is a customised compiler.-->
もう1つのユースケースはカスタマイズされたコンパイラです。
<!--Say you want to add a custom code generation phase after macro expansion, then creating a new tool should be easier than forking the compiler (and keeping it up to date as the compiler evolves).-->
マクロ展開後にカスタムコード生成フェーズを追加したい場合、コンパイラをフォークするよりも簡単に新しいツールを作成する必要があります（コンパイラが進化するにつれて最新の状態に保つ）。

<!--I have gradually been trying to improve the API of librustc to make creating a drop-in tool easier to produce (many others have also helped improve these interfaces over the same time frame).-->
私は、ドロップインツールの作成を容易にするために、ライブラリのAPIを徐々に改善しようとしてきました（他の多くのツールも、同じ時間枠でこれらのインターフェイスを改善するのに役立っています）。
<!--It is now pretty simple to make a tool which is as close to rustc as you want it to be.-->
あなたが望むように錆びたものに近いツールを作るのはかなり簡単です。
<!--In this tutorial I'll show how.-->
このチュートリアルでは、どのように表示するかを説明します。

<!--Note/warning, everything I talk about in this tutorial is internal API for rustc.-->
注意/警告、私がこのチュートリアルで話すことはすべて、rustcの内部APIです。
<!--It is all extremely unstable and likely to change often and in unpredictable ways.-->
それはすべて非常に不安定で、頻繁に、そして予測不能な方法で変更される可能性があります。
<!--Maintaining a tool which uses these APIs will be non-trivial, although hopefully easier than maintaining one that does similar things without using them.-->
これらのAPIを使用するツールを維持することは、些細なことではありませんが、似たようなことを使わずに行うものを維持するよりも簡単です。

<!--This tutorial starts with a very high level view of the rustc compilation process and of some of the code that drives compilation.-->
このチュートリアルは、rustcのコンパイルプロセスとコンパイルを駆動するコードの非常に高いレベルのビューから始まります。
<!--Then I'll describe how that process can be customised.-->
次に、そのプロセスをカスタマイズする方法について説明します。
<!--In the final section of the tutorial, I'll go through an example -stupid-stats -which shows how to build a drop-in tool.-->
チュートリアルの最後のセクションでは、ドロップインツールを作成する方法を示す例（stupid-stats）を紹介します。


## <!--Overview of the compilation process--> コンパイルプロセスの概要

<!--Compilation using rustc happens in several phases.-->
rustcを使ったコンパイルはいくつかの段階で起こります。
<!--We start with parsing, this includes lexing.-->
まず構文解析から始めます。これにはレキシングが含まれます。
<!--The output of this phase is an AST (abstract syntax tree).-->
このフェーズの出力は、AST（抽象構文ツリー）です。
<!--There is a single AST for each crate (indeed, the entire compilation process operates over a single crate).-->
各クレートには1つのASTがあります（実際には、コンパイルプロセス全体が1つのクレートで動作します）。
<!--Parsing abstracts away details about individual files which will all have been read in to the AST in this phase.-->
パーシングは、このフェーズでASTにすべて読み込まれた個々のファイルの詳細を抽象化します。
<!--At this stage the AST includes all macro uses, attributes will still be present, and nothing will have been eliminated due to `cfg` s.-->
この段階では、ASTにはすべてのマクロの使用が含まれ、属性は引き続き存在し、`cfg`によって何も削除されません。

<!--The next phase is configuration and macro expansion.-->
次のフェーズは構成とマクロ展開です。
<!--This can be thought of as a function over the AST.-->
これは、AST上の関数と考えることができます。
<!--The unexpanded AST goes in and an expanded AST comes out.-->
拡張されていないASTが入り、拡張ASTが出ます。
<!--Macros and syntax extensions are expanded, and `cfg` attributes will cause some code to disappear.-->
マクロとシンタックス拡張が拡張され、`cfg`属性によっていくつかのコードが消えます。
<!--The resulting AST won't have any macros or macro uses left in.-->
結果のASTには、マクロまたはマクロの使用は残されません。

<!--The code for these first two phases is in [libsyntax](https://github.com/rust-lang/rust/tree/master/src/libsyntax).-->
これらの最初の2つの段階のコードは[libsyntax](https://github.com/rust-lang/rust/tree/master/src/libsyntax)ます。

<!--After this phase, the compiler allocates ids to each node in the AST (technically not every node, but most of them).-->
このフェーズの後、コンパイラはASTの各ノードにIDを割り当てます（技術的にすべてのノードではなく、ほとんどのノード）。
<!--If we are writing out dependencies, that happens now.-->
依存関係を書き出している場合は、それが今起こります。

<!--The next big phase is analysis.-->
次の大きな段階は分析です。
<!--This is the most complex phase and uses the bulk of the code in rustc.-->
これは最も複雑な段階で、rustcのコードの大半を使用します。
<!--This includes name resolution, type checking, borrow checking, type and lifetime inference, trait selection, method selection, linting, and so forth.-->
これには、名前解決、型チェック、借用チェック、型と存続時間推論、特性選択、メソッド選択、リンピングなどが含まれます。
<!--Most error detection is done in this phase (although parse errors are found during parsing).-->
ほとんどのエラー検出はこのフェーズで実行されます（解析エラーは解析中に検出されます）。
<!--The 'output' of this phase is a bunch of side tables containing semantic information about the source program.-->
このフェーズの「出力」は、ソースプログラムに関する意味情報を含む一連のサイドテーブルです。
<!--The analysis code is in [librustc](https://github.com/rust-lang/rust/tree/master/src/librustc) and a bunch of other crates with the 'librustc_' prefix.-->
分析コードは[librustc](https://github.com/rust-lang/rust/tree/master/src/librustc)あり、librustc_という接頭辞を持つ他のクレートの束です。

<!--Next is translation, this translates the AST (and all those side tables) into LLVM IR (intermediate representation).-->
次は翻訳で、これはAST（およびそれらのすべてのサイドテーブル）をLLVM IR（中間表現）に変換します。
<!--We do this by calling into the LLVM libraries, rather than actually writing IR directly to a file.-->
実際に直接IRをファイルに書くのではなく、LLVMライブラリを呼び出すことでこれを行います。
<!--The code for this is in [librustc_trans](https://github.com/rust-lang/rust/tree/master/src/librustc_trans).-->
このコードは[librustc_trans](https://github.com/rust-lang/rust/tree/master/src/librustc_trans)ます。

<!--The next phase is running the LLVM backend.-->
次の段階では、LLVMバックエンドを実行しています。
<!--This runs LLVM's optimisation passes on the generated IR and then generates machine code.-->
これにより、生成されたIRに対してLLVMの最適化パスが実行され、マシンコードが生成されます。
<!--The result is object files.-->
結果はオブジェクトファイルです。
<!--This phase is all done by LLVM, it is not really part of the rust compiler.-->
このフェーズはすべてLLVMによって実行されますが、それは本当にrustコンパイラの一部ではありません。
<!--The interface between LLVM and rustc is in [librustc_llvm](https://github.com/rust-lang/rust/tree/master/src/librustc_llvm).-->
LLVMとrustcの間のインタフェースは[librustc_llvm](https://github.com/rust-lang/rust/tree/master/src/librustc_llvm)ます。

<!--Finally, we link the object files into an executable.-->
最後に、オブジェクトファイルを実行可能ファイルにリンクします。
<!--Again we outsource this to other programs and it's not really part of the rust compiler.-->
ここでも、これを他のプログラムに委託しています。それは実際には錆びたコンパイラの一部ではありません。
<!--The interface is in [librustc_back](https://github.com/rust-lang/rust/tree/master/src/librustc_back) (which also contains some things used primarily during translation).-->
インタフェースは[librustc_back](https://github.com/rust-lang/rust/tree/master/src/librustc_back)（主に翻訳時に使用されるものも含まれています）にあります。

<!--All these phases are coordinated by the driver.-->
これらのフェーズはすべてドライバによって調整されます。
<!--To see the exact sequence, look at [the `compile_input` function in `librustc_driver`][compile-input].-->
正確な配列を確認するには、見[`compile_inputの`中の関数`compile_input` `librustc_driver`][compile-input]。
<!--The driver handles all the highest level coordination of compilation -1. handling command-line arguments 2. maintaining compilation state (primarily in the `Session`) 3. calling the appropriate code to run each phase of compilation 4. handles high level coordination of pretty printing and testing.-->
ドライバは、コンパイルの最高レベルの調整をすべて処理します。1.コマンドライン引数の処理2.コンパイル状態の維持（主に`Session`）3.コンパイルの各段階を実行するための適切なコードの呼び出し4.きれいな印刷テスト。
<!--To create a drop-in compiler replacement or a compiler replacement, we leave most of compilation alone and customise the driver using its APIs.-->
ドロップインコンパイラの置き換えやコンパイラの置き換えを作成するには、ほとんどのコンパイルをそのままにして、そのAPIを使用してドライバをカスタマイズします。

[compile-input]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/driver/fn.compile_input.html


## <!--The driver customisation APIs--> ドライバのカスタマイズAPI

<!--There are two primary ways to customise compilation -high level control of the driver using `CompilerCalls` and controlling each phase of compilation using a `CompileController`.-->
コンパイルをカスタマイズするには、`CompilerCalls`を使用してドライバを高水準で制御し、`CompileController`を使用してコンパイルの各フェーズを制御する2つの主な方法があります。
<!--The former lets you customise handling of command line arguments etc., the latter lets you stop compilation early or execute code between phases.-->
前者では、コマンドライン引数などの処理をカスタマイズできます。後者では、コンパイルを早期に中止したり、フェーズ間でコードを実行したりできます。


### `CompilerCalls`
<!--`CompilerCalls` is a trait that you implement in your tool.-->
`CompilerCalls`は、あなたのツールに実装する特性です。
<!--It contains a fairly ad-hoc set of methods to hook in to the process of processing command line arguments and driving the compiler.-->
コマンドライン引数を処理してコンパイラを起動するプロセスにフックする方法のかなりアドホックなセットが含まれています。
<!--For details, see the comments in [librustc_driver/lib.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/index.html).-->
詳細は、[librustc_driver/lib.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/index.html)コメントを参照してください。
<!--I'll summarise the methods here.-->
ここではその方法を要約します。

<!--`early_callback` and `late_callback` let you call arbitrary code at different points -early is after command line arguments have been parsed, but before anything is done with them;-->
`early_callback`と`late_callback`は、異なるポイントで任意のコードを呼び出すことができます。早い段階でコマンドライン引数が解析された後で、何か処理が完了する前に実行されます。
<!--late is pretty much the last thing before compilation starts, ie, after all processing of command line arguments, etc. is done.-->
後半は、コンパイルが始まる前の最後のことです。つまり、コマンドライン引数などの処理がすべて完了した後です。
<!--Currently, you get to choose whether compilation stops or continues at each point, but you don't get to change anything the driver has done.-->
現在のところ、コンパイルが停止するか、各ポイントで続行するかを選択できますが、ドライバが行ったことは何も変更する必要はありません。
<!--You can record some info for later, or perform other actions of your own.-->
あとで情報を記録したり、自分の他のアクションを実行することができます。

<!--`some_input` and `no_input` give you an opportunity to modify the primary input to the compiler (usually the input is a file containing the top module for a crate, but it could also be a string).-->
`some_input`と`no_input`は、コンパイラへのプライマリ入力を変更する機会を与えます（通常、入力はクレートのトップモジュールを含むファイルですが、文字列でも可能です）。
<!--You could record the input or perform other actions of your own.-->
あなたは入力を記録したり、あなた自身の他のアクションを実行することができます。

<!--Ignore `parse_pretty`, it is unfortunate and hopefully will get improved.-->
`parse_pretty`無視すると、残念ですが、うまくいけば改善されます。
<!--There is a default implementation, so you can pretend it doesn't exist.-->
デフォルトの実装があるため、存在しないふりをすることができます。

<!--`build_controller` returns a `CompileController` object for more fine-grained control of compilation, it is described next.-->
`build_controller`は、`CompileController`より細かい制御のために`CompileController`オブジェクトを返します。次に説明します。

<!--We might add more options in the future.-->
将来、より多くのオプションを追加する可能性があります。


### `CompilerController`
<!--`CompilerController` is a struct consisting of `PhaseController` s and flags.-->
`CompilerController`は`PhaseController`とフラグで構成される構造体です。
<!--Currently, there is only flag, `make_glob_map` which signals whether to produce a map of glob imports (used by save-analysis and potentially other tools).-->
現在はglobインポートのマップを生成するかどうかを示すフラグ`make_glob_map`しかありません（save-analysisや他のツールで使用される）。
<!--There are probably flags in the session that should be moved here.-->
おそらく、ここに移動する必要のあるフラグがセッション内にあります。

<!--There is a `PhaseController` for each of the phases described in the above summary of compilation (and we could add more in the future for finer-grained control).-->
上のコンパイルの要約で説明したフェーズごとに`PhaseController`があります（さらに細かい制御のために将来追加することもできます）。
<!--They are all `after_` a phase because they are checked at the end of a phase (again, that might change), eg, `CompilerController::after_parse` controls what happens immediately after parsing (and before macro expansion).-->
彼らはすべてある`after_`それらは（変更される可能性があること、再び）フェーズの終了時にチェックされているため、例えば、相`CompilerController::after_parse`解析した直後に何が起こるかをコントロール（およびマクロ展開の前に）。

<!--Each `PhaseController` contains a flag called `stop` which indicates whether compilation should stop or continue, and a callback to be executed at the point indicated by the phase.-->
各`PhaseController`は、コンパイルを停止するか継続するかを示す`stop`というフラグと、フェーズが示すポイントで実行されるコールバックが含まれています。
<!--The callback is called whether or not compilation continues.-->
コールバックは、コンパイルが続行されるかどうかによって呼び出されます。

<!--Information about the state of compilation is passed to these callbacks in a `CompileState` object.-->
コンパイルの状態に関する情報は、`CompileState`オブジェクトのこれらのコールバックに渡されます。
<!--This contains all the information the compiler has.-->
これには、コンパイラーが持つすべての情報が含まれています。
<!--Note that this state information is immutable -your callback can only execute code using the compiler state, it can't modify the state.-->
この状態情報は不変であることに注意してください。コールバックはコンパイラ状態を使用してコードを実行するだけで、状態を変更することはできません。
<!--(If there is demand, we could change that).-->
（もし需要があれば、それを変えることができる）。
<!--The state available to a callback depends on where during compilation the callback is called.-->
コールバックで使用可能な状態は、コンパイル時にコールバックが呼び出される場所によって異なります。
<!--For example, after parsing there is an AST but no semantic analysis (because the AST has not been analysed yet).-->
たとえば、構文解析後にはASTは存在しますが、意味解析は行われません（ASTはまだ解析されていないため）。
<!--After translation, there is translation info, but no AST or analysis info (since these have been consumed/forgotten).-->
翻訳後、翻訳情報がありますが、ASTや分析情報はありません（これらは消費/忘れられているため）。


## <!--An example -stupid-stats--> 例 -stupid-stats

<!--Our example tool is very simple, it simply collects some simple and not very useful statistics about a program;-->
私たちのサンプルツールは非常にシンプルで、プログラムに関する簡単で有用ではない統計を収集するだけです。
<!--it is called stupid-stats.-->
それは愚かな統計と呼ばれています。
<!--You can find the (more heavily commented) complete source for the example on [Github](https://github.com/nick29581/stupid-stats/blob/master/src).-->
あなたは[Github](https://github.com/nick29581/stupid-stats/blob/master/src)の例の完全なソース（より多くコメントされている）を見つけることができます。
<!--To build, just do `cargo build`.-->
ビルドするには、`cargo build`行うだけです。
<!--To run on a file `foo.rs`, do `cargo run foo.rs` (assuming you have a Rust program called `foo.rs`. You can also pass any command line arguments that you would normally pass to rustc).-->
ファイル上で実行するには`foo.rs`、やる`cargo run foo.rs`（あなたが呼ばれる錆プログラム持っていると仮定し`foo.rs`。また、あなたが正常にrustcに渡す任意のコマンドライン引数を渡すことができます）。
<!--When you run it you'll see output similar to-->
それを実行すると、次のような出力が表示されます

```text
In crate: foo,

Found 12 uses of `println!`;
The most common number of arguments is 1 (67% of all functions);
25% of functions have four or more arguments.
```

<!--To make things easier, when we talk about functions, we're excluding methods and closures.-->
物事を簡単にするために、関数について話すとき、メソッドとクロージャを除外します。

<!--You can also use the executable as a drop-in replacement for rustc, because after all, that is the whole point of this exercise.-->
結局、実行可能ファイルをrustcのドロップイン置換として使用することもできます。なぜなら、これはこのエクササイズの要点ですからです。
<!--So, however you use rustc in your makefile setup, you can use `target/stupid` (or whatever executable you end up with) instead.-->
ですから、あなたはmakefileの設定でrustcを使いますが、`target/stupid`（またはあなたが最後に実行した実行可能ファイル）を代わりに使うことができます。
<!--That might mean setting an environment variable or it might mean renaming your executable to `rustc` and setting your PATH.-->
それは環境変数を設定することを意味するかもしれませんし、実行可能ファイルの名前を`rustc`変更してPATHを設定することを意味するかもしれません。
<!--Similarly, if you're using Cargo, you'll need to rename the executable to rustc and set the PATH.-->
同様に、Cargoを使用している場合は、実行可能ファイルの名前をrustcに変更し、PATHを設定する必要があります。
<!--Alternatively, you should be able to use [multirust](https://github.com/brson/multirust) to get around all the PATH stuff (although I haven't actually tried that).-->
あるいは、[multirust](https://github.com/brson/multirust)を使用してPATHのすべての[multirust](https://github.com/brson/multirust)を行うことができます（実際には試していませんが）。

<!--(Note that this example prints to stdout. I'm not entirely sure what Cargo does with stdout from rustc under different circumstances. If you don't see any output, try inserting a `panic!` after the `println!` s to error out, then Cargo should dump stupid-stats' stdout to Cargo's stdout).-->
（この例ではstdoutに出力していますが、Cargoがさまざまな状況下でstdoutを使ってstdoutを実行しているかどうかは完全にはわかりませんが出力が表示されない場合は`println!`後に`panic!`挿入してください貨物は、愚かな統計の貨物の標準にダンプする必要があります）。

<!--Let's start with the `main` function for our tool, it is pretty simple:-->
私たちのツールの`main`機能から始めてみましょう。これはとても簡単です：

```rust,ignore
fn main() {
    let args: Vec<_> = std::env::args().collect();
    rustc_driver::run_compiler(&args, &mut StupidCalls::new());
    std::env::set_exit_status(0);
}
```

<!--The first line grabs any command line arguments.-->
最初の行はコマンドライン引数を取得します。
<!--The second line calls the compiler driver with those arguments.-->
2行目は、これらの引数を使用してコンパイラドライバを呼び出します。
<!--The final line sets the exit code for the program.-->
最後の行は、プログラムの終了コードを設定します。

<!--The only interesting thing is the `StupidCalls` object we pass to the driver.-->
興味深いのは、私たちがドライバに渡す`StupidCalls`オブジェクトだけです。
<!--This is our implementation of the `CompilerCalls` trait and is what will make this tool different from rustc.-->
これは`CompilerCalls`特性を実装したもので、このツールをrustcとは異なるものにするものです。

<!--`StupidCalls` is a mostly empty struct:-->
`StupidCalls`はほとんど空の構造体です：

```rust,ignore
struct StupidCalls {
    default_calls: RustcDefaultCalls,
}
```

<!--This tool is so simple that it doesn't need to store any data here, but usually you would.-->
このツールはシンプルなので、ここにデータを格納する必要はありませんが、通常はそうです。
<!--We embed a `RustcDefaultCalls` object to delegate to in our impl when we want exactly the same behaviour as the Rust compiler.-->
私たちは、Rustコンパイラとまったく同じ振る舞いが必要なときに、私たちのimplに委譲する`RustcDefaultCalls`オブジェクトを埋め込みます。
<!--Mostly you don't want to do that (or at least don't need to) in a tool.-->
ほとんどの場合、ツールでそれをしたくない（または少なくとも行う必要はありません）。
<!--However, Cargo calls rustc with the `--print file-names`, so we delegate in `late_callback` and `no_input` to keep Cargo happy.-->
しかし、Cargoは--print `--print file-names`で`late_callback`を`no_input`ので、`late_callback`と`no_input`して、Cargoを幸せに保ちます。

<!--Most of the rest of the impl of `CompilerCalls` is trivial:-->
`CompilerCalls`その他のインプリメントのほとんどは自明です。

```rust,ignore
impl<'a> CompilerCalls<'a> for StupidCalls {
    fn early_callback(&mut self,
                        _: &getopts::Matches,
                        _: &config::Options,
                        _: &diagnostics::registry::Registry,
                        _: ErrorOutputType)
                      -> Compilation {
        Compilation::Continue
    }

    fn late_callback(&mut self,
                     t: &TransCrate,
                     m: &getopts::Matches,
                     s: &Session,
                     c: &CrateStore,
                     i: &Input,
                     odir: &Option<PathBuf>,
                     ofile: &Option<PathBuf>)
                     -> Compilation {
        self.default_calls.late_callback(t, m, s, c, i, odir, ofile);
        Compilation::Continue
    }

    fn some_input(&mut self,
                  input: Input,
                  input_path: Option<Path>)
                  -> (Input, Option<Path>) {
        (input, input_path)
    }

    fn no_input(&mut self,
                m: &getopts::Matches,
                o: &config::Options,
                odir: &Option<Path>,
                ofile: &Option<Path>,
                r: &diagnostics::registry::Registry)
                -> Option<(Input, Option<Path>)> {
        self.default_calls.no_input(m, o, odir, ofile, r);

#        // This is not optimal error handling.
        // これは最適なエラー処理ではありません。
        panic!("No input supplied to stupid-stats");
    }

    fn build_controller(&mut self, _: &Session) -> driver::CompileController<'a> {
        ...
    }
}
```

<!--We don't do anything for either of the callbacks, nor do we change the input if the user supplies it.-->
いずれかのコールバックに対しては何もしませんし、ユーザーが入力した場合は入力を変更しません。
<!--If they don't, we just `panic!`, this is the simplest way to handle the error, but not very user-friendly, a real tool would give a constructive message or perform a default action.-->
そうでない場合は、我々だけで`panic!`、これは非常にユーザーフレンドリーエラーを処理するための最も簡単な方法ですが、ではない、本当のツールは、建設的なメッセージを与えるか、またはデフォルトのアクションを実行します。

<!--In `build_controller` we construct our `CompileController`.-->
で`build_controller`我々は我々の構築`CompileController`。
<!--We only want to parse, and we want to inspect macros before expansion, so we make compilation stop after the first phase (parsing).-->
私たちは解析したいだけで、展開前にマクロを検査したいので、最初の段階（解析）後にコンパイルを停止します。
<!--The callback after that phase is where the tool does it's actual work by walking the AST.-->
その段階の後のコールバックは、ツールがASTを歩いて実際の作業を行う場所です。
<!--We do that by creating an AST visitor and making it walk the AST from the top (the crate root).-->
私たちはAST訪問者を作成し、ASTを上から（クレートルート）歩くようにします。
<!--Once we've walked the crate, we print the stats we've collected:-->
クレートを歩いたら、収集した統計を印刷します：

```rust,ignore
fn build_controller(&mut self, _: &Session) -> driver::CompileController<'a> {
#    // We mostly want to do what rustc does, which is what basic() will return.
    // 私たちは、ほとんどの場合、rustcがやることをしたいと思います。これはbasic（）が返すものです。
    let mut control = driver::CompileController::basic();
#    // But we only need the AST, so we can stop compilation after parsing.
    // しかし、ASTだけが必要なので、解析後にコンパイルを停止することができます。
    control.after_parse.stop = Compilation::Stop;

#    // And when we stop after parsing we'll call this closure.
#    // Note that this will give us an AST before macro expansions, which is
#    // not usually what you want.
    // そして解析後に停止するときに、このクロージャーを呼び出します。これはマクロ拡張の前にASTを与えてくれることに注意してください。通常はあなたが望むものではありません。
    control.after_parse.callback = box |state| {
#        // Which extracts information about the compiled crate...
        // コンパイル済みのクレートに関する情報を抽出します...
        let krate = state.krate.unwrap();

#        // ...and walks the AST, collecting stats.
        // ... ASTを歩き、統計を収集します。
        let mut visitor = StupidVisitor::new();
        visit::walk_crate(&mut visitor, krate);

#        // And finally prints out the stupid stats that we collected.
        // 最後に私たちが収集したばかげた統計を表示します。
        let cratename = match attr::find_crate_name(&krate.attrs[]) {
            Some(name) => name.to_string(),
            None => String::from_str("unknown_crate"),
        };
        println!("In crate: {},\n", cratename);
        println!("Found {} uses of `println!`;", visitor.println_count);

        let (common, common_percent, four_percent) = visitor.compute_arg_stats();
        println!("The most common number of arguments is {} ({:.0}% of all functions);",
                 common, common_percent);
        println!("{:.0}% of functions have four or more arguments.", four_percent);
    };

    control
}
```

<!--That is all it takes to create your own drop-in compiler replacement or custom compiler!-->
それはあなた自身のドロップインコンパイラ置換またはカスタムコンパイラを作成するために必要なすべてです！
<!--For the sake of completeness I'll go over the rest of the stupid-stats tool.-->
完全性のために、私は愚かな統計ツールの残りの部分について説明します。

```rust
struct StupidVisitor {
    println_count: usize,
    arg_counts: Vec<usize>,
}
```

<!--The `StupidVisitor` struct just keeps track of the number of `println!` s it has seen and the count for each number of arguments.-->
`StupidVisitor`構造体は、見た`println!`数と引数の数ごとの数を追跡します。
<!--It implements `syntax::visit::Visitor` to walk the AST.-->
ASTを歩くために`syntax::visit::Visitor`を実装してい`syntax::visit::Visitor`。
<!--Mostly we just use the default methods, these walk the AST taking no action.-->
ほとんどの場合、デフォルトのメソッドを使用しています。これらは、アクションを取らずにASTを実行します。
<!--We override `visit_item` and `visit_mac` to implement custom behaviour when we walk into items (items include functions, modules, traits, structs, and so forth, we're only interested in functions) and macros:-->
私たちがアイテム（関数、モジュール、特性、構造体などを含む項目、関数にのみ関心がある項目）とマクロに`visit_mac`したときのカスタム動作を実装するために`visit_item`と`visit_mac`をオーバーライドします。

```rust,ignore
impl<'v> visit::Visitor<'v> for StupidVisitor {
    fn visit_item(&mut self, i: &'v ast::Item) {
        match i.node {
            ast::Item_::ItemFn(ref decl, _, _, _, _) => {
#                // Record the number of args.
                //  argsの数を記録します。
                self.increment_args(decl.inputs.len());
            }
            _ => {}
        }

#        // Keep walking.
        // 歩き続ける。
        visit::walk_item(self, i)
    }

    fn visit_mac(&mut self, mac: &'v ast::Mac) {
#        // Find its name and check if it is "println".
        // その名前を見つけ、それが "println"であるかどうかを確認します。
        let ast::Mac_::MacInvocTT(ref path, _, _) = mac.node;
        if path_to_string(path) == "println" {
            self.println_count += 1;
        }

#        // Keep walking.
        // 歩き続ける。
        visit::walk_mac(self, mac)
    }
}
```

<!--The `increment_args` method increments the correct count in `StupidVisitor::arg_counts`.-->
`increment_args`メソッドは、`StupidVisitor::arg_counts`正しいカウントをインクリメントします。
<!--After we're done walking, `compute_arg_stats` does some pretty basic maths to come up with the stats we want about arguments.-->
歩き終わった後、`compute_arg_stats`は、引数に関して必要な統計を思い付くためのかなり基本的な数学を行います。


## <!--What next?--> 次は何？

<!--These APIs are pretty new and have a long way to go until they're really good.-->
これらのAPIはかなり新しく、本当に良い状態になるまではまだまだ進んでいます。
<!--If there are improvements you'd like to see or things you'd like to be able to do, let me know in a comment or [GitHub issue](https://github.com/rust-lang/rust/issues).-->
あなたが見たい改善がある場合、あるいはできるようにしたいことがある場合は、コメントや[GitHubの問題](https://github.com/rust-lang/rust/issues)で教えてください。
<!--In particular, it's not clear to me exactly what extra flexibility is required.-->
特に、余分な柔軟性が必要であることは私にはっきりしていません。
<!--If you have an existing tool that would be suited to this setup, please try it out and let me know if you have problems.-->
この設定に適した既存のツールがある場合は、それを試して問題がある場合にお知らせください。

<!--It'd be great to see Rustdoc converted to using these APIs, if that is possible (although long term, I'd prefer to see Rustdoc run on the output from save-analysis, rather than doing its own analysis).-->
可能であれば、RustdocがこれらのAPIを使用するように変換されていることを確認することは素晴らしいことです（長期間は、独自の分析を行うのではなく、保存分析からRustdocが実行されることを望みます）。
<!--Other parts of the compiler (eg, pretty printing, testing) could be refactored to use these APIs internally (I already changed save-analysis to use `CompilerController`).-->
コンパイラの他の部分（例えば、かなりの印刷、テスト）は、内部的にこれらのAPIを使用するようにリファクタリングすることができます（私は既に`CompilerController`を使用するように保存分析を変更しました）。
<!--I've been experimenting with a prototype rustfmt which also uses these APIs.-->
私は、これらのAPIも使用するprototype rustfmtを試してきました。

[stupid-stats]: https://github.com/nrc/stupid-stats
