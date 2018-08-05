# <!--Caching and subtle considerations therewith--> キャッシングと微妙な考慮事項

<!--In general, we attempt to cache the results of trait selection.-->
一般に、我々は形質選択の結果をキャッシュしようとする。
<!--This is a somewhat complex process.-->
これはやや複雑なプロセスです。
<!--Part of the reason for this is that we want to be able to cache results even when all the types in the trait reference are not fully known.-->
この理由の1つは、特性参照のすべての型が完全にわかっていなくても結果をキャッシュできるようにすることです。
<!--In that case, it may happen that the trait selection process is also influencing type variables, so we have to be able to not only cache the *result* of the selection process, but *replay* its effects on the type variables.-->
その場合、特性選択プロセスもタイプ変数に影響を与えることがありますので、選択プロセスの*結果*をキャッシュするだけでなく、タイプ変数にその影響を*再現*できるようにする必要があります。

## <!--An example--> 例

<!--The high-level idea of how the cache works is that we first replace all unbound inference variables with skolemized versions.-->
キャッシュがどのように機能するかについての高レベルの考え方は、すべての非結合推論変数を最初にskolemizedバージョンに置き換えることです。
<!--Therefore, if we had a trait reference `usize : Foo<$t>`, where `$t` is an unbound inference variable, we might replace it with `usize : Foo<$0>`, where `$0` is a skolemized type.-->
したがって、特性の参照`usize : Foo<$t>`（ `$t`は結合されていない推論変数です）を`usize : Foo<$0>`に置き換えることが`usize : Foo<$0>`ここで、`$0`はスカラー化型です。
<!--We would then look this up in the cache.-->
これをキャッシュ内で調べます。

<!--If we found a hit, the hit would tell us the immediate next step to take in the selection process (eg apply impl #22, or apply where clause `X : Foo<Y>`).-->
ヒットが見つかった場合は、選択プロセスを実行するための即時の次のステップがヒットします（たとえば、impl＃22を適用するか、where句`X : Foo<Y>`適用します）。

<!--On the other hand, if there is no hit, we need to go through the [selection process] from scratch.-->
一方、ヒットがなければ、最初から[selection process]を進める必要があります。
<!--Suppose, we come to the conclusion that the only possible impl is this one, with def-id 22:-->
たとえば、def-id 22という唯一の可能なimplがこの1つであるという結論に達したとします。

[selection process]: ./traits/resolution.html#selection

```rust,ignore
#//impl Foo<isize> for usize { ... } // Impl #22
impl Foo<isize> for usize { ... } //  Impl＃22
```

<!--We would then record in the cache `usize : Foo<$0> => ImplCandidate(22)`.-->
キャッシュ`usize : Foo<$0> => ImplCandidate(22)`ます。
<!--Next we would [confirm] `ImplCandidate(22)`, which would (as a side-effect) unify `$t` with `isize`.-->
次に、（副作用として）`$t`を`isize`統一[confirm] `ImplCandidate(22)`を[confirm]し`isize`。

[confirm]: ./traits/resolution.html#confirmation

<!--Now, at some later time, we might come along and see a `usize : Foo<$u>`.-->
さて、後で、私たちは一緒に来て、`usize : Foo<$u>`を見るかもしれません。
<!--When skolemized, this would yield `usize : Foo<$0>`, just as before, and hence the cache lookup would succeed, yielding `ImplCandidate(22)`.-->
スカラー化されると、以前と同じように`usize : Foo<$0>`が生成され、キャッシュルックアップが成功し`ImplCandidate(22)`生成されます。
<!--We would confirm `ImplCandidate(22)` which would (as a side-effect) unify `$u` with `isize`.-->
私たちは、（副作用として）`$u`を`isize`と統一する`ImplCandidate(22)`を確認し`isize`。

## <!--Where clauses and the local vs global cache--> where節とローカルとグローバルキャッシュ

<!--One subtle interaction is that the results of trait lookup will vary depending on what where clauses are in scope.-->
1つの微妙な相互作用は、特性検索の結果が、どの句がどの範囲にあるかによって異なることになります。
<!--Therefore, we actually have *two* caches, a local and a global cache.-->
したがって、実際にはローカルキャッシュとグローバルキャッシュの*2つの*キャッシュがあります。
<!--The local cache is attached to the [`ParamEnv`], and the global cache attached to the [`tcx`].-->
ローカルキャッシュは[`ParamEnv`]に接続され、グローバルキャッシュは[`tcx`]ます。
<!--We use the local cache whenever the result might depend on the where clauses that are in scope.-->
結果がスコープ内のwhere句に依存する場合は常に、ローカルキャッシュを使用します。
<!--The determination of which cache to use is done by the method `pick_candidate_cache` in `select.rs`.-->
使用するキャッシュその決意は、メソッドによって行われる`pick_candidate_cache`で`select.rs`。
<!--At the moment, we use a very simple, conservative rule: if there are any where-clauses in scope, then we use the local cache.-->
現時点では、非常にシンプルで保守的なルールを使用しています。スコープ内にwhere句がある場合は、ローカルキャッシュを使用します。
<!--We used to try and draw finer-grained distinctions, but that led to a serious of annoying and weird bugs like [#22019] and [#18290].-->
私たちはより細かい区別を試みましたが、それは[#22019]や[#18290]ような厄介で奇妙なバグに[#18290]。
<!--This simple rule seems to be pretty clearly safe and also still retains a very high hit rate (~95% when compiling rustc).-->
この単純なルールはかなり明確に安全であると思われ、非常に高いヒット率（rustcをコンパイルすると約95％）を保持します。

<!--**TODO**: it looks like `pick_candidate_cache` no longer exists.-->
**TODO**： `pick_candidate_cache`が存在しなくなったよう`pick_candidate_cache`。
<!--In general, is this section still accurate at all?-->
一般に、このセクションはまだまったく正確ですか？

<!--[`ParamEnv`]: ./param_env.html
 [`tcx`]: ./ty.html
 [#18290]: https://github.com/rust-lang/rust/issues/18290
 [#22019]: https://github.com/rust-lang/rust/issues/22019
-->
[`ParamEnv`]: ./param_env.html
 [`tcx`]: ./ty.html
 [#18290]: https://github.com/rust-lang/rust/issues/18290
 [#22019]: https://github.com/rust-lang/rust/issues/22019

