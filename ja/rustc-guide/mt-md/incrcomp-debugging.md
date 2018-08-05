# <!--Debugging and Testing Dependencies--> 依存性のデバッグとテスト

## <!--Testing the dependency graph--> 依存グラフのテスト

<!--There are various ways to write tests against the dependency graph.-->
依存グラフに対してテストを書くにはさまざまな方法があります。
<!--The simplest mechanisms are the `#[rustc_if_this_changed]` and `#[rustc_then_this_would_need]` annotations.-->
最も簡単なメカニズムは`#[rustc_if_this_changed]`と`#[rustc_then_this_would_need]`アノテーションです。
<!--These are used in compile-fail tests to test whether the expected set of paths exist in the dependency graph.-->
これらはコンパイル・フェイル・テストで使用され、予想されるパス・セットが依存関係グラフに存在するかどうかをテストします。
<!--As an example, see `src/test/compile-fail/dep-graph-caller-callee.rs`.-->
例として、`src/test/compile-fail/dep-graph-caller-callee.rs`参照してください。

<!--The idea is that you can annotate a test like:-->
考え方は、次のようなテストに注釈を付けることができるということです。

```rust,ignore
#[rustc_if_this_changed]
fn foo() { }

#[rustc_then_this_would_need(TypeckTables)] //~ ERROR OK
fn bar() { foo(); }

#[rustc_then_this_would_need(TypeckTables)] //~ ERROR no path
fn baz() { }
```

<!--This will check whether there is a path in the dependency graph from `Hir(foo)` to `TypeckTables(bar)`.-->
これは、`Hir(foo)`から`TypeckTables(bar)`までの依存関係グラフにパスがあるかどうかをチェックし`TypeckTables(bar)`。
<!--An error is reported for each `#[rustc_then_this_would_need]` annotation that indicates whether a path exists.-->
パスが存在するかどうかを示す`#[rustc_then_this_would_need]`アノテーションごとにエラーが報告されます。
<!--`//~ ERROR` annotations can then be used to test if a path is found (as demonstrated above).-->
`//~ ERROR`アノテーションを使用して、パスが見つかったかどうかをテストすることができます（上記のように）。

## <!--Debugging the dependency graph--> 依存グラフのデバッグ

### <!--Dumping the graph--> グラフをダンプする

<!--The compiler is also capable of dumping the dependency graph for your debugging pleasure.-->
コンパイラは、デバッグの喜びのために依存関係グラフをダンプすることもできます。
<!--To do so, pass the `-Z dump-dep-graph` flag.-->
これを行うには、`-Z dump-dep-graph`フラグを渡します。
<!--The graph will be dumped to `dep_graph.{txt,dot}` in the current directory.-->
グラフは現在のディレクトリの`dep_graph.{txt,dot}`にダンプされます。
<!--You can override the filename with the `RUST_DEP_GRAPH` environment variable.-->
ファイル名は`RUST_DEP_GRAPH`環境変数で上書きできます。

<!--Frequently, though, the full dep graph is quite overwhelming and not particularly helpful.-->
しかし、しばしば、完全なdepグラフは非常に圧倒的であり、特に有用ではない。
<!--Therefore, the compiler also allows you to filter the graph.-->
したがって、コンパイラではグラフをフィルタリングすることもできます。
<!--You can filter in three ways:-->
次の3つの方法でフィルタリングできます。

1. <!--All edges originating in a particular set of nodes (usually a single node).-->
    すべてのエッジは特定のノードセット（通常は単一のノード）で発生します。
2. <!--All edges reaching a particular set of nodes.-->
    すべてのエッジが特定のノードセットに到達します。
3. <!--All edges that lie between given start and end nodes.-->
    与えられた開始ノードと終了ノードの間にあるすべてのエッジ。

<!--To filter, use the `RUST_DEP_GRAPH_FILTER` environment variable, which should look like one of the following:-->
フィルタリングするには、`RUST_DEP_GRAPH_FILTER`環境変数を使用します。これは次のようになります。

```text
#//source_filter     // nodes originating from source_filter
source_filter     //  source_filterに由来するノード
#//-> target_filter  // nodes that can reach target_filter
-> target_filter  //  target_filterに到達できるノード
#//source_filter -> target_filter // nodes in between source_filter and target_filter
source_filter -> target_filter //  source_filterとtarget_filterの間のノード
```

