# <!--Goals and clauses--> 目標と句

<!--In logic programming terms, a **goal** is something that you must prove and a **clause** is something that you know is true.-->
論理プログラミングの用語では、**目標**はあなたが証明しなければならないものであり、**句**はあなたが知っているものが真であるものです。
<!--As described in the [lowering to logic](./traits/lowering-to-logic.html) chapter, Rust's trait solver is based on an extension of hereditary harrop (HH) clauses, which extend traditional Prolog Horn clauses with a few new superpowers.-->
[ロジックの](./traits/lowering-to-logic.html)章に記載されているように、Rustの特性ソルバーは、いくつかの新しいスーパーパワーを持つ伝統的なPrologホーン節を拡張する遺伝的ハーロープ（HH）節の拡張に基づいています。

## <!--Goals and clauses meta structure--> 目標と句メタ構造

<!--In Rust's solver, **goals** and **clauses** have the following forms (note that the two definitions reference one another):-->
Rustのソルバーでは、**目標**と**節**は次のような形をしています（2つの定義がお互いを参照しています）。

```text
#//Goal = DomainGoal           // defined in the section below
Goal = DomainGoal           // 下のセクションで定義されています
        | Goal && Goal
        | Goal || Goal
#//        | exists<K> { Goal }   // existential quantification
        | exists<K> { Goal }   // 存在量の定量化
#//        | forall<K> { Goal }   // universal quantification
        | forall<K> { Goal }   // 普遍的な定量
#//        | if (Clause) { Goal } // implication
        | if (Clause) { Goal } // 含意
#//        | true                 // something that's trivially true
        | true                 // 自明のことだ
#//        | ambiguous            // something that's never provable
        | ambiguous            // 証明できないもの

Clause = DomainGoal
#//        | Clause :- Goal     // if can prove Goal, then Clause is true
        | Clause :- Goal     //  Goalを証明できれば、句は真です
        | Clause && Clause
        | forall<K> { Clause }

#//K = <type>     // a "kind"
K = <type>     //  "種類"
    | <lifetime>
```

<!--The proof procedure for these sorts of goals is actually quite straightforward.-->
これらの種類の目標に対する証明手続きは、実際には非常に簡単です。
<!--Essentially, it's a form of depth-first search.-->
基本的に、これは深さ優先検索の一種です。
<!--The paper ["A Proof Procedure for the Logic of Hereditary Harrop Formulas"][pphhf] gives the details.-->
[「遺伝的なハロップロ式の論理のための証明手続き」][pphhf]という論文が詳細を述べている。

[pphhf]: ./traits/bibliography.html#pphhf

<span id="domain-goals"></span>
## <!--Domain goals--> ドメインの目標

<span id="trait-ref"></span>
<!--To define the set of *domain goals* in our system, we need to first introduce a few simple formulations.-->
私たちのシステムで一連の*ドメイン目標*を定義するには、最初にいくつかの簡単な形式を導入する必要があります。
<!--A **trait reference** consists of the name of a trait along with a suitable set of inputs P0..Pn:-->
**形質の参照**は、形質の名前と適切な入力の集合P0..Pnから成ります。

```text
TraitRef = P0: TraitName<P1..Pn>
```

<!--So, for example, `u32: Display` is a trait reference, as is `Vec<T>: IntoIterator`.-->
したがって、たとえば、`u32: Display`は`Vec<T>: IntoIterator`ように、特性参照`Vec<T>: IntoIterator`。
<!--Note that Rust surface syntax also permits some extra things, like associated type bindings (`Vec<T>: IntoIterator<Item = T>`), that are not part of a trait reference.-->
Rustサーフェスシンタックスでは、関連する型のバインディング（`Vec<T>: IntoIterator<Item = T>`）のようないくつかの余分なものが、特性参照の一部ではないことにも注意してください。

<span id="projection"></span>
<!--A **projection** consists of an associated item reference along with its inputs P0..Pm:-->
**投影**は、入力P0..Pmと共に関連するアイテム参照から成ります。

```text
Projection = <P0 as TraitName<P1..Pn>>::AssocItem<Pn+1..Pm>
```

<!--Given these, we can define a `DomainGoal` as follows:-->
これらを考えると、次のように`DomainGoal`を定義できます。

```text
DomainGoal = Implemented(TraitRef)
            | ProjectionEq(Projection = Type)
            | Normalize(Projection -> Type)
            | FromEnv(TraitRef)
            | FromEnv(Projection = Type)
            | WellFormed(Type)
            | WellFormed(TraitRef)
            | WellFormed(Projection = Type)
            | Outlives(Type: Region)
            | Outlives(Region: Region)
```

<!--Let's break down each one of these, one-by-one.-->
これらのそれぞれを1つ1つずつ分解しましょう。

#### <!--Implemented(TraitRef)--> 実装済み（TraitRef）
<!--eg `Implemented(i32: Copy)`-->
例： `Implemented(i32: Copy)`

<!--True if the given trait is implemented for the given input types and lifetimes.-->
指定された入力タイプおよび有効期間に対して、指定された特性が実装されている場合はtrueです。

