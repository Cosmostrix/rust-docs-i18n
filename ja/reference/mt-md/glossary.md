# <!--Glossary--> 用語集

### <!--Abstract Syntax Tree--> 抽象構文木

<!--An 'abstract syntax tree', or 'AST', is an intermediate representation of the structure of the program when the compiler is compiling it.-->
「抽象構文木」または「AST」は、コンパイラがコンパイルしているときのプログラム構造の中間表現です。

### <!--Alignment--> アラインメント

<!--The alignment of a value specifies what addresses values are preferred to start at.-->
値の整列は、開始するのが望ましい値のアドレスを指定します。
<!--Always a power of two.-->
常に2の累乗。
<!--References to a value must be aligned.-->
値への参照は一列に並ばなければなりません。
<!--[More][alignment].-->
[More][alignment]。

### <!--Arity--> アリティ

<!--Arity refers to the number of arguments a function or operator takes.-->
Arityは、関数または演算子が取る引数の数を指します。
<!--For some examples, `f(2, 3)` and `g(4, 6)` have arity 2, while `h(8, 2, 6)` has arity 3. The `!` operator has arity 1.-->
いくつかの例については、`f(2, 3)`及び`g(4, 6)`が、アリティ2を持っている`h(8, 2, 6)` 3.アリティを有する`!`オペレータはアリティ1を有しています。

### <!--Array--> アレイ

<!--An array, sometimes also called a fixed-size array or an inline array, is a value describing a collection of elements, each selected by an index that can be computed at run time by the program.-->
固定小数点配列またはインライン配列とも呼ばれる配列は、プログラムによって実行時に計算できるインデックスによって選択される要素のコレクションを記述する値です。
<!--It occupies a contiguous region of memory.-->
これは、連続したメモリ領域を占有します。

### <!--Associated Item--> 関連商品

<!--An associated item is an item that is associated with another item.-->
関連するアイテムは、別のアイテムに関連付けられているアイテムです。
<!--Associated items are defined in [implementations] and declared in [traits].-->
関連項目は[implementations]で定義され、[traits]で宣言されます。
<!--Only functions, constants, and type aliases can be associated.-->
関数、定数、および型のエイリアスのみを関連付けることができます。

### <!--Bound--> バウンド

<!--Bounds are constraints on a type or trait.-->
境界は、タイプまたは特性に対する制約です。
<!--For example, if a bound is placed on the argument a function takes, types passed to that function must abide by that constraint.-->
たとえば、ある関数が受け取る引数に境界が置かれている場合、その関数に渡される型はその制約を守らなければなりません。

### <!--Combinator--> コンビネータ

<!--Combinators are higher-order functions that apply only functions and earlier defined combinators to provide a result from its arguments.-->
Combinatorsは関数のみを適用する高次関数であり、その引数から結果を得るために以前に定義されたコンビネータです。
<!--They can be used to manage control flow in a modular fashion.-->
これらは、モジュラー方式で制御フローを管理するために使用できます。

### <!--Dispatch--> ディスパッチ

<!--Dispatch is the mechanism to determine which specific version of code is actually run when it involves polymorphism.-->
ディスパッチは、ポリモーフィズムに関連するときに実際に実行されるコードの特定のバージョンを判断するメカニズムです。
<!--Two major forms of dispatch are static dispatch and dynamic dispatch.-->
ディスパッチの主な2つの形式は、静的ディスパッチと動的ディスパッチです。
<!--While Rust favors static dispatch, it also supports dynamic dispatch through a mechanism called 'trait objects'.-->
Rustは静的なディスパッチを優先しますが、それは「特性オブジェクト」と呼ばれるメカニズムを介した動的ディスパッチもサポートしています。

### <!--Dynamically Sized Type--> ダイナミックサイジングタイプ

<!--A dynamically sized type (DST) is a type without a statically known size or alignment.-->
動的サイズタイプ（DST）は、静的に既知のサイズまたは配置がないタイプです。

### <!--Expression--> 式

<!--An expression is a combination of values, constants, variables, operators and functions that evaluate to a single value, with or without side-effects.-->
式は、副作用の有無にかかわらず、単一の値に評価される値、定数、変数、演算子、関数の組み合わせです。

<!--For example, `2 + (3 * 4)` is an expression that returns the value 14.-->
たとえば、`2 + (3 * 4)`は値14を返す式です。

### <!--Initialized--> 初期化済み

<!--A variable is initialized if it has been assigned a value and hasn't since been moved from.-->
変数は、値が割り当てられてから移動されなかった場合に初期化されます。
<!--All other memory locations are assumed to be initialized.-->
他のすべてのメモリ位置は初期化されているものとみなされます。
<!--Only unsafe Rust can create such a memory without initializing it.-->
安全でない錆だけが初期化せずにそのようなメモリを作成することができます。

### <!--Nominal Types--> 名目型

