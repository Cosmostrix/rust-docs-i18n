# <!--Type checking--> 型チェック

<!--The [`rustc_typeck`][typeck] crate contains the source for "type collection"and "type checking", as well as a few other bits of related functionality.-->
[`rustc_typeck`][typeck]枠には、"type collection"と "type checking"のソース、および関連する機能の他のビットが含まれています。
<!--(It draws heavily on the [type inference] and [trait solving].)-->
（これは[type inference]と[trait solving]大きく依存します。）

<!--[typeck]: https://github.com/rust-lang/rust/tree/master/src/librustc_typeck
 [type inference]: type-inference.html
 [trait solving]: traits/resolution.html
-->
[type inference]: type-inference.html
 [typeck]: https://github.com/rust-lang/rust/tree/master/src/librustc_typeck
 [type inference]: type-inference.html
 [trait solving]: traits/resolution.html


## <!--Type collection--> タイプコレクション

<!--Type "collection"is the process of converting the types found in the HIR (`hir::Ty`), which represent the syntactic things that the user wrote, into the **internal representation** used by the compiler (`Ty<'tcx>`) – we also do similar conversions for where-clauses and other bits of the function signature.-->
タイプ "collection"は、ユーザが書いた構文を表すHIR（`hir::Ty`）で見つかったタイプを、コンパイラ（ `Ty<'tcx>`）が使用する**内部表現**に変換するプロセスです。where-clauseと関数シグネチャの他のビットについても同様の変換を行います。

<!--To try and get a sense for the difference, consider this function:-->
違いを感じ取るために、この関数を考えてみましょう：

```rust,ignore
struct Foo { }
fn foo(x: Foo, y: self::Foo) { ... }
#//        ^^^     ^^^^^^^^^
//  ^^^ ^^^^^^^^^^^
```

<!--Those two parameters `x` and `y` each have the same type: but they will have distinct `hir::Ty` nodes.-->
これらの2つのパラメータ`x`と`y`それぞれ同じ型ですが、別々の`hir::Ty`ノードを持ちます。
<!--Those nodes will have different spans, and of course they encode the path somewhat differently.-->
それらのノードは異なるスパンを持ち、もちろんそれらのパスを多少異なる方法でエンコードします。
<!--But once they are "collected"into `Ty<'tcx>` nodes, they will be represented by the exact same internal type.-->
しかし、それらが`Ty<'tcx>`ノードに「収集」されると、それらはまったく同じ内部型によって表されることになる。

<!--Collection is defined as a bundle of [queries] for computing information about the various functions, traits, and other items in the crate being compiled.-->
コレクションは、コンパイルされている枠内のさまざまな機能、特性、およびその他の項目に関する情報を計算するための[queries]バンドルとして定義されます。
<!--Note that each of these queries is concerned with *interprocedural* things – for example, for a function definition, collection will figure out the type and signature of the function, but it will not visit the *body* of the function in any way, nor examine type annotations on local variables (that's the job of type *checking*).-->
これらのクエリのそれぞれは、*手続き間の*ものに関係していることに注意してください。例えば、関数定義では、関数の型とシグネチャをコレクションが調べますが、関数の*本体*を訪れることはありませんし、（これは型*チェック*の仕事です）。

<!--For more details, see the [`collect`][collect] module.-->
詳細は、[`collect`][collect]モジュールを参照してください。

<!--[queries]: query.html
 [collect]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_typeck/collect/
-->
[queries]: query.html
 [collect]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_typeck/collect/


<!--**TODO**: actually talk about type checking...-->
**TODO**：タイプチェックについて実際に話す...
