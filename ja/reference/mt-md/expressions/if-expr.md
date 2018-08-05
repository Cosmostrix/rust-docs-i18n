# <!--`if` and `if let` expressions--> `if`式と`if let`式

## <!--`if` expressions--> 式の`if`

> <!--**<sup>Syntax</sup>** \  _IfExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _IfExpression_ ：\＆nbsp;＆nbsp;
> <!--`if` [_Expression_] Subscript [Strikeout [Str "except",Space,Str "struct",Space,Str "expression"]] [_BlockExpression_] \ &nbsp;&nbsp;-->
> `if` [_Expression_] Subscript [Strikeout [Str "\27083\36896\20307\34920\29694\12434\38500\12356\12390"]] [_BlockExpression_] \＆NBSP;＆NBSP;
> <!--(`else` ([_BlockExpression_] |  _IfExpression_  |  _IfLetExpression_ ))  __\?__ -->
> （`else`（ [_BlockExpression_] |  _IfExpression_  |  _IfLetExpression_ ））  __\？__ 

<!--An `if` expression is a conditional branch in program control.-->
`if`式はプログラム制御の条件分岐です。
<!--The form of an `if` expression is a condition expression, followed by a consequent block, any number of `else if` conditions and blocks, and an optional trailing `else` block.-->
`if`式の形式は条件式であり、その後に続くブロック、`else if`条件とブロック、およびオプションの末尾`else`ブロックが続きます。
<!--The condition expressions must have type `bool`.-->
条件式は`bool`型でなければなりません。
<!--If a condition expression evaluates to `true`, the consequent block is executed and any subsequent `else if` or `else` block is skipped.-->
条件式が`true`であると評価されると、後続のブロックが実行され、後続の`else if`または`else`ブロックはスキップされます。
<!--If a condition expression evaluates to `false`, the consequent block is skipped and any subsequent `else if` condition is evaluated.-->
条件式が`false`と評価され`false`場合、結果のブロックはスキップされ、後続の`else if`条件が評価されます。
<!--If all `if` and `else if` conditions evaluate to `false` then any `else` block is executed.-->
`if`および`else if`条件がすべて`false`評価される`false`、 `else`ブロックが実行されます。
<!--An if expression evaluates to the same value as the executed block, or `()` if no block is evaluated.-->
if式は、実行されたブロックと同じ値に評価されます。ブロックが評価されない場合は、`()`です。
<!--An `if` expression must have the same type in all situations.-->
`if`式は、すべての状況で同じ型でなければなりません。

```rust
# let x = 3;
if x == 4 {
    println!("x is four");
} else if x == 3 {
    println!("x is three");
} else {
    println!("x is something else");
}

let y = if 12 * 15 > 150 {
    "Bigger"
} else {
    "Smaller"
};
assert_eq!(y, "Bigger");
```

## <!--`if let` expressions--> `if let`式

> <!--**<sup>Syntax</sup>** \  _IfLetExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _IfLetExpression_ ：\＆nbsp;＆nbsp;
> <!--`if` `let`  _Pattern_  `=` [_Expression_] Subscript [Strikeout [Str "except",Space,Str "struct",Space,Str "expression"]] [_BlockExpression_] \ &nbsp;&nbsp;-->
> `if` `let`  _パターンが_  `=` [_Expression_] Subscript [Strikeout [Str "\27083\36896\20307\34920\29694\12434\38500\12356\12390"]] [_BlockExpression_] \＆NBSP;＆NBSP;
> <!--(`else` ([_BlockExpression_] |  _IfExpression_  |  _IfLetExpression_ ))  __\?__ -->
> （`else`（ [_BlockExpression_] |  _IfExpression_  |  _IfLetExpression_ ））  __\？__ 

<!--An `if let` expression is semantically similar to an `if` expression but in place of a condition expression it expects the keyword `let` followed by a refutable pattern, an `=` and an expression.-->
`if let`式は意味的には`if`式と似ていますが、条件式の代わりに`let`というキーワードの後に​​改訂可能なパターンan `=`と式が必要です。
<!--If the value of the expression on the right hand side of the `=` matches the pattern, the corresponding block will execute, otherwise flow proceeds to the following `else` block if it exists.-->
`=`右側の式の値がパターンと一致する場合、対応するブロックが実行され、そうでない場合、次の`else`ブロックが存在する場合は、そのブロックに進みます。
<!--Like `if` expressions, `if let` expressions have a value determined by the block that is evaluated.-->
同様に`if`表現、`if let`式が評価されたブロックによって決定された値を持っています。

```rust
let dish = ("Ham", "Eggs");

#// this body will be skipped because the pattern is refuted
// パターンが反駁されたため、このボディはスキップされます。
if let ("Bacon", b) = dish {
    println!("Bacon is served with {}", b);
} else {
#    // This block is evaluated instead.
    // このブロックは代わりに評価されます。
    println!("No bacon will be served");
}

#// this body will execute
// このボディは実行されます
if let ("Ham", b) = dish {
    println!("Ham is served with {}", b);
}
```

<!--`if` and `if let` expressions can be intermixed:-->
`if`式を混在`if let`ことができる`if let`：

```rust
let x = Some(3);
let a = if let Some(1) = x {
    1
} else if x == Some(2) {
    2
} else if let Some(y) = x {
    y
} else {
    -1
};
assert_eq!(a, 3);
```

<!--[_Expression_]: expressions.html
 [_BlockExpression_]: expressions/block-expr.html
-->
[_Expression_]: expressions.html
 [_BlockExpression_]: expressions/block-expr.html

