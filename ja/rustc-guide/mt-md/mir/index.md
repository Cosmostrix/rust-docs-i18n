# <!--The MIR (Mid-level IR)--> MIR（ミッドレベルIR）は、

<!--MIR is Rust's  _Mid-level Intermediate Representation_ .-->
MIRはRustの _中級中間表現_ です。
<!--It is constructed from [HIR](./hir.html).-->
それは[HIR](./hir.html)から構築されます。
<!--MIR was introduced in [RFC 1211].-->
MIRは[RFC 1211]導入され[RFC 1211]。
<!--It is a radically simplified form of Rust that is used for certain flow-sensitive safety checks – notably the borrow checker!-->
これは、特定の流量に敏感な安全点検に使用される根本的に単純化された形のRustです。
<!--– and also for optimization and code generation.-->
-最適化とコード生成のために。

<!--If you'd like a very high-level introduction to MIR, as well as some of the compiler concepts that it relies on (such as control-flow graphs and desugaring), you may enjoy the [rust-lang blog post that introduced MIR][blog].-->
MIRを非常に高レベルで紹介したいと思っているならば、それが依存しているコンパイラの概念（コントロールフローグラフやデッサージなど）のいくつかと同様に、MIRを紹介した[rust-langのブログ記事を][blog]楽しむことができます。

[blog]: https://blog.rust-lang.org/2016/04/19/MIR.html

## <!--Introduction to MIR--> MIR入門

<!--MIR is defined in the [`src/librustc/mir/`][mir] module, but much of the code that manipulates it is found in [`src/librustc_mir`][mirmanip].-->
MIRは、で定義されている[`src/librustc/mir/`][mir]モジュールが、それを操作するコードの多くは中に発見された[`src/librustc_mir`][mirmanip]。

[RFC 1211]: http://rust-lang.github.io/rfcs/1211-mir.html

<!--Some of the key characteristics of MIR are:-->
MIRの主な特徴のいくつかは次のとおりです。

- <!--It is based on a [control-flow graph][cfg].-->
   これは、[制御フローグラフに][cfg]基づいてい[ます][cfg]。
- <!--It does not have nested expressions.-->
   ネストされた式はありません。
- <!--All types in MIR are fully explicit.-->
   MIRのすべてのタイプは完全に明示的です。

[cfg]: ./appendix/background.html#cfg

## <!--Key MIR vocabulary--> キーミル語彙

<!--This section introduces the key concepts of MIR, summarized here:-->
このセクションでは、MIRの主要概念を紹介します。

- <!--**Basic blocks**: units of the control-flow graph, consisting of:-->
   **基本ブロック**：コントロールフローグラフの単位。
  - <!--**statements:** actions with one successor-->
     **ステートメント：** 1つの後継アクション
  - <!--**terminators:** actions with potentially multiple successors;-->
     **ターミネータ：**潜在的に複数の後継者を伴うアクション。
