# <!--The Parser--> パーサー

<!--The parser is responsible for converting raw Rust source code into a structured form which is easier for the compiler to work with, usually called an [*Abstract Syntax Tree*][ast].-->
パーサは、生のRustソースコードを、コンパイラが動作するのが容易な構造化された形式に変換する責任があります。通常、これは、[*抽象構文木*][ast]と呼ばれます。
<!--An AST mirrors the structure of a Rust program in memory, using a `Span` to link a particular AST node back to its source text.-->
ASTはメモリ内のRustプログラムの構造をミラーリングし、`Span`を使用して特定のASTノードをソーステキストにリンクします。

<!--The bulk of the parser lives in the [libsyntax] crate.-->
パーサーの大部分は[libsyntax]クレートにあります。

<!--Like most parsers, the parsing process is composed of two main steps,-->
ほとんどのパーサーと同様に、解析プロセスは2つの主要なステップから構成されています。

- <!--lexical analysis – turn a stream of characters into a stream of token trees-->
   字句解析 -文字列をトークンツリーのストリームに変換する
- <!--parsing – turn the token trees into an AST-->
   構文解析 -トークンツリーをASTに変換する

<!--The `syntax` crate contains several main players,-->
`syntax` crateにはいくつかの主なプレイヤーが含まれてい`syntax`。

- <!--a [`CodeMap`] for mapping AST nodes to their source code-->
   ASTノードをソースコードにマッピングするための[`CodeMap`]
- <!--the [ast module] contains types corresponding to each AST node-->
   [ast module]は、各ASTノードに対応するタイプが含まれています
- <!--a [`StringReader`] for lexing source code into tokens-->
   ソースコードをトークンに変換するための[`StringReader`]
- <!--the [parser module] and [`Parser`] struct are in charge of actually parsing tokens into AST nodes,-->
   [parser module]と[`Parser`]構造体はトークンを実際にASTノードに構文解析する[`Parser`]、
- <!--and a [visit module] for walking the AST and inspecting or mutating the AST nodes.-->
   ASTを歩いてASTノードを検査または突然変異させる[visit module]とを含む。

<!--The main entrypoint to the parser is via the various `parse_*` functions in the [parser module].-->
パーサへの主なエントリポイントは、[parser module]内のさまざまな`parse_*`関数を使用すること[parser module]。
<!--They let you do things like turn a [`FileMap`][filemap] (eg the source in a single file) into a token stream, create a parser from the token stream, and then execute the parser to get a `Crate` (the root AST node).-->
それらは[`FileMap`][filemap]（例えば単一のファイルのソース）をトークンストリームに変換し、トークンストリームからパーサーを作成し、パーサーを実行して`Crate`（ルートASTノード）を取得するようなことをさせます。

<!--To minimise the amount of copying that is done, both the `StringReader` and `Parser` have lifetimes which bind them to the parent `ParseSess`.-->
実行されるコピーの量を最小限に抑えるために、`StringReader`と`Parser`両方に親`ParseSess`バインドする有効期間があります。
<!--This contains all the information needed while parsing, as well as the `CodeMap` itself.-->
これには、解析中に必要なすべての情報と、`CodeMap`自体が含まれて`CodeMap`ます。

<!--[libsyntax]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/index.html
 [rustc_errors]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/index.html
 [ast]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
 [`CodeMap`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html
 [ast module]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ast/index.html
 [parser module]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/index.html
 [`Parser`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/parser/struct.Parser.html
 [`StringReader`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/lexer/struct.StringReader.html
 [visit module]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/visit/index.html
 [filemap]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.FileMap.html
-->
[libsyntax]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/index.html
 [rustc_errors]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_errors/index.html
 [ast]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
 [`CodeMap`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.CodeMap.html
 [ast module]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ast/index.html
 [parser module]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/index.html
 [`Parser`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/parser/struct.Parser.html
 [`StringReader`]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/parse/lexer/struct.StringReader.html
 [visit module]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/visit/index.html
 [filemap]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/codemap/struct.FileMap.html

