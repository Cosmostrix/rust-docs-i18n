# <!--What Unsafe Rust Can Do--> 不安全な錆が何をすることができるか

<!--The only things that are different in Unsafe Rust are that you can:-->
Unsafe Rustと異なる点は、次のことができることです。

* <!--Dereference raw pointers-->
   未処理のポインタを参照解除する
* <!--Call `unsafe` functions (including C functions, compiler intrinsics, and the raw allocator)-->
   `unsafe`関数（C関数、コンパイラ組み込み関数、生のアロケータなど）を呼び出す
* <!--Implement `unsafe` traits-->
   `unsafe`特性を実装する
* <!--Mutate statics-->
   突然変異

<!--That's it.-->
それでおしまい。
<!--The reason these operations are relegated to Unsafe is that misusing any of these things will cause the ever dreaded Undefined Behavior.-->
これらの操作がUnsafeに委ねられた理由は、これらの操作のいずれかを悪用すると、恐ろしい未定義の動作が発生するからです。
<!--Invoking Undefined Behavior gives the compiler full rights to do arbitrarily bad things to your program.-->
定義されていない動作を呼び出すと、プログラムに任意に悪いことをするための完全な権利がコンパイラに与えられます。
<!--You definitely *should not* invoke Undefined Behavior.-->
あなたは間違いなく未定義の振る舞いを呼び出す*べきではありません*。

<!--Unlike C, Undefined Behavior is pretty limited in scope in Rust.-->
Cとは異なり、Undefined BehaviorはRustの範囲がかなり制限されています。
<!--All the core language cares about is preventing the following things:-->
すべてのコア言語の心配は、次のことを防ぐことです：

* <!--Dereferencing null, dangling, or unaligned pointers-->
   NULL、ダングリング、またはアラインされていないポインタを参照解除する
* <!--Reading [uninitialized memory][]-->
   [初期化されていないメモリの][]読み取り
* <!--Breaking the [pointer aliasing rules][]-->
   [ポインタエイリアシングルールを][]破る
* <!--Producing invalid primitive values:-->
   無効なプリミティブ値を生成する：
    * <!--dangling/null references-->
       ダングリング/ヌル参照
    * <!--a `bool` that isn't 0 or 1-->
       0または1ではない`bool`
    * <!--an undefined `enum` discriminant-->
       未定義の`enum`判別式
    * <!--a `char` outside the ranges [0x0, 0xD7FF] and [0xE000, 0x10FFFF]-->
       `char`範囲外の[0x0, 0xD7FF]と[0xE000, 0x10FFFF]
    * <!--A non-utf8 `str`-->
       非utf8 `str`
* <!--Unwinding into another language-->
   他の言語に巻き戻す
* <!--Causing a [data race][race]-->
   [データ競合の][race]原因

<!--That's it.-->
それでおしまい。
<!--That's all the causes of Undefined Behavior baked into Rust.-->
これは、Rustに焼き付けられたUndefined Behaviorのすべての原因です。
<!--Of course, unsafe functions and traits are free to declare arbitrary other constraints that a program must maintain to avoid Undefined Behavior.-->
もちろん、安全でない関数や特性は、プログラムが未定義の動作を避けるために保持しなければならない任意の他の制約を自由に宣言することができます。
<!--For instance, the allocator APIs declare that deallocating unallocated memory is Undefined Behavior.-->
例えば、アロケータAPIは、未割り当てメモリを解放することが未定義ビヘイビアであることを宣言する。

<!--However, violations of these constraints generally will just transitively lead to one of the above problems.-->
しかし、これらの制約に違反すると、一般的には過渡的に上記の問題の1つにつながります。
<!--Some additional constraints may also derive from compiler intrinsics that make special assumptions about how code can be optimized.-->
いくつかの追加の制約は、コードを最適化する方法について特別な前提を持つコンパイラ組み込み関数から派生することもあります。
<!--For instance, Vec and Box make use of intrinsics that require their pointers to be non-null at all times.-->
たとえば、VecとBoxは、ポインタが常にnullでないようにする組み込み関数を使用します。

<!--Rust is otherwise quite permissive with respect to other dubious operations.-->
そうでなければ、錆は他の怪しげな操作に関してかなり許容的です。
<!--Rust considers it "safe"to:-->
錆はそれを「安全」と考えます：

* <!--Deadlock-->
   デッドロック
* <!--Have a [race condition][race]-->
   [競争状態にある][race]
* <!--Leak memory-->
   リークメモリ
* <!--Fail to call destructors-->
   デストラクタの呼び出しに失敗しました
* <!--Overflow integers-->
   オーバーフロー整数
* <!--Abort the program-->
   プログラムを中止する
* <!--Delete the production database-->
   運用データベースを削除する

<!--However any program that actually manages to do such a thing is *probably* incorrect.-->
しかし実際にそのようなことをするプログラムは*おそらく*間違っている*でしょう*。
<!--Rust provides lots of tools to make these things rare, but these problems are considered impractical to categorically prevent.-->
錆はこれらのことを稀にするための多くのツールを提供しますが、これらの問題は不可避的に防止するには実用的ではないと考えられています。

<!--[pointer aliasing rules]: references.html
 [uninitialized memory]: uninitialized.html
 [race]: races.html
-->
[pointer aliasing rules]: references.html
 [uninitialized memory]: uninitialized.html
 [race]: races.html

