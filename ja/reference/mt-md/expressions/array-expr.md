# <!--Array and array index expressions--> 配列と配列のインデックス式

## <!--Array expressions--> 配列式

> <!--**<sup>Syntax</sup>** \  _ArrayExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _ArrayExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`[` `]` \ &nbsp;&nbsp;-->
> `[` `]` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`[` [_Expression_] (`,` [_Expression_])  __\*__  `,`  __?__ -->
> `[` [_Expression_]（ `,` [_Expression_]  __）\ *__  `,`  __？__ 
> <!--`]` \ &nbsp;&nbsp;-->
> `]` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`[` [_Expression_] `;`-->
> `[` [_Expression_] `;`
> <!--[_Expression_] `]`-->
> [_Expression_] `]`

<!--An  _[array](types.html#array-and-slice-types) expression_  can be written by enclosing zero or more comma-separated expressions of uniform type in square brackets.-->
 _[array]（types.html＃array-and-slice-types）式_ は、角括弧内に0個以上のコンマで区切られた統一タイプの式を囲むことで記述できます。
<!--This produces and array containing each of these values in the order they are written.-->
これは、書き込まれた順にこれらの値のそれぞれを含む配列を生成して配列します。

<!--Alternatively there can be exactly two expressions inside the brackets, separated by a semi-colon.-->
あるいは、ブラケットの中にセミコロンで区切られた正確に2つの式があります。
<!--The expression after the `;`-->
後の表現`;`
<!--must be a have type `usize` and be a [constant expression](expressions.html#constant-expressions), such as a [literal](tokens.html#literals) or a [constant item](items/constant-items.html).-->
有するタイプでなければならない`usize`とすること[定数式](expressions.html#constant-expressions)など、[literal](tokens.html#literals)または[constant item](items/constant-items.html)。
`[a; b]` <!--`[a; b]` creates an array containing `b` copies of the value of `a`.-->
`[a; b]`を含有する配列を作成し`b`の値のコピー。`a`
<!--If the expression after the semi-colon has a value greater than 1 then this requires that the type of `a` is [`Copy`](special-types-and-traits.html#copy).-->
セミコロンの後の式の値が1より大きい場合、`a`の型は[`Copy`](special-types-and-traits.html#copy)で`a`必要があります。

```rust
[1, 2, 3, 4];
["a", "b", "c", "d"];
#//[0; 128];              // array with 128 zeros
[0; 128];              //  128個のゼロを含む配列
[0u8, 0u8, 0u8, 0u8,];
#//[[1, 0, 0], [0, 1, 0], [0, 0, 1]]; // 2D array
[[1, 0, 0], [0, 1, 0], [0, 0, 1]]; //  2Dアレイ
```

## <!--Array and slice indexing expressions--> 配列とスライスのインデックス式

> <!--**<sup>Syntax</sup>** \  _IndexExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _IndexExpression_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] `[` [_Expression_] `]`-->
> [_Expression_] `[` [_Expression_] `]`

<!--[Array and slice](types.html#array-and-slice-types) -typed expressions can be indexed by writing a square-bracket-enclosed expression of type `usize` (the index) after them.-->
[配列型とスライス](types.html#array-and-slice-types)型の式は、後に型`usize`（索引）の角カッコで囲まれた式を記述することで索引付けできます。
<!--When the array is mutable, the resulting [memory location] can be assigned to.-->
配列が変更可能な場合、結果の[memory location]をに割り当てることができます。

<!--For other types an index expression `a[b]` is equivalent to `*std::ops::Index::index(&a, b)`, or `*std::ops::IndexMut::index_mut(&mut a, b)` in a mutable place expression context.-->
他の型の場合`a[b]`は`a[b]` `*std::ops::Index::index(&a, b)`、または`*std::ops::IndexMut::index_mut(&mut a, b)`と`*std::ops::IndexMut::index_mut(&mut a, b)`変更可能な場所表現コンテキスト。
<!--Just as with methods, Rust will also insert dereference operations on `a` repeatedly to find an implementation.-->
ちょうど方法と同様に、錆も上の操作を逆参照挿入する実装を見つけるために繰り返し。`a`

<!--Indices are zero-based for arrays and slices.-->
インデックスは、配列とスライスに基づいてゼロベースです。
<!--Array access is a [constant expression], so bounds can be checked at compile-time with a constant index value.-->
配列アクセスは[constant expression]であるため、定数のインデックス値でコンパイル時に境界を調べることができます。
<!--Otherwise a check will be performed at run-time that will put the thread in a  _panicked state_  if it fails.-->
それ以外の場合は、スレッドが失敗した場合に _パニック状態に_ なるように、実行時にチェックが実行されます。

```rust,should_panic
#// lint is deny by default.
//  lintはデフォルトでは拒否されます。
#![warn(const_err)]

#//([1, 2, 3, 4])[2];        // Evaluates to 3
([1, 2, 3, 4])[2];        //  3に評価する

let b = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
#//b[1][2];                  // multidimensional array indexing
b[1][2];                  // 多次元配列の索引付け

#//let x = (["a", "b"])[10]; // warning: index out of bounds
let x = (["a", "b"])[10]; // 警告：範囲外のインデックス

let n = 10;
#//let y = (["a", "b"])[n];  // panics
let y = (["a", "b"])[n];  // パニック

let arr = ["a", "b"];
#//arr[10];                  // warning: index out of bounds
arr[10];                  // 警告：範囲外のインデックス
```

<!--The array index expression can be implemented for types other than arrays and slices by implementing the [Index] and [IndexMut] traits.-->
配列インデックス式は、[Index]および[IndexMut]特性を実装することによって、配列やスライス以外の型に対しても実装できます。

<!--[_Expression_]: expressions.html
 [memory location]: expressions.html#place-expressions-and-value-expressions
 [Index]: ../std/ops/trait.Index.html
 [IndexMut]: ../std/ops/trait.IndexMut.html
 [constant expression]: expressions.html#constant-expressions
-->
[_Expression_]: expressions.html
 [memory location]: expressions.html#place-expressions-and-value-expressions
 [Index]: ../std/ops/trait.Index.html
 [IndexMut]: ../std/ops/trait.IndexMut.html
 [constant expression]: expressions.html#constant-expressions

