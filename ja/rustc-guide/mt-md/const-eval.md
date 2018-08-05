# <!--Constant Evaluation--> 一定の評価

<!--Constant evaluation is the process of computing values at compile time.-->
定数評価は、コンパイル時に値を計算するプロセスです。
<!--For a specific item (constant/static/array length) this happens after the MIR for the item is borrow-checked and optimized.-->
特定のアイテム（定数/静的/配列の長さ）に対して、これはアイテムのMIRが借用チェックされ最適化された後に発生します。
<!--In many cases trying to const evaluate an item will trigger the computation of its MIR for the first time.-->
多くの場合、項目を評価するconstを試みると、MIRの計算が初めてトリガーされます。

<!--Prominent examples are-->
有名な例は

* <!--The initializer of a `static`-->
   `static`の初期化子
* <!--Array length-->
   配列の長さ
    * <!--needs to be known to reserve stack or heap space-->
       スタックまたはヒープスペースを予約する必要がある
* <!--Enum variant discriminants-->
   Enumバリアント判別式
    * <!--needs to be known to prevent two variants from having the same discriminant-->
       2つの変種が同じ判別式を持つのを防ぐために知る必要があります
* <!--Patterns-->
   パターン
    * <!--need to be known to check for overlapping patterns-->
       パターンが重複していないかどうかを知る必要がある

<!--Additionally constant evaluation can be used to reduce the workload or binary size at runtime by precomputing complex operations at compiletime and only storing the result.-->
さらに、コンパイル時に複雑な操作を事前計算し、結果のみを保存することにより、実行時のワークロードまたはバイナリサイズを削減するために、一定の評価を使用できます。

<!--Constant evaluation can be done by calling the `const_eval` query of `TyCtxt`.-->
一定の評価を呼び出すことによって行うことができる`const_eval`のクエリ`TyCtxt`。

<!--The `const_eval` query takes a [`ParamEnv`](./param_env.html) of environment in which the constant is evaluated (eg the function within which the constant is used) and a `GlobalId`.-->
`const_eval`クエリがかかる[`ParamEnv`](./param_env.html)定数が評価される環境の（定数が使用されている内などの機能）と`GlobalId`。
<!--The `GlobalId` is made up of an `Instance` referring to a constant or static or of an `Instance` of a function and an index into the function's `Promoted` table.-->
`GlobalId`で構成されて`Instance`定数または静的またはのを参照する`Instance`関数の機能の内のインデックス`Promoted`テーブル。

<!--Constant evaluation returns a `Result` with either the error, or the simplest representation of the constant.-->
定数評価は、エラー、または定数の最も単純な表現のいずれかを返す`Result`を返します。
<!--"simplest"meaning if it is representable as an integer or fat pointer, it will directly yield the value (via `Value::ByVal` or `Value::ByValPair`), instead of referring to the [`miri`](./miri.html) virtual memory allocation (via `Value::ByRef`).-->
Integerまたは`Value::ByValPair`ポインタとして表現できる場合は、（`Value::ByVal`または`Value::ByValPair`） [`miri`](./miri.html)仮想メモリ割り当てを参照するのではなく、`Value::ByRef`直接値を生成します。。
<!--This means that the `const_eval` function cannot be used to create miri-pointers to the evaluated constant or static.-->
これは、評価された定数または静的変数へのミラーポインタの作成に`const_eval`関数を使用できないことを意味します。
<!--If you need that, you need to directly work with the functions in [src/librustc_mir/interpret/const_eval.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_mir/interpret/const_eval/).-->
必要な場合は、[src/librustc_mir/interpret/const_eval.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_mir/interpret/const_eval/)関数で直接作業する必要があります。
