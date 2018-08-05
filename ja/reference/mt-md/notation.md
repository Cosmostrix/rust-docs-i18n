# <!--Notation--> 記法

## <!--Unicode productions--> Unicodeプロダクション

<!--A few productions in Rust's grammar permit Unicode code points outside the ASCII range.-->
Rustの文法のいくつかのプロダクションでは、UnicodeコードがASCII範囲を超えています。
<!--We define these productions in terms of character properties specified in the Unicode standard, rather than in terms of ASCII-range code points.-->
これらのプロダクションは、ASCII範囲のコードポイントではなく、Unicode標準で指定された文字プロパティの観点から定義します。
<!--The grammar has a [Special Unicode Productions] section that lists these productions.-->
文法には、これらの作品をリストアップする[Special Unicode Productions]セクションがあります。

## <!--String table productions--> 文字列テーブルのプロダクション

<!--Some rules in the grammar &mdash;-->
文法のいくつかのルール
<!--notably [unary operators], [binary operators], and [keywords] &mdash;-->
特に[unary operators]、 [binary operators]、 [keywords]などがあります。
<!--are given in a simplified form: as a listing of printable strings.-->
印刷可能な文字列のリストとして単純化された形式で与えられます。
<!--These cases form a subset of the rules regarding the [token][tokens] rule, and are assumed to be the result of a lexical-analysis phase feeding the parser, driven by a RawInline (Format "html") "<abbr title=\"\27770\23450\35542\30340\26377\38480\12458\12540\12488\12510\12488\12531\">"DFARawInline (Format "html") "</abbr>", operating over the disjunction of all such string table entries.-->
これらのケースは、[token][tokens]ルールに関するルールのサブセットを形成し、RawInline (Format "html") "<abbr title=\"\27770\23450\35542\30340\26377\38480\12458\12540\12488\12510\12488\12531\">"DFARawInline (Format "html") "</abbr>"によって駆動される、パーサーに与える語彙分析フェーズの結果であり、そのようなすべての文字列テーブル項目の論理和を操作していると仮定されます。

<!--When such a string in `monospace` font occurs inside the grammar, it is an implicit reference to a single member of such a string table production.-->
`monospace`フォントのこのような文字列が文法の内部で発生した場合、このような文字列テーブル生成の単一メンバーへの暗黙の参照になります。
<!--See [tokens] for more information.-->
詳細は、[tokens]を参照してください。

<!--[Special Unicode Productions]: ../grammar.html#special-unicode-productions
 [binary operators]: expressions/operator-expr.html#arithmetic-and-logical-binary-operators
 [keywords]: keywords.html
 [tokens]: tokens.html
 [unary operators]: expressions/operator-expr.html#borrow-operators
-->
[Special Unicode Productions]: ../grammar.html#special-unicode-productions
 [binary operators]: expressions/operator-expr.html#arithmetic-and-logical-binary-operators
 [keywords]: keywords.html
 [tokens]: tokens.html
 [unary operators]: expressions/operator-expr.html#borrow-operators

