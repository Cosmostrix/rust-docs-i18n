# <!--Crates and source files--> クレートとソースファイル

> <!--**<sup>Syntax</sup>** \  _Crate_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _Crate_ ：\＆nbsp;＆nbsp;
> <!--UTF8BOM  __?__ -->
> UTF8BOM  __？__ 
> <!--\ &nbsp;&nbsp;-->
> \＆nbsp;＆nbsp;
> <!--SHEBANG  __?__ -->
> シェバン __？__ 
> <!--\ &nbsp;&nbsp;-->
> \＆nbsp;＆nbsp;
> <!--[_InnerAttribute_]  __\ *</sup>\ &nbsp;&nbsp;*__ -->
> [_InnerAttribute_]  __\ *</ sup> \＆nbsp;＆nbsp;*__ 
> <!-- __*[_Item_]<sup>\*__ -->
>  __*[_Item _] <sup> \*__ 

> <!--**<sup>Lexer</sup>** \ UTF8BOM: `\uFEFF` \ SHEBANG: `#!` ~ [`[` `\n`] ~ `\n`  __*__ -->
> **<sup> Lexer </ sup>** \ UTF8BOM： `\uFEFF` \ SHEBANG： `#!` 〜 [`[` `\n`] `\n`  __*__ 


> <!--Note: Although Rust, like any other language, can be implemented by an interpreter as well as a compiler, the only existing implementation is a compiler,and the language has always been designed to be compiled.-->
> 注：Rustは、他の言語と同様に、インタプリタとコンパイラによって実装できますが、既存の実装はコンパイラのみであり、言語は常にコンパイルできるように設計されています。
> <!--For these reasons, this section assumes a compiler.-->
> これらの理由から、このセクションではコンパイラを想定しています。

<!--Rust's semantics obey a *phase distinction* between compile-time and run-time.-->
Rustのセマンティクスは、コンパイル時と実行時の*段階的な区別に*従います。
<!--[^phase-distinction] Semantic rules that have a *static interpretation* govern the success or failure of compilation, while semantic rules that have a *dynamic interpretation* govern the behavior of the program at run-time.-->
[^phase-distinction] *静的解釈*を持つ意味規則はコンパイルの成功または失敗を制御し、*動的解釈*を持つ意味規則は実行時にプログラムの動作を制御します。

<!--The compilation model centers on artifacts called  _crates_ .-->
コンパイルモデルは、 _クレート_ と呼ばれるアーティファクトを中心に _扱い_ ます。
<!--Each compilation processes a single crate in source form, and if successful, produces a single crate in binary form: either an executable or some sort of library.-->
各コンパイルは、ソース形式の単一のクレートを処理し、成功した場合は、バイナリ形式の単一のクレート、つまり実行可能ファイルまたはライブラリの種類を生成します。
[^cratesourcefile]
<!--A  _crate_  is a unit of compilation and linking, as well as versioning, distribution and runtime loading.-->
 _クレート_ は、コンパイルとリンク、バージョン管理、配布、実行時の読み込みの単位です。
<!--A crate contains a  _tree_  of nested [module] scopes.-->
枠には、ネストされた[module]スコープの _ツリー_ が含まれてい[module]。
<!--The top level of this tree is a module that is anonymous (from the point of view of paths within the module) and any item within a crate has a canonical [module path] denoting its location within the crate's module tree.-->
このツリーの最上位レベルは、（モジュール内のパスの観点から見た）匿名のモジュールであり、クレート内のどのアイテムもクレートのモジュールツリー内の位置を示す標準[module path]を持っています。

<!--The Rust compiler is always invoked with a single source file as input, and always produces a single output crate.-->
Rustコンパイラは常に1つのソースファイルを入力として呼び出され、常に1つの出力クレートを生成します。
<!--The processing of that source file may result in other source files being loaded as modules.-->
そのソースファイルの処理によって、他のソースファイルがモジュールとしてロードされることがあります。
<!--Source files have the extension `.rs`.-->
ソースファイルの拡張子は`.rs`です。

<!--A Rust source file describes a module, the name and location of which &mdash;-->
Rustソースファイルには、モジュールの名前と場所が記述されています。
<!--in the module tree of the current crate &mdash;-->
現在のクレートのモジュールツリーに表示されます。
<!--are defined from outside the source file: either by an explicit `mod_item` in a referencing source file, or by the name of the crate itself.-->
ソースファイルの外側から、参照元ファイルの明示的な`mod_item`か、クレート自体の名前のどちらかで定義されます。
<!--Every source file is a module, but not every module needs its own source file: [module definitions][module] can be nested within one file.-->
すべてのソースファイルはモジュールですが、すべてのモジュールが独自のソースファイルを必要とするわけではありません。[モジュール定義][module]は1つのファイル内にネストすることができます。

