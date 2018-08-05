# <!--Incremental compilation--> インクリメンタルコンパイル

<!--The incremental compilation scheme is, in essence, a surprisingly simple extension to the overall query system.-->
インクリメンタルコンパイルスキームは、本質的には、全体的なクエリシステムに対する驚くほど単純な拡張です。
<!--We'll start by describing a slightly simplified variant of the real thing – the "basic algorithm"– and then describe some possible improvements.-->
実際のもののやや簡略化された変形 -基本的なアルゴリズム -を説明し、いくつかの改善点を説明します。

## <!--The basic algorithm--> 基本的なアルゴリズム

<!--The basic algorithm is called the **red-green** algorithm [^salsa].-->
基本的なアルゴリズムは**赤緑**アルゴリズム[^salsa]と呼ばれます。
<!--The high-level idea is that, after each run of the compiler, we will save the results of all the queries that we do, as well as the **query DAG**.-->
高レベルのアイデアは、コンパイラを実行するたびに、私たちが行うすべてのクエリの結果と**クエリDAG**を保存するということです。
<!--The **query DAG** is a [DAG] that indexes which queries executed which other queries.-->
**問合せDAG**は、どの問合せが他の問合せを実行したかを索引付けする[DAG]です。
<!--So, for example, there would be an edge from a query Q1 to another query Q2 if computing Q1 required computing Q2 (note that because queries cannot depend on themselves, this results in a DAG and not a general graph).-->
たとえば、Q1の計算にQ2の計算が必要な場合（つまり、クエリがそれ自体に依存しないため、これはDAGで一般的なグラフではないことに注意してください）、クエリQ1から別のクエリQ2へのエッジがあります。

[DAG]: https://en.wikipedia.org/wiki/Directed_acyclic_graph

<!--On the next run of the compiler, then, we can sometimes reuse these query results to avoid re-executing a query.-->
コンパイラの次回の実行時には、クエリの再実行を避けるために、これらのクエリ結果を再利用することがあります。
<!--We do this by assigning every query a **color**:-->
これは、すべてのクエリに**色を**割り当てることで行います。

- <!--If a query is colored **red**, that means that its result during this compilation has **changed** from the previous compilation.-->
   クエリーが**赤**で表示されている場合は、このコンパイル時の結果が前のコンパイルから**変更さ**れたことを意味します。
- <!--If a query is colored **green**, that means that its result is the **same** as the previous compilation.-->
   クエリーが**緑色**で表示されている場合は、その結果が以前のコンパイル**と同じ**であることを意味します。

<!--There are two key insights here:-->
ここには2つの重要な洞察があります：

- <!--First, if all the inputs to query Q are colored green, then the query Q **must** result in the same value as last time and hence need not be re-executed (or else the compiler is not deterministic).-->
   まず、問合せQのすべての入力が緑色に着色されている場合、問合せQ **は**前回と同じ値になるため、再実行する必要はありません（そうでなければ、コンパイラは確定的ではありません）。
- <!--Second, even if some inputs to a query changes, it may be that it-->
   第2に、クエリへの入力の一部が変更されたとしても、それが
<!--**still** produces the same result as the previous compilation.-->
**まだ**前のコンパイルと同じ結果を生成します。
<!--In particular, the query may only use part of its input.-->
特に、クエリは入力の一部しか使用できません。
<!---Therefore, after executing a query, we always check whether it produced the same result as the previous time.-->
-したがって、クエリを実行した後、前回と同じ結果が得られたかどうかを常にチェックします。
<!--**If it did,** we can still mark the query as green, and hence avoid re-executing dependent queries.-->
**そうした場合**でも、依然としてクエリを緑色にマークして、従属クエリの再実行を避けることができます。

### <!--The try-mark-green algorithm--> try-mark-greenアルゴリズム

