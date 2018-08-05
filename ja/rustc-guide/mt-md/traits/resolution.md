# <!--Trait resolution (old-style)--> 特性解像度（旧式）

<!--This chapter describes the general process of  _trait resolution_  and points out some non-obvious things.-->
この章では、 _形質の解決の_ 一般的なプロセスについて説明し、いくつかの非明白な事柄を指摘する。

<!--**Note:** This chapter (and its subchapters) describe how the trait solver **currently** works.-->
**注意：**この章（およびそのサブセクション）では、**現在**、形質ソルバーがどのように機能しているかについて説明して**い**ます。
<!--However, we are in the process of designing a new trait solver.-->
しかし、我々は新しい形質ソルバーを設計する過程にある。
<!--If you'd prefer to read about *that*, see [*this* traits chapter](./traits/index.html).-->
あなたが*それ*について読むこと*を*好むなら、[*この*特徴の章を](./traits/index.html)見てください。

## <!--Major concepts--> 主なコンセプト

<!--Trait resolution is the process of pairing up an impl with each reference to a trait.-->
形質の解像度は、特性を参照するたびにインプラントをペアリングするプロセスです。
<!--So, for example, if there is a generic function like:-->
たとえば、次のような汎用関数があるとします。

```rust,ignore
fn clone_slice<T:Clone>(x: &[T]) -> Vec<T> { ... }
```

<!--and then a call to that function:-->
その関数への呼び出し：

```rust,ignore
let v: Vec<isize> = clone_slice(&[1, 2, 3])
```

<!--it is the job of trait resolution to figure out whether there exists an impl of (in this case) `isize : Clone`.-->
`isize : Clone`が存在するかどうかを知ることは、特性決定の仕事です。

<!--Note that in some cases, like generic functions, we may not be able to find a specific impl, but we can figure out that the caller must provide an impl.-->
場合によっては、ジェネリック関数のように特定のimplを見つけることができないかもしれないが、呼び出し元がimplを指定しなければならないことがわかる。
<!--For example, consider the body of `clone_slice`:-->
たとえば、`clone_slice`の本文を考えてみ`clone_slice`。

```rust,ignore
fn clone_slice<T:Clone>(x: &[T]) -> Vec<T> {
    let mut v = Vec::new();
    for e in &x {
#//        v.push((*e).clone()); // (*)
        v.push((*e).clone()); // （*）
    }
}
```

<!--The line marked `(*)` is only legal if `T` (the type of `*e`) implements the `Clone` trait.-->
`T`（ `*e`の型）が`Clone`特性を実装している場合、`(*)`と書かれた行は合法です。
<!--Naturally, since we don't know what `T` is, we can't find the specific impl;-->
当然、`T`が何であるかわからないので、特定のインプットを見つけることはできません。
<!--but based on the bound `T:Clone`, we can say that there exists an impl which the caller must provide.-->
バインドされた`T:Clone`に基づいて、呼び出し元が提供しなければならないインプリメンテーションが存在すると言うことができます。

<!--We use the term *obligation* to refer to a trait reference in need of an impl.-->
我々は、*義務*という用語をインプラントが必要な形質の参照と呼ぶことにする。
<!--Basically, the trait resolution system resolves an obligation by proving that an appropriate impl does exist.-->
基本的に、特性決定システムは、適切なインプラントが存在することを証明することによって義務を解決する。

<!--During type checking, we do not store the results of trait selection.-->
タイプチェックの間、我々は形質選択の結果を保存しない。
<!--We simply wish to verify that trait selection will succeed.-->
我々は単に形質の選択が成功することを確認したい。
<!--Then later, at trans time, when we have all concrete types available, we can repeat the trait selection to choose an actual implementation, which will then be generated in the output binary.-->
その後、トランスタイムで、すべての具体的なタイプが利用可能になったら、特性選択を繰り返して実際の実装を選択し、出力バイナリで生成します。

## <!--Overview--> 概要

<!--Trait resolution consists of three major parts:-->
特性の解決は、3つの主要な部分で構成されています。

- <!--**Selection**: Deciding how to resolve a specific obligation.-->
   **選択**：特定の義務を解決する方法を決定する。
<!--For example, selection might decide that a specific obligation can be resolved by employing an impl which matches the `Self` type, or by using a parameter bound (eg `T: Trait`).-->
   例えば、セレクションでは、`Self`型と一致するimplを使用するか、パラメータの束縛（たとえば`T: Trait`）を使用することによって、特定の義務を解決できるかどうかを判断できます。
