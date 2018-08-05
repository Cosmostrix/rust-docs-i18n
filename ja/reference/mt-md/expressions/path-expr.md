# <!--Path expressions--> パス式

<!--A [path] used as an expression context denotes either a local variable or an item.-->
式コンテキストとして使用される[path]は、ローカル変数または項目のいずれかを示します。
<!--Path expressions that resolve to local or static variables are [place expressions], other paths are [value expressions].-->
ローカルまたは静的変数に解決されるパス式は[place expressions]、他のパスは[value expressions]です。
<!--Using a [`static mut`] variable requires an [`unsafe` block].-->
[`static mut`]変数を使うには[`static mut`] [`unsafe` block]が必要です。

```rust
# mod globals {
#     pub static STATIC_VAR: i32 = 5;
#     pub static mut STATIC_MUT_VAR: i32 = 7;
# }
# let local_var = 3;
local_var;
globals::STATIC_VAR;
unsafe { globals::STATIC_MUT_VAR };
let some_constructor = Some::<i32>;
let push_integer = Vec::<i32>::push;
let slice_reverse = <[i32]>::reverse;
```

<!--[place expressions]: expressions.html#place-expressions-and-value-expressions
 [value expressions]: expressions.html#place-expressions-and-value-expressions
 [path]: paths.html
 [`static mut`]: items/static-items.html#mutable-statics
 [`unsafe` block]: expressions/block-expr.html#unsafe-blocks
-->
[place expressions]: expressions.html#place-expressions-and-value-expressions
 [value expressions]: expressions.html#place-expressions-and-value-expressions
 [path]: paths.html
 [`static mut`]: items/static-items.html#mutable-statics
 [`unsafe` block]: expressions/block-expr.html#unsafe-blocks