#### <!--ProjectionEq(Projection = Type)--> プロジェクションイク（プロジェクション=タイプ）
<!--eg `ProjectionEq<T as Iterator>::Item = u8`-->
例えば`ProjectionEq<T as Iterator>::Item = u8`

<!--The given associated type `Projection` is equal to `Type`;-->
指定された関連型`Projection`は`Type`等しい。
<!--this can be proved with either normalization or using skolemized types.-->
これは、正規化またはスカラー化された型を使用して証明することができます。
<!--See [the section on associated types](./traits/associated-types.html).-->
[関連するタイプのセクションを](./traits/associated-types.html)参照してください。

#### <!--Normalize(Projection -> Type)--> 正規化（投影→タイプ）
<!--eg `ProjectionEq<T as Iterator>::Item -> u8`-->
例えば`ProjectionEq<T as Iterator>::Item -> u8`

<!--The given associated type `Projection` can be [normalized][n] to `Type`.-->
与えられた関連型`Projection`は`Type`に[normalized][n]できます。

<!--As discussed in [the section on associated types](./traits/associated-types.html), `Normalize` implies `ProjectionEq`, but not vice versa.-->
[関連するタイプのセクションで](./traits/associated-types.html)説明し[た](./traits/associated-types.html)ように、`Normalize` `ProjectionEq`意味し[ますが](./traits/associated-types.html)、その逆はしません。
<!--In general, proving `Normalize(<T as Trait>::Item -> U)` also requires proving `Implemented(T: Trait)`.-->
一般的には、`Normalize(<T as Trait>::Item -> U)`証明するには、`Implemented(T: Trait)`証明が必要です。

<!--[n]: ./traits/associated-types.html#normalize
 [at]: ./traits/associated-types.html
-->
[n]: ./traits/associated-types.html#normalize
 [at]: ./traits/associated-types.html


#### <!--FromEnv(TraitRef), FromEnv(Projection = Type)--> FromEnv（TraitRef）、FromEnv（Projection = Type）
<!--eg `FromEnv(Self: Add<i32>)`-->
例： `FromEnv(Self: Add<i32>)`

<!--eg `FromEnv(<Self as StreamingIterator>::Item<'a> = &'a [u8])`-->
例えば`FromEnv(<Self as StreamingIterator>::Item<'a> = &'a [u8])`

<!--True if the inner `TraitRef` or projection equality is *assumed* to be true;-->
内側の`TraitRef`または投影法の同等性が真であると*仮定さ*れている場合はTrueです。
<!--that is, if it can be derived from the in-scope where clauses.-->
つまり、スコープ内のwhereスコープから派生することができる場合です。

<!--For example, given the following function:-->
たとえば、次の関数を指定します。

```rust
fn loud_clone<T: Clone>(stuff: &T) -> T {
    println!("cloning!");
    stuff.clone()
}
```

<!--Inside the body of our function, we would have `FromEnv(T: Clone)`.-->
私たちの機能の中には、`FromEnv(T: Clone)`ます。
<!--In-scope where clauses nest, so a function body inside an impl body inherits the impl body's where clauses, too.-->
スコープ内でスコープが入れ子になるので、インプラント本体内の関数本体は、インプ本体のwhere句も継承します。

<!--This and the next rule are used to implement [implied bounds].-->
この規則と次の規則は、[implied bounds]を実装するために使用さ[implied bounds]。
<!--As we'll see in the section on lowering, `FromEnv(X)` implies `Implemented(X)`, but not vice versa.-->
下のセクションで見ているように、`FromEnv(X)` `Implemented(X)`意味しますが、その逆はしません。
<!--This distinction is crucial to implied bounds.-->
この区別は、暗黙の境界にとって重要です。

#### <!--WellFormed(Item)--> WellFormed（アイテム）
<!--These goals imply that the given item is *well-formed*.-->
これらの目標は、所定の項目が*整形式である*ことを意味する。

<!--We can talk about different types of items being well-formed:-->
整形式のアイテムの種類について話すことができます。

<!--**Types**, like `WellFormed(Vec<i32>)`, which is true in Rust, or `WellFormed(Vec<str>)`, which is not (because `str` is not `Sized`.)-->
Rustや`WellFormed(Vec<str>)`に`WellFormed(Vec<i32>)`ような**型**はありません（`str`は`Sized`はないためです）。

<!--**TraitRefs**, like `WellFormed(Vec<i32>: Clone)`.-->
**WellFormed** `WellFormed(Vec<i32>: Clone)`ような`WellFormed(Vec<i32>: Clone)`。

<!--**Projections**, like `WellFormed(T: Iterator<Item = u32>)`.-->
`WellFormed(T: Iterator<Item = u32>)`ような**投影**。

<!--Well-formedness is important to [implied bounds].-->
うまく形成さ[implied bounds]、 [implied bounds]にとって重要です。
<!--In particular, the reason it is okay to assume `FromEnv(T: Clone)` in the example above is that we  _also_  verify `WellFormed(T: Clone)` for each call site of `loud_clone`.-->
特に、上記の例で`FromEnv(T: Clone)`を使用するといい理由は、`loud_clone`各呼び出しサイトに対して`WellFormed(T: Clone)`  _も_ 検証すること`loud_clone`。