<!--In the case of an impl, selecting one obligation can create *nested obligations* because of where clauses on the impl itself.-->
   インプラントの場合、1つの義務を選択すると、インプレス自体のwhere句のために*ネストされた義務*が作成*される*可能性があります。
<!--It may also require evaluating those nested obligations to resolve ambiguities.-->
   また、あいまいさを解決するためにこれらのネストされた義務を評価する必要があります。

- <!--**Fulfillment**: The fulfillment code is what tracks that obligations are completely fulfilled.-->
   **フルフィルメント**： **フルフィルメント**コードは、その義務が完全に履行されることを追跡するものです。
<!--Basically it is a worklist of obligations to be selected: once selection is successful, the obligation is removed from the worklist and any nested obligations are enqueued.-->
   基本的には、選択する義務のワークリストです。選択が成功すると、義務はワークリストから削除され、ネストされた義務はすべてエンキューされます。

- <!--**Coherence**: The coherence checks are intended to ensure that there are never overlapping impls, where two impls could be used with equal precedence.-->
   **一貫性**：一貫性検査は、重複するimplがないことを確実にすることを目的としています.2つのimplを同じ優先順位で使用することができます。

## <!--Selection--> 選択

<!--Selection is the process of deciding whether an obligation can be resolved and, if so, how it is to be resolved (via impl, where clause, etc).-->
選択は、義務が解決できるかどうかを決定するプロセスであり、もしそうであれば、それをどのように解決するか（impl、where句など）。
<!--The main interface is the `select()` function, which takes an obligation and returns a `SelectionResult`.-->
主なインターフェイスは`select()`関数で、これは義務を引き受け、`SelectionResult`を返します。
<!--There are three possible outcomes:-->
可能な結果は3つあります。

- <!--`Ok(Some(selection))` – yes, the obligation can be resolved, and `selection` indicates how.-->
   `Ok(Some(selection))` -はい、義務を解決することができ、`selection`方法を示します。
<!--If the impl was resolved via an impl, then `selection` may also indicate nested obligations that are required by the impl.-->
   implがimplを介して解決された場合、`selection`はimplによって必要とされるネストされた義務を示すかもしれない。

- <!--`Ok(None)` – we are not yet sure whether the obligation can be resolved or not.-->
   `Ok(None)` -義務が解決できるかどうかはまだわかりません。
<!--This happens most commonly when the obligation contains unbound type variables.-->
   債務が非連結型変数を含む場合、これが最も一般的です。

- <!--`Err(err)` – the obligation definitely cannot be resolved due to a type error or because there are no impls that could possibly apply.-->
   `Err(err)` -タイプエラーのために義務が確実に解決できないか、あるいは適用可能なインプラントがないためです。

<!--The basic algorithm for selection is broken into two big phases: candidate assembly and confirmation.-->
選択のための基本的なアルゴリズムは、2つの大きな段階に分かれています：候補組立と確認。

<!--Note that because of how lifetime inference works, it is not possible to give back immediate feedback as to whether a unification or subtype relationship between lifetimes holds or not.-->
生涯推論がどのように機能するかにより、生存期間の統一または亜種の関係が成立するかどうかについての即時のフィードバックを返すことはできないことに注意してください。
<!--Therefore, lifetime matching is *not* considered during selection.-->
したがって、選択時にライフタイムマッチングは考慮され*ません*。
<!--This is reflected in the fact that subregion assignment is infallible.-->
これは、部分領域の割り当てが間違いないことに反映されます。
<!--This may yield lifetime constraints that will later be found to be in error (in contrast, the non-lifetime-constraints have already been checked during selection and can never cause an error, though naturally they may lead to other errors downstream).-->
これは、後でエラーとなる生涯の制約をもたらす可能性がある（対照的に、非生涯制約は既に選択中にチェックされており、決してエラーを引き起こすことはできない。

### <!--Candidate assembly--> 候補組立

<!--Searches for impls/where-clauses/etc that might possibly be used to satisfy the obligation.-->
義務を満たすために使用されるかもしれないimpls / where-clauses / etcを検索します。
<!--Each of those is called a candidate.-->
それらのそれぞれは候補者と呼ばれます。
<!--To avoid ambiguity, we want to find exactly one candidate that is definitively applicable.-->
あいまいさを避けるために、我々は明確に適用可能な1つの候補を正確に探したい。
<!--In some cases, we may not know whether an impl/where-clause applies or not – this occurs when the obligation contains unbound inference variables.-->
場合によっては、impl / where句が適用されるかどうかわからない場合があります。これは、義務にバインドされていない推論変数が含まれている場合に発生します。

