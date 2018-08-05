# <!--Unbounded Lifetimes--> 無限の生涯

<!--Unsafe code can often end up producing references or lifetimes out of thin air.-->
安全でないコードは、しばしば細い空気から参照や生涯を生み出すことになります。
<!--Such lifetimes come into the world as *unbounded*.-->
そのような生涯は*無限に*世界に生まれます。
<!--The most common source of this is dereferencing a raw pointer, which produces a reference with an unbounded lifetime.-->
これの最も一般的な原因は、無限の寿命を持つ参照を生成する生ポインタを逆参照することです。
<!--Such a lifetime becomes as big as context demands.-->
そのような生涯は文脈の要求と同じくらい大きくなります。
<!--This is in fact more powerful than simply becoming `'static`, because for instance `&'static &'a T` will fail to typecheck, but the unbound lifetime will perfectly mold into `&'a &'a T` as needed.-->
これは、実際には`'static`になるよりも強力です。なぜなら、`&'static &'a T`は型チェックに失敗するからです。しかし、未結合の生涯は必要に応じ`&'a &'a T`に完全に型どっていくでしょう。
<!--However for most intents and purposes, such an unbounded lifetime can be regarded as `'static`.-->
しかし、ほとんどの意図と目的のために、そのような無限の生涯は`'static`とみなすことができ`'static`。

<!--Almost no reference is `'static`, so this is probably wrong.-->
ほとんどの参考文献は`'static` 」なので、これはおそらく間違っています。
<!--`transmute` and `transmute_copy` are the two other primary offenders.-->
`transmute`と`transmute_copy`は他の2つの主要な犯罪者です。
<!--One should endeavor to bound an unbounded lifetime as quickly as possible, especially across function boundaries.-->
特に、関数の境界を越えてできるだけ早く無限の生涯を縛るように努力すべきである。

<!--Given a function, any output lifetimes that don't derive from inputs are unbounded.-->
ある関数が与えられると、入力から派生しない出力寿命は無限になります。
<!--For instance:-->
例えば：

```rust,ignore
fn get_str<'a>() -> &'a str;
```

<!--will produce an `&str` with an unbounded lifetime.-->
無限の寿命で`&str`を生成し`&str`。
<!--The easiest way to avoid unbounded lifetimes is to use lifetime elision at the function boundary.-->
無限の寿命を避ける最も簡単な方法は、関数の境界で寿命elisionを使用することです。
<!--If an output lifetime is elided, then it *must* be bounded by an input lifetime.-->
出力ライフタイムが省略された場合は、入力ライフタイムによって制限されている*必要*が*あり*ます。
<!--Of course it might be bounded by the *wrong* lifetime, but this will usually just cause a compiler error, rather than allow memory safety to be trivially violated.-->
もちろん、*間違った*寿命に縛られて*いる*かもしれませんが、メモリの安全を犠牲にするのではなく、通常コンパイラエラーが発生します。

<!--Within a function, bounding lifetimes is more error-prone.-->
関数内では、バウンディング・ライフタイムはエラーが発生しやすくなります。
<!--The safest and easiest way to bound a lifetime is to return it from a function with a bound lifetime.-->
生涯をバインドする最も安全かつ簡単な方法は、バインドされた存続時間を持つ関数からそれを返すことです。
<!--However if this is unacceptable, the reference can be placed in a location with a specific lifetime.-->
しかし、これが許容できない場合、参照は特定の有効期間のある場所に置くことができます。
<!--Unfortunately it's impossible to name all lifetimes involved in a function.-->
残念ながら、機能に関わるすべての生涯を命名することは不可能です。