<!--`source_filter` and `target_filter` are a `&` -separated list of strings.-->
`source_filter`と`target_filter`は、文字列の`&`分離されたリストです。
<!--A node is considered to match a filter if all of those strings appear in its label.-->
これらの文字列がすべてそのラベルに含まれている場合、ノードはフィルタと一致するとみなされます。
<!--So, for example:-->
したがって、たとえば：

```text
RUST_DEP_GRAPH_FILTER='-> TypeckTables'
```

<!--would select the predecessors of all `TypeckTables` nodes.-->
すべての`TypeckTables`ノードの`TypeckTables`を選択します。
<!--Usually though you want the `TypeckTables` node for some particular fn, so you might write:-->
通常、`TypeckTables`ノードには特定のfnが必要ですが、次のように書くこともできます：

```text
RUST_DEP_GRAPH_FILTER='-> TypeckTables & bar'
```

<!--This will select only the predecessors of `TypeckTables` nodes for functions with `bar` in their name.-->
これにより、名前に`bar`が付いている関数の`TypeckTables`ノードの先行`TypeckTables`のみが選択されます。

<!--Perhaps you are finding that when you change `foo` you need to re-type-check `bar`, but you don't think you should have to.-->
おそらく、あなたが`foo`を変更するときに、あなたは再チェック・`bar`チェックする必要があると思っていますが、そうする必要はないと思っているかもしれません。
<!--In that case, you might do:-->
その場合は、次のようにします。

```text
RUST_DEP_GRAPH_FILTER='Hir & foo -> TypeckTables & bar'
```

<!--This will dump out all the nodes that lead from `Hir(foo)` to `TypeckTables(bar)`, from which you can (hopefully) see the source of the erroneous edge.-->
これにより、`Hir(foo)`から`TypeckTables(bar)`に至るすべてのノードが`TypeckTables(bar)`、そこから誤ったエッジの原因を（できれば）見ることができます。

### <!--Tracking down incorrect edges--> 間違ったエッジをトラッキングする

<!--Sometimes, after you dump the dependency graph, you will find some path that should not exist, but you will not be quite sure how it came to be.-->
場合によっては、依存関係グラフをダンプした後に、存在してはいけないいくつかのパスを見つけることができますが、どのようになっているのかは分かりません。
<!--**When the compiler is built with debug assertions,** it can help you track that down.-->
**コンパイラがデバッグアサーションでビルドされると、**それを追跡するのに役立ちます。
<!--Simply set the `RUST_FORBID_DEP_GRAPH_EDGE` environment variable to a filter.-->
`RUST_FORBID_DEP_GRAPH_EDGE`環境変数をフィルタに設定するだけです。
<!--Every edge created in the dep-graph will be tested against that filter – if it matches, a `bug!` is reported, so you can easily see the backtrace (`RUST_BACKTRACE=1`).-->
デプログラフで作成されたすべてのエッジは、そのフィルタに対してテストされます。一致すると`bug!`がレポートされるので、バックトレース（`RUST_BACKTRACE=1`）を簡単に表示できます。

<!--The syntax for these filters is the same as described in the previous section.-->
これらのフィルタの構文は、前のセクションで説明したものと同じです。
<!--However, note that this filter is applied to every **edge** and doesn't handle longer paths in the graph, unlike the previous section.-->
ただし、このフィルタはすべての**エッジに**適用され、前のセクションとは異なり、グラフの長いパスは処理されません。

<!--Example:-->
例：

<!--You find that there is a path from the `Hir` of `foo` to the type check of `bar` and you don't think there should be.-->
あなたは`foo`の`Hir`から`bar`のタイプチェックまでの道があり、そこにあるはずはないと思っています。
<!--You dump the dep-graph as described in the previous section and open `dep-graph.txt` to see something like:-->
前のセクションで説明したように`dep-graph.txt`をダンプし、dep `dep-graph.txt`を開いて次のように表示します。

```text
Hir(foo) -> Collect(bar)
Collect(bar) -> TypeckTables(bar)
```

<!--That first edge looks suspicious to you.-->
その最初のエッジはあなたに疑わしい。
<!--So you set `RUST_FORBID_DEP_GRAPH_EDGE` to `Hir&foo -> Collect&bar`, re-run, and then observe the backtrace.-->
したがって、`RUST_FORBID_DEP_GRAPH_EDGE`を`Hir&foo -> Collect&bar` `RUST_FORBID_DEP_GRAPH_EDGE` `Hir&foo -> Collect&bar`に設定して再実行し、バックトレースを観察します。
<!--Voila, bug fixed!-->
Voila、バグ修正！
