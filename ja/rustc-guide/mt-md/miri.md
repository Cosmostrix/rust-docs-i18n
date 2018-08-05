# <!--Miri--> ミリ

<!--Miri (**MIR** **I** nterpreter) is a virtual machine for executing MIR without compiling to machine code.-->
Miri（**MIR** **I** nterpreter）は、マシンコードにコンパイルせずにMIRを実行するための仮想マシンです。
<!--It is usually invoked via `tcx.const_eval`.-->
これは通常、`tcx.const_eval`を介して呼び出されます。

<!--If you start out with a constant-->
あなたが定数で始めるなら

```rust
const FOO: usize = 1 << 12;
```

<!--rustc doesn't actually invoke anything until the constant is either used or placed into metadata.-->
rustcは、定数が使用されるかメタデータに置かれるまで、実際には何も呼び出されません。

<!--Once you have a use-site like-->
のような使用サイトを取得したら

```rust,ignore
type Foo = [u8; FOO - 42];
```

<!--The compiler needs to figure out the length of the array before being able to create items that use the type (locals, constants, function arguments,...).-->
コンパイラは、型（地域、定数、関数の引数など）を使用する項目を作成するには、配列の長さを把握する必要があります。

<!--To obtain the (in this case empty) parameter environment, one can call `let param_env = tcx.param_env(length_def_id);`-->
（この場合は空の）パラメータ環境を取得するには、`let param_env = tcx.param_env(length_def_id);`呼び出し`let param_env = tcx.param_env(length_def_id);`
<!--.-->
。
<!--The `GlobalId` needed is-->
必要な`GlobalId`は

```rust,ignore
let gid = GlobalId {
    promoted: None,
    instance: Instance::mono(length_def_id),
};
```

<!--Invoking `tcx.const_eval(param_env.and(gid))` will now trigger the creation of the MIR of the array length expression.-->
`tcx.const_eval(param_env.and(gid))`を呼び出すと、配列の長さ式のMIRが作成されます。
<!--The MIR will look something like this:-->
MIRは次のようになります。

```mir
const Foo::{{initializer}}: usize = {
#//    let mut _0: usize;                   // return pointer
    let mut _0: usize;                   // 戻りポインタ
    let mut _1: (usize, bool);

    bb0: {
        _1 = CheckedSub(const Unevaluated(FOO, Slice([])), const 42usize);
        assert(!(_1.1: bool), "attempt to subtract with overflow") -> bb1;
    }

    bb1: {
        _0 = (_1.0: usize);
        return;
    }
}
```

<!--Before the evaluation, a virtual memory location (in this case essentially a `vec![u8; 4]` or `vec![u8; 8]`) is created for storing the evaluation result.-->
評価の前に、評価結果を格納する仮想メモリの場所（この場合は基本的に`vec![u8; 4]`または`vec![u8; 8]`）が作成されます。

<!--At the start of the evaluation, `_0` and `_1` are `Value::ByVal(PrimVal::Undef)`.-->
評価の開始時に、`_0`と`_1`は`Value::ByVal(PrimVal::Undef)`です。
<!--When the initialization of `_1` is invoked, the value of the `FOO` constant is required, and triggers another call to `tcx.const_eval`, which will not be shown here.-->
`_1`の初期化が呼び出されると、`FOO`定数の値が必要になり、ここには表示されない`tcx.const_eval`への別の呼び出しがトリガーされます。
<!--If the evaluation of FOO is successful, 42 will be subtracted by its value `4096` and the result stored in `_1` as `Value::ByValPair(PrimVal::Bytes(4054), PrimVal::Bytes(0))`.-->
FOOの評価が成功すると、42はその値`4096`によって減算され、結果は`Value::ByValPair(PrimVal::Bytes(4054), PrimVal::Bytes(0))`として`_1`格納されます。
<!--The first part of the pair is the computed value, the second part is a bool that's true if an overflow happened.-->
ペアの最初の部分は計算された値で、2番目の部分はオーバーフローが発生した場合に真となるブールです。

