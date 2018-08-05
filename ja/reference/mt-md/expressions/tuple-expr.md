# <!--Tuple and tuple indexing expressions--> タプルとタプルのインデックス式

## <!--Tuple expressions--> タプル式

> <!--**<sup>Syntax</sup>** \  _TupleExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _TupleExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`(` `)` \ &nbsp;&nbsp;-->
> `(` `)` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`(` ([_Expression_] `,`)  __+__  [_Expression_]  __?__  `)`-->
> `(`（ [_Expression_] `,`）  __+__  [_Expression_]  __？__  `)`

<!--Tuples are written by enclosing zero or more comma-separated expressions in parentheses.-->
タプルは、0個以上のコンマ区切りの式をカッコで囲むことで作成されます。
<!--They are used to create [tuple-typed](types.html#tuple-types) values.-->
[tuple-typed](types.html#tuple-types)値を作成するために使用さ[tuple-typed](types.html#tuple-types)ます。

```rust
(0.0, 4.5);
("a", 4usize, true);
();
```

<!--You can disambiguate a single-element tuple from a value in parentheses with a comma:-->
単一要素のタプルを括弧でくくられた値からコンマで区別できます。

```rust
#//(0,); // single-element tuple
(0,); // 単一要素タプル
#//(0); // zero in parentheses
(0); // カッコ内はゼロ
```

## <!--Tuple indexing expressions--> タプルインデックス式

> <!--**<sup>Syntax</sup>** \  _TupleIndexingExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _TupleIndexingExpression_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] `.`-->
> [_Expression_] `.`
> [TUPLE_INDEX]

<!--[Tuples](types.html#tuple-types) and [struct tuples](items/structs.html) can be indexed using the number corresponding to the position of the field.-->
[Tuples](types.html#tuple-types)および[構造体タプル](items/structs.html)は、フィールドの位置に対応する番号を使用して索引付けできます。
<!--The index must be written as a [decimal literal](tokens.html#integer-literals) with no underscores or suffix.-->
インデックスは、アンダースコアまたはサフィックスがない[小数のリテラル](tokens.html#integer-literals)として記述する必要があります。
<!--Tuple indexing expressions also differ from field expressions in that they can unambiguously be called as a function.-->
タプル索引付け式は、明示的に関数として呼び出すことができる点でフィールド式とは異なります。
<!--In all other aspects they have the same behavior.-->
他のすべての側面において、それらは同じ挙動を有する。

```rust
# struct Point(f32, f32);
let pair = (1, 2);
assert_eq!(pair.1, 2);
let unit_x = Point(1.0, 0.0);
assert_eq!(unit_x.0, 1.0);
```

<!--[TUPLE_INDEX]: tokens.html#integer-literals
 [_Expression_]: expressions.html
-->
[TUPLE_INDEX]: tokens.html#integer-literals
 [_Expression_]: expressions.html

