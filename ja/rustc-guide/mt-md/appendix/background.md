# <!--Appendix B: Background topics--> 付録B：背景の話題

<!--This section covers a numbers of common compiler terms that arise in this guide.-->
このセクションでは、このガイドで一般的に使用される多くのコンパイラ用語について説明します。
<!--We try to give the general definition while providing some Rust-specific context.-->
我々は、いくつかの錆固有の文脈を提供しながら、一般的な定義を与えることを試みる。

<span id="cfg"></span>
## <!--What is a control-flow graph?--> コントロールフローグラフとは何ですか？

<!--A control-flow graph is a common term from compilers.-->
制御フローグラフは、コンパイラからの一般的な用語です。
<!--If you've ever used a flow-chart, then the concept of a control-flow graph will be pretty familiar to you.-->
フローグラフを使用したことがあるなら、コントロールフローグラフの概念はあなたによく知られています。
<!--It's a representation of your program that exposes the underlying control flow in a very clear way.-->
これは、基本的な制御フローを非常に明確な方法で公開するプログラムの表現です。

<!--A control-flow graph is structured as a set of **basic blocks** connected by edges.-->
制御フローグラフは、エッジによって接続された**基本ブロックの**セットとして**構成**されています。
<!--The key idea of a basic block is that it is a set of statements that execute "together"– that is, whenever you branch to a basic block, you start at the first statement and then execute all the remainder.-->
基本ブロックの重要なアイデアは、それが「一緒に」実行する一連のステートメントであることです。つまり、基本ブロックに分岐するたびに最初のステートメントから開始し、残りのすべてを実行します。
<!--Only at the end of the block is there the possibility of branching to more than one place (in MIR, we call that final statement the **terminator**):-->
ブロックの終わりに限り、2つ以上の場所に分岐する可能性があります（MIRでは、最後のステートメントを**終了**記号と呼び**ます**）。

```mir
bb0: {
    statement0;
    statement1;
    statement2;
    ...
    terminator;
}
```

<!--Many expressions that you are used to in Rust compile down to multiple basic blocks.-->
錆に慣れている多くの式は、複数の基本ブロックにコンパイルされます。
<!--For example, consider an if statement:-->
たとえば、if文を考えてみましょう。

```rust,ignore
a = 1;
if some_variable {
    b = 1;
} else {
    c = 1;
}
d = 1;
```

<!--This would compile into four basic blocks:-->
これは4つの基本ブロックにコンパイルされます：

```mir
BB0: {
    a = 1;
    if some_variable { goto BB1 } else { goto BB2 }
}

BB1: {
    b = 1;
    goto BB3;
}

BB2: {
    c = 1;
    goto BB3;
}

BB3: {
    d = 1;
    ...;
}
```

<!--When using a control-flow graph, a loop simply appears as a cycle in the graph, and the `break` keyword translates into a path out of that cycle.-->
制御フローグラフを使用する場合、ループは単にグラフの1サイクルとして表示され、`break`キーワードはそのサイクル外のパスに変換されます。

<span id="dataflow"></span>
## <!--What is a dataflow analysis?--> データフロー分析とは何ですか？

<!--[*Static Program Analysis*](https://cs.au.dk/~amoeller/spa/) by Anders Møller and Michael I. Schwartzbach is an incredible resource!-->
AndersMøllerとMichael I. Schwartzbachによる[*静的プログラム分析*](https://cs.au.dk/~amoeller/spa/)は信じられないほどのリソースです！

<!--*to be written*-->
*書かれる*

<span id="quantified"></span>
## <!--What is "universally quantified"?--> 「普遍的な定量化」とは何ですか？
<!--What about "existentially quantified"?--> 「現存量量化」はどうでしょうか？

<!--*to be written*-->
*書かれる*

<span id="variance"></span>
## <!--What is co-and contra-variance?--> 共変および反差分散とは何ですか？

<!--Check out the subtyping chapter from the [Rust Nomicon](https://doc.rust-lang.org/nomicon/subtyping.html).-->
[Rust Nomiconの](https://doc.rust-lang.org/nomicon/subtyping.html)サブタイプの章を調べてください。

<!--See the [variance](./variance.html) chapter of this guide for more info on how the type checker handles variance.-->
型チェッカーが分散をどのように処理するかについては、このガイドの[variance](./variance.html)章を参照してください。

<span id="free-vs-bound"></span>
## <!--What is a "free region"or a "free variable"?--> 「自由領域」または「自由変数」とは何ですか？
<!--What about "bound region"?--> "縛られた地域"はどうですか？

<!--Let's describe the concepts of free vs bound in terms of program variables, since that's the thing we're most familiar with.-->
自由変数と自由変数の概念をプログラム変数の観点から記述してみましょう。それは、これが私たちが最もよく知っていることです。

- <!--Consider this expression, which creates a closure: `|a, b| a + b`-->
   クロージャを作成するこの式を考えてみましょう： `|a, b| a + b`
<!--`|a, b| a + b`.-->
   `|a, b| a + b`。
<!--Here, the `a` and `b` in `a + b` refer to the arguments that the closure will be given when it is called.-->
   ここで、`a`と`b`で`a + b`、それが呼び出されたときに閉鎖が与えられます引数を参照してください。
<!--We say that the `a` and `b` there are **bound** to the closure, and that the closure signature `|a, b|`-->
   `a`と`b`はクロージャに**拘束さ**れており、クロージャのシグネチャ`|a, b|`
<!--is a **binder** for the names `a` and `b` (because any references to `a` or `b` within refer to the variables that it introduces).-->
   名前の**バインダー**であると`a` `b`（への参照ので又は`a` `b`が導入された変数を参照内で）。
- <!--Consider this expression: `a + b`.-->
   次の式を考えてみましょう： `a + b`。
<!--In this expression, `a` and `b` refer to local variables that are defined *outside* of the expression.-->
   この式で`a`、 `b`と`b`は式の*外部*で定義されたローカル変数を参照します。
<!--We say that those variables **appear free** in the expression (ie, they are **free**, not **bound** (tied up)).-->
   これらの変数は式で**自由**に**見える**（すなわち、 **自由**であり、**束縛さ**れていない（結ばれている））。

<!--So there you have it: a variable "appears free"in some expression/statement/whatever if it refers to something defined outside of that expressions/statement/whatever.-->
そこで、あなたはそれを持っています：変数は、ある式/文/それ以外で定義された何かを参照する場合は何でも自由に表示されます。
<!--Equivalently, we can then refer to the "free variables"of an expression – which is just the set of variables that "appear free".-->
同様に、式の「自由変数」を参照することができます。これは、「自由に見える」変数のセットだけです。

<!--So what does this have to do with regions?-->
それでは、これは地域と何が関係していますか？
<!--Well, we can apply the analogous concept to type and regions.-->
さて、型と地域に類似の概念を適用することができます。
<!--For example, in the type `&'a u32`, `'a` appears free.-->
たとえば、タイプ`&'a u32` `'a`は無料で表示されます。
<!--But in the type `for<'a> fn(&'a u32)`, it does not.-->
しかし、`for<'a> fn(&'a u32)`ではそうではありません。
