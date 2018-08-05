# <!--Closure expressions--> クロージャ式

> <!--**<sup>Syntax</sup>** \  _ClosureExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _ClosureExpression_ ：\＆nbsp;＆nbsp;
> <!--`move`  __?__ -->
> `move`  __？__ 
> <!--\ &nbsp;&nbsp;-->
> \＆nbsp;＆nbsp;
> <!--(`||` | `|` [_FunctionParameters_]  __?__  `|`)\ &nbsp;&nbsp;-->
> （`||` | `|` [_FunctionParameters_]  __？__  `|`）\＆nbsp;＆nbsp;
> <!--([_Expression_] | `->` [_TypeNoBounds_] &nbsp; [_BlockExpression_])-->
> （[_Expression_] | `->` [_TypeNoBounds_] ＆nbsp; [_BlockExpression_]）

<!--A  _closure expression_  defines a closure and denotes it as a value, in a single expression.-->
 _クロージャ式_ は _クロージャを_ 定義し、単一の式で値として表します。
<!--A closure expression is a pipe-symbol-delimited (`|`) list of patterns followed by an expression.-->
クロージャー式は、パイプ記号で区切られた（`|`）パターンのリストとそれに続く式です。
<!--Type annotations may optionally be added for the type of the parameters or for the return type.-->
型の注釈は、パラメータの型または戻り値の型にオプションで追加できます。
<!--If there is a return type, the expression used for the body of the closure must be a normal [block].-->
戻り値の型がある場合、クロージャの本体に使用される式は通常の[block]なければなりません。
<!--A closure expression also may begin with the `move` keyword before the initial `|`-->
クロージャー式は、最初の`|`前に`move`キーワードで始まることもあります`|`
<!--.-->
。

<!--A closure expression denotes a function that maps a list of parameters (`ident_list`) onto the expression that follows the `ident_list`.-->
クロージャー式は、`ident_list`続く式にパラメーターのリスト（`ident_list`）をマップする関数を表します。
<!--The patterns in the `ident_list` are the parameters to the closure.-->
`ident_list`のパターンはクロージャのパラメータです。
<!--If a parameter's types is not specified, then the compiler infers it from context.-->
パラメータの型が指定されていない場合、コンパイラはそれをコンテキストから推論します。
<!--Each closure expression has a unique anonymous type.-->
各クロージャ式には、一意の匿名型があります。

<!--Closure expressions are most useful when passing functions as arguments to other functions, as an abbreviation for defining and capturing a separate function.-->
クロージャ式は、別の関数を定義してキャプチャするための省略形として、関数を引数として他の関数に渡すときに最も便利です。

<!--Significantly, closure expressions  _capture their environment_ , which regular [function definitions] do not.-->
重要なことに、クロージャ式 _は環境を捕捉します_ 。通常の[function definitions]はそうではありません。
<!--Without the `move` keyword, the closure expression [infers how it captures each variable from its environment](types.html#capture-modes), preferring to capture by shared reference, effectively borrowing all outer variables mentioned inside the closure's body.-->
`move`キーワードがなければ、クロージャ式[は環境から各変数をどのように取得するのかを推測し](types.html#capture-modes)、共有参照によって取得することを優先し、クロージャのボディ内部に記述されたすべての外部変数を効果的に借用します。
<!--If needed the compiler will infer that instead mutable references should be taken, or that the values should be moved or copied (depending on their type) from the environment.-->
必要に応じて、コンパイラは、代わりに変更可能な参照を取るか、値を環境から移動またはコピーする必要があると推論します。
<!--A closure can be forced to capture its environment by copying or moving values by prefixing it with the `move` keyword.-->
クロージャーは、値をコピーまたは移動することによって、そのキーワードの先頭に`move`キーワードを付けることによって、環境をキャプチャーすることが強制できます。
<!--This is often used to ensure that the closure's type is `'static`.-->
これは、しばしばクロージャのタイプが`'static`あることを保証するために使用され`'static`。

<!--The compiler will determine which of the [closure traits](types.html#call-traits-and-coercions) the closure's type will implement by how it acts on its captured variables.-->
コンパイラは、クロージャの型が実装されるクロージャの[closure traits](types.html#call-traits-and-coercions)、そのクロージャのキャプチャされた変数でどのように動作するかによって決定します。
<!--The closure will also implement [`Send`](special-types-and-traits.html#send) and/or [`Sync`](special-types-and-traits.html#sync) if all of its captured types do.-->
クロージャは、キャプチャされたすべての型が行う場合には[`Send`](special-types-and-traits.html#send)および/または[`Sync`](special-types-and-traits.html#sync)も実装します。
<!--These traits allow functions to accept closures using generics, even though the exact types can't be named.-->
これらの特性は、正確な型の名前を付けることはできないが、関数がジェネリックを使用してクロージャを受け入れることを可能にする。

<!--In this example, we define a function `ten_times` that takes a higher-order function argument, and we then call it with a closure expression as an argument, followed by a closure expression that moves values from its environment.-->
この例では、高次関数の引数を取る関数`ten_times`を定義し、引数としてクロージャ式を指定してコールし、その後に環境から値を移動するクロージャ式を呼び出します。

```rust
fn ten_times<F>(f: F) where F: Fn(i32) {
    for index in 0..10 {
        f(index);
    }
}

ten_times(|j| println!("hello, {}", j));
#// With type annotations
// 型アノテーション付き
ten_times(|j: i32| -> () { println!("hello, {}", j) });

let word = "konnichiwa".to_owned();
ten_times(move |j| println!("{}, {}", word, j));
```

<!--[block]: expressions/block-expr.html
 [function definitions]: items/functions.html
-->
[block]: expressions/block-expr.html
 [function definitions]: items/functions.html


<!--[_Expression_]: expressions.html
 [_BlockExpression_]: expressions/block-expr.html
 [_TypeNoBounds_]: types.html
 [_FunctionParameters_]: items/functions.html
-->
[_Expression_]: expressions.html
 [_BlockExpression_]: expressions/block-expr.html
 [_TypeNoBounds_]: types.html
 [_FunctionParameters_]: items/functions.html

