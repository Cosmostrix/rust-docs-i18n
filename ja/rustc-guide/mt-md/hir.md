# <!--The HIR--> HIR

<!--The HIR – "High-Level Intermediate Representation"– is the primary IR used in most of rustc.-->
HIR -「高レベル中間表現」 -ほとんどの錆びた部分に使用される主なIRです。
<!--It is a compiler-friendly representation of the abstract syntax tree (AST) that is generated after parsing, macro expansion, and name resolution (see [Lowering](./lowering.html) for how the HIR is created).-->
それはパースした後に生成された抽象構文木（AST）、マクロ展開、および名前解決（参照のコンパイラにやさしい表現で[Lowering](./lowering.html) HIRを作成する方法については）。
<!--Many parts of HIR resemble Rust surface syntax quite closely, with the exception that some of Rust's expression forms have been desugared away.-->
HIRの多くの部分は、Rustの表現形式のいくつかが削除されていることを除いて、Rustサーフェイスのシンタックスに非常によく似ています。
<!--For example, `for` loops are converted into a `loop` and do not appear in the HIR.-->
例えば、`for`ループに変換され`loop`とHIRには表示されません。
<!--This makes HIR more amenable to analysis than a normal AST.-->
これにより、HIRは通常のASTよりも解析が行いやすくなります。

<!--This chapter covers the main concepts of the HIR.-->
この章では、HIRの主な概念について説明します。

<!--You can view the HIR representation of your code by passing the `-Zunpretty=hir-tree` flag to rustc:-->
`-Zunpretty=hir-tree`フラグをrustcに渡すことで、コードのHIR表現を表示できます。

```bash
> cargo rustc -- -Zunpretty=hir-tree
```

### <!--Out-of-band storage and the `Crate` type--> アウトオブバンドストレージと`Crate`タイプ

<!--The top-level data-structure in the HIR is the `Crate`, which stores the contents of the crate currently being compiled (we only ever construct HIR for the current crate).-->
HIRのトップレベルのデータ構造は、現在コンパイルされているクレートの内容を格納する`Crate`（現在のクレートのHIRのみを構築しています）。
<!--Whereas in the AST the crate data structure basically just contains the root module, the HIR `Crate` structure contains a number of maps and other things that serve to organize the content of the crate for easier access.-->
ASTでは、クレートデータ構造には基本的にルートモジュールのみが含まれていますが、HIR `Crate`構造には、`Crate`の内容を整理して簡単にアクセスできるようにするためのマップやその他の要素が数多く含まれています。

<!--For example, the contents of individual items (eg modules, functions, traits, impls, etc) in the HIR are not immediately accessible in the parents.-->
例えば、HIR内の個々の項目（モジュール、機能、特性、インプラントなど）の内容は、親からすぐにアクセスできません。
<!--So, for example, if there is a module item `foo` containing a function `bar()`:-->
したがって、たとえば、関数`bar()`を含むモジュール項目`foo`がある場合は、次のようになります。

```rust
mod foo {
    fn bar() { }
}
```

<!--then in the HIR the representation of module `foo` (the `Mod` stuct) would only have the **`ItemId`** `I` of `bar()`.-->
HIRでは、モジュール`foo`（ `Mod` stuct）の**表現**は`bar()` **`ItemId`** `I`しか持たないでしょう。
<!--To get the details of the function `bar()`, we would lookup `I` in the `items` map.-->
関数`bar()`の詳細を取得する`I`は、`items`マップで`I`を検索します。

<!--One nice result from this representation is that one can iterate over all items in the crate by iterating over the key-value pairs in these maps (without the need to trawl through the whole HIR).-->
この表現の良い結果の1つは、これらのマップ内のキーと値のペアを反復することによって、木枠内のすべてのアイテムを繰り返し処理できることです（HIR全体をトラックする必要はありません）。
<!--There are similar maps for things like trait items and impl items, as well as "bodies"(explained below).-->
特性項目やインプット項目、「ボディ」（以下で説明します）のようなものについても同様のマップがあります。