<!--The next statement asserts that said boolean is `0`.-->
次の文は、前記ブール値が`0`ことを表明する。
<!--In case the assertion fails, its error message is used for reporting a compile-time error.-->
アサーションが失敗した場合、そのエラーメッセージはコンパイル時エラーを報告するために使用されます。

<!--Since it does not fail, `Value::ByVal(PrimVal::Bytes(4054))` is stored in the virtual memory was allocated before the evaluation.-->
それが失敗しないので、`Value::ByVal(PrimVal::Bytes(4054))`は、評価の前に割り当てられた仮想メモリに格納されます。
<!--`_0` always refers to that location directly.-->
`_0`常にその場所を直接参照します。

<!--After the evaluation is done, the virtual memory allocation is interned into the `TyCtxt`.-->
評価が終了すると、仮想メモリの割り当てが`TyCtxt`されます。
<!--Future evaluations of the same constants will not actually invoke miri, but just extract the value from the interned allocation.-->
同じ定数の将来の評価は、実際にはmiriを呼び出すのではなく、インターナショナル割り当てから値を抽出するだけです。

<!--The `tcx.const_eval` function has one additional feature: it will not return a `ByRef(interned_allocation_id)`, but a `ByVal(computed_value)` if possible.-->
`tcx.const_eval`関数には、`ByRef(interned_allocation_id)` `tcx.const_eval` `ByRef(interned_allocation_id)`が返されるのではなく、可能な場合は`ByVal(computed_value)`が返されるという追加機能があります。
<!--This makes using the result much more convenient, as no further queries need to be executed in order to get at something as simple as a `usize`.-->
これにより、`usize`ような単純なものを得るためにクエリを実行する必要がないため、結果をより便利に使用できます。

## <!--Datastructures--> データ構造

