# <!--Loops--> ループ

> <!--**<sup>Syntax</sup>** \  _LoopExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _LoopExpression_ ：\＆nbsp;＆nbsp;
> <!--[_LoopLabel_]  __?__ -->
> [_LoopLabel_]  __？__ 
> <!--(\ &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; [_InfiniteLoopExpression_] \ &nbsp;&nbsp; &nbsp;&nbsp; | [_PredicateLoopExpression_] \ &nbsp;&nbsp; &nbsp;&nbsp; | [_PredicatePatternLoopExpression_] \ &nbsp;&nbsp; &nbsp;&nbsp; | [_IteratorLoopExpression_] \ &nbsp;&nbsp;)-->
> （\＆nbsp;＆nbsp;＆nbsp;＆nbsp;＆nbsp;＆nbsp; [_InfiniteLoopExpression_] \＆nbsp;＆nbsp;＆nbsp; | [_PredicateLoopExpression_] \＆nbsp;＆nbsp;＆nbsp;＆nbsp; | [_PredicatePatternLoopExpression_] \＆nbsp;＆nbsp;＆nbsp;＆nbsp; | [_IteratorLoopExpression_] \＆nbsp;＆nbsp;）

<!--[_LoopLabel_]: #loop-labels
 [_InfiniteLoopExpression_]: #infinite-loops
 [_PredicateLoopExpression_]: #predicate-loops
 [_PredicatePatternLoopExpression_]: #predicate-pattern-loops
 [_IteratorLoopExpression_]: #iterator-loops
-->
[_LoopLabel_]: #loop-labels
 [_InfiniteLoopExpression_]: #infinite-loops
 [_PredicateLoopExpression_]: #predicate-loops
 [_PredicatePatternLoopExpression_]: #predicate-pattern-loops
 [_IteratorLoopExpression_]: #iterator-loops


<!--Rust supports four loop expressions:-->
Rustは4つのループ式をサポートしています：