<!--Types that can be referred to by a path directly.-->
パスで直接参照できる型。
<!--Specifically [enums], [structs], [unions], and [trait objects].-->
特に[enums]、 [structs]、 [unions] [structs]、および[trait objects]

### <!--Object Safe Traits--> オブジェクトセーフな特性

<!--[Traits] that can be used as [trait objects].-->
[Traits]として使用することができ[trait objects]。
<!--Only traits that follow specific [rules][object%20safety] are object safe.-->
特定の[rules][object%20safety]従う形質だけがオブジェクトセーフです。

### <!--Prelude--> プレリュード

<!--Prelude, or The Rust Prelude, is a small collection of items -mostly traits -that are imported into every module of every crate.-->
Prelude、またはThe Rust Preludeは、すべてのクレートのすべてのモジュールにインポートされる、少数のアイテム、主に特質です。
<!--The traits in the prelude are pervasive.-->
プレリュードの特徴は普及している。

### <!--Size--> サイズ

<!--The size of a value has two definitions.-->
値のサイズには2つの定義があります。

<!--The first is that it is how much memory must be allocated to store that value.-->
1つは、その値を格納するためにどのくらいのメモリを割り当てる必要があるかということです。

<!--The second is that it is the offset in bytes between successive elements in an array with that item type.-->
2つ目は、そのアイテムタイプの配列内の連続する要素間のバイト単位のオフセットです。

<!--It is a multiple of the alignment, including zero.-->
これは、ゼロを含む整列の倍数です。
<!--The size can change depending on compiler version (as new optimizations are made) and target platform (similar to how `usize` varies per-platform).-->
コンパイラのバージョン（新しい最適化が行われる`usize`）とターゲットプラットフォーム（プラットフォームごとの`usize`使い方に似ています）に応じてサイズが変わる可能性があります。

<!--[More][alignment].-->
[More][alignment]。

### <!--Slice--> スライス

<!--A slice is dynamically-sized view into a contiguous sequence, written as `[T]`.-->
スライスは、`[T]`と書かれた連続したシーケンスへの動的なサイズのビューです。

<!--It is often seen in its borrowed forms, either mutable or shared.-->
それはしばしば、借り入れられた形で、変更可能または共有された形で見られます。
<!--The shared slice type is `&[T]`, while the mutable slice type is `&mut [T]`, where `T` represents the element type.-->
共有スライスタイプは`&[T]`であり、可変スライスタイプは`&mut [T]`。ここで、 `T`はエレメントタイプを表します。

### <!--Statement--> ステートメント

<!--A statement is the smallest standalone element of a programming language that commands a computer to perform an action.-->
ステートメントは、コンピュータにアクションを実行するように指示する、プログラミング言語の最小のスタンドアロン要素です。

### <!--String literal--> 文字列リテラル

<!--A string literal is a string stored directly in the final binary, and so will be valid for the `'static` duration.-->
文字列リテラルは、最終バイナリに直接格納される文字列であり、したがって`'static`持続時間`'static`も有効です。

<!--Its type is `'static` duration borrowed string slice, `&'static str`.-->
そのタイプは`'static` duration borrowed string slice、`&'static str`です。

### <!--String slice--> 文字列スライス

<!--A string slice is the most primitive string type in Rust, written as `str`.-->
文字列スライスは、`str`として書かれた、Rustの最も基本的な文字列型です。
<!--It is often seen in its borrowed forms, either mutable or shared.-->
それはしばしば、借り入れられた形で、変更可能または共有された形で見られます。
<!--The shared string slice type is `&str`, while the mutable string slice type is `&mut str`.-->
共有文字列のスライスタイプは`&str`ですが、可変スライスタイプは`&mut str`です。

<!--Strings slices are always valid UTF-8.-->
文字列スライスは常に有効なUTF-8です。

### <!--Trait--> 特性

<!--A trait is a language item that is used for describing the functionalities a type must provide.-->
特性とは、型が提供しなければならない機能を記述するために使用される言語項目です。
<!--It allows a type to make certain promises about its behavior.-->
タイプによって、その振る舞いについてある種の約束をすることができます。

<!--Generic functions and generic structs can use traits to constrain, or bound, the types they accept.-->
汎用関数と汎用構造体は、特性を使用して、それらが受け入れる型を束縛または束縛することができます。

<!--[alignment]: type-layout.html#size-and-alignment
 [enums]: items/enumerations.html
 [structs]: items/structs.html
 [unions]: items/unions.html
 [trait objects]: types.html#trait-objects
 [implementations]: items/implementations.html
 [traits]: items/traits.html
 [object safety]: items/traits.html#object-safety
-->
[alignment]: type-layout.html#size-and-alignment
 [enums]: items/enumerations.html
 [structs]: items/structs.html
 [unions]: items/unions.html
 [trait objects]: types.html#trait-objects
 [implementations]: items/implementations.html
 [traits]: items/traits.html
 [object safety]: items/traits.html#object-safety