<!--At the core of incremental compilation is an algorithm called "try-mark-green".-->
インクリメンタルコンパイルの中核には、"try-mark-green"と呼ばれるアルゴリズムがあります。
<!--It has the job of determining the color of a given query Q (which must not have yet been executed).-->
与えられたクエリーQ（まだ実行されていてはならない）の色を決定する作業をしています。
<!--In cases where Q has red inputs, determining Q's color may involve re-executing Q so that we can compare its output, but if all of Q's inputs are green, then we can conclude that Q must be green without re-executing it or inspecting its value at all.-->
Qが赤の入力を持つ場合、Qの色を決定するにはQを再実行してその出力を比較することができますが、Qの入力がすべて緑であれば、Qを再実行せずに緑にする必要があります。その価値はまったくありません。
<!--In the compiler, this allows us to avoid deserializing the result from disk when we don't need it, and in fact enables us to sometimes skip *serializing* the result as well (see the refinements section below).-->
コンパイラでは、これにより、必要のないときにディスクから結果を逆シリアル化することを避けることができます。実際には結果を*シリアライズ*することもできます（下記の詳細セクションを参照してください）。

<!--Try-mark-green works as follows:-->
Try-mark-greenは次のように動作します。

- <!--First check if the query Q was executed during the previous compilation.-->
   まず、前回のコンパイル時にクエリQが実行されたかどうかを確認します。
  - <!--If not, we can just re-execute the query as normal, and assign it the color of red.-->
     そうでない場合は、通常どおりクエリを再実行し、赤の色を割り当てます。
- <!--If yes, then load the 'dependent queries' of Q.-->
   「はい」の場合は、「依存クエリ」を読み込みます。
- <!--If there is a saved result, then we load the `reads(Q)` vector from the query DAG.-->
   保存された結果がある場合は、クエリDAGから`reads(Q)`ベクトルを`reads(Q)`ます。
<!--The "reads"is the set of queries that Q executed during its execution.-->
   「読み込み」は、実行中にQが実行したクエリのセットです。
  - <!--For each query R in `reads(Q)`, we recursively demand the color of R using try-mark-green.-->
     `reads(Q)`各クエリRについて、私たちはtry-mark-greenを使ってRの色を再帰的に要求します。
    - <!--Note: it is important that we visit each node in `reads(Q)` in same order as they occurred in the original compilation.-->
       注：元のコンパイルで発生したのと同じ順序で、各ノードを`reads(Q)`に移動することが重要です。
