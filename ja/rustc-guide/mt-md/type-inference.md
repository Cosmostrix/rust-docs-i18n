# <!--Type inference--> 型推論

<!--Type inference is the process of automatic detection of the type of an expression.-->
型推論は、式の型の自動検出のプロセスです。

<!--It is what allows Rust to work with fewer or no type annotations, making things easier for users:-->
これは、Rustがタイプアノテーションの数を減らしたり、使用しないようにすることで、ユーザにとってより使いやすくなりました。

```rust,ignore
fn main() {
    let mut things = vec![];
    things.push("thing")
}
```

<!--Here, the type of `things` is *inferenced* to be `&str` because that's the value we push into `things`.-->
ここで、`things`の型は`&str`で`things`と*推論さ*れ`&str`なぜなら、それが私たちが`things`に押し込む価値だからです。

<!--The type inference is based on the standard Hindley-Milner (HM) type inference algorithm, but extended in various way to accommodate subtyping, region inference, and higher-ranked types.-->
型推論は、標準的なHindley-Milner（HM）型の推論アルゴリズムに基づいていますが、サブタイプ、領域推論、および上位ランクの型に対応するためにさまざまな方法で拡張されています。

## <!--A note on terminology--> 用語に関する注記

<!--We use the notation `?T` to refer to inference variables, also called existential variables.-->
我々は推論変数（実在変数とも呼ばれる）を参照するために`?T`という表記を使用する。

<!--We use the terms "region"and "lifetime"interchangeably.-->
私たちは、「地域」と「生涯」という言葉を同じ意味で使用しています。
<!--Both refer to the `'a` in `&'a T`.-->
両方とも、`'a` in `&'a T` `'a`指す。

<!--The term "bound region"refers to a region that is bound in a function signature, such as the `'a` in `for<'a> fn(&'a u32)`.-->
「結合領域」という用語は、`'a` in `for<'a> fn(&'a u32)`ような関数シグネチャにバインドされた領域を指します。
<!--A region is "free"if it is not bound.-->
領域が束縛されていない場合、領域は「フリー」です。

## <!--Creating an inference context--> 推論コンテキストの作成

<!--You create and "enter"an inference context by doing something like the following:-->
あなたは、次のようなことをして、推論コンテキストを作成して「入力」します。

```rust,ignore
tcx.infer_ctxt().enter(|infcx| {
#    // Use the inference context `infcx` here.
    // ここで推論コンテキスト`infcx`使用してください。
})
```

<!--Each inference context creates a short-lived type arena to store the fresh types and things that it will create, as described in the [chapter on the `ty` module][ty-ch].-->
それぞれの推論コンテキストは[、`ty`モジュールの章で][ty-ch]説明されているように、作成する新しいタイプとものを格納する短命型のアリーナを作成し[ます][ty-ch]。
<!--This arena is created by the `enter` function and disposed of after it returns.-->
このアリーナは、`enter`機能によって作成され、返された後に処分されます。

[ty-ch]: ty.html

<!--Within the closure, `infcx` has the type `InferCtxt<'cx, 'gcx, 'tcx>` for some fresh `'cx` and `'tcx` – the latter corresponds to the lifetime of this temporary arena, and the `'cx` is the lifetime of the `InferCtxt` itself.-->
閉鎖内では、いくつかの新鮮な`'cx`と`'tcx`に対して、`infcx`は`InferCtxt<'cx, 'gcx, 'tcx>`型を`InferCtxt<'cx, 'gcx, 'tcx>`後者はこの一時的なアリーナの存続期間に対応し、`'cx`は`InferCtxt`自身。
<!--(Again, see the [`ty` chapter][ty-ch] for more details on this setup.)-->
（ここでも、参照[`ty`章][ty-ch]この設定の詳細については、を。）

<!--The `tcx.infer_ctxt` method actually returns a builder, which means there are some kinds of configuration you can do before the `infcx` is created.-->
`tcx.infer_ctxt`メソッドは実際にビルダーを返します。`infcx`、 `infcx`を作成する前にいくつかの設定ができます。
<!--See `InferCtxtBuilder` for more information.-->
詳細については、`InferCtxtBuilder`を参照してください。

