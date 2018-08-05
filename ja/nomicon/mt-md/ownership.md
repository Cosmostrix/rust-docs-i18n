# <!--Ownership and Lifetimes--> 所有権と生涯

<!--Ownership is the breakout feature of Rust.-->
所有権はRustのブレークアウト機能です。
<!--It allows Rust to be completely memory-safe and efficient, while avoiding garbage collection.-->
これはガーベッジコレクションを回避しながら、Rustを完全にメモリ安全かつ効率的にすることを可能にします。
<!--Before getting into the ownership system in detail, we will consider the motivation of this design.-->
オーナーシップシステムを詳細に説明する前に、このデザインの動機付けについて検討します。

<!--We will assume that you accept that garbage collection (GC) is not always an optimal solution, and that it is desirable to manually manage memory in some contexts.-->
ガベージコレクション（GC）は必ずしも最適な解決策ではないということを承知しており、いくつかの状況で手動でメモリを管理することが望ましいと考えています。
<!--If you do not accept this, might I interest you in a different language?-->
これを受け入れない場合は、別の言語であなたに興味がありますか？

<!--Regardless of your feelings on GC, it is pretty clearly a *massive* boon to making code safe.-->
かかわらず、GC上のあなたの気持ちの、それはかなり明確にコードを安全に作るための*大規模な*恩恵です。
<!--You never have to worry about things going away *too soon* (although whether you still wanted to be pointing at that thing is a different issue...).-->
*あまりにも早く*消え去ることについて心配する必要はありません（あなたがまだそのことを指し示したがっているかどうかは別の問題です...）。
<!--This is a pervasive problem that C and C++ programs need to deal with.-->
これは、CおよびC ++プログラムが処理する必要がある普及した問題です。
<!--Consider this simple mistake that all of us who have used a non-GC'd language have made at one point:-->
GCではない言語を使用していた私たち全員が一度に作ったという単純な誤りを考えてみましょう。

```rust,ignore
fn as_str(data: &u32) -> &str {
#    // compute the string
    // 文字列を計算する
    let s = format!("{}", data);

#    // OH NO! We returned a reference to something that
#    // exists only in this function!
#    // Dangling pointer! Use after free! Alas!
#    // (this does not compile in Rust)
    // あらいやだ！この関数だけに存在するものへの参照を返しました！ぶら下がっているポインタ！無料で使用してください！ああ！（これはRustではコンパイルされません）
    &s
}
```

<!--This is exactly what Rust's ownership system was built to solve.-->
これはまさしくRustの所有システムが解決するために造られたものです。
<!--Rust knows the scope in which the `&s` lives, and as such can prevent it from escaping.-->
錆がで範囲を知っている`&s`の生活を、そのように逃げることを防ぐことができます。
<!--However this is a simple case that even a C compiler could plausibly catch.-->
しかし、これは単純なケースでも、Cコンパイラでさえもっともらしいものです。
<!--Things get more complicated as code gets bigger and pointers get fed through various functions.-->
コードが大きくなり、ポインタがさまざまな機能を提供されるにつれ、状況はより複雑になります。
<!--Eventually, a C compiler will fall down and won't be able to perform sufficient escape analysis to prove your code unsound.-->
最終的には、Cコンパイラがダウンし、あなたのコードが不健全であることを証明するのに十分なエスケープ解析を実行することができなくなります。
<!--It will consequently be forced to accept your program on the assumption that it is correct.-->
その結果、それは正しいことを前提にしてプログラムを受け入れることが強制されます。

<!--This will never happen to Rust.-->
これは決して錆には起こりません。
<!--It's up to the programmer to prove to the compiler that everything is sound.-->
コンパイラがすべてが健全であることを証明するのはプログラマの責任です。

<!--Of course, Rust's story around ownership is much more complicated than just verifying that references don't escape the scope of their referent.-->
もちろん、所有権に関するRustの話は、参考文献が参照対象から逸脱しないことを検証するだけではなく、はるかに複雑です。
<!--That's because ensuring pointers are always valid is much more complicated than this.-->
これは、ポインタを常に有効にすることは、これよりはるかに複雑であるためです。
<!--For instance in this code,-->
たとえば、このコードでは、

```rust,ignore
let mut data = vec![1, 2, 3];
#// get an internal reference
// 内部参照を取得する
let x = &data[0];

#// OH NO! `push` causes the backing storage of `data` to be reallocated.
#// Dangling pointer! Use after free! Alas!
#// (this does not compile in Rust)
// あらいやだ！ `push`と、`data`のバッキングストレージが再割り当てされます。ぶら下がっているポインタ！無料で使用してください！ああ！（これはRustではコンパイルされません）
data.push(4);

println!("{}", x);
```

<!--naive scope analysis would be insufficient to prevent this bug, because `data` does in fact live as long as we needed.-->
このバグを防ぐには、単純なスコープ分析では不十分です。なぜなら、実際には`data`は必要なだけ長く生きているからです。
<!--However it was *changed* while we had a reference into it.-->
しかし、それが参照されている間に*変更さ*れました。
<!--This is why Rust requires any references to freeze the referent and its owners.-->
これは、Rustが参照対象とその所有者をフリーズするための参照を必要とする理由です。

