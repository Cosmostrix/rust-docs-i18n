# <!--Higher-ranked trait bounds--> 高ランクの形質境界

<!--One of the more subtle concepts in trait resolution is *higher-ranked trait bounds*.-->
特性決定におけるより微妙な概念の1つは、*上位ランクの形質境界である*。
<!--An example of such a bound is `for<'a> MyTrait<&'a isize>`.-->
このような境界の例は`for<'a> MyTrait<&'a isize>`です。
<!--Let's walk through how selection on higher-ranked trait references works.-->
より高いランクの形質参照の選択がどのように機能するかを見てみましょう。

## <!--Basic matching and skolemization leaks--> 基本的なマッチングとスケーリングリーク

<!--Suppose we have a trait `Foo`:-->
私たちが特色を持っていると仮定`Foo`：

```rust
trait Foo<X> {
    fn foo(&self, x: X) { }
}
```

<!--Let's say we have a function `want_hrtb` that wants a type which implements `Foo<&'a isize>` for any `'a`:-->
我々は、関数があるとしましょう`want_hrtb`実装タイプ望んでいる`Foo<&'a isize>`いずれかのために`'a`：

```rust,ignore
fn want_hrtb<T>() where T : for<'a> Foo<&'a isize> { ... }
```

<!--Now we have a struct `AnyInt` that implements `Foo<&'a isize>` for any `'a`:-->
今、私たちは、構造体の持っている`AnyInt`実装`Foo<&'a isize>`いずれかのために`'a`：

```rust,ignore
struct AnyInt;
impl<'a> Foo<&'a isize> for AnyInt { }
```

<!--And the question is, does `AnyInt : for<'a> Foo<&'a isize>`?-->
そして、問題は、`AnyInt : for<'a> Foo<&'a isize>`ですか？
<!--We want the answer to be yes.-->
私たちは答えが欲しいと思っています。
<!--The algorithm for figuring it out is closely related to the subtyping for higher-ranked types (which is described [here][hrsubtype] and also in a [paper by SPJ]. If you wish to understand higher-ranked subtyping, we recommend you read the paper).-->
それを計算するためのアルゴリズムは、上位ランクのタイプのサブタイプと密接に関連しています（[paper by SPJ]も[here][hrsubtype]で説明してい[here][hrsubtype]。上位ランクのサブタイプを理解したい場合は、このペーパーを読むことをお勧めします）。
<!--There are a few parts:-->
いくつかの部分があります：

<!--**TODO**: We should define  _skolemize_ .-->
**TODO**：  _skolemize_ を定義する必要があります。

1. <!-- _Skolemize_  the obligation.-->
    義務を _Skolemize。_ 
2. <!--Match the impl against the skolemized obligation.-->
    黙示的義務とimplとを一致させる。
3. <!--Check for  _skolemization leaks_ .-->
     _脱皮漏れがないか_ チェックしてください。

<!--[hrsubtype]: https://github.com/rust-lang/rust/tree/master/src/librustc/infer/higher_ranked/README.md
 [paper by SPJ]: http://research.microsoft.com/en-us/um/people/simonpj/papers/higher-rank/
-->
[paper by SPJ]: http://research.microsoft.com/en-us/um/people/simonpj/papers/higher-rank/
 [hrsubtype]: https://github.com/rust-lang/rust/tree/master/src/librustc/infer/higher_ranked/README.md
 [paper by SPJ]: http://research.microsoft.com/en-us/um/people/simonpj/papers/higher-rank/


<!--So let's work through our example.-->
そこで、例を試してみましょう。

1. <!--The first thing we would do is to-->
    私たちがまずやるべきことは、
