# <!--Lifetimes--> 生涯

<!--Rust enforces these rules through *lifetimes*.-->
錆はこれらの規則を*生涯*を通して強制する。
<!--Lifetimes are effectively just names for scopes somewhere in the program.-->
生涯は事実上、プログラムのどこかのスコープの名前です。
<!--Each reference, and anything that contains a reference, is tagged with a lifetime specifying the scope it's valid for.-->
各参照、および参照を含むものには、それが有効である有効範囲を指定する存続期間が付けられます。

<!--Within a function body, Rust generally doesn't let you explicitly name the lifetimes involved.-->
関数本体の中で、Rustは通常、関連する存続期間を明示的に指定することはできません。
<!--This is because it's generally not really necessary to talk about lifetimes in a local context;-->
なぜなら、一般的には、ローカルな状況での生涯について話す必要はないからです。
<!--Rust has all the information and can work out everything as optimally as possible.-->
錆はすべての情報を持ち、可能な限り最適にすべてを動かすことができます。
<!--Many anonymous scopes and temporaries that you would otherwise have to write are often introduced to make your code Just Work.-->
多くの場合、あなたが書かなければならない多くの匿名スコープと一時的なものが、あなたのコードをJust Workにするために導入されています。

<!--However once you cross the function boundary, you need to start talking about lifetimes.-->
しかし、一度関数の境界を越えると、生涯について話を始める必要があります。
<!--Lifetimes are denoted with an apostrophe: `'a`, `'static`.-->
生涯はアポストロフィで示されます： `'a` `'static`。
<!--To dip our toes with lifetimes, we're going to pretend that we're actually allowed to label scopes with lifetimes, and desugar the examples from the start of this chapter.-->
私たちの足元に生涯を浸すために、実際にスコープに生涯を付けることが実際に許されているふりをして、この章の最初から例を除外します。

<!--Originally, our examples made use of *aggressive* sugar --high fructose corn syrup even --around scopes and lifetimes, because writing everything out explicitly is *extremely noisy*.-->
もともと、私たちの例は、明示的にすべてを書くことは*非常に騒々しい*ので、*積極的な*砂糖 -高果糖コーンシロップをスコープや生涯にわたって使用しました。
<!--All Rust code relies on aggressive inference and elision of "obvious"things.-->
すべての錆のコードは積極的な推論と "明白な"ものの逃避に頼っています。

<!--One particularly interesting piece of sugar is that each `let` statement implicitly introduces a scope.-->
1つの特に興味深いのは、各`let`ステートメントが暗黙的にスコープを導入していることです。
<!--For the most part, this doesn't really matter.-->
ほとんどの場合、これは問題ではありません。
<!--However it does matter for variables that refer to each other.-->
しかし、お互いを参照する変数については重要です。
<!--As a simple example, let's completely desugar this simple piece of Rust code:-->
簡単な例として、この簡単な錆コードを完全に解説しましょう：

```rust
let x = 0;
let y = &x;
let z = &y;
```

<!--The borrow checker always tries to minimize the extent of a lifetime, so it will likely desugar to the following:-->
借用チェッカーは、常に生涯の範囲を最小限にしようとします。したがって、次のように考えるのは難しいでしょう：

```rust,ignore
#// NOTE: `'a: {` and `&'b x` is not valid syntax!
// 注： `'a: {` and `&'bx`は有効な構文ではありません！
'a: {
    let x: i32 = 0;
    'b: {
#        // lifetime used is 'b because that's good enough.
        // 使用されている生涯は「b」で十分です。
        let y: &'b i32 = &'b x;
        'c: {
#            // ditto on 'c
            // 同上
            let z: &'c &'b i32 = &'c y;
        }
    }
}
```

<!--Wow.-->
ワオ。
<!--That's... awful.-->
それはひどい。
<!--Let's all take a moment to thank Rust for making this easier.-->
これをもっと簡単にしてくれたRustに感謝の意を表します。

<!--Actually passing references to outer scopes will cause Rust to infer a larger lifetime:-->
実際に外部スコープへの参照を渡すと、Rustはより長い寿命を推測します：

