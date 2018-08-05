# <!--impl Trait--> インプット特性

<!--`impl Trait` is the new way to specify unnamed but concrete types that implement a specific trait.-->
`impl Trait`は、特定の特性を実装する名前のない具体的な型を指定する新しい方法です。
<!--There are two places you can put it: argument position, and return position.-->
あなたが置くことができる場所は、引数の位置と戻り位置の2つです。

```rust,ignore
trait Trait {}

#// argument position
// 引数の位置
fn foo(arg: impl Trait) {
}

#// return position
// 戻り位置
fn foo() -> impl Trait {
}
```

## <!--Argument Position--> 引数の位置

<!--In argument position, this feature is quite simple.-->
引数の位置では、この機能は非常に単純です。
<!--These two forms are almost the same:-->
これらの2つの形式はほぼ同じです。

```rust,ignore
trait Trait {}

fn foo<T: Trait>(arg: T) {
}

fn foo(arg: impl Trait) {
}
```

<!--That is, it's a slightly shorter syntax for a generic type parameter.-->
つまり、ジェネリック型パラメータのシンタックスが少し短くなっています。
<!--It means, "`arg` is an argument that takes any type that implements the `Trait` trait."-->
それは「意味`arg`実装する任意のタイプとる引数である`Trait`形質を。」

<!--However, there's also an important technical difference between `T: Trait` and `impl Trait` here.-->
しかし、間の重要な技術的な違いもあります`T: Trait`と`impl Trait`ここでは。
<!--When you write the former, you can specify the type of `T` at the call site with turbo-fish syntax as with `foo::<usize>(1)`.-->
前者を書くときは、`foo::<usize>(1)`ようにturbo-fish構文を使ってコールサイトで`T`のタイプを指定することができます。
<!--In the case of `impl Trait`, if it is used anywhere in the function definition, then you can't use turbo-fish at all.-->
`impl Trait`の場合、関数定義のどこでも使用されていれば、ターボフィッシュはまったく使用できません。
<!--Therefore, you should be mindful that changing both from and to `impl Trait` can constitute a breaking change for the users of your code.-->
したがって、`impl Trait`を`impl Trait`から`impl Trait`変えることは、あなたのコードのユーザにとって大きな変化をもたらす可能性があることに注意してください。

## <!--Return Position--> 戻り位置

<!--In return position, this feature is more interesting.-->
戻り位置では、この機能はより面白いです。
<!--It means "I am returning some type that implements the `Trait` trait, but I'm not going to tell you exactly what the type is."-->
それは、「私は、`Trait`形質を実装するいくつかの型を返していますが、型が何であるかを正確に伝えるつもりはありません」という意味です。
<!--Before `impl Trait`, you could do this with trait objects:-->
`impl Trait`前に、traitオブジェクトでこれを行うことができます：

```rust
trait Trait {}

impl Trait for i32 {}

fn returns_a_trait_object() -> Box<dyn Trait> {
    Box::new(5)
}
```

<!--However, this has some overhead: the `Box<T>` means that there's a heap allocation here, and this will use dynamic dispatch.-->
しかし、これにはいくつかのオーバーヘッドがあります`Box<T>`はここにヒープ割り当てがあることを意味し、動的ディスパッチを使用します。
<!--See the [`dyn Trait`] section for an explanation of this syntax.-->
この構文の説明については、[`dyn Trait`]セクションを参照してください。
<!--But we only ever return one possible thing here, the `Box<i32>`.-->
しかし、私たちは一つの可能​​なもの、`Box<i32>`返すだけです。
<!--This means that we're paying for dynamic dispatch, even though we don't use it!-->
これは、たとえそれを使用していないとしても、動的なディスパッチを支払うことを意味します。

<!--With `impl Trait`, the code above could be written like this:-->
`impl Trait`では、上のコードは次のように書くことができます：

```rust
trait Trait {}

impl Trait for i32 {}

fn returns_a_trait_object() -> impl Trait {
    5
}
```

<!--Here, we have no `Box<T>`, no trait object, and no dynamic dispatch.-->
ここでは、`Box<T>`、Traitオブジェクト、および動的ディスパッチはありません。
<!--But we still can obscure the `i32` return type.-->
しかし私はまだ`i32`戻り値の型をあいまいにすることができます。

<!--With `i32`, this isn't super useful.-->
`i32`では、これは非常に便利ではありません。
<!--But there's one major place in Rust where this is much more useful: closures.-->
しかし、Rustにはこれがはるかに便利な1つの主要な場所があります：閉鎖。

[`dyn Trait`]: 2018/transitioning/traits/dyn-trait.html

### <!--`impl Trait` and closures--> `impl Trait`とクロージャ

