# <!--Subtyping and Variance--> サブタイプと差異

<!--Subtyping is a relationship between types that allows statically typed languages to be a bit more flexible and permissive.-->
サブタイプとは、静的に型指定された言語を少し柔軟性と許容性があるようにするタイプ間の関係です。

<!--The most common and easy to understand example of this can be found in languages with inheritance.-->
最も一般的で分かりやすい例は、継承のある言語で見つけることができます。
<!--Consider an Animal type which has an `eat()` method, and a Cat type which extends Animal, adding a `meow()` method.-->
`eat()`メソッドを持つAnimal型と`meow()`するCat型を考え、`meow()`メソッドを追加します。
<!--Without subtyping, if someone were to write a `feed(Animal)` function, they wouldn't be able to pass a Cat to this function, because a Cat isn't *exactly* an Animal.-->
誰かが書き込みをした場合にサブタイプがなければ、`feed(Animal)`機能を猫は*まさに*動物ではないので、彼らは、この関数に猫を渡すことができないだろう。
<!--But being able to pass a Cat where an Animal is expected seems fairly reasonable.-->
しかし、Animalが期待されるCatを渡すことができることはかなり合理的です。
<!--After all, a Cat is just an Animal *and more*.-->
結局のところ、猫はただの動物で*あり、それ以上*です。
<!--Something having extra features that can be ignored shouldn't be any impediment to using it!-->
無視できる余分な機能を持っているものは、それを使うことに何の障害もないはずです！

<!--This is exactly what subtyping lets us do.-->
これはサブタイピングが私たちにできることです。
<!--Because a Cat is an Animal *and more* we say that Cat is a *subtype* of Animal.-->
猫は動物で*あり*、猫は動物の*亜型*であるといっています。
<!--We then say that anywhere a value of a certain type is expected, a value with a subtype can also be supplied.-->
次に、特定の型の値が期待される場所であればどこでも、サブ型の値を指定することができます。
<!--Ok actually it's a lot more complicated and subtle than that, but that's the basic intuition that gets you by in 99% of the cases.-->
実際、それはそれよりずっと複雑で微妙ですが、それは99％のケースであなたを得る基本的な直感です。
<!--We'll cover why it's *only* 99% later in this section.-->
なぜこのセクションでは99％ *しかないの*かを説明します。

<!--Although Rust doesn't have any notion of structural inheritance, it *does* include subtyping.-->
Rustには構造上の継承という概念はありませんが、サブタイプ*も*含まれます。
<!--In Rust, subtyping derives entirely from lifetimes.-->
Rustでは、サブタイプは完全に生涯から派生しています。
<!--Since lifetimes are regions of code, we can partially order them based on the *contains* (outlives) relationship.-->
ライフタイムはコードの領域なので、*contains*（outlives）関係に基づいて部分的に順序付けを行うことができます。

<!--Subtyping on lifetimes is in terms of that relationship: if `'big: 'small` ("big contains small"or "big outlives small"), then `'big` is a subtype of `'small`.-->
生存期間のサブタイプ化は、その関係の観点から行われます。「大きい」 `'big: 'small` 」（「大きなものが小さい」または「大きいものが小さい」）の場合、`'big` `'small`は`'small`サブタイプです。
<!--This is a large source of confusion, because it seems backwards to many: the bigger region is a *subtype* of the smaller region.-->
これは混乱の大きな原因です。なぜなら、それは多くの人に逆行しているように見えるからです。より大きな領域は、より小さな領域の*サブタイプ*です。
<!--But it makes sense if you consider our Animal example: *Cat* is an Animal *and more*, just as `'big` is `'small` *and more*.-->
あなたが私たちの動物の例を考えてみた場合しかし、それは理にかなっている： *猫は*同じように、動物*とより*である`'big`ある`'small` *とより*。

