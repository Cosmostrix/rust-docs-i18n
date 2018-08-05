# <!--Appendix D: Code Index--> 付録D：コードインデックス

<!--rustc has a lot of important data structures.-->
rustcには多くの重要なデータ構造があります。
<!--This is an attempt to give some guidance on where to learn more about some of the key data structures of the compiler.-->
これは、コンパイラの主要なデータ構造のいくつかについての詳細を知るためのガイダンスを提供しようとする試みです。

<!--Item |-->
アイテム|
<!--Kind |-->
種類|
<!--Short description |-->
簡単な説明|
<!--Chapter |-->
章|
<!--Declaration ----------------|----------|-----------------------------|--------------------|-------------------`BodyId` |-->
宣言----------------| ----------| -----------------------------| --------------------| -------------------`BodyId` |
<!--struct |-->
構造体|
<!--One of four types of HIR node identifiers |-->
4種類のHIRノード識別子の1つ|
<!--[Identifiers in the HIR] |-->
[Identifiers in the HIR] |
<!--[src/librustc/hir/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/hir/struct.BodyId.html) `CodeMap` |-->
[src/librustc/hir/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/hir/struct.BodyId.html) `CodeMap` |
<!--struct |-->
構造体|
<!--Maps AST nodes to their source code.-->
ASTノードをソースコードにマップします。
<!--It is composed of `FileMap` s |-->
これは、`FileMap` |
<!--[The parser] |-->
[The parser] |
<!--[src/libsyntax/codemap.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html) `CompileState` |-->
[src/libsyntax/codemap.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html) `CompileState` |
<!--struct |-->
構造体|
<!--State that is passed to a callback at each compiler pass |-->
各コンパイラでコールバックに渡される状態|
<!--[The Rustc Driver] |-->
[The Rustc Driver] |
<!--[src/librustc_driver/driver.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/driver/struct.CompileState.html) `ast::Crate` |-->
[src/librustc_driver/driver.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_driver/driver/struct.CompileState.html) `ast::Crate` |
<!--struct |-->
構造体|
<!--A syntax-level representation of a parsed crate |-->
構文解析されたクレートの構文レベル表現|
<!--[The parser] |-->
[The parser] |
<!--[src/librustc/hir/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ast/struct.Crate.html) `hir::Crate` |-->
[src/librustc/hir/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ast/struct.Crate.html) `hir::Crate` |
<!--struct |-->
構造体|
<!--A more abstract, compiler-friendly form of a crate's AST |-->
より抽象的で、コンパイラに優しいクレートのAST |
<!--[The Hir] |-->
[The Hir] |
<!--[src/librustc/hir/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/hir/struct.Crate.html) `DefId` |-->
[src/librustc/hir/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/hir/struct.Crate.html) `DefId` |
<!--struct |-->
構造体|
<!--One of four types of HIR node identifiers |-->
4種類のHIRノード識別子の1つ|
<!--[Identifiers in the HIR] |-->
[Identifiers in the HIR] |
<!--[src/librustc/hir/def_id.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/hir/def_id/struct.DefId.html) `DiagnosticBuilder` |-->
[src/librustc/hir/def_id.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/hir/def_id/struct.DefId.html) `DiagnosticBuilder` |
<!--struct |-->
構造体|
<!--A struct for building up compiler diagnostics, such as errors or lints |-->
エラーやlintsなどのコンパイラ診断を構築するための構造体|
<!--[Emitting Diagnostics] |-->
[Emitting Diagnostics] |
<!--[src/librustc_errors/diagnostic_builder.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/struct.DiagnosticBuilder.html) `DocContext` |-->
[src/librustc_errors/diagnostic_builder.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/struct.DiagnosticBuilder.html) `DocContext` |
<!--struct |-->
構造体|
<!--A state container used by rustdoc when crawling through a crate to gather its documentation |-->
rustdocがクレートを通過してドキュメントを収集するときに使用する状態コンテナ
<!--[Rustdoc] |-->
[Rustdoc] |
<!--[src/librustdoc/core.rs](https://github.com/rust-lang/rust/blob/master/src/librustdoc/core.rs) `FileMap` |-->
[src/librustdoc/core.rs](https://github.com/rust-lang/rust/blob/master/src/librustdoc/core.rs) `FileMap` |
<!--struct |-->
構造体|
<!--Part of the `CodeMap`.-->
`CodeMap`一部です。
<!--Maps AST nodes to their source code for a single source file |-->
ASTノードを1つのソースファイルのソースコードにマップする|
<!--[The parser] |-->
[The parser] |
<!--[src/libsyntax_pos/lib.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.FileMap.html) `HirId` |-->
[src/libsyntax_pos/lib.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.FileMap.html) `HirId` |
<!--struct |-->
構造体|
<!--One of four types of HIR node identifiers |-->
4種類のHIRノード識別子の1つ|
<!--[Identifiers in the HIR] |-->
[Identifiers in the HIR] |
<!--[src/librustc/hir/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/hir/struct.HirId.html) `NodeId` |-->
[src/librustc/hir/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/hir/struct.HirId.html) `NodeId` |
<!--struct |-->
構造体|
<!--One of four types of HIR node identifiers.-->
4種類のHIRノード識別子の1つ。
<!--Being phased out |-->
段階的に廃止される|
<!--[Identifiers in the HIR] |-->
[Identifiers in the HIR] |
<!--[src/libsyntax/ast.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ast/struct.NodeId.html) `ParamEnv` |-->
[src/libsyntax/ast.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ast/struct.NodeId.html) `ParamEnv` |
<!--struct |-->
構造体|
<!--Information about generic parameters or `Self`, useful for working with associated or generic items |-->
一般的なパラメータまたは`Self`に関する情報。関連するアイテムまたは一般的なアイテムの操作に便利です。
<!--[Parameter Environment] |-->
[Parameter Environment] |
<!--[src/librustc/ty/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/struct.ParamEnv.html) `ParseSess` |-->
[src/librustc/ty/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/struct.ParamEnv.html) `ParseSess` |
<!--struct |-->
構造体|
<!--This struct contains information about a parsing session |-->
この構造体には、解析セッションに関する情報が含まれています。
<!--[The parser] |-->
[The parser] |
<!--[src/libsyntax/parse/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/struct.ParseSess.html) `Rib` |-->
[src/libsyntax/parse/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/struct.ParseSess.html) `Rib` |
<!--struct |-->
構造体|
<!--Represents a single scope of names |-->
名前の単一スコープを表します。
<!--[Name resolution] |-->
[Name resolution] |
<!--[src/librustc_resolve/lib.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_resolve/struct.Rib.html) `Session` |-->
[src/librustc_resolve/lib.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_resolve/struct.Rib.html) `Session` |
<!--struct |-->
構造体|
<!--The data associated with a compilation session |-->
コンパイルセッションに関連するデータ|
<!--[The parser], [The Rustc Driver] |-->
[The parser]、 [The Rustc Driver] |
<!--[src/librustc/session/mod.html](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html) `Span` |-->
[src/librustc/session/mod.html](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/session/struct.Session.html) `Span` |
<!--struct |-->
構造体|
<!--A location in the user's source code, used for error reporting primarily |-->
主にエラー報告に使用されるユーザーのソースコード内の場所|
<!--[Emitting Diagnostics] |-->
[Emitting Diagnostics] |
<!--[src/libsyntax_pos/span_encoding.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax_pos/struct.Span.html) `StringReader` |-->
[src/libsyntax_pos/span_encoding.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax_pos/struct.Span.html) `StringReader` |
<!--struct |-->
構造体|
<!--This is the lexer used during parsing.-->
これは解析中に使用されるレクサーです。
<!--It consumes characters from the raw source code being compiled and produces a series of tokens for use by the rest of the parser |-->
コンパイルされている生のソースコードの文字を消費し、残りのパーサーが使用する一連のトークンを生成します。
<!--[The parser] |-->
[The parser] |
<!--[src/libsyntax/parse/lexer/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/lexer/struct.StringReader.html) `syntax::token_stream::TokenStream` |-->
[src/libsyntax/parse/lexer/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/lexer/struct.StringReader.html) `syntax::token_stream::TokenStream` |
<!--struct |-->
構造体|
<!--An abstract sequence of tokens, organized into `TokenTree` s |-->
`TokenTree`に編成されたトークンの抽象シーケンス|
<!--[The parser], [Macro expansion] |-->
[The parser]、 [Macro expansion] |
<!--[src/libsyntax/tokenstream.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/tokenstream/struct.TokenStream.html) `TraitDef` |-->
[src/libsyntax/tokenstream.rs](https://doc.rust-lang.org/nightly/nightly-rustc/syntax/tokenstream/struct.TokenStream.html) `TraitDef` |
<!--struct |-->
構造体|
<!--This struct contains a trait's definition with type information |-->
この構造体には型情報を持つtraitの定義が含まれています。
<!--[The `ty` modules] |-->
[The `ty` modules] |
<!--[src/librustc/ty/trait_def.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/trait_def/struct.TraitDef.html) `TraitRef` |-->
[src/librustc/ty/trait_def.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/trait_def/struct.TraitDef.html) `TraitRef` |
<!--struct |-->
構造体|
<!--The combination of a trait and its input types (eg `P0: Trait<P1...Pn>`) |-->
形質とその入力タイプの組み合わせ（例： `P0: Trait<P1...Pn>`）
<!--[Trait Solving: Goals and Clauses], [Trait Solving: Lowering impls] |-->
[Trait Solving: Goals and Clauses]、 [Trait Solving: Lowering impls] |
<!--[src/librustc/ty/sty.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/struct.TraitRef.html) `Ty<'tcx>` |-->
[src/librustc/ty/sty.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/struct.TraitRef.html) `Ty<'tcx>` |
<!--struct |-->
構造体|
<!--This is the internal representation of a type used for type checking |-->
これは、型チェックに使用される型の内部表現です。
<!--[Type checking] |-->
[Type checking] |
<!--[src/librustc/ty/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/type.Ty.html) `TyCtxt<'cx, 'tcx, 'tcx>` |-->
[src/librustc/ty/mod.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/type.Ty.html) `TyCtxt<'cx, 'tcx, 'tcx>` |
<!--type |-->
タイプ|
<!--The "typing context".-->
"タイピングの文脈"。
<!--This is the central data structure in the compiler.-->
これはコンパイラの中心的なデータ構造です。
<!--It is the context that you use to perform all manner of queries |-->
これは、すべての方法の問合せを実行するために使用するコンテキストです。
<!--[The `ty` modules] |-->
[The `ty` modules] |
[src/librustc/ty/context.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/struct.TyCtxt.html)
<!--[The HIR]: hir.html
 [Identifiers in the HIR]: hir.html#hir-id
 [The parser]: the-parser.html
 [The Rustc Driver]: rustc-driver.html
 [Type checking]: type-checking.html
 [The `ty` modules]: ty.html
 [Rustdoc]: rustdoc.html
 [Emitting Diagnostics]: diag.html
 [Macro expansion]: macro-expansion.html
 [Name resolution]: name-resolution.html
 [Parameter Environment]: param_env.html
 [Trait Solving: Goals and Clauses]: traits/goals-and-clauses.html#domain-goals
 [Trait Solving: Lowering impls]: traits/lowering-rules.html#lowering-impls
-->
[The HIR]: hir.html
 [Identifiers in the HIR]: hir.html#hir-id
 [The HIR]: hir.html
 [Identifiers in the HIR]: hir.html#hir-id
 [The parser]: the-parser.html
 [The Rustc Driver]: rustc-driver.html
 [Type checking]: type-checking.html
 [The `ty` modules]: ty.html
 [Rustdoc]: rustdoc.html
 [Emitting Diagnostics]: diag.html
 [Macro expansion]: macro-expansion.html
 [Name resolution]: name-resolution.html
 [Parameter Environment]: param_env.html
 [Trait Solving: Goals and Clauses]: traits/goals-and-clauses.html#domain-goals
 [Trait Solving: Lowering impls]: traits/lowering-rules.html#lowering-impls

