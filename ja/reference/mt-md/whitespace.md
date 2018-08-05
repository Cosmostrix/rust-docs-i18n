# <!--Whitespace--> 空白

<!--Whitespace is any non-empty string containing only characters that have the `Pattern_White_Space` Unicode property, namely:-->
空白は、`Pattern_White_Space` Unicodeプロパティを持つ文字のみを含む空でない文字列です。

- <!--`U+0009` (horizontal tab, `'\t'`)-->
   `U+0009`（水平タブ、 `'\t'`）
- <!--`U+000A` (line feed, `'\n'`)-->
   `U+000A`（改行、 `'\n'`）
- <!--`U+000B` (vertical tab)-->
   `U+000B`（垂直タブ）
- <!--`U+000C` (form feed)-->
   `U+000C`（フォームフィード）
- <!--`U+000D` (carriage return, `'\r'`)-->
   `U+000D`（キャリッジリターン、 `'\r'`）
- <!--`U+0020` (space, `' '`)-->
   `U+0020`（スペース、 `' '`）
- <!--`U+0085` (next line)-->
   `U+0085`（次の行）
- <!--`U+200E` (left-to-right mark)-->
   `U+200E`（左から右のマーク）
- <!--`U+200F` (right-to-left mark)-->
   `U+200F`（右から左のマーク）
- <!--`U+2028` (line separator)-->
   `U+2028`（行区切り記号）
- <!--`U+2029` (paragraph separator)-->
   `U+2029`（段落区切り記号）

<!--Rust is a "free-form"language, meaning that all forms of whitespace serve only to separate  _tokens_  in the grammar, and have no semantic significance.-->
Rustは "自由形式"の言語であり、すべての形式の空白は文法上の _トークン_ を分離 _する_ 役割しか果たしておらず、意味上の意味はありません。

<!--A Rust program has identical meaning if each whitespace element is replaced with any other legal whitespace element, such as a single space character.-->
Rustプログラムは、各空白要素が単一の空白文字などの他の有効な空白要素で置き換えられている場合、同じ意味を持ちます。
