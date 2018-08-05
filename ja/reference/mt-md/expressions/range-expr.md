# <!--Range expressions--> 範囲式

> <!--**<sup>Syntax</sup>** \  _RangeExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _RangeExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!-- _RangeExpr_  \ &nbsp;&nbsp;-->
>  _RangeExpr_  \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!-- _RangeFromExpr_  \ &nbsp;&nbsp;-->
>  _RangeFromExpr_  \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!-- _RangeToExpr_  \ &nbsp;&nbsp;-->
>  _RangeToExpr_  \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!-- _RangeFullExpr_  \ &nbsp;&nbsp;-->
>  _RangeFullExpr_  \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!-- _RangeInclusiveExpr_  \ &nbsp;&nbsp;-->
>  _RangeInclusiveExpr_  \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!-- _RangeToInclusiveExpr_ -->
>  _RangeToInclusiveExpr_ 
> 
> <!-- _RangeExpr_ :\ &nbsp;&nbsp;-->
>  _RangeExpr_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] `..` [_Expression_]-->
> [_Expression_] `..` [_Expression_]
> 
> <!-- _RangeFromExpr_ :\ &nbsp;&nbsp;-->
>  _RangeFromExpr_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] `..`-->
> [_Expression_] `..`
> 
> <!-- _RangeToExpr_ :\ &nbsp;&nbsp;-->
>  _RangeToExpr_ ：\＆nbsp;＆nbsp;
> <!--`..` [_Expression_]-->
> `..` [_Expression_]
> 
> <!-- _RangeFullExpr_ :\ &nbsp;&nbsp;-->
>  _RangeFullExpr_ ：\＆nbsp;＆nbsp;
> `..`
> <!-- _RangeExpr_ :\ &nbsp;&nbsp;-->
>  _RangeExpr_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] `..=` [_Expression_]-->
> [_Expression_] `..=` [_Expression_]
> 
> <!-- _RangeToExpr_ :\ &nbsp;&nbsp;-->
>  _RangeToExpr_ ：\＆nbsp;＆nbsp;
> <!--`..=` [_Expression_]-->
> `..=` [_Expression_]

<!--The `..` and `..=` operators will construct an object of one of the `std::ops::Range` (or `core::ops::Range`) variants, according to the following table:-->
`..`と`..=`演算子は、次の表に従って、`std::ops::Range`（または`core::ops::Range`）のいずれかのオブジェクトを作成します。

|<!--Production-->製造|<!--Syntax-->構文|<!--Type-->タイプ|<!--Range-->範囲|
|<!---------------------------->------------------------|<!------------------->---------------|<!---------------------------------->------------------------------|<!--------------------------->-----------------------|
|<!-- _RangeExpr_ --> _RangeExpr_ |<!--start `..` end-->開始`..`終了|[std::ops::Range]|<!--start &le;-->スタート＆ル;<!--x &lt;-->x <<!--end-->終わり|
|<!-- _RangeFromExpr_ --> _RangeFromExpr_ |<!--start `..`-->スタート`..`|[std::ops::RangeFrom]|<!--start &le;-->スタート＆ル;<!--x-->バツ|
|<!-- _RangeToExpr_ --> _RangeToExpr_ |<!--`..` end-->`..`終わり|[std::ops::RangeTo]|<!--x &lt;-->x <<!--end-->終わり|
|<!-- _RangeFullExpr_ --> _RangeFullExpr_ |`..`|[std::ops::RangeFull]|<!----->-|
|<!-- _RangeInclusiveExpr_ --> _RangeInclusiveExpr_ |<!--start `..=` end-->開始`..=`終了|[std::ops::RangeInclusive]|<!--start &le;-->スタート＆ル;<!--x &le;-->x＆le;<!--end-->終わり|
|<!-- _RangeToInclusiveExpr_ --> _RangeToInclusiveExpr_ |<!--`..=` end-->`..=`終わり|[std::ops::RangeToInclusive]|<!--x &le;-->x＆le;<!--end-->終わり|

<!--Examples:-->
例：

```rust
#//1..2;   // std::ops::Range
1..2;   //  std:: ops:: Range
#//3..;    // std::ops::RangeFrom
3..;    //  std:: ops:: RangeFrom
#//..4;    // std::ops::RangeTo
..4;    //  std:: ops:: RangeTo
#//..;     // std::ops::RangeFull
..;     //  std:: ops:: RangeFull
#//5..=6;  // std::ops::RangeInclusive
5..=6;  //  std:: ops:: RangeInclusive
#//..=7;   // std::ops::RangeToInclusive
..=7;   //  std:: ops:: RangeToInclusive
```

<!--The following expressions are equivalent.-->
次の式は同等です。

```rust
let x = std::ops::Range {start: 0, end: 10};
let y = 0..10;

assert_eq!(x, y);
```

<!--Ranges can be used in `for` loops:-->
範囲は`for`ループで使用できます。

```rust
for i in 1..11 {
    println!("{}", i);
}
```

[_Expression_]: expressions.html

<!--[std::ops::Range]: %20%20%20%20%20%20%20%20%20%20%20https://doc.rust-lang.org/std/ops/struct.Range.html
 [std::ops::RangeFrom]: %20%20%20%20%20%20%20https://doc.rust-lang.org/std/ops/struct.RangeFrom.html
 [std::ops::RangeTo]: %20%20%20%20%20%20%20%20%20https://doc.rust-lang.org/std/ops/struct.RangeTo.html
 [std::ops::RangeFull]: %20%20%20%20%20%20%20https://doc.rust-lang.org/std/ops/struct.RangeFull.html
 [std::ops::RangeInclusive]: %20%20https://doc.rust-lang.org/std/ops/struct.RangeInclusive.html
 [std::ops::RangeToInclusive]: https://doc.rust-lang.org/std/ops/struct.RangeToInclusive.html
-->
[std::ops::Range]: %20%20%20%20%20%20%20%20%20%20%20https://doc.rust-lang.org/std/ops/struct.Range.html
 [std::ops::RangeFrom]: %20%20%20%20%20%20%20https://doc.rust-lang.org/std/ops/struct.RangeFrom.html
 [std::ops::RangeTo]: %20%20%20%20%20%20%20%20%20https://doc.rust-lang.org/std/ops/struct.RangeTo.html
 [std::ops::RangeFull]: %20%20%20%20%20%20%20https://doc.rust-lang.org/std/ops/struct.RangeFull.html
 [std::ops::RangeInclusive]: %20%20https://doc.rust-lang.org/std/ops/struct.RangeInclusive.html
 [std::ops::RangeToInclusive]: https://doc.rust-lang.org/std/ops/struct.RangeToInclusive.html

