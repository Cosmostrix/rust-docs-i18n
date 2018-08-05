# <!--MIR-based region checking (NLL)--> MIRベースの領域チェック（NLL）

<!--The MIR-based region checking code is located in [the `rustc_mir::borrow_check::nll` module][nll].-->
MIRベースの領域検査コードは[、`rustc_mir::borrow_check::nll`モジュールにあります][nll]。
<!--(NLL, of course, stands for "non-lexical lifetimes", a term that will hopefully be deprecated once they become the standard kind of lifetime.)-->
（もちろん、NLLは「非語彙生涯」を意味します。これは、生涯の標準的な種類になったら非難されるでしょう）。

[nll]: https://github.com/rust-lang/rust/tree/master/src/librustc_mir/borrow_check/nll

<!--The MIR-based region analysis consists of two major functions:-->
MIRベースの領域分析は、2つの主要な機能から成り立っています。

- <!--`replace_regions_in_mir`, invoked first, has two jobs:-->
   最初に呼び出された`replace_regions_in_mir`には2つのジョブがあります。
  - <!--First, it finds the set of regions that appear within the signature of the function (eg, `'a` in `fn foo<'a>(&'a u32) { ... }`).-->
     まず、関数のシグネチャ内に現れる領域のセットを見つけます（例えば、`'a` in `fn foo<'a>(&'a u32) { ... }`）。
<!--These are called the "universal"or "free"regions – in particular, they are the regions that [appear free][fvb] in the function body.-->
     これらは、「ユニバーサル」または「フリー」領域と呼ばれ、特に、機能体内で[自由][fvb]に[見える][fvb]領域です。
  - <!--Second, it replaces all the regions from the function body with fresh inference variables.-->
     次に、関数本体のすべての領域を新しい推論変数に置き換えます。
<!--This is because (presently) those regions are the results of lexical region inference and hence are not of much interest.-->
     これは、（現在）それらの領域がレキシカル領域推論の結果であり、したがってそれほど関心がないためです。
<!--The intention is that – eventually – they will be "erased regions"(ie, no information at all), since we won't be doing lexical region inference at all.-->
     その意図は、最終的に、「消去された領域」（すなわち、全く情報がない）であるということである。なぜなら、我々は語彙領域推論を全く行わないからである。
- <!--`compute_regions`, invoked second: this is given as argument the results of move analysis.-->
   `compute_regions`、2番目の呼び出し：これは、移動解析の結果を引数として与えられます。
