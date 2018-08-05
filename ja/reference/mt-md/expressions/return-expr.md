# <!--`return` expressions--> 式を`return`

> <!--**<sup>Syntax</sup>** \  _ReturnExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _ReturnExpression_ ：\＆nbsp;＆nbsp;
> <!--`return` [_Expression_]  __?__ -->
> `return` [_Expression_]  __？__ 

<!--Return expressions are denoted with the keyword `return`.-->
戻り式は、キーワード`return`示されます。
<!--Evaluating a `return` expression moves its argument into the designated output location for the current function call, destroys the current function activation frame, and transfers control to the caller frame.-->
`return`式を評価すると、その引数が現在の関数呼び出しの指定された出力場所に移動し、現在の関数起動フレームが破棄され、呼び出し元フレームに制御が移ります。

<!--An example of a `return` expression:-->
`return`式の例：

```rust
fn max(a: i32, b: i32) -> i32 {
    if a > b {
        return a;
    }
    return b;
}
```

[_Expression_]: expressions.html
