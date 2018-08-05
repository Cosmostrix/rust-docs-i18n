# <!--MIR passes--> MIRパス

<!--If you would like to get the MIR for a function (or constant, etc), you can use the `optimized_mir(def_id)` query.-->
関数（または定数など）のMIRを取得する場合は、`optimized_mir(def_id)`クエリを使用できます。
<!--This will give you back the final, optimized MIR.-->
これにより、最終的に最適化されたMIRが返されます。
<!--For foreign def-ids, we simply read the MIR from the other crate's metadata.-->
外国のdef-idsでは、他の箱のメタデータからMIRを読み込むだけです。
<!--But for local def-ids, the query will construct the MIR and then iteratively optimize it by applying a series of passes.-->
しかし、ローカルdef-idsの場合、クエリはMIRを構築し、一連のパスを適用して反復的に最適化します。
<!--This section describes how those passes work and how you can extend them.-->
このセクションでは、パスの仕組みとパスの拡張方法について説明します。

<!--To produce the `optimized_mir(D)` for a given def-id `D`, the MIR passes through several suites of optimizations, each represented by a query.-->
与えられたdef-id `D`に対する`optimized_mir(D)`を生成するために、MIRはいくつかの最適化スイートを通過し、それぞれがクエリによって表されます。
<!--Each suite consists of multiple optimizations and transformations.-->
各スイートは、複数の最適化と変換で構成されています。
<!--These suites represent useful intermediate points where we want to access the MIR for type checking or other purposes:-->
これらのスイートは、タイプチェックやその他の目的でMIRにアクセスしたい場合に便利な中間点です。

- <!--`mir_build(D)` – not a query, but this constructs the initial MIR-->
   `mir_build(D)` -クエリではないが、これは最初のMIRを構築する
- <!--`mir_const(D)` – applies some simple transformations to make MIR ready for constant evaluation;-->
   `mir_const(D)` -いくつかの簡単な変換を適用して、MIRを定数評価の準備を整えます。
- <!--`mir_validated(D)` – applies some more transformations, making MIR ready for borrow checking;-->
   `mir_validated(D)` -いくつかの変換を適用し、MIRを借用チェックの準備が整えます。
- <!--`optimized_mir(D)` – the final state, after all optimizations have been performed.-->
   `optimized_mir(D)` -すべての最適化が実行された後の最終状態。

### <!--Seeing how the MIR changes as the compiler executes--> コンパイラの実行時にMIRがどのように変化するかを見る

<!--`-Zdump-mir=F` is a handy compiler options that will let you view the MIR for each function at each stage of compilation.-->
`-Zdump-mir=F`は、コンパイルの各段階で各関数のMIRを表示するのに便利なコンパイラオプションです。
<!--`-Zdump-mir` takes a **filter** `F` which allows you to control which functions and which passes you are interesting in. For example:-->
`-Zdump-mir`は**フィルタ** `F`を受け取ります。この関数を使用すると、どの関数をどの関数に渡すかを制御できます。たとえば、次のようになります。

```bash
> rustc -Zdump-mir=foo ...
```

<!--This will dump the MIR for any function whose name contains `foo`;-->
これは、名前に`foo`が含まれる関数のMIRをダンプします。
<!--it will dump the MIR both before and after every pass.-->
すべてのパスの前後にMIRをダンプします。
<!--Those files will be created in the `mir_dump` directory.-->
これらのファイルは、`mir_dump`ディレクトリに作成されます。
<!--There will likely be quite a lot of them!-->
おそらくそれらのかなりたくさんあるでしょう！

```bash
> cat > foo.rs
fn main() {
    println!("Hello, world!");
}
^D
> rustc -Zdump-mir=main foo.rs
> ls mir_dump/* | wc -l
     161
```

<!--The files have names like `rustc.main.000-000.CleanEndRegions.after.mir`.-->
ファイルには`rustc.main.000-000.CleanEndRegions.after.mir`ような名前が`rustc.main.000-000.CleanEndRegions.after.mir`ます。
<!--These names have a number of parts:-->
これらの名前にはいくつかの部分があります。

```text
rustc.main.000-000.CleanEndRegions.after.mir
      ---- --- --- --------------- ----- either before or after
      |    |   |   name of the pass
      |    |   index of dump within the pass (usually 0, but some passes dump intermediate states)
      |    index of the pass
      def-path to the function etc being dumped
```

<!--You can also make more selective filters.-->
より選択的なフィルタを作成することもできます。
<!--For example, `main & CleanEndRegions` will select for things that reference *both* `main` and the pass `CleanEndRegions`:-->
たとえば、`main & CleanEndRegions`は*、* `main`とパスの*両方*を参照するものを選択します`CleanEndRegions`：

