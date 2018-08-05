# <!--The `ty` module: representing types--> `ty`モジュール：型の表現

<!--The `ty` module defines how the Rust compiler represents types internally.-->
`ty`モジュールは、Rustコンパイラが型を内部的にどのように表現するかを定義します。
<!--It also defines the *typing context* (`tcx` or `TyCtxt`), which is the central data structure in the compiler.-->
また、*タイピングコンテキスト*（ `tcx`または`TyCtxt`）も定義されてい*ます*。これは、コンパイラの中心的なデータ構造です。

## <!--The tcx and how it uses lifetimes--> tcxとそのライフタイムの使い方

<!--The `tcx` ("typing context") is the central data structure in the compiler.-->
`tcx`（ "typing context"）は、コンパイラの中心的なデータ構造です。
<!--It is the context that you use to perform all manner of queries.-->
これは、あらゆる方法でクエリを実行するために使用するコンテキストです。
<!--The struct `TyCtxt` defines a reference to this shared context:-->
struct `TyCtxt`は、この共有コンテキストへの参照を定義します。

```rust,ignore
tcx: TyCtxt<'a, 'gcx, 'tcx>
#//          --  ----  ----
#//          |   |     |
#//          |   |     innermost arena lifetime (if any)
#//          |   "global arena" lifetime
#//          lifetime of this reference
//  ---------| | | | |最も内側のアリーナ生涯（もしあれば）|この参照の「グローバルアリーナ」生涯
```

<!--As you can see, the `TyCtxt` type takes three lifetime parameters.-->
ご覧のとおり、`TyCtxt`タイプには3つのライフタイムパラメータがあります。
<!--These lifetimes are perhaps the most complex thing to understand about the tcx.-->
これらの寿命はおそらく、tcxについて理解するのに最も複雑なものです。
<!--During Rust compilation, we allocate most of our memory in **arenas**, which are basically pools of memory that get freed all at once.-->
錆のコンパイル中に、私たちは大部分のメモリを**アリーナ**に割り当てます。**アリーナ**は基本的に一度に解放されるメモリのプールです。
<!--When you see a reference with a lifetime like `'tcx` or `'gcx`, you know that it refers to arena-allocated data (or data that lives as long as the arenas, anyhow).-->
`'tcx`や`'gcx` `'tcx`ような生涯の参照を見ると、アリーナが割り当てたデータ（またはアリーナと同じくらい長い間生存しているデータ）を参照していることがわかります。

<!--We use two distinct levels of arenas.-->
我々は2つの異なるレベルのアリーナを使用する。
<!--The outer level is the "global arena".-->
外部レベルは「グローバルアリーナ」です。
<!--This arena lasts for the entire compilation: so anything you allocate in there is only freed once compilation is basically over (actually, when we shift to executing LLVM).-->
このアリーナはコンパイル全体に適用されます。つまり、コンパイルが基本的に終了すると（実際には、LLVMの実行に移ると）、そこに割り当てられるものはすべて解放されます。

<!--To reduce peak memory usage, when we do type inference, we also use an inner level of arena.-->
ピークメモリ使用量を減らすために、型推論を行うときには、内部レベルのアリーナも使用します。
<!--These arenas get thrown away once type inference is over.-->
型推論が終わると、これらのアリーナは投げ捨てられます。
<!--This is done because type inference generates a lot of "throw-away"types that are not particularly interesting after type inference completes, so keeping around those allocations would be wasteful.-->
これは、型推論が型推論の完了後に特に興味深いものではない、多くの "スローアウェイ"型を生成するために行われます。したがって、その割り当てを回避することは無駄です。

<!--Often, we wish to write code that explicitly asserts that it is not taking place during inference.-->
しばしば、推論の間に起こっていないことを明示的に宣言するコードを記述したい。
<!--In that case, there is no "local"arena, and all the types that you can access are allocated in the global arena.-->
その場合、「ローカル」アリーナはなく、アクセスできるすべてのタイプはグローバルアリーナに割り当てられます。
<!--To express this, the idea is to use the same lifetime for the `'gcx` and `'tcx` parameters of `TyCtxt`.-->
これを表現するために、アイデアがために同じ寿命を使用することです`'gcx`と`'tcx`のパラメータ`TyCtxt`。
<!--Just to be a touch confusing, we tend to use the name `'tcx` in such contexts.-->
わかりやすくするために、私たちはこのような文脈で`'tcx`という名前を使う傾向があります。
<!--Here is an example:-->
次に例を示します。