<!--skolemize the obligation, yielding `AnyInt : Foo<&'0 isize>` (here `'0` represents skolemized region #0).-->
AnyInt `AnyInt : Foo<&'0 isize>`（ここでは`'0`はskolemized region＃0を表します）。
<!--Note that we now have no quantifiers;-->
ここでは、限定子がないことに注意してください。
<!--in terms of the compiler type, this changes from a `ty::PolyTraitRef` to a `TraitRef`.-->
コンパイラのタイプでは、これは`ty::PolyTraitRef`から`TraitRef`ます。
<!--We would then create the `TraitRef` from the impl, using fresh variables for it's bound regions (and thus getting `Foo<&'$a isize>`, where `'$a` is the inference variable for `'a`).-->
私たちは、その後、作成し`TraitRef`、それが地域をバインドだ新鮮な変数を使用して、独自の実装から（したがって、取得`Foo<&'$a isize>` `'$a`のための推論変数であるが`'a`）。

2. <!--Next-->
    次
<!--we relate the two trait refs, yielding a graph with the constraint that `'0 == '$a`.-->
我々は2つの特性の参照を関連づけ、`'0 == '$a`という制約を持つグラフを生成`'0 == '$a`。

3. <!--Finally, we check for skolemization "leaks"– a-->
    最後に、「漏れ」という文字列をチェックします。
<!--leak is basically any attempt to relate a skolemized region to another skolemized region, or to any region that pre-existed the impl match.-->
リークは、スカレーマ化された領域を他のスカラー化領域、またはインプリメンテーションマッチが既に存在していた領域に関連付ける試みです。
<!--The leak check is done by searching from the skolemized region to find the set of regions that it is related to in any way.-->
リークチェックは、スカラー化された領域から検索して、それが何らかの形で関連している領域の集合を見つけることによって行われる。
<!--This is called the "taint"set.-->
これは「汚れ」と呼ばれます。
<!--To pass the check, that set must consist *solely* of itself and region variables from the impl.-->
チェックを渡すには、そのセットはそれ自身とインプラントからのリージョン変数*のみ*で構成*さ*れていなければなりません。
<!--If the taint set includes any other region, then the match is a failure.-->
汚れ集合に他の領域が含まれている場合、一致は失敗です。
<!--In this case, the taint set for `'0` is `{'0, '$a}`, and hence the check will succeed.-->
この場合、`'0`設定された汚れは`{'0, '$a}`チェックは成功します。

<!--Let's consider a failure case.-->
失敗事例を考えてみましょう。
<!--Imagine we also have a struct-->
私たちも構造体を持っていると想像してください

```rust,ignore
struct StaticInt;
impl Foo<&'static isize> for StaticInt;
```

<!--We want the obligation `StaticInt : for<'a> Foo<&'a isize>` to be considered unsatisfied.-->
我々は義務`StaticInt : for<'a> Foo<&'a isize>`が不満であると考えたい。
<!--The check begins just as before.-->
前と同じようにチェックが始まります。
<!--`'a` is skolemized to `'0` and the impl trait reference is instantiated to `Foo<&'static isize>`.-->
`'a`は`'0`スキーされ、impl traitの参照は`Foo<&'static isize>`インスタンス化されます。
<!--When we relate those two, we get a constraint like `'static == '0`.-->
これらの2つを関連付けると、`'static == '0`ような制約があります。
<!--This means that the taint set for `'0` is `{'0, 'static}`, which fails the leak check.-->
これは、`'0`設定された汚れが`{'0, 'static}`であることを意味します。これはリークチェックに失敗します。

<!--**TODO**: This is because `'static` is not a region variable but is in the taint set, right?-->
**TODO**：これは、 `'static`変数は領域変数ではなく、汚れ集合に含まれているからです。

## <!--Higher-ranked trait obligations--> より高いランクの形質義務

<!--Once the basic matching is done, we get to another interesting topic: how to deal with impl obligations.-->
基本的なマッチングが完了したら、別の興味深い話題になる：implの義務をどう扱うか。
<!--I'll work through a simple example here.-->
私はここで簡単な例を使って作業します。
<!--Imagine we have the traits `Foo` and `Bar` and an associated impl:-->
私たちが`Foo`と`Bar`の形質とそれに関連するimplを持っているとしましょう：

```rust
trait Foo<X> {
    fn foo(&self, x: X) { }
}

trait Bar<X> {
    fn bar(&self, x: X) { }
}

impl<X,F> Foo<X> for F
    where F : Bar<X>
{
}
```

<!--Now let's say we have a obligation `Baz: for<'a> Foo<&'a isize>` and we match this impl.-->
さて、私たちに義務`Baz: for<'a> Foo<&'a isize>`があるとしましょう`Baz: for<'a> Foo<&'a isize>`、このimplと一致します。
<!--What obligation is generated as a result?-->
結果としてどのような義務が生じますか？
<!--We want to get `Baz: for<'a> Bar<&'a isize>`, but how does that happen?-->
私たちは`Baz: for<'a> Bar<&'a isize>`を得たいと思っています`Baz: for<'a> Bar<&'a isize>`ために、どうしますか？

<!--After the matching, we are in a position where we have a skolemized substitution like `X => &'0 isize`.-->
マッチングの後、我々は`X => &'0 isize`ようなスカラー化された置換を持つ位置にいる。
<!--If we apply this substitution to the impl obligations, we get `F : Bar<&'0 isize>`.-->
この置換をimplの義務に適用すると、`F : Bar<&'0 isize>`ます。
<!--Obviously this is not directly usable because the skolemized region `'0` cannot leak out of our computation.-->
Skolemized領域`'0`は私たちの計算から漏れ出すことができないので、明らかにこれは直接使用できません。

<!--What we do is to create an inverse mapping from the taint set of `'0` back to the original bound region (`'a`, here) that `'0` resulted from.-->
私たちがしているのは、`'0`汚れ集合から元の結合領域（ここでは`'a` `'0`）に逆マッピングを作成することです。
<!--(This is done in `higher_ranked::plug_leaks`).-->
（これは`higher_ranked::plug_leaks`行われ`higher_ranked::plug_leaks`）。
<!--We know that the leak check passed, so this taint set consists solely of the skolemized region itself plus various intermediate region variables.-->
リークチェックが合格したことを知っているので、この汚れ集合はスカラー化された領域そのものと様々な中間領域変数から構成されています。
<!--We then walk the trait-reference and convert every region in that taint set back to a late-bound region, so in this case we'd wind up with `Baz: for<'a> Bar<&'a isize>`.-->
次に、特性参照を歩み、そのテントのすべての領域を後でバインドされた領域に変換します。この場合`Baz: for<'a> Bar<&'a isize>`。