<!--Put another way, if someone wants a reference that lives for `'small`, usually what they actually mean is that they want a reference that lives for *at least* `'small`.-->
別の言い方をすれば、誰かが`'small`ために生きる参照を望んでいるのであれば、彼らが実際に意味することは*、少なくとも* `'small`生活を送る参照が欲しいということです。
<!--They don't actually care if the lifetimes match exactly.-->
生涯が正確に一致するかどうかは実際には気にしません。
<!--For this reason `'static`, the forever lifetime, is a subtype of every lifetime.-->
この理由から、`'static`永遠の生涯`'static`は、あらゆる生涯のサブタイプです。

<!--Higher-ranked lifetimes are also subtypes of every concrete lifetime.-->
ランクの高いランクは、すべての具体的な生涯のサブタイプです。
<!--This is because taking an arbitrary lifetime is strictly more general than taking a specific one.-->
これは、任意の生涯を取ることは、特定の生涯を取ることよりも厳密に一般的であるからです。

<!--(The typed-ness of lifetimes is a fairly arbitrary construct that some disagree with. However it simplifies our analysis to treat lifetimes and types uniformly.)-->
（型定義された生涯は、それに反するいくつかのものはかなり恣意的な構造ですが、生涯と型を一様に扱うために分析を単純化します）。

<!--However you can't write a function that takes a value of type `'a`!-->
しかし、タイプ`'a`！ `'a`値をとる関数を書くことはできません。
<!--Lifetimes are always just part of another type, so we need a way of handling that.-->
生涯は常に他のタイプの一部に過ぎません。したがって、その処理方法が必要です。
<!--To handle it, we need to talk about *variance*.-->
それを処理するには、*分散*について話す必要があります。





# <!--Variance--> 分散

<!--Variance is where things get a bit complicated.-->
差異は物事が少し複雑になるところです。

<!--Variance is a property that *type constructors* have with respect to their arguments.-->
分散は、*型コンストラクタ*が引数に関して持つプロパティです。
<!--A type constructor in Rust is a generic type with unbound arguments.-->
Rustの型コンストラクタは、バインドされていない引数を持つジェネリック型です。
<!--For instance `Vec` is a type constructor that takes a `T` and returns a `Vec<T>`.-->
例えば、`Vec`は`T`をとり、`Vec<T>`を返す型コンストラクタです。
<!--`&` and `&mut` are type constructors that take two inputs: a lifetime, and a type to point to.-->
`&`と`&mut`は、2つの入力を取るタイプのコンストラクタです：生涯とポイントする型です。

<!--A type constructor F's *variance* is how the subtyping of its inputs affects the subtyping of its outputs.-->
タイプコンストラクタFの*分散*は、入力のサブタイプがその出力のサブタイプにどのように影響するかです。
<!--There are three kinds of variance in Rust:-->
Rustには3種類の分散があります：

* <!--F is *covariant* over `T` if `T` being a subtype of `U` implies `F<T>` is a subtype of `F<U>` (subtyping "passes through")-->
   Fは上*共変*である`T`場合`T`のサブタイプである`U`意味`F<T>`のサブタイプである`F<U>`（サブタイプ「通過します」）
* <!--F is *contravariant* over `T` if `T` being a subtype of `U` implies `F<U>` is a subtype of `F<T>` (subtyping is "inverted")-->
   Fは、上に*反変*された`T`場合`T`のサブタイプである`U`意味`F<U>`のサブタイプである`F<T>`サブタイプが「反転」されます）
* <!--F is *invariant* over `T` otherwise (no subtyping relation can be derived)-->
   Fは`T`以外では*不変*である（サブタイプの関係は得られない）

<!--It should be noted that covariance is *far* more common and important than contravariance in Rust.-->
共分散は、Rustの反動よりも*はるか*に一般的で重要であることに注意してください。
<!--The existence of contravariance in Rust can mostly be ignored.-->
Rustのcontravarianceの存在は、ほとんど無視することができます。

<!--Some important variances (which we will explain in detail below):-->
いくつかの重要な差異（以下で詳しく説明します）：

* <!--`&'a T` is covariant over `'a` and `T` (as is `*const T` by metaphor)-->
   `&'a T`は`'a`と`T`上で共変する（metaphorによって`*const T`同じように）
* <!--`&'a mut T` is covariant over `'a` but invariant over `T`-->
   `&'a mut T`は共変で`'a`が、`T`に対しては不変である
* <!--`fn(T) -> U` is **contra** variant over `T`, but covariant over `U`-->
   `fn(T) -> U`は`T`よりも**反対の**形であるが、`U`
* <!--`Box`, `Vec`, and all other collections are covariant over the types of their contents-->
   `Box`、 `Vec`、および他のすべてのコレクションは、その内容のタイプに対して共変です
* <!--`UnsafeCell<T>`, `Cell<T>`, `RefCell<T>`, `Mutex<T>` and all other interior mutability types are invariant over T (as is `*mut T` by metaphor)-->
   `UnsafeCell<T>`、 `Cell<T>`、 `RefCell<T>`、 `Mutex<T>`および他のすべての内部の可変型は、Tを超えて不変である（メタ`*mut T`によって`*mut T`である）

<!--To understand why these variances are correct and desirable, we will consider several examples.-->
これらの差異が正しい理由と望ましい理由を理解するために、いくつかの例を検討します。

<!--We have already covered why `&'a T` should be covariant over `'a` when introducing subtyping: it's desirable to be able to pass longer-lived things where shorter-lived things are needed.-->
我々はすでにサブタイピングを導入`'a`ときに`&'a T`が共変型でなければならない理由について議論しました。より短命なものが必要な場合には長命のものを渡すことが望ましいです。

<!--Similar reasoning applies to why it should be covariant over T: it's reasonable to be able to pass `&&'static str` where an `&&'a str` is expected.-->
同様の推論は、なぜそれがTよりも共変でなければならないかにも当てはまり`&&'static str`。 `&&'a str`が期待される場所で`&&'static str`を渡すことは合理的です。
<!--The additional level of indirection doesn't change the desire to be able to pass longer lived things where shorter lived things are expected.-->
付加的な間接的なレベルは、より短い生存物が期待されるより長い生存物を通過させたいという欲求を変えない。

