# <!--An Overview of Chalk--> チョークの概要

> <!--Chalk is under heavy development, so if any of these links are broken or if any of the information is inconsistent with the code or outdated, please [open an issue][rustc-issues] so we can fix it.-->
> チョークは大きく発展しているため、これらのリンクのいずれかが壊れている場合や、情報のいずれかがコードと矛盾しているか、古くなった場合は[、問題][rustc-issues]を修正して修正することができます。
> <!--If you are able to fix the issue yourself, we would love your contribution!-->
> あなた自身で問題を解決できる場合は、あなたの貢献が大好きです！

<!--[Chalk][chalk] recasts Rust's trait system explicitly in terms of logic programming by "lowering"Rust code into a kind of logic program we can then execute queries against.-->
[Chalk][chalk] Rustの特性システムを論理プログラミングの観点から明示的に作り直します.Rustコードを一種の論理プログラムに「引き下げ」して、クエリを実行します。
<!--(See [*Lowering to Logic*][lowering-to-logic] and [*Lowering Rules*][lowering-rules]) Its goal is to be an executable, highly readable specification of the Rust trait system.-->
（[*論理*][lowering-to-logic]への[*下げとルールの*][lowering-rules] [*下げを*][lowering-to-logic]参照してください）その目標は、Rust特性システムの実行可能で読みやすい仕様です。

<!--There are many expected benefits from this work.-->
この作業には多くの期待される利点があります。
<!--It will consolidate our existing, somewhat ad-hoc implementation into something far more principled and expressive, which should behave better in corner cases, and be much easier to extend.-->
既存の、多少のアドホックな実装を、はるかに原則的かつ表現力豊かなものに統合し、コーナーケースではより良く動作し、拡張がはるかに容易になるはずです。

## <!--Resources--> リソース

