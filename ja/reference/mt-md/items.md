# <!--Items--> アイテム

<!--An  _item_  is a component of a crate.-->
 _アイテム_ はクレートのコンポーネントです。
<!--Items are organized within a crate by a nested set of [modules].-->
アイテムは、[modules]ネストされたセットによってクレート内に編成され[modules]。
<!--Every crate has a single "outermost"anonymous module;-->
すべての箱には、一番外側の匿名モジュールが1つあります。
<!--all further items within the crate have [paths] within the module tree of the crate.-->
クレート内の他のすべてのアイテムは、クレートのモジュールツリー内に[paths]持ち[paths]。

<!--[modules]: items/modules.html
 [paths]: paths.html
-->
[modules]: items/modules.html
 [paths]: paths.html


<!--Items are entirely determined at compile-time, generally remain fixed during execution, and may reside in read-only memory.-->
項目はコンパイル時に完全に決定され、一般に実行中は固定されたままであり、読み取り専用メモリに存在する可能性があります。

<!--There are several kinds of items:-->
いくつかの種類のアイテムがあります：

* [modules](items/modules.html)
* <!--[`extern crate` declarations](items/extern-crates.html)-->
   [`extern crate`宣言](items/extern-crates.html)
* <!--[`use` declarations](items/use-declarations.html)-->
   [宣言を`use`](items/use-declarations.html)
* <!--[function definitions](items/functions.html)-->
   [関数定義](items/functions.html)
* <!--[type definitions](items/type-aliases.html)-->
   [型定義](items/type-aliases.html)
* <!--[struct definitions](items/structs.html)-->
   [構造体定義](items/structs.html)
* <!--[enumeration definitions](items/enumerations.html)-->
   [列挙型の定義](items/enumerations.html)
* <!--[union definitions](items/unions.html)-->
   [組合の定義](items/unions.html)
* <!--[constant items](items/constant-items.html)-->
   [定数項目](items/constant-items.html)
* <!--[static items](items/static-items.html)-->
   [静的なアイテム](items/static-items.html)
* <!--[trait definitions](items/traits.html)-->
   [形質の定義](items/traits.html)
* [implementations](items/implementations.html)
* <!--[`extern` blocks](items/external-blocks.html)-->
   [`extern`ブロック](items/external-blocks.html)

<!--Some items form an implicit scope for the declaration of sub-items.-->
一部の項目は、サブ項目の宣言のための暗黙のスコープを形成します。
<!--In other words, within a function or module, declarations of items can (in many cases) be mixed with the statements, control blocks, and similar artifacts that otherwise compose the item body.-->
言い換えれば、ある関数またはモジュール内で、項目の宣言は、多くの場合、項目本体を構成する文、制御ブロック、および類似の成果物と混在することができます。
<!--The meaning of these scoped items is the same as if the item was declared outside the scope &mdash;-->
これらのスコープ付きアイテムの意味は、アイテムがスコープ外で宣言された場合と同じです。
<!--it is still a static item &mdash;-->
それはまだ静的なアイテムです。
<!--except that the item's *path name* within the module namespace is qualified by the name of the enclosing item, or is private to the enclosing item (in the case of functions).-->
モジュール名前空間内の項目の*パス名*が、囲む項目の名前で修飾されているか、（関数の場合には）包含する項目に対して非公開です。
<!--The grammar specifies the exact locations in which sub-item declarations may appear.-->
文法は、サブ項目宣言が現れる正確な場所を指定します。