<!--However this logic doesn't apply to `&mut`.-->
しかし、このロジックは`&mut`は適用されません。
<!--To see why `&mut` should be invariant over T, consider the following code:-->
`&mut`がTに対して不変でなければならない理由を調べるには、次のコードを考えてみましょう：

```rust,ignore
fn overwrite<T: Copy>(input: &mut T, new: &mut T) {
    *input = *new;
}

fn main() {
    let mut forever_str: &'static str = "hello";
    {
        let string = String::from("world");
        overwrite(&mut forever_str, &mut &*string);
    }
#    // Oops, printing free'd memory
    // メモリの空き領域を印刷しています
    println!("{}", forever_str);
}
```

<!--The signature of `overwrite` is clearly valid: it takes mutable references to two values of the same type, and overwrites one with the other.-->
`overwrite`の署名は明らかに有効です。同じ型の2つの値への参照を変更し、一方を他方に上書きします。

<!--But, if `&mut T` was covariant over T, then `&mut &'static str` would be a subtype of `&mut &'a str`, since `&'static str` is a subtype of `&'a str`.-->
しかし、`&mut T`がTに対して共変すると、`&mut &'static str`は`&mut &'a str`のサブタイプになり`&'a str`。なぜなら`&'static str`は`&'static str`のサブタイプです。
<!--Therefore the lifetime of `forever_str` would successfully be "shrunk"down to the shorter lifetime of `string`, and `overwrite` would be called successfully.-->
したがって、`forever_str`有効期間は`string`寿命が短くなるまで「縮小」され、`overwrite`は正常に呼び出されます。
<!--`string` would subsequently be dropped, and `forever_str` would point to freed memory when we print it!-->
`string`はその後削除され、`forever_str`は解放されたメモリを指します。
<!--Therefore `&mut` should be invariant.-->
したがって、`&mut`は不変でなければなりません。

