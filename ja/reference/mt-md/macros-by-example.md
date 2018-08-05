# <!--Macros By Example--> 例によるマクロ

<!--`macro_rules` allows users to define syntax extension in a declarative way.-->
`macro_rules`は、ユーザーが宣言的な方法で構文拡張を定義できるようにします。
<!--We call such extensions "macros by example"or simply "macros".-->
このような拡張機能を「マクロを例として」または単に「マクロ」と呼びます。

<!--Currently, macros can expand to expressions, statements, items, or patterns.-->
現在、マクロは式、文、項目、またはパターンに展開できます。

<!--(A `sep_token` is any token other than `*` and `+`. A `non_special_token` is any token other than a delimiter or `$`.)-->
（`sep_token`は、`*`と`+`以外のトークンで、`non_special_token`はデリミタまたは`$`以外のトークンです。）

<!--The macro expander looks up macro invocations by name, and tries each macro rule in turn.-->
マクロエクスパンダはマクロ呼び出しを名前で検索し、各マクロルールを順番に試行します。
<!--It transcribes the first successful match.-->
それは最初の成功したマッチを転写する。
<!--Matching and transcription are closely related to each other, and we will describe them together.-->
マッチングと転写はお互いに密接に関連しており、それらを一緒に説明します。

<!--The macro expander matches and transcribes every token that does not begin with a `$` literally, including delimiters.-->
マクロエクスパンダは、区切り文字を含めて、`$`始まらないすべてのトークンと一致して転記します。
<!--For parsing reasons, delimiters must be balanced, but they are otherwise not special.-->
構文解析の理由から、デリミタはバランスをとる必要がありますが、特殊文字ではありません。

<!--In the matcher, `$`  _name_  `:`  _designator_  matches the nonterminal in the Rust syntax named by  _designator_ .-->
正規表現では、`$`  _name_  `:`  _designator_ は、 _designator_ によって命名されたRust構文の非終端記号と一致します。
<!--Valid designators are:-->
有効な指定子は次のとおりです。

* <!--`item`: an [item]-->
   `item`： [item]
* <!--`block`: a [block]-->
   `block`： [block]
* <!--`stmt`: a [statement]-->
   `stmt`： [statement]
* <!--`pat`: a [pattern]-->
   `pat`： [pattern]
* <!--`expr`: an [expression]-->
   `expr`： [expression]
* <!--`ty`: a [type]-->
   `ty`： [type]
* <!--`ident`: an [identifier] or [keyword]-->
   `ident`： [identifier]または[keyword]
* <!--`path`: a [path]-->
   `path`： [path]
* <!--`tt`: a token tree (a single [token] by matching `()`, `[]`, or `{}`)-->
   `tt`：トークンツリー（ `()`、 `[]`、または`{}`マッチさせた単一の[token]）
* <!--`meta`: the contents of an [attribute]-->
   `meta`： [attribute]の内容
* <!--`lifetime`: a lifetime.-->
   `lifetime`：生涯。
<!--Examples: `'static`, `'a`.-->
   例： `'static` `'a`。

<!--[item]: items.html
 [block]: expressions/block-expr.html
 [statement]: statements.html
 [pattern]: expressions/match-expr.html
 [expression]: expressions.html
 [type]: types.html
 [identifier]: identifiers.html
 [keyword]: keywords.html
 [path]: paths.html
 [token]: tokens.html
 [attribute]: attributes.html
-->
[item]: items.html
 [block]: expressions/block-expr.html
 [statement]: statements.html
 [pattern]: expressions/match-expr.html
 [expression]: expressions.html
 [type]: types.html
 [identifier]: identifiers.html
 [keyword]: keywords.html
 [path]: paths.html
 [token]: tokens.html
 [attribute]: attributes.html


<!--In the transcriber, the designator is already known, and so only the name of a matched nonterminal comes after the dollar sign.-->
転記者では、指定子は既に知られているので、一致した非終端記号の名前だけがドル記号の後に来る。

