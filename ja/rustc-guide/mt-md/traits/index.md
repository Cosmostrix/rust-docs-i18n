# <!--Trait solving (new-style)--> 特性解法（新スタイル）

<!--🚧 This chapter describes "new-style"trait solving.-->
🚧この章では、「新しいスタイル」の特性解決について説明します。
<!--This is still in the [process of being implemented][wg];-->
これはまだ[実施中][wg]です。
<!--this chapter serves as a kind of in-progress design document.-->
この章は、進行中の設計ドキュメントの一種として機能します。
<!--If you would prefer to read about how the current trait solver works, check out [this other chapter](./traits/resolution.html).-->
現在の形質ソルバーの仕組みについては、[この他の章を参照してください](./traits/resolution.html)。
<!--(By the way, if you would like to help in hacking on the new solver, you will find instructions for getting involved in the [Traits Working Group tracking issue][wg].) 🚧-->
（ところで、新しいソルバのハッキングを手助けしたい場合は、[Traitsワーキンググループの追跡に関する問題に][wg]取り組むための手順を参照してください）。🚧

[wg]: https://github.com/rust-lang/rust/issues/48416

<!--Trait solving is based around a few key ideas:-->
特性の解決は、いくつかの重要なアイデアに基づいています。

- <!--[Lowering to logic](./traits/lowering-to-logic.html), which expresses Rust traits in terms of standard logical terms.-->
   標準的な論理用語の観点からRust特性を表現[する論理](./traits/lowering-to-logic.html)に[下げる](./traits/lowering-to-logic.html)。
  - <!--The [goals and clauses](./traits/goals-and-clauses.html) chapter describes the precise form of rules we use, and [lowering rules](./traits/lowering-rules.html) gives the complete set of lowering rules in a more reference-like form.-->
     [目標と節で](./traits/goals-and-clauses.html)は、使用する規則の正確な形式について説明し、規則を[下げること](./traits/lowering-rules.html)は、参照のような形式で完全な規則の集合を提供します。
- <!--[Canonical queries](./traits/canonical-queries.html), which allow us to solve trait problems (like "is `Foo` implemented for the type `Bar`?") once, and then apply that same result independently in many different inference contexts.-->
   [カノニカルクエリは](./traits/canonical-queries.html)、特性問題（「 `Bar`型のために`Foo`実装されていますか？」など）を一度解き、多くの異なる推論コンテキストで同じ結果を独立して適用することを可能にします。
- <!--[Lazy normalization](./traits/associated-types.html), which is the technique we use to accommodate associated types when figuring out whether types are equal.-->
   [レイジー正規化](./traits/associated-types.html)は、型が等しいかどうかを判断する際に関連する型を扱うために使用する技法です。
<!---[Region constraints](./traits/regions.html), which are accumulated during trait solving but mostly ignored.-->
-特性[制約の](./traits/regions.html)間に蓄積されるが、ほとんど無視される[領域制約](./traits/regions.html)。
<!--This means that trait solving effectively ignores the precise regions involved, always – but we still remember the constraints on them so that those constraints can be checked by thet type checker.-->
これは、特性解法が関与する正確な領域を効果的に無視することを意味しますが、これらの制約が型検査器によって検査できるように、それらの制約を覚えています。
<!--Note: this is not a complete list of topics.-->
注：これはトピックの完全なリストではありません。
<!--See the sidebar for more.-->
詳細については、サイドバーを参照してください。