> <!--If you need to catch up on closures, check out [their chapter in the book](https://doc.rust-lang.org/book/second-edition/ch13-01-closures.html).-->
> 閉鎖に追いつく必要がある場合[は、本の章を参照して](https://doc.rust-lang.org/book/second-edition/ch13-01-closures.html)ください。

<!--In Rust, closures have a unique, un-writable type.-->
Rustでは、クロージャーは一意で書き込み不可能なタイプです。
<!--They do implement the `Fn` family of traits, however.-->
しかし彼らは、`Fn`ファミリーの形質を導入してい`Fn`。
<!--This means that previously, the only way to return a closure from a function was to use a trait object:-->
これは、これまで、関数からクロージャを返す唯一の方法は、traitオブジェクトを使用することでした：

```rust
fn returns_closure() -> Box<dyn Fn(i32) -> i32> {
    Box::new(|x| x + 1)
}
```

<!--You couldn't write the type of the closure, only use the `Fn` trait.-->
クロージャーのタイプを書くことはできず、`Fn`特性のみを使用し`Fn`。
<!--That means that the trait object is necessary.-->
つまり、特性オブジェクトが必要です。
<!--However, with `impl Trait`:-->
しかしながら、`impl Trait`：

```rust
fn returns_closure() -> impl Fn(i32) -> i32 {
    |x| x + 1
}
```

<!--We can now return closures by value, just like any other type!-->
他の型と同じように、クロージャを値で返すことができるようになりました。

## <!--More details--> 詳細

<!--The above is all you need to know to get going with `impl Trait`, but for some more nitty-gritty details: type parameters and `impl Trait` in argument position are universals (universally quantified types).-->
上のものは、インプ`impl Trait`を使うために知る必要があるのですが、いくつかのより詳細な詳細については、型パラメータとインプリメント引数位置の`impl Trait`はユニバーサル（普遍的な定量型）です。
<!--Meanwhile, `impl Trait` in return position are existentials (existentially quantified types).-->
一方、リターン位置の`impl Trait`は、存在する（現存する定量化された型）。
<!--Okay, maybe that's a bit too jargon-heavy.-->
さて、あまりにも専門用語が重すぎるかもしれません。
<!--Let's step back.-->
元気に戻ろう。

<!--Consider this function:-->
この関数を考えてみましょう：

```rust,ignore
fn foo<T: Trait>(x: T) {
```

<!--When you call it, you set the type, `T`.-->
あなたがそれを呼び出すと、タイプ`T`を設定します。
<!--"you"being the caller here.-->
"あなた"はここに発信者です。
<!--This signature says "I accept any type that implements Trait."-->
このシグネチャは「私はTraitを実装するすべての型を受け入れる」と述べています。
<!--("any type"== universal in the jargon)-->
（「任意のタイプ」==専門用語の普遍的な）

<!--This version:-->
このバージョン：

```rust,ignore
fn foo<T: Trait>() -> T {
```

<!--is similar, but also different.-->
類似しているが、異なっている。
<!--You, the caller, provide the type you want, `T`, and then the function returns it.-->
呼び出し元は、必要な型`T`、関数がそれを返します。
<!--You can see this in Rust today with things like parse or collect:-->
あなたは今日、Rustでこれをparseやcollectのようなもので見ることができます：

```rust,ignore
let x: i32 = "5".parse()?;
let x: u64 = "5".parse()?;
```

<!--Here, `.parse` has this signature:-->
ここでは、`.parse`は次のシグネチャがあります。

```rust,ignore
pub fn parse<F>(&self) -> Result<F, <F as FromStr>::Err> where
    F: FromStr,
```

<!--Same general idea, though with a result type and `FromStr` has an associated type... anyway, you can see how `F` is in the return position here.-->
同じ一般的な考え方ですが、結果の型と`FromStr`には関連する型があります...とにかく、ここで`F`がどのように戻り位置にあるかを見ることができます。
<!--So you have the ability to choose.-->
あなたは選択する能力があります。

<!--With `impl Trait`, you're saying "hey, some type exists that implements this trait, but I'm not gonna tell you what it is."-->
`impl Trait`では、「ねえ、この特性を実現するいくつかのタイプが存在しますが、私はそれが何であるか教えてくれません」と言っています。
<!--("existential"in the jargon, "some type exists").-->
（専門用語の「実在性」、「何らかのタイプが存在する」）。
<!--So now, the caller can't choose, and the function itself gets to choose.-->
だから今、呼び出し側は選択することはできません、関数自体を選択します。
<!--If we tried to define parse with `Result<impl F,...` as the return type, it wouldn't work.-->
`Result<impl F,...`を戻り値の型として構文解析を定義しようとすると、動作しません。

### <!--Using `impl Trait` in more places--> より多くの場所で`impl Trait`を使用する

<!--As previously mentioned, as a start, you will only be able to use `impl Trait` as the argument or return type of a free or inherent function.-->
前述したように、最初は、自由`impl Trait`または固有の関数の引数または戻り値の型として`impl Trait`を使用することしかできません。
<!--However, `impl Trait` can't be used inside implementations of traits, nor can it be used as the type of a let binding or inside a type alias.-->
しかし、`impl Trait`は形質の実装の中で使用することはできず、レットバインディングのタイプとしても、タイプエイリアスの内部としても使用することはできません。
<!--Some of these restrictions will eventually be lifted.-->
これらの制限の一部は最終的に解除されます。
<!--For more information, see the [tracking issue on `impl Trait`](https://github.com/rust-lang/rust/issues/34511).-->
詳細については、[`impl Trait`トラッキングの問題を](https://github.com/rust-lang/rust/issues/34511)参照してください。
