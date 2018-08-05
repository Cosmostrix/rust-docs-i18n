# <!--Equality and associated types--> 等価および関連タイプ

<!--This section covers how the trait system handles equality between associated types.-->
このセクションでは、形質システムが関連するタイプ間の等価性をどのように処理するかについて説明します。
<!--The full system consists of several moving parts, which we will introduce one by one:-->
フルシステムはいくつかの可動部品で構成されています.1つずつ紹介します：

- <!--Projection and the `Normalize` predicate-->
   投影法と`Normalize`述語
- <!--Skolemization-->
   Skolemization
- <!--The `ProjectionEq` predicate-->
   `ProjectionEq`述語
- <!--Integration with unification-->
   統一との統合

## <!--Associated type projection and normalization--> 関連型の投影と正規化

<!--When a trait defines an associated type (eg, [the `Item` type in the `IntoIterator` trait][intoiter-item]), that type can be referenced by the user using an **associated type projection** like `<Option<u32> as IntoIterator>::Item`.-->
形質が関連タイプ（例えば、[`IntoIterator`特性の`Item`タイプ][intoiter-item]）を定義するとき、そのタイプは、 `<Option<u32> as IntoIterator>::Item`ような**関連するタイプ投影**を使用してユーザによって参照され得る。
<!--(Often, though, people will use the shorthand syntax `T::Item` – presently, that syntax is expanded during ["type collection"](./type-checking.html) into the explicit form, though that is something we may want to change in the future.)-->
（しばしば、人々は短縮形の構文`T::Item`を使用します -現時点では、その構文は["型の収集](./type-checking.html)中に["](./type-checking.html)明示的な形式に展開されますが、将来的に変更することができます。

[intoiter-item]: https://doc.rust-lang.org/nightly/core/iter/trait.IntoIterator.html#associatedtype.Item

<span id="normalize"></span>
<!--In some cases, associated type projections can be **normalized** – that is, simplified – based on the types given in an impl.-->
場合によっては、implで指定された型に基づいて、関連する型の投影を**正規化**することができます（つまり、単純化されます）。
<!--So, to continue with our example, the impl of `IntoIterator` for `Option<T>` declares (among other things) that `Item = T`:-->
したがって、この例を続けると、`IntoIterator` for `Option<T>` `IntoIterator`、（特に） `Item = T`：を宣言します。

```rust,ignore
impl<T> IntoIterator for Option<T> {
  type Item = T;
  ...
}
```

<!--This means we can normalize the projection `<Option<u32> as IntoIterator>::Item` to just `u32`.-->
これは、我々が投影正規化することができることを意味し`<Option<u32> as IntoIterator>::Item`だけに`u32`。

<!--In this case, the projection was a "monomorphic"one – that is, it did not have any type parameters.-->
この場合、投影は「単相性」であり、つまり型パラメータはありませんでした。
<!--Monomorphic projections are special because they can **always** be fully normalized – but often we can normalize other associated type projections as well.-->
単相性投影は**常に**完全に正規化できるので特別ですが、しばしば他の関連する投影も正規化することができます。
<!--For example, `<Option<?T> as IntoIterator>::Item` (where `?T` is an inference variable) can be normalized to just `?T`.-->
例えば、`<Option<?T> as IntoIterator>::Item`（ `<Option<?T> as IntoIterator>::Item` `?T`は推論変数）`<Option<?T> as IntoIterator>::Item`は、単に`?T`正規化することができます。

<!--In our logic, normalization is defined by a predicate `Normalize`.-->
私たちのロジックでは、正規化は述語`Normalize`によって定義されます。
<!--The `Normalize` clauses arise only from impls.-->
`Normalize`句はimplからのみ発生します。
<!--For example, the `impl` of `IntoIterator` for `Option<T>` that we saw above would be lowered to a program clause like so:-->
たとえば、`impl`の`IntoIterator`ための`Option<T>`上で見たようにのようなプログラム節に低下してしまいます。

```text
forall<T> {
    Normalize(<Option<T> as IntoIterator>::Item -> T) :-
        Implemented(Option<T>: IntoIterator)
}
```

<!--where in this case, the one `Implemented` condition is always true.-->
この場合、1つの`Implemented`条件は常にtrueです。

<!--(An aside: since we do not permit quantification over traits, this is really more like a family of program clauses, one for each associated type.)-->
（脇に：形質を定量化することはできないので、これは実際にはプログラム句のファミリーに似ていて、関連するタイプごとに1つです。）

<!--We could apply that rule to normalize either of the examples that we've seen so far.-->
これまでに見た例のいずれかを正規化するためにそのルールを適用することができます。

## <!--Skolemized associated types--> Skolemized関連タイプ

<!--Sometimes however we want to work with associated types that cannot be normalized.-->
しかし、時には正規化できない関連する型を扱うことが必要な場合もあります。
<!--For example, consider this function:-->
たとえば、次の関数を考えます。

```rust,ignore
fn foo<T: IntoIterator>(...) { ... }
```