```rust
let x = 0;
let z;
let y = &x;
z = y;
```

```rust,ignore
'a: {
    let x: i32 = 0;
    'b: {
        let z: &'b i32;
        'c: {
#            // Must use 'b here because this reference is
#            // being passed to that scope.
            // この参照はそのスコープに渡されているため、ここでは「b」を使用する必要があります。
            let y: &'b i32 = &'b x;
            z = y;
        }
    }
}
```



# <!--Example: references that outlive referents--> 例：レフェレントを凌駕するレファレンス

<!--Alright, let's look at some of those examples from before:-->
さて、これまでのいくつかの例を見てみましょう：

```rust,ignore
fn as_str(data: &u32) -> &str {
    let s = format!("{}", data);
    &s
}
```

<!--desugars to:-->
desugarsに：

```rust,ignore
fn as_str<'a>(data: &'a u32) -> &'a str {
    'b: {
        let s = format!("{}", data);
        return &'a s;
    }
}
```

<!--This signature of `as_str` takes a reference to a u32 with *some* lifetime, and promises that it can produce a reference to a str that can live *just as long*.-->
`as_str`このシグネチャは、*いくつかの*生存時間を持つu32への参照をとり、*ちょうど長く続く*ことができるstrへの参照を生成できることを約束します。
<!--Already we can see why this signature might be trouble.-->
すでにこの署名が問題になっている理由がわかります。
<!--That basically implies that we're going to find a str somewhere in the scope the reference to the u32 originated in, or somewhere *even earlier*.-->
これは、基本的には、u32への参照が起源のスコープのどこかにあるか、*それより前の*どこかでstrを見つけることを意味します。
<!--That's a bit of a tall order.-->
それはちょっとした秩序です。

<!--We then proceed to compute the string `s`, and return a reference to it.-->
その後、文字列`s`を計算し、その文字列への参照を返します。
<!--Since the contract of our function says the reference must outlive `'a`, that's the lifetime we infer for the reference.-->
私たちの機能の契約では、リファレンスは`'a`よりも長くなければならないと言われているので、それは参照用に推測される生涯です。
<!--Unfortunately, `s` was defined in the scope `'b`, so the only way this is sound is if `'b` contains `'a` --which is clearly false since `'a` must contain the function call itself.-->
残念ながら、`s`はスコープ`'b`で定義されていたので、`'b` contains `'a` -関数呼び出し自体が含まれて`'a`必要があるため`'a`明らかにfalseです。
<!--We have therefore created a reference whose lifetime outlives its referent, which is *literally* the first thing we said that references can't do.-->
したがって、我々は、その寿命*文字通り*、我々は参照がないことを言った最初のものですその参照先を、outlives参照を作成しました。
<!--The compiler rightfully blows up in our face.-->
コンパイラは正当に私たちの顔を爆破する。

<!--To make this more clear, we can expand the example:-->
これをより明確にするために、例を拡張することができます：

```rust,ignore
fn as_str<'a>(data: &'a u32) -> &'a str {
    'b: {
        let s = format!("{}", data);
        return &'a s
    }
}

fn main() {
    'c: {
        let x: u32 = 0;
        'd: {
#            // An anonymous scope is introduced because the borrow does not
#            // need to last for the whole scope x is valid for. The return
#            // of as_str must find a str somewhere before this function
#            // call. Obviously not happening.
            // 匿名のスコープが導入された理由は、xが有効であるスコープ全体で借用を続ける必要がないからです。as_strを返すと、この関数呼び出しの前にstrが見つかるはずです。明らかに起こっていない。
            println!("{}", as_str::<'d>(&'d x));
        }
    }
}
```

<!--Shoot!-->
シュート！

<!--Of course, the right way to write this function is as follows:-->
もちろん、この関数を書く正しい方法は次のとおりです：

```rust
fn to_string(data: &u32) -> String {
    format!("{}", data)
}
```