<!--The subroutines that decide whether a particular impl/where-clause/etc applies to a particular obligation are collectively refered to as the process of  _matching_ .-->
特定の義務に特定のimpl / where-clause / etcが適用されるかどうかを決定するサブルーチンは、まとめて _マッチング_ のプロセスと呼ばれます。
<!--At the moment, this amounts to unifying the `Self` types, but in the future we may also recursively consider some of the nested obligations, in the case of an impl.-->
現時点では、これは`Self`タイプを統一することになりますが、将来、インプラントの場合には、ネストされた義務のいくつかを再帰的に検討することもあります。

<!--**TODO**: what does "unifying the `Self` types"mean?-->
**TODO**：「 `Self`タイプを統一する」とはどういう意味ですか？
<!--The `Self` of the obligation with that of an impl?-->
インプラントの義務の`Self`？

<!--The basic idea for candidate assembly is to do a first pass in which we identify all possible candidates.-->
候補組立の基本的な考え方は、可能性のあるすべての候補を特定する最初のパスを実行することです。
<!--During this pass, all that we do is try and unify the type parameters.-->
このパスでは、タイプパラメータを統一しようとするだけです。
<!--(In particular, we ignore any nested where clauses.) Presuming that this unification succeeds, the impl is added as a candidate.-->
（特に、ネストされたwhere節は無視されます）。この統一が成功したと仮定すると、implが候補として追加されます。

<!--Once this first pass is done, we can examine the set of candidates.-->
この最初のパスが完了すると、候補のセットを調べることができます。
<!--If it is a singleton set, then we are done: this is the only impl in scope that could possibly apply.-->
シングルトンセットの場合は、これが完了します。これが適用可能な範囲内の唯一のインプリメンテーションです。
<!--Otherwise, we can winnow down the set of candidates by using where clauses and other conditions.-->
さもなければ、私たちはwhere節と他の条件を使って候補の集合を絞り込むことができます。
<!--If this reduced set yields a single, unambiguous entry, we're good to go, otherwise the result is considered ambiguous.-->
この減少したセットが単一の明白なエントリをもたらすなら、我々は行かなくてはなりません、そうでなければ結果はあいまいであると考えられます。

#### <!--The basic process: Inferring based on the impls we see--> 基本的なプロセス：我々が見るインプルメントに基づいて推論する

<!--This process is easier if we work through some examples.-->
このプロセスは、いくつかの例を試してみると簡単です。
<!--Consider the following trait:-->
次のような特性を考えてみましょう。

```rust,ignore
trait Convert<Target> {
    fn convert(&self) -> Target;
}
```

<!--This trait just has one method.-->
この形質には1つの方法しかありません。
<!--It's about as simple as it gets.-->
それはそれが得るほど簡単です。
<!--It converts from the (implicit) `Self` type to the `Target` type.-->
これは、（暗黙の）`Self`型から`Target`型に変換されます。
<!--If we wanted to permit conversion between `isize` and `usize`, we might implement `Convert` like so:-->
`isize`と`usize`間の変換を許可したい場合は、`usize`ように`Convert`を実装することができます：

```rust,ignore
#//impl Convert<usize> for isize { ... } // isize -> usize
impl Convert<usize> for isize { ... } //  isize -> usize
#//impl Convert<isize> for usize { ... } // usize -> isize
impl Convert<isize> for usize { ... } //  usize -> isize
```

<!--Now imagine there is some code like the following:-->
さて、次のようなコードがあるとしましょう：

```rust,ignore
let x: isize = ...;
let y = x.convert();
```

