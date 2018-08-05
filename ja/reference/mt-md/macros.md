# <!--Macros--> マクロ

<!--A number of minor features of Rust are not central enough to have their own syntax, and yet are not implementable as functions.-->
Rustのマイナーな機能の多くは、独自の構文を持つためには十分ではありませんが、機能としては実装できません。
<!--Instead, they are given names, and invoked through a consistent syntax: `some_extension!(...)`.-->
代わりに、名前が与えられ、一貫した構文`some_extension!(...)`によって呼び出されます。

<!--There are two ways to define new macros:-->
新しいマクロを定義する方法は2つあります。

* <!--[Macros by Example] define new syntax in a higher-level, declarative way.-->
   [Macros by Example]新しい構文をより高いレベルで宣言的に定義します。
* <!--[Procedural Macros] can be used to implement custom derive.-->
   [Procedural Macros]は、カスタム派生を実装するために使用できます。

<!--[Macros by Example]: macros-by-example.html
 [Procedural Macros]: procedural-macros.html
 [compiler plugins]: ../unstable-book/language-features/plugin.html
-->
[Procedural Macros]: procedural-macros.html
 [compiler plugins]: ../unstable-book/language-features/plugin.html
 [Macros by Example]: macros-by-example.html
 [Procedural Macros]: procedural-macros.html