<!--In both the matcher and transcriber, the Kleene star-like operator indicates repetition.-->
マッチャーと転記者の両方で、Kleeneの星のような演算子は反復を示します。
<!--The Kleene star operator consists of `$` and parentheses, optionally followed by a separator token, followed by `*` or `+`.-->
Kleeneのスター演算子は`$`と括弧で構成され、任意にセパレータトークンが続き、`*`または`+`続きます。
<!--`*` means zero or more repetitions, `+` means at least one repetition.-->
`*`は0回以上の繰り返しを意味し、`+`は少なくとも1回の繰り返しを意味します。
<!--The parentheses are not matched or transcribed.-->
かっこは一致しないか転写されません。
<!--On the matcher side, a name is bound to  _all_  of the names it matches, in a structure that mimics the structure of the repetition encountered on a successful match.-->
マッチャー側では、一致する _すべての_ 名前に名前が結び付けられ _ます_ 。これは、正常に一致したときに遭遇する繰り返しの構造を模倣した構造です。
<!--The job of the transcriber is to sort that structure out.-->
転記者の仕事は、その構造を整理することです。

<!--The rules for transcription of these repetitions are called "Macro By Example".-->
これらの繰り返しの転写の規則は、「マクロバイケース」と呼ばれます。
<!--Essentially, one "layer"of repetition is discharged at a time, and all of them must be discharged by the time a name is transcribed.-->
本質的に、繰り返しの1つの「レイヤー」は一度に排出され、名前はすべて転記されるまでに排出されなければなりません。
<!--Therefore, `( $( $i:ident ),* ) => ( $i )` is an invalid macro, but `( $( $i:ident ),* ) => ( $( $i:ident ),* )` is acceptable (if trivial).-->
したがって、`( $( $i:ident ),* ) => ( $i )`は無効なマクロですが、`( $( $i:ident ),* ) => ( $( $i:ident ),* )`許容される（些細であれば）。

<!--When Macro By Example encounters a repetition, it examines all of the `$`  _name_  s that occur in its body.-->
Example by Macroは繰り返しに遭遇すると、本体にある`$`  _name_ すべてを調べます。
<!--At the "current layer", they all must repeat the same number of times, so `( $( $i:ident ),* ; $( $j:ident ),* ) => ( $( ($i,$j) ),* )` is valid if given the argument `(a,b,c ; d,e,f)`, but not `(a,b,c ; d,e)`.-->
"現在のレイヤー"では、それらはすべて同じ回数繰り返さなければならないので、`( $( $i:ident ),* ; $( $j:ident ),* ) => ( $( ($i,$j) ),* )`は、`(a,b,c ; d,e,f)`ではなく、`(a,b,c ; d,e)`場合に有効です。
<!--The repetition walks through the choices at that layer in lockstep, so the former input transcribes to `(a,d), (b,e), (c,f)`.-->
その反復はロックステップでその層の選択肢を歩き回り、前者の入力は`(a,d), (b,e), (c,f)`転記される。

<!--Nested repetitions are allowed.-->
ネストされた繰り返しが許可されます。

### <!--Parsing limitations--> 解析の制限

<!--The parser used by the macro system is reasonably powerful, but the parsing of Rust syntax is restricted in two ways:-->
マクロシステムで使用されるパーサーはかなり強力ですが、Rust構文の構文解析には2通りの制限があります。

1. <!--Macro definitions are required to include suitable separators after parsing expressions and other bits of the Rust grammar.-->
    マクロ定義には、式やRust文法の他のビットを解析した後に、適切な区切り文字を含める必要があります。
<!--This implies that a macro definition like `$i:expr [ , ]` is not legal, because `[` could be part of an expression.-->
    これは、`$i:expr [ , ]`ようなマクロ定義は、`[`式の一部である可能性があるためです。
<!--A macro definition like `$i:expr,` or `$i:expr;`-->
    `$i:expr,`や`$i:expr;`ようなマクロ定義`$i:expr;`
<!--would be legal, however, because `,` and `;`-->
    しかし、法的になりますので`,`と`;`
<!--are legal separators.-->
    法的な区切り文字です。
<!--See [RFC 550] for more information.-->
    詳細については、[RFC 550]を参照してください。
2. <!--The parser must have eliminated all ambiguity by the time it reaches a `$`  _name_  `:`  _designator_ .-->
    パーサは、`$`  _name_  `:`  _指定子に_ 達するまでにすべてのあいまいさを解消していなければなりません。
<!--This requirement most often affects name-designator pairs when they occur at the beginning of, or immediately after, a `$(...)*`;-->
    この要件は、`$(...)*`の開始時または直後に名前指定子のペアが発生するときに最も頻繁に影響します。
<!--requiring a distinctive token in front can solve the problem.-->
    先に特有のトークンを要求することで問題を解決できます。

[RFC 550]: https://github.com/rust-lang/rfcs/blob/master/text/0550-macro-future-proofing.md