<!--The other reason to set up the representation this way is for better integration with incremental compilation.-->
このように表現を設定するもう1つの理由は、インクリメンタル・コンパイルとのより良い統合のためです。
<!--This way, if you gain access to an `&hir::Item` (eg for the mod `foo`), you do not immediately gain access to the contents of the function `bar()`.-->
こうすると、`&hir::Item`（mod `foo`）にアクセスすると、すぐに関数`bar()`内容にアクセスすることはできません。
<!--Instead, you only gain access to the **id** for `bar()`, and you must invoke some function to lookup the contents of `bar()` given its id;-->
代わりに、あなただけの**ID**へのアクセスを得る`bar()`、そしてあなたは、内容ルックアップするために、いくつかの機能を呼び出す必要があります`bar()`そのID与えられました。
<!--this gives the compiler a chance to observe that you accessed the data for `bar()`, and then record the dependency.-->
これにより、コンパイラは`bar()`データにアクセスしたことを観察し、依存関係を記録することができます。

<span id="hir-id"></span>
### <!--Identifiers in the HIR--> HIRの識別子

<!--Most of the code that has to deal with things in HIR tends not to carry around references into the HIR, but rather to carry around *identifier numbers* (or just "ids").-->
HIRのものを扱わなければならないコードのほとんどは、HIRへの参照を持ち越すのではなく、むしろ*識別子番号*（または単に "ids"）を持ち歩く傾向があります。
<!--Right now, you will find four sorts of identifiers in active use:-->
現在、4種類の識別子がアクティブに使用されています。

- <!--`DefId`, which primarily names "definitions"or top-level items.-->
   `DefId`。主に「定義」またはトップレベルの項目に名前を付けます。
  - <!--You can think of a `DefId` as being shorthand for a very explicit and complete path, like `std::collections::HashMap`.-->
     `DefId`は、`std::collections::HashMap`ような非常に明示的で完全なパスの省略形であると考えることができます。
<!--However, these paths are able to name things that are not nameable in normal Rust (eg impls), and they also include extra information about the crate (such as its version number, as two versions of the same crate can co-exist).-->
     しかし、これらのパスは、通常のRust（例えばimpls）では名前を付けられないものに名前を付けることができ、また、クレートに関する追加情報（同じクレートの2つのバージョンが共存できるバージョン番号など）も含みます。
  - <!--A `DefId` really consists of two parts, a `CrateNum` (which identifies the crate) and a `DefIndex` (which indixes into a list of items that is maintained per crate).-->
     `DefId`実際には`CrateNum`（クレートを識別する）と`DefIndex`（クレートごとに維持されるアイテムのリストに示される）の2つの部分で構成されます。
- <!--`HirId`, which combines the index of a particular item with an offset within that item.-->
   `HirId`は、特定のアイテムのインデックスとそのアイテム内のオフセットを結合します。
  - <!--the key point of a `HirId` is that it is *relative* to some item (which is named via a `DefId`).-->
     `HirId`は、それが（`DefId`を介して命名された）いくつかのアイテムに*関連*していることです。
- <!--`BodyId`, this is an absolute identifier that refers to a specific body (definition of a function or constant) in the crate.-->
   `BodyId`、これは、クレート内の特定のボディ（関数または定数の定義）を参照する絶対的な識別子です。
<!--It is currently effectively a "newtype'd"`NodeId`.-->
   これは現在、事実上「newtype'd」 `NodeId`です。
- <!--`NodeId`, which is an absolute id that identifies a single node in the HIR tree.-->
   `NodeId`：HIRツリー内の単一のノードを識別する絶対的なIDです。
  - <!--While these are still in common use, **they are being slowly phased out**.-->
     これらはまだ一般的に使用**されてい**ます**が、徐々に段階的に廃止されてい**ます。
  - <!--Since they are absolute within the crate, adding a new node anywhere in the tree causes the `NodeId` s of all subsequent code in the crate to change.-->
     ツリー内のどこにでも新しいノードを追加すると、クレート内のすべての後続コードの`NodeId`が変更されます。