* <!--[Chalk Source Code](https://github.com/rust-lang-nursery/chalk)-->
   [チョークソースコード](https://github.com/rust-lang-nursery/chalk)
* <!--[Chalk Glossary](https://github.com/rust-lang-nursery/chalk/blob/master/GLOSSARY.md)-->
   [チョーク用語集](https://github.com/rust-lang-nursery/chalk/blob/master/GLOSSARY.md)
* <!--The traits section of the rustc guide (you are here)-->
   rustcガイドの特徴セクション（ここにいる）

### <!--Blog Posts--> ブログ投稿

* <!--[Lowering Rust traits to logic](http://smallcultfollowing.com/babysteps/blog/2017/01/26/lowering-rust-traits-to-logic/)-->
   [錆特性をロジックに下げる](http://smallcultfollowing.com/babysteps/blog/2017/01/26/lowering-rust-traits-to-logic/)
* <!--[Unification in Chalk, part 1](http://smallcultfollowing.com/babysteps/blog/2017/03/25/unification-in-chalk-part-1/)-->
   [チョークでの統一、パート1](http://smallcultfollowing.com/babysteps/blog/2017/03/25/unification-in-chalk-part-1/)
* <!--[Unification in Chalk, part 2](http://smallcultfollowing.com/babysteps/blog/2017/04/23/unification-in-chalk-part-2/)-->
   [チョークでの統一、パート2](http://smallcultfollowing.com/babysteps/blog/2017/04/23/unification-in-chalk-part-2/)
* <!--[Negative reasoning in Chalk](http://aturon.github.io/blog/2017/04/24/negative-chalk/)-->
   [チョークにおける否定的推論](http://aturon.github.io/blog/2017/04/24/negative-chalk/)
* <!--[Query structure in chalk](http://smallcultfollowing.com/babysteps/blog/2017/05/25/query-structure-in-chalk/)-->
   [チョークのクエリ構造](http://smallcultfollowing.com/babysteps/blog/2017/05/25/query-structure-in-chalk/)
* <!--[Cyclic queries in chalk](http://smallcultfollowing.com/babysteps/blog/2017/09/12/tabling-handling-cyclic-queries-in-chalk/)-->
   [チョークでの循環クエリ](http://smallcultfollowing.com/babysteps/blog/2017/09/12/tabling-handling-cyclic-queries-in-chalk/)
* <!--[An on-demand SLG solver for chalk](http://smallcultfollowing.com/babysteps/blog/2018/01/31/an-on-demand-slg-solver-for-chalk/)-->
   [チョーク用のオンデマンドSLGソルバー](http://smallcultfollowing.com/babysteps/blog/2018/01/31/an-on-demand-slg-solver-for-chalk/)

## <!--Parsing--> 解析

<!--Chalk is designed to be incorporated with the Rust compiler, so the syntax and concepts it deals with heavily borrow from Rust.-->
チョークはRustコンパイラに組み込まれるように設計されているので、Rustから多額の借用を行うシンタックスとコンセプトがあります。
<!--It is convenient for the sake of testing to be able to run chalk on its own, so chalk includes a parser for a Rust-like syntax.-->
テストのためにチョークを単独で実行できるようにすると便利です。チョークには、錆のような構文のパーサが含まれています。
<!--This syntax is orthogonal to the Rust AST and grammar.-->
この構文は、錆ASTと文法に直交しています。
<!--It is not intended to look exactly like it or support the exact same syntax.-->
正確に同じように見えるか、まったく同じ構文をサポートすることを意図していません。

<!--The parser takes that syntax and produces an [Abstract Syntax Tree (AST)][ast].-->
パーサーはその構文を取り、[抽象構文木（AST）][ast]を生成します。
<!--You can find the [complete definition of the AST][chalk-ast] in the source code.-->
[ASTの完全な定義は][chalk-ast]ソースコードで見つけることができます。

<!--The syntax contains things from Rust that we know and love, for example: traits, impls, and struct definitions.-->
シンタックスには、Rustの知っているものや愛しているものが含まれています。例えば、特性、impls、構造体の定義です。
<!--Parsing is often the first "phase"of transformation that a program goes through in order to become a format that chalk can understand.-->
解析は、しばしば、チョークが理解できる形式になるために、プログラムが通過する最初の「段階」の変換です。

## <!--Lowering--> 低下

<!--After parsing, there is a "lowering"phase.-->
解析後、「低下」段階があります。
<!--This aims to convert traits/impls into "program clauses".-->
これは、形質/ implsを「プログラム条項」に変換することを目的としています。
<!--A [`ProgramClause` (source code)][programclause] is essentially one of the following:-->
[`ProgramClause`（ソースコード）][programclause]は、基本的に次のいずれかです。

* <!--A [clause] of the form `consequence :- conditions` where `:-` is read as "if"and `conditions = cond1 && cond2 && ...`-->
   `consequence :- conditions`の形式の[clause] `consequence :- conditions` `:-` "if"と`conditions = cond1 && cond2 && ...`として読み込まれ`conditions = cond1 && cond2 && ...`
* <!--A universally quantified clause of the form `forall<T> { consequence :- conditions }`-->
   `forall<T> { consequence :- conditions }`という形式の普遍的な定量節は、
  * <!--`forall<T> { ... }` is used to represent [universal quantification].-->
     `forall<T> { ... }`は、[universal quantification]を表すために使用されます。
<!--See the section on [Lowering to logic][lowering-forall] for more information.-->
     詳細については、[ロジック][lowering-forall]への[下位][lowering-forall]節を参照してください。
  * <!--A key thing to note about `forall` is that we don't allow you to "quantify"over traits, only types and regions (lifetimes).-->
     注意すべき重要なこと`forall`、我々はあなたが形質のみのタイプと地域（寿命）の上に、「定量化」することはできませんということです。
<!--That is, you can't make a rule like `forall<Trait> { u32: Trait }` which would say "`u32` implements all traits".-->
     つまり、`forall<Trait> { u32: Trait }`ようなルールを作ることはできません`forall<Trait> { u32: Trait }`これは "`u32`がすべての特性を実装する"ということです。
<!--You can however say `forall<T> { T: Trait }` meaning "`Trait` is implemented by all types".-->
     しかし、`forall<T> { T: Trait }`は、"`Trait`はすべての型で実装されている"という意味です。
  * <!--`forall<T> { ... }` is represented in the code using the [`Binders<T>` struct][binders-struct].-->
     `forall<T> { ... }`は、[`Binders<T>`構造体][binders-struct]を使用してコード内に表されます。

<!--*See also: [Goals and Clauses][goals-and-clauses]*-->
*参照：[目標と節] [目標と節]*

<!--Lowering is the phase where we encode the rules of the trait system into logic.-->
下降は、形質システムのルールを論理にエンコードするフェーズです。
<!--For example, if we have the following Rust:-->
たとえば、次のようなRustがあるとします。

```rust,ignore
impl<T: Clone> Clone for Vec<T> {}
```

<!--We generate the following program clause:-->
次のプログラム句を生成します。

```rust,ignore
forall<T> { (Vec<T>: Clone) :- (T: Clone) }
```

<!--This rule dictates that `Vec<T>: Clone` is only satisfied if `T: Clone` is also satisfied (ie "provable").-->
このルールは、`Vec<T>: Clone`は`T: Clone`も満たされている場合（つまり「証明可能」）のみ満たされることを指示します。

### <!--Well-formedness checks--> 整形式チェック

<!--As part of lowering from the AST to the internal IR, we also do some "well formedness"checks.-->
ASTから内部IRへの引き下げの一環として、我々はまた「整形式」チェックを行う。
<!--See the [source code][well-formedness-checks] for where those are done.-->
それらがどこで行われたかの[ソースコード][well-formedness-checks]を参照してください。
<!--The call to `record_specialization_priorities` checks "coherence"which means that it ensures that two impls of the same trait for the same type cannot exist.-->
`record_specialization_priorities`の呼び出しは、「コヒーレンス」をチェックします。つまり、同じタイプの同じ特性の2つのインプリメントが存在しないことを保証します。

## <!--Intermediate Representation (IR)--> 中間表現（IR）

<!--The second intermediate representation in chalk is called, well, the "ir".-->
チョークの第2中間表現は、「ir」と呼ばれます。
<!--:) The [IR source code][ir-code] contains the complete definition.-->
:) [IRソースコード][ir-code]には完全な定義が含まれています。
<!--The `ir::Program` struct contains some "rust things"but indexed and accessible in a different way.-->
`ir::Program`構造体には「錆びるもの」がいくつか含まれていますが、索引付けされ、別の方法でアクセス可能です。
<!--This is sort of analogous to the [HIR] in Rust.-->
これはRustの[HIR]に似ています。

<!--For example, if you have a type like `Foo<Bar>`, we would represent `Foo` as a string in the AST but in `ir::Program`, we use numeric indices (`ItemId`).-->
たとえば、`Foo<Bar>`ようなタイプの場合、`Foo`をASTの文字列として表しますが、`ir::Program`では数字のインデックス（`ItemId`）を使用します。

<!--In addition to `ir::Program` which has "rust-like things", there is also `ir::ProgramEnvironment` which is "pure logic".-->
`ir::Program`加えて、"rust-likeなもの"を持つ`ir::ProgramEnvironment`には、"pure logic"である`ir::ProgramEnvironment`もあります。
<!--The main field in that struct is `program_clauses` which contains the `ProgramClause` s that we generated previously.-->
その構造体の主なフィールドは、以前に生成した`ProgramClause`を含む`program_clauses`です。

## <!--Rules--> ルール

<!--The `rules` module works by iterating over every trait, impl, etc. and emitting the rules that come from each one.-->
`rules`モジュールは、あらゆる特性、インプレスなどを反復し、それぞれから来るルールを放出することによって機能します。
<!--See [Lowering Rules][lowering-rules] for the most up-to-date reference on that.-->
参照[ルールを下げる][lowering-rules]ことに関する最新の参照のために。

<!--The `ir::ProgramEnvironment` is created [in this module][rules-environment].-->
[このモジュールで][rules-environment] `ir::ProgramEnvironment`が作成さ[れます][rules-environment]。

## <!--Testing--> テスト

<!--TODO: Basically, [there is a macro](https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/solve/test.rs#L112-L148) that will take chalk's Rust-like syntax and run it through the full pipeline described above.-->
TODO：基本的[には、](https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/solve/test.rs#L112-L148)チョークのRustのような構文をとり、上で説明した完全なパイプラインを通して実行[するマクロがあり](https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/solve/test.rs#L112-L148)ます。
<!--[This](https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/solve/test.rs#L83-L110) is the function that is ultimately called.-->
[This](https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/solve/test.rs#L83-L110)は最終的に呼び出される関数です。

## <!--Solver--> ソルバー

<!--See [The SLG Solver][slg].-->
[The SLG Solverを][slg]参照してください。

<!--[rustc-issues]: https://github.com/rust-lang-nursery/rustc-guide/issues
 [chalk]: https://github.com/rust-lang-nursery/chalk
 [lowering-to-logic]: traits/lowering-to-logic.html
 [lowering-rules]: traits/lowering-rules.html
 [ast]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
 [chalk-ast]: https://github.com/rust-lang-nursery/chalk/blob/master/chalk-parse/src/ast.rs
 [universal quantification]: https://en.wikipedia.org/wiki/Universal_quantification
 [lowering-forall]: ./traits/lowering-to-logic.html#type-checking-generic-functions-beyond-horn-clauses
 [programclause]: https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/ir.rs#L721
 [clause]: https://github.com/rust-lang-nursery/chalk/blob/master/GLOSSARY.md#clause
 [goals-and-clauses]: ./traits/goals-and-clauses.html
 [well-formedness-checks]: https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/ir/lowering.rs#L230-L232
 [ir-code]: https://github.com/rust-lang-nursery/chalk/blob/master/src/ir.rs
 [HIR]: hir.html
 [binders-struct]: https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/ir.rs#L661
 [rules-environment]: https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/rules.rs#L9
 [slg]: ./traits/slg.html
-->
[rustc-issues]: https://github.com/rust-lang-nursery/rustc-guide/issues
 [chalk]: https://github.com/rust-lang-nursery/chalk
 [lowering-to-logic]: traits/lowering-to-logic.html
 [lowering-rules]: traits/lowering-rules.html
 [ast]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
 [chalk-ast]: https://github.com/rust-lang-nursery/chalk/blob/master/chalk-parse/src/ast.rs
 [universal quantification]: https://en.wikipedia.org/wiki/Universal_quantification
 [lowering-forall]: ./traits/lowering-to-logic.html#type-checking-generic-functions-beyond-horn-clauses
 [programclause]: https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/ir.rs#L721
 [clause]: https://github.com/rust-lang-nursery/chalk/blob/master/GLOSSARY.md#clause
 [goals-and-clauses]: ./traits/goals-and-clauses.html
 [well-formedness-checks]: https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/ir/lowering.rs#L230-L232
 [ir-code]: https://github.com/rust-lang-nursery/chalk/blob/master/src/ir.rs
 [HIR]: hir.html
 [binders-struct]: https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/ir.rs#L661
 [rules-environment]: https://github.com/rust-lang-nursery/chalk/blob/94a1941a021842a5fcb35cd043145c8faae59f08/src/rules.rs#L9
 [slg]: ./traits/slg.html

