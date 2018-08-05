# <!--Block expressions--> 表現をブロックする

> <!--**<sup>Syntax</sup>** \  _BlockExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _BlockExpression_ ：\＆nbsp;＆nbsp;
> <!--`{` \ &nbsp;&nbsp;-->
> `{` \＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[_InnerAttribute_]  __\ *</sup>\ &nbsp;&nbsp;*__ -->
> [_InnerAttribute_]  __\ *</ sup> \＆nbsp;＆nbsp;*__ 
> <!-- __*&nbsp;&nbsp;*__ -->
>  __*＆nbsp;＆nbsp;*__ 
> <!-- __*[_Statement_]<sup>\*__  \ &nbsp;&nbsp;-->
>  __*[_ Statement _] <sup> \*__  \＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[_Expression_]  __?__ -->
> [_Expression_]  __？__ 
> <!--\ &nbsp;&nbsp;-->
> \＆nbsp;＆nbsp;
> `}`

<!--A  _block expression_  is similar to a module in terms of the declarations that are possible, but can also contain [statements] and end with an [expression].-->
 _ブロック式_ は可能な宣言の点でモジュールと似ていますが、[statements]を含み、[expression]終わることもできます。
<!--Each block conceptually introduces a new namespace scope.-->
各ブロックは、新しい名前空間のスコープを概念的に導入しています。
<!--Use items can bring new names into scopes and declared items are in scope for only the block itself.-->
使用アイテムはスコープに新しい名前を付けることができ、宣言されたアイテムはブロック自体のスコープ内にあります。

<!--A block will execute each statement sequentially, and then execute the expression, if given.-->
ブロックは各ステートメントを順番に実行し、与えられれば式を実行します。
<!--If the block doesn't end in an expression, its value is `()`:-->
ブロックが式で終了しない場合、その値は`()`です。

```rust
let x: () = { println!("Hello."); };
```

<!--If it ends in an expression, its value and type are that of the expression:-->
式で終わる場合、その値と型は式の値と型です：

```rust
let x: i32 = { println!("Hello."); 5 };

assert_eq!(5, x);
```

<!--Blocks are always [value expressions] and evaluate the last expression in value expression context.-->
ブロックは常に[value expressions]あり、値式コンテキストの最後の[value expressions]を評価します。
<!--This can be used to force moving a value if really needed.-->
これは、本当に必要な場合に値を強制的に移動させるために使用できます。

## <!--`unsafe` blocks--> `unsafe`ブロック

> <!--**<sup>Syntax</sup>** \  _UnsafeBlockExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _UnsafeBlockExpression_ ：\＆nbsp;＆nbsp;
> <!--`unsafe`  _BlockExpression_ -->
> `unsafe`  _BlockExpression_ 

<!-- _See [`unsafe` block](unsafe-blocks.html) for more information on when to use `unsafe`_ -->
 _`unsafe`をいつ使うべきかについては、` `unsafe`ブロック（unsafe-blocks.html）を参照してください。_ 

<!--A block of code can be prefixed with the `unsafe` keyword, to permit calling `unsafe` functions or dereferencing raw pointers within a safe function.-->
コードのブロックに`unsafe`キーワードを接頭辞として付けると、`unsafe` `unsafe`関数を呼び出したり、安全な関数内で生ポインタを逆参照することができます。
<!--Examples:-->
例：

```rust
unsafe {
    let b = [13u8, 17u8];
    let a = &b[0] as *const u8;
    assert_eq!(*a, 13);
    assert_eq!(*a.offset(1), 17);
}

# unsafe fn f() -> i32 { 10 }
let a = unsafe { f() };
```

## <!--Attributes on block expressions--> ブロック式の属性

<!--Block expressions allow [outer attributes] and [inner attributes] directly after the opening brace when the block expression is the outer expression of an [expression statement] or the final expression of another block expression.-->
ブロック式は許可[outer attributes]及び[inner attributes]ブロック発現が外表現である場合、直接開口ブレース後に[expression statement]または他のブロック式の最終的な発現。
<!--The attributes that have meaning on a block expression are [`cfg`], and [the lint check attributes].-->
ブロック式に意味を持つ属性は[`cfg`]と[the lint check attributes]。

<!--For example, this function returns `true` on unix platforms and `false` on other platforms.-->
たとえば、この関数はUNIXプラットフォームでは`true`を返し、他のプラットフォームでは`false`を返します。

```rust
fn is_unix_platform() -> bool {
    #[cfg(unix)] { true }
    #[cfg(not(unix))] { false }
}
```

<!--[_InnerAttribute_]: attributes.html
 [_Statement_]: statements.html
 [_Expression_]: expressions.html
 [expression]: expressions.html
 [statements]: statements.html
 [value expressions]: expressions.html#place-expressions-and-value-expressions
 [outer attributes]: attributes.html
 [inner attributes]: attributes.html
 [expression statement]: statements.html#expression-statements
 [`cfg`]: attributes.html#conditional-compilation
 [the lint check attributes]: attributes.html#lint-check-attributes
-->
[_InnerAttribute_]: attributes.html
 [_Statement_]: statements.html
 [_Expression_]: expressions.html
 [expression]: expressions.html
 [statements]: statements.html
 [value expressions]: expressions.html#place-expressions-and-value-expressions
 [outer attributes]: attributes.html
 [inner attributes]: attributes.html
 [expression statement]: statements.html#expression-statements
 [`cfg`]: attributes.html#conditional-compilation
 [the lint check attributes]: attributes.html#lint-check-attributes

