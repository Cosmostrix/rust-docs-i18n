# <!--Emitting Diagnostics--> エミッション診断

<!--A lot of effort has been put into making `rustc` have great error messages.-->
`rustc`に大きなエラーメッセージが`rustc`ように多くの努力が払われています。
<!--This chapter is about how to emit compile errors and lints from the compiler.-->
この章では、コンパイラからコンパイルエラーとリントを発行する方法について説明します。

## `Span`
<!--[`Span`][span] is the primary data structure in `rustc` used to represent a location in the code being compiled.-->
[`Span`][span]は、コンパイル中のコード内の場所を表すために使用される`rustc`主要なデータ構造です。
<!--`Span` s are attached to most constructs in HIR and MIR, allowing for more informative error reporting.-->
`Span`は、HIRとMIRのほとんどのコンストラクトに添付されており、より有益なエラー報告が可能です。

[span]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.Span.html

<!--A `Span` can be looked up in a [`CodeMap`][codemap] to get a "snippet"useful for displaying errors with [`span_to_snippet`][sptosnip] and other similar methods on the `CodeMap`.-->
`Span`で調べることができ[`CodeMap`][codemap]でエラーを表示するために有用な「スニペット」を取得し[`span_to_snippet`][sptosnip]上や他の同様の方法`CodeMap`。

<!--[codemap]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html
 [sptosnip]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html#method.span_to_snippet
-->
[codemap]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html
 [sptosnip]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html#method.span_to_snippet


## <!--Error messages--> エラーメッセージ

<!--The [`rustc_errors`][errors] crate defines most of the utilities used for reporting errors.-->
[`rustc_errors`][errors]枠は、エラーを報告するために使用されるほとんどのユーティリティを定義します。

[errors]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/index.html

<!--[`Session`][session] and [`ParseSess`][parsesses] have methods (or fields with methods) that allow reporting errors.-->
[`Session`][session]と[`ParseSess`][parsesses]は、エラーの報告を可能にするメソッド（またはメソッドを持つフィールド）があります。
<!--These methods usually have names like `span_err` or `struct_span_err` or `span_warn`, etc... There are lots of them;-->
これらのメソッドは、通常、`struct_span_err`や`span_warn`、 `span_err`などの名前を持っています。
<!--they emit different types of "errors", such as warnings, errors, fatal errors, suggestions, etc.-->
警告、エラー、致命的なエラー、提案などさまざまな種類の「エラー」を出します。

<!--[parsesses]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/struct.ParseSess.html
 [session]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html
-->
[session]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html
 [parsesses]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/struct.ParseSess.html


<!--In general, there are two class of such methods: ones that emit an error directly and ones that allow finer control over what to emit.-->
一般に、このような方法には2つのクラスがあります。エラーを直接発生させる方法と、放出する内容をより細かく制御できる方法です。
<!--For example, [`span_err`][spanerr] emits the given error message at the given `Span`, but [`struct_span_err`][strspanerr] instead returns a [`DiagnosticBuilder`][diagbuild].-->
例えば、[`span_err`][spanerr]所与で指定されたエラーメッセージを発する`Span`が、[`struct_span_err`][strspanerr]代わりに返し[`DiagnosticBuilder`][diagbuild]。

<!--`DiagnosticBuilder` allows you to add related notes and suggestions to an error before emitting it by calling the [`emit`][emit] method.-->
`DiagnosticBuilder`使用すると、[`emit`][emit]メソッドを呼び出して関連するメモと提案をエラーに追加することができます。
<!--(Failing to either emit or [cancel][cancel] a `DiagnosticBuilder` will result in an ICE.) See the [docs][diagbuild] for more info on what you can do.-->
（`DiagnosticBuilder`発行または[cancel][cancel]失敗すると、ICEが発生します）。できることの詳細については、[docs][diagbuild]を参照してください。

<!--[spanerr]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html#method.span_err
 [strspanerr]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html#method.struct_span_err
 [diagbuild]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/diagnostic_builder/struct.DiagnosticBuilder.html
 [emit]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/diagnostic_builder/struct.DiagnosticBuilder.html#method.emit
 [cancel]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/struct.Diagnostic.html#method.cancel
