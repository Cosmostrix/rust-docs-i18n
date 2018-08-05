# <!--Call expressions--> 呼び出し式

> <!--**<sup>Syntax</sup>** \  _CallExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _CallExpression_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] `(`  _CallParams_   __?__  `)`-->
> [_Expression_] `(`  _CallParams_   __？__  `)`
> 
> <!-- _CallParams_ :\ &nbsp;&nbsp;-->
>  _CallParams_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] &nbsp;(`,` [_Expression_])  __\*__  `,`  __?__ -->
> [_Expression_] ＆NBSP;（`,` [_Expression_]  __）\ *__  `,`  __？__ 

<!--A  _call expression_  consists of an expression followed by a parenthesized expression-list.-->
 _呼び出し式_ は、式の後に括弧で囲まれた式リストが続きます。
<!--It invokes a function, providing zero or more input variables.-->
それは0個以上の入力変数を提供する関数を呼び出します。
<!--If the function eventually returns, then the expression completes.-->
関数が最終的に戻ると、式は完了します。
<!--For [non-function types](types.html#function-item-types), the expression f(...) uses the method on one of the [`std::ops::Fn`], [`std::ops::FnMut`] or [`std::ops::FnOnce`] traits, which differ in whether they take the type by reference, mutable reference, or take ownership respectively.-->
[非関数型の](types.html#function-item-types)場合、式f（...）は[`std::ops::Fn`]、 [`std::ops::FnMut`]または[`std::ops::FnOnce`]それぞれが参照によってタイプを取るか、変更可能な参照であるか、所有権を取るかという点で異なる。
<!--An automatic borrow will be taken if needed.-->
必要に応じて自動借用が行われます。
<!--Rust will also automatically dereference `f` as required.-->
また、錆は必要に応じて自動的に`f`を逆参照します。
<!--Some examples of call expressions:-->
呼び出し式の例をいくつか示します。

```rust
# fn add(x: i32, y: i32) -> i32 { 0 }
let three: i32 = add(1i32, 2i32);
let name: &'static str = (|| "Rust")();
```

## <!--Disambiguating Function Calls--> 関数呼び出しの曖昧さを解消する

<!--Rust treats all function calls as sugar for a more explicit, fully-qualified syntax.-->
Rustは、より明示的で完全修飾された構文のために、すべての関数呼び出しを砂糖として扱います。
<!--Upon compilation, Rust will desugar all function calls into the explicit form.-->
コンパイル時に、Rustはすべての関数呼び出しを明示的な形式にします。
<!--Rust may sometimes require you to qualify function calls with trait, depending on the ambiguity of a call in light of in-scope items.-->
Rustでは、スコープ内の項目に照らしてコールのあいまいさに応じて、機能コールを特性で修飾する必要が生じることがあります。

> <!--**Note**: In the past, the Rust community used the terms "Unambiguous Function Call Syntax", "Universal Function Call Syntax", or "UFCS", in documentation, issues, RFCs, and other community writings.-->
> **注記**：過去に、Rustコミュニティは、ドキュメント、問題、RFC、およびその他のコミュニティーの文書で、「明確な関数呼び出し構文」、「汎用関数呼び出し構文」、または「UFCS」という用語を使用していました。
> <!--However, the term lacks descriptive power and potentially confuses the issue at hand.-->
> しかし、この用語は説明力がなく、潜在的に問題を混乱させる可能性があります。
> <!--We mention it here for searchability's sake.-->
> 検索可能性のためにここで言及します。

<!--Several situations often occur which result in ambiguities about the receiver or referent of method or associated function calls.-->
いくつかの状況がしばしば起こり、その結果、メソッドまたは関連する関数呼び出しの受信者または参照先に関するあいまい性が生じる。
<!--These situations may include:-->
これらの状況には、

* <!--Multiple in-scope traits define methods with the same name for the same types-->
   複数のスコープ内の特性は、同じタイプの同じ名前を持つメソッドを定義します
* <!--Auto-`deref` is undesirable;-->
   自動`deref`は望ましくありません。
<!--for example, distinguishing between methods on a smart pointer itself and the pointer's referent-->
   例えば、スマートポインタ自体のメソッドとポインタの指示対象との区別
* <!--Methods which take no arguments, like `default()`, and return properties of a type, like `size_of()`-->
   `default()`ように引数を取らず、`size_of()`ような型の戻り`default()`メソッドは、

<!--To resolve the ambiguity, the programmer may refer to their desired method or function using more specific paths, types, or traits.-->
あいまいさを解決するために、プログラマは、より具体的なパス、タイプ、または特性を使用して、望ましいメソッドまたは関数を参照することがあります。

<!--For example,-->
例えば、

```rust
trait Pretty {
    fn print(&self);
}

trait Ugly {
  fn print(&self);
}

struct Foo;
impl Pretty for Foo {
    fn print(&self) {}
}

struct Bar;
impl Pretty for Bar {
    fn print(&self) {}
}
impl Ugly for Bar{
    fn print(&self) {}
}

fn main() {
    let f = Foo;
    let b = Bar;

#    // we can do this because we only have one item called `print` for `Foo`s
    //  `print` for `Foo` sという項目が1つしかないので、これを行うことができます
    f.print();
#    // more explicit, and, in the case of `Foo`, not necessary
    // より明示的であり、`Foo`の場合、必要ではない
    Foo::print(&f);
#    // if you're not into the whole brevity thing
    // あなたが全体の簡潔なことにならないなら
    <Foo as Pretty>::print(&f);

#    // b.print(); // Error: multiple 'print' found
#    // Bar::print(&b); // Still an error: multiple `print` found
    //  b.print（）; //エラー：複数の 'print'が見つかりましたBar:: print（＆b）; //まだエラー：複数の`print`見つかりました

#    // necessary because of in-scope items defining `print`
    //  `print`定義する範囲内の項目のために必要
    <Bar as Pretty>::print(&b);
}
```

<!--Refer to [RFC 132] for further details and motivations.-->
詳細と動機については、[RFC 132]を参照し[RFC 132]ください。

<!--[`std::ops::Fn`]: ../std/ops/trait.Fn.html
 [`std::ops::FnMut`]: ../std/ops/trait.FnMut.html
 [`std::ops::FnOnce`]: ../std/ops/trait.FnOnce.html
 [RFC 132]: https://github.com/rust-lang/rfcs/blob/master/text/0132-ufcs.md
-->
[`std::ops::Fn`]: ../std/ops/trait.Fn.html
 [`std::ops::FnMut`]: ../std/ops/trait.FnMut.html
 [`std::ops::FnOnce`]: ../std/ops/trait.FnOnce.html
 [RFC 132]: https://github.com/rust-lang/rfcs/blob/master/text/0132-ufcs.md


[_Expression_]: expressions.html
