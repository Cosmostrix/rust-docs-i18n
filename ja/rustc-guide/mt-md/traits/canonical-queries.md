# <!--Canonical queries--> 標準クエリ

<!--The "start"of the trait system is the **canonical query** (these are both queries in the more general sense of the word – something you would like to know the answer to – and in the [rustc-specific sense](./query.html)).-->
形質システムの「スタート」は**標準的なクエリーです**（これは、より一般的な意味でのクエリーです -あなたが答えを知りたいと思っているものと[錆びた特異的な意味で](./query.html)）。
<!--The idea is that the type checker or other parts of the system, may in the course of doing their thing want to know whether some trait is implemented for some type (eg, is `u32: Debug` true?).-->
考え方は、型チェッカーやシステムの他の部分は、ある種の特性（例えば、`u32: Debug` true？）が実装されているかどうかを知りたいということです。
<!--Or they may want to [normalize some associated type](./traits/associated-types.html).-->
あるいは、[関連するタイプ](./traits/associated-types.html)を[正規化し](./traits/associated-types.html)たいかもしれません。

<!--This section covers queries at a fairly high level of abstraction.-->
このセクションでは、抽象度のかなり高いレベルでのクエリについて説明します。
<!--The subsections look a bit more closely at how these ideas are implemented in rustc.-->
サブセクションは、これらのアイデアがどのようにしっかりとして実装されているかを少し詳しく見ています。

## <!--The traditional, interactive Prolog query--> 従来のインタラクティブなPrologクエリ

<!--In a traditional Prolog system, when you start a query, the solver will run off and start supplying you with every possible answer it can find.-->
伝統的なPrologシステムでは、クエリを開始するとソルバが実行され、検索可能なすべての回答がユーザに提供されます。
<!--So given something like this:-->
だからこのような何かを与えられた：

```text
?- Vec<i32>: AsRef<?U>
```

<!--The solver might answer:-->
ソルバーは答えます：

```text
Vec<i32>: AsRef<[i32]>
    continue? (y/n)
```

