# <!--`match` expressions--> `match`式

> <!--**<sup>Syntax</sup>** \  _MatchExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _MatchExpression_ ：\＆nbsp;＆nbsp;
> <!--`match` [_Expression_] Subscript [Strikeout [Str "except",Space,Str "struct",Space,Str "expression"]] `{` \ &nbsp;&nbsp;-->
> `match` [_Expression_] Subscript [Strikeout [Str "\27083\36896\20307\34920\29694\12434\38500\12367"]] `{` ＆NBSP; \＆NBSP;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[_InnerAttribute_]  __\ *</sup>\ &nbsp;&nbsp;*__ -->
> [_InnerAttribute_]  __\ *</ sup> \＆nbsp;＆nbsp;*__ 
> <!-- __*&nbsp;&nbsp;*__ -->
>  __*＆nbsp;＆nbsp;*__ 
> <!-- __*_MatchArms_<sup>?</sup>\ &nbsp;&nbsp;*__ -->
>  __*_MatchArms_ <sup>？</ sup> \＆nbsp;＆nbsp;*__ 
> <!-- __*`}` _MatchArms_:\ &nbsp;&nbsp;*__ -->
>  __*`}` _MatchArms_：\＆nbsp;＆nbsp;*__ 
> <!-- __*(_MatchArm_ `=>` ([_BlockExpression_] `,`<sup>?</sup> | [_Expression_] `,`))<sup>\*__  \ &nbsp;&nbsp;-->
>  __*（_MatchArm_ `=>`（[_BlockExpression_] `、` <sup>？</ sup> | [_Expression_] `、））<sup> \*__  \＆nbsp;
> <!-- _MatchArm_  `=>` ([_BlockExpression_] | [_Expression_]) `,`  __?__ -->
>  _MatchArm_  `=>` [_BlockExpression_] | [_Expression_]） `,`  __？__ 
> 
> <!-- _MatchArm_ :\ &nbsp;&nbsp;-->
>  _MatchArm_ ：\＆nbsp;＆nbsp;
> <!--[_OuterAttribute_]  __\ *</sup> _MatchArmPatterns_ _MatchArmGuard_<sup>?</sup> _MatchArmPatterns_:\ &nbsp;&nbsp;*__ -->
> [_OuterAttribute_]  __\ *</ sup> _MatchArmPatterns_ _MatchArmGuard_ <sup>？</ sup> _MatchArmPatterns_：\＆nbsp;＆nbsp;*__ 
> <!-- __*`|`<sup>?</sup> _Pattern_ (`|` _Pattern_)<sup>\*__ -->
>  __*`|` <sup>？</ sup> _Pattern_（`|` _Pattern_）<sup> \*__ 
> 
> <!-- _MatchArmGuard_ :\ &nbsp;&nbsp;-->
>  _MatchArmGuard_ ：\＆nbsp;＆nbsp;
> <!--`if` [_Expression_]-->
> [_Expression_] `if`

<!--A `match` expression branches on a *pattern*.-->
`match`式は*パターンに*分岐し*ます*。
<!--The exact form of matching that occurs depends on the pattern.-->
発生するマッチングの正確な形式は、パターンによって異なります。
<!--Patterns consist of some combination of literals, destructured arrays or enum constructors, structs and tuples, variable binding specifications, wildcards (`..`), and placeholders (`_`).-->
パターンは、リテラル、構造化配列または列挙コンストラクタ、構造体およびタプル、可変バインディング仕様、ワイルドカード（`..`）、およびプレースホルダ（ `_`）のいくつかの組み合わせで構成されます。
<!--A `match` expression has a *head expression*, which is the value to compare to the patterns.-->
`match`式には*ヘッド式があり*、これはパターンと比較する値です。
<!--The type of the patterns must equal the type of the head expression.-->
パターンのタイプは、頭部表現のタイプと等しくなければならない。

<!--A `match` behaves differently depending on whether or not the head expression is a [place expression or value expression][place%20expression].-->
`match`は、先頭の式が[プレース・エクスプレッションか値式][place%20expression]かによって異なる動作をし[ます][place%20expression]。
<!--If the head expression is a [value expression], it is first evaluated into a temporary location, and the resulting value is sequentially compared to the patterns in the arms until a match is found.-->
先頭の式が[value expression]である場合、最初に一時的な位置に評価され、結果の値は、一致が見つかるまで、連続してアームのパターンと比較されます。
<!--The first arm with a matching pattern is chosen as the branch target of the `match`, any variables bound by the pattern are assigned to local variables in the arm's block, and control enters the block.-->
マッチングパターンを有する第一のアームはの分岐先として選択される`match`パターンにより結合した任意の変数は、アームのブロック内のローカル変数に代入され、そして制御はブロックに入ります。

<!--When the head expression is a [place expression], the match does not allocate a temporary location;-->
先頭の式が[place expression]場合、マッチングは一時的なロケーションを割り当てません。
<!--however, a by-value binding may copy or move from the memory location.-->
ただし、値渡しのバインディングは、メモリ位置からコピーまたは移動することがあります。
<!--When possible, it is preferable to match on place expressions, as the lifetime of these matches inherits the lifetime of the place expression rather than being restricted to the inside of the match.-->
可能な場合は、これらの一致の存続期間が一致の内部に限定されるのではなく、プレース表現の存続期間を継承するので、プレース・エクスプレッションをマッチさせることが望ましいです。

<!--An example of a `match` expression:-->
`match`式の例：

```rust
let x = 1;