<!--It has the job of computing values for all the inference variabes that `replace_regions_in_mir` introduced.-->
   それは、`replace_regions_in_mir`導入したすべての推論変数の値を計算する仕事を持っています。
  - <!--To do that, it first runs the [MIR type checker](#mirtypeck).-->
     これを行うために、まず[MIR型チェッカーを](#mirtypeck)実行します。
<!--This is basically a normal type-checker but specialized to MIR, which is much simpler than full Rust of course.-->
     これは基本的には通常のタイプチェッカーですが、MIRに特化しています。これは完全なRustよりはるかに簡単です。
<!--Running the MIR type checker will however create **outlives constraints** between region variables (eg, that one variable must outlive another one) to reflect the subtyping relationships that arise.-->
     しかし、MIR型チェッカーを実行すると、発生するサブタイプの関係を反映する**ために**、リージョン変数間の**アウトライヴ制約**が作成**さ**れます（たとえば、ある変数は別の変数よりも長く**存続**する必要があります）。
  - <!--It also adds **liveness constraints** that arise from where variables are used.-->
     また、変数が使用されている場所から生じる**生存の制約**を追加します。
  - <!--More details to come, though the [NLL RFC] also includes fairly thorough (and hopefully readable) coverage.-->
     [NLL RFC]には、かなり徹底した（そしてうまくいけば判読可能な）カバレッジも含まれていますが、さらに詳細があります。

<!--[fvb]: appendix/background.html#free-vs-bound
 [NLL RFC]: http://rust-lang.github.io/rfcs/2094-nll.html
-->
[fvb]: appendix/background.html#free-vs-bound
 [NLL RFC]: http://rust-lang.github.io/rfcs/2094-nll.html


## <!--Universal regions--> ユニバーサル地域

<!--*to be written* – explain the `UniversalRegions` type-->
*書かれる* -`UniversalRegions`タイプを説明する

## <!--Region variables and constraints--> 地域変数と制約

<!--*to be written* – describe the `RegionInferenceContext` and the role of `liveness_constraints` vs other `constraints`, plus-->
*書かれる* -`RegionInferenceContext`と`liveness_constraints`の役割と他の`constraints`とを記述する

## <!--Closures--> 閉鎖

<!--*to be written*-->
*書かれる*

<span id="mirtypeck"></span>
## <!--The MIR type-check--> MIR型チェック

## <!--Representing the "values"of a region variable--> 領域変数の「値」を表す

<!--The value of a region can be thought of as a **set**;-->
領域の値は**集合**と考えることができます。
<!--we call the domain of this set a `RegionElement`.-->
このセットのドメインを`RegionElement`ます。
<!--In the code, the value for all regions is maintained in [the `rustc_mir::borrow_check::nll::region_infer` module][ri].-->
コードでは、すべての領域の値[が`rustc_mir::borrow_check::nll::region_infer`モジュールで][ri]維持され[ます][ri]。
<!--For each region we maintain a set storing what elements are present in its value (to make this efficient, we give each kind of element an index, the `RegionElementIndex`, and use sparse bitsets).-->
各領域に対して、どの要素がその値に格納されているかを保持するセットを保持します（これを効率的にするために、各要素にインデックス、`RegionElementIndex`、疎ビットセットを使用します）。

[ri]: https://github.com/rust-lang/rust/tree/master/src/librustc_mir/borrow_check/nll/region_infer/

<!--The kinds of region elements are as follows:-->
領域要素の種類は次のとおりです。

- <!--Each **location** in the MIR control-flow graph: a location is just the pair of a basic block and an index.-->
   MIR制御フローグラフの各**位置**：位置は基本ブロックとインデックスのペアです。
<!--This identifies the point-->
   これは、
<!--**on entry** to the statement with that index (or the terminator, if the index is equal to `statements.len()`).-->
そのインデックスを持つステートメント（または、インデックスが`statements.len()`と等しい場合はターミネータ）**にエントリ**します。
<!---There is an element `end('a)` for each universal region `'a`, corresponding to some portion of the caller's (or caller's caller, etc) control-flow graph.-->
-呼び出し元（または呼び出し元の呼び出し元など）の制御フローグラフの一部に対応する要素の`end('a)`が各汎用領域`'a`にあります。
<!---Similarly, there is an element denoted `end('static)` corresponding to the remainder of program execution after this function returns.-->
-同様に、この関数が復帰した後の残りのプログラム実行に対応する`end('static)`と示される要素があります。
<!---There is an element `!1` for each skolemized region `!1`.-->
-各スカラー化領域`!1`は要素`!1`があります。
<!--This corresponds (intuitively) to some unknown set of other elements – for details on skolemization, see the section [skolemization and universes](#skol).-->
これは他の要素のいくつかの未知の集合に（直感的に）対応しています -スカイレングスの詳細については、[skolemizationとユニバースの](#skol)セクションを参照してください。

## <!--Causal tracking--> 原因トラッキング

<!--*to be written* – describe how we can extend the values of a variable with causal tracking etc-->
*書かれる* -因果追跡などで変数の値をどのように拡張できるかを記述する

<span id="skol"></span>
## <!--Skolemization and universes--> スカラー化と宇宙

<!--(This section describes ongoing work that hasn't landed yet.)-->
（このセクションでは、まだ着陸していない進行中の作業について説明します）。

<!--From time to time we have to reason about regions that we can't concretely know.-->
時には、われわれが具体的に知ることができない地域について、時には理由を論ずる必要がある。
<!--For example, consider this program:-->
たとえば、次のプログラムを考えてみましょう。

```rust,ignore
#// A function that needs a static reference
// 静的参照が必要な関数
fn foo(x: &'static u32) { }

fn bar(f: for<'a> fn(&'a u32)) {
#       // ^^^^^^^^^^^^^^^^^^^ a function that can accept **any** reference
       //  **任意の**参照を受け入れることができる^^^^^^^^^^^^^^^^^^^機能
    let x = 22;
    f(&x);
}

fn main() {
    bar(foo);
}
```

<!--This program ought not to type-check: `foo` needs a static reference for its argument, and `bar` wants to be given a function that that accepts **any** reference (so it can call it with something on its stack, for example).-->
：このプログラムは型チェックべきではない`foo`引数の静的参照を必要とし、`bar`それが（それは、例えば、そのスタック上に何かでそれを呼び出すことができます）**任意の**参照を受け入れることの機能を与えることを望んでいます。
<!--But *how* do we reject it and *why*?-->
しかし、*どのように*我々はそれを拒否*する*の*か*。

### <!--Subtyping and skolemization--> サブタイプ化およびスカイ化

<!--When we type-check `main`, and in particular the call `bar(foo)`, we are going to wind up with a subtyping relationship like this one:-->
型チェック`main`、特に`bar(foo)`場合、次のようなサブタイプの関係で終了します：

```text
fn(&'static u32) <: for<'a> fn(&'a u32)
----------------    -------------------
the type of `foo`   the type `bar` expects
```

<!--We handle this sort of subtyping by taking the variables that are bound in the supertype and **skolemizing** them: this means that we replace them with [universally quantified](appendix/background.html#quantified) representatives, written like `!1`.-->
この種のサブタイプは、スーパータイプにバインドされている変数を取り、それらを**スカラー**化することによって処理されます。つまり、これは、`!1`似ている[普遍的な定量化された](appendix/background.html#quantified)表現で置き換えられます。
<!--We call these regions "skolemized regions"– they represent, basically, "some unknown region".-->
これらの地域を「スカレミア地域」と呼びます。これらは、基本的に「未知の地域」を表しています。

<!--Once we've done that replacement, we have the following relation:-->
この交換を済ませたら、次の関係があります。

```text
fn(&'static u32) <: fn(&'!1 u32)
```

<!--The key idea here is that this unknown region `'!1` is not related to any other regions.-->
ここでの重要なアイデアは、この未知の領域`'!1`は他のどの地域にも関連していないということです。
<!--So if we can prove that the subtyping relationship is true for `'!1`, then it ought to be true for any region, which is what we wanted.-->
したがって、サブタイプの関係が`'!1`当てはまることを証明できれば、それはどの地域にとっても当てはまります。

<!--So let's work through what happens next.-->
それでは、次に起こることを考えてみましょう。
<!--To check if two functions are subtypes, we check if their arguments have the desired relationship (fn arguments are [contravariant](./appendix/background.html#variance), so we swap the left and right here):-->
2つの関数がサブタイプであるかどうかを調べるために、引数が望ましい関係にあるかどうかをチェックします（fn引数は[contravariant](./appendix/background.html#variance)ので、ここでは左と右を入れ替えます）。

```text
&'!1 u32 <: &'static u32
```

<!--According to the basic subtyping rules for a reference, this will be true if `'!1: 'static`.-->
リファレンスの基本的なサブタイプの規則によれば、`'!1: 'static`場合はtrueになります。
<!--That is – if "some unknown region `!1` "lives outlives `'static`.-->
つまり、「何らかの未知の地域`!1` 」が生存`'static`住んで`'static`です。
<!--Now, this *might* be true – after all, `'!1` could be `'static` – but we don't *know* that it's true.-->
結局のところ、これ*は*真実*かもしれません。*結局のところ、`'!1`は`'static`可能性があります*が*、それが本当である*か*どうかは*わかり*ません。
<!--So this should yield up an error (eventually).-->
だから、これはエラー（最終的に）をもたらすはずです。

### <!--What is a universe--> 宇宙とは何ですか？

<!--In the previous section, we introduced the idea of a skolemized region, and we denoted it `!1`.-->
前のセクションでは、skolemized地域のアイデアを紹介し、それを`!1`。
<!--We call this number `1` the **universe index**.-->
私たちは、この番号を呼び出す`1` **宇宙インデックスを**。
<!--The idea of a "universe"is that it is a set of names that are in scope within some type or at some point.-->
「宇宙」のアイデアは、それが、あるタイプまたはあるポイントの範囲内にある名前のセットであるということです。
<!--Universes are formed into a tree, where each child extends its parents with some new names.-->
ユニバースは樹木に形成され、それぞれの子供は両親にいくつかの新しい名前を付ける。
<!--So the **root universe** conceptually contains global names, such as the the lifetime `'static` or the type `i32`.-->
したがって、**ルート・ユニバースに**は、ライフタイム`'static`タイプやタイプ`i32`などのグローバル名が概念的に含まれています。
<!--In the compiler, we also put generic type parameters into this root universe (in this sense, there is not just one root universe, but one per item).-->
コンパイラでは、ジェネリック型のパラメータをこのルートユニバースに入れます（この意味で、ルートユニバースは1つではなく、1つのアイテムに1つあります）。
<!--So consider this function `bar`:-->
この関数の`bar`考えてみ`bar`：

```rust,ignore
struct Foo { }

fn bar<'a, T>(t: &'a T) {
    ...
}
```

<!--Here, the root universe would consist of the lifetimes `'static` and `'a`.-->
ここでは、ルートの宇宙は生命体の`'static` `'a`と`'a`生命体`'static`からなる。
<!--In fact, although we're focused on lifetimes here, we can apply the same concept to types, in which case the types `Foo` and `T` would be in the root universe (along with other global types, like `i32`).-->
実際、ここでは生涯に焦点を当てていますが、同じ概念を型に適用することができます。この場合、型`Foo`と`T`はルート宇宙にあります（他のグローバル型、`i32`）。
<!--Basically, the root universe contains all the names that [appear free](./appendix/background.html#free-vs-bound) in the body of `bar`.-->
基本的に、ルートユニバースには、`bar`の本体に[自由](./appendix/background.html#free-vs-bound)に[表示される](./appendix/background.html#free-vs-bound)すべての名前が含まれてい`bar`。

<!--Now let's extend `bar` a bit by adding a variable `x`:-->
変数`x`追加して`bar`を少し拡張しましょう：

```rust,ignore
fn bar<'a, T>(t: &'a T) {
    let x: for<'b> fn(&'b u32) = ...;
}
```

<!--Here, the name `'b` is not part of the root universe.-->
ここでは、名前`'b`はルートの宇宙の一部ではありません。
<!--Instead, when we "enter"into this `for<'b>` (eg, by skolemizing it), we will create a child universe of the root, let's call it U1:-->
代わりに、`for<'b>`にこれに「入る」（例えば、それをスカラー化することによって）、ルートの子ユニバースを作成します。それをU1と呼んでいます：

```text
U0 (root universe)
│
└─ U1 (child universe)
```

<!--The idea is that this child universe U1 extends the root universe U0 with a new name, which we are identifying by its universe number: `!1`.-->
：アイデアは、この子ユニバースU1は、我々はその宇宙の番号で識別されている新しい名前、とルートユニバースU0を拡張することである`!1`

<!--Now let's extend `bar` a bit by adding one more variable, `y`:-->
今度は拡張できます`bar`少し、1つのより多くの変数を追加することにより、`y`：

```rust,ignore
fn bar<'a, T>(t: &'a T) {
    let x: for<'b> fn(&'b u32) = ...;
    let y: for<'c> fn(&'b u32) = ...;
}
```

<!--When we enter *this* type, we will again create a new universe, which we'll call `U2`.-->
*この*タイプに入ると、`U2`と呼ばれる新しい宇宙をもう一度作ります。
<!--Its parent will be the root universe, and U1 will be its sibling:-->
その親はルートの宇宙になり、U1はその兄弟になります：

```text
U0 (root universe)
│
├─ U1 (child universe)
│
└─ U2 (child universe)
```

<!--This implies that, while in U2, we can name things from U0 or U2, but not U1.-->
これは、U2では、U0ではなくU0またはU2から名前を付けることができます。

<!--**Giving existential variables a universe.**-->
**実在の変数を宇宙に与える。**
<!--Now that we have this notion of universes, we can use it to extend our type-checker and things to prevent illegal names from leaking out.-->
私たちはこのような宇宙の概念を持っているので、これを使って型検査員や物事を拡張して、違法名が漏出するのを防ぐことができます。
<!--The idea is that we give each inference (existential) variable – whether it be a type or a lifetime – a universe.-->
アイデアは、それが型であろうと一生であろうと、宇宙である各推論（存在）変数を与えることです。
<!--That variable's value can then only reference names visible from that universe.-->
その変数の値は、その宇宙から見える名前だけを参照することができます。
<!--So for example is a lifetime variable is created in U0, then it cannot be assigned a value of `!1` or `!2`, because those names are not visible from the universe U0.-->
たとえば、U0に生涯変数が作成された場合、これらの名前はユニバースU0から表示されないため、`!1`または`!2`値を割り当てることはできません。

<!--**Representing universes with just a counter.**-->
**カウンターだけで宇宙を表現する。**
<!--You might be surprised to see that the compiler doesn't keep track of a full tree of universes.-->
コンパイラがユニバースの完全なツリーを追跡していないことに驚くかもしれません。
<!--Instead, it just keeps a counter – and, to determine if one universe can see another one, it just checks if the index is greater.-->
代わりに、カウンタを保持し、ある宇宙が別の宇宙を見ることができるかどうかを判断するために、インデックスが大きいかどうかを確認するだけです。
<!--For example, U2 can see U0 because 2 >= 0. But U0 cannot see U2, because 0 >= 2 is false.-->
例えば、2> = 0なのでU2はU0を見ることができます。しかし、0> = 2は偽であるため、U0はU2を見ることができません。

<!--How can we get away with this?-->
どうすればこの問題を解決できますか？
<!--Doesn't this mean that we would allow U2 to also see U1?-->
これは、U2にもU1を見ることを許可するという意味ではありませんか？
<!--The answer is that, yes, we would, **if that question ever arose**.-->
答えは、**その質問が起きたならば**、はい、私たちはそうするでしょう。
<!--But because of the structure of our type checker etc, there is no way for that to happen.-->
しかし、私たちのタイプチェッカーなどの構造のために、それが起こる方法はありません。
<!--In order for something happening in the universe U1 to "communicate"with something happening in U2, they would have to have a shared inference variable X in common.-->
宇宙U1で起こっていることがU2で起こっていることと「コミュニケート」するためには、共通の推論変数Xを共有する必要があります。
<!--And because everything in U1 is scoped to just U1 and its children, that inference variable X would have to be in U0.-->
そして、U1のすべてがU1とその子にスコープされているので、その推論変数XはU0になければなりません。
<!--And since X is in U0, it cannot name anything from U1 (or U2).-->
XはU0にあるので、U1（またはU2）の名前を付けることはできません。
<!--This is perhaps easiest to see by using a kind of generic "logic"example:-->
これは、一種の一般的な「論理」の例を使用することによって、おそらく最も簡単に見えます。

```text
exists<X> {
   forall<Y> { ... /* Y is in U1 ... */ }
   forall<Z> { ... /* Z is in U2 ... */ }
}
```

<!--Here, the only way for the two foralls to interact would be through X, but neither Y nor Z are in scope when X is declared, so its value cannot reference either of them.-->
ここでは、2つのフォールトが相互作用する唯一の方法はXを介して行われるが、Xが宣言されているときにはYもZもスコープにないので、その値はどちらも参照できない。

### <!--Universes and skolemized region elements--> ユニバースとskolemizedリージョンエレメント

<!--But where does that error come from?-->
しかし、そのエラーはどこから来ますか？
<!--The way it happens is like this.-->
それが起こる方法はこれのようなものです。
<!--When we are constructing the region inference context, we can tell from the type inference context how many skolemized variables exist (the `InferCtxt` has an internal counter).-->
領域推論コンテキストを構築するときに、型推論コンテキストから、いくつかの変数が存在することがわかります（`InferCtxt`には内部カウンタがあります）。
<!--For each of those, we create a corresponding universal region variable `!n` and a "region element"`skol(n)`.-->
それぞれについて、対応するユニバーサル領域変数`!n`と "region要素"`skol(n)`ます。
<!--This corresponds to "some unknown set of other elements".-->
これは、「他の要素の未知の集合」に対応します。
<!--The value of `!n` is `{skol(n)}`.-->
`!n`の値は`{skol(n)}`です。

<!--At the same time, we also give each existential variable a **universe** (also taken from the `InferCtxt`).-->
同時に、我々はまた、各存在変数を**宇宙**（ `InferCtxt`からも取った`InferCtxt`）に`InferCtxt`ます。
<!--This universe determines which skolemized elements may appear in its value: For example, a variable in universe U3 may name `skol(1)`, `skol(2)`, and `skol(3)`, but not `skol(4)`.-->
たとえば、ユニバースU3の変数は、`skol(1)`、 `skol(2)`、および`skol(3)`になり`skol(3)`が、`skol(4)`はありません。
<!--Note that the universe of an inference variable controls what region elements **can** appear in its value;-->
推論変数のユニバースは、その値にどの地域要素**が**現れるかを制御することに注意してください。
<!--it does not say region elements **will** appear.-->
地域の要素**が**表示さ**れる**ことはありません。

### <!--Skolemization and outlives constraints--> Skolemizationと寿命の制約

<!--In the region inference engine, outlives constraints have the form:-->
領域推論エンジンでは、寿命の制約は次の形式をとります。

```text
V1: V2 @ P
```

<!--where `V1` and `V2` are region indices, and hence map to some region variable (which may be universally or existentially quantified).-->
ここで、`V1`および`V2`は領域指数であり、したがって、いくつかの領域変数（普遍的または存在的に定量化され得る）にマッピングされる。
<!--The `P` here is a "point"in the control-flow graph;-->
ここでの`P`は、制御フローグラフの「ポイント」です。
<!--it's not important for this section.-->
このセクションでは重要ではありません。
<!--This variable will have a universe, so let's call those universes `U(V1)` and `U(V2)` respectively.-->
この変数には宇宙があるので、それらの宇宙`U(V1)`と`U(V2)`それぞれ呼ぶことにしましょう。
<!--(Actually, the only one we are going to care about is `U(V1)`.)-->
（実際、私たちが気にするのは`U(V1)`です。）

<!--When we encounter this constraint, the ordinary procedure is to start a DFS from `P`.-->
この制約に遭遇すると、通常の手順は`P`からDFSを開始することです。
<!--We keep walking so long as the nodes we are walking are present in `value(V2)` and we add those nodes to `value(V1)`.-->
歩いているノードが`value(V2)`存在し、それらのノードを`value(V1)`追加する限り、歩行を続けます。
<!--If we reach a return point, we add in any `end(X)` elements.-->
リターンポイントに達すると、任意の`end(X)`要素が追加されます。
<!--That part remains unchanged.-->
その部分は変わりません。

<!--But then *after that* we want to iterate over the skolemized `skol(x)` elements in V2 (each of those must be visible to `U(V2)`, but we should be able to just assume that is true, we don't have to check it).-->
しかし、*その後*、私たちはskolemizedを反復処理したい`skol(x)` V2の要素（これらのそれぞれは、に見えなければならない`U(V2)`しかし、我々は確認する必要はありません。私達はちょうどそれが本当であると仮定することができるはずですそれ）。
<!--We have to ensure that `value(V1)` outlives each of those skolemized elements.-->
`value(V1)`がそれらの価値のある要素のそれぞれよりも長く存続することを保証する必要があります。

<!--Now there are two ways that could happen.-->
今、起こる可能性のある2つの方法があります。
<!--First, if `U(V1)` can see the universe `x` (ie, `x <= U(V1)`), then we can just add `skol(x)` to `value(V1)` and be done.-->
まず、`U(V1)`が宇宙`x`（ `x <= U(V1)`）を見ることができれば、 `skol(x)`を`value(V1)`加えて`skol(x)`することができます。
<!--But if not, then we have to approximate: we may not know what set of elements `skol(x)` represents, but we should be able to compute some sort of **upper bound** B for it – some region B that outlives `skol(x)`.-->
我々は要素の集合のか分からないかもしれません。しかし、そうでなければ、我々は近似する必要があり`skol(x)`表すが、我々はそれの**上限** Bのいくつかの並べ替えを計算することができるはず-outlivesいくつかの領域B `skol(x)`
<!--For now, we'll just use `'static` for that (since it outlives everything) – in the future, we can sometimes be smarter here (and in fact we have code for doing this already in other contexts).-->
現時点では、私たちは単に`'static`を使用しています（すべてが残って`'static`ため）-将来、時にはスマートになることがあります（実際には他のコンテキストでこれを行うためのコードがあります）。
<!--Moreover, since `'static` is in the root universe U0, we know that all variables can see it – so basically if we find that `value(V2)` contains `skol(x)` for some universe `x` that `V1` can't see, then we force `V1` to `'static`.-->
さらに、`'static`は根の宇宙U0にあるので、すべての変数がそれを見ることができることを知っている -基本的に、`V1`が見ることができない宇宙`x` `value(V2)`に`skol(x)` `V1`から`'static`。

### <!--Extending the "universal regions"check--> 「ユニバーサル地域」のチェックを拡大する

<!--After all constraints have been propagated, the NLL region inference has one final check, where it goes over the values that wound up being computed for each universal region and checks that they did not get 'too large'.-->
すべての制約が伝播された後、NLL領域の推論には最終的なチェックが1つあります。ここでは、それぞれのユニバーサル領域で計算された値を超え、「大きすぎる」ことはありません。
<!--In our case, we will go through each skolemized region and check that it contains *only* the `skol(u)` element it is known to outlive.-->
私たちの場合、各スカイメーションされた領域を通過し、それが*残っ*ていることが分かっている`skol(u)`要素*だけ*が含まれていることを確認します。
<!--(Later, we might be able to know that there are relationships between two skolemized regions and take those into account, as we do for universal regions from the fn signature.)-->
（後で、fnシグネチャからの普遍的なリージョンの場合と同様に、2つのスカラー化されたリージョン間に関係があり、それらを考慮に入れていることがわかるかもしれません。）

<!--Put another way, the "universal regions"check can be considered to be checking constraints like:-->
別の言い方をすれば、「ユニバーサル領域」チェックは以下のような制約をチェックすると考えることができます：

```text
{skol(1)}: V1
```

<!--where `{skol(1)}` is like a constant set, and V1 is the variable we made to represent the `!1` region.-->
ここで、`{skol(1)}`は定数集合に似ており、V1は`!1`領域を表すために作成した変数です。

## <!--Back to our example--> 私たちの例に戻る

<!--OK, so far so good.-->
OK、これまでのところ良い。
<!--Now let's walk through what would happen with our first example:-->
さあ、最初の例で起こることを歩みましょう：

```text
#//fn(&'static u32) <: fn(&'!1 u32) @ P  // this point P is not imp't here
fn(&'static u32) <: fn(&'!1 u32) @ P  // この点Pはここでは意味を持たない
```

<!--The region inference engine will create a region element domain like this:-->
リージョン推論エンジンは、以下のようなリージョン要素ドメインを作成します。

```text
{ CFG; end('static); skol(1) }
    ---  ------------  ------- from the universe `!1`
    |    'static is always in scope
    all points in the CFG; not especially relevant here
```

<!--It will always create two universal variables, one representing `'static` and one representing `'!1`.-->
常に2つの普遍的な変数を作成します.1つは`'static`変数`'static`表し、もう1つは`'static` 1 `'!1`表します。
<!--Let's call them Vs and V1.-->
それらをVsとV1としましょう。
<!--They will have initial values like so:-->
それらは次のような初期値を持ちます：

```text
#//Vs = { CFG; end('static) } // it is in U0, so can't name anything else
Vs = { CFG; end('static) } // それはU0にあるので、他の名前を付けることはできません
V1 = { skol(1) }
```

<!--From the subtyping constraint above, we would have an outlives constraint like-->
上記のサブタイプの制約から、次のような寿命の制約があります。

```text
'!1: 'static @ P
```

<!--To process this, we would grow the value of V1 to include all of Vs:-->
これを処理するには、Vsのすべてを含むようにV1の値を大きくします。

```text
Vs = { CFG; end('static) }
V1 = { CFG; end('static), skol(1) }
```

<!--At that point, constraint propagation is complete, because all the outlives relationships are satisfied.-->
その時点で、すべての残存関係が満たされているため、制約の伝播は完了しています。
<!--Then we would go to the "check universal regions"portion of the code, which would test that no universal region grew too large.-->
次に、コードの "普遍的な領域をチェックする"部分に行き、普遍的な領域が大きくなりすぎないことをテストします。

<!--In this case, `V1` *did* grow too large – it is not known to outlive `end('static)`, nor any of the CFG – so we would report an error.-->
この場合、`V1` *は*大きくなりすぎました。つまり、`end('static)`ものもCFGのものも残っていないことが分かっています。そのため、エラーが報告されます。

## <!--Another example--> もう一つの例

<!--What about this subtyping relationship?-->
このサブタイプの関係はどうですか？

```text
for<'a> fn(&'a u32, &'a u32)
    <:
for<'b, 'c> fn(&'b u32, &'c u32)
```

<!--Here we would skolemize the supertype, as before, yielding:-->
ここで、以前と同じように、スーパータイプをskolemizeします。

```text
for<'a> fn(&'a u32, &'a u32)
    <:
fn(&'!1 u32, &'!2 u32)
```

<!--then we instantiate the variable on the left-hand side with an existential in universe U2, yielding the following (`?n` is a notation for an existential variable):-->
変数U2の左辺の変数をインスタンスU2にインスタンス化すると、以下のようになります（`?n`は実在変数の表記です）。

```text
fn(&'?3 u32, &'?3 u32)
    <:
fn(&'!1 u32, &'!2 u32)
```

<!--Then we break this down further:-->
次に、これをさらに分解します。

```text
&'!1 u32 <: &'?3 u32
&'!2 u32 <: &'?3 u32
```

<!--and even further, yield up our region constraints:-->
さらに、地域の制約を生み出します：

```text
'!1: '?3
'!2: '?3
```

<!--Note that, in this case, both `'!1` and `'!2` have to outlive the variable `'?3`, but the variable `'?3` is not forced to outlive anything else.-->
なお、この場合には、両方の`'!1`および`'!2`、変数をより長生きする必要が`'?3`が、変数`'?3`、何よりも長生きすることを余儀なくされていません。
<!--Therefore, it simply starts and ends as the empty set of elements, and hence the type-check succeeds here.-->
したがって、要素の空集合として単純に開始および終了するため、ここで型チェックが成功します。

<!--(This should surprise you a little. It surprised me when I first realized it. We are saying that if we are a fn that **needs both of its arguments to have the same region**, we can accept being called with **arguments with two distinct regions**. That seems intuitively unsound. But in fact, it's fine, as I tried to explain in [this issue][ohdeargoditsallbroken] on the Rust issue tracker long ago. The reason is that even if we get called with arguments of two distinct lifetimes, those two lifetimes have some intersection (the call itself), and that intersection can be our value of `'a` that we use as the common lifetime of our arguments. -nmatsakis)-->
私たちが**、同じ領域を持つために引数の両方**を**必要と**するfnなら**、2つの異なる領域を**持つ**引数で**呼び出されることを受け入れることができると言ってい**ます**。それは直感的には不健全なようですが、実際には、 [この問題][ohdeargoditsallbroken]については、ずっと前にRust号トラッカーで説明しようとしていたので、うまくいきます。その理由は、2つの異なる生涯の議論で呼び出されても、（呼び出し自体）、その交差点は、私たちの議論の共通の生涯として使用する`'a`私たちの価値`'a`なる可能性があります。

[ohdeargoditsallbroken]: https://github.com/rust-lang/rust/issues/32330#issuecomment-202536977

## <!--Final example--> 最後の例

<!--Let's look at one last example.-->
最後の例を見てみましょう。
<!--We'll extend the previous one to have a return type:-->
前の関数を戻り値の型に拡張します：

```text
for<'a> fn(&'a u32, &'a u32) -> &'a u32
    <:
for<'b, 'c> fn(&'b u32, &'c u32) -> &'b u32
```

<!--Despite seeming very similar to the previous example, this case is going to get an error.-->
前の例と非常によく似ているにもかかわらず、この場合はエラーが発生します。
<!--That's good: the problem is that we've gone from a fn that promises to return one of its two arguments, to a fn that is promising to return the first one.-->
それは問題です：問題は、最初のものを返すことを約束しているfnに、2つの引数の1つを返すことを約束しているfnから行ったことです。
<!--That is unsound.-->
それは不健全です。
<!--Let's see how it plays out.-->
それがどのように再生するか見てみましょう。

<!--First, we skolemize the supertype:-->
まず、スーパータイプをスカラー化します。

```text
for<'a> fn(&'a u32, &'a u32) -> &'a u32
    <:
fn(&'!1 u32, &'!2 u32) -> &'!1 u32
```

<!--Then we instantiate the subtype with existentials (in U2):-->
次に、（U2の）existentialsでサブタイプをインスタンス化します。

```text
fn(&'?3 u32, &'?3 u32) -> &'?3 u32
    <:
fn(&'!1 u32, &'!2 u32) -> &'!1 u32
```

<!--And now we create the subtyping relationships:-->
次に、サブタイプの関係を作成します。

```text
#//&'!1 u32 <: &'?3 u32 // arg 1
&'!1 u32 <: &'?3 u32 //  arg 1
#//&'!2 u32 <: &'?3 u32 // arg 2
&'!2 u32 <: &'?3 u32 //  arg 2
#//&'?3 u32 <: &'!1 u32 // return type
&'?3 u32 <: &'!1 u32 // 戻り値の型
```

<!--And finally the outlives relationships.-->
そして最終的には永遠の関係。
<!--Here, let V1, V2, and V3 be the variables we assign to `!1`, `!2`, and `?3` respectively:-->
ここで、V1、V2、V3をそれぞれ`!1`、 `!2`、および`?3`に割り当てる変数とし`?3`。

```text
V1: V3
V2: V3
V3: V1
```

<!--Those variables will have these initial values:-->
これらの変数は、次の初期値を持ちます。

```text
V1 in U1 = {skol(1)}
V2 in U2 = {skol(2)}
V3 in U2 = {}
```

<!--Now because of the `V3: V1` constraint, we have to add `skol(1)` into `V3` (and indeed it is visible from `V3`), so we get:-->
さてための`V3: V1`制約、我々は、追加する必要があります`skol(1)`に`V3`（そして実際にそれがから見える`V3`）ので、我々が得ます：

```text
V3 in U2 = {skol(1)}
```

<!--then we have this constraint `V2: V3`, so we wind up having to enlarge `V2` to include `skol(1)` (which it can also see):-->
この制約`V2: V3`があるので、`V2`を拡大して`skol(1)`を含める`skol(1)`があります（これも見ることができます）。

```text
V2 in U2 = {skol(1), skol(2)}
```

<!--Now contraint propagation is done, but when we check the outlives relationships, we find that `V2` includes this new element `skol(1)`, so we report an error.-->
今度は`skol(1)`伝播が行われますが、残存関係を調べると、`V2`はこの新しい要素`skol(1)`含まれていることが`skol(1)`ます。そのため、エラーを報告します。