<!--See [the section on the query DAG below](#dag).-->
       [以下のクエリDAGのセクションを](#dag)参照してください。
    - <!--If **any** of the nodes in `reads(Q)` wind up colored **red**, then Q is dirty.-->
       `reads(Q)`ノードの**いずれか**が**赤色**に着色して**いる**場合、Qは汚れています。
      - <!--We re-execute Q and compare the hash of its result to the hash of the result from the previous compilation.-->
         Qを再実行し、その結果のハッシュを前のコンパイル結果のハッシュと比較します。
      - <!--If the hash has not changed, we can mark Q as **green** and return.-->
         ハッシュ値が変更されていない場合は、Qを**緑色に**マークして戻ることができます。
    - <!--Otherwise, **all** of the nodes in `reads(Q)` must be **green**.-->
       それ以外の場合は、`reads(Q)`ノードは**すべて** **緑色で**なければなりません。
<!--In that case, we can color Q as **green** and return.-->
       その場合、私たちはQを**緑色に**して返します。

<span id="dag"></span>
### <!--The query DAG--> クエリDAG

<!--The query DAG code is stored in [`src/librustc/dep_graph`][dep_graph].-->
クエリDAGコードは[`src/librustc/dep_graph`][dep_graph]格納されます。
<!--Construction of the DAG is done by instrumenting the query execution.-->
DAGの構築は、クエリの実行を計測することによって行われます。

<!--One key point is that the query DAG also tracks ordering;-->
1つの重要な点は、クエリDAGも順序付けを追跡することです。
<!--that is, for each query Q, we not only track the queries that Q reads, we track the **order** in which they were read.-->
つまり、各クエリQに対して、Qが読み取るクエリを追跡するだけでなく、読み取られた**順序**を追跡します。
<!--This allows try-mark-green to walk those queries back in the same order.-->
これにより、try-mark-greenはそれらのクエリを同じ順序で戻すことができます。
<!--This is important because once a subquery comes back as red, we can no longer be sure that Q will continue along the same path as before.-->
サブクエリが赤色に戻ると、以前と同じパスでQが続行されることがなくなるため、これは重要です。
<!--That is, imagine a query like this:-->
つまり、次のようなクエリを想像してみてください。

```rust,ignore
fn main_query(tcx) {
    if tcx.subquery1() {
        tcx.subquery2()
    } else {
        tcx.subquery3()
    }
}
```

<!--Now imagine that in the first compilation, `main_query` starts by executing `subquery1`, and this returns true.-->
今、最初のコンパイルで、`main_query`が`subquery1`を実行することによって開始し、これがtrueを返すと想像してください。
<!--In that case, the next query `main_query` executes will be `subquery2`, and `subquery3` will not be executed at all.-->
その場合、次のクエリ`main_query`は`subquery2`になり、`subquery3`はまったく実行されません。

<!--But now imagine that in the **next** compilation, the input has changed such that `subquery1` returns **false**.-->
しかし、今度は、**次の**コンパイルで入力が変更され、`subquery1`が**falseを**返すと想像してください。
<!--In this case, `subquery2` would never execute.-->
この場合、`subquery2`は決して実行されません。
<!--If try-mark-green were to visit `reads(main_query)` out of order, however, it might visit `subquery2` before `subquery1`, and hence execute it.-->
try-mark-greenが`reads(main_query)`を順不同で訪れた場合、`subquery2`前の`subquery1`にアクセスして実行する可能性があります。
<!--This can lead to ICEs and other problems in the compiler.-->
これにより、ICEやコンパイラのその他の問題が発生する可能性があります。

[dep_graph]: https://github.com/rust-lang/rust/tree/master/src/librustc/dep_graph

## <!--Improvements to the basic algorithm--> 基本的なアルゴリズムの改善

<!--In the description of the basic algorithm, we said that at the end of compilation we would save the results of all the queries that were performed.-->
基本的なアルゴリズムの説明では、コンパイルの最後に、実行されたすべてのクエリの結果を保存すると述べました。
<!--In practice, this can be quite wasteful – many of those results are very cheap to recompute, and serializing and deserializing them is not a particular win.-->
実際には、これは非常に無駄かもしれません。それらの結果の多くは再計算するのに非常に安価であり、シリアライズとデシリアライズは特別な勝利ではありません。
<!--In practice, what we would do is to save **the hashes** of all the subqueries that we performed.-->
実際には、実行したすべてのサブクエリの**ハッシュ**を保存することです。
<!--Then, in select cases, we **also** save the results.-->
次に、選択されたケースでは、結果**も**保存します。

<!--This is why the incremental algorithm separates computing the **color** of a node, which often does not require its value, from computing the **result** of a node.-->
これは、増分アルゴリズムが、ノードの**結果**を計算する**こと**から、しばしばその値を必要としないノードの**色**の計算を分離する理由です。
<!--Computing the result is done via a simple algorithm like so:-->
結果を計算するには、次のような簡単なアルゴリズムを使用します。

- <!--Check if a saved result for Q is available.-->
   Qの保存結果が利用可能かどうかを確認してください。
<!--If so, compute the color of Q. If Q is green, deserialize and return the saved result.-->
   そうであれば、Qの色を計算します.Qが緑の場合は、デシリアライズして保存した結果を返します。
- <!--Otherwise, execute Q.-->
   そうでなければ、Qを実行します
  - <!--We can then compare the hash of the result and color Q as green if it did not change.-->
     次に、結果のハッシュと色Qが変更されていない場合は緑色を比較することができます。

# <!--Footnotes--> 脚注

[^salsa]: I%20have%20long%20wanted%20to%20rename%20it%20to%20the%20Salsa%20algorithm,%20but%20it%20never%20caught%20on.%20-@nikomatsakis
