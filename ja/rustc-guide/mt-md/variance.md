# <!--Variance of type and lifetime parameters--> タイプと寿命パラメータの差異

<!--For a more general background on variance, see the [background] appendix.-->
分散に関するより一般的な背景については、[background]付録を参照してください。

[background]: ./appendix/background.html

<!--During type checking we must infer the variance of type and lifetime parameters.-->
タイプチェックの際には、タイプと寿命パラメータの分散を推測する必要があります。
<!--The algorithm is taken from Section 4 of the paper ["Taming the Wildcards: Combining Definition-and Use-Site Variance"][pldi11] published in PLDI'11 and written by Altidor et al., and hereafter referred to as The Paper.-->
このアルゴリズムは、PLDI'11で出版され、Altidorらによって書かれた、以後「The Paper」と呼ばれる論文[「ワイルドカードを飼いならすこと：定義と使用の場所の差異を組み合わせる」の][pldi11]第4章から取られている。

[pldi11]: https://people.cs.umass.edu/~yannis/variance-extended2011.pdf

<!--This inference is explicitly designed *not* to consider the uses of types within code.-->
この推論は、コード内の型の使用を考慮し*ない*ように明示的に設計されて*い*ます。
<!--To determine the variance of type parameters defined on type `X`, we only consider the definition of the type `X` and the definitions of any types it references.-->
タイプ`X`で定義されたタイプパラメータの分散を決定するために、タイプ`X`の定義とそれが参照するタイプの定義のみを考慮する。

<!--We only infer variance for type parameters found on *data types* like structs and enums.-->
構造体や列挙*型*などの*データ型で*見つかった型パラメータの分散のみを推測します。
<!--In these cases, there is a fairly straightforward explanation for what variance means.-->
このような場合には、分散が何を意味するのかについて、かなり簡単な説明があります。
<!--The variance of the type or lifetime parameters defines whether `T<A>` is a subtype of `T<B>` (resp. `T<'a>` and `T<'b>`) based on the relationship of `A` and `B` (resp. `'a` and `'b`).-->
タイプまたはライフタイムパラメータの分散は、`A`と`B`関係に基づいて`T<A>`が`T<B>`（ `T<'a>`と`T<'b>`）のサブタイプであるかどうかを定義`'a`と`'b`）。

<!--We do not infer variance for type parameters found on traits, functions, or impls.-->
私たちは、形質、関数、またはインプリメンテーション上に見いだされるタイプのパラメータについては、分散を推測しません。
<!--Variance on trait parameters can indeed make sense (and we used to compute it) but it is actually rather subtle in meaning and not that useful in practice, so we removed it.-->
特性パラメータの差異は実際には意味をなさない（そして、それを計算するために使用された）が、実際には意味が微妙であり、実用的ではないので、削除した。
<!--See the [addendum] for some details.-->
詳細は[addendum]を参照してください。
<!--Variances on function/impl parameters, on the other hand, doesn't make sense because these parameters are instantiated and then forgotten, they don't persist in types or compiled byproducts.-->
一方、関数/ implパラメータの分散は、これらのパラメータがインスタンス化されてから忘れられるため、型やコンパイルされた副産物に残らないため、意味をなさない。

[addendum]: #addendum

> <!--**Notation**-->
> **記法**
> 
> <!--We use the notation of The Paper throughout this chapter:-->
> この章では、The Paperの表記法を使用しています。
> 
> - <!--`+` is  _covariance_ .-->
>    `+`は _共分散である_ 。
> - <!--`-` is  _contravariance_ .-->
>    `-`  _反共分散_ です。
> - <!--`*` is  _bivariance_ .-->
>    `*`は二 _変数_ です。
> - <!--`o` is  _invariance_ .-->
>    `o`は _不変である_ 。

## <!--The algorithm--> アルゴリズム

<!--The basic idea is quite straightforward.-->
基本的な考え方はとても簡単です。
<!--We iterate over the types defined and, for each use of a type parameter `X`, accumulate a constraint indicating that the variance of `X` must be valid for the variance of that use site.-->
定義された型を反復し、型パラメータ`X`使用するたびに、`X`の分散がその使用サイトの分散に対して有効でなければならないことを示す制約を累積します。
<!--We then iteratively refine the variance of `X` until all constraints are met.-->
次に、すべての制約が満たされるまで`X`の分散を繰り返し調整します。
<!--There is *always* a solution, because at the limit we can declare all type parameters to be invariant and all constraints will be satisfied.-->
制限があると、すべての型パラメーターを不変であると宣言でき、すべての制約が満たされるため、*常に*解があります。

