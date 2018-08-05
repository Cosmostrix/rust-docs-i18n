# <!--Appendix C: Glossary--> 付録C：用語集

<!--The compiler uses a number of...idiosyncratic abbreviations and things.-->
コンパイラは、いくつかの特有の略語を使用します。
<!--This glossary attempts to list them and give you a few pointers for understanding them better.-->
この用語集では、それらをリストアップし、それらをよりよく理解するためのいくつかの指針を示しています。

<!--Term |-->
ターム|
<!--Meaning ------------------------|--------AST |-->
意味------------------------| --------AST |
<!--the abstract syntax tree produced by the syntax crate;-->
構文crateによって生成された抽象構文木。
<!--reflects user syntax very closely.-->
ユーザーの構文を非常によく反映しています。
<!--binder |-->
バインダー|
<!--a "binder"is a place where a variable or type is declared;-->
「バインダー」は、変数または型が宣言されている場所です。
<!--for example, the `<T>` is a binder for the generic type parameter `T` in `fn foo<T>(..)`, and \|-->
たとえば、`<T>`は`fn foo<T>(..)`の汎用型パラメータ`T`バインダであり、\ |
<!--`a` \|-->
\ |
<!--`...` is a binder for the parameter `a`.-->
`...`パラメータのための結合剤である`a`。
<!--See [the background chapter for more](./appendix/background.html#free-vs-bound) bound variable |-->
[より多くの](./appendix/background.html#free-vs-bound)バウンド変数について[は、背景の章を](./appendix/background.html#free-vs-bound)参照してください。
<!--a "bound variable"is one that is declared within an expression/term.-->
「束縛された変数」は、式/項内で宣言された変数です。
<!--For example, the variable `a` is bound within the closure expession \|-->
たとえば、変数`a`はクロージャexpiration \ |内にバインドされています。
<!--`a` \|-->
\ |
<!--`a * 2`.-->
`a * 2`。
<!--See [the background chapter for more](./appendix/background.html#free-vs-bound) codegen |-->
codegenの詳細について[は、背景の章を](./appendix/background.html#free-vs-bound)参照してください。
<!--the code to translate MIR into LLVM IR.-->
MIRをLLVM IRに変換するコード。
<!--codegen unit |-->
|コードギアユニット|
<!--when we produce LLVM IR, we group the Rust code into a number of codegen units.-->
LLVM IRを生成するとき、Rustコードをいくつかのcodegenユニットにグループ化します。
<!--Each of these units is processed by LLVM independently from one another, enabling parallelism.-->
これらのユニットのそれぞれは、互いに独立してLLVMによって処理され、並列性を可能にします。
<!--They are also the unit of incremental re-use.-->
これらはまた、増分再利用の単位でもあります。
<!--completeness |-->
|完全性|
<!--completeness is a technical term in type theory.-->
完全性は型理論における専門用語である。
<!--Completeness means that every type-safe program also type-checks.-->
完全性とは、すべての型保証型プログラムが型チェックも意味します。
<!--Having both soundness and completeness is very hard, and usually soundness is more important.-->
健全性と完全性の両方を持つことは非常に難しく、通常は健全性が重要です。
<!--(see "soundness").-->
（「健全性」を参照）。
<!--control-flow graph |-->
制御フローグラフ|
<!--a representation of the control-flow of a program;-->
プログラムの制御フローの表現。
<!--see [the background chapter for more](./appendix/background.html#cfg) CTFE |-->
CTFEの詳細について[は、背景の章を](./appendix/background.html#cfg)参照してください。
<!--Compile-Time Function Evaluation.-->
コンパイル時関数評価。
<!--This is the ability of the compiler to evaluate `const fn` s at compile time.-->
これはコンパイラがコンパイル時に`const fn`を評価する能力です。
<!--This is part of the compiler's constant evaluation system.-->
これは、コンパイラの定数評価システムの一部です。
<!--([see more](./const-eval.html)) cx |-->
（[もっと見る](./const-eval.html)）cx |
<!--we tend to use "cx"as an abbrevation for context.-->
文脈の省略形として「cx」を使用する傾向があります。
<!--See also `tcx`, `infcx`, etc. DAG |-->
`tcx`、 `infcx`なども参照してください`tcx` |
<!--a directed acyclic graph is used during compilation to keep track of dependencies between queries.-->
クエリ間の依存関係を追跡するために、コンパイル中に有向非循環グラフが使用されます。
<!--([see more](incremental-compilation.html)) data-flow analysis |-->
（[詳細はこちらを参照](incremental-compilation.html)）データフロー分析|
<!--a static analysis that figures out what properties are true at each point in the control-flow of a program;-->
プログラムの制御フローの各ポイントでどのプロパティが真であるかを示す静的解析。
<!--see [the background chapter for more](./appendix/background.html#dataflow) DefId |-->
DefIdの詳細について[は、背景の章を](./appendix/background.html#dataflow)参照してください。
<!--an index identifying a definition (see `librustc/hir/def_id.rs`).-->
定義を識別するインデックス（`librustc/hir/def_id.rs`参照）。
<!--Uniquely identifies a `DefPath`.-->
`DefPath`識別し`DefPath`。
<!--Double pointer |-->
ダブルポインタ|
<!--a pointer with additional metadata.-->
追加のメタデータを持つポインタ。
<!--See "fat pointer"for more.-->
詳細については、「ファットポインタ」を参照してください。
<!--DST |-->
DST |
<!--Dynamically-Sized Type.-->
ダイナミックサイジングタイプ。
<!--A type for which the compiler cannot statically know the size in memory (eg `str` or `[u8]`).-->
コンパイラがメモリ内のサイズを静的に知ることができない型（`str`や`[u8]`）。
<!--Such types don't implement `Sized` and cannot be allocated on the stack.-->
そのような型は`Sized`を実装しておらず、スタックには割り当てられません。
<!--They can only occur as the last field in a struct.-->
それらは構造体の最後のフィールドとしてのみ発生します。
<!--They can only be used behind a pointer (eg `&str` or `&[u8]`).-->
ポインタの後ろでのみ使用できます（例えば、`&str`または`&[u8]`）。
<!--empty type |-->
空のタイプ|
<!--see "uninhabited type".-->
「無人タイプ」を参照してください。
<!--Fat pointer |-->
ファットポインタ|
<!--a two word value carrying the address of some value, along with some further information necessary to put the value to use.-->
ある値のアドレスを持つ2ワードの値と、その値を使用するために必要ないくつかのさらなる情報。
<!--Rust includes two kinds of "fat pointers": references to slices, and trait objects.-->
錆には2種類の「脂肪ポインタ」が含まれています：スライスへの参照と形質オブジェクトです。
<!--A reference to a slice carries the starting address of the slice and its length.-->
スライスへの参照は、スライスの開始アドレスとその長さを保持します。
<!--A trait object carries a value's address and a pointer to the trait's implementation appropriate to that value.-->
特性オブジェクトは、値のアドレスと、その値に適した特性の実装へのポインタを持ちます。
<!--"Fat pointers"are also known as "wide pointers", and "double pointers".-->
「脂肪ポインタ」は、「ワイドポインタ」および「ダブルポインタ」としても知られています。
<!--free variable |-->
|無料の変数|
<!--a "free variable"is one that is not bound within an expression or term;-->
"自由変数"とは、式や用語の中に拘束されていない変数です。
<!--see [the background chapter for more](./appendix/background.html#free-vs-bound) 'gcx |-->
詳細について[は、背景の章を](./appendix/background.html#free-vs-bound)参照してください。
<!--the lifetime of the global arena ([see more](ty.html)) generics |-->
グローバルアリーナの生涯（[もっと見る](ty.html)）ジェネリック|
<!--the set of generic type parameters defined on a type or item HIR |-->
型または項目に定義されたジェネリック型パラメータのセットHIR |
<!--the High-level IR, created by lowering and desugaring the AST ([see more](hir.html)) HirId |-->
ASTを下げ、脱獄して作成したハイレベルIR（[詳細はこちら](hir.html)）HirId |
<!--identifies a particular node in the HIR by combining a def-id with an "intra-definition offset".-->
def-idと「intra-definition offset」とを組み合わせることにより、HIR内の特定のノードを識別する。
<!--HIR Map |-->
HIRマップ|
<!--The HIR map, accessible via tcx.hir, allows you to quickly navigate the HIR and convert between various forms of identifiers.-->
tcx.hirを介してアクセス可能なHIRマップを使用すると、HIRをすばやく移動し、さまざまな形式の識別子間で変換できます。
<!--ICE |-->
ICE |
<!--internal compiler error.-->
内部コンパイラエラー。
<!--When the compiler crashes.-->
コンパイラがクラッシュしたとき。
<!--ICH |-->
ICH |
<!--incremental compilation hash.-->
増分コンパイルハッシュ。
<!--ICHs are used as fingerprints for things such as HIR and crate metadata, to check if changes have been made.-->
ICHは、HIRやcrateメタデータなどのために指紋として使用され、変更が加えられたかどうかを確認します。
<!--This is useful in incremental compilation to see if part of a crate has changed and should be recompiled.-->
これは増分コンパイルで、クレートの一部が変更され、再コンパイルする必要があるかどうかを確認するのに便利です。
<!--inference variable |-->
推論変数|
<!--when doing type or region inference, an "inference variable"is a kind of special type/region that represents what you are trying to infer.-->
タイプまたは領域の推論を行うとき、「推論変数」は、あなたが推測しようとしているものを表す特別な型/領域の一種です。
<!--Think of X in algebra.-->
Xを代数で考える。
<!--For example, if we are trying to infer the type of a variable in a program, we create an inference variable to represent that unknown type.-->
たとえば、プログラム内の変数の型を推測しようとすると、その未知の型を表す推論変数が作成されます。
<!--infcx |-->
infcx |
<!--the inference context (see `librustc/infer`) IR |-->
推論のコンテキスト（`librustc/infer`参照）IR |
<!--Intermediate Representation.-->
中間表現。
<!--A general term in compilers.-->
コンパイラの一般的な用語。
<!--During compilation, the code is transformed from raw source (ASCII text) to various IRs.-->
コンパイル時には、コードは生ソース（ASCIIテキスト）からさまざまなIRに変換されます。
<!--In Rust, these are primarily HIR, MIR, and LLVM IR.-->
Rustでは、これらは主にHIR、MIR、およびLLVM IRです。
<!--Each IR is well-suited for some set of computations.-->
各IRは、いくつかの計算セットに適しています。
<!--For example, MIR is well-suited for the borrow checker, and LLVM IR is well-suited for codegen because LLVM accepts it.-->
たとえば、MIRは貸借チェッカーに適しており、LLVM IRはそれを受け入れるのでcodegenに適しています。
<!--local crate |-->
|
<!--the crate currently being compiled.-->
現在コンパイルされています。
<!--LTO |-->
LTO |
<!--Link-Time Optimizations.-->
リンク時の最適化。
<!--A set of optimizations offered by LLVM that occur just before the final binary is linked.-->
最終バイナリがリンクされる直前に発生するLLVMによって提供される一連の最適化。
<!--These include optmizations like removing functions that are never used in the final program, for example.-->
これには、最終的なプログラムでは使用されなかった機能の削除などのオプティマイゼーションが含まれます。
<!-- _ThinLTO_  is a variant of LTO that aims to be a bit more scalable and efficient, but possibly sacrifices some optimizations.-->
 _ThinLTO_ は、よりスケーラブルで効率的なものを目指すLTOの変種ですが、いくつかの最適化を犠牲にする可能性があります。
<!--You may also read issues in the Rust repo about "FatLTO", which is the loving nickname given to non-Thin LTO.-->
非薄型LTOに与えられた愛らしいニックネームである「FatLTO」についての錆レポの問題も読むことができます。
<!--LLVM documentation: [here][lto] and [here][thinlto] [LLVM] |-->
LLVMのドキュメント： [here][lto] and [here][thinlto] [LLVM] |
<!--(actually not an acronym:P) an open-source compiler backend.-->
（実際に頭字語ではありません：P）オープンソースコンパイラバックエンド。
<!--It accepts LLVM IR and outputs native binaries.-->
LLVM IRを受け入れ、ネイティブバイナリを出力します。
<!--Various languages (eg Rust) can then implement a compiler front-end that output LLVM IR and use LLVM to compile to all the platforms LLVM supports.-->
さまざまな言語（例えばRust）では、LLVM IRを出力するコンパイラフロントエンドを実装し、LLVMを使用してLLVMがサポートするすべてのプラットフォームにコンパイルできます。
<!--MIR |-->
ミル|
<!--the Mid-level IR that is created after type-checking for use by borrowck and codegen ([see more](./mir/index.html)) miri |-->
borrowckとcodegenが使用する型チェックの後に作成される中間レベルのIR（[詳細はこちら](./mir/index.html)）miri |
<!--an interpreter for MIR used for constant evaluation ([see more](./miri.html)) normalize |-->
一定の評価に使用されるMIRのためのインタプリタ（[もっと見る](./miri.html)）normalize |
<!--a general term for converting to a more canonical form, but in the case of rustc typically refers to [associated type normalization](./traits/associated-types.html#normalize) newtype |-->
より標準的な形式に変換する一般的な用語ですが、rustcの場合、通常、[関連付けられた型正規化を参照しています](./traits/associated-types.html#normalize) newtype |
<!--a "newtype"is a wrapper around some other type (eg, `struct Foo(T)` is a "newtype"for `T`).-->
「newtypeのは、」他のいくつかのタイプのラッパーである（例えば、`struct Foo(T)`のための「のnewtype」である`T`）。
<!--This is commonly used in Rust to give a stronger type for indices.-->
これは、インデックスのためのより強い型を与えるためにRustでよく使用されます。
<!--NLL |-->
NLL |
<!--[non-lexical lifetimes](./mir/regionck.html), an extension to Rust's borrowing system to make it be based on the control-flow graph.-->
[非語彙的寿命は](./mir/regionck.html)、錆の借入システムへの拡張は、それが制御フローグラフに基づいて行うことにします。
<!--node-id or NodeId |-->
node-idまたはNodeId |
<!--an index identifying a particular node in the AST or HIR;-->
ASTまたはHIR内の特定のノードを識別するインデックス。
<!--gradually being phased out and replaced with `HirId`.-->
徐々に段階的に廃止され、`HirId`と置き換えられ`HirId`。
<!--obligation |-->
義務|
<!--something that must be proven by the trait system ([see more](traits/resolution.html)) projection |-->
形質システムによって証明されなければならないもの（[詳細はこちら](traits/resolution.html)）
<!--a general term for a "relative path", eg `xf` is a "field projection", and `T::Item` is an ["associated type projection"](./traits/goals-and-clauses.html#trait-ref) promoted constants |-->
例えば、`xf`は「フィールド投影法」であり、`T::Item`は[「関連する型投影法」で](./traits/goals-and-clauses.html#trait-ref)ある。
<!--constants extracted from a function and lifted to static scope;-->
関数から抽出され、静的スコープに持ち上げられた定数。
<!--see [this section](./mir/index.html#promoted) for more details.-->
詳細については、[このセクション](./mir/index.html#promoted)を参照してください。
<!--provider |-->
プロバイダー|
<!--the function that executes a query ([see more](query.html)) quantified |-->
クエリを実行する関数（[詳細はを見てください](query.html)）
<!--in math or logic, existential and universal quantification are used to ask questions like "is there any type T for which is true?"-->
数学や論理では、実在的で普遍的な定量化は、「どのタイプTが真であるか」のような質問をするために使われます。
<!--or "is this true for all types T?";-->
または "これはすべてのタイプTに当てはまりますか？"
<!--see [the background chapter for more](./appendix/background.html#quantified) query |-->
[より多くの](./appendix/background.html#quantified)クエリの[背景の章を](./appendix/background.html#quantified)参照してください|
<!--perhaps some sub-computation during compilation ([see more](query.html)) region |-->
おそらくコンパイル中のいくつかの部分計算（[もっと見る](query.html)）
<!--another term for "lifetime"often used in the literature and in the borrow checker.-->
文学や借用チェッカーでよく使われる「生涯」の別の用語。
<!--rib |-->
リブ|
<!--a data structure in the name resolver that keeps track of a single scope for names.-->
名前の単一スコープを追跡する名前リゾルバ内のデータ構造体。
<!--([see more](./name-resolution.html)) sess |-->
（[もっと見る](./name-resolution.html)）sess |
<!--the compiler session, which stores global data used throughout compilation side tables |-->
コンパイル・サイド・テーブル全体で使用されるグローバル・データを格納するコンパイラ・セッション|
<!--because the AST and HIR are immutable once created, we often carry extra information about them in the form of hashtables, indexed by the id of a particular node.-->
ASTとHIRはいったん作成されると不変であるため、特定のノードのIDでインデックス付けされたハッシュテーブルの形で、それらに関する余分な情報を運ぶことがよくあります。
<!--sigil |-->
シギル|
<!--like a keyword but composed entirely of non-alphanumeric tokens.-->
キーワードのように、英数字以外のトークンで完全に構成されています。
<!--For example, `&` is a sigil for references.-->
たとえば、`&`は参照のためのsigilです。
<!--skolemization |-->
| skolemization |
<!--a way of handling subtyping around "for-all"types (eg, `for<'a> fn(&'a u32)`) as well as solving higher-ranked trait bounds (eg, `for<'a> T: Trait<'a>`).-->
（例えば、`for<'a> fn(&'a u32)`）、さらには上位の特性境界を解決する場合（例えば、 `for<'a> T: Trait<'a>`）。
<!--See [the chapter on skolemization and universes](./mir/regionck.html#skol) for more details.-->
詳細について[は、スカレを](./mir/regionck.html#skol)参照してください。
<!--soundness |-->
健全性|
<!--soundness is a technical term in type theory.-->
健全性は型理論における専門用語である。
<!--Roughly, if a type system is sound, then if a program type-checks, it is type-safe;-->
おおまかに言えば、タイプシステムが健全な場合、プログラムタイプチェックの場合はタイプセーフです。
<!--ie I can never (in safe rust) force a value into a variable of the wrong type.-->
すなわち、私は（間違いなく）間違った型の変数に値を強制することはできません。
<!--(see "completeness").-->
（「完全性」を参照）。
<!--span |-->
スパン|
<!--a location in the user's source code, used for error reporting primarily.-->
主にエラー報告に使用されるユーザーのソースコード内の場所。
<!--These are like a file-name/line-number/column tuple on steroids: they carry a start/end point, and also track macro expansions and compiler desugaring.-->
これらは、ステロイドのファイル名/行番号/列タプルのようなものです。開始点と終了点を持ち、マクロ展開とコンパイラdesugaringも追跡します。
<!--All while being packed into a few bytes (really, it's an index into a table).-->
すべては数バイトにパックされています（実際にはテーブルへのインデックスです）。
<!--See the Span datatype for more.-->
詳細についてはSpanのデータ型を参照してください。
<!--substs |-->
|
<!--the substitutions for a given generic type or item (eg the `i32`, `u32` in `HashMap<i32, u32>`) tcx |-->
指定したジェネリック型または項目の置換（例えば`i32`、 `u32`で`HashMap<i32, u32>` TCX）|
<!--the "typing context", main data structure of the compiler ([see more](ty.html)) 'tcx |-->
コンパイラの主なデータ構造（[詳細はこちら](ty.html)） 'tcx |
<!--the lifetime of the currently active inference context ([see more](ty.html)) trait reference |-->
現在アクティブな推論コンテキストの寿命（[詳細はこちらを参照](ty.html)）trait reference |
<!--the name of a trait along with a suitable set of input type/lifetimes ([see more](./traits/goals-and-clauses.html#trait-ref)) token |-->
特性の名前、適切な入力タイプ/有効期間のセット（[詳細はこちら](./traits/goals-and-clauses.html#trait-ref)）token |
<!--the smallest unit of parsing.-->
解析の最小単位。
<!--Tokens are produced after lexing ([see more](the-parser.html)).-->
トークンはレクシング後に生成されます（[詳細はを参照](the-parser.html)）。
<!--[TLS] |-->
| [TLS] |
<!--Thread-Local Storage.-->
スレッドローカルストレージ。
<!--Variables may be defined so that each thread has its own copy (rather than all threads sharing the variable).-->
変数は、各スレッドが（変数を共有するすべてのスレッドではなく）独自のコピーを持つように定義することができます。
<!--This has some interactions with LLVM.-->
これにはLLVMとのやりとりがあります。
<!--Not all platforms support TLS.-->
すべてのプラットフォームがTLSをサポートするわけではありません。
<!--trans |-->
トランス|
<!--the code to translate MIR into LLVM IR.-->
MIRをLLVM IRに変換するコード。
<!--Renamed to codegen.-->
codegenに改名されました。
<!--trait reference |-->
|
<!--a trait and values for its type parameters ([see more](ty.html)).-->
特性とその型パラメータの値（[詳細はこちらを参照](ty.html)）。
<!--ty |-->
|
<!--the internal representation of a type ([see more](ty.html)).-->
型の内部表現（[詳細を参照](ty.html)）。
<!--UFCS |-->
UFCS |
<!--Universal Function Call Syntax.-->
汎用関数呼び出し構文。
<!--An unambiguous syntax for calling a method ([see more](type-checking.html)).-->
メソッドを呼び出すための明確な構文です（[詳細はこちらを参照](type-checking.html)）。
<!--uninhabited type |-->
無人タイプ|
<!--a type which has  _no_  values.-->
値を持た _ない_ 型。
<!--This is not the same as a ZST, which has exactly 1 value.-->
これは、ちょうど1の値を持つZSTと同じではありません。
<!--An example of an uninhabited type is `enum Foo {}`, which has no variants, and so, can never be created.-->
無人型の例は、バリアントを持たない`enum Foo {}`です。したがって、決して作成することはできません。
<!--The compiler can treat code that deals with uninhabited types as dead code, since there is no such value to be manipulated.-->
コンパイラは、無人型を処理するコードをデッドコードとして扱うことができます。操作対象となる値がないからです。
<!--`!` (the never type) is an uninhabited type.-->
`!`（never型）は無人型です。
<!--Uninhabited types are also called "empty types".-->
無人タイプは「空のタイプ」とも呼ばれます。
<!--upvar |-->
upvar |
<!--a variable captured by a closure from outside the closure.-->
クロージャの外側からクロージャによって取り込まれた変数。
<!--variance |-->
|
<!--variance determines how changes to a generic type/lifetime parameter affect subtyping;-->
分散は、ジェネリック型/ライフタイムパラメータへの変更がサブタイプにどのように影響するかを決定します。
<!--for example, if `T` is a subtype of `U`, then `Vec<T>` is a subtype `Vec<U>` because `Vec` is *covariant* in its generic parameter.-->
例えば、`T`が`U`サブタイプである場合、`Vec`はその汎用パラメータにおいて*共変*であるので、`Vec<T>`はサブタイプ`Vec<U>`ある。
<!--See [the background chapter](./appendix/background.html#variance) for a more general explanation.-->
より一般的な説明について[は、背景の章](./appendix/background.html#variance)を参照してください。
<!--See the [variance chapter](./variance.html) for an explanation of how type checking handles variance.-->
型チェックが分散を処理する方法については、[分散の章](./variance.html)を参照してください。
<!--Wide pointer |-->
ワイドポインタ|
<!--a pointer with additional metadata.-->
追加のメタデータを持つポインタ。
<!--See "fat pointer"for more.-->
詳細については、「ファットポインタ」を参照してください。
<!--ZST |-->
| ZST |
<!--Zero-Sized Type.-->
ゼロサイズタイプ。
<!--A type whose values have size 0 bytes.-->
値のサイズが0バイトの型。
<!--Since `2^0 = 1`, such types can have exactly one value.-->
`2^0 = 1`、そのような型はちょうど1つの値を持つことができます。
<!--For example, `()` (unit) is a ZST.-->
たとえば、`()`（単位）はZSTです。
`struct Foo;` <!--is also a ZST.-->
また、ZSTです。
<!--The compiler can do some nice optimizations around ZSTs.-->
コンパイラは、ZSTを中心に最適化を行うことができます。

<!--[LLVM]: https://llvm.org/
 [lto]: https://llvm.org/docs/LinkTimeOptimization.html
 [thinlto]: https://clang.llvm.org/docs/ThinLTO.html
 [TLS]: https://llvm.org/docs/LangRef.html#thread-local-storage-models
-->
[LLVM]: https://llvm.org/
 [lto]: https://llvm.org/docs/LinkTimeOptimization.html
 [thinlto]: https://clang.llvm.org/docs/ThinLTO.html
 [TLS]: https://llvm.org/docs/LangRef.html#thread-local-storage-models