match x {
    1 => println!("one"),
    2 => println!("two"),
    3 => println!("three"),
    4 => println!("four"),
    5 => println!("five"),
    _ => println!("something else"),
}
```

<!--Patterns that bind variables default to binding to a copy or move of the matched value (depending on the matched value's type).-->
変数をバインドするパターンは、デフォルトでは一致した値のコピーまたは移動にバインドされます（一致した値の型によって異なります）。
<!--This can be changed to bind to a reference by using the `ref` keyword, or to a mutable reference using `ref mut`.-->
これは、`ref`キーワードを使用して参照にバインドするか、`ref mut`を使用して変更可能な参照に変更することができます。

<!--Patterns can be used to *destructure* structs, enums, and tuples.-->
パターンは、構造体、列挙型、およびタプルを*破棄*するために使用できます。
<!--Destructuring breaks a value up into its component pieces.-->
破壊は、値をその構成要素に分解します。
<!--The syntax used is the same as when creating such values.-->
使用される構文は、そのような値を作成する場合と同じです。
<!--When destructing a data structure with named (but not numbered) fields, it is allowed to write `fieldname` as a shorthand for `fieldname: fieldname`.-->
名前の（しかし、番号なし）フィールドを持つデータ構造を破壊すると、書き込みを許可された`fieldname`の省略形として`fieldname: fieldname`。
<!--In a pattern whose head expression has a `struct`, `enum` or `tupl` type, a placeholder (`_`) stands for a *single* data field, whereas a wildcard `..` stands for *all* the fields of a particular variant.-->
head式が`struct`、 `enum`または`tupl`型のパターンでは、プレースホルダ（`_`）は*単一の*データフィールドを表し、ワイルドカードは特定のバリアントの*すべて*のフィールドを表し`..`。

```rust
# enum Message {
#     Quit,
#     WriteString(String),
#     Move { x: i32, y: i32 },
#     ChangeColor(u8, u8, u8),
# }
# let message = Message::Quit;
match message {
    Message::Quit => println!("Quit"),
    Message::WriteString(write) => println!("{}", &write),
    Message::Move{ x, y: 0 } => println!("move {} horizontally", x),
    Message::Move{ .. } => println!("other move"),
    Message::ChangeColor { 0: red, 1: green, 2: _ } => {
        println!("color change, red: {}, green: {}", red, green);
    }
};
```

<!--Patterns can also dereference pointers by using the `&`, `&mut` and `box` symbols, as appropriate.-->
パターンは、必要に応じて、`&`、 `&mut`、 `box`シンボルを使用してポインタを逆参照することもできます。
<!--For example, these two matches on `x: &i32` are equivalent:-->
たとえば、`x: &i32`これらの2つの一致は同じです：

```rust
# let x = &3;
let y = match *x { 0 => "zero", _ => "some" };
let z = match x { &0 => "zero", _ => "some" };

assert_eq!(y, z);
```

<!--Subpatterns can also be bound to variables by the use of the syntax `variable @ subpattern`.-->
サブパターンは、`variable @ subpattern`という構文`variable @ subpattern`使用して変数にバインドすることもできます。
<!--For example:-->
例えば：

```rust
let x = 1;

match x {
    e @ 1 ... 5 => println!("got a range element {}", e),
    _ => println!("anything"),
}
```

<!--Multiple match patterns may be joined with the `|`-->
複数の一致パターンを`|`
<!--operator.-->
オペレーター。
<!--An inclusive range of values may be specified with `..=`.-->
包括的な値の範囲は`..=`で指定することができます。
<!--For example:-->
例えば：

```rust
# let x = 9;
let message = match x {
    0 | 1  => "not many",
    2 ..= 9 => "a few",
    _      => "lots"
};