-->
[spanerr]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html#method.span_err
 [strspanerr]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html#method.struct_span_err
 [diagbuild]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/diagnostic_builder/struct.DiagnosticBuilder.html
 [emit]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/diagnostic_builder/struct.DiagnosticBuilder.html#method.emit
 [cancel]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/struct.Diagnostic.html#method.cancel


```rust,ignore
#// Get a DiagnosticBuilder. This does _not_ emit an error yet.
//  DiagnosticBuilderを取得します。これはまだエラーを _出さ_ ない。
let mut err = sess.struct_span_err(sp, "oh no! this is an error!");

#// In some cases, you might need to check if `sp` is generated by a macro to
#// avoid printing weird errors about macro-generated code.
// 場合によっては、マクロ生成コードに関する奇妙なエラーを避けるために、マクロによって`sp`が生成されているかどうかを確認する必要があります。

if let Ok(snippet) = sess.codemap().span_to_snippet(sp) {
#    // Use the snippet to generate a suggested fix
    // スニペットを使用して推奨される修正を生成する
    err.span_suggestion(suggestion_sp, "try using a qux here", format!("qux {}", snip));
} else {
#    // If we weren't able to generate a snippet, then emit a "help" message
#    // instead of a concrete "suggestion". In practice this is unlikely to be
#    // reached.
    // スニペットを生成できなかった場合は、具体的な「提案」の代わりに「ヘルプ」メッセージを表示します。実際にはこれは達成されないでしょう。
    err.span_help(suggestion_sp, "you could use a qux here instead");
}

#// emit the error
// エラーを出す
err.emit();
```

## <!--Suggestions--> 提案

<!--In addition to telling the user exactly  _why_  their code is wrong, it's oftentimes furthermore possible to tell them how to fix it.-->
ユーザにコードが間違っている _理由を_ 正確に伝えることに加えて、それを修正する方法を彼らに伝えることはしばしば可能です。
<!--To this end, `DiagnosticBuilder` offers a structured suggestions API, which formats code suggestions pleasingly in the terminal, or (when the `--error-format json` flag is passed) as JSON for consumption by tools, most notably the [Rust Language Server][rls] and [`rustfix`][rustfix].-->
この目的のために、`DiagnosticBuilder`は、端末で気に入ったコード提案や、--`--error-format json`フラグが渡されたときにJSONとしてツール（特に[Rust Language Server][rls]と[`rustfix`][rustfix]）で使用するための構造化された提案APIを提供しています。

<!--[rls]: https://github.com/rust-lang-nursery/rls
 [rustfix]: https://github.com/rust-lang-nursery/rustfix
-->
[rls]: https://github.com/rust-lang-nursery/rls
 [rustfix]: https://github.com/rust-lang-nursery/rustfix


<!--Not all suggestions should be applied mechanically.-->
すべての提案を機械的に適用する必要はありません。
<!--Use the [`span_suggestion_with_applicability`][sswa] method of `DiagnosticBuilder` to make a suggestion while providing a hint to tools whether the suggestion is mechanically applicable or not.-->
`DiagnosticBuilder`の[`span_suggestion_with_applicability`][sswa]メソッドを使用して、提案が機械的に適用可能かどうかのヒントを提供しながら、提案を行います。

[sswa]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/struct.DiagnosticBuilder.html#method.span_suggestion_with_applicability

<!--For example, to make our `qux` suggestion machine-applicable, we would do:-->
たとえば、`qux`提案を適用するには、次のようにします。

```rust,ignore
let mut err = sess.struct_span_err(sp, "oh no! this is an error!");

if let Ok(snippet) = sess.codemap().span_to_snippet(sp) {
#    // Add applicability info!
    // 適用性情報を追加してください！
    err.span_suggestion_with_applicability(
        suggestion_sp,
        "try using a qux here",
        format!("qux {}", snip),
        Applicability::MachineApplicable,
    );
} else {
    err.span_help(suggestion_sp, "you could use a qux here instead");
}

err.emit();
```

<!--This might emit an error like-->
これは次のようなエラーを出すかもしれません

