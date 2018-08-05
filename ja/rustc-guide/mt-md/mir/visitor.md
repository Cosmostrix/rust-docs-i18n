# <!--MIR visitor--> MIR訪問者

<!--The MIR visitor is a convenient tool for traversing the MIR and either looking for things or making changes to it.-->
MIR訪問者は、MIRを横断したり、物を探したり、変更を加えるための便利なツールです。
<!--The visitor traits are defined in [the `rustc::mir::visit` module][m-v] – there are two of them, generated via a single macro: `Visitor` (which operates on a `&Mir` and gives back shared references) and `MutVisitor` (which operates on a `&mut Mir` and gives back mutable references).-->
訪問者の特徴は[`rustc::mir::visit`モジュールで][m-v]定義され[ています][m-v]。 `Visitor`（ `Visitor`（ `&Mir`上で動作し、共有参照を返す）と`MutVisitor`（ `&mut Mir`変更可能な参照を返す）。

[mv]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/mir/visit/index.html

<!--To implement a visitor, you have to create a type that represents your visitor.-->
ビジターを実装するには、ビジターを表すタイプを作成する必要があります。
<!--Typically, this type wants to "hang on"to whatever state you will need while processing MIR:-->
通常、このタイプは、MIRを処理する際に必要となるどのような状態でも「ハングオフ」する必要があります。

```rust,ignore
struct MyVisitor<...> {
    tcx: TyCtxt<'cx, 'tcx, 'tcx>,
    ...
}
```

<!--and you then implement the `Visitor` or `MutVisitor` trait for that type:-->
そのタイプの`Visitor`または`MutVisitor`特性を実装します。

```rust,ignore
impl<'tcx> MutVisitor<'tcx> for NoLandingPads {
    fn visit_foo(&mut self, ...) {
        ...
        self.super_foo(...);
    }
}
```

<!--As shown above, within the impl, you can override any of the `visit_foo` methods (eg, `visit_terminator`) in order to write some code that will execute whenever a `foo` is found.-->
上記のように、impl内では、`foo`が見つかるたびに実行されるコードを記述するために`visit_foo`メソッド（`visit_terminator`）をオーバーライドできます。
<!--If you want to recursively walk the contents of the `foo`, you then invoke the `super_foo` method.-->
`foo`の内容を再帰的に処理したい場合は、`super_foo`メソッドを呼び出します。
<!--(NB. You never want to override `super_foo`.)-->
（あなたは`super_foo`をオーバーライドすることは決してありません。）

<!--A very simple example of a visitor can be found in [`NoLandingPads`].-->
訪問者の非常に単純な例は[`NoLandingPads`]ます。
<!--That visitor doesn't even require any state: it just visits all terminators and removes their `unwind` successors.-->
その訪問者はどんな状態も必要としません。すべてのターミネータを訪れ、その`unwind`後継者を取り除くだけです。

[`NoLandingPads`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_mir/transform/no_landing_pads/struct.NoLandingPads.html

## <!--Traversal--> トラバーサル

<!--In addition the visitor, [the `rustc::mir::traversal` module][t] contains useful functions for walking the MIR CFG in [different standard orders][traversal] (eg pre-order, reverse post-order, and so forth).-->
さらに、訪問者に[は、`rustc::mir::traversal`モジュールに][t]は、MIR CFGを[さまざまな標準注文][traversal]（例えば、プレオーダー、逆ポストオーダーなど）で歩くための便利な機能が含まれています。

<!--[t]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/mir/traversal/index.html
 [traversal]: https://en.wikipedia.org/wiki/Tree_traversal
-->
[t]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/mir/traversal/index.html
 [traversal]: https://en.wikipedia.org/wiki/Tree_traversal