```rust,ignore
fn not_in_inference<'a, 'tcx>(tcx: TyCtxt<'a, 'tcx, 'tcx>, def_id: DefId) {
#    //                                        ----  ----
#    //                                        Using the same lifetime here asserts
#    //                                        that the innermost arena accessible through
#    //                                        this reference *is* the global arena.
    //  --------ここに同じ寿命を使用すると、この参照を介してアクセス可能な最も内側の舞台がグローバルアリーナ*である*と主張しています。
}
```

<!--In contrast, if we want to code that can be usable during type inference, then you need to declare a distinct `'gcx` and `'tcx` lifetime parameter:-->
対照的に、型推論の際に使用できるコードを作成したい場合は、別の`'gcx`および`'tcx` lifetimeパラメータを宣言する必要があります。

```rust,ignore
fn maybe_in_inference<'a, 'gcx, 'tcx>(tcx: TyCtxt<'a, 'gcx, 'tcx>, def_id: DefId) {
#    //                                                ----  ----
#    //                                        Using different lifetimes here means that
#    //                                        the innermost arena *may* be distinct
#    //                                        from the global arena (but doesn't have to be).
    // ここで異なる生涯を使用するということは、最も内側のアリーナ*が*グローバルアリーナとは異なる*かもしれない*ことを意味する（しかし、そうである必要はない）。
}
```

### <!--Allocating and working with types--> 型の割り当てと操作

<!--Rust types are represented using the `Ty<'tcx>` defined in the `ty` module (not to be confused with the `Ty` struct from [the HIR]).-->
錆のタイプは、`ty`モジュールで定義された`Ty<'tcx>`を使って表されます（[the HIR]から[the HIR] `Ty`構造体と混同しないでください）。
<!--This is in fact a simple type alias for a reference with `'tcx` lifetime:-->
これは実際に`'tcx` lifetime： `'tcx`という参照のシンプルな型別名です。

```rust,ignore
pub type Ty<'tcx> = &'tcx TyS<'tcx>;
```

[the HIR]: ./hir.html

<!--You can basically ignore the `TyS` struct – you will basically never access it explicitly.-->
あなたは基本的に`TyS`構造体を無視することができます -基本的には明示的にそれにアクセスすることはありません。
<!--We always pass it by reference using the `Ty<'tcx>` alias – the only exception I think is to define inherent methods on types.-->
私たちは`Ty<'tcx>`エイリアスを使って参照することで常に渡します。タイプに固有のメソッドを定義することが唯一の例外です。
<!--Instances of `TyS` are only ever allocated in one of the rustc arenas (never eg on the stack).-->
`TyS`インスタンスは、錆びたアリーナの1つにしか割り当てられません（スタック上には決して配置されません）。

<!--One common operation on types is to **match** and see what kinds of types they are.-->
タイプの一般的な操作の1つは、どのタイプのタイプであるかを**照合**して確認することです。
<!--This is done by doing `match ty.sty`, sort of like this:-->
これは`match ty.sty`行うことによって行われます。

```rust,ignore
fn test_type<'tcx>(ty: Ty<'tcx>) {
    match ty.sty {
        ty::TyArray(elem_ty, len) => { ... }
        ...
    }
}
```

<!--The `sty` field (the origin of this name is unclear to me; perhaps structural type?) is of type `TypeVariants<'tcx>`, which is an enum defining all of the different kinds of types in the compiler.-->
`sty`フィールド（この名前の由来は私には分かりませんが、おそらく構造型ですか？）は`TypeVariants<'tcx>`型です。これはコンパイラのさまざまな種類のすべてを定義する列挙型です。

> <!--NB inspecting the `sty` field on types during type inference can be risky, as there may be inference variables and other things to consider, or sometimes types are not yet known that will become known later.).-->
> タイプ推論の際にタイプの`sty`フィールドを検査するNBは、推論変数や考慮すべき他のものが存在する可能性があるため、危険である可能性があります。

<!--To allocate a new type, you can use the various `mk_` methods defined on the `tcx`.-->
新しい型を割り当てるために、`tcx`定義されたさまざまな`mk_`メソッドを使用できます。
<!--These have names that correpond mostly to the various kinds of type variants.-->
これらは、主に様々な種類の型変種に対応する名前を持っています。
<!--For example:-->
例えば：

```rust,ignore
let array_ty = tcx.mk_array(elem_ty, len * 2);
```