<!--In this context, how would we normalize the type `T::Item`?-->
このコンテキストでは、`T::Item`型を正規化する方法はありますか？
<!--Without knowing what `T` is, we can't really do so.-->
`T`が何であるか知らずに、私たちは本当にそうすることはできません。
<!--To represent this case, we introduce a type called a **skolemized associated type projection**.-->
このケースを表現するために、**スカラー化関連型投影**と呼ばれるタイプを導入する。
<!--This is written like so `(IntoIterator::Item)<T>`.-->
これは`(IntoIterator::Item)<T>`ように書かれています。
<!--You may note that it looks a lot like a regular type (eg, `Option<T>`), except that the "name"of the type is `(IntoIterator::Item)`.-->
型の "名前"が`(IntoIterator::Item)`ことを除いて、通常の型（例えば、`Option<T>`）のように見えることに注意してください。
<!--This is not an accident: skolemized associated type projections work just like ordinary types like `Vec<T>` when it comes to unification.-->
これは事故ではありません。skolemized関連型投影は、統一に関しては`Vec<T>`ような通常の型と同じように機能します。
<!--That is, they are only considered equal if (a) they are both references to the same associated type, like `IntoIterator::Item` and (b) their type arguments are equal.-->
つまり、（a）`IntoIterator::Item`や（b）型引数が等しい場合など、それらが両方とも同じ関連型への参照である場合、それらは等しいとみなされます。

<!--Skolemized associated types are never written directly by the user.-->
Skolemized関連型は決してユーザーによって直接書かれません。
<!--They are used internally by the trait system only, as we will see shortly.-->
これらは、形質システムによってのみ内部的に使用されます。

## <!--Projection equality--> 投影の平等

<!--So far we have seen two ways to answer the question of "When can we consider an associated type projection equal to another type?":-->
これまで、「関連する型投影をいつ別の型に等しいと考えることができるか」という質問に答える2つの方法を見てきました。

- <!--the `Normalize` predicate could be used to transform associated type projections when we knew which impl was applicable;-->
   適用可能なimplを知っていれば、`Normalize`述部を使用して関連する型予測を変換することができます。
- <!--**skolemized** associated types can be used when we don't.-->
   私たちがしていないときには、**スカラー化された**関連型を使うことができます。

<!--We now introduce the `ProjectionEq` predicate to bring those two cases together.-->
`ProjectionEq`述語を導入して、これら2つのケースを統合します。
<!--The `ProjectionEq` predicate looks like so:-->
`ProjectionEq`述語は次のようになります。

```text
ProjectionEq(<T as IntoIterator>::Item = U)
```

<!--and we will see that it can be proven *either* via normalization or skolemization.-->
私たちはそれが正規化かskolemizationの*どちらか*によって証明さ*れる*ことがわかります。
<!--As part of lowering an associated type declaration from some trait, we create two program clauses for `ProjectionEq`:-->
関連する型宣言をある種の特性から引き下げる一環として、`ProjectionEq` 2つのプログラム節を作成します。

```text
forall<T, U> {
    ProjectionEq(<T as IntoIterator>::Item = U) :-
        Normalize(<T as IntoIterator>::Item -> U)
}

forall<T> {
    ProjectionEq(<T as IntoIterator>::Item = (IntoIterator::Item)<T>)
}
```

<!--These are the only two `ProjectionEq` program clauses we ever make for any given associated item.-->
これらのアイテムは、関連するアイテムごとに作成された唯一の`ProjectionEq`プログラム句です。

## <!--Integration with unification--> 統一との統合

<!--Now we are ready to discuss how associated type equality integrates with unification.-->
これで、関連する型の平等がどのように統一に統合されるのかを議論する準備ができました。
<!--As described in the [type inference](./type-inference.html) section, unification is basically a procedure with a signature like this:-->
[型推論の](./type-inference.html)セクションで説明したように、統一は基本的に次のような署名を持つ手続きです。

```text
Unify(A, B) = Result<(Subgoals, RegionConstraints), NoSolution>
```

<!--In other words, we try to unify two things A and B. That procedure might just fail, in which case we get back `Err(NoSolution)`.-->
言い換えれば、私たちはAとBの2つのものを統一しようとします。その手順は失敗するかもしれません。その場合、`Err(NoSolution)`ます。
<!--This would happen, for example, if we tried to unify `u32` and `i32`.-->
たとえば、`u32`と`i32`を統合しようとすると、これが起こります。

<!--The key point is that, on success, unification can also give back to us a set of subgoals that still remain to be proven (it can also give back region constraints, but those are not relevant here).-->
重要な点は、成功すれば、統一はまだ証明されていないサブゴールのセットを私たちに返すことである（リージョンの制約を戻すこともできるが、ここでは関係ない）。

<!--Whenever unification encounters an (unskolemized!) associated type projection P being equated with some other type T, it always succeeds, but it produces a subgoal `ProjectionEq(P = T)` that is propagated back up.-->
統一が（非公式化された）関連型投射Pが他のいくつかの型Tと等しいとみなされると、常に成功するが、それはバックアップに伝搬されるサブゴール`ProjectionEq(P = T)`を生成する。
<!--Thus it falls to the ordinary workings of the trait system to process that constraint.-->
したがって、それはその制約を処理するために形質システムの通常の動作に落ちる。

<!--(If we unify two projections P1 and P2, then unification produces a variable X and asks us to prove that `ProjectionEq(P1 = X)` and `ProjectionEq(P2 = X)`. That used to be needed in an older system to prevent cycles; I rather doubt it still is. -nmatsakis)-->
（2つの投影P1とP2を統一すると、統一によって変数Xが生成され、`ProjectionEq(P1 = X)`と`ProjectionEq(P2 = X)`を証明するように求められます。それはまだそれが疑わしい。-nmatsakis）