<!--As a simple example, consider:-->
簡単な例として、次の点を考慮してください。

```rust,ignore
enum Option<A> { Some(A), None }
enum OptionalFn<B> { Some(|B|), None }
enum OptionalMap<C> { Some(|C| -> C), None }
```

<!--Here, we will generate the constraints:-->
ここでは、制約を生成します。

```text
1. V(A) <= +
2. V(B) <= -
3. V(C) <= +
4. V(C) <= -
```

<!--These indicate that (1) the variance of A must be at most covariant;-->
これらは、（1）Aの分散が最大で共変でなければならないこと、
<!--(2) the variance of B must be at most contravariant;-->
（2）Bの分散は、ほとんど反則でなければならない。
<!--and (3, 4) the variance of C must be at most covariant *and* contravariant.-->
（3、4）Cの分散は、最大で共変*で*反変でなければならない。
<!--All of these results are based on a variance lattice defined as follows:-->
これらの結果はすべて、次のように定義された分散格子に基づいています。

```text
   *      Top (bivariant)
-     +
   o      Bottom (invariant)
```

<!--Based on this lattice, the solution `V(A)=+`, `V(B)=-`, `V(C)=o` is the optimal solution.-->
この格子に基づいて、解`V(A)=+`、 `V(B)=-`、 `V(C)=o`が最適解です。
<!--Note that there is always a naive solution which just declares all variables to be invariant.-->
すべての変数を不変であると宣言するという単純な解法は常に存在することに注意してください。

<!--You may be wondering why fixed-point iteration is required.-->
なぜ固定小数点の反復が必要なのか疑問に思うかもしれません。
<!--The reason is that the variance of a use site may itself be a function of the variance of other type parameters.-->
その理由は、使用サイトの分散自体が、他のタイプのパラメータの分散の関数である可能性があるためです。
<!--In full generality, our constraints take the form:-->
完全な一般性において、制約は以下の形をとる：

```text
V(X) <= Term
Term := + | - | * | o | V(X) | Term x Term
```

<!--Here the notation `V(X)` indicates the variance of a type/region parameter `X` with respect to its defining class.-->
ここで、表記`V(X)`は、型/領域パラメータ`X`定義クラスに対する分散を示す。
<!--`Term x Term` represents the "variance transform"as defined in the paper:-->
`Term x Term`は、論文で定義されている「分散変換」を表します。

> <!--If the variance of a type variable `X` in type expression `E` is `V2` and the definition-site variance of the [corresponding] type parameter of a class `C` is `V1`, then the variance of `X` in the type expression `C<E>` is `V3 = V1.xform(V2)`.-->
> タイプ表現`E`タイプ変数`X`の分散が`V2`あり、クラス`C` [corresponding]タイプパラメータの定義サイト分散が`V1`である場合、タイプ表現`C<E>`の`X`の分散は`V3 = V1.xform(V2)`。

## <!--Constraints--> 制約

<!--If I have a struct or enum with where clauses:-->
構造体またはenumのwhere句がある場合：

```rust,ignore
struct Foo<T: Bar> { ... }
```

<!--you might wonder whether the variance of `T` with respect to `Bar` affects the variance `T` with respect to `Foo`.-->
`Bar`に対する`T`の分散が`Foo`に対する分散`T`影響するかどうか疑問に思うかもしれません。
<!--I claim no.-->
私はノーと主張する。
<!--The reason: assume that `T` is invariant with respect to `Bar` but covariant with respect to `Foo`.-->
その理由は、`T`は`Bar`に対して不変であるが、`Foo`に関しては共変であると仮定する。
<!--And then we have a `Foo<X>` that is upcast to `Foo<Y>`, where `X <: Y`.-->
そして、`Foo<X>`が`Foo<Y>`アップキャストされています（`X <: Y`。
<!--However, while `X : Bar`, `Y : Bar` does not hold.-->
ただし、`X : Bar`、 `Y : Bar`は保持されません。
<!--In that case, the upcast will be illegal, but not because of a variance failure, but rather because the target type `Foo<Y>` is itself just not well-formed.-->
その場合、アップキャストは違法ですが、分散障害のためではなく、むしろ目標タイプ`Foo<Y>`自体がうまく構成されていないためです。
<!--Basically we get to assume well-formedness of all types involved before considering variance.-->
基本的には、分散を考慮する前に、すべてのタイプの整形式を仮定します。

### <!--Dependency graph management--> 依存関係グラフ管理

