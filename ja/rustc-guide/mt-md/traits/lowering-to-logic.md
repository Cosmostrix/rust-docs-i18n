# <!--Lowering to logic--> ロジックに下げる

<!--The key observation here is that the Rust trait system is basically a kind of logic, and it can be mapped onto standard logical inference rules.-->
ここで重要なのは、Rust形質システムは基本的に一種の論理であり、標準の論理推論ルールにマッピングできるということです。
<!--We can then look for solutions to those inference rules in a very similar fashion to how eg a [Prolog] solver works.-->
これらの推論規則の解を、[Prolog]ソルバの動作方法と非常によく似た方法で探すことができます。
<!--It turns out that we can't *quite* use Prolog rules (also called Horn clauses) but rather need a somewhat more expressive variant.-->
それは、我々は*非常に* Prologのルールを使用します（また、ホーン節と呼ばれる）のではなく、ややより表現の変形を必要とすることはできませんことが判明しました。

[Prolog]: https://en.wikipedia.org/wiki/Prolog

## <!--Rust traits and logic--> 錆の特性とロジック

<!--One of the first observations is that the Rust trait system is basically a kind of logic.-->
最初の観察の1つは、Rust形質システムは基本的に一種の論理であるということです。
<!--As such, we can map our struct, trait, and impl declarations into logical inference rules.-->
このように、私たちはstruct、trait、impl宣言を論理的な推論規則にマップすることができます。
<!--For the most part, these are basically Horn clauses, though we'll see that to capture the full richness of Rust – and in particular to support generic programming – we have to go a bit further than standard Horn clauses.-->
ほとんどの場合、これらは基本的にHorn節ですが、Rustの完全な豊富さ、特に汎用プログラミングをサポートすることがわかりますが、標準的なHorn節よりも少し先に進む必要があります。

<!--To see how this mapping works, let's start with an example.-->
このマッピングがどのように機能するかを確認するには、まず例を見てみましょう。
<!--Imagine we declare a trait and a few impls, like so:-->
私たちが特質を宣言し、いくつかのことがそうであると想像してみましょう：

```rust
trait Clone { }
impl Clone for usize { }
impl<T> Clone for Vec<T> where T: Clone { }
```

<!--We could map these declarations to some Horn clauses, written in a Prolog-like notation, as follows:-->
これらの宣言を、Prologのような表記法で書かれたHorn節にマップすると、次のようになります。

```text
Clone(usize).
Clone(Vec<?T>) :- Clone(?T).

#// The notation `A :- B` means "A is true if B is true".
#// Or, put another way, B implies A.
// 表記`A :- B`は、"`A :- B`が真であればAは真"を意味する。あるいは、別の言い方をすれば、BはAを意味する。
```

<!--In Prolog terms, we might say that `Clone(Foo)` – where `Foo` is some Rust type – is a *predicate* that represents the idea that the type `Foo` implements `Clone`.-->
Prologの項では、我々は言うかもしれない`Clone(Foo)` -`Foo`、いくつかの錆のタイプであるが-タイプという考えを表す*述語*である`Foo`実装`Clone`。
<!--These rules are **program clauses**;-->
これらの規則は**プログラム条項**です。
<!--they state the conditions under which that predicate can be proven (ie, considered true).-->
その述語が証明できる（すなわち、真であると考えられる）条件を述べている。
<!--So the first rule just says "Clone is implemented for `usize` ".-->
したがって、最初のルールでは「クローンは`usize`ために実装されてい`usize` 」と`usize`れています。
<!--The next rule says "for any type `?T`, Clone is implemented for `Vec<?T>` if clone is implemented for `?T` ".-->
次のルールでは、「どのタイプの`?T`でもクローンが`?T`に実装されていれば、`Vec<?T>`ためにクローンが実装されてい`?T`。
<!--So eg if we wanted to prove that `Clone(Vec<Vec<usize>>)`, we would do so by applying the rules recursively:-->
たとえば、`Clone(Vec<Vec<usize>>)`を証明したい場合、ルールを再帰的に適用することでそうすることができます。

- <!--`Clone(Vec<Vec<usize>>)` is provable if:-->
   `Clone(Vec<Vec<usize>>)`は、次の場合に証明可能です。
  - <!--`Clone(Vec<usize>)` is provable if:-->
     `Clone(Vec<usize>)`は、次の場合に証明可能です。
    - <!--`Clone(usize)` is provable.-->
       `Clone(usize)`は証明可能です。
