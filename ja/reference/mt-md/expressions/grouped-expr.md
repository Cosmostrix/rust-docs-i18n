# <!--Grouped expressions--> グループ化された式

> <!--**<sup>Syntax</sup>** \  _GroupedExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _GroupedExpression_ ：\＆nbsp;＆nbsp;
> <!--`(` [_Expression_] `)`-->
> `(` [_Expression_] `)`

<!--An expression enclosed in parentheses evaluates to the result of the enclosed expression.-->
括弧で囲まれた式は、囲まれた式の結果を評価します。
<!--Parentheses can be used to explicitly specify evaluation order within an expression.-->
括弧は、式内の評価順序を明示的に指定するために使用できます。

<!--An example of a parenthesized expression:-->
カッコで囲まれた式の例：

```rust
let x: i32 = 2 + 3 * 4;
let y: i32 = (2 + 3) * 4;
assert_eq!(x, 14);
assert_eq!(y, 20);
```

<!--An example of a necessary use of parentheses is when calling a function pointer that is a member of a struct:-->
括弧の必要な使用例は、structのメンバーである関数ポインタを呼び出すときです：

```rust
# struct A {
#    f: fn() -> &'static str
# }
# impl A {
#    fn f(&self) -> &'static str {
#        "The method f"
#    }
# }
# let a = A{f: || "The field f"};
#
assert_eq!( a.f (), "The method f");
assert_eq!((a.f)(), "The field f");
```

[_Expression_]: expressions.html