<!--The call to convert will generate a trait reference `Convert<$Y> for isize`, where `$Y` is the type variable representing the type of `y`.-->
convertへの呼び出しは、`Convert<$Y> for isize`。ここで、 `$Y`は`y`の型を表す型変数です。
<!--Of the two impls we can see, the only one that matches is `Convert<usize> for isize`.-->
我々が見ることができる2つの意味のうち、一致するものは`Convert<usize> for isize`です。
<!--Therefore, we can select this impl, which will cause the type of `$Y` to be unified to `usize`.-->
したがって、このimplを選択すると、`$Y`のタイプが`usize`に統一され`usize`。
<!--(Note that while assembling candidates, we do the initial unifications in a transaction, so that they don't affect one another.)-->
（候補を集めている間は、トランザクションで最初の統一を行い、相互に影響しないことに注意してください）。

<!--**TODO**: The example says we can "select"the impl, but this section is talking specifically about candidate assembly.-->
**TODO**：この例では、implを「選択」できるとしていますが、このセクションでは候補アセンブリについて具体的に話しています。
<!--Does this mean we can sometimes skip confirmation?-->
これは時には確認をスキップできることを意味しますか？
<!--Or is this poor wording?-->
それともこの貧弱な表現ですか？
<!--**TODO**: Is the unification of `$Y` part of trait resolution or type inference?-->
**TODO**： `$Y`統治しているかどうかは、特性の解明や型推論の一部ですか？
<!--Or is this not the same type of "inference variable"as in type inference?-->
あるいは、型推論の場合と同じタイプの「推論変数」ではないのですか？

#### <!--Winnowing: Resolving ambiguities--> 驚くようなこと：あいまいさを解決する

<!--But what happens if there are multiple impls where all the types unify?-->
しかし、すべての型が統一されている複数の意味がある場合はどうなりますか？
<!--Consider this example:-->
この例を考えてみましょう。

```rust,ignore
trait Get {
    fn get(&self) -> Self;
}

impl<T:Copy> Get for T {
    fn get(&self) -> T { *self }
}

impl<T:Get> Get for Box<T> {
    fn get(&self) -> Box<T> { Box::new(get_it(&**self)) }
}
```

<!--What happens when we invoke `get_it(&Box::new(1_u16))`, for example?-->
`get_it(&Box::new(1_u16))`を呼び出すとどうなりますか？
<!--In this case, the `Self` type is `Box<u16>` – that unifies with both impls, because the first applies to all types `T`, and the second to all `Box<T>`.-->
この場合、`Self`型は`Box<u16>`です。最初の型はすべての型`T`適用され、2つ目の型はすべての`Box<T>`適用されるため、両方のimplで統一されます。
<!--In order for this to be unambiguous, the compiler does a *winnowing* pass that considers `where` clauses and attempts to remove candidates.-->
これを明確にするために、コンパイラは`where`節と候補を削除しようとする考慮するパスを*調べ*ます。
<!--In this case, the first impl only applies if `Box<u16> : Copy`, which doesn't hold.-->
この場合、最初のimplは`Box<u16> : Copy`が保持していない場合にのみ適用されます。
<!--After winnowing, then, we are left with just one candidate, so we can proceed.-->
それから、私たちはただ一つの候補者しか残されていないので、進めることができます。

#### <!--`where` clauses--> `where`句

<!--Besides an impl, the other major way to resolve an obligation is via a where clause.-->
impl以外にも、義務を解決するもう1つの主要な方法は、where句を使用することです。
<!--The selection process is always given a [parameter environment] which contains a list of where clauses, which are basically obligations that we can assume are satisfiable.-->
選択プロセスには常に、基本的には納得のいくものであると仮定できる句である句のリストを含む[parameter environment]が与えられ[parameter environment]。
<!--We will iterate over that list and check whether our current obligation can be found in that list.-->
私たちはそのリストを繰り返して、現在の義務がそのリストにあるかどうかをチェックします。
<!--If so, it is considered satisfied.-->
そうであれば、満足しているとみなされます。
<!--More precisely, we want to check whether there is a where-clause obligation that is for the same trait (or some subtrait) and which can match against the obligation.-->
より正確には、同一の形質（または一部の亜種）に対する義務の義務があるかどうかを確認したいと思います。

[parameter environment]: ./param_env.html

<!--Consider this simple example:-->
以下の簡単な例を考えてみましょう。

```rust,ignore
trait A1 {
    fn do_a1(&self);
}
trait A2 : A1 { ... }

trait B {
    fn do_b(&self);
}

fn foo<X:A2+B>(x: X) {
#//    x.do_a1(); // (*)
    x.do_a1(); // （*）
#//    x.do_b();  // (#)
    x.do_b();  // （＃）
}
```

<!--In the body of `foo`, clearly we can use methods of `A1`, `A2`, or `B` on variable `x`.-->
`foo`の本体では、明らかに変数`x` `A1`、 `A2`、または`B`メソッドを使用できます。
<!--The line marked `(*)` will incur an obligation `X: A1`, while the line marked `(#)` will incur an obligation `X: B`.-->
`(*)`と書かれた行は`X: A1`義務を負うが、`(#)`行は`X: B`義務を負う。
<!--Meanwhile, the parameter environment will contain two where-clauses: `X : A2` and `X : B`.-->
一方、パラメータ環境には、`X : A2`と`X : B` 2つのwhere節が含まれます。
<!--For each obligation, then, we search this list of where-clauses.-->
各義務について、where-clauseのこのリストを検索します。
<!--The obligation `X: B` trivially matches against the where-clause `X: B`.-->
義務`X: B`はwhere節`X: B`に対して一意に一致します。
<!--To resolve an obligation `X:A1`, we would note that `X:A2` implies that `X:A1`.-->
義務`X:A1`を解決するには、`X:A2`は`X:A1`意味することに注意してください。

### <!--Confirmation--> 確認

<!-- _Confirmation_  unifies the output type parameters of the trait with the values found in the obligation, possibly yielding a type error.-->
 _確認_ は、特性の出力タイプのパラメータを義務で見つかった値と統一し、場合によってはタイプエラーが発生する可能性があります。

<!--Suppose we have the following variation of the `Convert` example in the previous section:-->
前のセクションで`Convert`例を次のように変更したとします。

```rust,ignore
trait Convert<Target> {
    fn convert(&self) -> Target;
}

#//impl Convert<usize> for isize { ... } // isize -> usize
impl Convert<usize> for isize { ... } //  isize -> usize
#//impl Convert<isize> for usize { ... } // usize -> isize
impl Convert<isize> for usize { ... } //  usize -> isize

let x: isize = ...;
#//let y: char = x.convert(); // NOTE: `y: char` now!
let y: char = x.convert(); // 注： `y: char` now！
```

<!--Confirmation is where an error would be reported because the impl specified that `Target` would be `usize`, but the obligation reported `char`.-->
確認は、`Target`が`usize`と指定されたimplが、義務は`char`報告したので、エラーが報告される`usize`です。
<!--Hence the result of selection would be an error.-->
したがって、選択の結果はエラーになります。

<!--Note that the candidate impl is chosen based on the `Self` type, but confirmation is done based on (in this case) the `Target` type parameter.-->
候補のimplは`Self`型に基づいて選択されますが、確認は（この場合は）`Target`型のパラメータに基づいて行われます。

### <!--Selection during translation--> 翻訳中の選択

<!--As mentioned above, during type checking, we do not store the results of trait selection.-->
前述のように、型チェックの際には、特性選択の結果を保存しません。
<!--At trans time, we repeat the trait selection to choose a particular impl for each method call.-->
trans時には、特性選択を繰り返して、各メソッド呼び出しに特定のimplを選択します。
<!--In this second selection, we do not consider any where-clauses to be in scope because we know that each resolution will resolve to a particular impl.-->
この2番目の選択では、各解決が特定のimplに解決されることを知っているため、where節をスコープとみなしません。

<!--One interesting twist has to do with nested obligations.-->
1つの興味深いひねりは、ネストされた義務と関連しています。
<!--In general, in trans, we only need to do a "shallow"selection for an obligation.-->
一般的に、トランスでは、義務のために「浅い」選択を行うだけです。
<!--That is, we wish to identify which impl applies, but we do not (yet) need to decide how to select any nested obligations.-->
つまり、どのインプラントが当てはまるのかを確認したいが、ネストされた義務の選択方法を決める必要はない（まだ）。
<!--Nonetheless, we *do* currently do a complete resolution, and that is because it can sometimes inform the results of type inference.-->
それにもかかわらず、私たち*は*現在、完全な解決を*し*ています。なぜなら、時には型推論の結果を知らせることができるからです。
<!--That is, we do not have the full substitutions in terms of the type variables of the impl available to us, so we must run trait selection to figure everything out.-->
つまり、私たちが利用できるインプットの型変数の点で完全な置換を持っていないので、すべてを把握するために特性選択を実行する必要があります。

<!--**TODO**: is this still talking about trans?-->
**TODO**：これはまだトランスについて話していますか？

<!--Here is an example:-->
次に例を示します。

```rust,ignore
trait Foo { ... }
impl<U, T:Bar<U>> Foo for Vec<T> { ... }

impl Bar<usize> for isize { ... }
```

<!--After one shallow round of selection for an obligation like `Vec<isize> : Foo`, we would know which impl we want, and we would know that `T=isize`, but we do not know the type of `U`.-->
`Vec<isize> : Foo`ような義務の選択の浅い1ラウンドの後、私たちが望む`T=isize`を知ることができ、`T=isize`であることが分かるだろうが、`U`のタイプは分からない。
<!--We must select the nested obligation `isize : Bar<U>` to find out that `U=usize`.-->
`U=usize`ことを知るために、ネストされた義務`isize : Bar<U>`を選択する必要があります。

<!--It would be good to only do *just as much* nested resolution as necessary.-->
必要な*だけ多くの*ネストされた解像度を行う*だけ*でよいでしょう。
<!--Currently, though, we just do a full resolution.-->
現在のところ、我々は完全な解決策をとるだけです。
