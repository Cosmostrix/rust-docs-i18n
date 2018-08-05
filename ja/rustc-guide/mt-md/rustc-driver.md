# <!--The Rustc Driver--> Rustcドライバー

<!--The [`rustc_driver`] is essentially `rustc` 's `main()` function.-->
[`rustc_driver`]は本質的には`rustc`の`main()`関数です。
<!--It acts as the glue for running the various phases of the compiler in the correct order, managing state such as the [`CodeMap`] \(maps AST nodes to source code), [`Session`] \(general build context and error messaging) and the [`TyCtxt`] \(the "typing context", allowing you to query the type system and other cool stuff).-->
これは、[`CodeMap`] \（ASTノードをソースコードにマップする）、[`Session`] \（一般的なビルドコンテキストとエラーメッセージング）、および[`TyCtxt`] \（タイプの文脈、タイプシステムと他のクールなものを照会できるようにする"タイピングコンテキスト "）。
<!--The `rustc_driver` crate also provides external users with a method for running code at particular times during the compilation process, allowing third parties to effectively use `rustc` 's internals as a library for analysing a crate or emulating the compiler in-process (eg the RLS).-->
`rustc_driver`クレートは、コンパイルプロセス中に特定の時間にコードを実行する方法を外部ユーザーに提供し、サードパーティが`rustc`を解析するライブラリやインプロセスでコンパイラをエミュレートするためのライブラリとして`rustc`の内部を効果的に使用できるようにします（RLSなど）。

<!--For those using `rustc` as a library, the `run_compiler()` function is the main entrypoint to the compiler.-->
ライブラリとして`rustc`を使用している場合、`run_compiler()`関数はコンパイラのメインエントリポイントです。
<!--Its main parameters are a list of command-line arguments and a reference to something which implements the `CompilerCalls` trait.-->
その主なパラメータは、コマンドライン引数のリストと`CompilerCalls`特性を実装するものへの参照です。
<!--A `CompilerCalls` creates the overall `CompileController`, letting it govern which compiler passes are run and attach callbacks to be fired at the end of each phase.-->
`CompilerCalls`は全体的な`CompileController`作成し、どのコンパイラパスが実行されているかを管理し、各フェーズの最後にコールバックを起動するようにします。

<!--From `rustc_driver` 's perspective, the main phases of the compiler are:-->
`rustc_driver`の観点から見ると、コンパイラの主なフェーズは次のとおりです。

1. <!--*Parse Input:* Initial crate parsing-->
    *パース入力：*初期クレート解析
2. <!--*Configure and Expand:* Resolve `#[cfg]` attributes, name resolution, and expand macros-->
    *設定と展開：* `#[cfg]`属性、名前解決、およびマクロの展開を解決する
3. <!--*Run Analysis Passes:* Run trait resolution, typechecking, region checking and other miscellaneous analysis passes on the crate-->
    *解析パスを*実行する*：*クレートの特性*解析*、型チェック、領域検査、その他のその他の解析パスを実行する
4. <!--*Translate to LLVM:* Translate to the in-memory form of LLVM IR and turn it into an executable/object files-->
    *LLVMに翻訳する：* LLVM IRのインメモリ形式に変換し、それを実行可能ファイル/オブジェクトファイルに変換する

<!--The `CompileController` then gives users the ability to inspect the ongoing compilation process-->
`CompileController`は、ユーザーに進行中のコンパイルプロセスを検査する機能を提供します

- <!--after parsing-->
   解析後
- <!--after AST expansion-->
   AST拡張後
- <!--after HIR lowering-->
   HIR低下後
- <!--after analysis, and-->
   分析後、および
- <!--when compilation is done-->
   編集が終わったら

<!--The `CompileState` 's various `state_after_*()` constructors can be inspected to determine what bits of information are available to which callback.-->
`CompileState`のさまざまな`state_after_*()`コンストラクタを調べることで、どのコールビットにどの情報ビットが利用可能かを判断できます。

<!--For a more detailed explanation on using `rustc_driver`, check out the [stupid-stats] guide by `@nrc` (attached as [Appendix A]).-->
`rustc_driver`詳細については、`rustc_driver` [stupid-stats] guideを`@nrc`て[Appendix A]（ [Appendix A]参照）。

> <!--**Warning:** By its very nature, the internal compiler APIs are always going to be unstable.-->
> **警告：**本質的に、内部コンパイラAPIは常に不安定になります。
> <!--That said, we do try not to break things unnecessarily.-->
> しかし、私たちは不必要に物事を壊さないようにしています。

## <!--A Note On Lifetimes--> 生涯に関する注意

<!--The Rust compiler is a fairly large program containing lots of big data structures (eg the AST, HIR, and the type system) and as such, arenas and references are heavily relied upon to minimize unnecessary memory use.-->
Rustコンパイラは、大量のデータ構造（AST、HIR、型システムなど）を含むかなり大きなプログラムであり、不要なメモリの使用を最小限に抑えるために、アリーナや参照に大きく依存しています。
<!--This manifests itself in the way people can plug into the compiler, preferring a "push"-style API (callbacks) instead of the more Rust-ic "pull"style (think the `Iterator` trait).-->
これは、人々がコンパイラにプラグインできる方法で明らかになり、Rust-icの「プル」スタイル（`Iterator`特性を考える）の代わりに「プッシュ」スタイルのAPI（コールバック）を好みます。

<!--For example the [`CompileState`], the state passed to callbacks after each phase, is essentially just a box of optional references to pieces inside the compiler.-->
たとえば、各段階の後にコールバックに渡される状態である[`CompileState`]は、本質的に、コンパイラ内の部分へのオプション参照のボックスです。
<!--The lifetime bound on the `CompilerCalls` trait then helps to ensure compiler internals don't "escape"the compiler (eg if you tried to keep a reference to the AST after the compiler is finished), while still letting users record *some* state for use after the `run_compiler()` function finishes.-->
上に結合寿命`CompilerCalls`特色は、（あなたはコンパイラが終了した後にASTへの参照を保持しようとした場合など）の後に、まだせ、ユーザーが使用するために*、いくつかの*状態を記録しながら、コンパイラを「エスケープ」していないコンパイラの内部を確認するのに役立ちます`run_compiler()`関数が終了します。

<!--Thread-local storage and interning are used a lot through the compiler to reduce duplication while also preventing a lot of the ergonomic issues due to many pervasive lifetimes.-->
スレッドローカルストレージとインターンは、多くの普及している生涯に起因する人間工学的な問題の多くを防ぐと同時に、重複を減らすためにコンパイラを介して多く使用されます。
<!--The `rustc::ty::tls` module is used to access these thread-locals, although you should rarely need to touch it.-->
`rustc::ty::tls`モジュールは、これらのスレッドローカルにアクセスするために使用されますが、ほとんど触れる必要はありません。


<!--[`rustc_driver`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/
 [`CompileState`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/driver/struct.CompileState.html
 [`Session`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html
 [`TyCtxt`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/struct.TyCtxt.html
 [`CodeMap`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html
 [stupid-stats]: https://github.com/nrc/stupid-stats
 [Appendix A]: appendix/stupid-stats.html
-->
[`rustc_driver`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/
 [`CompileState`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/driver/struct.CompileState.html
 [`Session`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html
 [`TyCtxt`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/struct.TyCtxt.html
 [`CodeMap`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html
 [stupid-stats]: https://github.com/nrc/stupid-stats
 [Appendix A]: appendix/stupid-stats.html

