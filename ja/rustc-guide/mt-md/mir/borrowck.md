# <!--MIR borrow check--> MIR借り入れチェック

<!--The borrow check is Rust's "secret sauce"– it is tasked with enforcing a number of properties:-->
借り入れチェックは、Rustの「秘密のソース」です。これは、いくつかのプロパティを強制することを任されています。

- <!--That all variables are initialized before they are used.-->
   すべての変数は使用前に初期化されています。
- <!--That you can't move the same value twice.-->
   同じ値を2回動かすことはできません。
- <!--That you can't move a value while it is borrowed.-->
   それは借りている間に値を動かすことができないということです。
- <!--That you can't access a place while it is mutably borrowed (except through the reference).-->
   場所を参照する場合を除いて、それが変更されている間は場所にアクセスできないということです。
- <!--That you can't mutate a place while it is shared borrowed.-->
   あなたが借りたものを共有している間にその場所を突然変異させることはできないということです。
- <!--etc-->
   等

<!--At the time of this writing, the code is in a state of transition.-->
この執筆時点では、コードは移行状態にあります。
<!--The "main"borrow checker still works by processing [the HIR](hir.html), but that is being phased out in favor of the MIR-based borrow checker.-->
"メイン"借用チェッカーは依然として[HIRを](hir.html)処理[することで](hir.html)動作しますが、MIRベースの借用チェッカーのために段階的に廃止されています。
<!--Doing borrow checking on MIR has two key advantages:-->
MIRの借り入れチェックには2つの大きな利点があります。

- <!--The MIR is *far* less complex than the HIR;-->
   MIRはHIRより*はるかに*複雑ではありません。
<!--the radical desugaring helps prevent bugs in the borrow checker.-->
   根本的なdesugaringは借りチェッカーのバグを防ぐのに役立ちます。
<!--(If you're curious, you can see [a list of bugs that the MIR-based borrow checker fixes here][47366].)-->
   （興味[がある人は、MIRベースの借用チェッカーがここで修正したバグのリストを][47366]見ることができます）。
- <!--Even more importantly, using the MIR enables ["non-lexical lifetimes"][nll], which are regions derived from the control-flow graph.-->
   さらに重要なことに、MIRを使用することで、制御フローグラフから派生した領域である[「語彙外の生涯」が][nll]可能になります。

<!--[47366]: https://github.com/rust-lang/rust/issues/47366
 [nll]: http://rust-lang.github.io/rfcs/2094-nll.html
-->
[47366]: https://github.com/rust-lang/rust/issues/47366
 [nll]: http://rust-lang.github.io/rfcs/2094-nll.html


### <!--Major phases of the borrow checker--> 借用チェッカーの主なフェーズ

<!--The borrow checker source is found in [the `rustc_mir::borrow_check` module][b_c].-->
[`rustc_mir::borrow_check`][b_c]チェッカーのソースは[、`rustc_mir::borrow_check`モジュールにあります][b_c]。
<!--The main entry point is the `mir_borrowck` query.-->
メインエントリポイントは、`mir_borrowck`クエリです。
<!--At the time of this writing, MIR borrowck can operate in several modes, but this text will describe only the mode when NLL is enabled (what you get with `#![feature(nll)]`).-->
この執筆時点では、MIR borrowckはいくつかのモードで動作することができますが、このテキストではNLLが有効になっているモード（`#![feature(nll)]`取得するモード）についてのみ説明します。

[b_c]: https://github.com/rust-lang/rust/tree/master/src/librustc_mir/borrow_check

<!--The overall flow of the borrow checker is as follows:-->
借用チェッカーの全体的な流れは次のとおりです。

- <!--We first create a **local copy** C of the MIR.-->
   最初に、MIRの**ローカルコピー** Cを作成します。
<!--In the coming steps, we will modify this copy in place to modify the types and things to include references to the new regions that we are computing.-->
   今後の手順では、このコピーを修正して、コンピューティングしている新しい地域への参照を含めるためにタイプとものを変更します。
- <!--We then invoke `nll::replace_regions_in_mir` to modify this copy C. Among other things, this function will replace all of the regions in the MIR with fresh [inference variables](./appendix/glossary.html).-->
   次に、このコピーCを変更するために`nll::replace_regions_in_mir`を呼び出します。とりわけ、この関数は、MIRのすべての領域を新しい[推論変数に](./appendix/glossary.html)置き換え[ます](./appendix/glossary.html)。
  - <!--(More details can be found in [the regionck section](./mir/regionck.html).)-->
     詳細については[、regionckのセクションを参照してください](./mir/regionck.html)。
- <!--Next, we perform a number of [dataflow analyses](./appendix/background.html#dataflow) that compute what data is moved and when.-->
   次に、移動するデータとそのタイミングを計算する多数の[データフロー分析](./appendix/background.html#dataflow)を実行します。
<!--The results of these analyses are needed to do both borrow checking and region inference.-->
   これらの分析の結果は、借り入れチェックと地域推論の両方を行うために必要です。
- <!--Using the move data, we can then compute the values of all the regions in the MIR.-->
   移動データを使用して、MIR内のすべての領域の値を計算することができます。
  - <!--(More details can be found in [the NLL section](./mir/regionck.html).)-->
     （詳細は[、NLLセクションを参照して](./mir/regionck.html)ください）。
- <!--Finally, the borrow checker itself runs, taking as input (a) the results of move analysis and (b) the regions computed by the region checker.-->
   最後に、借りチェッカー自体は、（a）移動解析の結果と（b）領域チェッカーによって計算された領域を入力として取ります。
<!--This allows us to figure out which loans are still in scope at any particular point.-->
   これにより、特定の時点でどの融資がまだ範囲内にあるのか把握することができます。

