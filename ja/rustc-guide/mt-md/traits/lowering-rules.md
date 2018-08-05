# <!--Lowering rules--> 規則を下げる

<!--This section gives the complete lowering rules for Rust traits into [program clauses][pc].-->
このセクションでは、Rust特性を[プログラム節に][pc]完全に下げるための規則を示します。
<!--It is a kind of reference.-->
これは一種の参考資料です。
<!--These rules reference the [domain goals][dg] defined in an earlier section.-->
これらのルールは、前のセクションで定義した[ドメイン目標を][dg]参照し[ます][dg]。

<!--[pc]: ./traits/goals-and-clauses.html
 [dg]: ./traits/goals-and-clauses.html#domain-goals
-->
[pc]: ./traits/goals-and-clauses.html
 [dg]: ./traits/goals-and-clauses.html#domain-goals


## <!--Notation--> 記法

<!--The nonterminal `Pi` is used to mean some generic *parameter*, either a named lifetime like `'a` or a type paramter like `A`.-->
非終端`Pi`どちらか、いくつかの一般的な*パラメータを*意味するような名前の生涯使用されている`'a`等のタイプPARAMTER。 `A`

<!--The nonterminal `Ai` is used to mean some generic *argument*, which might be a lifetime like `'a` or a type like `Vec<A>`.-->
非終端記号`Ai`は、一般的な*引数*を意味するために使用され*ます*。これは、 `'a`や`Vec<A>`ような型のような生涯のものです。

<!--When defining the lowering rules, we will give goals and clauses in the [notation given in this section](./traits/goals-and-clauses.html).-->
下げ規則を定義するときには[、この節で与えられ](./traits/goals-and-clauses.html)た[表記法](./traits/goals-and-clauses.html)で目標と節を与える。
<!--We sometimes insert "macros"like `LowerWhereClause!` into these definitions;-->
これらの定義に`LowerWhereClause!`ような "マクロ"を挿入することがあります。
<!--these macros reference other sections within this chapter.-->
これらのマクロはこの章の他のセクションを参照しています。

## <!--Rule names and cross-references--> ルール名と相互参照

<!--Each of these lowering rules is given a name, documented with a comment like so:-->
これらの下げ規則のそれぞれには、次のようなコメントを記載した名前が付けられています。

<!--// Rule Foo-Bar-Baz-->
//ルールFoo-Bar-Baz

<!--you can also search through the `librustc_traits` crate in rustc to find the corresponding rules from the implementation.-->
`librustc_traits`枠を検索して、実装から対応するルールを見つけることもできます。

## <!--Lowering where clauses--> 節を下げる

<!--When used in a goal position, where clauses can be mapped directly to [domain goals][dg], as follows:-->
ゴール位置で使用する場合、句を[ドメイン目標][dg]に直接マッピングすることができます。

- <!--`A0: Foo<A1..An>` maps to `Implemented(A0: Foo<A1..An>)`.-->
   `A0: Foo<A1..An>`は`Implemented(A0: Foo<A1..An>)`マップされます。
- <!--`A0: Foo<A1..An, Item = T>` maps to `ProjectionEq(<A0 as Foo<A1..An>>::Item = T)`-->
   `A0: Foo<A1..An, Item = T>`は`ProjectionEq(<A0 as Foo<A1..An>>::Item = T)`マッピングされます`ProjectionEq(<A0 as Foo<A1..An>>::Item = T)`
- <!--`T: 'r` maps to `Outlives(T, 'r)`-->
   `T: 'r`は`Outlives(T, 'r)`マップされます。
- <!--`'a: 'b` maps to `Outlives('a, 'b)`-->
   `'a: 'b`は`Outlives('a, 'b)`マップされ`Outlives('a, 'b)`