<span id="vars"></span>
## <!--Inference variables--> 推論変数

<!--The main purpose of the inference context is to house a bunch of **inference variables** – these represent types or regions whose precise value is not yet known, but will be uncovered as we perform type-checking.-->
推論コンテキストの主な目的は、推論**変数の**束を収容すること**です。**これらは、正確な値が未知である型または領域を表しますが、型チェックを実行すると明らかになります。

<!--If you're familiar with the basic ideas of unification from HM type systems, or logic languages like Prolog, this is the same concept.-->
HM型システムやPrologのような論理言語からの統一の基本的な考え方に精通しているなら、これは同じ概念です。
<!--If you're not, you might want to read a tutorial on how HM type inference works, or perhaps this blog post on [unification in the Chalk project].-->
そうでない場合は、HM型推論の仕組みや[unification in the Chalk project]に関するブログ記事を読むことをお勧めします。

[Unification in the Chalk project]: http://smallcultfollowing.com/babysteps/blog/2017/03/25/unification-in-chalk-part-1/

<!--All told, the inference context stores four kinds of inference variables as of this writing:-->
結論として、推論コンテキストは、この執筆時点で、4種類の推論変数を格納しています。

- <!--Type variables, which come in three varieties:-->
   型変数は、3つの種類があります：
  - <!--General type variables (the most common).-->
     一般的な型変数（最も一般的なもの）。
<!--These can be unified with any type.-->
     これらはどのタイプでも統一できます。
  - <!--Integral type variables, which can only be unified with an integral type, and arise from an integer literal expression like `22`.-->
     整数型でのみ統一でき、`22`ような整数のリテラル式から生まれる整数型変数。
  - <!--Float type variables, which can only be unified with a float type, and arise from a float literal expression like `22.0`.-->
     浮動小数点型変数は、浮動小数点型でのみ統合でき、`22.0`ような浮動小数点型のリテラル式から生まれます。
- <!--Region variables, which represent lifetimes, and arise all over the place.-->
   生存期間を表し、その場全体で発生する領域変数。

<!--All the type variables work in much the same way: you can create a new type variable, and what you get is `Ty<'tcx>` representing an unresolved type `?T`.-->
あなたは新しいタイプの変数を作成することができ、そして何を得ることである：すべてのタイプの変数は、ほとんど同じように動作する`Ty<'tcx>`未解決のタイプ表す`?T`。
<!--Then later you can apply the various operations that the inferencer supports, such as equality or subtyping, and it will possibly **instantiate** (or **bind**) that `?T` to a specific value as a result.-->
その後、等号やサブタイプなどの推論機能がサポートするさまざまな操作を適用することができます。結果として、その`?T`を特定の値に**インスタンス化**（または**バインド**）し`?T`。

<!--The region variables work somewhat differently, and are described below in a separate section.-->
リージョン変数は多少異なる働きをしますが、以下で別のセクションで説明します。

## <!--Enforcing equality / subtyping--> 等価/サブタイプの強制

<!--The most basic operations you can perform in the type inferencer is **equality**, which forces two types `T` and `U` to be the same.-->
型推論で実行できる最も基本的な操作は**等価で**、 `T`と`U` 2つの型を同じにします。
<!--The recommended way to add an equality constraint is to use the `at` method, roughly like so:-->
等価制約を追加するための推奨される方法は、`at`メソッドを使用することです。

```rust,ignore
infcx.at(...).eq(t, u);
```

<!--The first `at()` call provides a bit of context, ie why you are doing this unification, and in what environment, and the `eq` method performs the actual equality constraint.-->
最初の`at()`コールは少しのコンテキストを提供します。つまり、なぜこの統一を行い、どのような環境で、`eq`メソッドが実際の等価制約を実行するのかです。