<!--Because variance is a whole-crate inference, its dependency graph can become quite muddled if we are not careful.-->
分散は全クレート推論であるため、従属グラフは注意を払わないとかなり混乱することがあります。
<!--To resolve this, we refactor into two queries:-->
これを解決するために、2つのクエリにリファクタリングします。

- <!--`crate_variances` computes the variance for all items in the current crate.-->
   `crate_variances`は、現在のクレート内のすべてのアイテムの分散を計算します。
- <!--`variances_of` accesses the variance for an individual reading;-->
   `variances_of`は個々の読み値の`variances_of`アクセスします。
<!--it works by requesting `crate_variances` and extracting the relevant data.-->
   `crate_variances`を要求し、関連するデータを抽出することによって動作します。

<!--If you limit yourself to reading `variances_of`, your code will only depend then on the inference of that particular item.-->
あなたが読書の`variances_of`に自分自身を制限するなら、あなたのコードはその特定のアイテムの推論に依存するだけです。

<!--Ultimately, this setup relies on the [red-green algorithm][rga].-->
最終的に、この設定は[赤緑アルゴリズムに][rga]依存し[ます][rga]。
<!--In particular, every variance query effectively depends on all type definitions in the entire crate (through `crate_variances`), but since most changes will not result in a change to the actual results from variance inference, the `variances_of` query will wind up being considered green after it is re-evaluated.-->
特に、すべての分散クエリは効果的に（`crate_variances`を`crate_variances`）クレート全体のすべての型定義に依存しますが、ほとんどの変更は分散推論の実際の結果に変化をもたらさないため、 `variances_of`後に緑色と見なされます再評価される。

[rga]: ./incremental-compilation.html

<span id="addendum"></span>
## <!--Addendum: Variance on traits--> 補遺：形質の差異

<!--As mentioned above, we used to permit variance on traits.-->
上記のように、私たちは形質の差異を許容するために使用しました。
<!--This was computed based on the appearance of trait type parameters in method signatures and was used to represent the compatibility of vtables in trait objects (and also "virtual"vtables or dictionary in trait bounds).-->
これは、メソッドシグネチャの特性タイプパラメータの出現に基づいて計算され、特性オブジェクト（および「仮想」vtableまたは特性境界内の辞書）におけるvtableの互換性を表すために使用されました。
<!--One complication was that variance for associated types is less obvious, since they can be projected out and put to myriad uses, so it's not clear when it is safe to allow `X<A>::Bar` to vary (or indeed just what that means).-->
1つの複雑な問題は、関連する型の分散があまり明白でないことです。なぜなら、それらを投射して無数の用途に使うことができるからです`X<A>::Bar`を変えることが安全かどうかは分かりません（あるいは、）。
<!--Moreover (as covered below) all inputs on any trait with an associated type had to be invariant, limiting the applicability.-->
さらに、関連する型を持つ任意の形質のすべての入力は不変でなければならず、適用性が制限されていました。
<!--Finally, the annotations (`MarkerTrait`, `PhantomFn`) needed to ensure that all trait type parameters had a variance were confusing and annoying for little benefit.-->
最後に、すべての特性タイプパラメータにばらつきがあることを保証するために必要な注釈（`MarkerTrait`、 `PhantomFn`）は、ほとんど利益を得ずに混乱し迷惑になりました。

<!--Just for historical reference, I am going to preserve some text indicating how one could interpret variance and trait matching.-->
歴史的な参考のために、私は分散と形質のマッチングをどのように解釈できるかを示すテキストを保存します。

### <!--Variance and object types--> 差異およびオブジェクトタイプ

<!--Just as with structs and enums, we can decide the subtyping relationship between two object types `&Trait<A>` and `&Trait<B>` based on the relationship of `A` and `B`.-->
構造体と列挙型と同様に、`A`と`B`関係に基づいて、2つのオブジェクト型`&Trait<A>`と`&Trait<B>`間のサブタイプの関係を決定できます。
<!--Note that for object types we ignore the `Self` type parameter – it is unknown, and the nature of dynamic dispatch ensures that we will always call a function that is expected the appropriate `Self` type.-->
オブジェクト型の場合、`Self`型パラメータは無視されます。これは不明です。動的ディスパッチの性質上、適切な`Self`型の関数が常に呼び出されることに注意してください。
<!--However, we must be careful with the other type parameters, or else we could end up calling a function that is expecting one type but provided another.-->
しかし、他の型のパラメータに注意する必要があります。そうでなければ、ある型を予期しているが別の型を提供している関数を呼び出すことになります。

<!--To see what I mean, consider a trait like so:-->
私が何を意味するかを見るには、次のような特性を考えてみましょう：

```rust
trait ConvertTo<A> {
    fn convertTo(&self) -> A;
}
```