<!--always at the end of a block-->
     いつもブロックの終わりに
  - <!--(if you're not familiar with the term *basic block*, see the [background chapter][cfg])-->
     （*基本ブロック*という用語に慣れていない場合は、[背景の章を][cfg]参照してください）
- <!--**Locals:** Memory locations alloated on the stack (conceptually, at least), such as function arguments, local variables, and temporaries.-->
   **ローカル：**関数の引数、ローカル変数、一時変数など、スタック上にアロケーションされたメモリの場所（概念的には、少なくとも）。
<!--These are identified by an index, written with a leading underscore, like `_1`.-->
   これらは`_1`ような先頭のアンダースコアで書かれたインデックスによって識別されます。
<!--There is also a special "local"(`_0`) allocated to store the return value.-->
   戻り値を格納するために割り当てられた特別な "ローカル"（`_0`）もあります。
- <!--**Places:** expressions that identify a location in memory, like `_1` or `_1.f`.-->
   **Places：** `_1`や`_1.f`ようなメモリ上の場所を識別する式。
- <!--**Rvalues:** expressions that produce a value.-->
   **Rvalues：**値を生成する式。
<!--The "R"stands for the fact that these are the "right-hand side"of an assignment.-->
   「R」は、これらが課題の「右側」であるという事実を表しています。
  - <!--**Operands:** the arguments to an rvalue, which can either be a constant (like `22`) or a place (like `_1`).-->
     **オペランド：** rvalueへの引数。定数（`22`）または場所（ `_1`）のいずれかになります。

<!--You can get a feeling for how MIR is structed by translating simple programs into MIR and reading the pretty printed output.-->
簡単なプログラムをMIRに翻訳し、きれいに印刷された出力を読むことで、MIRがどのように構成されているかを知ることができます。
<!--In fact, the playground makes this easy, since it supplies a MIR button that will show you the MIR for your program.-->
実際には、あなたのプログラムのMIRを表示するMIRボタンを提供しているため、プレイグラウンドでこれを簡単に行うことができます。
<!--Try putting this program into play (or [clicking on this link][sample-play]), and then clicking the "MIR"button on the top:-->
このプログラムをプレイしてみてください（または[このリンクをクリックしてください][sample-play]）。そして上の "MIR"ボタンをクリックしてください：

[sample-play]: https://play.rust-lang.org/?gist=30074856e62e74e91f06abd19bd72ece&version=stable

```rust
fn main() {
    let mut vec = Vec::new();
    vec.push(1);
    vec.push(2);
}
```

<!--You should see something like:-->
次のようなものが表示されます。

```mir
#// WARNING: This output format is intended for human consumers only
#// and is subject to change without notice. Knock yourself out.
// 警告：この出力形式は、人間の消費者のみを対象としており、予告なしに変更されることがあります。自分をノックアウトしてください。
fn main() -> () {
    ...
}
```

<!--This is the MIR format for the `main` function.-->
これは`main`関数のMIR形式です。

<!--**Variable declarations.**-->
**変数の宣言。**
<!--If we drill in a bit, we'll see it begins with a bunch of variable declarations.-->
少し掘り下げれば、変数の宣言が始まっていることがわかります。
<!--They look like this:-->
彼らはこのように見えます：

```mir
#//let mut _0: ();                      // return place
let mut _0: ();                      // 戻り場所
scope 1 {
#//    let mut _1: std::vec::Vec<i32>;  // "vec" in scope 1 at src/main.rs:2:9: 2:16
    let mut _1: std::vec::Vec<i32>;  // 範囲1のsrc / main.rs：2：9：2:16の "vec"
}
scope 2 {
}
let mut _2: ();
let mut _3: &mut std::vec::Vec<i32>;
let mut _4: ();
let mut _5: &mut std::vec::Vec<i32>;
```

<!--You can see that variables in MIR don't have names, they have indices, like `_0` or `_1`.-->
MIRの変数には名前がなく、`_0`や`_1`ようなインデックスがあることがわかります。
<!--We also intermingle the user's variables (eg, `_1`) with temporary values (eg, `_2` or `_3`).-->
また、ユーザの変数（`_1`）と一時的な値（ `_2`や`_3`）が混在しています。
<!--You can tell the difference between user-defined variables have a comment that gives you their original name (`// "vec" in scope 1...`).-->
ユーザー定義の変数の違いに、元の名前（`// "vec" in scope 1...`）を与えるコメントがあることが`// "vec" in scope 1...`。
<!--The "scope"blocks (eg, `scope 1 { .. }`) describe the lexical structure of the source program (which names were in scope when).-->
"scope"ブロック（例えば`scope 1 { .. }`）は、ソースプログラムの語彙構造を記述し`scope 1 { .. }`（名前はいつスコープに入ったのか）。

<!--**Basic blocks.**-->
**基本ブロック。**
<!--Reading further, we see our first **basic block** (naturally it may look slightly different when you view it, and I am ignoring some of the comments):-->
さらに読むと、最初の**基本ブロック**が表示されます（実際に見ると少し違って見えるかもしれませんが、私はいくつかのコメントを無視しています）。

```mir
bb0: {
    StorageLive(_1);
    _1 = const <std::vec::Vec<T>>::new() -> bb2;
}
```

<!--A basic block is defined by a series of **statements** and a final **terminator**.-->
基本ブロックは、一連の**ステートメント**と最終的な**ターミネータ**で定義され**ます**。
<!--In this case, there is one statement:-->
この場合、1つのステートメントがあります。

```mir
StorageLive(_1);
```

<!--This statement indicates that the variable `_1` is "live", meaning that it may be used later – this will persist until we encounter a `StorageDead(_1)` statement, which indicates that the variable `_1` is done being used.-->
このステートメントは、変数`_1`が "live"であることを示します。これは、後で使用されることを意味します`StorageDead(_1)`ステートメントが出現するまで持続し、`_1`変数の使用が完了したことを示します。
<!--These "storage statements"are used by LLVM to allocate stack space.-->
これらの「ストレージステートメント」は、スタックスペースを割り当てるためにLLVMによって使用されます。

<!--The **terminator** of the block `bb0` is the call to `Vec::new`:-->
ブロックの**終端** `bb0`呼び出しです`Vec::new`：

```mir
_1 = const <std::vec::Vec<T>>::new() -> bb2;
```

<!--Terminators are different from statements because they can have more than one successor – that is, control may flow to different places.-->
ターミネータはステートメントとは異なります。ステートメントは複数の後継を持つことができます。つまり、制御が異なる場所に流れることがあります。
<!--Function calls like the call to `Vec::new` are always terminators because of the possibility of unwinding, although in the case of `Vec::new` we are able to see that indeed unwinding is not possible, and hence we list only one succssor block, `bb2`.-->
`Vec::new`呼び出しのような関数呼び出しは、巻き戻しの可能性があるため、常にターミネータです`Vec::new`場合、実際に巻き戻しが不可能であることがわかります。したがって、succssorブロックを1つだけリストします。`bb2`。

<!--If we look ahead to `bb2`, we will see it looks like this:-->
`bb2`を先読みすると、次のようになります。

```mir
bb2: {
    StorageLive(_3);
    _3 = &mut _1;
    _2 = const <std::vec::Vec<T>>::push(move _3, const 1i32) -> [return: bb3, unwind: bb4];
}
```

<!--Here there are two statements: another `StorageLive`, introducing the `_3` temporary, and then an assignment:-->
ここには2つのステートメントがあります：別の`StorageLive`、 `_3`一時的な導入、そして割り当て：

```mir
_3 = &mut _1;
```

<!--Assignments in general have the form:-->
割り当ては一般的に次の形式です。

```text
<Place> = <Rvalue>
```

<!--A place is an expression like `_3`, `_3.f` or `*_3` – it denotes a location in memory.-->
場所は`_3`、 `_3.f`または`*_3`ような式です。これはメモリ内の場所を表します。
<!--An **Rvalue** is an expression that creates a value: in this case, the rvalue is a mutable borrow expression, which looks like `&mut <Place>`.-->
**Rvalue**は値を作成する式です。この場合、**rvalue**は可変の借用式で、`&mut <Place>`ます。
<!--So we can kind of define a grammar for rvalues like so:-->
ですから、右辺の文法を次のように定義することができます：

```text
<Rvalue>  = & (mut)? <Place>
          | <Operand> + <Operand>
          | <Operand> - <Operand>
          | ...

<Operand> = Constant
          | copy Place
          | move Place
```

<!--As you can see from this grammar, rvalues cannot be nested – they can only reference places and constants.-->
この文法からわかるように、右辺値は入れ子にできません。右辺値と定数のみを参照できます。
<!--Moreover, when you use a place, we indicate whether we are **copying it** (which requires that the place have a type `T` where `T: Copy`) or **moving it** (which works for a place of any type).-->
あなたの場所を使用するときにまた、我々は（場所はタイプ持っていることを必要とし、我々は**それをコピーし**ているかどうかを示す`T` `T: Copy`（任意の型の場所のために動作します）か、 **それを移動します**）。
<!--So, for example, if we had the expression `x = a + b + c` in Rust, that would get compile to two statements and a temporary:-->
たとえば、Rustに`x = a + b + c`の式があれば、それは2つの文と1つの一時的な文にコンパイルされます。

```mir
TMP1 = a + b
x = TMP1 + c
```

<!--([Try it and see][play-abc], though you may want to do release mode to skip over the overflow checks.)-->
（オーバーフローチェックをスキップするためにリリースモードを実行したいかもしれませんが、[試してみてください][play-abc]）。

[play-abc]: https://play.rust-lang.org/?gist=1751196d63b2a71f8208119e59d8a5b6&version=stable

## <!--MIR data types--> MIRデータ型

<!--The MIR data types are defined in the [`src/librustc/mir/`][mir] module.-->
MIRデータ型は、[`src/librustc/mir/`][mir]モジュールで定義されています。
<!--Each of the key concepts mentioned in the previous section maps in a fairly straightforward way to a Rust type.-->
前のセクションで述べた主要な概念のそれぞれは、Rust型へのかなり単純な方法でマップします。

<!--The main MIR data type is `Mir`.-->
主なMIRデータ型は`Mir`です。
<!--It contains the data for a single function (along with sub-instances of Mir for "promoted constants", but [you can read about those below](#promoted)).-->
これには、単一の関数のデータが含まれています（昇格された定数の場合は、Mirのサブインスタンスとともに表示され[ますが](#promoted)、 [以下でそれらについて読むことができます](#promoted)）。

- <!--**Basic blocks**: The basic blocks are stored in the field `basic_blocks`;-->
   **基本ブロック**：基本ブロックはフィールド`basic_blocks`格納されます。
<!--this is a vector of `BasicBlockData` structures.-->
   これは`BasicBlockData`構造体のベクトルです。
<!--Nobody ever references a basic block directly: instead, we pass around `BasicBlock` values, which are [newtype'd] indices into this vector.-->
   誰も基本ブロックを直接参照することはありません。代わりに、このベクトルに[newtype'd]インデックスである`BasicBlock`値を渡します。
- <!--**Statements** are represented by the type `Statement`.-->
   **ステートメント**は、`Statement`によって表されます。
- <!--**Terminators** are represented by the `Terminator`.-->
   **ターミネータ**は、`Terminator`によって表されます。
- <!--**Locals** are represented by a [newtype'd] index type `Local`.-->
   **ローカル**は、[newtype'd]タイプのインデックスタイプ`Local`によって表されます。
<!--The data for a local variable is found in the `Mir` (the `local_decls` vector).-->
   ローカル変数のデータは、`Mir`（ `local_decls`ベクトル）にあります。
<!--There is also a special constant `RETURN_PLACE` identifying the special "local"representing the return value.-->
   戻り値を表す特殊な "ローカル"を特定する特別な定数`RETURN_PLACE`もあります。
- <!--**Places** are identified by the enum `Place`.-->
   **場所**はenum `Place`によって識別されます。
<!--There are a few variants:-->
   いくつかの亜種があります：
  - <!--Local variables like `_1`-->
     `_1`などのローカル変数
  - <!--Static variables `FOO`-->
     静的変数`FOO`
  - <!--**Projections**, which are fields or other things that "project out"from a base place.-->
     **プロジェクション**は、ベースの場所から「突出した」フィールドまたは他のものです。
<!--So eg the place `_1.f` is a projection, with `f` being the "projection element and `_1` being the base path. `*_1` is also a projection, with the `*` being represented by the `ProjectionElem::Deref` element.-->
     したがって、例えば`_1.f`の場所は投影であり、`f`は "投影要素"であり、`_1`は基本パスである。`*_1`は投影でもあり、`*`は`ProjectionElem::Deref`要素で表される。
- <!--**Rvalues** are represented by the enum `Rvalue`.-->
   **Rvalue**は列挙`Rvalue`表されます。
- <!--**Operands** are represented by the enum `Operand`.-->
   **オペランド**は列挙型`Operand`表されます。

## <!--Representing constants--> 定数を表す

<!--*to be written*-->
*書かれる*

<span id="promoted"></span>
### <!--Promoted constants--> プロモート定数

<!--*to be written*-->
*書かれる*


<!--[mir]: https://github.com/rust-lang/rust/tree/master/src/librustc/mir
 [mirmanip]: https://github.com/rust-lang/rust/tree/master/src/librustc_mir
 [mir]: https://github.com/rust-lang/rust/tree/master/src/librustc/mir
 [newtype'd]: appendix/glossary.html
-->
[mir]: https://github.com/rust-lang/rust/tree/master/src/librustc/mir
 [mirmanip]: https://github.com/rust-lang/rust/tree/master/src/librustc_mir
 [mir]: https://github.com/rust-lang/rust/tree/master/src/librustc/mir
 [newtype'd]: appendix/glossary.html

