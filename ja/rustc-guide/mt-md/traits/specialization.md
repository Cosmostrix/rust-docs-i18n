# <!--Specialization--> 専門分野

<!--**TODO**: where does Chalk fit in?-->
**TODO**：チョークはどこに収まるの？
<!--Should we mention/discuss it here?-->
ここでそれについて言及/議論すべきか？

<!--Defined in the `specialize` module.-->
`specialize`モジュールで定義されて`specialize`ます。

<!--The basic strategy is to build up a *specialization graph* during coherence checking (recall that coherence checking looks for overlapping impls).-->
基本的な戦略は、コヒーレンスチェック中に*特殊化グラフ*を作成すること*です*（コヒーレンスチェックでは、インバートのインプレッションが検索されます）。
<!--Insertion into the graph locates the right place to put an impl in the specialization hierarchy;-->
グラフに挿入すると、特殊化階層にimplを配置する適切な場所が見つけられます。
<!--if there is no right place (due to partial overlap but no containment), you get an overlap error.-->
適切な場所がない場合（部分的な重なりはあるが閉じ込めがないため）、重複エラーが発生します。
<!--Specialization is consulted when selecting an impl (of course), and the graph is consulted when propagating defaults down the specialization hierarchy.-->
インプリメンテーションを選択すると、スペシャライゼーションが参照され、デフォルトをスペシャライゼーション階層に伝播するときにグラフが参照されます。

<!--You might expect that the specialization graph would be used during selection – ie when actually performing specialization.-->
スペシャライゼーショングラフは、選択中、つまり実際にスペシャライゼーションを実行するときに使用されることが期待されます。
<!--This is not done for two reasons:-->
これには2つの理由があります。

- <!--It's merely an optimization: given a set of candidates that apply, we can determine the most specialized one by comparing them directly for specialization, rather than consulting the graph.-->
   単なる最適化であり、適用候補のセットを与えられた場合、グラフを参照するのではなく、専門化のために直接比較することで、最も専門化された候補を特定できます。
<!--Given that we also cache the results of selection, the benefit of this optimization is questionable.-->
   選択結果をキャッシュすると、この最適化の利点は疑問です。

- <!--To build the specialization graph in the first place, we need to use selection (because we need to determine whether one impl specializes another).-->
   特殊化グラフを最初に構築するには、selectionを使用する必要があります（あるimplが別のimplを専門にするかどうかを判断する必要があるため）。
<!--Dealing with this reentrancy would require some additional mode switch for selection.-->
   このリエントラントを扱うには、選択のためにいくつかの追加のモードスイッチが必要です。
<!--Given that there seems to be no strong reason to use the graph anyway, we stick with a simpler approach in selection, and use the graph only for propagating default implementations.-->
   とにかくグラフを使用する強い理由がないと考えられるので、我々は選択においてより簡単なアプローチを採用し、デフォルトの実装を伝播するためにのみグラフを使用する。

<!--Trait impl selection can succeed even when multiple impls can apply, as long as they are part of the same specialization family.-->
同じ専門化ファミリーの一部である限り、複数のimplを適用することができる場合でも、Traitのimpl選択は成功する可能性があります。
<!--In that case, it returns a *single* impl on success – this is the most specialized impl *known* to apply.-->
その場合、成功した場合は*単一の*インプリメンテーションが返されます。これが適用さ*れる*最も特化されたインプットです。
<!--However, if there are any inference variables in play, the returned impl may not be the actual impl we will use at trans time.-->
しかし、演奏中に推論変数がある場合、返されるimplは、trans時に使用される実際のimplではない可能性があります。
<!--Thus, we take special care to avoid projecting associated types unless either (1) the associated type does not use `default` and thus cannot be overridden or (2) all input types are known concretely.-->
したがって、（1）関連付けられた型が`default`を使用せず、したがってオーバーライドできないか、または（2）すべての入力型が具体的に知られている場合を除いて、関連型を投影することを避けるために特別な注意が必要`default`。