assert_eq!(message, "a few");
```

<!--Other forms of [range] \(`..` for an exclusive range, or any range with one or both endpoints left unspecified) are not supported in matches.-->
他の形式の[range] \（`..`は排他的範囲、またはいずれか一方または両方の端点が指定されていない範囲）はマッチではサポートされていません。
<!--The syntax `...` is also accepted for inclusive ranges in patterns only, for backwards compatibility.-->
構文`...`は、下位互換性のために、パターン内の包括的範囲に対してのみ受け入れられます。

<!--Range patterns only work [`char`] and [numeric types].-->
範囲パターンは[`char`]と[numeric types]だけを[`char`] [numeric types]。
<!--A range pattern may not be a sub-range of another range pattern inside the same `match`.-->
範囲パターンは、同じ`match`内の別の範囲パターンのサブレンジではない場合があります。

<!--Slice patterns can match both arrays of fixed size and slices of dynamic size.-->
スライスパターンは、固定サイズの配列と動的サイズのスライスの両方に一致します。
<!--` ``rust // Fixed size let arr = [1, 2, 3]; match arr { [1, _, _] => "starts with one", [a, b, c] => "starts with something else", };``-->
` ``rust // Fixed size let arr = [1, 2, 3]; match arr { [1, _, _] => "starts with one", [a, b, c] => "starts with something else", };``
``rust // Fixed size let arr = [1, 2, 3]; match arr { [1, _, _] => "starts with one", [a, b, c] => "starts with something else", };`` <!--` ` ``rust // Dynamic size let v = vec![1, 2, 3]; match v[..] { [a, b] => { /* this arm will not apply because the length doesn't match */ } [a, b, c] => { /* this arm will apply */ } _ => { /* this wildcard is required, since we don't know length statically */ } }``-->
`` ``rust // Dynamic size let v = vec![1, 2, 3]; match v[..] { [a, b] => { /* this arm will not apply because the length doesn't match */ } [a, b, c] => { /* this arm will apply */ } _ => { /* this wildcard is required, since we don't know length statically */ } }``
<!--``rust // Dynamic size let v = vec![1, 2, 3]; match v[..] { [a, b] => { /* this arm will not apply because the length doesn't match */ } [a, b, c] => { /* this arm will apply */ } _ => { /* this wildcard is required, since we don't know length statically */ } }`` `-->
``rust // Dynamic size let v = vec![1, 2, 3]; match v[..] { [a, b] => { /* this arm will not apply because the length doesn't match */ } [a, b, c] => { /* this arm will apply */ } _ => { /* this wildcard is required, since we don't know length statically */ } }`` `

<!--Finally, match patterns can accept *pattern guards* to further refine the criteria for matching a case.-->
最後に、一致パターンは*パターンガード*を受け入れて、ケースの一致基準をさらに洗練させることができます。
<!--Pattern guards appear after the pattern and consist of a bool-typed expression following the `if` keyword.-->
パターンガードはパターンの後に表示され、`if`キーワードの後に​​bool型の式で構成されます。
<!--A pattern guard may refer to the variables bound within the pattern they follow.-->
パターンガードは、それらが従うパターン内にバインドされた変数を参照することができる。

```rust
# let maybe_digit = Some(0);
# fn process_digit(i: i32) { }
# fn process_other(i: i32) { }
let message = match maybe_digit {
    Some(x) if x < 10 => process_digit(x),
    Some(x) => process_other(x),
    None => panic!(),
};
```

## <!--Attributes on match arms--> マッチアームの属性

<!--Outer attributes are allowed on match arms.-->
外部アトリビュートはマッチアームで許可されます。
<!--The only attributes that have meaning on match arms are [`cfg`], `cold`, and the [lint check attributes].-->
マッチアームで意味を持つ唯一の属性は[`cfg`]、 `cold`、 [lint check attributes]。

<!--[_Expression_]: expressions.html
 [_BlockExpression_]: expressions/block-expr.html#block-expressions
 [place expression]: expressions.html#place-expressions-and-value-expressions
 [value expression]: expressions.html#place-expressions-and-value-expressions
 [`char`]: types.html#textual-types
 [numeric types]: types.html#numeric-types
 [_InnerAttribute_]: attributes.html
 [_OuterAttribute_]: attributes.html
 [`cfg`]: attributes.html#conditional-compilation
 [lint check attributes]: attributes.html#lint-check-attributes
-->
[_Expression_]: expressions.html
 [_BlockExpression_]: expressions/block-expr.html#block-expressions
 [place expression]: expressions.html#place-expressions-and-value-expressions
 [value expression]: expressions.html#place-expressions-and-value-expressions
 [`char`]: types.html#textual-types
 [numeric types]: types.html#numeric-types
 [_InnerAttribute_]: attributes.html
 [_OuterAttribute_]: attributes.html
 [`cfg`]: attributes.html#conditional-compilation
 [lint check attributes]: attributes.html#lint-check-attributes

