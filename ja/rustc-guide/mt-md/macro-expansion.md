# <!--Macro expansion--> マクロ展開

<!--Macro expansion happens during parsing.-->
マクロ展開は解析中に行われます。
<!--`rustc` has two parsers, in fact: the normal Rust parser, and the macro parser.-->
`rustc`は実際には2つのパーサがあります。通常のRustパーサとマクロパーサです。
<!--During the parsing phase, the normal Rust parser will set aside the contents of macros and their invocations.-->
解析段階では、通常のRustパーサーはマクロとその呼び出しの内容を脇に置いています。
<!--Later, before name resolution, macros are expanded using these portions of the code.-->
後で、名前解決の前に、これらのコード部分を使用してマクロが展開されます。
<!--The macro parser, in turn, may call the normal Rust parser when it needs to bind a metavariable (eg `$my_expr`) while parsing the contents of a macro invocation.-->
マクロパーサは、マクロ呼び出しの内容を解析中に`$my_expr`変数（例えば`$my_expr`）をバインドする必要がある場合、通常のRustパーサーを呼び出すことができます。
<!--The code for macro expansion is in [`src/libsyntax/ext/tt/`][code_dir].-->
マクロ展開のためのコードは[`src/libsyntax/ext/tt/`][code_dir]ます。
<!--This chapter aims to explain how macro expansion works.-->
この章では、マクロ展開のしくみについて説明します。

### <!--Example--> 例

<!--It's helpful to have an example to refer to.-->
参照する例があると便利です。
<!--For the remainder of this chapter, whenever we refer to the "example  _definition_  ", we mean the following:-->
この章の残りの部分では、「サンプル _定義_  」を参照するときはいつでも、次のことを意味します。

```rust,ignore
macro_rules! printer {
    (print $mvar:ident) => {
        println!("{}", $mvar);
    }
    (print twice $mvar:ident) => {
        println!("{}", $mvar);
        println!("{}", $mvar);
    }
}
```

<!--`$mvar` is called a  _metavariable_ .-->
`$mvar`  _メタ変数_ と呼ばれています。
<!--Unlike normal variables, rather than binding to a value in a computation, a metavariable binds  _at compile time_  to a tree of  _tokens_ .-->
通常の変数とは異なり、計算の値にバインドするのではなく、メタ変数は _コンパイル時_ に _トークンの_ ツリーにバインドさ _れます_ 。
<!--A  _token_  is a single "unit"of the grammar, such as an identifier (eg `foo`) or punctuation (eg `=>`).-->
 _トークン_ は、識別子（例えば、`foo`）または句読点（例えば、 `=>`）のような、文法の単一の「単位」である。
<!--There are also other special tokens, such as `EOF`, which indicates that there are no more tokens.-->
さらにトークンがないことを示す`EOF`などの特別なトークンもあります。
<!--Token trees resulting from paired parentheses-like characters (`(`... `)`, `[`... `]`, and `{`... `}`) – they include the open and close and all the tokens in between (we do require that parentheses-like characters be balanced).-->
`(`... `)`、 `[`... `]`、および`{`... `}`）の対になったトークンツリー -それらには開閉とすべてのトークンが含まれています（カッコのような文字をバランスさせる）。
<!--Having macro expansion operate on token streams rather than the raw bytes of a source file abstracts away a lot of complexity.-->
マクロ展開がソースファイルの生のバイトではなくトークンストリームで動作することは、多くの複雑さを抽象化します。
<!--The macro expander (and much of the rest of the compiler) doesn't really care that much about the exact line and column of some syntactic construct in the code;-->
マクロエキスパンダー（およびその他の多くのコンパイラ）は、コード内の構文構造の正確な行と列についてはそれほど気にしません。
<!--it cares about what constructs are used in the code.-->
コード内でどのような構文が使用されているかが気になります。
<!--Using tokens allows us to care about  _what_  without worrying about  _where_ .-->
トークンを使用することで、 _どこ_ を気にせずに気にすること _ができ_ ます。
<!--For more information about tokens, see the [Parsing][parsing] chapter of this book.-->
トークンの詳細については、この[Parsing][parsing] 「 [Parsing][parsing]章を参照してください。

<!--Whenever we refer to the "example  _invocation_  ", we mean the following snippet:-->
「サンプル _呼び出し_  」を参照するたびに、次のスニペットを意味します。

```rust,ignore
#//printer!(print foo); // Assume `foo` is a variable defined somewhere else...
printer!(print foo); //  `foo`は他のどこかで定義された変数であると仮定します...
```

<!--The process of expanding the macro invocation into the syntax tree `println!("{}", foo)` and then expanding that into a call to `Display::fmt` is called  _macro expansion_ , and it is the topic of this chapter.-->
マクロ呼び出しを構文木`println!("{}", foo)`に展開し、それを`Display::fmt`呼び出しに展開するプロセスは、 _マクロ展開_ と呼ばれ、この章のトピックです。

