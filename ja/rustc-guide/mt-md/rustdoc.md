# <!--The walking tour of rustdoc--> rustdocのウォーキングツアー

<!--Rustdoc actually uses the rustc internals directly.-->
Rustdocは実際にはrustcの内部構造を直接使用しています。
<!--It lives in-tree with the compiler and standard library.-->
コンパイラと標準ライブラリでツリー内に存在します。
<!--This chapter is about how it works.-->
この章では、どのように動作するかについて説明します。

<!--Rustdoc is implemented entirely within the crate [`librustdoc`][rd].-->
Rustdocはクレート内に完全に実装されて[`librustdoc`][rd]。
<!--It runs the compiler up to the point where we have an internal representation of a crate (HIR) and the ability to run some queries about the types of items.-->
これはコンパイラを実行して、クレート（HIR）の内部表現を持ち、アイテムのタイプについていくつかのクエリを実行できるようになります。
<!--[HIR] and [queries] are discussed in the linked chapters.-->
[HIR]と[queries]については、リンクされた章で説明します。

<!--[HIR]: ./hir.html
 [queries]: ./query.html
 [rd]: https://github.com/rust-lang/rust/tree/master/src/librustdoc
-->
[HIR]: ./hir.html
 [queries]: ./query.html
 [rd]: https://github.com/rust-lang/rust/tree/master/src/librustdoc


<!--`librustdoc` performs two major steps after that to render a set of documentation:-->
`librustdoc`は、それ以降の2つの主要なステップを実行して一連のドキュメントをレンダリングします。

* <!--"Clean"the AST into a form that's more suited to creating documentation (and slightly more resistant to churn in the compiler).-->
   ASTをドキュメントを作成するのに適した形にしています（そして、コンパイラの解読に若干抵抗力があります）。
* <!--Use this cleaned AST to render a crate's documentation, one page at a time.-->
   一度に1ページずつクレートのドキュメントをレンダリングするには、このクリーンASTを使用します。

<!--Naturally, there's more than just this, and those descriptions simplify out lots of details, but that's the high-level overview.-->
当然ながら、これ以上のものがあり、それらの記述は詳細を多く簡略化しますが、それは高水準の概要です。

<!--(Side note: `librustdoc` is a library crate! The `rustdoc` binary is created using the project in [`src/tools/rustdoc`][bin]. Note that literally all that does is call the `main()` that's in this crate's `lib.rs`, though.)-->
（サイドノート： `librustdoc`はライブラリの箱です！）`rustdoc`バイナリは[`src/tools/rustdoc`][bin]プロジェクトを使って作成されていますが、文字通り、このクレートの`lib.rs`にある`main()`を呼び出しています。

[bin]: https://github.com/rust-lang/rust/tree/master/src/tools/rustdoc

## <!--Cheat sheet--> カンニングペーパー

* <!--Use `./x.py build --stage 1 src/libstd src/tools/rustdoc` to make a useable rustdoc you can run on other projects.-->
   `./x.py build --stage 1 src/libstd src/tools/rustdoc`を使用して、他のプロジェクトで実行可能なrustdocを作成してください。
  * <!--Add `src/libtest` to be able to use `rustdoc --test`.-->
     `rustdoc --test`を使用できるように`src/libtest`を追加してください。
  * <!--If you've used `rustup toolchain link local /path/to/build/$TARGET/stage1` previously, then after the previous build command, `cargo +local doc` will Just Work.-->
     前回のビルドコマンドの後に`rustup toolchain link local /path/to/build/$TARGET/stage1`を使用した場合、`cargo +local doc`はJust Workとなります。
* <!--Use `./x.py doc --stage 1 src/libstd` to use this rustdoc to generate the standard library docs.-->
   `./x.py doc --stage 1 src/libstd`を使用して、このrustdocを使用して標準ライブラリdocsを生成します。
  * <!--The completed docs will be available in `build/$TARGET/doc/std`, though the bundle is meant to be used as though you would copy out the `doc` folder to a web server, since that's where the CSS/JS and landing page are.-->
     完成したドキュメントは`build/$TARGET/doc/std`で利用できますが、バンドルはCSS / JSとリンク先ページがあるため、`doc`フォルダをWebサーバーにコピーするように使用されます。
* <!--Most of the HTML printing code is in `html/format.rs` and `html/render.rs`.-->
   ほとんどのHTML印刷コードは`html/format.rs`と`html/render.rs`ます。