```console
$ rustc mycode.rs
error[E0999]: oh no! this is an error!
 --> mycode.rs:3:5
  |
3 |     sad()
  |     ^ help: try using a qux here: `qux sad()`

error: aborting due to previous error

For more information about this error, try `rustc --explain E0999`.
```

<!--In some cases, like when the suggestion spans multiple lines or when there are multiple suggestions, the suggestions are displayed on their own:-->
場合によっては、提案が複数の行にまたがっている場合や複数の提案がある場合のように、提案は独自に表示されます：

```console
error[E0999]: oh no! this is an error!
 --> mycode.rs:3:5
  |
3 |     sad()
  |     ^
help: try using a qux here:
  |
3 |     qux sad()
  |     ^^^

error: aborting due to previous error

For more information about this error, try `rustc --explain E0999`.
```

<!--There are a few other [`Applicability`][appl] possibilities:-->
他にもいくつかの[`Applicability`][appl]可能性があります。

- <!--`MachineApplicable`: Can be applied mechanically.-->
   `MachineApplicable`：機械的に適用することができます。
- <!--`HasPlaceholders`: Cannot be applied mechanically because it has placeholder text in the suggestions.-->
   `HasPlaceholders`：提案にプレースホルダテキストがあるため機械的には適用できません。
<!--For example, "Try adding a type: \ `let x: \<type\>\` ".-->
   たとえば、「型を追加してみてください：\ `let x: \<type\>\` 」と入力します。
- <!--`MaybeIncorrect`: Cannot be applied mechanically because the suggestion may or may not be a good one.-->
   `MaybeIncorrect`：提案が良いものであるかもしれないし、そうでないかもしれないので機械的には適用できない。
- <!--`Unspecified`: Cannot be applied mechanically because we don't know which of the above cases it falls into.-->
   未`Unspecified`：上記のいずれのケースに該当するのかわからないため、機械的には適用できません。

[appl]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/enum.Applicability.html

## <!--Lints--> 糸くず

<!--The compiler linting infrastructure is defined in the [`rustc::lint`][rlint] module.-->
コンパイラリンキングインフラストラクチャは、[`rustc::lint`][rlint]モジュールで定義されています。

[rlint]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/lint/index.html

### <!--Declaring a lint--> リント宣言

<!--The built-in compiler lints are defined in the [`rustc_lint`][builtin] crate.-->
組み込みのコンパイラlintsは、[`rustc_lint`][builtin]クレートに定義されています。

[builtin]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_lint/index.html

<!--Each lint is defined as a `struct` that implements the `LintPass` `trait`.-->
各lintは、`LintPass` `trait`を実装する`struct`として定義されてい`trait`。
<!--The trait implementation allows you to check certain syntactic constructs the linter walks the source code.-->
traitの実装では、リンターがソースコードを参照する特定の構文構造をチェックすることができます。
<!--You can then choose to emit lints in a very similar way to compile errors.-->
エラーをコンパイルするのと非常によく似た方法でlintを出力することができます。
<!--Finally, you register the lint to actually get it to be run by the compiler by using the `declare_lint!` macro.-->
最後に、lintを登録して、`declare_lint!`マクロを使用して`declare_lint!`コンパイラによって実行されるようにします。

<!--For example, the following lint checks for uses of `while true { ... }` and suggests using `loop { ... }` instead.-->
たとえば、次のlintは`while true { ... }`使用をチェックし、代わりに`loop { ... }`を使用することを提案し`loop { ... }`。

```rust,ignore
#// Declare a lint called `WHILE_TRUE`
//  `WHILE_TRUE`というリントを宣言する
declare_lint! {
    WHILE_TRUE,

#    // warn-by-default
    // デフォルトで警告する
    Warn,

#    // This string is the lint description
    // この文字列はリントの説明です
    "suggest using `loop { }` instead of `while true { }`"
}

#// Define a struct and `impl LintPass` for it.
// 構造体と`impl LintPass`を定義します。
#[derive(Copy, Clone)]
pub struct WhileTrue;

impl LintPass for WhileTrue {
    fn get_lints(&self) -> LintArray {
        lint_array!(WHILE_TRUE)
    }
}