<!--When you equate things, you force them to be precisely equal.-->
あなたが物事を同等にするとき、あなたはそれらが正確に等しくなるように強制します。
<!--Equating returns an `InferResult` – if it returns `Err(err)`, then equating failed, and the enclosing `TypeError` will tell you what went wrong.-->
`InferResult`は`InferResult`返します。それが`Err(err)`返した場合、`InferResult`失敗し、囲む`TypeError`は何がうまくいかなかったかを示します。

<!--The success case is perhaps more interesting.-->
成功事例はおそらくもっと面白いでしょう。
<!--The "primary"return type of `eq` is `()` – that is, when it succeeds, it doesn't return a value of any particular interest.-->
`eq`の「主」戻り値の型は`()`です。つまり、成功すると、特に関心のある値を返しません。
<!--Rather, it is executed for its side-effects of constraining type variables and so forth.-->
むしろ、型変数などの制約の副作用のために実行されます。
<!--However, the actual return type is not `()`, but rather `InferOk<()>`.-->
しかし、実際の戻り値の型は`()`ではなく、`InferOk<()>`です。
<!--The `InferOk` type is used to carry extra trait obligations – your job is to ensure that these are fulfilled (typically by enrolling them in a fulfillment context).-->
`InferOk`タイプは、特別な義務を負うために使用されます。あなたの仕事は、これらの条件が満たされることを保証することです（通常、履行状況に登録することによって）。
<!--See the [trait chapter] for more background on that.-->
その背景については、[trait chapter]を参照してください。

[trait chapter]: traits/resolution.html

<!--You can similarly enforce subtyping through `infcx.at(..).sub(..)`.-->
同様に、`infcx.at(..).sub(..)`を`infcx.at(..).sub(..)`してサブタイプを強制することができ`infcx.at(..).sub(..)`。
<!--The same basic concepts as above apply.-->
上記と同じ基本概念が適用されます。

## <!--"Trying"equality--> 平等を「試す」

<!--Sometimes you would like to know if it is *possible* to equate two types without error.-->
場合によっては、エラーなしで2つのタイプを同等にすることが*可能*かどうかを知りたい場合があります。
<!--You can test that with `infcx.can_eq` (or `infcx.can_sub` for subtyping).-->
あなたがそれをテストすることができ`infcx.can_eq`（または`infcx.can_sub`サブタイピングのため）。
<!--If this returns `Ok`, then equality is possible – but in all cases, any side-effects are reversed.-->
これが`Ok`返す場合、等価は可能ですが、すべての場合において副作用が逆転します。

<!--Be aware, though, that the success or failure of these methods is always **modulo regions**.-->
ただし、これらのメソッドの成功または失敗は常に**モジュロ領域**であることに注意してください。
<!--That is, two types `&'a u32` and `&'b u32` will return `Ok` for `can_eq`, even if `'a != 'b`.-->
つまり、`'a != 'b`であっても、`&'b u32` `&'a u32`と`&'b u32` 2つの型は、`can_eq`に対して`Ok`を`can_eq`ます。
<!--This falls out from the "two-phase"nature of how we solve region constraints.-->
これは、地域の制約をどのように解決するかという「2段階」の性質から逸脱しています。

## <!--Snapshots--> スナップショット

<!--As described in the previous section on `can_eq`, often it is useful to be able to do a series of operations and then roll back their side-effects.-->
`can_eq`の前のセクションで説明したように、一連の操作を実行して副作用をロールバックできることがしばしば役に立ちます。
<!--This is done for various reasons: one of them is to be able to backtrack, trying out multiple possibilities before settling on which path to take.-->
これはさまざまな理由で行われます。そのうちの1つは、取り戻すことができ、複数の可能性を試してから、どのパスを取るか決めることです。
<!--Another is in order to ensure that a series of smaller changes take place atomically or not at all.-->
もう一つは、一連の小さな変化が原子的に起こるかどうかを確実にするためです。