<!--It's in a bunch of `fmt::Display` implementations and supplementary functions.-->
   これは`fmt::Display`実装と補足関数の束です。
* <!--The types that got `Display` impls above are defined in `clean/mod.rs`, right next to the custom `Clean` trait used to process them out of the rustc HIR.-->
   上記の`Display`インプラントを持つタイプは、`clean/mod.rs`で定義されています。カスタムHIRからそれらを処理するために使用されるカスタム`Clean`特性のすぐ隣にあります。
* <!--The bits specific to using rustdoc as a test harness are in `test.rs`.-->
   テストハーネスとしてのrustdocの使用に固有のビットは`test.rs`ます。
* <!--The Markdown renderer is loaded up in `html/markdown.rs`, including functions for extracting doctests from a given block of Markdown.-->
   Markdownレンダラーは`html/markdown.rs`ロードされ、Markdownの与えられたブロックからdoctestを抽出する関数を含みます。
* <!--The tests on rustdoc *output* are located in `src/test/rustdoc`, where they're handled by the test runner of rustbuild and the supplementary script `src/etc/htmldocck.py`.-->
   rustdoc *出力*のテストは`src/test/rustdoc`にあります。そこではrustbuildのテストランナーと補足スクリプト`src/etc/htmldocck.py`ます。
* <!--Tests on search index generation are located in `src/test/rustdoc-js`, as a series of JavaScript files that encode queries on the standard library search index and expected results.-->
   検索インデックスの生成に関するテストは、`src/test/rustdoc-js`にあります。これは、標準ライブラリ検索インデックスと期待される結果に関するクエリをエンコードする一連のJavaScriptファイルです。

## <!--From crate to clean--> クレートからクリーンまで

<!--In `core.rs` are two central items: the `DocContext` struct, and the `run_core` function.-->
`core.rs`は、`DocContext`構造体と`run_core`関数の2つの中心的な項目が`run_core`ます。
<!--The latter is where rustdoc calls out to rustc to compile a crate to the point where rustdoc can take over.-->
後者は、rustdocが引き継ぐことができるポイントまで木箱をコンパイルするためにrustdocがrustcに呼び出すところです。
<!--The former is a state container used when crawling through a crate to gather its documentation.-->
前者は、ドキュメントを収集するためにクレートを通ってクロールするときに使用される状態コンテナです。

<!--The main process of crate crawling is done in `clean/mod.rs` through several implementations of the `Clean` trait defined within.-->
クレートクロールのメインプロセスは、`clean/mod.rs`定義された`Clean`な特性のいくつかの実装を通じて行われます。
<!--This is a conversion trait, which defines one method:-->
これは1つの方法を定義する変換特性です。

```rust,ignore
pub trait Clean<T> {
    fn clean(&self, cx: &DocContext) -> T;
}
```

<!--`clean/mod.rs` also defines the types for the "cleaned"AST used later on to render documentation pages.-->
`clean/mod.rs`は、ドキュメントページをレンダリングするために後で使用される「クリーン」ASTのタイプも定義します。
<!--Each usually accompanies an implementation of `Clean` that takes some AST or HIR type from rustc and converts it into the appropriate "cleaned"type.-->
それぞれは、通常、rustcのASTまたはHIRタイプを取り、適切な「クリーン」タイプに変換する`Clean`実装に伴います。
<!--"Big"items like modules or associated items may have some extra processing in its `Clean` implementation, but for the most part these impls are straightforward conversions.-->
モジュールや関連アイテムのような「ビッグ」アイテムは、`Clean`実装では余分な処理を行うことがありますが、ほとんどの場合、これらのインプットは直接的な変換です。
<!--The "entry point"to this module is the `impl Clean<Crate> for visit_ast::RustdocVisitor`, which is called by `run_core` above.-->
このモジュールの「エントリーポイント」は、上記の`run_core`によって`run_core`れる`impl Clean<Crate> for visit_ast::RustdocVisitor`の`impl Clean<Crate> for visit_ast::RustdocVisitor`。