<!--In the rules below, we will use `WC` to indicate where clauses that appear in Rust syntax;-->
以下のルールでは、`WC`を使用してRust構文で表示される句を指定します。
<!--we will then use the same `WC` to indicate where those where clauses appear as goals in the program clauses that we are producing.-->
同じ`WC`を使用して、私たちが作成しているプログラム句のどこに句がどこに表示されるのかを示します。
<!--In that case, the mapping above is used to convert from the Rust syntax into goals.-->
その場合、上記のマッピングを使用してRust構文をゴールに変換します。

### <!--Transforming the lowered where clauses--> 下位のwhere句を変換する

<!--In addition, in the rules below, we sometimes do some transformations on the lowered where clauses, as defined here:-->
さらに、以下の規則では、ここで定義されているように、where句が低くなったところで変換を行うことがあります。

- <!--`FromEnv(WC)` – this indicates that:-->
   `FromEnv(WC)` -次のことを示します。
  - <!--`Implemented(TraitRef)` becomes `FromEnv(TraitRef)`-->
     `Implemented(TraitRef)`は`FromEnv(TraitRef)`
  - <!--`ProjectionEq(Projection = Ty)` becomes `FromEnv(Projection = Ty)`-->
     `ProjectionEq(Projection = Ty)`は`FromEnv(Projection = Ty)`
  - <!--other where-clauses are left intact-->
     他のwhere節はそのまま残す
- <!--`WellFormed(WC)` – this indicates that:-->
   `WellFormed(WC)` -これは次のことを示します。
  - <!--`Implemented(TraitRef)` becomes `WellFormed(TraitRef)`-->
     `Implemented(TraitRef)`が`WellFormed(TraitRef)`
  - <!--`ProjectionEq(Projection = Ty)` becomes `WellFormed(Projection = Ty)`-->
     `ProjectionEq(Projection = Ty)`は`WellFormed(Projection = Ty)`

<!--*TODO*: I suspect that we want to alter the outlives relations too, but Chalk isn't modeling those right now.-->
*TODO*：私は遺族の関係も変えたいと思うが、チョークは現時点でモデル化していない。

## <!--Lowering traits--> 形質を下げる

<!--Given a trait definition-->
特性の定義が与えられた

```rust,ignore
#//trait Trait<P1..Pn> // P0 == Self
trait Trait<P1..Pn> //  P0 ==自己
where WC
{
#    // trait items
    // 特産品
}
```