<!--This is the general theme of variance vs invariance: if variance would allow you to store a short-lived value in a longer-lived slot, then invariance must be used.-->
これは、分散と不変性の一般的なテーマです。分散を使用すると長命の値を短命のスロットに保存できる場合は、不変量を使用する必要があります。

<!--More generally, the soundness of subtyping and variance is based on the idea that its ok to forget details, but with mutable references there's always someone (the original value being referenced) that remembers the forgotten details and will assume that those details haven't changed.-->
より一般的には、サブタイプ化と分散の健全性は、その細かいことを忘れてしまうという考えに基づいていますが、変更可能な参照では、忘れられた細部を覚えている人物（元の値が参照されます）。
<!--If we do something to invalidate those details, the original location can behave unsoundly.-->
これらの細部を無効にするために何かを行うと、元の場所は不運にも動作します。

<!--However it *is* sound for `&'a mut T` to be covariant over `'a`.-->
しかし、それ*は* `&'a mut T`が共変する`'a`ために`&'a mut T`。
<!--The key difference between `'a` and T is that `'a` is a property of the reference itself, while T is something the reference is borrowing.-->
`'a`とTの主な違いは、`'a`は参照自体のプロパティであり、Tは参照が借用しているものであるということです。
<!--If you change T's type, then the source still remembers the original type.-->
Tの型を変更すると、ソースは元の型を覚えています。
<!--However if you change the lifetime's type, no one but the reference knows this information, so it's fine.-->
しかし、あなたが生涯のタイプを変更した場合、リファレンス以外の誰もこの情報を知っていないので、それは問題ありません。
<!--Put another way: `&'a mut T` owns `'a`, but only *borrows* T.-->
別の言い方を`'a`、 `'a` `&'a mut T`は`'a`所有し`'a`、 `&'a mut T`を*借りる*だけです。

<!--`Box` and `Vec` are interesting cases because they're covariant, but you can definitely store values in them!-->
`Box`と`Vec`は共変なので面白いケースですが、あなたは間違いなく値を保存することができます！
<!--This is where Rust's typesystem allows it to be a bit more clever than others.-->
これは、Rustの型システムによって、他の型よりも少し巧妙なものになります。
<!--To understand why it's sound for owning containers to be covariant over their contents, we must consider the two ways in which a mutation may occur: by-value or by-reference.-->
コンテナに内容を共変させることが妥当である理由を理解するためには、バイナリまたはバイ・リファレンスという2つの方法が考えられます。

<!--If mutation is by-value, then the old location that remembers extra details is moved out of, meaning it can't use the value anymore.-->
突然変異が副作用である場合、余分な詳細を記憶している古い場所は移動されます。つまり、それ以上値を使用できません。
<!--So we simply don't need to worry about anyone remembering dangerous details.-->
だから、危険な詳細を覚えている人を心配する必要はありません。
<!--Put another way, applying subtyping when passing by-value *destroys details forever*.-->
別の言い方をすれば、by-value *を*渡すときにサブタイプを適用*すると、ディテールが永遠に破棄*され*ます*。
<!--For example, this compiles and is fine:-->
たとえば、これはコンパイルされ、うまくいきます：