<!--These methods all return a `Ty<'tcx>` – note that the lifetime you get back is the lifetime of the innermost arena that this `tcx` has access to.-->
これらのメソッドはすべて`Ty<'tcx>`返します。あなたが戻ってきたライフタイムは、この`tcx`がアクセスできる最も内側のアリーナのライフタイムです。
<!--In fact, types are always canonicalized and interned (so we never allocate exactly the same type twice) and are always allocated in the outermost arena where they can be (so, if they do not contain any inference variables or other "temporary"types, they will be allocated in the global arena).-->
実際には、型は常に正規化され、インターンされています（したがって、同じ型を2回も絶対に割り当てません）。そして、できる限り最も外側の領域に割り当てられます（推論変数やその他の "一時的な"彼らはグローバルアリーナに配分される）。
<!--However, the lifetime `'tcx` is always a safe approximation, so that is what you get back.-->
しかし、生涯`'tcx`は常に安全な近似であるため、これが返されます。

> <!--NB.-->
> NB。
> <!--Because types are interned, it is possible to compare them for equality efficiently using `==` – however, this is almost never what you want to do unless you happen to be hashing and looking for duplicates.-->
> 型はインターンされているので、`==`を使用して等価性を効率的に比較することは可能ですが、ハッシュや重複を見つけない限り、これはほとんどあなたがしたいことではありません。
> <!--This is because often in Rust there are multiple ways to represent the same type, particularly once inference is involved.-->
> これは、多くの場合、Rustには同じタイプを表現するための複数の方法があり、特に推論が関与しているからです。
> <!--If you are going to be testing for type equality, you probably need to start looking into the inference code to do it right.-->
> 型の等価性をテストする場合は、おそらくそれを正しく行うために推論コードを調べる必要があります。

<!--You can also find various common types in the `tcx` itself by accessing `tcx.types.bool`, `tcx.types.char`, etc (see `CommonTypes` for more).-->
あなたはまた、様々な一般的なタイプを見つけることができます`tcx`アクセスすることで自分自身を`tcx.types.bool`、 `tcx.types.char`（参照など、 `CommonTypes`多くのため）。

### <!--Beyond types: other kinds of arena-allocated data structures--> 型を超えて：アリーナに割り当てられた他の種類のデータ構造

<!--In addition to types, there are a number of other arena-allocated data structures that you can allocate, and which are found in this module.-->
タイプに加えて、割り当て可能な他のアリーナ割り当てデータ構造があり、このモジュールにはいくつかのものがあります。
<!--Here are a few examples:-->
いくつかの例があります：

- <!--`Substs`, allocated with `mk_substs` – this will intern a slice of types, often used to specify the values to be substituted for generics (eg `HashMap<i32, u32>` would be represented as a slice `&'tcx [tcx.types.i32, tcx.types.u32]`).-->
   `Substs`で割り当てられた`mk_substs` -これは型のスライスをインターンにします。これは一般にジェネリックスの代わりに値を指定するのに使われます（例えば、`HashMap<i32, u32>`はスライスとして表されます`&'tcx [tcx.types.i32, tcx.types.u32]`）。
- <!--`TraitRef`, typically passed by value – a **trait reference** consists of a reference to a trait along with its various type parameters (including `Self`), like `i32: Display` (here, the def-id would reference the `Display` trait, and the substs would contain `i32`).-->
   `TraitRef`、典型的には値によって渡される -**形質参照**は、`i32: Display`（ここでは、def-idは`Display`形質を参照するだろう）のような様々な型パラメータ（`Self`を含む）`i32`）。
- <!--`Predicate` defines something the trait system has to prove (see `traits` module).-->
   `Predicate`は、形質システムが証明しなければならないものを定義します（`traits`モジュールを参照）。

### <!--Import conventions--> インポート規則

<!--Although there is no hard and fast rule, the `ty` module tends to be used like so:-->
`ty`高速なルールはありませんが、`ty`モジュールは次のように使用される傾向があります。

```rust,ignore
use ty::{self, Ty, TyCtxt};
```

<!--In particular, since they are so common, the `Ty` and `TyCtxt` types are imported directly.-->
特に、それらは非常に一般的であるため、`Ty`および`TyCtxt`タイプは直接インポートされます。
<!--Other types are often referenced with an explicit `ty::` prefix (eg `ty::TraitRef<'tcx>`).-->
他の型は、しばしば明示的な`ty::`接頭辞（例えば、`ty::TraitRef<'tcx>`）で参照されます。
<!--But some modules choose to import a larger or smaller set of names explicitly.-->
しかし、いくつかのモジュールは、より大きなまたはより小さな名前セットを明示的にインポートすることを選択します。
