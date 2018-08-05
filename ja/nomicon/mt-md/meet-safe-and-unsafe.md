# <!--Meet Safe and Unsafe--> 安全で安心して会う

<!--!-->
！
<!--[safe and unsafe](img/safeandunsafe.svg)-->
[安全で危険な](img/safeandunsafe.svg)

<!--It would be great to not have to worry about low-level implementation details.-->
低レベルの実装の詳細について心配する必要はありません。
<!--Who could possibly care how much space the empty tuple occupies?-->
空のタプルがどのくらいのスペースを占めているのか誰が気にすることができますか？
<!--Sadly, it sometimes matters and we need to worry about it.-->
残念ながら、それは時には重要であり、私たちはそれについて心配する必要があります。
<!--The most common reason developers start to care about implementation details is performance, but more importantly, these details can become a matter of correctness when interfacing directly with hardware, operating systems, or other languages.-->
開発者が実装の詳細を気にかけ始めている最も一般的な理由はパフォーマンスですが、重要なことは、ハードウェア、オペレーティングシステム、または他の言語と直接接続するときに、これらの詳細が正確になることです。

<!--When implementation details start to matter in a safe programming language, programmers usually have three options:-->
実装の詳細が安全なプログラミング言語で問題になると、プログラマは通常3つの選択肢があります。

* <!--fiddle with the code to encourage the compiler/runtime to perform an optimization-->
   コンパイラ/ランタイムが最適化を実行するようにするためのコード
* <!--adopt a more unidiomatic or cumbersome design to get the desired implementation-->
   望ましい実装を得るためによりユニダイマティカルで面倒な設計を採用する
* <!--rewrite the implementation in a language that lets you deal with those details-->
   それらの詳細を処理できる言語で実装を書き直す

<!--For that last option, the language programmers tend to use is *C*.-->
その最後のオプションのために、言語プログラマは*C*を使う傾向があります。
<!--This is often necessary to interface with systems that only declare a C interface.-->
これは、多くの場合、Cインタフェースのみを宣言するシステムとのインタフェースに必要です。

<!--Unfortunately, C is incredibly unsafe to use (sometimes for good reason), and this unsafety is magnified when trying to interoperate with another language.-->
残念ながら、Cは（時には正当な理由で）使用するのが信じられないほど安全ではなく、この安全性は他の言語と相互運用しようとすると拡大されます。
<!--Care must be taken to ensure C and the other language agree on what's happening, and that they don't step on each other's toes.-->
Cと他の言語が何が起こっているかに同意し、互いのつま先を踏まないように注意する必要があります。

<!--So what does this have to do with Rust?-->
それでは、これはRustと何が関係していますか？

<!--Well, unlike C, Rust is a safe programming language.-->
Cとは異なり、Rustは安全なプログラミング言語です。

<!--But, like C, Rust is an unsafe programming language.-->
しかし、Cのように、Rustは安全でないプログラミング言語です。

<!--More accurately, Rust *contains* both a safe and unsafe programming language.-->
より正確に言えば、Rust *は*安全なプログラミング言語と安全でないプログラミング言語の両方を*含んで*います。

<!--Rust can be thought of as a combination of two programming languages: *Safe Rust* and *Unsafe Rust*.-->
*安全な錆*と*安全ではない錆*：錆は2つのプログラミング言語を組み合わせたものと考えることができます。
<!--Conveniently, these names mean exactly what they say: Safe Rust is Safe.-->
便利なことに、これらの名前はまさに彼らが言うことを意味します：安全な錆は安全です。
<!--Unsafe Rust is, well, not.-->
安全でない錆は、まあ、そうではありません。
<!--In fact, Unsafe Rust lets us do some *really* unsafe things.-->
事実、安全でない錆は、私たちに*本当に*危険な事をしてくれます。
<!--Things the Rust authors will implore you not to do, but we'll do anyway.-->
物事は、錆の作家はあなたがしないことを懇願しますが、とにかくやっていきます。

<!--Safe Rust is the *true* Rust programming language.-->
Safe Rustは*真の* Rustプログラミング言語です。
<!--If all you do is write Safe Rust, you will never have to worry about type-safety or memory-safety.-->
あなたがするすべてがSafe Rustと書かれていれば、型安全性やメモリ安全性を心配する必要はありません。
<!--You will never endure a dangling pointer, a use-after-free, or any other kind of Undefined Behavior.-->
ぶら下がったポインタ、使用後フリー、または他の種類の未定義ビヘイビアには決して耐えられません。

<!--The standard library also gives you enough utilities out of the box that you'll be able to write high-performance applications and libraries in pure idiomatic Safe Rust.-->
標準ライブラリでは、すぐに使えるユーティリティが用意されているため、高性能アプリケーションやライブラリを純粋な慣用的Safe Rustで記述することができます。

<!--But maybe you want to talk to another language.-->
しかし、多分あなたは別の言語と話したいと思うかもしれません。
<!--Maybe you're writing a low-level abstraction not exposed by the standard library.-->
たぶん、あなたは標準ライブラリによって公開されていない低レベルの抽象化を書いているでしょう。
<!--Maybe you're *writing* the standard library (which is written entirely in Rust).-->
たぶんあなたは標準的なライブラリ（これは完全にRustで書かれています）を*書い*ています。
<!--Maybe you need to do something the type-system doesn't understand and just *frob some dang bits*.-->
たぶん、あなたは型システムが理解できないことをして、*ちょっとしたダンスを覚えるしか*ないでしょう。
<!--Maybe you need Unsafe Rust.-->
多分あなたは安全でない錆が必要でしょう。

<!--Unsafe Rust is exactly like Safe Rust with all the same rules and semantics.-->
安全でない錆は、まったく同じルールと意味を持つ安全な錆とまったく同じです。
<!--It just lets you do some *extra* things that are Definitely Not Safe (which we will define in the next section).-->
これは、あなたが絶対に安全でないいくつかの*余分*なことを行うことができます（次のセクションで定義します）。

<!--The value of this separation is that we gain the benefits of using an unsafe language like C — low level control over implementation details — without most of the problems that come with trying to integrate it with a completely different safe language.-->
この分離の価値は、完全に異なる安全な言語との統合に伴う問題の大部分を除いて、Cのような安全でない言語を使用する利点を得ることです。

<!--There are still some problems — most notably, we must become aware of properties that the type system assumes and audit them in any code that interacts with Unsafe Rust.-->
いくつかの問題が残っています。最も重要なことは、タイプシステムが想定しているプロパティを認識し、Unsafe Rustと相互作用するコードでそれらを監査する必要があることです。
<!--That's the purpose of this book: to teach you about these assumptions and how to manage them.-->
それは、この本の目的です：これらの前提とそれらを管理する方法について教えてください。