<!--This `continue` bit is interesting.-->
この`continue`ビットは面白いです。
<!--The idea in Prolog is that the solver is finding **all possible** instantiations of your query that are true.-->
Prologのアイデアは、ソルバーが実際のクエリのインスタンス化を**すべて**見つけることです。
<!--In this case, if we instantiate `?U = [i32]`, then the query is true (note that a traditional Prolog interface does not, directly, tell us a value for `?U`, but we can infer one by unifying the response with our original query – Rust's solver gives back a substitution instead).-->
この場合、`?U = [i32]`をインスタンス化すると、クエリは真です（伝統的なPrologインタフェースは、`?U`値を直接指示しませんが、私たちは元のクエリ -Rustのソルバーは代わりに代入を返します）。
<!--If we were to hit `y`, the solver might then give us another possible answer:-->
`y`を打つと、ソルバーは別の可能な答えを与えるかもしれません：

```text
Vec<i32>: AsRef<Vec<i32>>
    continue? (y/n)
```

<!--This answer derives from the fact that there is a reflexive impl (`impl<T> AsRef<T> for T`) for `AsRef`.-->
この回答は（再帰のimplがあるという事実に由来`impl<T> AsRef<T> for T`のために）`AsRef`。
<!--If were to hit `y` again, then we might get back a negative response:-->
もう一度`y`を押すと、否定応答を返す可能性があります。

```text
no
```

<!--Naturally, in some cases, there may be no possible answers, and hence the solver will just give me back `no` right away:-->
当然のことながら、いくつかのケースでは、何の可能な答えがないことが、ひいてはソルバーはちょうど私が戻って与える`no`すぐに：

```text
?- Box<i32>: Copy
    no
```

<!--In some cases, there might be an infinite number of responses.-->
場合によっては、無限の応答が存在する可能性があります。
<!--So for example if I gave this query, and I kept hitting `y`, then the solver would never stop giving me back answers:-->
たとえば、このクエリを与えても、`y`を続けていたら、ソルバーは決して私に答えを返すことを止めることはできません：

```text
?- Vec<?U>: Clone
    Vec<i32>: Clone
        continue? (y/n)
    Vec<Box<i32>>: Clone
        continue? (y/n)
    Vec<Box<Box<i32>>>: Clone
        continue? (y/n)
    Vec<Box<Box<Box<i32>>>>: Clone
        continue? (y/n)
```

<!--As you can imagine, the solver will gleefully keep adding another layer of `Box` until we ask it to stop, or it runs out of memory.-->
あなたが想像しているように、ソルバーは、停止するように頼むまで、あるいは記憶がなくなるまで、別の層の`Box`追加し続けます。

<!--Another interesting thing is that queries might still have variables in them.-->
もう1つの興味深い点は、クエリにはまだ変数が含まれている可能性があるということです。
<!--For example:-->
例えば：

```text
?- Rc<?T>: Clone
```

<!--might produce the answer:-->
答えを出すかもしれない：

```text
Rc<?T>: Clone
    continue? (y/n)
```

<!--After all, `Rc<?T>` is true **no matter what type `?T` is**.-->
結局、`Rc<?T>`は**どんな型の `？T 'であって**も真**です**。

<span id="query-response"></span>
## <!--A trait query in rustc--> rustcの形質のクエリ

<!--The trait queries in rustc work somewhat differently.-->
rustcのtrait queryはやや異なった働きをします。
<!--Instead of trying to enumerate **all possible** answers for you, they are looking for an **unambiguous** answer.-->
**可能なすべての**回答を列挙しようとするのではなく、**曖昧さのない**回答を探しています。
<!--In particular, when they tell you the value for a type variable, that means that this is the **only possible instantiation** that you could use, given the current set of impls and where-clauses, that would be provable.-->
特に、型変数の値を伝えると、これは、現在のimplsとwhere-clauseのセットがあれば、それが証明**できる唯一の可能なインスタンス化で**あることを意味します。
<!--(Internally within the solver, though, they can potentially enumerate all possible answers. See [the description of the SLG solver](./traits/slg.html) for details.)-->
（ソルバーの内部では、すべての可能な解を列挙できる可能性があります。詳細[については、SLGソルバーの説明を](./traits/slg.html)参照[し](./traits/slg.html)てください）。

<!--The response to a trait query in rustc is typically a `Result<QueryResult<T>, NoSolution>` (where the `T` will vary a bit depending on the query itself).-->
rustcでのtraitクエリへの応答は、通常、`Result<QueryResult<T>, NoSolution>`（ `T`はクエリ自体に依存して変化します）です。
<!--The `Err(NoSolution)` case indicates that the query was false and had no answers (eg, `Box<i32>: Copy`).-->
`Err(NoSolution)`場合は、クエリが偽であり、回答がないことを示します（`Box<i32>: Copy`）。
<!--Otherwise, the `QueryResult` gives back information about the possible answer(s) we did find.-->
それ以外の場合、`QueryResult`は、`QueryResult`た可能な回答に関する情報を返します。
<!--It consists of four parts:-->
それは4つの部分で構成されています。

- <!--**Certainty:** tells you how sure we are of this answer.-->
   **確かなこと：**私たちがこの答えをどのようにしているかを伝えます。
<!--It can have two values:-->
   それは2つの値を持つことができます：
  - <!--`Proven` means that the result is known to be true.-->
     `Proven`とは、結果が真実であることを意味します。
    - <!--This might be the result for trying to prove `Vec<i32>: Clone`, say, or `Rc<?T>: Clone`.-->
       これは`Vec<i32>: Clone`、 `Rc<?T>: Clone`を証明しようとした結果です。
  - <!--`Ambiguous` means that there were things we could not yet prove to be either true *or* false, typically because more type information was needed.-->
     `Ambiguous`ということは、より多くの型情報が必要だったために、我々がまだ真実*か*偽であるかを証明できなかったことがあることを意味します。
<!--(We'll see an example shortly.)-->
     （まもなく例が表示されます）
    - <!--This might be the result for trying to prove `Vec<?T>: Clone`.-->
       これは、`Vec<?T>: Clone`を証明しようとした場合の結果かもしれません。
- <!--**Var values:** Values for each of the unbound inference variables (like `?T`) that appeared in your original query.-->
   変数**値：**元のクエリに現れたアンバウンドの推論変数（`?T`）のそれぞれの値。
<!--(Remember that in Prolog, we had to infer these.)-->
   （Prologではこれらを推測しなければならなかったことを忘れないでください）。
  - <!--As we'll see in the example below, we can get back var values even for `Ambiguous` cases.-->
     下の例で見るように、`Ambiguous`場合でもvar値を戻すことができます。
- <!--**Region constraints:** these are relations that must hold between the lifetimes that you supplied as inputs.-->
   **地域の制約：**これはあなたが入力として提供した生涯の間に保持されなければならない関係です。
<!--We'll ignore these here, but see the [section on handling regions in traits](./traits/regions.html) for more details.-->
   これらはここでは無視しますが、詳細については[特性の領域を扱うセクションを](./traits/regions.html)参照してください。
- <!--**Value:** The query result also comes with a value of type `T`.-->
   **値：**クエリ結果には、タイプ`T`値も含まれます。
<!--For some specialized queries – like normalizing associated types – this is used to carry back an extra result, but it's often just `()`.-->
   関連する型の正規化などの特殊なクエリでは、余分な結果を返すために使用されますが、しばしば単なる`()`です。

### <!--Examples--> 例

<!--Let's work through an example query to see what all the parts mean.-->
すべての部品の意味を調べるためのサンプルクエリを試してみましょう。
<!--Consider [the `Borrow` trait][borrow].-->
[`Borrow`特性を][borrow]考えてみましょう。
<!--This trait has a number of impls;-->
この形質には多くの意味があります。
<!--among them, there are these two (for clarify, I've written the `Sized` bounds explicitly):-->
その中には、これらの2つがあります（明確にするために、私は`Sized`境界を明示的に記述しました）。

[borrow]: https://doc.rust-lang.org/std/borrow/trait.Borrow.html

```rust,ignore
impl<T> Borrow<T> for T where T: ?Sized
impl<T> Borrow<[T]> for Vec<T> where T: Sized
```

<!--**Example 1.** Imagine we are type-checking this (rather artificial) bit of code:-->
**例1.**この（人工的ではなく）コードの型チェックをしているとします。

```rust,ignore
fn foo<A, B>(a: A, vec_b: Option<B>) where A: Borrow<B> { }

fn main() {
#//    let mut t: Vec<_> = vec![]; // Type: Vec<?T>
Div ("",[],[("data-l","    let mut t: Vec<_> = vec![]; // ")]) [Plain [Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "Type:",Space,Str "Vec"],Str "\12479\12452\12503\65306Vec"]],RawBlock (Format "html") "<?t ?>"]#//    let mut u: Option<_> = None; // Type: Option<?U>
Div ("",[],[("data-l","    let mut u: Option<_> = None; // ")]) [Plain [Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "Type:",Space,Str "Option"],Str "\12479\12452\12503\65306\12458\12503\12471\12519\12531"]],RawBlock (Format "html") "<?u ?>"]#//    foo(t, u); // Example 1: requires `Vec<?T>: Borrow<?U>`
    foo(t, u); // 例1： `Vec<?T>: Borrow<?U>`が必要`Vec<?T>: Borrow<?U>`
    ...
}
```

<!--As the comments indicate, we first create two variables `t` and `u`;-->
コメントが示すように、まず2つの変数`t`と`u`作成します。
<!--`t` is an empty vector and `u` is a `None` option.-->
`t`は空のベクトルで、`u`は`None`オプションです。
<!--Both of these variables have unbound inference variables in their type: `?T` represents the elements in the vector `t` and `?U` represents the value stored in the option `u`.-->
これらの変数の両方とも、その型に束縛されていない推論変数を持ち`?T`はベクトル`t`要素を表し、`?U`はオプション`u`格納された値を表します。
<!--Next, we invoke `foo`;-->
次に、`foo`を呼び出します。
<!--comparing the signature of `foo` to its arguments, we wind up with `A = Vec<?T>` and `B = ?U`.Therefore, the where clause on `foo` requires that `Vec<?T>: Borrow<?U>`.-->
`foo`のシグネチャとその引数を比較すると、`A = Vec<?T>`と`B = ?U`となり`B = ?U`したがって、`foo`のwhere句には`Vec<?T>: Borrow<?U>`です。
<!--This is thus our first example trait query.-->
これが最初のtrait queryの例です。

<!--There are many possible solutions to the query `Vec<?T>: Borrow<?U>`;-->
クエリ`Vec<?T>: Borrow<?U>`は、多くの解決策があります`Vec<?T>: Borrow<?U>`;
<!--for example:-->
例えば：

- <!--`?U = Vec<?T>`,-->
   `?U = Vec<?T>`
- <!--`?U = [?T]`,-->
   `?U = [?T]`、
- `?T = u32, ?U = [u32]`
- <!--and so forth.-->
   等々。

<!--Therefore, the result we get back would be as follows (I'm going to ignore region constraints and the "value"):-->
したがって、私たちが返す結果は次のようになります（リージョンの制約と「値」を無視します）。

- <!--Certainty: `Ambiguous` – we're not sure yet if this holds-->
   確実性： `Ambiguous` -これが成立すればまだわからない
- <!--Var values: `[?T = ?T, ?U = ?U]` – we learned nothing about the values of the variables-->
   変数値： `[?T = ?T, ?U = ?U]` -変数の値については何も学びませんでした

<!--In short, the query result says that it is too soon to say much about whether this trait is proven.-->
要するに、クエリーの結果は、この形質が証明されているかどうかについてはあまりにも早すぎると言います。
<!--During type-checking, this is not an immediate error: instead, the type checker would hold on to this requirement (`Vec<?T>: Borrow<?U>`) and wait.-->
タイプチェックの間、これは直接的なエラーではありません。代わりに、タイプチェッカーはこの要件（`Vec<?T>: Borrow<?U>`）を保持して待機します。
<!--As we'll see in the next example, it may happen that `?T` and `?U` wind up constrained from other sources, in which case we can try the trait query again.-->
次の例でわかるように、`?T`と`?U`が他のソースから拘束されることがあります。この場合、特性クエリを再度試すことができます。

<!--**Example 2.** We can now extend our previous example a bit, and assign a value to `u`:-->
**例2**これまでの例を少し拡張して、`u`値を代入することができます：

```rust,ignore
fn foo<A, B>(a: A, vec_b: Option<B>) where A: Borrow<B> { }