#// LateLintPass has lots of methods. We only override the definition of
#// `check_expr` for this lint because that's all we need, but you could
#// override other methods for your own lint. See the rustc docs for a full
#// list of methods.
//  LateLintPassにはたくさんのメソッドがあります。このlintの`check_expr`の定義をオーバーライドするだけですが、それだけで`check_expr`ですが、自分のlintのために他のメソッドをオーバーライドできます。メソッドの完全なリストについては、rustcのドキュメントを参照してください。
impl<'a, 'tcx> LateLintPass<'a, 'tcx> for WhileTrue {
    fn check_expr(&mut self, cx: &LateContext, e: &hir::Expr) {
        if let hir::ExprWhile(ref cond, ..) = e.node {
            if let hir::ExprLit(ref lit) = cond.node {
                if let ast::LitKind::Bool(true) = lit.node {
                    if lit.span.ctxt() == SyntaxContext::empty() {
                        let msg = "denote infinite loops with `loop { ... }`";
                        let condition_span = cx.tcx.sess.codemap().def_span(e.span);
                        let mut err = cx.struct_span_lint(WHILE_TRUE, condition_span, msg);
                        err.span_suggestion_short(condition_span, "use `loop`", "loop".to_owned());
                        err.emit();
                    }
                }
            }
        }
    }
}
```

### <!--Edition-gated Lints--> 版依存の糸くず

<!--Sometimes we want to change the behavior of a lint in a new edition.-->
時には新しい版で糸くずの動作を変えたいと思うことがあります。
<!--To do this, we just add the transition to our invocation of `declare_lint!`:-->
これを行うには、`declare_lint!`呼び出しにトランジションを追加するだけ`declare_lint!`：

```rust,ignore
declare_lint! {
    pub ANONYMOUS_PARAMETERS,
    Allow,
    "detects anonymous parameters",
    Edition::Edition2018 => Warn,
}
```

<!--This makes the `ANONYMOUS_PARAMETERS` lint allow-by-default in the 2015 edition but warn-by-default in the 2018 edition.-->
これにより、`ANONYMOUS_PARAMETERS` lintは2015年版でデフォルトで許可されますが、2018年版ではデフォルトで警告されます。

<!--Lints that represent an incompatibility (ie error) in the upcoming edition should also be registered as `FutureIncompatibilityLint` s in [`register_builtins`][rbuiltins] function in [`rustc_lint::lib`][builtin].-->
次期版で互換性がない（すなわちエラー）を表すLintsもとして登録する必要があります`FutureIncompatibilityLint`での[`register_builtins`][rbuiltins]中の関数[`rustc_lint::lib`][builtin]。

### <!--Lint Groups--> リントグループ

<!--Lints can be turned on in groups.-->
リントはグループでオンにすることができます。
<!--These groups are declared in the [`register_builtins`][rbuiltins] function in [`rustc_lint::lib`][builtin].-->
これらのグループは、[`rustc_lint::lib`][builtin] [`register_builtins`][rbuiltins]関数で宣言されてい[`register_builtins`][rbuiltins]。
<!--The `add_lint_group!` macro is used to declare a new group.-->
`add_lint_group!`マクロは、新しいグループを宣言するために使用されます。

[rbuiltins]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_lint/fn.register_builtins.html

<!--For example,-->
例えば、

```rust,ignore
    add_lint_group!(sess,
                    "nonstandard_style",
                    NON_CAMEL_CASE_TYPES,
                    NON_SNAKE_CASE,
                    NON_UPPER_CASE_GLOBALS);
```

<!--This defines the `nonstandard_style` group which turns on the listed lints.-->
これは、リストされたlintをオンにする`nonstandard_style`グループを定義します。
<!--A user can turn on these lints with a `!#[warn(nonstandard_style)]` attribute in the source code, or by passing `-W nonstandard-style` on the command line.-->
ユーザーは、ソースコードの`!#[warn(nonstandard_style)]`属性を使用するか、コマンドラインで`-W nonstandard-style`を渡して、これらのlintを有効にすることができます。

### <!--Linting early in the compiler--> コンパイラの早い段階