<!--This is terrible for incremental compilation, as you can perhaps imagine.-->
     あなたが想像することができるように、これは増分コンパイルにとってひどいことです。

### <!--The HIR Map--> HIRマップ

<!--Most of the time when you are working with the HIR, you will do so via the **HIR Map**, accessible in the tcx via `tcx.hir` (and defined in the `hir::map` module).-->
ほとんどの場合、HIRで作業しているときは、tcx.hir経由で`tcx.hir`でアクセス可能な**HIRマップ**を使用します（`hir::map`モジュールで定義されています）。
<!--The HIR map contains a number of methods to convert between IDs of various kinds and to lookup data associated with an HIR node.-->
HIRマップは、様々な種類のID間で変換し、HIRノードに関連するデータを検索するための多数の方法を含む。

<!--For example, if you have a `DefId`, and you would like to convert it to a `NodeId`, you can use `tcx.hir.as_local_node_id(def_id)`.-->
たとえば、`DefId`を持っていて`NodeId`に変換したい場合は、`tcx.hir.as_local_node_id(def_id)`使用できます。
<!--This returns an `Option<NodeId>` – this will be `None` if the def-id refers to something outside of the current crate (since then it has no HIR node), but otherwise returns `Some(n)` where `n` is the node-id of the definition.-->
これは、戻り`Option<NodeId>` -これはないであろう`None` DEF-idは（それは全くHIRノードを有していないので）、現在のクレートの外部の何かを指し、それ以外を返した場合`Some(n)`ここで`n`のノードIDであります定義。

<!--Similarly, you can use `tcx.hir.find(n)` to lookup the node for a `NodeId`.-->
同様に、`tcx.hir.find(n)`を使用して`NodeId`ノードをルックアップできます。
<!--This returns a `Option<Node<'tcx>>`, where `Node` is an enum defined in the map;-->
これは`Option<Node<'tcx>>`返します。ここで、`Node`はマップで定義されたenumです。
<!--by matching on this you can find out what sort of node the node-id referred to and also get a pointer to the data itself.-->
これを照合することでnode-idが参照しているノードの種類を知ることができ、データ自体へのポインタも取得できます。
<!--Often, you know what sort of node `n` is – eg if you know that `n` must be some HIR expression, you can do `tcx.hir.expect_expr(n)`, which will extract and return the `&hir::Expr`, panicking if `n` is not in fact an expression.-->
多くの場合、あなたはノードの種類を知っている`n`ある-あなたがいることを知っていれば例えば`n`、いくつかのHIR式でなければなりません、あなたが行うことができます`tcx.hir.expect_expr(n)`抽出して返します、`&hir::Expr`た場合パニック、`n`あるが実際に表現ではありません。

<!--Finally, you can use the HIR map to find the parents of nodes, via calls like `tcx.hir.get_parent_node(n)`.-->
最後に、HIRマップを使用して、`tcx.hir.get_parent_node(n)`ような呼び出しによってノードの親を見つけることができます。

### <!--HIR Bodies--> HIR機関

<!--A **body** represents some kind of executable code, such as the body of a function/closure or the definition of a constant.-->
**本体は、**そのような機能/クロージャの本体又は定数の定義として、実行可能コードのいくつかの種類を表します。
<!--Bodies are associated with an **owner**, which is typically some kind of item (eg an `fn()` or `const`), but could also be a closure expression (eg `|x, y| x + y`).-->
ボディは、通常、ある種のアイテム（例えば`fn()`や`const`）であるが、クロージャ式（例えば、 `|x, y| x + y`）であってもよい、 **オーナー**に関連付けられている。
<!--You can use the HIR map to find the body associated with a given def-id (`maybe_body_owned_by()`) or to find the owner of a body (`body_owner_def_id()`).-->
指定したDEF-IDに関連付けられた本体を見つけるために、HIRマップを使用することができる（`maybe_body_owned_by()`または身体の所有者を見つけるために（`body_owner_def_id()`