<!--Each source file contains a sequence of zero or more `item` definitions, and may optionally begin with any number of [attributes] that apply to the containing module, most of which influence the behavior of the compiler.-->
各ソースファイルには、0個以上の`item`定義のシーケンスが含まれています。オプションとして、包含モジュールに適用される任意の数の[attributes]から始めることができます。これらの[attributes]多くは、コンパイラの動作に影響します。
<!--The anonymous crate module can have additional attributes that apply to the crate as a whole.-->
匿名の木枠モジュールには、枠全体に適用される追加の属性を含めることができます。

```rust,no_run
#// Specify the crate name.
// クレート名を指定します。
#![crate_name = "projx"]

#// Specify the type of output artifact.
// 出力成果物のタイプを指定します。
#![crate_type = "lib"]

#// Turn on a warning.
#// This can be done in any module, not just the anonymous crate module.
// 警告をオンにします。これは、匿名クレートモジュールだけでなく、どのモジュールでも行うことができます。
#![warn(non_camel_case_types)]
```

<!--A crate that contains a `main` [function] can be compiled to an executable.-->
`main` [function]を含む木枠は、実行可能ファイルにコンパイルできます。
<!--If a `main` function is present, it must take no arguments, must not declare any [trait or lifetime bounds], must not have any [where clauses], and its return type must be one of the following:-->
`main`関数が存在する場合、引数を取らず、[trait or lifetime bounds]宣言してはならず、[where clauses]持たず、戻り値の型が次のいずれか[where clauses]なければなりません：

* `()`
<!-- * `!` -->
 <!--* `Result<T, E> where T: on this list, E: Error`-->
* `Result<T, E> where T: on this list, E: Error`

> <!--Note: The implementation of which return types are allowed is determined by the unstable [`Termination`] trait.-->
> 注：戻り値の型の実装は、不安定な[`Termination`]特性によって決まります。

<!--The optional [_UTF8 byte order mark_] (UTF8BOM production) indicates that the file is encoded in UTF8.-->
オプションの[_UTF8 byte order mark_]（UTF8BOM制作）は、ファイルがUTF8でエンコードされていることを示します。
<!--It can only occur at the beginning of the file and is ignored by the compiler.-->
これはファイルの先頭でのみ発生する可能性があり、コンパイラによって無視されます。

<!--A source file can have a [_shebang_] (SHEBANG production), which indicates to the operating system what program to use to execute this file.-->
ソースファイルは[_shebang_]（SHEBANG制作）を持つことができ、これはオペレーティングシステムにこのファイルの実行に使用するプログラムを指示します。
<!--It serves essentially to treat the source file as an executable script.-->
基本的に、ソースファイルを実行可能なスクリプトとして扱います。
<!--The shebang can only occur at the beginning of the file (but after the optional  _UTF8BOM_ ).-->
シバンは、ファイルの先頭（ただしオプションの _UTF8BOMの_ 後）でのみ発生します。
<!--It is ignored by the compiler.-->
これはコンパイラによって無視されます。
<!--For example:-->
例えば：

```text,ignore
#!/usr/bin/env rustx

fn main() {
    println!("Hello!");
}
```

[^phase-distinction]: This%20distinction%20would%20also%20exist%20in%20an%20interpreter.
<!--Static checks like syntactic analysis, type checking, and lints should happen before the program is executed regardless of when it is executed.-->
シンタックス分析、型チェック、およびlintのような静的検査は、プログラムの実行前に実行される前に実行する必要があります。

[^cratesourcefile]: A%20crate%20is%20somewhat%20analogous%20to%20an%20*assembly*%20in%20the
<!--ECMA-335 CLI model, a *library* in the SML/NJ Compilation Manager, a *unit* in the Owens and Flatt module system, or a *configuration* in Mesa.-->
ECMA-335 CLIモデル、SML / NJ Compilation Managerの*ライブラリ*、Owens and Flattモジュールシステムの*ユニット*、またはMesaの*コンフィギュレーションを使用*し*ます*。

<!--[module]: items/modules.html
 [module path]: paths.html
 [attributes]: attributes.html
 [unit]: types.html#tuple-types
 [_InnerAttribute_]: attributes.html
 [_Item_]: items.html
 [_shebang_]: https://en.wikipedia.org/wiki/Shebang_(Unix)
 [_utf8 byte order mark_]: https://en.wikipedia.org/wiki/Byte_order_mark#UTF-8
 [function]: items/functions.html
 [`Termination`]: ../std/process/trait.Termination.html
 [where clause]: items/where-clauses.html
 [trait or lifetime bounds]: trait-bounds.html
-->
[module]: items/modules.html
 [module path]: paths.html
 [attributes]: attributes.html
 [unit]: types.html#tuple-types
 [_InnerAttribute_]: attributes.html
 [_Item_]: items.html
 [_shebang_]: https://en.wikipedia.org/wiki/Shebang_(Unix)
 [_utf8 byte order mark_]: https://en.wikipedia.org/wiki/Byte_order_mark#UTF-8
 [function]: items/functions.html
 [`Termination`]: ../std/process/trait.Termination.html
 [where clause]: items/where-clauses.html
 [trait or lifetime bounds]: trait-bounds.html