```bash
> rustc -Zdump-mir='main & CleanEndRegions' foo.rs
> ls mir_dump
rustc.main.000-000.CleanEndRegions.after.mir	rustc.main.000-000.CleanEndRegions.before.mir
```

<!--Filters can also have `|`-->
フィルタには`|`
<!--parts to combine multiple sets of `&` -filters.-->
複数の`&`フィルターセットを組み合わせるための部品。
<!--For example `main & CleanEndRegions | main & NoLandingPads`-->
たとえば、`main & CleanEndRegions | main & NoLandingPads`
<!--`main & CleanEndRegions | main & NoLandingPads` will select *either* `main` and `CleanEndRegions` *or* `main` and `NoLandingPads`:-->
`main & CleanEndRegions | main & NoLandingPads`は*、* `main`と`CleanEndRegions` *、* `main`と`NoLandingPads` *いずれか*を選択し*ます*：

```bash
> rustc -Zdump-mir='main & CleanEndRegions | main & NoLandingPads' foo.rs
> ls mir_dump
rustc.main-promoted[0].002-000.NoLandingPads.after.mir
rustc.main-promoted[0].002-000.NoLandingPads.before.mir
rustc.main-promoted[0].002-006.NoLandingPads.after.mir
rustc.main-promoted[0].002-006.NoLandingPads.before.mir
rustc.main-promoted[1].002-000.NoLandingPads.after.mir
rustc.main-promoted[1].002-000.NoLandingPads.before.mir
rustc.main-promoted[1].002-006.NoLandingPads.after.mir
rustc.main-promoted[1].002-006.NoLandingPads.before.mir
rustc.main.000-000.CleanEndRegions.after.mir
rustc.main.000-000.CleanEndRegions.before.mir
rustc.main.002-000.NoLandingPads.after.mir
rustc.main.002-000.NoLandingPads.before.mir
rustc.main.002-006.NoLandingPads.after.mir
rustc.main.002-006.NoLandingPads.before.mir
```

<!--(Here, the `main-promoted[0]` files refer to the MIR for "promoted constants"that appeared within the `main` function.)-->
（ここでは、`main-promoted[0]`ファイルは`main`関数内に登場した "promoted constant"のMIRを参照しています）。

### <!--Implementing and registering a pass--> パスの実装と登録

<!--A `MirPass` is some bit of code that processes the MIR, typically – but not always – transforming it along the way somehow.-->
`MirPass`はMIRを処理するコードですが、いつもとは限りませんが、何とか途中でそれを変換します。
<!--For example, it might perform an optimization.-->
たとえば、最適化を実行する場合があります。
<!--The `MirPass` trait itself is found in in [the `rustc_mir::transform` module][mirtransform], and it basically consists of one method, `run_pass`, that simply gets an `&mut Mir` (along with the tcx and some information about where it came from).-->
`MirPass`特性自体は[`rustc_mir::transform`モジュール][mirtransform]にあります。基本的には`run_pass` 1つのメソッドから成ってい[ます][mirtransform]。これは単に`&mut Mir`（どこから来たのかについてのtcxといくつかの情報を）取得します。
<!--The MIR is therefore modified in place (which helps to keep things efficient).-->
したがって、MIRはその場で変更されます（物事を効率的に保つのに役立ちます）。

<!--A good example of a basic MIR pass is [`NoLandingPads`], which walks the MIR and removes all edges that are due to unwinding – this is used when configured with `panic=abort`, which never unwinds.-->
基本的なMIRパスの良い例は、MIRを歩き、巻き戻しに起因するすべてのエッジを除去する[`NoLandingPads`]。これは[`NoLandingPads`]しない`panic=abort`で構成されている場合に使用されます。
<!--As you can see from its source, a MIR pass is defined by first defining a dummy type, a struct with no fields, something like:-->
そのソースから見ることができるように、MIRパスは最初にダミー型を定義し、フィールドを持たない構造体を定義します。

```rust
struct MyPass;
```

<!--for which you then implement the `MirPass` trait.-->
そのために`MirPass`特性を実装します。
<!--You can then insert this pass into the appropriate list of passes found in a query like `optimized_mir`, `mir_validated`, etc. (If this is an optimization, it should go into the `optimized_mir` list.)-->
このパスを`optimized_mir`、 `mir_validated`などのクエリで見つかった適切なパスリストに挿入することができます（これが最適化されている場合は、`optimized_mir`リストに移動する必要があります）。