<!--You see, I actually lied a little earlier: There's another AST transformation that happens before the events in `clean/mod.rs`.-->
あなたは、少し前に私は実際に嘘をつきました： `clean/mod.rs`イベントの前に起こる別のAST変換があります。
<!--In `visit_ast.rs` is the type `RustdocVisitor`, which *actually* crawls a `hir::Crate` to get the first intermediate representation, defined in `doctree.rs`.-->
`visit_ast.rs`はタイプ`RustdocVisitor`があります。*実際に*は`hir::Crate`をクロールして、最初の中間表現を取得し`doctree.rs`。これは`doctree.rs`で定義されてい`doctree.rs`。
<!--This pass is mainly to get a few intermediate wrappers around the HIR types and to process visibility and inlining.-->
このパスは、主に、HIRタイプの周りにいくつかの中間ラッパーを取得し、可視性とインライン化を処理することです。
<!--This is where `#[doc(inline)]`, `#[doc(no_inline)]`, and `#[doc(hidden)]` are processed, as well as the logic for whether a `pub use` should get the full page or a "Reexport"line in the module page.-->
これは、`#[doc(inline)]`、 `#[doc(no_inline)]`、 `#[doc(hidden)]`が処理され、`pub use`フルページを取得するか、モジュールページの行。

<!--The other major thing that happens in `clean/mod.rs` is the collection of doc comments and `#[doc=""]` attributes into a separate field of the Attributes struct, present on anything that gets hand-written documentation.-->
`clean/mod.rs`で起こるもう一つの主要なことは、`clean/mod.rs`のドキュメントを取得するものの上にある、Attributes構造体の別のフィールドにドキュメントコメントと`#[doc=""]`属性のコレクションです。
<!--This makes it easier to collect this documentation later in the process.-->
これにより、プロセスの後半でこの文書を簡単に収集することができます。

<!--The primary output of this process is a `clean::Crate` with a tree of Items which describe the publicly-documentable items in the target crate.-->
このプロセスの主な出力は、`clean::Crate`で、アイテムのツリーがあり、ターゲットのクレートに公開されているドキュメント化可能なアイテムを記述します。

### <!--Hot potato--> 焼き芋

<!--Before moving on to the next major step, a few important "passes"occur over the documentation.-->
次の大きなステップに進む前に、ドキュメントにいくつかの重要な「パス」が発生します。
<!--These do things like combine the separate "attributes"into a single string and strip leading whitespace to make the document easier on the markdown parser, or drop items that are not public or deliberately hidden with `#[doc(hidden)]`.-->
これらは、別々の "属性"を1つの文字列に組み込み、先頭の空白を取り除いてマークダウンパーサ上でドキュメントを簡単にしたり、`#[doc(hidden)]`公開または故意に隠されていないアイテムをドロップしたりするような処理を行います。
<!--These are all implemented in the `passes/` directory, one file per pass.-->
これらはすべて`passes/`ディレクトリに実装されています。パスごとに1つのファイルです。
<!--By default, all of these passes are run on a crate, but the ones regarding dropping private/hidden items can be bypassed by passing `--document-private-items` to rustdoc.-->
デフォルトでは、これらのパスはすべてクレートで実行されますが、private / hidden項目の削除に関する`--document-private-items`をrustdocに渡すことで回避できます。
<!--Note that unlike the previous set of AST transformations, the passes happen on the  _cleaned_  crate.-->
以前のAST変換のセットとは異なり、パスは _クリーン・_ クレートで _行われる_ ことに注意してください。