<!--Miri's core datastructures can be found in [librustc/mir/interpret](https://github.com/rust-lang/rust/blob/master/src/librustc/mir/interpret).-->
Miriのコアデータ構造は[librustc/mir/interpret](https://github.com/rust-lang/rust/blob/master/src/librustc/mir/interpret)ます。
<!--This is mainly the error enum and the `Value` and `PrimVal` types.-->
これは、主にエラー列挙型と`Value`および`PrimVal`型です。
<!--A `Value` can be either `ByVal` (a single `PrimVal`), `ByValPair` (two `PrimVal` s, usually fat pointers or two element tuples) or `ByRef`, which is used for anything else and refers to a virtual allocation.-->
`Value`は、`ByVal`（単一の`PrimVal`）、 `ByValPair`（2つの`PrimVal`、通常はファットポインタまたは2つの要素タプル）または`ByRef`いずれかで、他のものに使用され、仮想割り当てを参照します。
<!--These allocations can be accessed via the methods on `tcx.interpret_interner`.-->
これらの割り当ては、`tcx.interpret_interner`のメソッドを介してアクセスできます。

<!--If you are expecting a numeric result, you can use `unwrap_u64` (panics on anything that can't be representad as a `u64`) or `to_raw_bits` which results in an `Option<u128>` yielding the `ByVal` if possible.-->
数値結果が必要な場合は、`unwrap_u64`（ `u64`として表現できないものについてはパニック）や`to_raw_bits`を使用して、できるだけ`ByVal`を生成する`Option<u128>`を`ByVal`することができます。

## <!--Allocations--> 割り当て

<!--A miri allocation is either a byte sequence of the memory or an `Instance` in the case of function pointers.-->
ミリ割り当ては、メモリのバイトシーケンスか、関数ポインタの場合は`Instance`です。
<!--Byte sequences can additionally contain relocations that mark a group of bytes as a pointer to another allocation.-->
バイトシーケンスには、さらに、別の割り当てへのポインタとしてバイトグループをマークする再配置を含めることができます。
<!--The actual bytes at the relocation refer to the offset inside the other allocation.-->
再配置時の実際のバイトは、他の割り当て内のオフセットを参照します。

<!--These allocations exist so that references and raw pointers have something to point to.-->
これらの割り当ては、参照と生ポインタが指すものがあるように存在します。
<!--There is no global linear heap in which things are allocated, but each allocation (be it for a local variable, a static or a (future) heap allocation) gets its own little memory with exactly the required size.-->
物事が割り当てられるグローバルリニアヒープはありませんが、各割り当て（ローカル変数、静的または将来のヒープ割り当て用）は、必要なサイズのメモリを持っています。
<!--So if you have a pointer to an allocation for a local variable `a`, there is no possible (no matter how unsafe) operation that you can do that would ever change said pointer to a pointer to `b`.-->
したがって、ローカル変数`a`割り当てへのポインタがあれば、`b`へのポインタへのポインタを変更する可能性のある（安全性に関係なく）可能な操作はありません。

## <!--Interpretation--> 解釈

<!--Although the main entry point to constant evaluation is the `tcx.const_eval` query, there are additional functions in [librustc_mir/interpret/const_eval.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_mir/interpret/const_eval/) that allow accessing the fields of a `Value` (`ByRef` or otherwise).-->
定数評価の主なエントリポイントは`tcx.const_eval`クエリですが、[librustc_mir/interpret/const_eval.rs](https://doc.rust-lang.org/nightly/nightly-rustc/rustc_mir/interpret/const_eval/)には`Value`（ `ByRef`など）のフィールドにアクセスするための追加機能があります。
<!--You should never have to access an `Allocation` directly except for translating it to the compilation target (at the moment just LLVM).-->
コンパイル対象に翻訳することを除いて（今のところLLVMのみ）、`Allocation`直接アクセスする必要はありません。

<!--Miri starts by creating a virtual stack frame for the current constant that is being evaluated.-->
Miriは評価されている現在の定数の仮想スタックフレームを作成することから始めます。
<!--There's essentially no difference between a constant and a function with no arguments, except that constants do not allow local (named) variables at the time of writing this guide.-->
本ガイドの作成時には、定数がローカル（名前付き）変数を許可しないという点を除き、定数と関数の間には基本的に違いはありません。

<!--A stack frame is defined by the `Frame` type in [librustc_mir/interpret/eval_context.rs](https://github.com/rust-lang/rust/blob/master/src/librustc_mir/interpret/eval_context.rs) and contains all the local variables memory (`None` at the start of evaluation).-->
スタックフレームは、[librustc_mir/interpret/eval_context.rs](https://github.com/rust-lang/rust/blob/master/src/librustc_mir/interpret/eval_context.rs)の`Frame`タイプで定義され、すべてのローカル変数メモリ（評価の開始時には`None`を含みます。
<!--Each frame refers to the evaluation of either the root constant or subsequent calls to `const fn`.-->
各フレームは、ルート定数またはそれ以降の`const fn`呼び出しの評価を参照します。
<!--The evaluation of another constant simply calls `tcx.const_eval`, which produces an entirely new and independent stack frame.-->
別の定数を評価すると、単純に`tcx.const_eval`が`tcx.const_eval`、全く新しい独立したスタックフレームが生成されます。

<!--The frames are just a `Vec<Frame>`, there's no way to actually refer to a `Frame` 's memory even if horrible shenigans are done via unsafe code.-->
フレームはちょうど`Vec<Frame>`なので、恐ろしい怪物が安全でないコードであっても実際に`Frame`のメモリを参照する方法はありません。
<!--The only memory that can be referred to are `Allocation` s.-->
参照できる唯一のメモリは`Allocation`です。

<!--Miri now calls the `step` method (in [librustc_mir/interpret/step.rs](https://github.com/rust-lang/rust/blob/master/src/librustc_mir/interpret/step.rs)) until it either returns an error or has no further statements to execute.-->
Miriはエラーを返すか、実行する文がなくなるまで`step`メソッド（[librustc_mir/interpret/step.rs](https://github.com/rust-lang/rust/blob/master/src/librustc_mir/interpret/step.rs)）を呼び出します。
<!--Each statement will now initialize or modify the locals or the virtual memory referred to by a local.-->
各ステートメントはローカルまたはローカルで参照される仮想メモリを初期化または変更します。
<!--This might require evaluating other constants or statics, which just recursively invokes `tcx.const_eval`.-->
これは、`tcx.const_eval`再帰的に呼び出す他の定数や統計を評価する必要があるかもしれません。