<!--To allow for this, the inference context supports a `snapshot` method.-->
これを可能にするために、推論コンテキストは`snapshot`メソッドをサポートします。
<!--When you call it, it will start recording changes that occur from the operations you perform.-->
これを呼び出すと、実行した操作から発生した変更の記録が開始されます。
<!--When you are done, you can either invoke `rollback_to`, which will undo those changes, or else `confirm`, which will make the permanent.-->
完了したら、`rollback_to`呼び出すことができます。これは、変更を取り消します。そうでない場合は、`confirm`て永続化します。
<!--Snapshots can be nested as long as you follow a stack-like discipline.-->
スナップショットは、スタック状の規律に従う限りネストできます。

<!--Rather than use snapshots directly, it is often helpful to use the methods like `commit_if_ok` or `probe` that encapsulate higher-level patterns.-->
スナップショットを直接使うのではなく、より高いレベルのパターンをカプセル化する`commit_if_ok`や`probe`ようなメソッドを使うと便利です。

## <!--Subtyping obligations--> サブタイプの義務

<!--One thing worth discussing is subtyping obligations.-->
議論する価値のあることの1つは、サブタイプの義務です。
<!--When you force two types to be a subtype, like `?T <: i32`, we can often convert those into equality constraints.-->
`?T <: i32`ように、2つの型を強制的にサブタイプにすると、それらを等価制約に変換することができます。
<!--This follows from Rust's rather limited notion of subtyping: so, in the above case, `?T <: i32` is equivalent to `?T = i32`.-->
これは、Rustの限定されたサブタイプ化の考え方に従います`?T <: i32`つまり、上記の場合、`?T <: i32`は`?T = i32`相当し`?T = i32`。

<!--However, in some cases we have to be more careful.-->
しかし、場合によってはもっと注意する必要があります。
<!--For example, when regions are involved.-->
例えば、領域が関与している場合。
<!--So if you have `?T <: &'a i32`, what we would do is to first "generalize"`&'a i32` into a type with a region variable: `&'?b i32`, and then unify `?T` with that (`?T = &'?b i32`).-->
あなたが持っているのであれば`?T <: &'a i32`、私たちはどうなることはまず『一般』にある`&'a i32`：型に領域変数と`&'?b i32`して、統一`?T`それと（`?T = &'?b i32`）。
<!--We then relate this new variable with the original bound:-->
次に、この新しい変数を元の境界と関連付けます。

```text
&'?b i32 <: &'a i32
```

<!--This will result in a region constraint (see below) of `'?b: 'a`.-->
これにより、`'?b: 'a`領域制約（下記参照）が発生し`'?b: 'a`。

<!--One final interesting case is relating two unbound type variables, like `?T <: ?U`.-->
1つの最後の興味深いケースは、2つの非結合型変数、例えば`?T <: ?U`関連付けること`?T <: ?U`。
<!--In that case, we can't make progress, so we enqueue an obligation `Subtype(?T, ?U)` and return it via the `InferOk` mechanism.-->
その場合、我々は進歩を遂げることができないので、義務`Subtype(?T, ?U)`をエンキューし、`InferOk`メカニズムを介してそれを返します。
<!--You'll have to try again when more details about `?T` or `?U` are known.-->
`?T`か`?U`についての詳細が分かっ`?U`、もう一度やり直す必要があります。

## <!--Region constraints--> 地域の制約

<!--Regions are inferenced somewhat differently from types.-->
リージョンはタイプとは多少推論されます。
<!--Rather than eagerly unifying things, we simply collect constraints as we go, but make (almost) no attempt to solve regions.-->
熱心に物事を統一するのではなく、私たちが行くにつれて制約を集めるだけですが、（ほとんど）地域を解決しようとする試みはありません。
<!--These constraints have the form of an "outlives"constraint:-->
これらの制約は、「outlives」制約の形式をとります。

```text
'a: 'b
```

<!--Actually the code tends to view them as a subregion relation, but it's the same idea:-->
実際には、コードはそれらを部分領域の関係として見る傾向がありますが、同じ考えです。