<!--Intuitively, If we had one object `O=&ConvertTo<Object>` and another `S=&ConvertTo<String>`, then `S <: O` because `String <: Object` (presuming Java-like "string"and "object"types, my go to examples for subtyping).-->
直感的に、もし私たちが1つのオブジェクト`O=&ConvertTo<Object>` 1つの`S=&ConvertTo<String>`を持っていれば、`S <: O` `String <: Object`（Javaのような "string"と "object"サブタイピングのため）。
<!--The actual algorithm would be to compare the (explicit) type parameters pairwise respecting their variance: here, the type parameter A is covariant (it appears only in a return position), and hence we require that `String <: Object`.-->
実際のアルゴリズムは、その分散を考慮して（明示的な）型パラメータをペアで比較することです：ここでは、型パラメータAは共変（戻り位置にのみ現れる）なので、`String <: Object`必要です。

<!--You'll note though that we did not consider the binding for the (implicit) `Self` type parameter: in fact, it is unknown, so that's good.-->
しかし、（暗黙の）`Self`型パラメータのバインディングは考慮していませんが、実際は不明です。
<!--The reason we can ignore that parameter is precisely because we don't need to know its value until a call occurs, and at that time (as you said) the dynamic nature of virtual dispatch means the code we run will be correct for whatever value `Self` happens to be bound to for the particular object whose method we called.-->
そのパラメータを無視できる理由は、コールが発生するまでその値を知る必要がないため、その時点で（バーチャルディスパッチの動的な性質は、実行するコードがどんな値であれ正しい私たちが呼び出したメソッドを持つ特定のオブジェクトに対しては、`Self`が縛られてしまいます。
<!--`Self` is thus different from `A`, because the caller requires that `A` be known in order to know the return type of the method `convertTo()`.-->
`Self`から従って異なる`A`発信者がいることを必要とするので、メソッドの戻り型を知るために知られている`A` `convertTo()`
<!--(As an aside, we have rules preventing methods where `Self` appears outside of the receiver position from being called via an object.)-->
（例外として、受信者の位置の外に出現する`Self`がオブジェクトを介して呼び出されるのを防ぐルールがあります）。

### <!--Trait variance and vtable resolution--> 特性の分散とvtableの解像度

<!--But traits aren't only used with objects.-->
しかし、形質は対象物とともに使用されるだけではありません。
<!--They're also used when deciding whether a given impl satisfies a given trait bound.-->
与えられたimplが与えられた特性境界を満たすかどうかを決めるときにも使われます。
<!--To set the scene here, imagine I had a function:-->
ここでシーンを設定するには、私は関数があると想像してください：

```rust,ignore
fn convertAll<A,T:ConvertTo<A>>(v: &[T]) { ... }
```

<!--Now imagine that I have an implementation of `ConvertTo` for `Object`:-->
さて、`Object`の`ConvertTo`実装があるとしましょう。

```rust,ignore
impl ConvertTo<i32> for Object { ... }
```

<!--And I want to call `convertAll` on an array of strings.-->
そして、私は文字列の配列に対して`convertAll`を呼びたいと思います。
<!--Suppose further that for whatever reason I specifically supply the value of `String` for the type parameter `T`:-->
さらに何らかの理由で、型パラメータ`T`に`String`の値を指定するとします：

```rust,ignore
let mut vector = vec!["string", ...];
convertAll::<i32, String>(vector);
```

<!--Is this legal?-->
これは合法ですか？
<!--To put another way, can we apply the `impl` for `Object` to the type `String`?-->
別の言い方をすれば、`String`の型に`Object`の`impl`を適用できますか？
<!--The answer is yes, but to see why we have to expand out what will happen:-->
答えは「はい」ですが、何が起こるのかを広げなければならない理由を知るためです。

- <!--`convertAll` will create a pointer to one of the entries in the vector, which will have type `&String`-->
   `convertAll`はベクトル内のエントリの1つを指すポインタを作成します。このポインタはタイプ`&String`を持ちます
- <!--It will then call the impl of `convertTo()` that is intended for use with objects.-->
   次に、オブジェクトで使用する`convertTo()` implを呼び出します。
<!--This has the type `fn(self: &Object) -> i32`.-->
   これはタイプ`fn(self: &Object) -> i32`です。

<!--It is OK to provide a value for `self` of type `&String` because `&String <: &Object`.-->
のための価値を提供するためにOKである`self`タイプの`&String`理由`&String <: &Object`。