<!--(Which is is, so we're all good.)-->
       （それは、だから私たちはすべて良いです。）

<!--But now suppose we tried to prove that `Clone(Vec<Bar>)`.-->
しかし今、私たちが`Clone(Vec<Bar>)`を証明しようとしたとします。
<!--This would fail (after all, I didn't give an impl of `Clone` for `Bar`):-->
これは失敗する（結局、私は`Bar`の`Clone`インプリメントを与えなかった）。

- <!--`Clone(Vec<Bar>)` is provable if:-->
   `Clone(Vec<Bar>)`は、次の場合に証明可能です。
  - <!--`Clone(Bar)` is provable.-->
     `Clone(Bar)`は証明可能です。
<!--(But it is not, as there are no applicable rules.)-->
     （ただし、適用されるルールがないため、そうではありません。）

<!--We can easily extend the example above to cover generic traits with more than one input type.-->
上記の例を、複数の入力タイプを持つ一般的な特性をカバーするように簡単に拡張することができます。
<!--So imagine the `Eq<T>` trait, which declares that `Self` is equatable with a value of type `T`:-->
それで、`Self`が`T`型の値と等価であると宣言する`Eq<T>`特性を想像してください：

```rust,ignore
trait Eq<T> { ... }
impl Eq<usize> for usize { }
impl<T: Eq<U>> Eq<Vec<U>> for Vec<T> { }
```

<!--That could be mapped as follows:-->
それは次のようにマッピングすることができます：

```text
Eq(usize, usize).
Eq(Vec<?T>, Vec<?U>) :- Eq(?T, ?U).
```

<!--So far so good.-->
ここまでは順調ですね。

## <!--Type-checking normal functions--> 型チェック正常関数

<!--OK, now that we have defined some logical rules that are able to express when traits are implemented and to handle associated types, let's turn our focus a bit towards **type-checking**.-->
さて、形質の実装時に表現できる論理的な規則を定義し、関連する型を扱うようになったので、ここでは**型チェックに**向けて少し焦点を合わせましょう。
<!--Type-checking is interesting because it is what gives us the goals that we need to prove.-->
タイプ・チェックは面白いです。なぜなら、タイプ・チェッキングは私たちが証明する必要がある目標を提供するからです。
<!--That is, everything we've seen so far has been about how we derive the rules by which we can prove goals from the traits and impls in the program;-->
つまり、今まで見てきたことは、どのようにして我々がその特性から目標を証明し、プログラムに含めることができるかというルールを導き出すことであった。
<!--but we are also interested in how to derive the goals that we need to prove, and those come from type-checking.-->
しかし、私たちが証明しなければならない目標を導出する方法と、型チェックから来るものにも興味があります。

<!--Consider type-checking the function `foo()` here:-->
次の関数`foo()`型チェックを検討してください。

```rust,ignore
fn foo() { bar::<usize>() }
fn bar<U: Eq<U>>() { }
```

<!--This function is very simple, of course: all it does is to call `bar::<usize>()`.-->
この関数は非常に単純`bar::<usize>()`を呼び出すだけです。
<!--Now, looking at the definition of `bar()`, we can see that it has one where-clause `U: Eq<U>`.-->
さて、`bar()`定義を見ると、where節`U: Eq<U>`があることが分かります。
<!--So, that means that `foo()` will have to prove that `usize: Eq<usize>` in order to show that it can call `bar()` with `usize` as the type argument.-->
だから、`foo()`は、`usize`をtype引数として`bar()`を`usize`ことを示すために、`usize: Eq<usize>`を証明する必要があります。

<!--If we wanted, we could write a Prolog predicate that defines the conditions under which `bar()` can be called.-->
必要ならば、`bar()`を呼び出すことができる条件を定義するProlog述語を書くことができます。
<!--We'll say that those conditions are called being "well-formed":-->
これらの条件は「整形式」と呼ばれています。

```text
barWellFormed(?U) :- Eq(?U, ?U).
```

<!--Then we can say that `foo()` type-checks if the reference to `bar::<usize>` (that is, `bar()` applied to the type `usize`) is well-formed:-->
次に`foo()`型は、`bar()` `bar::<usize>`への参照（つまり、`usize`型に適用された`bar()`が`bar::<usize>`式であるかどうかを`usize`）。

```text
fooTypeChecks :- barWellFormed(usize).
```

<!--If we try to prove the goal `fooTypeChecks`, it will succeed:-->
`fooTypeChecks`の目標を証明しようとすると成功します：

- <!--`fooTypeChecks` is provable if:-->
   `fooTypeChecks`場合、`fooTypeChecks`は証明可能です。
  - <!--`barWellFormed(usize)`, which is provable if:-->
     `barWellFormed(usize)`。次の場合に証明可能です。
    - <!--`Eq(usize, usize)`, which is provable because of an impl.-->
       `Eq(usize, usize)`。これはimplのために証明可能です。

<!--Ok, so far so good.-->
さて、これほど良い。
<!--Let's move on to type-checking a more complex function.-->
もっと複雑な関数の型チェックをしましょう。

## <!--Type-checking generic functions: beyond Horn clauses--> 型チェック汎用関数：ホーン節を越えて

<!--In the last section, we used standard Prolog horn-clauses (augmented with Rust's notion of type equality) to type-check some simple Rust functions.-->
最後のセクションでは、シンプルなRust関数を型チェックするために、標準的なPrologホーン節（Rustの型平等の概念を補強したもの）を使用しました。
<!--But that only works when we are type-checking non-generic functions.-->
しかし、これは非ジェネリック関数を型チェックするときにのみ機能します。
<!--If we want to type-check a generic function, it turns out we need a stronger notion of goal than Prolog can be provide.-->
ジェネリック関数の型チェックをしたいのであれば、Prologが提供できる目標よりも強い目標が必要であることが分かります。
<!--To see what I'm talking about, let's revamp our previous example to make `foo` generic:-->
私が何を話しているのかを見るには、前の例を改良して`foo`一般化するようにしましょう：

```rust,ignore
fn foo<T: Eq<T>>() { bar::<T>() }
fn bar<U: Eq<U>>() { }
```

<!--To type-check the body of `foo`, we need to be able to hold the type `T` "abstract".-->
`foo`の本体を型チェックするには、型`T` "抽象"にする必要があります。
<!--That is, we need to check that the body of `foo` is type-safe *for all types `T`*, not just for some specific type.-->
つまり、`foo`の本体が、特定の型だけでなく、*すべての型 'T'に対して*型安全であることを確認する必要があります。
<!--We might express this like so:-->
私たちはこれを次のように表現するかもしれません：

```text
fooTypeChecks :-
#  // for all types T...
  // すべてのタイプのTのために...
  forall<T> {
#    // ...if we assume that Eq(T, T) is provable...
    // ... Eq（T、T）が証明可能であると仮定すると...
    if (Eq(T, T)) {
#      // ...then we can prove that `barWellFormed(T)` holds.
      // ... `barWellFormed(T)`が成り立つことを証明できます。
      barWellFormed(T)
    }
  }.
```

<!--This notation I'm using here is the notation I've been using in my prototype implementation;-->
ここで使用しているこの表記法は、私のプロトタイプ実装で使用している表記法です。
<!--it's similar to standard mathematical notation but a bit Rustified.-->
それは標準的な数学的表記法に似ていますが、少し錆びました。
<!--Anyway, the problem is that standard Horn clauses don't allow universal quantification (`forall`) or implication (`if`) in goals (though many Prolog engines do support them, as an extension).-->
とにかく、問題は、標準的なホーン節では、普遍的な定量化（`forall`）や含意（ `if`）がゴールに許されないことです（多くのPrologエンジンがそれらをサポートしていますが）。
<!--For this reason, we need to accept something called "first-order hereditary harrop"(FOHH) clauses – this long name basically means "standard Horn clauses with `forall` and `if` in the body".-->
この長い名前は基本的に「と標準ホーン節意味-このような理由から、私たちは、「一次遺伝性のハロップ」（FOHH）条項と呼ばれるもの受け入れる必要が`forall`と`if`、体内での」。
<!--But it's nice to know the proper name, because there is a lot of work describing how to efficiently handle FOHH clauses;-->
しかし、FOHH句を効率的に扱う方法を記述する作業がたくさんあるので、適切な名前を知ることはうれしいことです。
<!--see for example Gopalan Nadathur's excellent ["A Proof Procedure for the Logic of Hereditary Harrop Formulas"][pphhf] in [the bibliography].-->
例ゴパランNadathurの優れたを参照[「遺伝ハロップ式のロジックのための証明手順」][pphhf]で[the bibliography]。

<!--[the bibliography]: ./traits/bibliography.html
 [pphhf]: ./traits/bibliography.html#pphhf
-->
[the bibliography]: ./traits/bibliography.html
 [pphhf]: ./traits/bibliography.html#pphhf


<!--It turns out that supporting FOHH is not really all that hard.-->
FOHHのサポートはそれほど難しいことではないことが判明しました。
<!--And once we are able to do that, we can easily describe the type-checking rule for generic functions like `foo` in our logic.-->
そしてそれができたら、`foo`ようなジェネリック関数の型チェックルールをロジックに簡単に記述することができます。

## <!--Source--> ソース

<!--This page is a lightly adapted version of a [blog post by Nicholas Matsakis][lrtl].-->
このページは、[Nicholas Matsakisのブログ記事の][lrtl]軽いバージョンです。

[lrtl]: http://smallcultfollowing.com/babysteps/blog/2017/01/26/lowering-rust-traits-to-logic/