<!--On occasion, you may need to define a lint that runs before the linting system has been initialized (eg during parsing or macro expansion).-->
場合によっては、リンキングシステムが初期化される前に実行されるlintを定義する必要があるかもしれません（例えば、解析やマクロ展開中）。
<!--This is problematic because we need to have computed lint levels to know whether we should emit a warning or an error or nothing at all.-->
これは問題があります。なぜなら、警告またはエラーを出すべきかどうかを知るためには、lintレベルを計算する必要があるからです。

<!--To solve this problem, we buffer the lints until the linting system is processed.-->
この問題を解決するために、lintingシステムが処理されるまでlintをバッファします。
<!--[`Session`][sessbl] and [`ParseSess`][parsebl] both have `buffer_lint` methods that allow you to buffer a lint for later.-->
[`Session`][sessbl]と[`ParseSess`][parsebl]両方に`buffer_lint`メソッドがあります。`buffer_lint`メソッドを使うと、後でlintをバッファすることができます。
<!--The linting system automatically takes care of handling buffered lints later.-->
lintingシステムは、後でバッファリングされたlintを自動的に処理します。

<!--[sessbl]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html#method.buffer_lint
 [parsebl]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/struct.ParseSess.html#method.buffer_lint
-->
[sessbl]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html#method.buffer_lint
 [parsebl]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/struct.ParseSess.html#method.buffer_lint


<!--Thus, to define a lint that runs early in the compilation, one defines a lint like normal but invokes the lint with `buffer_lint`.-->
したがって、コンパイルの初期段階で実行されるlintを定義するには、lintをnormalのように定義しますが、lintを`buffer_lint`呼び出します。

#### <!--Linting even earlier in the compiler--> コンパイラの早い段階で糸曳き

<!--The parser (`libsyntax`) is interesting in that it cannot have dependencies on any of the other `librustc*` crates.-->
パーサー（`libsyntax`）は、他の`librustc*`クレートに依存することができない点で面白いです。
<!--In particular, it cannot depend on `librustc::lint` or `librustc_lint`, where all of the compiler linting infrastructure is defined.-->
特に、`librustc::lint`や`librustc_lint`に依存することはできません`librustc::lint`や`librustc_lint`では、すべてのコンパイラlintingインフラストラクチャが定義されています。
<!--That's troublesome!-->
それは面倒です！

<!--To solve this, `libsyntax` defines its own buffered lint type, which `ParseSess::buffer_lint` uses.-->
これを解決するために、`libsyntax`は独自のバッファリングされたlint型を定義します。これは`ParseSess::buffer_lint`使用します。
<!--After macro expansion, these buffered lints are then dumped into the `Session::buffered_lints` used by the rest of the compiler.-->
マクロ展開の後、これらのバッファリングされたlintは、残りのコンパイラで使用される`Session::buffered_lints`ダンプされます。

<!--Usage for buffered lints in `libsyntax` is pretty much the same as the rest of the compiler with one exception because we cannot import the `LintId` s for lints we want to emit.-->
でバッファリングされlintsの使用上`libsyntax`私たちがインポートできないので、かなりの1つの例外を除き、コンパイラの他の部分と同じである`LintId`我々が発光するようにしたいlintsため秒。
<!--Instead, the [`BufferedEarlyLintId`] type is used.-->
代わりに、[`BufferedEarlyLintId`]型が使用されます。
<!--If you are defining a new lint, you will want to add an entry to this enum.-->
新しいlintを定義している場合は、この列挙型に項目を追加することになります。
<!--Then, add an appropriate mapping to the body of [`Lint::from_parser_lint_id`][fplid].-->
次に、[`Lint::from_parser_lint_id`][fplid]本文に適切なマッピングを追加します。

<!--[`BufferedEarlyLintId`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/early_buffered_lints/struct.BufferedEarlyLintId.html
 [fplid]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/lint/struct.Lint.html#from_parser_lint_id
-->
[`BufferedEarlyLintId`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/early_buffered_lints/struct.BufferedEarlyLintId.html
 [fplid]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/lint/struct.Lint.html#from_parser_lint_id

