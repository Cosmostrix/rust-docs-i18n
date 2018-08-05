# <!--Lowering--> 低下

<!--The lowering step converts AST to [HIR](hir.html).-->
下降段階は、ASTを[HIR](hir.html)変換する。
<!--This means many structures are removed if they are irrelevant for type analysis or similar syntax agnostic analyses.-->
これは、型分析やそれに類似した構文に依存しない分析とは無関係な場合、多くの構造が削除されることを意味します。
<!--Examples of such structures include but are not limited to-->
そのような構造の例には、

* <!--Parenthesis-->
   括弧
    * <!--Removed without replacement, the tree structure makes order explicit-->
       置き換えずに削除されたツリー構造は、順序を明示的にします
* <!--`for` loops and `while (let)` loops-->
   `for`ループと`while (let)`ループ
    * <!--Converted to `loop` + `match` and some `let` bindings-->
       `loop` + `match`といくつかの`let`バインディングに変換されました
* `if let`
    * <!--Converted to `match`-->
       `match`変換されまし`match`
* <!--Universal `impl Trait`-->
   ユニバーサル`impl Trait`
    * <!--Converted to generic arguments (but with some flags, to know that the user didn't write them)-->
       一般的な引数に変換されます（しかし、ユーザーがそれらを記述していないことを知るためにフラグがいくつかあります）
* <!--Existential `impl Trait`-->
   存在する`impl Trait`
    * <!--Converted to a virtual `existential type` declaration-->
       仮想`existential type`宣言に変換されました

<!--Lowering needs to uphold several invariants in order to not trigger the sanity checks in `src/librustc/hir/map/hir_id_validator.rs`:-->
`src/librustc/hir/map/hir_id_validator.rs`のサニティチェックを起動しないために、いくつかの不変条件を維持する必要があります。

1. <!--A `HirId` must be used if created.-->
    作成された場合、`HirId`使用する必要があります。
<!--So if you use the `lower_node_id`, you *must* use the resulting `NodeId` or `HirId` (either is fine, since any `NodeId` s in the `HIR` are checked for existing `HirId` s)-->
    したがって、`lower_node_id`を使用する場合は、結果の`NodeId`または`HirId`使用する*必要*が*あり*ます（`HIR`内の`NodeId`は既存の`HirId`チェックされるため、どちらでも`HirId`ん）
2. <!--Lowering a `HirId` must be done in the scope of the *owning* item.-->
    `HirId`下げることは、*所有*アイテムの範囲内で行われなければならない。
<!--This means you need to use `with_hir_id_owner` if you are creating parts of another item than the one being currently lowered.-->
    つまり、現在下げているアイテム以外のアイテムの一部を作成する場合は、`with_hir_id_owner`を使用する必要があります。
<!--This happens for example during the lowering of existential `impl Trait`-->
    これは、例えば、存在する`impl Trait`低下中に起こる
3. <!--A `NodeId` that will be placed into a HIR structure must be lowered, even if its `HirId` is unused.-->
    その`HirId`が使用されていなくても、HIR構造に配置される`NodeId`を下げる必要があります。
<!--Calling `let _ = self.lower_node_id(node_id);`-->
    `let _ = self.lower_node_id(node_id);`呼び出し`let _ = self.lower_node_id(node_id);`
<!--is perfectly legitimate.-->
    完全に合法です。
4. <!--If you are creating new nodes that didn't exist in the `AST`, you *must* create new ids for them.-->
    `AST`に存在しなかった新しいノードを作成する場合は、新しいノードを作成する*必要*が*あり*ます。
<!--This is done by calling the `next_id` method, which produces both a new `NodeId` as well as automatically lowering it for you so you also get the `HirId`.-->
    これは、呼び出しによって行われます`next_id`新しい両方の生成方法、`NodeId`だけでなく、あなたも得るように自動的にあなたのためにそれを下げる`HirId`。

<!--If you are creating new `DefId` s, since each `DefId` needs to have a corresponding `NodeId`, it is adviseable to add these `NodeId` s to the `AST` so you don't have to generate new ones during lowering.-->
新しい`DefId`を作成する場合、各`DefId`対応する`NodeId`が必要であるため、これらの`NodeId`を`AST`に追加して、下げる際に新しい`NodeId`を生成する必要はありません。
<!--This has the advantage of creating a way to find the `DefId` of something via its `NodeId`.-->
これは`NodeId`を介して何かの`DefId`を見つける方法を作り出すという利点があります。
<!--If lowering needs this `DefId` in multiple places, you can't generate a new `NodeId` in all those places because you'd also get a new `DefId` then.-->
この`DefId`を複数の場所で下げる必要がある場合は、新しい`DefId`取得するため、これらの場所に新しい`NodeId`を生成することはできません。
<!--With a `NodeId` from the `AST` this is not an issue.-->
`AST` `NodeId`では、これは問題ではありません。

<!--Having the `NodeId` also allows the `DefCollector` to generate the `DefId` s instead of lowering having to do it on the fly.-->
`NodeId`を持つことで、`DefCollector`は`DefCollector`に実行する必要が`DefId`、 `DefCollector`を生成することができます。
<!--Centralizing the `DefId` generation in one place makes it easier to refactor and reason about.-->
`DefId`ジェネレーションを1か所に`DefId`することで、リファクタリングや理由の`DefId`容易になります。
