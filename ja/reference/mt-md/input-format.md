# <!--Input format--> 入力形式

<!--Rust input is interpreted as a sequence of Unicode code points encoded in UTF-8.-->
錆の入力は、UTF-8でエンコードされた一連のUnicodeコードポイントとして解釈されます。
<!--Most Rust grammar rules are defined in terms of printable ASCII-range code points, but a small number are defined in terms of Unicode properties or explicit code point lists.-->
ほとんどのRust文法ルールは、印刷可能なASCII範囲のコードポイントで定義されますが、少数はUnicodeプロパティまたは明示的なコードポイントリストの観点から定義されます。
[^inputformat]
[^inputformat]: Substitute%20definitions%20for%20the%20special%20Unicode%20productions%20are
<!--provided to the grammar verifier, restricted to ASCII range, when verifying the grammar in this document.-->
本書の文法を検証する際に、ASCII範囲に制限された文法検証者に提供されます。