#### <!--Outlives(Type: Region), Outlives(Region: Region)--> アウトライフ（種類：地域）、アウトライフ（地域：地域）
<!--eg `Outlives(&'a str: 'b)`, `Outlives('a: 'static)`-->
例えば`Outlives(&'a str: 'b)`、 `Outlives('a: 'static)`

<!--True if the given type or region on the left outlives the right-hand region.-->
指定された型または領域が右側の領域よりも長い場合はtrue。

<span id="coinductive"></span>
## <!--Coinductive goals--> 共創の目標

<!--Most goals in our system are "inductive".-->
私たちのシステムのほとんどの目標は「誘導的」です。
<!--In an inductive goal, circular reasoning is disallowed.-->
帰納的目標では、循環推論は禁止されています。
<!--Consider this example clause:-->
この例の節を考えてみましょう。

```text
    Implemented(Foo: Bar) :-
        Implemented(Foo: Bar).
```

<!--Considered inductively, this clause is useless: if we are trying to prove `Implemented(Foo: Bar)`, we would then recursively have to prove `Implemented(Foo: Bar)`, and that cycle would continue ad infinitum (the trait solver will terminate here, it would just consider that `Implemented(Foo: Bar)` is not known to be true).-->
誘導考えられ、この句は無意味です：我々は証明しようとしている場合`Implemented(Foo: Bar)`、我々は、再帰的に証明しなければならない`Implemented(Foo: Bar)`、そしてそのサイクルは無限に継続する（形質ソルバーは、ここで終了します`Implemented(Foo: Bar)`が真実であるとは知られていないと考えられます）。

<!--However, some goals are *co-inductive*.-->
しかし、いくつかの目標は*共誘導的である*。
<!--Simply put, this means that cycles are OK.-->
簡単に言えば、これはサイクルがOKであることを意味します。
<!--So, if `Bar` were a co-inductive trait, then the rule above would be perfectly valid, and it would indicate that `Implemented(Foo: Bar)` is true.-->
したがって、`Bar`が共誘導特性の場合、上記のルールは完全に有効であり、`Implemented(Foo: Bar)`がtrueであることを示します。

<!--*Auto traits* are one example in Rust where co-inductive goals are used.-->
*自動特性*は、誘導目標が使用されるRustの1つの例です。
<!--Consider the `Send` trait, and imagine that we have this struct:-->
`Send`特性を考えて、この構造体があると想像してください：

```rust
struct Foo {
    next: Option<Box<Foo>>
}
```

<!--The default rules for auto traits say that `Foo` is `Send` if the types of its fields are `Send`.-->
自動形質のデフォルトのルールはと言う`Foo`されて`Send`そのフィールドのタイプがされている場合は`Send`。
<!--Therefore, we would have a rule like-->
したがって、私たちは

```text
Implemented(Foo: Send) :-
    Implemented(Option<Box<Foo>>: Send).
```

<!--As you can probably imagine, proving that `Option<Box<Foo>>: Send` is going to wind up circularly requiring us to prove that `Foo: Send` again.-->
おそらくあなたが想像しているように、`Option<Box<Foo>>: Send`は循環的に巻き上げられ、`Foo: Send`再度証明する必要があります。
<!--So this would be an example where we wind up in a cycle – but that's ok, we *do* consider `Foo: Send` to hold, even though it references itself.-->
だからこれは、我々がサイクルで巻き上げる例です -しかしそれは大丈夫です、私たち*は* `Foo: Send`を考慮し`Foo: Send`それが自分自身を参照していても、保留にします。

<!--In general, co-inductive traits are used in Rust trait solving when we want to enumerate a fixed set of possibilities.-->
一般的に、固定抵抗の集合を列挙したいときには、共誘導特性がRust特性解法で使用されます。
<!--In the case of auto traits, we are enumerating the set of reachable types from a given starting point (ie, `Foo` can reach values of type `Option<Box<Foo>>`, which implies it can reach values of type `Box<Foo>`, and then of type `Foo`, and then the cycle is complete).-->
自動特性の場合、与えられた開始点から到達可能な型のセットを列挙しています（つまり、`Foo`は`Option<Box<Foo>>`型の値に達することができます。これは`Box<Foo>` `Foo`タイプの場合、サイクルが完了します）。

<!--In addition to auto traits, `WellFormed` predicates are co-inductive.-->
オート`WellFormed`加えて、`WellFormed`述語は共誘導的です。
<!--These are used to achieve a similar "enumerate all the cases"pattern, as described in the section on [implied bounds].-->
これらは、[implied bounds]に関するセクションで説明したように、同様の「すべてのケースを列挙する」パターンを達成するために使用さ[implied bounds]。

[implied bounds]: ./traits/lowering-rules.html#implied-bounds

## <!--Incomplete chapter--> 不完全な章

<!--Some topics yet to be written:-->
まだ書かれていないいくつかのトピック：

- <!--Elaborate on the proof procedure-->
   証明手続きを詳述する
- <!--SLG solving – introduce negative reasoning-->
   SLGの解決 -否定的な推論を導入する
