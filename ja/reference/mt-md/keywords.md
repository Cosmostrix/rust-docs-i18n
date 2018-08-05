# <!--Keywords--> キーワード

<!--Rust divides keywords into three categories:-->
錆はキーワードを3つのカテゴリに分類します：

* [strict](#strict-keywords)
* [reserved](#reserved-keywords)
* [weak](#weak-keywords)

## <!--Strict keywords--> 厳密なキーワード

<!--These keywords can only be used in their correct contexts.-->
これらのキーワードは、正しいコンテキストでのみ使用できます。
<!--They cannot be used as the names of:-->
それらは以下の名前として使用することはできません：

* [Items]
* <!--[Variables] and function parameters-->
   [Variables]と関数のパラメータ
* <!--Fields and [variants]-->
   フィールドと[variants]
* [Type parameters]
* <!--Lifetime parameters or [loop labels]-->
   寿命パラメータまたは[loop labels]
* <!--[Macros] or [attributes]-->
   [Macros]または[attributes]
* [Macro placeholders]
* [Crates]

> <!--**<sup>Lexer:<sup>** \ KW_AS: `as` \ KW_BREAK: `break` \ KW_CONST: `const` \ KW_CONTINUE: `continue` \ KW_CRATE: `crate` \ KW_ELSE: `else` \ KW_ENUM: `enum` \ KW_EXTERN: `extern` \ KW_FALSE: `false` \ KW_FN: `fn` \ KW_FOR: `for` \ KW_IF: `if` \ KW_IMPL: `impl` \ KW_IN: `in` \ KW_LET: `let` \ KW_LOOP: `loop` \ KW_MATCH: `match` \ KW_MOD: `mod` \ KW_MOVE: `move` \ KW_MUT: `mut` \ KW_PUB: `pub` \ KW_REF: `ref` \ KW_RETURN: `return` \ KW_SELFVALUE: `self` \ KW_SELFTYPE: `Self` \ KW_STATIC: `static` \ KW_STRUCT: `struct` \ KW_SUPER: `super` \ KW_TRAIT: `trait` \ KW_TRUE: `true` \ KW_TYPE: `type` \ KW_UNSAFE: `unsafe` \ KW_USE: `use` \ KW_WHERE: `where` \ KW_WHILE: `while`-->
> **<SUP>レクサー：<SUP>** \ KW_AS： `as`：\ KW_BREAK `break`の\ KW_CONST： `const`の\ KW_CONTINUE： `continue`の\ KW_CRATEを： `crate`の\ KW_ELSE： `else` \ KW_ENUM： `enum` \ KW_EXTERN： `extern` \ KW_FALSE： `false`の\ KW_FN： `fn` \ KW_FOR： `for`：\ KW_IF `if` \ KW_IMPL： `impl` \のKW_IN： `in` \ KW_LET： `let` \ KW_LOOP： `loop`の\ KW_MATCH： `match`の\ KW_MOD： `mod`の\ KW_MOVE： `move`の\ KW_MUT： `mut`の\ KW_PUB： `pub`の\ KW_REF： `ref`の\ KW_RETURN： `return` \ KW_SELFVALUE： `self`の\ KW_SELFTYPE： `Self` \ KW_STATIC： `static` \のKW_STRUCT： `struct`の\ KW_SUPER： `super`の\ KW_TRAIT： `trait`の\ KW_TRUE： `true`の\ KW_TYPE： `type`の\ KW_UNSAFE： `unsafe`の\ KW_USE： `use` \ KW_WHEREを： \ KW_WHILE： `where` `while`

## <!--Reserved keywords--> 予約済みのキーワード

<!--These keywords aren't used yet, but they are reserved for future use.-->
これらのキーワードはまだ使用されていませんが、将来の使用のために予約されています。
<!--They have the same restrictions as strict keywords.-->
厳格なキーワードと同じ制限があります。
<!--The reasoning behind this is to make current programs forward compatible with future versions of Rust by forbidding them to use these keywords.-->
これの背景にある理由は、現在のプログラムを、これらのキーワードを使用することを禁止することによって、将来のバージョンのRustと上位互換にすることです。

> <!--**<sup>Lexer</sup>** \ KW_ABSTRACT: `abstract` \ KW_BECOME: `become` \ KW_BOX: `box` \ KW_DO: `do` \ KW_FINAL: `final` \ KW_MACRO: `macro` \ KW_OVERRIDE: `override` \ KW_PRIV: `priv` \ KW_TYPEOF: `typeof` \ KW_UNSIZED: `unsized` \ KW_VIRTUAL: `virtual` \ KW_YIELD: `yield`-->
> **<SUP>レクサー</ SUP>** \ KW_ABSTRACT： `abstract` \のKW_BECOME： `become` \ KW_BOX： `box`の\ KW_DO： `do` \ KW_FINALを： `final` \のKW_MACRO： `macro`の\ KW_OVERRIDE： `override`：\ KW_PRIV `priv` \ KW_TYPEOF： `typeof` \ KW_UNSIZED： `unsized` \ KW_VIRTUAL： `virtual` \ KW_YIELD： `yield`

## <!--Weak keywords--> 弱いキーワード

<!--These keywords have special meaning only in certain contexts.-->
これらのキーワードは、特定のコンテキストでのみ特別な意味を持ちます。
<!--For example, it is possible to declare a variable or method with the name `union`.-->
たとえば、名前`union`持つ変数またはメソッドを宣言することは可能です。

* <!--`union` is used to declare a [union] and is only a keyword when used in a union declaration.-->
   `union`は、[union]を宣言するために使用され、union宣言で使用される場合にのみキーワードになります。
* <!--`'static` is used for the static lifetime and cannot be used as a generic lifetime parameter-->
   `'static`は静的有効期間に使用され、一般的な有効期間パラメータとして使用することはできません

<!--` ``compile_fail // error[E0262]: invalid lifetime parameter name: `'static` fn invalid_lifetime_parameter<'static>(s: &'static str) -> &'static str { s }`` `*` dyn `denotes a [trait object] and is a keyword when used in a type position followed by a path that does not start with`::`.-->
` ``compile_fail // error[E0262]: invalid lifetime parameter name: `'static` fn invalid_lifetime_parameter<'static>(s: &'static str) -> &'static str { s }`` `*` dyn `denotes a [trait object] and is a keyword when used in a type position followed by a path that does not start with`:: ` `denotes a [trait object] and is a keyword when used in a type position followed by a path that does not start with`です。

> <!--**<sup>Lexer</sup>** \ KW_UNION: `union` \ KW_STATICLIFETIME: `'static` \ KW_DYN: `dyn`-->
> **<sup> Lexer </ sup>** \ KW_UNION： `union` \ KW_STATICLIFETIME： `'static` \ KW_DYN： `dyn`

<!--[items]: items.html
 [Variables]: variables.html
 [Type parameters]: types.html#type-parameters
 [loop labels]: expressions/loop-expr.html#loop-labels
 [Macros]: macros.html
 [attributes]: attributes.html
 [Macro placholders]: macros-by-example.html
 [Crates]: crates-and-source-files.html
 [union]: items/unions.html
 [variants]: items/enumerations.html
 [trait object]: types.html#trait-objects
-->
[items]: items.html
 [Variables]: variables.html
 [Type parameters]: types.html#type-parameters
 [loop labels]: expressions/loop-expr.html#loop-labels
 [Macros]: macros.html
 [attributes]: attributes.html
 [Macro placholders]: macros-by-example.html
 [Crates]: crates-and-source-files.html
 [union]: items/unions.html
 [variants]: items/enumerations.html
 [trait object]: types.html#trait-objects