<!--we will produce a number of declarations.-->
私たちはいくつかの宣言を生成します。
<!--This section is focused on the program clauses for the trait header (ie, the stuff outside the `{}`);-->
このセクションは、形質ヘッダのプログラム句（すなわち、`{}`外のもの）に焦点を当てています。
<!--the [section on trait items](#trait-items) covers the stuff inside the `{}`.-->
[特性項目](#trait-items)の[セクション](#trait-items)は`{}`内のものをカバーします。

### <!--Trait header--> 形質ヘッダー

<!--From the trait itself we mostly make "meta"rules that setup the relationships between different kinds of domain goals.-->
特性そのものから、私たちは主にさまざまな種類のドメイン目標間の関係を設定する「メタ」ルールを作成します。
<!--The first such rule from the trait header creates the mapping between the `FromEnv` and `Implemented` predicates:-->
traitヘッダーの最初のルールは、`FromEnv`述部と`Implemented`述部の間のマッピングを作成します。

```text
#// Rule Implemented-From-Env
//  Enrから実装されたルール
forall<Self, P1..Pn> {
  Implemented(Self: Trait<P1..Pn>) :- FromEnv(Self: Trait<P1..Pn>)
}
```

<span id="implied-bounds"></span>
#### <!--Implied bounds--> 暗黙の境界

<!--The next few clauses have to do with implied bounds (see also [RFC 2089]).-->
次のいくつかの句は、暗黙の境界と関係しています（[RFC 2089]も参照）。
<!--For each trait, we produce two clauses:-->
各形質について、我々は2つの節を生成する：

[RFC 2089]: https://rust-lang.github.io/rfcs/2089-implied-bounds.html

```text
#// Rule Implied-Bound-From-Trait
// ルールが暗黙のうちに束縛する
//
#// For each where clause WC:
// 各where句のWC：
forall<Self, P1..Pn> {
  FromEnv(WC) :- FromEnv(Self: Trait<P1..Pn)
}
```

<!--This clause says that if we are assuming that the trait holds, then we can also assume that its where-clauses hold.-->
この句は、もしその特性が保持されていると仮定しているなら、そのwhere節が保持されていると仮定することもできます。
<!--It's perhaps useful to see an example:-->
例を見てみると便利でしょう。

```rust,ignore
trait Eq: PartialEq { ... }
```

<!--In this case, the `PartialEq` supertrait is equivalent to a `where Self: PartialEq` where clause, in our simplified model.-->
この場合、`PartialEq` supertraitは、単純化されたモデルの`where Self: PartialEq` where句に相当します。
<!--The program clause above therefore states that if we can prove `FromEnv(T: Eq)` – eg, if we are in some function with `T: Eq` in its where clauses – then we also know that `FromEnv(T: PartialEq)`.-->
したがって、上記のプログラム節は、`FromEnv(T: Eq)`証明`FromEnv(T: Eq)`ば -たとえばwhere節に`T: Eq`を持つ関数であれば -`FromEnv(T: PartialEq)`も知っていると`FromEnv(T: PartialEq)`ます。
<!--Thus the set of things that follow from the environment are not only the **direct where clauses** but also things that follow from them.-->
したがって、環境から続く一連の事柄は、**直接のwhere句**だけでなく、**そこ**から続くものでもあります。

<!--The next rule is related;-->
次のルールは関連しています。
<!--it defines what it means for a trait reference to be **well-formed**:-->
それは、形質の参照が**整形式**であることが何を意味するのかを定義する。

```text
#// Rule WellFormed-TraitRef
// ルールWellFormed-TraitRef
forall<Self, P1..Pn> {
  WellFormed(Self: Trait<P1..Pn>) :- Implemented(Self: Trait<P1..Pn>) && WellFormed(WC)
}
```

<!--This `WellFormed` rule states that `T: Trait` is well-formed if (a) `T: Trait` is implemented and (b) all the where-clauses declared on `Trait` are well-formed (and hence they are implemented).-->
これは`WellFormed`ルールはと述べて`T: Trait`（a）の場合、十分に形成されている`T: Trait`実装されており、（B）に宣言されたすべての場所条項`Trait`よく形成されている（従って、それらが実装されています）。
<!--Remember that the `WellFormed` predicate is [coinductive](./traits/goals-and-clauses.html#coinductive);-->
`WellFormed`述語は[coinductive](./traits/goals-and-clauses.html#coinductive)あることを忘れないでください。
<!--in this case, it is serving as a kind of "carrier"that allows us to enumerate all the where clauses that are transitively implied by `T: Trait`.-->
このケースでは、`T: Trait`によって推移的に暗示されているすべてのwhere節を列挙することを可能にする一種の「キャリア」として機能しています。

<!--An example:-->
例：

```rust,ignore
trait Foo: A + Bar { }
trait Bar: B + Foo { }
trait A { }
trait B { }
```

<!--Here, the transitive set of implications for `T: Foo` are `T: A`, `T: Bar`, and `T: B`.-->
ここで、`T: Foo`に対する推移の推移は`T: A`、 `T: Bar`、 `T: B`。
<!--And indeed if we were to try to prove `WellFormed(T: Foo)`, we would have to prove each one of those:-->
`WellFormed(T: Foo)`を証明しようとするなら、実際にはそれぞれの証明が必要です。

- `WellFormed(T: Foo)`
  - `Implemented(T: Foo)`
  - `WellFormed(T: A)`
    - `Implemented(T: A)`
  - `WellFormed(T: Bar)`
    - `Implemented(T: Bar)`
    - `WellFormed(T: B)`
      - `Implemented(T: Bar)`
    - <!--`WellFormed(T: Foo)` --cycle, true coinductively-->
       `WellFormed(T: Foo)` -サイクル、真の共誘導

<!--This `WellFormed` predicate is only used when proving that impls are well-formed – basically, for each impl of some trait ref `TraitRef`, we must show that `WellFormed(TraitRef)`.-->
この`WellFormed`述語は、implsが整形式であることを証明する場合にのみ使用されます。基本的には、`TraitRef`の一部の`TraitRef`各`TraitRef`、 `WellFormed(TraitRef)`表示する必要があります。
<!--This in turn justifies the implied bounds rules that allow us to extend the set of `FromEnv` items.-->
これは、`FromEnv`アイテムのセットを拡張することを可能にする暗黙的な境界ルールを正当化します。

## <!--Lowering type definitions--> タイプ定義を下げる

<!--We also want to have some rules which define when a type is well-formed.-->
タイプが整形式であるときを定義するいくつかのルールも必要です。
<!--For example, given this type:-->
たとえば、次のように指定します。

```rust,ignore
struct Set<K> where K: Hash { ... }
```

<!--then `Set<i32>` is well-formed because `i32` implements `Hash`, but `Set<NotHash>` would not be well-formed.-->
`i32`は`Hash`実装しているので`Set<i32>`は整形式ですが、`Set<NotHash>`は`Set<NotHash>`はありません。
<!--Basically, a type is well-formed if its parameters verify the where clauses written on the type definition.-->
基本的に、型の型定義は、そのパラメータが型定義に記述されたwhere文節を検証する場合に適切です。

<!--Hence, for every type definition:-->
したがって、すべての型定義について：

```rust, ignore
struct Type<P1..Pn> where WC { ... }
```

<!--we produce the following rule:-->
我々は以下のルールを生成する。

```text
#// Rule WellFormed-Type
// ルールWellFormed型
forall<P1..Pn> {
  WellFormed(Type<P1..Pn>) :- WC
}
```

<!--Note that we use `struct` for defining a type, but this should be understood as a general type definition (it could be eg a generic `enum`).-->
型を定義するには`struct`を使用しますが、これは一般的な型定義（一般的な`enum`型など）として理解する必要があります。

<!--Conversely, we define rules which say that if we assume that a type is well-formed, we can also assume that its where clauses hold.-->
逆に、型が整形式であると仮定すると、where節が保持されていると仮定することもできるという規則を定義します。
<!--That is, we produce the following family of rules:-->
つまり、次のルールファミリが生成されます。

```text
#// Rule FromEnv-Type
// ルールFromEnv-Type
//
#// For each where clause `WC`
// 各where句について`WC`
forall<P1..Pn> {
  FromEnv(WC) :- FromEnv(Type<P1..Pn>)
}
```

<!--As for the implied bounds RFC, functions will *assume* that their arguments are well-formed.-->
暗黙の境界RFCに関しては、関数は引数が正しい形式であると*想定*します。
<!--For example, suppose we have the following bit of code:-->
たとえば、次のようなコードがあるとします。

```rust,ignore
trait Hash: Eq { }
struct Set<K: Hash> { ... }

fn foo<K>(collection: Set<K>, x: K, y: K) {
#    // `x` and `y` can be equalized even if we did not explicitly write
#    // `where K: Eq`
    //  `x`と`y`は、明示的`where K: Eq`
    if x == y {
        ...
    }
}
```

<!--In the `foo` function, we assume that `Set<K>` is well-formed, ie we have `FromEnv(Set<K>)` in our environment.-->
`foo`関数では、`Set<K>`が整形式であると仮定します。つまり、我々の環境では`FromEnv(Set<K>)`を持ちます。
<!--Because of the previous rule, we get `FromEnv(K: Hash)` without needing an explicit where clause.-->
以前のルールのため、明示的なwhere節を必要とせずに`FromEnv(K: Hash)`を取得します。
<!--And because of the `Hash` trait definition, there also exists a rule which says:-->
また、`Hash`特性定義のために、次のようなルールも存在します。

```text
forall<K> {
  FromEnv(K: Eq) :- FromEnv(K: Hash)
}
```

<!--which means that we finally get `FromEnv(K: Eq)` and then can compare `x` and `y` without needing an explicit where clause.-->
つまり、最終的に`FromEnv(K: Eq)`を取得し、明示的なwhere節を必要とせずに`x`と`y`を比較できます。

<span id="trait-items"></span>
## <!--Lowering trait items--> 特性項目を下げる

### <!--Associated type declarations--> 関連付けられた型宣言

<!--Given a trait that declares a (possibly generic) associated type:-->
（おそらくジェネリックな）関連タイプを宣言する特性が与えられているとします：

```rust,ignore
#//trait Trait<P1..Pn> // P0 == Self
trait Trait<P1..Pn> //  P0 ==自己
where WC
{
    type AssocType<Pn+1..Pm>: Bounds where WC1;
}
```

<!--We will produce a number of program clauses.-->
私たちはいくつかのプログラム条項を作成します。
<!--The first two define the rules by which `ProjectionEq` can succeed;-->
最初の2つは、`ProjectionEq`が成功するためのルールを定義しています。
<!--these two clauses are discussed in detail in the [section on associated types](./traits/associated-types.html), but reproduced here for reference:-->
これらの2つの節は[、関連する種類](./traits/associated-types.html)の[セクション](./traits/associated-types.html)で詳しく説明していますが、参照用にここに再現しています。

```text
#// Rule ProjectionEq-Normalize
// ルール射影Eq-正規化
//
#// ProjectionEq can succeed by normalizing:
//  ProjectionEqは正規化することで成功することができます：
forall<Self, P1..Pn, Pn+1..Pm, U> {
  ProjectionEq(<Self as Trait<P1..Pn>>::AssocType<Pn+1..Pm> = U) :-
      Normalize(<Self as Trait<P1..Pn>>::AssocType<Pn+1..Pm> -> U)
}
```

```text
#// Rule ProjectionEq-Skolemize
// ルールプロジェクション -Skolemize
//
#// ProjectionEq can succeed by skolemizing, see "associated type"
#// chapter for more:
//  ProjectionEqはskolemizingで成功することができます。詳しくは、「関連タイプ」の章を参照してください。
forall<Self, P1..Pn, Pn+1..Pm> {
  ProjectionEq(
    <Self as Trait<P1..Pn>>::AssocType<Pn+1..Pm> =
    (Trait::AssocType)<Self, P1..Pn, Pn+1..Pm>
  )
}
```

<!--The next rule covers implied bounds for the projection.-->
次の規則は、投影の暗黙の境界をカバーしています。
<!--In particular, the `Bounds` declared on the associated type must have been proven to hold to show that the impl is well-formed, and hence we can rely on them elsewhere.-->
具体的には、関連タイプで宣言された`Bounds`は、implがうまく形成されていることを示すために保持されていることが証明されている必要があるため、他の場所に依存することができます。

```text
#// Rule Implied-Bound-From-AssocTy
// ルールが暗示している
//
#// For each `Bound` in `Bounds`:
//  `Bound` in `Bounds`について：
forall<Self, P1..Pn, Pn+1..Pm> {
    FromEnv(<Self as Trait<P1..Pn>>::AssocType<Pn+1..Pm>>: Bound) :-
      FromEnv(Self: Trait<P1..Pn>)
}
```

<!--Next, we define the requirements for an instantiation of our associated type to be well-formed...-->
次に、関連する型のインスタンス化の要件を整形式に定義します。

```text
#// Rule WellFormed-AssocTy
// ルールWell-Formed-AssocTy
forall<Self, P1..Pn, Pn+1..Pm> {
    WellFormed((Trait::AssocType)<Self, P1..Pn, Pn+1..Pm>) :-
      WC1, Implemented(Self: Trait<P1..Pn>)
}
```

<!--...along with the reverse implications, when we can assume that it is well-formed.-->
...逆の意味と一緒に、それがうまく形成されていると仮定することができます。

```text
#// Rule Implied-WC-From-AssocTy
// ルールが暗示する -WC-AssocTy
//
#// For each where clause WC1:
// 各where句についてWC1：
forall<Self, P1..Pn, Pn+1..Pm> {
    FromEnv(WC1) :- FromEnv((Trait::AssocType)<Self, P1..Pn, Pn+1..Pm>)
}
```

```text
#// Rule Implied-Trait-From-AssocTy
// ルールが暗示する -Trait-From-AssocTy
forall<Self, P1..Pn, Pn+1..Pm> {
    FromEnv(Self: Trait<P1..Pn>) :-
      FromEnv((Trait::AssocType)<Self, P1..Pn, Pn+1..Pm>)
}
```

### <!--Lowering function and constant declarations--> 関数と定数の宣言を下げる

<!--Chalk didn't model functions and constants, but I would eventually like to treat them exactly like normalization.-->
チョークは関数と定数をモデル化していませんでしたが、最終的に正規化と同じように取り扱いたいと思います。
<!--See [the section on function/constant values below](#constant-vals) for more details.-->
詳細について[は、関数/定数の項を参照](#constant-vals)してください。

## <!--Lowering impls--> 下げることは意味する

<!--Given an impl of a trait:-->
特性のインプラントを与えられた：

```rust,ignore
impl<P0..Pn> Trait<A1..An> for A0
where WC
{
#    // zero or more impl items
    // ゼロ個以上のインプットアイテム
}
```

<!--Let `TraitRef` be the trait reference `A0: Trait<A1..An>`.-->
`TraitRef`特性参照`A0: Trait<A1..An>`。
<!--Then we will create the following rules:-->
次に、次のルールを作成します。

```text
#// Rule Implemented-From-Impl
// 実装されたルール
forall<P0..Pn> {
  Implemented(TraitRef) :- WC
}
```

<!--In addition, we will lower all of the *impl items*.-->
さらに、すべての*インプラント項目*を下げ*ます*。

## <!--Lowering impl items--> インプルアイテムを下げる

### <!--Associated type values--> 関連付けられた型の値

<!--Given an impl that contains:-->
与えられたimplを含む：

```rust,ignore
impl<P0..Pn> Trait<P1..Pn> for P0
where WC_impl
{
    type AssocType<Pn+1..Pm> = T;
}
```

<!--and our where clause `WC1` on the trait associated type from above, we produce the following rule:-->
上記のtrait関連型のwhere節`WC1`では、次のルールを生成します。

```text
#// Rule Normalize-From-Impl
// ルール正規化-Implから
forall<P0..Pm> {
  forall<Pn+1..Pm> {
    Normalize(<P0 as Trait<P1..Pn>>::AssocType<Pn+1..Pm> -> T) :-
      Implemented(P0 as Trait) && WC1
  }
}
```

<!--Note that `WC_impl` and `WC1` both encode where-clauses that the impl can rely on.-->
`WC_impl`と`WC1`どちらも、implが依存できるwhere節をエンコードすることに注意してください。
<!--(`WC_impl` is not used here, because it is implied by `Implemented(P0 as Trait)`.)-->
（`Implemented(P0 as Trait)`によって暗示されているため、`WC_impl`はここでは使用されません`Implemented(P0 as Trait)`。

<span id="constant-vals"></span>
### <!--Function and constant values--> 関数と定数

<!--Chalk didn't model functions and constants, but I would eventually like to treat them exactly like normalization.-->
チョークは関数と定数をモデル化していませんでしたが、最終的に正規化と同じように取り扱いたいと思います。
<!--This presumably involves adding a new kind of parameter (constant), and then having a `NormalizeValue` domain goal.-->
これには、新しい種類のパラメータ（定数）を追加し、次に`NormalizeValue`ドメインの目標を持つことが含まれます。
<!--This is *to be written* because the details are a bit up in the air.-->
これは、細部が空中でちょっと上にあるため*に書かれています*。