<!--(Strictly speaking, you can fine-tune the passes run and even add your own, but [we're trying to deprecate that][44136]. If you need finer-grain control over these passes, please let us know!)-->
（厳密に微調整パスが実行しても、あなた自身を追加し、あなたが言えば、しかし、[我々はそれを廃止しようとしている][44136]。あなたはこれらのパスを細かく粒に制御する必要がある場合は、私たちに知らせてください！）

[44136]: https://github.com/rust-lang/rust/issues/44136

<!--Here is current (as of this writing) list of passes:-->
ここに現在の（この執筆時点で）パスのリストがあります：

- <!--`propagate-doc-cfg` -propagates `#[doc(cfg(...))]` to child items.-->
   `propagate-doc-cfg` -`#[doc(cfg(...))]`を子項目に伝播します。
- <!--`collapse-docs` concatenates all document attributes into one document attribute.-->
   `collapse-docs`すべてのドキュメント属性を1つのドキュメント属性に連結します。
<!--This is necessary because each line of a doc comment is given as a separate doc attribute, and this will combine them into a single string with line breaks between each attribute.-->
   これは、docコメントの各行が別々のdoc属性として指定され、各属性間に改行を含む単一の文字列に結合されるため必要です。
- <!--`unindent-comments` removes excess indentation on comments in order for markdown to like it.-->
   `unindent-comments`は、マークダウンが好きになるように、コメントの余分な字下げを取り除きます。
<!--This is necessary because the convention for writing documentation is to provide a space between the `///` or `//!` marker and the text, and stripping that leading space will make the text easier to parse by the Markdown parser.-->
   これは、ドキュメントを書くための規約は、`///`または`//!`マーカーとテキストの間にスペースを入れ、その先頭のスペースを取り除くことで、Markdownパーサーがテキストを解析しやすくするためです。
<!--(In the past, the markdown parser used was not Commonmark-compliant, which caused annoyances with extra whitespace but this seems to be less of an issue today.)-->
   （以前は、使用されたマークダウンパーサーはCommonmarkに準拠していなかったため、余分な空白を迷惑にしていましたが、今日はそれほど問題にはならないようです）。
- <!--`strip-priv-imports` strips all private import statements (`use`, `extern crate`) from a crate.-->
   `strip-priv-imports`は、クレートからすべてのプライベートインポートステートメント（`use`、 `extern crate`）を削除します。
<!--This is necessary because rustdoc will handle *public* imports by either inlining the item's documentation to the module or creating a "Reexports"section with the import in it.-->
   これは、rustdocがアイテムのドキュメンテーションをモジュールにインライン展開するか、インポートした「Reexports」セクションを作成することで、*パブリック*インポートを処理するために必要です。
<!--The pass ensures that all of these imports are actually relevant to documentation.-->
   パスは、これらの輸入のすべてが実際に文書に関連していることを保証します。
- <!--`strip-hidden` and `strip-private` strip all `doc(hidden)` and private items from the output.-->
   `strip-hidden`と`strip-private`すべての`doc(hidden)`とプライベート項目を出力から削除します。
<!--`strip-private` implies `strip-priv-imports`.-->
   `strip-private`、 `strip-priv-imports`意味`strip-priv-imports`ます。
<!--Basically, the goal is to remove items that are not relevant for public documentation.-->
   基本的には、公開ドキュメントに関係のないアイテムを削除することが目標です。

## <!--From clean to crate--> クリーンからクレートまで

<!--This is where the "second phase"in rustdoc begins.-->
これは、rustdocの「第2段階」が始まるところです。
<!--This phase primarily lives in the `html/` folder, and it all starts with `run()` in `html/render.rs`.-->
このフェーズは主に`html/`フォルダにあり、`html/render.rs`では`run()`で`html/render.rs`ます。
<!--This code is responsible for setting up the `Context`, `SharedContext`, and `Cache` which are used during rendering, copying out the static files which live in every rendered set of documentation (things like the fonts, CSS, and JavaScript that live in `html/static/`), creating the search index, and printing out the source code rendering, before beginning the process of rendering all the documentation for the crate.-->
このコードは、レンダリング時に使用される`Context`、 `SharedContext`、および`Cache`を設定し、レンダリングされたすべてのドキュメントセット（`html/static/`するフォント、CSS、JavaScriptなど）に存在する静的ファイルをコピーします。）、検索インデックスを作成し、ソースコードレンダリングを印刷してから、クレートのすべてのドキュメントをレンダリングするプロセスを開始します。

<!--Several functions implemented directly on `Context` take the `clean::Crate` and set up some state between rendering items or recursing on a module's child items.-->
`Context`直接実装されたいくつかの関数は、`clean::Crate`を取り、レンダリング項目間またはモジュールの子項目で再帰する間にある状態を設定します。
<!--From here the "page rendering"begins, via an enormous `write!()` call in `html/layout.rs`.-->
ここからは、`html/layout.rs`巨大な`write!()`呼び出しを介して、"ページレンダリング"が始まります。
<!--The parts that actually generate HTML from the items and documentation occurs within a series of `std::fmt::Display` implementations and functions that pass around a `&mut std::fmt::Formatter`.-->
アイテムとドキュメントから実際にHTMLを生成する部分は、一連の`std::fmt::Display`実装と、`&mut std::fmt::Formatter`を渡す関数内で発生します。
<!--The top-level implementation that writes out the page body is the `impl<'a> fmt::Display for Item<'a>` in `html/render.rs`, which switches out to one of several `item_*` functions based on the kind of `Item` being rendered.-->
ページ本文を書き出すトップレベルの実装は、`html/render.rs` `impl<'a> fmt::Display for Item<'a>`の`impl<'a> fmt::Display for Item<'a>`であり、その種類に基づいていくつかの`item_*`関数の1つに切り替わりますレンダリングされる`Item`。

<!--Depending on what kind of rendering code you're looking for, you'll probably find it either in `html/render.rs` for major items like "what sections should I print for a struct page"or `html/format.rs` for smaller component pieces like "how should I print a where clause as part of some other item".-->
あなたが探しているレンダリングコードの種類に応じて、おそらく、`html/render.rs`、 "構造ページのためにどのセクションを印刷すべきか"、または小さなコンポーネントのための`html/format.rs` 「where句を他のアイテムの一部としてどのように出力すればよいか」のようなものです。

<!--Whenever rustdoc comes across an item that should print hand-written documentation alongside, it calls out to `html/markdown.rs` which interfaces with the Markdown parser.-->
rustdocが手書きのドキュメントを横に並べて表示するアイテムを見つけるたびに、Markdownパーサとインターフェイスする`html/markdown.rs`を呼び出します。
<!--This is exposed as a series of types that wrap a string of Markdown, and implement `fmt::Display` to emit HTML text.-->
これはMarkdownの文字列をラップする一連の型として公開され、`fmt::Display`を実装してHTMLテキストを出力します。
<!--It takes special care to enable certain features like footnotes and tables and add syntax highlighting to Rust code blocks (via `html/highlight.rs`) before running the Markdown parser.-->
脚注や表のような特定の機能を有効にし、Markdownパーサーを実行する前に錆コードブロック（`html/highlight.rs`経由）に構文ハイライトを追加することには特別な注意が必要です。
<!--There's also a function in here (`find_testable_code`) that specifically scans for Rust code blocks so the test-runner code can find all the doctests in the crate.-->
テストランナーコードがクレート内のすべてのdoctestを見つけることができるように、錆コードブロックをスキャンする関数（`find_testable_code`）もあります。

### <!--From soup to nuts--> スープからナッツまで

<!--(alternate title: ["An unbroken thread that stretches from those first `Cell` s to us"][video])-->
（代替タイトル： [「最初の`Cell`から私たちに伸びる破られていないスレッド」][video]）

[video]: https://www.youtube.com/watch?v=hOLAGYmUQV0

<!--It's important to note that the AST cleaning can ask the compiler for information (crucially, `DocContext` contains a `TyCtxt`), but page rendering cannot.-->
これは、ASTのクリーニングが（決定的に、情報のためのコンパイラを頼むことができることに注意することが重要です`DocContext`含まれている`TyCtxt`）が、ページのレンダリングができません。
<!--The `clean::Crate` created within `run_core` is passed outside the compiler context before being handed to `html::render::run`.-->
`run_core`で作成された`clean::Crate`は、`html::render::run`に渡される前にコンパイラコンテキストの外側に渡され`html::render::run`。
<!--This means that a lot of the "supplementary data"that isn't immediately available inside an item's definition, like which trait is the `Deref` trait used by the language, needs to be collected during cleaning, stored in the `DocContext`, and passed along to the `SharedContext` during HTML rendering.-->
これは、言語によって使用される`Deref`特性であるアイテムの定義内ですぐに利用できない「補足データ」の多くが、クリーニング中に収集され、`DocContext`に格納され、HTMLレンダリング中の`SharedContext`
<!--This manifests as a bunch of shared state, context variables, and `RefCell` s.-->
これは共有状態、コンテキスト変数、および`RefCell`の束として現れます。

<!--Also of note is that some items that come from "asking the compiler"don't go directly into the `DocContext` -for example, when loading items from a foreign crate, rustdoc will ask about trait implementations and generate new `Item` s for the impls based on that information.-->
また、"コンパイラに質問する"`DocContext`由来するいくつかの項目は、`DocContext`に直接は行きません。例えば、外国の木箱からアイテムを読み込むとき、rustdocはtraitの実装について質問し、implsに基づいて新しい`Item`を生成します。その情報に
<!--This goes directly into the returned `Crate` rather than roundabout through the `DocContext`.-->
これは、`DocContext`介したラウンドアバウトではなく、返された`Crate`直接入ります。
<!--This way, these implementations can be collected alongside the others, right before rendering the HTML.-->
このように、これらの実装は、HTMLをレンダリングする直前に、他の実装と一緒に収集することができます。

## <!--Other tricks up its sleeve--> 袖の上の他のトリック

<!--All this describes the process for generating HTML documentation from a Rust crate, but there are couple other major modes that rustdoc runs in. It can also be run on a standalone Markdown file, or it can run doctests on Rust code or standalone Markdown files.-->
これはrustdocが実行するいくつかの主要なモードがあります。スタンドアロンのMarkdownファイルで実行することもできますし、RustコードやスタンドアロンのMarkdownファイルでdoctestを実行することもできます。
<!--For the former, it shortcuts straight to `html/markdown.rs`, optionally including a mode which inserts a Table of Contents to the output HTML.-->
前者の場合、`html/markdown.rs`直接ショートカットし、必要に応じて出力HTMLに目次を挿入するモードも含みます。

<!--For the latter, rustdoc runs a similar partial-compilation to get relevant documentation in `test.rs`, but instead of going through the full clean and render process, it runs a much simpler crate walk to grab *just* the hand-written documentation.-->
後者の場合、rustdocはに関連するドキュメントを取得するために、同様の部分のコンパイルを実行します`test.rs`が、その代わりに、完全なクリーンを通過するのはプロセスをレンダリングし、それ*だけで*手書きの文書をつかむためにはるかに簡単なクレート散歩を実行します。
<!--Combined with the aforementioned "`find_testable_code` "in `html/markdown.rs`, it builds up a collection of tests to run before handing them off to the libtest test runner.-->
`html/markdown.rs` `find_testable_code`の前述の "`find_testable_code` "と組み合わせて、libtestテストランナーに渡す前に実行する一連のテストをビルドします。
<!--One notable location in `test.rs` is the function `make_test`, which is where hand-written doctests get transformed into something that can be executed.-->
`test.rs`注目すべき場所は`test.rs`という関数`make_test`。これは手書きのdoctestが実行可能なものに変換される場所です。

<!--Some extra reading about `make_test` can be found [here](https://quietmisdreavus.net/code/2018/02/23/how-the-doctests-get-made/).-->
`make_test`に関するいくつかの追加情報が[here](https://quietmisdreavus.net/code/2018/02/23/how-the-doctests-get-made/)。

## <!--Dotting i's and crossing t's--> 私はドットをつけています。

<!--So that's rustdoc's code in a nutshell, but there's more things in the repo that deal with it.-->
つまり、rustdocのコードは要点ですが、それを扱うレポにはもっと多くのものがあります。
<!--Since we have the full `compiletest` suite at hand, there's a set of tests in `src/test/rustdoc` that make sure the final HTML is what we expect in various situations.-->
`compiletest`な`compiletest`スイートがあるので、`src/test/rustdoc`は一連のテストがあり、さまざまな状況で最終的なHTMLを期待しています。
<!--These tests also use a supplementary script, `src/etc/htmldocck.py`, that allows it to look through the final HTML using XPath notation to get a precise look at the output.-->
これらのテストでは、補足スクリプト`src/etc/htmldocck.py`も使用しています。これは、出力を正確に見るためにXPath表記を使用して最終HTMLを調べることができます。
<!--The full description of all the commands available to rustdoc tests is in `htmldocck.py`.-->
rustdocテストで使用できるすべてのコマンドの詳細は、`htmldocck.py`して`htmldocck.py`。

<!--In addition, there are separate tests for the search index and rustdoc's ability to query it.-->
さらに、検索インデックスとrustdocのクエリー機能については、別々のテストがあります。
<!--The files in `src/test/rustdoc-js` each contain a different search query and the expected results, broken out by search tab.-->
`src/test/rustdoc-js`各ファイルには、それぞれ異なる検索クエリと、期待される結果が検索タブで表示されます。
<!--These files are processed by a script in `src/tools/rustdoc-js` and the Node.js runtime.-->
これらのファイルは、`src/tools/rustdoc-js`内のスクリプトとNode.jsランタイムによって処理されます。
<!--These tests don't have as thorough of a writeup, but a broad example that features results in all tabs can be found in `basic.js`.-->
これらのテストでは、徹底的な書き出しはありませんが、すべてのタブで結果を表示するという幅広い例は、`basic.js`ます。
<!--The basic idea is that you match a given `QUERY` with a set of `EXPECTED` results, complete with the full item path of each item.-->
基本的な考え方は、指定された`QUERY`に`EXPECTED`結果セットをマッチさせ、各アイテムの完全なアイテムパスを指定することです。
