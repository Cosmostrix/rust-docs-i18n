# <!--Canonicalization--> 正規化

<!--Canonicalization is the process of **isolating** an inference value from its context.-->
正規化は、推論値をそのコンテキストから**分離**するプロセスです。
<!--It is a key part of implementing [canonical queries][cq], and you may wish to read the parent chapter to get more context.-->
これは[標準的なクエリ][cq]を実装するための重要な部分であり、より多くの文脈を得るために親の章を読むことをお勧めします。

<!--Canonicalization is really based on a very simple concept: every [inference variable](./type-inference.html#vars) is always in one of two states: either it is **unbound**, in which case we don't know yet what type it is, or it is **bound**, in which case we do.-->
正則化は実際には非常に単純な概念に基づいてい[ます](./type-inference.html#vars)。すべての[推論変数](./type-inference.html#vars)は常に2つの状態のいずれかにあります。それは**束縛さ**れていないか、どちらの型かそれとも**束縛され**ているかはわかりません。
<!--So to isolate some data-structure T that contains types/regions from its environment, we just walk down and find the unbound variables that appear in T;-->
したがって、その環境から型/領域を含むデータ構造体Tを分離するために、Tに現れる非束縛変数を探して見つけます。
<!--those variables get replaced with "canonical variables", starting from zero and numbered in a fixed order (left to right, for the most part, but really it doesn't matter as long as it is consistent).-->
これらの変数は、ゼロから始まり、固定された順序で番号が付けられた（「大部分は左から右へ」という番号の）「標準変数」に置き換えられますが、実際は一貫していれば問題ありません。

[cq]: ./traits/canonical-queries.html

<!--So, for example, if we have the type `X = (?T, ?U)`, where `?T` and `?U` are distinct, unbound inference variables, then the canonical form of `X` would be `(?0, ?1)`, where `?0` and `?1` represent these **canonical placeholders**.-->
我々がタイプしている場合ので、例えば、`X = (?T, ?U)` `?T`し、`?U`その後の正規形、別個の、未結合の推論変数で`X`だろう`(?0, ?1)`ここで`?0`と`?1`はこれらの**カノニカルプレースホルダを**表す。
<!--Note that the type `Y = (?U, ?T)` also canonicalizes to `(?0, ?1)`.-->
タイプことに注意してください`Y = (?U, ?T)`も正規化する`(?0, ?1)`
<!--But the type `Z = (?T, ?T)` would canonicalize to `(?0, ?0)` (as would `(?U, ?U)`).-->
しかしタイプ`Z = (?T, ?T)`に正規化であろう`(?0, ?0)`同じように`(?U, ?U)`
<!--In other words, the exact identity of the inference variables is not important – unless they are repeated.-->
言い換えれば、推論変数の正確なアイデンティティーは重要ではありません。

<!--We use this to improve caching as well as to detect cycles and other things during trait resolution.-->
これを使用して、キャッシュを改善するとともに、特性の決定時にサイクルやその他のものを検出します。
<!--Roughly speaking, the idea is that if two trait queries have the same canonicalize form, then they will get the same answer.-->
おおまかに言えば、2つの特性クエリーが同じ正規化フォームを持つ場合、同じ回答が得られるという考え方です。
<!--That answer will be expressed in terms of the canonical variables (`?0`, `?1`), which we can then map back to the original variables (`?T`, `?U`).-->
その答えは正準変数（`?0`、 `?1`）の形で表現され、元の変数（ `?T`、 `?U`）に戻すことができます。

## <!--Canonicalizing the query--> クエリの正規化

<!--To see how it works, imagine that we are asking to solve the following trait query: `?A: Foo<'static, ?B>`, where `?A` and `?B` are unbound.-->
どのように動作するかを見るために、以下の特性クエリを解くように求めていると想像してください： `?A: Foo<'static, ?B>` `?A`と`?B`は非結合です。
<!--This query contains two unbound variables, but it also contains the lifetime `'static`.-->
このクエリには2つのバインドされていない変数が含まれていますが、ライフタイム`'static`変数も含まれてい`'static`。
<!--The trait system generally ignores all lifetimes and treats them equally, so when canonicalizing, we will *also* replace any [free lifetime](./appendix/background.html#free-vs-bound) with a canonical variable.-->
トレイトシステムは、一般的に、すべての寿命を無視し、平等に扱いますので、canonicalizingとき、我々は*また*、任意の置き換えます[自由寿命を](./appendix/background.html#free-vs-bound)正準変数で。
<!--Therefore, we get the following result:-->
したがって、次の結果が得られます。

```text
?0: Foo<'?1, ?2>
```

<!--Sometimes we write this differently, like so:-->
時にはこれを次のように書きます：

```text
for<T,L,T> { ?0: Foo<'?1, ?2> }
```

<!--This `for<>` gives some information about each of the canonical variables within.-->
これ`for<>`に対して、それぞれの正準変数についての情報を提供します。
<!--In this case, each `T` indicates a type variable, so `?0` and `?2` are types;-->
この場合、各`T`は型変数を示すので、`?0`と`?2`は型です。
<!--the `L` indicates a lifetime varibale, so `?1` is a lifetime.-->
`L`生涯varibaleを示し、そう`?1`寿命です。
<!--The `canonicalize` method *also* gives back a `CanonicalVarValues` array OV with the "original values"for each canonicalized variable:-->
`canonicalize`方法は*また*、バック与える`CanonicalVarValues`各正規化変数の「元の値」と配列OVました：

```text
[?A, 'static, ?B]
```

<!--We'll need this vector OV later, when we process the query response.-->
クエリ応答を処理するときに、このベクトルOVが後で必要になります。

## <!--Executing the query--> クエリの実行

<!--Once we've constructed the canonical query, we can try to solve it.-->
標準クエリを作成したら、それを解決しようとすることができます。
<!--To do so, we will wind up creating a fresh inference context and **instantiating** the canonical query in that context.-->
そのためには、新しい推論コンテキストを作成し、そのコンテキストで標準クエリを**インスタンス化**することになります。
<!--The idea is that we create a substitution S from the canonical form containing a fresh inference variable (of suitable kind) for each canonical variable.-->
考え方は、それぞれの正準変数に対して（適切な種類の）新鮮な推論変数を含むカノニカルフォームから置換Sを作成することです。
<!--So, for our example query:-->
したがって、サンプルクエリでは、次のようになります。

```text
for<T,L,T> { ?0: Foo<'?1, ?2> }
```

<!--the substitution S might be:-->
置換Sは次のようになります。

```text
S = [?A, '?B, ?C]
```

<!--We can then replace the bound canonical variables (`?0`, etc) with these inference variables, yielding the following fully instantiated query:-->
次に、結合された標準変数（`?0`など）をこれらの推論変数に置き換えて、完全にインスタンス化された次のクエリを生成することができます。

```text
?A: Foo<'?B, ?C>
```

<!--Remember that substitution S though!-->
代用Sを忘れないで！
<!--We're going to need it later.-->
私たちは後でそれを必要とします。

<!--OK, now that we have a fresh inference context and an instantiated query, we can go ahead and try to solve it.-->
これで新しい推論コンテキストとインスタンス化されたクエリができたので、これを解決しようとします。
<!--The trait solver itself is explained in more detail in [another section](./traits/slg.html), but suffice to say that it will compute a [certainty value][cqqr] (`Proven` or `Ambiguous`) and have side-effects on the inference variables we've created.-->
特性ソルバー自体については、[別のセクション](./traits/slg.html)で詳しく説明しますが、[確実性値][cqqr]（ `Proven`または`Ambiguous`）を計算し、作成した推論変数に副作用があるといっても過言ではありません。
<!--For example, if there were only one impl of `Foo`, like so:-->
たとえば、`Foo`インプリメントが1つだけだった場合、次のようになります。

[cqqr]: ./traits/canonical-queries.html#query-response

```rust,ignore
impl<'a, X> Foo<'a, X> for Vec<X>
where X: 'a
{ ... }
```

<!--then we might wind up with a certainty value of `Proven`, as well as creating fresh inference variables `'?D` and `?E` (to represent the parameters on the impl) and unifying as follows:-->
`Proven`確からしさを念頭に置いて、新たな推論変数`'?D`と`?E`（implのパラメータを表現するために） `'?D`を作り、次のように統一するかもしれない：

- `'?B = '?D`
- `?A = Vec<?E>`
- `?C = ?E`

<!--We would also accumulate the region constraint `?E: '?D`, due to the where clause.-->
また、where句のために、領域制約`?E: '?D`累積します。

<!--In order to create our final query result, we have to "lift"these values out of the query's inference context and into something that can be reapplied in our original inference context.-->
最終的なクエリ結果を作成するためには、これらの値をクエリの推論コンテキストから元の推論コンテキストに再適用できるものに「持ち上げる」必要があります。
<!--We do that by **re-applying canonicalization**, but to the **query result**.-->
これは、**正規化を再適用することで**行い**ます**が、**クエリ結果に** **適用**し**ます**。

## <!--Canonicalizing the query result--> クエリ結果の正規化

<!--As discussed in [the parent section][cqqr], most trait queries wind up with a result that brings together a "certainty value"`certainty`, a result substitution `var_values`, and some region constraints.-->
[親セクション][cqqr]で説明し[た][cqqr]ように、ほとんどの特性クエリは、「確実性値」 `certainty`、結果置換`var_values`、および一部の領域制約を`var_values`た結果を`var_values`ます。
<!--To create this, we wind up re-using the substitution S that we created when first instantiating our query.-->
これを作成するために、最初にクエリをインスタンス化するときに作成した置換Sを再利用します。
<!--To refresh your memory, we had a query-->
あなたの記憶をリフレッシュするために、

```text
for<T,L,T> { ?0: Foo<'?1, ?2> }
```

<!--for which we made a substutition S:-->
それに対して私たちは副義を作ったS：

```text
S = [?A, '?B, ?C]
```

<!--We then did some work which unified some of those variables with other things.-->
その後、これらの変数のいくつかを他のものと統合した作業を行いました。
<!--If we "refresh"S with the latest results, we get:-->
最新の結果をSに反映させると、次のようになります。

```text
S = [Vec<?E>, '?D, ?E]
```

<!--These are precisely the new values for the three input variables from our original query.-->
これらは、元のクエリの3つの入力変数の新しい値です。
<!--Note though that they include some new variables (like `?E`).-->
ただし、それらにはいくつかの新しい変数（「 `?E`）が含まれています。
<!--We can make those go away by canonicalizing again!-->
私たちはもう一度canonicalizingすることによってそれらを去らせることができます！
<!--We don't just canonicalize S, though, we canonicalize the whole query response QR:-->
Sを正規化するだけではありませんが、クエリ応答QR全体を正規化します。

```text
QR = {
#//    certainty: Proven,             // or whatever
    certainty: Proven,             // または何でも
#//    var_values: [Vec<?E>, '?D, ?E] // this is S
    var_values: [Vec<?E>, '?D, ?E] // これはSです
#//    region_constraints: [?E: '?D], // from the impl
    region_constraints: [?E: '?D], // インプラントから
#//    value: (),                     // for our purposes, just (), but
#                                   // in some cases this might have
#                                   // a type or other info
    value: (),                     // 私たちの目的のためには、just（）ですが、場合によっては型やその他の情報
}
```

<!--The result would be as follows:-->
結果は次のようになります。

```text
Canonical(QR) = for<T, L> {
    certainty: Proven,
    var_values: [Vec<?0>, '?1, ?2]
    region_constraints: [?2: '?1],
    value: (),
}
```

<!--(One subtle point: when we canonicalize the query **result**, we do not use any special treatment for free lifetimes. Note that both references to `'?D`, for example, were converted into the same canonical variable (`?1`). This is in contrast to the original query, where we canonicalized every free lifetime into a fresh canonical variable.)-->
（1つの微妙な点：クエリの**結果**を正規化するとき、フリーライフタイムには特別な扱いはしません。たとえば、`'?D`両方の参照は同じ標準変数（`?1`）に変換されています。すべてのフリーライフを正規の新しい変数に正規化した元のクエリとは対照的です）。

<!--Now, this result must be reapplied in each context where needed.-->
さて、この結果は、必要に応じてそれぞれの文脈で再適用しなければなりません。

## <!--Processing the canonicalized query result--> 正規化されたクエリ結果の処理

<!--In the previous section we produced a canonical query result.-->
前のセクションでは、標準クエリ結果を作成しました。
<!--We now have to apply that result in our original context.-->
その結果を元の文脈で適用する必要があります。
<!--If you recall, way back in the beginning, we were trying to prove this query:-->
あなたが思い出すと、始めに戻って、私たちはこのクエリを証明しようとしていました：

```text
?A: Foo<'static, ?B>
```

<!--We canonicalized that into this:-->
これを標準化しました：

```text
for<T,L,T> { ?0: Foo<'?1, ?2> }
```

<!--and now we got back a canonical response:-->
今、標準的な応答を得ました：

```text
for<T, L> {
    certainty: Proven,
    var_values: [Vec<?0>, '?1, ?2]
    region_constraints: [?2: '?1],
    value: (),
}
```

<!--We now want to apply that response to our context.-->
私たちは現在、その応答を私たちの状況に適用したいと考えています。
<!--Conceptually, how we do that is to (a) instantiate each of the canonical variables in the result with a fresh inference variable, (b) unify the values in the result with the original values, and then (c) record the region constraints for later.-->
概念的には、（a）結果の中の正準変数をそれぞれ新しい推論変数でインスタンス化し、（b）結果の値を元の値に統一し、（c）後で。
<!--Doing step (a) would yield a result of-->
ステップ（a）を実行すると、

```text
{
      certainty: Proven,
      var_values: [Vec<?C>, '?D, ?C]
                       ^^   ^^^ fresh inference variables
      region_constraints: [?C: '?D],
      value: (),
}
```

<!--Step (b) would then unify:-->
ステップ（b）は、

```text
?A with Vec<?C>
'static with '?D
?B with ?C
```

<!--And finally the region constraint of `?C: 'static` would be recorded for later verification.-->
最後に、`?C: 'static`の領域制約は、後で検証するために記録されます。

<!--(What we *actually* do is a mildly optimized variant of that: Rather than eagerly instantiating all of the canonical values in the result with variables, we instead walk the vector of values, looking for cases where the value is just a canonical variable. In our example, `values[2]` is `?C`, so that means we can deduce that `?C := ?B and` '?D:= 'static`. This gives us a partial set of values. Anything for which we do not find a value, we create an inference variable.)-->
（私たちが*実際に*やっているのは、やや最適化された変数です。結果の標準的な値すべてを変数で瞬時にインスタンス化するのではなく、値のベクトルを歩き、値が標準的な変数である場合を探します。例えば、`values[2]`は`?C`なので、`?C := ?B and` '？D：=' static`を推論することができます。値、推論変数を作成します。）