```text
'b <= 'a
```

<!--(There are various other kinds of constraints, such as "verifys"; see the `region_constraints` module for details.)-->
（"verifys"など、さまざまな種類の制約があります;詳細については、`region_constraints`モジュールを参照してください）。

<!--There is one case where we do some amount of eager unification.-->
私たちがある程度の熱心な統一を行うケースが1つあります。
<!--If you have an equality constraint between two regions-->
2つの地域の間に等しい制約がある場合

```text
'a = 'b
```

<!--we will record that fact in a unification table.-->
その事実を統一表に記録する。
<!--You can then use `opportunistic_resolve_var` to convert `'b` to `'a` (or vice versa).-->
その後、`opportunistic_resolve_var`を使用して`'b`を`'a`（またはその逆）に変換することができます。
<!--This is sometimes needed to ensure termination of fixed-point algorithms.-->
これは、固定小数点アルゴリズムの終了を確実にするために必要なことがあります。

## <!--Extracting region constraints--> 領域の制約を抽出する

<!--Ultimately, region constraints are only solved at the very end of type-checking, once all other constraints are known.-->
最終的に、領域制約は、タイプ・チェッキングの最後でのみ解かれます。他のすべての制約がわかっているとします。
<!--There are two ways to solve region constraints right now: lexical and non-lexical.-->
今すぐリージョンの制約を解決するには、字句と非字句の2つの方法があります。
<!--Eventually there will only be one.-->
最終的には1つしかありません。

<!--To solve **lexical** region constraints, you invoke `resolve_regions_and_report_errors`.-->
**字句**領域の制約を解決するには、`resolve_regions_and_report_errors`を呼び出し`resolve_regions_and_report_errors`。
<!--This "closes"the region constraint process and invoke the `lexical_region_resolve` code.-->
これは、領域制約プロセスを「クローズ」し、`lexical_region_resolve`コードを呼び出します。
<!--Once this is done, any further attempt to equate or create a subtyping relationship will yield an ICE.-->
これが完了すると、サブタイピング関係を同一化または作成しようとするさらなる試みは、ICEを生じる。

<!--Non-lexical region constraints are not handled within the inference context.-->
非語彙領域の制約は、推論コンテキスト内では処理されません。
<!--Instead, the NLL solver (actually, the MIR type-checker) invokes `take_and_reset_region_constraints` periodically.-->
代わりに、NLLソルバ（実際には、MIR型チェッカ）は`take_and_reset_region_constraints`定期的に呼び出します。
<!--This extracts all of the outlives constraints from the region solver, but leaves the set of variables intact.-->
これは、領域ソルバからすべてのアウトライブ制約を抽出しますが、変数セットはそのまま残します。
<!--This is used to get *just* the region constraints that resulted from some particular point in the program, since the NLL solver needs to know not just *what* regions were subregions but *where*.-->
NLLソルバは領域がサブ領域が、*どこ*だっただけでなく、*何を*知っている必要があるので、これは、プログラム内のいくつかの特定のポイントに起因する*だけで*地域の制約を取得するために使用されます。
<!--Finally, the NLL solver invokes `take_region_var_origins`, which "closes"the region constraint process in the same way as normal solving.-->
最後に、NLLソルバは`take_region_var_origins`呼び出し、通常の解決と同じ方法で領域制約プロセスを「閉じる」。

## <!--Lexical region resolution--> 字句領域の解像度

<!--Lexical region resolution is done by initially assigning each region variable to an empty value.-->
字句領域の解決は、各領域変数を最初に空の値に割り当てることによって行われます。
<!--We then process each outlives constraint repeatedly, growing region variables until a fixed-point is reached.-->
その後、各アウトライブ制約を繰り返し処理し、固定小数点に達するまで領域変数を拡張します。
<!--Region variables can be grown using a least-upper-bound relation on the region lattice in a fairly straightforward fashion.-->
領域変数は、かなり単純な方法で領域格子上の最小上界関係を用いて成長させることができる。