* <!--A [`loop` expression](#infinite-loops) denotes an infinite loop.-->
   [`loop`式](#infinite-loops)は、無限ループを表します。
* <!--A [`while` expression](#predicate-loops) loops until a predicate is false.-->
   [`while`式](#predicate-loops)は述語がfalseになるまでループします。
* <!--A [`while let` expression](#predicate-pattern-loops) tests a refutable pattern.-->
   [`while let`式](#predicate-pattern-loops)は不変のパターンをテストします。
* <!--A [`for` expression](#iterator-loops) extracts values from an iterator, looping until the iterator is empty.-->
   [`for`式](#iterator-loops)はイテレータから値を抽出し、イテレータが空になるまでループします。

<!--All four types of loop support [`break` expressions](#break-expressions), [`continue` expressions](#continue-expressions), and [labels](#loop-labels).-->
4つのタイプのループはすべて、[式の](#continue-expressions) [`break`式の](#break-expressions) [`continue`](#continue-expressions)、および[labels](#loop-labels)サポートします。
<!--Only `loop` supports [evaluation to non-trivial values](#break-and-loop-values).-->
`loop`のみが[評価を非自明な値に](#break-and-loop-values)サポートし[ます](#break-and-loop-values)。

## <!--Infinite loops--> 無限ループ

> <!--**<sup>Syntax</sup>** \  _InfiniteLoopExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _InfiniteLoopExpression_ ：\＆nbsp;＆nbsp;
> <!--`loop` [_BlockExpression_]-->
> `loop` [_BlockExpression_]

<!--A `loop` expression repeats execution of its body continuously: `loop { println!("I live."); }`-->
`loop`式は、その本体の実行を連続して繰り返します： `loop { println!("I live."); }`
<!--`loop { println!("I live."); }`.-->
`loop { println!("I live."); }`。

<!--A `loop` expression without an associated `break` expression is diverging and has type [`!`](types.html#never-type).-->
関連する`break`式のない`loop`式は分岐しており、タイプは[`!`](types.html#never-type)。
<!--A `loop` expression containing associated [`break` expression(s)](#break-expressions) may terminate, and must have type compatible with the value of the `break` expression(s).-->
関連する[`break`](#break-expressions)式を含む`loop`式は終了し、`break`式の値と型互換性がなければなりません。

## <!--Predicate loops--> 述語ループ

> <!--**<sup>Syntax</sup>** \  _PredicateLoopExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _PredicateLoopExpression_ ：\＆nbsp;＆nbsp;
> <!--`while` [_Expression_] Subscript [Str "except",Space,Str "struct",Space,Str "expression"] [_BlockExpression_]-->
> `while` [_Expression_] Subscript [Str "\27083\36896\20307\34920\29694\12434\38500\12356"] [_BlockExpression_]

<!--A `while` loop begins by evaluating the boolean loop conditional expression.-->
`while`ループはブールループの条件式を評価することから始まります。
<!--If the loop conditional expression evaluates to `true`, the loop body block executes, then control returns to the loop conditional expression.-->
ループ条件式が`true`と評価された`true`、ループ本体ブロックが実行され、制御はループ条件式に戻ります。
<!--If the loop conditional expression evaluates to `false`, the `while` expression completes.-->
ループ条件式が`false`と評価され`false`場合、`while`式は完了します。

<!--An example:-->
例：

```rust
let mut i = 0;

while i < 10 {
    println!("hello");
    i = i + 1;
}
```

## <!--Predicate pattern loops--> 述語パターンループ

> <!--**<sup>Syntax</sup>** \ [_PredicatePatternLoopExpression_]:\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \ [_PredicatePatternLoopExpression_]：\＆nbsp;＆nbsp;
> <!--`while` `let`  _Pattern_  `=` [_Expression_] Subscript [Str "except",Space,Str "struct",Space,Str "expression"] [_BlockExpression_]-->
> `while` `let`  _Pattern_  `=` [_Expression_] Subscript [Str "\12434\38500\12367\12392\12289\27083\36896\20307\24335"] [_BlockExpression_]

<!--A `while let` loop is semantically similar to a `while` loop but in place of a condition expression it expects the keyword `let` followed by a refutable pattern, an `=`, an expression and a block expression.-->
`while let`ループは意味的に`while`ループに似ていますが、条件式の代わりに`let`というキーワードの後に​​改訂可能なパターン、`=`、式、ブロック式が続くと想定しています。
<!--If the value of the expression on the right hand side of the `=` matches the pattern, the loop body block executes then control returns to the pattern matching statement.-->
`=`右側の式の値がパターンと一致すると、ループ本体ブロックが実行され、制御がパターンマッチングステートメントに戻ります。
<!--Otherwise, the while expression completes.-->
それ以外の場合は、while式が完了します。

```rust
let mut x = vec![1, 2, 3];

while let Some(y) = x.pop() {
    println!("y = {}", y);
}
```

## <!--Iterator loops--> イテレータループ

> <!--**<sup>Syntax</sup>** \  _IteratorLoopExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _IteratorLoopExpression_ ：\＆nbsp;＆nbsp;
> <!--`for`  _Pattern_  `in` [_Expression_] Subscript [Str "except",Space,Str "struct",Space,Str "expression"] [_BlockExpression_]-->
> `for`  _パターン_  `in` [_Expression_] Subscript [Str "\27083\36896\20307\12398\24335\12434\38500\12367"] [_BlockExpression_]

<!--A `for` expression is a syntactic construct for looping over elements provided by an implementation of `std::iter::IntoIterator`.-->
`for`式は、`std::iter::IntoIterator`実装によって提供される要素をループするための構文構造です。
<!--If the iterator yields a value, that value is given the specified name and the body of the loop is executed, then control returns to the head of the `for` loop.-->
イテレータが値を返す場合、その値に指定された名前が与えられ、ループの本体が実行され、制御が`for`ループの先頭に戻ります。
<!--If the iterator is empty, the `for` expression completes.-->
イテレータが空の場合、`for`式は完了します。

<!--An example of a `for` loop over the contents of an array:-->
配列の内容`for`ループの例：

```rust
let v = &["apples", "cake", "coffee"];

for text in v {
    println!("I like {}.", text);
}
```

<!--An example of a for loop over a series of integers:-->
一連の整数にわたるforループの例：

```rust
let mut sum = 0;
for n in 1..11 {
    sum += n;
}
assert_eq!(sum, 55);
```

## <!--Loop labels--> ループラベル

> <!--**<sup>Syntax</sup>** \  _LoopLabel_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _LoopLabel_ ：\＆nbsp;＆nbsp;
> <!--[LIFETIME_OR_LABEL] `:`-->
> [LIFETIME_OR_LABEL] `:`

<!--A loop expression may optionally have a  _label_ .-->
ループ式はオプションで _ラベルを_ 持つことができます。
<!--The label is written as a lifetime preceding the loop expression, as in `'foo: loop { break 'foo; }`-->
ラベルは、`'foo: loop { break 'foo; }`ように、ループ式に先行する生涯として書かれてい`'foo: loop { break 'foo; }`
<!--`'foo: loop { break 'foo; }`, `'bar: while false {}`, `'humbug: for _ in 0..0 {}`.-->
`'foo: loop { break 'foo; }`、 `'bar: while false {}`、 `'humbug: for _ in 0..0 {}`。
<!--If a label is present, then labeled `break` and `continue` expressions nested within this loop may exit out of this loop or return control to its head.-->
ラベルが存在する場合、このループ内にネストされたラベル付きの`break`および`continue`式は、このループから抜けるか、コントロールをそのヘッドに戻すことがあります。
<!--See [break expressions](#break-expressions) and [continue expressions](#continue-expressions).-->
[ブレーク・エクスプレッション](#break-expressions)と[continue expressions](#continue-expressions)参照してください。

## <!--`break` expressions--> `break`式を

> <!--**<sup>Syntax</sup>** \  _BreakExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _BreakExpression_ ：\＆nbsp;＆nbsp;
> <!--`break` [LIFETIME_OR_LABEL]  __?__ -->
> `break` [LIFETIME_OR_LABEL]  __？__ 
> <!--[_Expression_]  __?__ -->
> [_Expression_]  __？__ 

<!--When `break` is encountered, execution of the associated loop body is immediately terminated, for example:-->
`break`に遭遇すると、関連するループ本体の実行は直ちに終了します。

```rust
let mut last = 0;
for x in 1..100 {
    if x > 12 {
        break;
    }
    last = x;
}
assert_eq!(last, 12);
```

<!--A `break` expression is normally associated with the innermost `loop`, `for` or `while` loop enclosing the `break` expression, but a [label](#loop-labels) can be used to specify which enclosing loop is affected.-->
`break`発現は、通常、最も内側に関連している`loop`、 `for`又は`while`囲むループ`break`発現が、[label](#loop-labels)影響される囲むループを指定するために使用することができます。
<!--Example:-->
例：

```rust
'outer: loop {
    while true {
        break 'outer;
    }
}
```

<!--A `break` expression is only permitted in the body of a loop, and has one of the forms `break`, `break 'label` or ([see below](#break-and-loop-values)) `break EXPR` or `break 'label EXPR`.-->
`break`式はループの本体でのみ許され、`break`、 `break 'label`または（[以下を参照](#break-and-loop-values)） `break EXPR`または`break 'label EXPR`いずれかの形式`break` `break 'label EXPR`ます。

## <!--`continue` expressions--> 式を`continue`

> <!--**<sup>Syntax</sup>** \  _ContinueExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _ContinueExpression_ ：\＆nbsp;＆nbsp;
> <!--`continue` [LIFETIME_OR_LABEL]  __?__ -->
> [LIFETIME_OR_LABEL] `continue`  __ますか？__ 

<!--When `continue` is encountered, the current iteration of the associated loop body is immediately terminated, returning control to the loop *head*.-->
`continue`に遭遇すると、関連するループ本体の現在の反復が直ちに終了し、ループ*ヘッドに*制御が戻されます。
<!--In the case of a `while` loop, the head is the conditional expression controlling the loop.-->
`while`ループの場合、headはループを制御する条件式です。
<!--In the case of a `for` loop, the head is the call-expression controlling the loop.-->
`for`ループの場合、headはループを制御するcall-expressionです。

<!--Like `break`, `continue` is normally associated with the innermost enclosing loop, but `continue 'label` may be used to specify the loop affected.-->
`break`と同様に、`continue`は通常、最も内側の囲みループに関連付け`continue`が、`continue`は`continue 'label`を使用して影響を受けるループを指定します。
<!--A `continue` expression is only permitted in the body of a loop.-->
`continue`式は、ループの本体でのみ使用できます。

## <!--`break` and loop values--> `break`値とループ値

<!--When associated with a `loop`, a break expression may be used to return a value from that loop, via one of the forms `break EXPR` or `break 'label EXPR`, where `EXPR` is an expression whose result is returned from the `loop`.-->
`loop`に関連付けられている場合、ブレーク式を使用して、`break EXPR`または`break 'label EXPR`いずれかを使用してループから値を戻すことができます`EXPR`は`loop`から結果が返される式です。
<!--For example:-->
例えば：

```rust
let (mut a, mut b) = (1, 1);
let result = loop {
    if b > 10 {
        break b;
    }
    let c = a + b;
    a = b;
    b = c;
};
#// first number in Fibonacci sequence over 10:
//  10以上のフィボナッチ数列の最初の数：
assert_eq!(result, 13);
```

<!--In the case a `loop` has an associated `break`, it is not considered diverging, and the `loop` must have a type compatible with each `break` expression.-->
`loop`に関連する`break`がある場合、`break`は考慮されず、`loop`は各`break`式と互換性のあるタイプでなければなりません。
<!--`break` without an expression is considered identical to `break` with expression `()`.-->
`break`表現せずには同一とみなされる`break`式で`()`

[IDENTIFIER]: identifiers.html

<!--[_Expression_]: %20%20%20%20%20expressions.html
 [_BlockExpression_]: expressions/block-expr.html
-->
[_Expression_]: %20%20%20%20%20expressions.html
 [_BlockExpression_]: expressions/block-expr.html


[LIFETIME_OR_LABEL]: tokens.html#lifetimes-and-loop-labels
