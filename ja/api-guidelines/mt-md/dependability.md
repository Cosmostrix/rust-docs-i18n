# <!--Dependability--> 信頼性


<span id="c-validate"></span><!--## Functions validate their arguments (C-VALIDATE)-->
##関数は引数を検証します（C-VALIDATE）

<!--Rust APIs do  _not_  generally follow the [robustness principle]: "be conservative in what you send; be liberal in what you accept".-->
Rust APIは _、_ 一般に、[robustness principle]に従わ _ない_ ：「送信するものを控えめにする、受け入れるものを自由にする」。

[robustness principle]: http://en.wikipedia.org/wiki/Robustness_principle

<!--Instead, Rust code should  _enforce_  the validity of input whenever practical.-->
代わりに、錆コードは実用的なときは常に入力の妥当性を _強制_ すべきです。

<!--Enforcement can be achieved through the following mechanisms (listed in order of preference).-->
施行は、以下の仕組み（優先順に記載）によって達成することができます。

### <!--Static enforcement--> 静的強制

<!--Choose an argument type that rules out bad inputs.-->
不正な入力を排除する引数型を選択します。

<!--For example, prefer-->
たとえば、prefer

```rust
fn foo(a: Ascii) { /* ... */ }
```

<!--over-->
以上

```rust
fn foo(a: u8) { /* ... */ }
```

<!--where `Ascii` is a  _wrapper_  around `u8` that guarantees the highest bit is zero;-->
どこ`Ascii`  _ラッパ_ です`u8`最上位ビットがゼロである保証します。
<!--see newtype patterns ([C-NEWTYPE]) for more details on creating typesafe wrappers.-->
型セーフラッパーの作成の詳細については、newtypeパターン（[C-NEWTYPE]）を参照してください。

<!--Static enforcement usually comes at little run-time cost: it pushes the costs to the boundaries (eg when a `u8` is first converted into an `Ascii`).-->
静的執行は通常、少しの実行時のコストで来る：それは境界にコストをプッシュ（例えばとき`u8`最初に変換さ`Ascii`）。
<!--It also catches bugs early, during compilation, rather than through run-time failures.-->
また、実行時の失敗ではなく、コンパイル時に早期にバグを検出します。

<!--On the other hand, some properties are difficult or impossible to express using types.-->
一方、いくつかのプロパティは型を使って表現することが困難または不可能です。

[C-NEWTYPE]: type-safety.html#c-newtype

### <!--Dynamic enforcement--> 動的施行

<!--Validate the input as it is processed (or ahead of time, if necessary).-->
入力が処理されると（または必要に応じて先に）入力を検証します。
<!--Dynamic checking is often easier to implement than static checking, but has several downsides:-->
静的検査よりも動的検査はしばしば実装が容易ですが、いくつかの欠点があります。

1. <!--Runtime overhead (unless checking can be done as part of processing the input).-->
    ランタイムオーバーヘッド（入力の処理の一部としてチェックを行うことができない限り）
2. <!--Delayed detection of bugs.-->
    バグの検出を遅らせる。
3. <!--Introduces failure cases, either via `panic!` or `Result` / `Option` types, which must then be dealt with by client code.-->
    `panic!`または`Result` / `Option`タイプのいずれかで失敗のケースを紹介します。これはクライアントコードで処理する必要があります。

#### <!--Dynamic enforcement with `debug_assert!`--> `debug_assert!`動的強制

<!--Same as dynamic enforcement, but with the possibility of easily turning off expensive checks for production builds.-->
動的強制と同じですが、プロダクションビルド用の高価なチェックを簡単に無効にする可能性があります。

#### <!--Dynamic enforcement with opt-out--> オプトアウトによる動的施行

<!--Same as dynamic enforcement, but adds sibling functions that opt out of the checking.-->
動的強制と同じですが、チェックの対象外となる兄弟機能が追加されています。

<!--The convention is to mark these opt-out functions with a suffix like `_unchecked` or by placing them in a `raw` submodule.-->
規約では、これらのオプトアウト機能に、`_unchecked`ような接尾辞を`_unchecked`か、それらを`raw`サブモジュールに置くことです。

<!--The unchecked functions can be used judiciously in cases where (1) performance dictates avoiding checks and (2) the client is otherwise confident that the inputs are valid.-->
チェックされていない機能は、（1）パフォーマンスがチェックを避けるよう指示する場合、および（2）クライアントが入力が有効であると確信している場合に、慎重に使用することができます。


<span id="c-dtor-fail"></span><!--## Destructors never fail (C-DTOR-FAIL)-->
##デストラクタは決して失敗しない（C-DTOR-FAIL）

<!--Destructors are executed on task failure, and in that context a failing destructor causes the program to abort.-->
デストラクタはタスクの失敗時に実行され、そのコンテキストでは失敗したデストラクタによってプログラムが中止されます。

<!--Instead of failing in a destructor, provide a separate method for checking for clean teardown, eg a `close` method, that returns a `Result` to signal problems.-->
代わりに、デストラクタで失敗するの、きれいなティアダウンのためにチェックするために別の方法を提供し、例えば`close`返す方法、`Result`の問題を通知するために。


<span id="c-dtor-block"></span><!--## Destructors that may block have alternatives (C-DTOR-BLOCK)-->
＃ブロックする可能性のあるデストラクタには代替（C-DTOR-BLOCK）

<!--Similarly, destructors should not invoke blocking operations, which can make debugging much more difficult.-->
同様に、デストラクタはブロッキング操作を呼び出すべきではありません。そのため、デバッグがずっと難しくなります。
<!--Again, consider providing a separate method for preparing for an infallible, nonblocking teardown.-->
ここでも、間違いのない、ブロックされていないティアダウンを準備するための別の方法を提供することを検討してください。