<!--We must produce an owned value inside the function to return it!-->
それを返すには、関数内に所有された値を生成する必要があります。
<!--The only way we could have returned an `&'a str` would have been if it was in a field of the `&'a u32`, which is obviously not the case.-->
私たちが`&'a str`を返すことができる唯一の方法は、明らかにそうではない`&'a u32`分野にあったのだろう。

<!--(Actually we could have also just returned a string literal, which as a global can be considered to reside at the bottom of the stack; though this limits our implementation *just a bit*.)-->
（実際には、文字列リテラルを返すこともできました。これは、グローバルとしてはスタックの最下部にあると見なすことができますが、これでは実装が*少ししか*制限され*ません*）。





# <!--Example: aliasing a mutable reference--> 例：可変参照のエイリアシング

<!--How about the other example:-->
他の例はどうですか？

```rust,ignore
let mut data = vec![1, 2, 3];
let x = &data[0];
data.push(4);
println!("{}", x);
```

```rust,ignore
'a: {
    let mut data: Vec<i32> = vec![1, 2, 3];
    'b: {
#        // 'b is as big as we need this borrow to be
#        // (just need to get to `println!`)
        //  'bは私たちがこれを借りて必要とするほど大きく（`println!`に行く必要があるだけ`println!`）
        let x: &'b i32 = Index::index::<'b>(&'b data, 0);
        'c: {
#            // Temporary scope because we don't need the
#            // &mut to last any longer.
            // 一時的なスコープは、＆mutがそれ以上長く続く必要はないからです。
            Vec::push(&'c mut data, 4);
        }
        println!("{}", x);
    }
}
```

<!--The problem here is a bit more subtle and interesting.-->
ここの問題はもう少し微妙で面白いです。
<!--We want Rust to reject this program for the following reason: We have a live shared reference `x` to a descendant of `data` when we try to take a mutable reference to `data` to `push`.-->
私たちは、Rustに以下の理由でこのプログラムを拒否させたいと考えています。`push`する`data`への変更可能な参照を取ろうとすると、`data`子孫にライブ共有参照`x`があり`data`。
<!--This would create an aliased mutable reference, which would violate the *second* rule of references.-->
これにより、参照の*第2の*規則に違反するエイリアス化された可変参照が作成されます。

<!--However this is *not at all* how Rust reasons that this program is bad.-->
しかし、これは、このプログラムが悪いという理由の理由*で*はあり*ません*。
<!--Rust doesn't understand that `x` is a reference to a subpath of `data`.-->
Rustは`x`が`data`サブパスへの参照であることを理解していません。
<!--It doesn't understand Vec at all.-->
それはVecを全く理解していない。
<!--What it *does* see is that `x` has to live for `'b` to be printed.-->
何それは見*ないこと*ということで`x`のために生きるために持っている`'b`印刷します。
<!--The signature of `Index::index` subsequently demands that the reference we take to `data` has to survive for `'b`.-->
`Index::index`のシグネチャは、その後、我々が`data`に対して行う参照が`'b`ために生存しなければならないことを要求する。
<!--When we try to call `push`, it then sees us try to make an `&'c mut data`.-->
`push`を呼び出そうとすると、`&'c mut data`を作成しようとしてい`&'c mut data`。
<!--Rust knows that `'c` is contained within `'b`, and rejects our program because the `&'b data` must still be live!-->
Rustは`'c`が`'b`中に含まれていることを知り、`&'b data`はまだ生きていなければならないので、私たちのプログラムを拒絶します！

<!--Here we see that the lifetime system is much more coarse than the reference semantics we're actually interested in preserving.-->
ここで、生涯システムは、実際に保存に関心のある参照セマンティクスよりもはるかに粗いことがわかります。
<!--For the most part, *that's totally ok*, because it keeps us from spending all day explaining our program to the compiler.-->
ほとんどの場合、*それは完全に大丈夫です*。なぜなら、プログラムをコンパイラに説明することを一日中止めさせるからです。
<!--However it does mean that several programs that are totally correct with respect to Rust's *true* semantics are rejected because lifetimes are too dumb.-->
しかし、生涯があまりにも愚かであるため、Rustの*真の*意味論に関して完全に正しいいくつかのプログラムが拒絶されることを意味する。