<!--OK, so intuitively we want this to be legal, so let's bring this back to variance and see whether we are computing the correct result.-->
そう、直感的に私たちはこれが合法であることを望んでいるので、これを分散して、正しい結果を計算しているかどうかを見てみましょう。
<!--We must first figure out how to phrase the question "is an impl for `Object,i32` usable where an impl for `String,i32` is expected?"-->
私たちはまず、"`String,i32`が期待されるところで`Object,i32`使える`Object,i32`ですか？"

<!--Maybe it's helpful to think of a dictionary-passing implementation of type classes.-->
おそらく、型クラスのディクショナリを渡す実装を考えてみると便利です。
<!--In that case, `convertAll()` takes an implicit parameter representing the impl.-->
その場合、`convertAll()`はimplを表す暗黙のパラメータをとります。
<!--In short, we *have* an impl of type:-->
つまり、次の*よう*なタイプのインプリメンテーションがあります。

```text
V_O = ConvertTo<i32> for Object
```

<!--and the function prototype expects an impl of type:-->
関数プロトタイプは型のimplを期待しています：

```text
V_S = ConvertTo<i32> for String
```

<!--As with any argument, this is legal if the type of the value given (`V_O`) is a subtype of the type expected (`V_S`).-->
任意の引数と同様に、指定された値の型（`V_O`）が期待される型（ `V_S`）のサブタイプである場合、これは正当です。
<!--So is `V_O <: V_S`?-->
`V_O <: V_S`ですか？
<!--The answer will depend on the variance of the various parameters.-->
答えは、さまざまなパラメータの分散に依存します。
<!--In this case, because the `Self` parameter is contravariant and `A` is covariant, it means that:-->
この場合、`Self`パラメータは反変で`A`は共変であるため、次のことを意味します。

```text
V_O <: V_S iff
    i32 <: i32
    String <: Object
```

<!--These conditions are satisfied and so we are happy.-->
これらの条件は満たされており、満足しています。

### <!--Variance and associated types--> 差異および関連タイプ

<!--Traits with associated types – or at minimum projection expressions – must be invariant with respect to all of their inputs.-->
関連する型（または最小限の射影式）を持つ特性は、すべての入力に対して不変でなければなりません。
<!--To see why this makes sense, consider what subtyping for a trait reference means:-->
なぜこれが理にかなっているかを知るためには、形質の参照のためにどのようなサブタイプが意味するのかを検討してください：

```text
<T as Trait> <: <U as Trait>
```

<!--means that if I know that `T as Trait`, I also know that `U as Trait`.-->
私が`T as Trait`知っているなら、私`U as Trait`も知っていることを意味します。
<!--Moreover, if you think of it as dictionary passing style, it means that a dictionary for `<T as Trait>` is safe to use where a dictionary for `<U as Trait>` is expected.-->
また、辞書を通り抜けるスタイルと考えると、`<T as Trait>`の辞書は、`<U as Trait>`辞書が期待される場所での使用が安全であることを意味します。

<!--The problem is that when you can project types out from `<T as Trait>`, the relationship to types projected out of `<U as Trait>` is completely unknown unless `T==U` (see #21726 for more details).-->
問題は、`<T as Trait>`から投影すると、`T==U`（詳細については＃21726を参照）がない限り、 `<U as Trait>`から投影された型への関係は完全に不明です。
<!--Making `Trait` invariant ensures that this is true.-->
`Trait`不変にすることは、これが正しいことを保証する。

<!--Another related reason is that if we didn't make traits with associated types invariant, then projection is no longer a function with a single result.-->
もう一つの関連する理由は、関連する型が不変な特性を作成しなければ、射影はもはや単一の結果を持つ関数ではないということです。
<!--Consider:-->
検討してください：

```rust,ignore
trait Identity { type Out; fn foo(&self); }
impl<T> Identity for T { type Out = T; ... }
```

<!--Now if I have `<&'static () as Identity>::Out`, this can be validly derived as `&'a ()` for any `'a`:-->
今、私が`<&'static () as Identity>::Out`を持っていれば、これは有効に`&'a ()` for `'a`

```text
<&'a () as Identity> <: <&'static () as Identity>
if &'static () < : &'a ()   -- Identity is contravariant in Self
if 'static : 'a             -- Subtyping rules for relations
```

<!--This change otoh means that `<'static () as Identity>::Out` is always `&'static ()` (which might then be upcast to `'a ()`, separately).-->
この変更は、`<'static () as Identity>::Out` `&'static ()`が常に`&'static ()`（別名`'a ()`にアップキャストされる可能性があること）を意味します。
<!--This was helpful in solving #21750.-->
これは＃21750の解決に役立ちました。