<!--If you are writing a pass, there's a good chance that you are going to want to use a [MIR visitor].-->
パスを書いている場合は、[MIR visitor]を使用する可能性があります。
<!--MIR visitors are a handy way to walk all the parts of the MIR, either to search for something or to make small edits.-->
MIR訪問者は、何かを検索したり、小さな編集をするために、MIRのすべての部分を歩く便利な方法です。

### <!--Stealing--> 窃盗

<!--The intermediate queries `mir_const()` and `mir_validated()` yield up a `&'tcx Steal<Mir<'tcx>>`, allocated using `tcx.alloc_steal_mir()`.-->
中間クエリ`mir_const()`と`mir_const()`、 `mir_validated()`を使用して割り当てられた`&'tcx Steal<Mir<'tcx>>`を`tcx.alloc_steal_mir()`ます。
<!--This indicates that the result may be **stolen** by the next suite of optimizations – this is an optimization to avoid cloning the MIR.-->
これは、次の一連の最適化によって結果が**盗ま**れる可能性があることを示します。これは、MIRの複製を回避するための最適化です。
<!--Attempting to use a stolen result will cause a panic in the compiler.-->
盗まれた結果を使用しようとすると、コンパイラでパニックが発生します。
<!--Therefore, it is important that you do not read directly from these intermediate queries except as part of the MIR processing pipeline.-->
したがって、MIR処理パイプラインの一部として以外は、これらの中間クエリから直接読み取らないことが重要です。

<!--Because of this stealing mechanism, some care must also be taken to ensure that, before the MIR at a particular phase in the processing pipeline is stolen, anyone who may want to read from it has already done so.-->
この窃取メカニズムのために、処理パイプラインの特定のフェーズでMIRが盗まれる前に、MIRから処理パイプラインを盗まれる前に、それを読みたいと思っている人は、すでにそれを行っていることを確認する必要があります。
<!--Concretely, this means that if you have some query `foo(D)` that wants to access the result of `mir_const(D)` or `mir_validated(D)`, you need to have the successor pass "force"`foo(D)` using `ty::queries::foo::force(...)`.-->
具体的には、これは、`mir_const(D)`または`mir_validated(D)`の結果にアクセスするクエリ`foo(D)`ある場合、後継者に`ty::queries::foo::force(...)`を使用して "force"`foo(D)`を渡す必要があることを`mir_const(D)`ます`ty::queries::foo::force(...)`。
<!--This will force a query to execute even though you don't directly require its result.-->
これにより、結果を直接要求していなくても、クエリが強制的に実行されます。

<!--As an example, consider MIR const qualification.-->
例として、MIR const資格を検討してください。
<!--It wants to read the result produced by the `mir_const()` suite.-->
これは、`mir_const()`スイートによって生成された結果を読み取ることを望みます。
<!--However, that result will be **stolen** by the `mir_validated()` suite.-->
ただし、その結果は`mir_validated()`スイートによって**盗ま**れます。
<!--If nothing was done, then `mir_const_qualif(D)` would succeed if it came before `mir_validated(D)`, but fail otherwise.-->
何もしなかった場合、`mir_const_qualif(D)`は`mir_validated(D)`前に`mir_validated(D)`ば成功しますが、そうでなければ失敗します。
<!--Therefore, `mir_validated(D)` will **force** `mir_const_qualif` before it actually steals, thus ensuring that the reads have already happened (remember that [queries are memoized](./query.html), so executing a query twice simply loads from a cache the second time):-->
したがって、`mir_validated(D)`は実際に盗む前に`mir_const_qualif`を**強制**し、読み込みが既に行われていることを確認します（[クエリがメモされる](./query.html)ので、クエリを2回実行するだけで2回目にキャッシュからロードされます）。

```text
mir_const(D) --read-by--> mir_const_qualif(D)
     |                       ^
  stolen-by                  |
     |                    (forces)
     v                       |
mir_validated(D) ------------+
```

<!--This mechanism is a bit dodgy.-->
このメカニズムは少しばかげている。
<!--There is a discussion of more elegant alternatives in [rust-lang/rust#41710].-->
[rust-lang/rust#41710]のよりエレガントな選択肢の議論があります。

<!--[rust-lang/rust#41710]: https://github.com/rust-lang/rust/issues/41710
 [mirtransform]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_mir/transform/
 [`NoLandingPads`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_mir/transform/no_landing_pads/struct.NoLandingPads.html
 [MIR visitor]: mir/visitor.html
-->
[rust-lang/rust#41710]: https://github.com/rust-lang/rust/issues/41710
 [mirtransform]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_mir/transform/
 [`NoLandingPads`]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_mir/transform/no_landing_pads/struct.NoLandingPads.html
 [MIR visitor]: mir/visitor.html