```rust
fn get_box<'a>(str: &'a str) -> Box<&'a str> {
#    // String literals are `&'static str`s, but it's fine for us to
#    // "forget" this and let the caller think the string won't live that long.
    // 文字列リテラルは`&'static str`ですが、これを "忘れ"て呼び出し元が文字列がそれほど長くは生きていないと思うようにするのは良いことです。
    Box::new("hello")
}
```

<!--If mutation is by-reference, then our container is passed as `&mut Vec<T>`.-->
突然変異が参照によって行われる場合、コンテナは`&mut Vec<T>`として渡されます。
<!--But `&mut` is invariant over its value, so `&mut Vec<T>` is actually invariant over `T`.-->
しかし、`&mut`はその値に対して不変であるため、`&mut Vec<T>`は実際には`T`に対して不変である。
<!--So the fact that `Vec<T>` is covariant over `T` doesn't matter at all when mutating by-reference.-->
だから、という事実`Vec<T>`オーバー共変である`T`参照による変異ときは全く関係ありません。

<!--But being covariant still allows `Box` and `Vec` to be weakened when shared immutably.-->
しかし、共変のままであれば、`Box`と`Vec`は不変に共有されると弱体化することができます。
<!--So you can pass a `&Vec<&'static str>` where a `&Vec<&'a str>` is expected.-->
したがって、`&Vec<&'static str>`が必要`&Vec<&'static str>`を渡すことができ`&Vec<&'a str>`。

<!--The invariance of the cell types can be seen as follows: `&` is like an `&mut` for a cell, because you can still store values in them through an `&`.-->
細胞種の不変性は、以下のように見ることができます： `&`のようです`&mut`それでも介してそれらの値を格納できるので、セルの`&`。
<!--Therefore cells must be invariant to avoid lifetime smuggling.-->
したがって、セルは生涯の密輸を避けるために不変でなければならない。

<!--`fn` is the most subtle case because they have mixed variance, and in fact are the only source of **contra** variance.-->
`fn`は分散が混じっており、実際には**コントラ**分散の唯一の原因であるため、最も微妙なケースです。
<!--To see why `fn(T) -> U` should be contravariant over T, consider the following function signature:-->
なぜ、`fn(T) -> U`がTに対して反変であるべきかを知るために、以下の関数シグネチャを考えてみよう。

```rust,ignore
#// 'a is derived from some parent scope
//  'aは親スコープから派生したものです
fn foo(&'a str) -> usize;
```

<!--This signature claims that it can handle any `&str` that lives at least as long as `'a`.-->
この署名は、少なくとも`'a`同じ長さ`'a`すべての`&str`を処理できることを主張してい`&str`。
<!--Now if this signature was **co** variant over `&'a str`, that would mean-->
今、この署名が`&'a str` **共**変種であった場合、それは

```rust,ignore
fn foo(&'static str) -> usize;
```

<!--could be provided in its place, as it would be a subtype.-->
それがサブタイプであるため、その場所に提供することができる。
<!--However this function has a stronger requirement: it says that it can only handle `&'static str` s, and nothing else.-->
しかし、この関数はより強力な要件を持っています：それは`&'static str`だけを扱うことができ、他には何もありません。
<!--Giving `&'a str` s to it would be unsound, as it's free to assume that what it's given lives forever.-->
寄付`&'a str`、それが永遠の命を与えられているものと仮定して自由だとしてそれにSは、不健全でしょう。
<!--Therefore functions definitely shouldn't be **co** variant over their arguments.-->
そのための機能は、間違いなくその引数を超える**コ**バリアントであってはなりません。

<!--However if we flip it around and use **contra** variance, it *does* work!-->
私たちは周りにそれを反転し、**コントラ**分散を使用している場合しかし、それは動作*しません*！
<!--If something expects a function which can handle strings that live forever, it makes perfect sense to instead provide a function that can handle strings that live for *less* than forever.-->
何かが永遠に生きる文字列を扱うことができると期待しているのであれば、永遠より*少ない*文字列を処理できる関数を提供するのが理にかなっています。
<!--So-->
そう

```rust,ignore
fn foo(&'a str) -> usize;
```

<!--can be passed where-->
どこに渡すことができます

```rust,ignore
fn foo(&'static str) -> usize;
```

<!--is expected.-->
期待されています。

<!--To see why `fn(T) -> U` should be **co** variant over U, consider the following function signature:-->
なぜ`fn(T) -> U`上の**共**変であるべきかを知るために、以下の関数シグネチャを考えてみよう。