### <!--The macro parser--> マクロパーサー

<!--There are two parts to macro expansion: parsing the definition and parsing the invocations.-->
マクロ拡張には、定義の解析と呼び出しの解析という2つの部分があります。
<!--Interestingly, both are done by the macro parser.-->
興味深いことに、両方ともマクロパーサによって行われます。

<!--Basically, the macro parser is like an NFA-based regex parser.-->
基本的には、マクロパーサはNFAベースの正規表現パーサーのようなものです。
<!--It uses an algorithm similar in spirit to the [Earley parsing algorithm](https://en.wikipedia.org/wiki/Earley_parser).-->
これは、[Earley構文解析アルゴリズム](https://en.wikipedia.org/wiki/Earley_parser)と似たアルゴリズムを使用し[ます](https://en.wikipedia.org/wiki/Earley_parser)。
<!--The macro parser is defined in [`src/libsyntax/ext/tt/macro_parser.rs`][code_mp].-->
マクロパーサは、[`src/libsyntax/ext/tt/macro_parser.rs`][code_mp]定義されています。

<!--The interface of the macro parser is as follows (this is slightly simplified):-->
マクロパーサのインタフェースは次のとおりです（これは少し簡略化されています）：

```rust,ignore
fn parse(
    sess: ParserSession,
    tts: TokenStream,
    ms: &[TokenTree]
) -> NamedParseResult
```

<!--In this interface:-->
このインタフェースでは、

- <!--`sess` is a "parsing session", which keeps track of some metadata.-->
   `sess`は「解析セッション」で、メタデータを追跡します。
<!--Most notably, this is used to keep track of errors that are generated so they can be reported to the user.-->
   特に、生成されたエラーを追跡してユーザーに報告できるようにするために使用されます。
- <!--`tts` is a stream of tokens.-->
   `tts`はトークンのストリームです。
<!--The macro parser's job is to consume the raw stream of tokens and output a binding of metavariables to corresponding token trees.-->
   マクロパーサの仕事は、トークンの生ストリームを消費し、メタ変数の対応するトークンツリーへのバインディングを出力することです。
- <!--`ms` a  _matcher_ .-->
   `ms`  _マッチャー_ 。
<!--This is a sequence of token trees that we want to match `tts` against.-->
   これは、`tts`と照合したいトークンツリーのシーケンスです。

<!--In the analogy of a regex parser, `tts` is the input and we are matching it against the pattern `ms`.-->
正規表現パーサの類推では、`tts`は入力であり、パターン`ms`と一致しています。
<!--Using our examples, `tts` could be the stream of tokens containing the inside of the example invocation `print foo`, while `ms` might be the sequence of token (trees) `print $mvar:ident`.-->
私たちの例を使って、`tts`は、例の`print foo`内部を含むトークンのストリームであり、`ms`はトークン（ツリー）`print $mvar:ident`のシーケンスかもしれません。

<!--The output of the parser is a `NamedParseResult`, which indicates which of three cases has occured:-->
パーサーの出力は`NamedParseResult`、3つのケースのどれが発生したかを示します。

- <!--Success: `tts` matches the given matcher `ms`, and we have produced a binding from metavariables to the corresponding token trees.-->
   成功： `tts`は与えられたマッチャー`ms`と一致し、メタ変数から対応するトークンツリーへのバインディングを生成しました。
- <!--Failure: `tts` does not match `ms`.-->
   失敗： `tts`は`ms`一致しません。
<!--This results in an error message such as "No rule expected token  _blah_  ".-->
   この結果、「No rule expected token  _blah_  」のようなエラーメッセージが表示されます。
- <!--Error: some fatal error has occured  _in the parser_ .-->
   エラー：  _パーサで_ 致命的なエラーが発生 _し_ まし _た_ 。
<!--For example, this happens if there are more than one pattern match, since that indicates the macro is ambiguous.-->
   たとえば、複数のパターンマッチがある場合は、マクロがあいまいであることを示します。

<!--The full interface is defined [here][code_parse_int].-->
完全なインタフェースが[here][code_parse_int]で定義されてい[here][code_parse_int]。

<!--The macro parser does pretty much exactly the same as a normal regex parser with one exception: in order to parse different types of metavariables, such as `ident`, `block`, `expr`, etc., the macro parser must sometimes call back to the normal Rust parser.-->
マクロパーサーは`ident`、 `block`、 `expr`などのさまざまな種類のメタ変数を解析するために、通常の正規表現パーサと同じように動作します。。

<!--As mentioned above, both definitions and invocations of macros are parsed using the macro parser.-->
前述のように、マクロの定義と呼び出しは、マクロパーサーを使用して解析されます。
<!--This is extremely non-intuitive and self-referential.-->
これは非常に非直感的で自己参照的です。
<!--The code to parse macro  _definitions_  is in [`src/libsyntax/ext/tt/macro_rules.rs`][code_mr].-->
マクロ _定義_ を解析するコードは、[`src/libsyntax/ext/tt/macro_rules.rs`][code_mr]ます。
<!--It defines the pattern for matching for a macro definition as `$( $lhs:tt => $rhs:tt );+`.-->
これは、`$( $lhs:tt => $rhs:tt );+`マクロ定義の一致パターンを定義し`$( $lhs:tt => $rhs:tt );+`。
<!--In other words, a `macro_rules` defintion should have in its body at least one occurence of a token tree followed by `=>` followed by another token tree.-->
言い換えれば、`macro_rules`定義は、本体に少なくとも1つのトークンツリーの出現があり、その後に`=>`続き、別のトークンツリーが続くはずです。
<!--When the compiler comes to a `macro_rules` definition, it uses this pattern to match the two token trees per rule in the definition of the macro  _using the macro parser itself_ .-->
コンパイラが`macro_rules`定義に来ると、このパターンを使用して、このパターンを _使用して、マクロパーサ自体を使用して_ 、マクロ定義内のルールごとに2つのトークンツリーを照合します。
<!--In our example definition, the metavariable `$lhs` would match the patterns of both arms: `(print $mvar:ident)` and `(print twice $mvar:ident)`.-->
この例の定義では、メタ`$lhs`は、`(print $mvar:ident)`と`(print twice $mvar:ident)` `(print $mvar:ident)`両方のパターンのパターンと一致します。
<!--And `$rhs` would match the bodies of both arms: `{ println!("{}", $mvar); }`-->
そして、`$rhs`は両腕のボディにマッチします： `{ println!("{}", $mvar); }`
<!--`{ println!("{}", $mvar); }` and `{ println!("{}", $mvar); println!("{}", $mvar); }`-->
`{ println!("{}", $mvar); }`と`{ println!("{}", $mvar); println!("{}", $mvar); }`
`{ println!("{}", $mvar); println!("{}", $mvar); }` <!--`{ println!("{}", $mvar); println!("{}", $mvar); }`.-->
`{ println!("{}", $mvar); println!("{}", $mvar); }`。
<!--The parser would keep this knowledge around for when it needs to expand a macro invocation.-->
パーサは、マクロ呼び出しを拡張する必要があるときに、この知識を保持します。

<!--When the compiler comes to a macro invocation, it parses that invocation using the same NFA-based macro parser that is described above.-->
コンパイラがマクロ呼び出しになると、コンパイラは上記の同じNFAベースのマクロパーサを使用してその呼び出しを解析します。
<!--However, the matcher used is the first token tree (`$lhs`) extracted from the arms of the macro  _definition_ .-->
しかし、使用されるマッチャーは、マクロ _定義の_ アームから抽出された最初のトークンツリー（`$lhs`）です。
<!--Using our example, we would try to match the token stream `print foo` from the invocation against the matchers `print $mvar:ident` and `print twice $mvar:ident` that we previously extracted from the definition.-->
この例では、呼び出し元の`print foo`のトークンストリームを、`print $mvar:ident`というマッチャーの`print $mvar:ident`とマッチさせようとします。そして、定義から前に抽出した`print twice $mvar:ident`を行います。
<!--The algorithm is exactly the same, but when the macro parser comes to a place in the current matcher where it needs to match a  _non-terminal_  (eg `$mvar:ident`), it calls back to the normal Rust parser to get the contents of that non-terminal.-->
アルゴリズムはまったく同じですが、マクロパーサーは _、非末端と_ 一致する必要 _が_ あり、現在のマッチャー内の場所（例えばに来るとき`$mvar:ident`）、それはの内容を取得するために、通常の錆パーサーにコールバックしますその非終端。
<!--In this case, the Rust parser would look for an `ident` token, which it finds (`foo`) and returns to the macro parser.-->
この場合、Rustパーサーは`ident`トークンを探し、それを見つけ（`foo`）、マクロパーサに返します。
<!--Then, the macro parser proceeds in parsing as normal.-->
次に、マクロパーサは通常通り解析を続けます。
<!--Also, note that exactly one of the matchers from the various arms should match the invocation;-->
また、さまざまな武器のマッチャーのうちの1つが呼び出しに一致する必要があります。
<!--if there is more than one match, the parse is ambiguous, while if there are no matches at all, there is a syntax error.-->
複数の一致がある場合は解析があいまいで、一致が全くない場合は構文エラーがあります。

<!--For more information about the macro parser's implementation, see the comments in [`src/libsyntax/ext/tt/macro_parser.rs`][code_mp].-->
マクロパーサの実装の詳細については、[`src/libsyntax/ext/tt/macro_parser.rs`][code_mp]のコメントを参照してください。

### <!--Hygiene--> 衛生

<!--If you have ever used C/C++ preprocessor macros, you know that there are some annoying and hard-to-debug gotchas!-->
これまでにC / C ++プリプロセッサマクロを使用したことがある人は、厄介で難しい問題があることを知っています。
<!--For example, consider the following C code:-->
たとえば、次のCコードを考えてみましょう。

```c
#define DEFINE_FOO struct Bar {int x;}; struct Foo {Bar bar;};

#// Then, somewhere else
// 次に、他のどこか
struct Bar {
    ...
};

DEFINE_FOO
```

<!--Most people avoid writing C like this – and for good reason: it doesn't compile.-->
ほとんどの人はこのようにCを書くのを避けます。正当な理由でそれはコンパイルされません。
<!--The `struct Bar` defined by the macro clashes names with the `struct Bar` defined in the code.-->
`struct Bar`でマクロ衝突名で定義された`struct Bar`コードで定義されています。
<!--Consider also the following example:-->
以下の例も考慮してください。

```c
#define DO_FOO(x) {\
    int y = 0;\
    foo(x, y);\
    }

#// Then elsewhere
// それ以外の場所
int y = 22;
DO_FOO(y);
```

<!--Do you see the problem?-->
あなたは問題が見えますか？
<!--We wanted to generate a call `foo(22, 0)`, but instead we got `foo(0, 0)` because the macro defined its own `y`!-->
私たちは、コール生成したかった`foo(22, 0)`が、代わりに我々は持っ`foo(0, 0)`マクロは、独自の定義されたので、`y`！

<!--These are both examples of  _macro hygiene_  issues.-->
これらは両方とも _マクロ衛生_ 問題の例です。
<!-- _Hygiene_  relates to how to handle names defined  _within a macro_ .-->
 _衛生_   _は、マクロ内で_ 定義さ _れた_ 名前を処理する方法に関連しています。
<!--In particular, a hygienic macro system prevents errors due to names introduced within a macro.-->
特に、衛生的なマクロシステムは、マクロ内に導入された名前によるエラーを防ぎます。
<!--Rust macros are hygienic in that they do not allow one to write the sorts of bugs above.-->
Rustマクロは、上のような種類のバグを書くことができないという点で衛生的です。

<!--At a high level, hygiene within the rust compiler is accomplished by keeping track of the context where a name is introduced and used.-->
高レベルでは、rustコンパイラ内の衛生は、名前が導入され使用されるコンテキストを追跡することによって達成されます。
<!--We can then disambiguate names based on that context.-->
そのコンテキストに基づいて名前を明確にすることができます。
<!--Future iterations of the macro system will allow greater control to the macro author to use that context.-->
マクロシステムの今後の反復は、マクロ作成者がそのコンテキストを使用するように制御することを可能にする。
<!--For example, a macro author may want to introduce a new name to the context where the macro was called.-->
たとえば、マクロ作成者は、マクロが呼び出されたコンテキストに新しい名前を導入することができます。
<!--Alternately, the macro author may be defining a variable for use only within the macro (ie it should not be visible outside the macro).-->
あるいは、マクロ作成者は、マクロ内でのみ使用する変数を定義している可能性があります（つまり、マクロの外側には表示しないでください）。

<!--In rustc, this "context"is tracked via `Span` s.-->
rustcでは、この「コンテキスト」は`Span`によって追跡されます。

<!--TODO: what is call-site hygiene?-->
TODO：コールサイト衛生とは何ですか？
<!--what is def-site hygiene?-->
デフサイト衛生とは何ですか？

<!--TODO-->
TODO

### <!--Procedural Macros--> 手続き型マクロ

<!--TODO-->
TODO

### <!--Custom Derive--> カスタム作成

<!--TODO-->
TODO

<!--TODO: maybe something about macros 2.0?-->
TODO：マクロ2.0についての何か？


<!--[code_dir]: https://github.com/rust-lang/rust/tree/master/src/libsyntax/ext/tt
 [code_mp]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ext/tt/macro_parser/
 [code_mr]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ext/tt/macro_rules/
 [code_parse_int]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ext/tt/macro_parser/fn.parse.html
 [parsing]: ./the-parser.html
-->
[code_dir]: https://github.com/rust-lang/rust/tree/master/src/libsyntax/ext/tt
 [code_mp]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ext/tt/macro_parser/
 [code_mr]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ext/tt/macro_rules/
 [code_parse_int]: https://doc.rust-lang.org/nightly/nightly-rustc/syntax/ext/tt/macro_parser/fn.parse.html
 [parsing]: ./the-parser.html