fn main() {
#    // What we saw before:
    // 私たちが以前見たもの：
#//    let mut t: Vec<_> = vec![]; // Type: Vec<?T>
Div ("",[],[("data-l","    let mut t: Vec<_> = vec![]; // ")]) [Plain [Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "Type:",Space,Str "Vec"],Str "\12479\12452\12503\65306Vec"]],RawBlock (Format "html") "<?t ?>"]#//    let mut u: Option<_> = None; // Type: Option<?U>
Div ("",[],[("data-l","    let mut u: Option<_> = None; // ")]) [Plain [Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "Type:",Space,Str "Option"],Str "\12479\12452\12503\65306\12458\12503\12471\12519\12531"]],RawBlock (Format "html") "<?u ?>"]#//    foo(t, u); // `Vec<?T>: Borrow<?U>` => ambiguous
    foo(t, u); //  `Vec<?T>: Borrow<?U>` =>あいまい

#    // New stuff:
    // 新しいもの：
#//    u = Some(vec![]); // ?U = Vec<?V>
Div ("",[],[("data-l","    u = Some(vec![]); // ")]) [Plain [Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "?U",Space,Str "=",Space,Str "Vec"],Space,Str "\65311U",Space,Str "=",Space,Str "Vec"]],RawBlock (Format "html") "<?v ?>"]}
```

<!--As a result of this assignment, the type of `u` is forced to be `Option<Vec<?V>>`, where `?V` represents the element type of the vector.-->
この代入の結果として、`u`の型は強制的に`Option<Vec<?V>>`になり`?V`ここで、`?V`はベクトルの要素型を表します。
<!--This in turn implies that `?U` is [unified] to `Vec<?V>`.-->
これは、`?U`が`Vec<?V>` [unified]れることを意味する。

[unified]: ./type-checking.html

<!--Let's suppose that the type checker decides to revisit the "as-yet-unproven"trait obligation we saw before, `Vec<?T>: Borrow<?U>`.-->
タイプ・チェッカーが、以前に見た「未だに証明されていない」特性義務を再考することを決めたとしよう`Vec<?T>: Borrow<?U>`。
<!--`?U` is no longer an unbound inference variable;-->
`?U`はもはや束縛されていない推論変数ではありません。
<!--it now has a value, `Vec<?V>`.-->
`Vec<?V>`という値を持つようになりました。
<!--So, if we "refresh"the query with that value, we get:-->
したがって、その値でクエリを「リフレッシュ」すると、次のようになります。

```text
Vec<?T>: Borrow<Vec<?V>>
```

<!--This time, there is only one impl that applies, the reflexive impl:-->
今回は、適用されるインプラントは1つしかなく、リフレクティブなインプットがあります。

```text
impl<T> Borrow<T> for T where T: ?Sized
```

<!--Therefore, the trait checker will answer:-->
したがって、特性チェッカーは答えます：

- <!--Certainty: `Proven`-->
   確かさ： `Proven`
- <!--Var values: `[?T = ?T, ?V = ?T]`-->
   Var値： `[?T = ?T, ?V = ?T]`

<!--Here, it is saying that we have indeed proven that the obligation holds, and we also know that `?T` and `?V` are the same type (but we don't know what that type is yet!).-->
ここでは、義務が成立していることが実証されているということ`?T`と`?V`は同じタイプです（ただし、そのタイプはまだわかりません）。

<!--(In fact, as the function ends here, the type checker would give an error at this point, since the element types of `t` and `u` are still not yet known, even though they are known to be the same.)-->
（関数がここで終わると、型チェッカーは`t`と`u`要素型がまだ分かっていないため、この時点で型チェッカーにエラーが発生します）。