```rust,ignore
#// 'a is derived from some parent scope
//  'aは親スコープから派生したものです
fn foo(usize) -> &'a str;
```

<!--This signature claims that it will return something that outlives `'a`.-->
この署名は、それが生存するものを返すと主張して`'a`。
<!--It is therefore completely reasonable to provide-->
したがって、

```rust,ignore
fn foo(usize) -> &'static str;
```

<!--in its place, as it does indeed return things that outlive `'a`.-->
それは確かに物事を返さないように、その場所に、より長生きいます`'a`。
<!--Therefore functions are covariant over their return type.-->
したがって、関数はその戻り型に対して共変です。

<!--`*const` has the exact same semantics as `&`, so variance follows.-->
`*const`は`&`と全く同じセマンティクスを持っているので、分散が続く。
<!--`*mut` on the other hand can dereference to an `&mut` whether shared or not, so it is marked as invariant just like cells.-->
一方、`*mut`は、共有されているかどうかにかかわらず、`&mut`逆参照することができるので、セルと同じように不変としてマークされます。

<!--This is all well and good for the types the standard library provides, but how is variance determined for type that *you* define?-->
これは、標準ライブラリが提供する型のすべてに適してい*ますが、*定義する型に対してどのように分散が決定されますか？
<!--A struct, informally speaking, inherits the variance of its fields.-->
構造体は非形式的に言えば、そのフィールドの分散を継承します。
<!--If a struct `Foo` has a generic argument `A` that is used in a field `a`, then Foo's variance over `A` is exactly `a` 's variance.-->
構造体場合`Foo`、一般的な引数がある`A`分野で使用され、その後、オーバーフーの差異`a` `A`正確であるの分散。`a`
<!--However if `A` is used in multiple fields:-->
ただし、`A`が複数のフィールドで使用されている場合は、

* <!--If all uses of A are covariant, then Foo is covariant over A-->
   Aのすべての用途が共変である場合、FooはAに対して共変する
* <!--If all uses of A are contravariant, then Foo is contravariant over A-->
   Aのすべての使用が反変である場合、FooはAに対して反変です
* <!--Otherwise, Foo is invariant over A-->
   さもなければ、FooはAに対して不変である

```rust
use std::cell::Cell;

struct Foo<'a, 'b, A: 'a, B: 'b, C, D, E, F, G, H, In, Out, Mixed> {
#//    a: &'a A,     // covariant over 'a and A
    a: &'a A,     //  AとAの共変量
#//    b: &'b mut B, // covariant over 'b and invariant over B
    b: &'b mut B, //  B上の共変およびB上の不変

#//    c: *const C,  // covariant over C
    c: *const C,  //  Cとの共変量
#//    d: *mut D,    // invariant over D
    d: *mut D,    // 不変のD

#//    e: E,         // covariant over E
    e: E,         //  E上の共変量
#//    f: Vec<F>,    // covariant over F
    f: Vec<F>,    //  F上の共変量
#//    g: Cell<G>,   // invariant over G
    g: Cell<G>,   // 不変のG

#//    h1: H,        // would also be variant over H except...
    h1: H,        // を除いてH以上の変形も...
#//    h2: Cell<H>,  // invariant over H, because invariance wins all conflicts
    h2: Cell<H>,  // 不変性がすべての競合を勝ち取るので、Hより不変である

#//    i: fn(In) -> Out,       // contravariant over In, covariant over Out
    i: fn(In) -> Out,       //  In上の反変、Out上の共変

#//    k1: fn(Mixed) -> usize, // would be contravariant over Mixed except..
    k1: fn(Mixed) -> usize, // ミックスド以外では反乱的であろう。
#//    k2: Mixed,              // invariant over Mixed, because invariance wins all conflicts
    k2: Mixed,              // 不変がすべての競合を勝ち取るため、混合よりも不変
}
```
