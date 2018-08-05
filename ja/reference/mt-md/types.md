# <!--Types--> タイプ

<!--Every variable, item and value in a Rust program has a type.-->
Rustプログラムのすべての変数、項目、値には型があります。
<!--The  _type_  of a *value* defines the interpretation of the memory holding it.-->
*値*の _型_ は、それを保持するメモリの解釈を定義します。

<!--Built-in types are tightly integrated into the language, in nontrivial ways that are not possible to emulate in user-defined types.-->
組み込み型は、ユーザー定義型ではエミュレートできない重要な方法で、言語に密接に統合されています。
<!--User-defined types have limited capabilities.-->
ユーザー定義型には機能が限られています。

## <!--Primitive types--> プリミティブ型

<!--Some types are defined by the language, rather than as part of the standard library, these are called  _primitive types_ .-->
言語によって定義されるタイプもあれば、標準ライブラリの一部ではなく、 _プリミティブタイプ_ と呼ばれる _タイプもあります_ 。
<!--Some of these are individual types:-->
これらは個々のタイプです：

* <!--The boolean type `bool` with values `true` and `false`.-->
   値が`true`および`false`のブール型`bool`。
* <!--The [machine types] (integer and floating-point).-->
   [machine types]（整数と浮動小数点）。
* <!--The [machine-dependent integer types].-->
   [machine-dependent integer types]。
* <!--The [textual types] `char` and `str`.-->
   [textual types] `char`と`str`。
* <!--The [never type] `!`-->
   [never type] `!`

<!--There are also some primitive constructs for generic types built in to the language:-->
言語に組み込まれたジェネリック型の基本的な構造もいくつかあります。

* [Tuples]
* [Arrays]
* [Slices]
* [Function pointers]
* [References]
* [Pointers]

<!--[machine types]: #machine-types
 [machine-dependent integer types]: #machine-dependent-integer-types
 [textual types]: #textual-types
 [never-type]: #never-type
 [Tuples]: #tuple-types
 [Arrays]: #array-and-slice-types
 [Slices]: #array-and-slice-types
 [References]: #pointer-types
 [Pointers]: #raw-pointers-const-and-mut
 [Function pointers]: #function-pointer-types
 [function]: #function-types
 [closure]: #closure-types
-->
[machine types]: #machine-types
 [machine-dependent integer types]: #machine-dependent-integer-types
 [textual types]: #textual-types
 [never-type]: #never-type
 [Tuples]: #tuple-types
 [Arrays]: #array-and-slice-types
 [Slices]: #array-and-slice-types
 [References]: #pointer-types
 [Pointers]: #raw-pointers-const-and-mut
 [Function pointers]: #function-pointer-types
 [function]: #function-types
 [closure]: #closure-types


## <!--Numeric types--> 数値型

### <!--Machine types--> マシンの種類

<!--The machine types are the following:-->
マシンの種類は次のとおりです。

* <!--The unsigned word types `u8`, `u16`, `u32`, `u64`, and `u128` with values drawn from the integer intervals [0, 2^8 -1], [0, 2^16 -1], [0, 2^32 -1], [0, 2^64 -1], and [0, 2^128 -1] respectively.-->
   符号なしのワードタイプ`u8`、 `u16`、 `u32`、 `u64`、および`u128`整数間隔から引き出された値を[0, 2^8 -1]、 [0, 2^16 -1]、 [0, 2^32 -1]、 [0, 2^64 -1]、及び[0, 2^128 -1]それぞれ。

* <!--The signed two's complement word types `i8`, `i16`, `i32`, `i64`, and `i128`, with values drawn from the integer intervals [-(2^7), 2^7 -1], [-(2^15), 2^15 -1], [-(2^31), 2^31 -1], [-(2^63), 2^63 -1], and [-(2^127), 2^127 -1] respectively.-->
   符号付き2の補数ワードタイプ`i8`、 `i16`、 `i32`、 `i64`、および`i128`、整数間隔から引き出された値を有する[-(2^7), 2^7 -1]、 [-(2^15), 2^15 -1]、 [-(2^31), 2^31 -1]、 [-(2^63), 2^63 -1]、 [-(2^127), 2^127 -1]ある。

* <!--The IEEE 754-2008 "binary32"and "binary64"floating-point types: `f32` and `f64`, respectively.-->
   IEEE 754-2008の「binary32」浮動小数点型と「binary64」浮動小数点型：それぞれ`f32`と`f64`です。

### <!--Machine-dependent integer types--> マシン依存の整数型

<!--The `usize` type is an unsigned integer type with the same number of bits as the platform's pointer type.-->
`usize`型は、プラットフォームのポインタ型と同じビット数の符号なし整数型です。
<!--It can represent every memory address in the process.-->
プロセス内のすべてのメモリアドレスを表すことができます。

<!--The `isize` type is a signed integer type with the same number of bits as the platform's pointer type.-->
`isize`型は、プラットフォームのポインタ型と同じビット数を持つ符号付き整数型です。
<!--The theoretical upper bound on object and array size is the maximum `isize` value.-->
オブジェクトと配列のサイズに関する理論上の上限は、最大`isize`値です。
<!--This ensures that `isize` can be used to calculate differences between pointers into an object or array and can address every byte within an object along with one byte past the end.-->
これにより、オブジェクトまたは配列へのポインタ間の相違を計算するために`isize`を使用できるようになり、オブジェクト内のすべてのバイトを1バイト後に処理することができます。

## <!--Textual types--> テキストタイプ

<!--The types `char` and `str` hold textual data.-->
`char`型と`str`型はテキストデータを保持します。

<!--A value of type `char` is a [Unicode scalar value](http://www.unicode.org/glossary/#unicode_scalar_value) (ie a code point that is not a surrogate), represented as a 32-bit unsigned word in the 0x0000 to 0xD7FF or 0xE000 to 0x10FFFF range.-->
`char`型の値は、0x0000から0xD7FFまたは0xE000から0x10FFFFまでの範囲内の32ビットの符号なしワードとして表される[Unicodeスカラー値](http://www.unicode.org/glossary/#unicode_scalar_value)（つまり代理コードではないコードポイント）です。
<!--A `[char]` is effectively a UCS-4 / UTF-32 string.-->
`[char]`は実質的にUCS-4 / UTF-32文字列です。

<!--A value of type `str` is a Unicode string, represented as an array of 8-bit unsigned bytes holding a sequence of UTF-8 code points.-->
`str`型の値は、UTF-8コードポイントのシーケンスを保持する8ビットの符号なしバイトの配列として表されるUnicode文字列です。
<!--Since `str` is a [dynamically sized type], it is not a  _first-class_  type, but can only be instantiated through a pointer type, such as `&str`.-->
`str`は[dynamically sized type]であるため、 _first-class_ 型ではありませんが、`&str`ようなポインタ型でのみインスタンス化でき`&str`。

## <!--Never type--> 入力しない

<!--The never type `!` is a type with no values, representing the result of computations that never complete.-->
never型`!`は、値のない型であり、決して完了しない計算の結果を表します。
<!--Expressions of type `!` can be coerced into any other type.-->
タイプ`!`式は、他の型に変換できます。

## <!--Tuple types--> タプルタイプ

<!--A tuple *type* is a heterogeneous product of other types, called the *elements* of the tuple.-->
タプル*型*は、タプルの*要素*と呼ばれる他の型の異種の製品です。
<!--It has no nominal name and is instead structurally typed.-->
名目上の名前はなく、代わりに構造的に型付けされています。

<!--Tuple types and values are denoted by listing the types or values of their elements, respectively, in a parenthesized, comma-separated list.-->
タプルの型と値は、要素の型または値をカッコで区切られたコンマで区切られたリストにそれぞれリストして示します。

<!--Because tuple elements don't have a name, they can only be accessed by pattern-matching or by using `N` directly as a field to access the `N` th element.-->
タプル要素は名前を持たないので、パターンマッチングや`N`番目の要素にアクセスするためのフィールドとして`N`直接使用することによってのみアクセスできます。

<!--An example of a tuple type and its use:-->
タプル型とその使用例：

```rust
type Pair<'a> = (i32, &'a str);
let p: Pair<'static> = (10, "ten");
let (a, b) = p;

assert_eq!(a, 10);
assert_eq!(b, "ten");
assert_eq!(p.0, 10);
assert_eq!(p.1, "ten");
```

<!--For historical reasons and convenience, the tuple type with no elements (`()`) is often called 'unit' or 'the unit type'.-->
歴史的な理由と便宜のために、要素のないタプルタイプ（`()`）は、しばしば「ユニット」または「ユニットタイプ」と呼ばれます。

## <!--Array, and Slice types--> 配列、およびスライスタイプ

<!--Rust has two different types for a list of items:-->
錆は、アイテムのリストに2つの異なるタイプがあります：

* `[T; N]` <!--`[T; N]`, an 'array'-->
   `[T; N]`、 '配列'
* <!--`[T]`, a 'slice'-->
   `[T]`、 'スライス'

<!--An array has a fixed size, and can be allocated on either the stack or the heap.-->
配列は固定サイズであり、スタックまたはヒープのいずれかに割り当てることができます。

<!--A slice is a [dynamically sized type] representing a 'view' into an array.-->
スライスは、配列への 'ビュー'を表す[dynamically sized type]です。
<!--To use a slice type it generally has to be used behind a pointer for example as-->
スライスタイプを使用するには、一般にポインタの後ろに例えば以下のように使用する必要があります。

* <!--`&[T]`, a 'shared slice', often just called a 'slice', it doesn't own the data it points to, it borrows it.-->
   `&[T]`、「共有スライス」はしばしば単に「スライス」と呼ばれ、それが指すデータを所有していないので、それを借ります。
* <!--`&mut [T]`, a 'mutable slice', mutably borrows the data it points to.-->
   `&mut [T]`、 'mutable slice'は、それが指し示すデータを可変的に借ります。
* <!--`Box<[T]>`, a 'boxed slice'-->
   `Box<[T]>`、 'boxed slice'

<!--Examples:-->
例：

```rust
#// A stack-allocated array
// スタック割り当て配列
let array: [i32; 3] = [1, 2, 3];

#// A heap-allocated array, coerced to a slice
// スライスに強制的に割り当てられたヒープ割り当て配列
let boxed_array: Box<[i32]> = Box::new([1, 2, 3]);

#// A (shared) slice into an array
// アレイへの（共有）スライス
let slice: &[i32] = &boxed_array[..];
```

<!--All elements of arrays and slices are always initialized, and access to an array or slice is always bounds-checked in safe methods and operators.-->
配列やスライスのすべての要素は常に初期化され、配列やスライスへのアクセスは安全なメソッドや演算子で常に境界チェックされます。

> <!--Note: The [`Vec `]-->
> 注： [`Vec `]
> RawInline (Format "html") "<t>" <!--[`Vec `] standard library type provides a heap-allocated resizable array type.-->
> [`Vec `]標準ライブラリ型は、ヒープ割り当てのサイズ変更可能な配列型を提供します。

## <!--Struct types--> 構造体の型

<!--A `struct` *type* is a heterogeneous product of other types, called the *fields* of the type.-->
`struct` *型*は、*型*の*フィールド*と呼ばれる他の型の異種製品です。
[^structtype]
<!--New instances of a `struct` can be constructed with a [struct expression](expressions/struct-expr.html).-->
`struct`新しいインスタンスは、`struct` [struct expression](expressions/struct-expr.html)構築できます。

<!--The memory layout of a `struct` is undefined by default to allow for compiler optimizations like field reordering, but it can be fixed with the `#[repr(...)]` attribute.-->
`struct`のメモリレイアウトは、デフォルトではフィールドの並べ替えのようなコンパイラの最適化を可能にするために未定義ですが、`#[repr(...)]`属性で修正できます。
<!--In either case, fields may be given in any order in a corresponding struct *expression*;-->
どちらの場合でも、フィールドは、対応する構造*式*で任意の順序で指定することができます。
<!--the resulting `struct` value will always have the same memory layout.-->
結果の`struct`値は常に同じメモリレイアウトになります。

<!--The fields of a `struct` may be qualified by [visibility modifiers](visibility-and-privacy.html), to allow access to data in a struct outside a module.-->
`struct`のフィールドは[visibility modifiers](visibility-and-privacy.html)子によって修飾され、モジュール外の構造体のデータにアクセスすることができます。

<!--A  _tuple struct_  type is just like a struct type, except that the fields are anonymous.-->
 _タプル構造_ 体型は、構造体型と似ていますが、フィールドは匿名です。

<!--A  _unit-like struct_  type is like a struct type, except that it has no fields.-->
 _ユニットのような構造体の_ 型は、構造体の型に似ていますが、フィールドを持たない点が異なります。
<!--The one value constructed by the associated [struct expression] is the only value that inhabits such a type.-->
関連する[struct expression]によって構築された1つの値は、そのような型が存在する唯一の値です。

[^structtype]: %60struct%60%20types%20are%20analogous%20to%20%60struct%60%20types%20in%20C,%20the
<!--*record* types of the ML family, or the *struct* types of the Lisp family.-->
MLファミリの*レコード*タイプ、またはLispファミリの*構造体*タイプを定義します。

## <!--Enumerated types--> 列挙型

<!--An *enumerated type* is a nominal, heterogeneous disjoint union type, denoted by the name of an [`enum` item](items/enumerations.html).-->
*列挙型は、*の名前で示される名目、異種のばらばらの共用体型、ある[`enum`アイテム](items/enumerations.html)。
[^enumtype]
<!--An [`enum` item](items/enumerations.html) declares both the type and a number of *variants*, each of which is independently named and has the syntax of a struct, tuple struct or unit-like struct.-->
[`enum`](items/enumerations.html)型[項目](items/enumerations.html)は、*バリアントの*型と数の両方を宣言し*ます*。各*バリアントは*、それぞれ独立して名前が付けられ、構造体、タプル構造体またはユニットのような構造体の構文を持ちます。

<!--New instances of an `enum` can be constructed in an [enumeration variant expression](expressions/enum-variant-expr.html).-->
新しいインスタンスを`enum`構築することができる[列挙変異体発現](expressions/enum-variant-expr.html)。

<!--Any `enum` value consumes as much memory as the largest variant for its corresponding `enum` type, as well as the size needed to store a discriminant.-->
`enum`値は、対応する`enum`型の最大の変種と同じくらい多くのメモリと、判別式を格納するのに必要なサイズを消費します。

<!--Enum types cannot be denoted *structurally* as types, but must be denoted by named reference to an [`enum` item](items/enumerations.html).-->
Enum型は、型として*構造的*に指定することはできませんが、[`enum`項目の](items/enumerations.html)名前付き参照で指定する必要があり[ます](items/enumerations.html)。

[^enumtype]: The%20%60enum%60%20type%20is%20analogous%20to%20a%20%60data%60%20constructor%20declaration%20in
<!--ML, or a *pick ADT* in Limbo.-->
ML、またはLimboの*ADT*を*選択*します。

## <!--Union types--> 連合型

<!--A *union type* is a nominal, heterogeneous C-like union, denoted by the name of a [`union` item](items/unions.html).-->
*ユニオンタイプ*の名前によって示さ公称、異種C状組合であり、[`union`アイテム](items/unions.html)。

<!--A union contains the value of any one of its fields.-->
共用体には、そのフィールドのいずれかの値が含まれます。
<!--Since the accessing the wrong field can cause unexpected or undefined behaviour, `unsafe` is required to read from a union field or to write to a field that doesn't implement [`Copy`].-->
間違ったフィールドにアクセスすると予期しない動作や未定義の動作が発生する可能性があるので、unionフィールドからの読み取りや[`Copy`]実装していないフィールドへの書き込みには`unsafe`はありません。

<!--The memory layout of a `union` is undefined by default, but the `#[repr(...)]` attribute can be used to fix a layout.-->
`union`のメモリー・レイアウトはデフォルトでは未定義ですが、`#[repr(...)]`属性を使用してレイアウトを修正できます。

[`Copy`]: special-types-and-traits.html#copy

## <!--Recursive types--> 再帰型

<!--Nominal types &mdash;-->
名義型＆mdash;
<!--[structs](#struct-types), [enumerations](#enumerated-types) and [unions](#union-types) &mdash;-->
[structs](#struct-types)、 [enumerations](#enumerated-types)および[unions](#union-types) [structs](#struct-types)
<!--may be recursive.-->
再帰的である可能性があります。
<!--That is, each `enum` variant or `struct` or `union` field may refer, directly or indirectly, to the enclosing `enum` or `struct` type itself.-->
つまり、各`enum`型または`struct`または`union`体フィールドは、直接的または間接的に、囲む`enum`型または`struct`タイプ自体を参照することがあります。
<!--Such recursion has restrictions:-->
そのような再帰には制限があります。

* <!--Recursive types must include a nominal type in the recursion (not mere [type definitions](../grammar.html#type-definitions), or other structural types such as [arrays](#array-and-slice-types) or [tuples](#tuple-types)).-->
   再帰型は、単純[型定義](../grammar.html#type-definitions)、または[arrays](#array-and-slice-types)や[tuples](#tuple-types)などの他の構造[型で](../grammar.html#type-definitions)はなく、再帰に名目型を含める必要があります。
<!--So `type Rec = &'static [Rec]` is not allowed.-->
   したがって`type Rec = &'static [Rec]`は許可されません。
* <!--The size of a recursive type must be finite;-->
   再帰型のサイズは有限でなければなりません。
<!--in other words the recursive fields of the type must be [pointer types](#pointer-types).-->
   つまり、型の再帰的フィールドは[ポインタ](#pointer-types)型でなければなりません。
* <!--Recursive type definitions can cross module boundaries, but not module-->
   再帰型定義はモジュール境界を越えることができますが、モジュールは通過できません
<!--*visibility* boundaries, or crate boundaries (in order to simplify the module system and type checker).-->
*可視の*境界、またはクレート境界（モジュールシステムおよびタイプチェックを簡単にするために）。

<!--An example of a *recursive* type and its use:-->
*再帰*型とその使用例：

```rust
enum List<T> {
    Nil,
    Cons(T, Box<List<T>>)
}

let a: List<i32> = List::Cons(7, Box::new(List::Cons(13, Box::new(List::Nil))));
```

## <!--Pointer types--> ポインタの種類

<!--All pointers in Rust are explicit first-class values.-->
Rustのすべてのポインタは明示的なファーストクラスの値です。
<!--They can be moved or copied, stored into data structs, and returned from functions.-->
それらは移動またはコピーし、データ構造体に格納し、関数から返すことができます。

### <!--Shared references (`&`)--> 共有参照（`&`）

<!--These point to memory  _owned by some other value_ .-->
これらは _、他の値が所有_ するメモリを指し _ます_ 。
<!--When a shared reference to a value is created it prevents direct mutation of the value.-->
値への共有参照が作成されると、値の直接的な変更が防止されます。
<!--[Interior mutability](interior-mutability.html) provides an exception for this in certain circumstances.-->
[Interior mutability](interior-mutability.html)は、特定の状況でこれに対して例外を提供します。
<!--As the name suggests, any number of shared references to a value may exit.-->
名前が示すように、値に対する共有参照はいくつでも終了することがあります。
<!--A shared reference type is written `&type`, or `&'a type` when you need to specify an explicit lifetime.-->
共有参照型が書かれている`&type`、または`&'a type`明示的な寿命を指定する必要があります。
<!--Copying a reference is a "shallow"operation: it involves only copying the pointer itself, that is, pointers are `Copy`.-->
参照をコピーすることは、「浅い」操作です。ポインタ自体をコピーするだけです。つまり、ポインタは`Copy`です。
<!--Releasing a reference has no effect on the value it points to, but referencing of a [temporary value](expressions.html#temporary-lifetimes) will keep it alive during the scope of the reference itself.-->
参照を解放することは、その参照先の値には影響を与えませんが、[一時的な値](expressions.html#temporary-lifetimes)を参照することは、参照自体の有効範囲内で有効にします。

### <!--Mutable references (`&mut`)--> 変更可能な参照（`&mut`）

<!--These also point to memory owned by some other value.-->
これらはまた、他の値が所有するメモリを指しています。
<!--A mutable reference type is written `&mut type` or `&'a mut type`.-->
変更可能な参照型は`&mut type`または`&'a mut type`記述されます。
<!--A mutable reference (that hasn't been borrowed) is the only way to access the value it points to, so is not `Copy`.-->
参照する値（借用されていない）は、参照する値にアクセスする唯一の方法であるため、`Copy`はありません。

### <!--Raw pointers (`*const` and `*mut`)--> 生ポインタ（`*const`と`*mut`）

<!--Raw pointers are pointers without safety or liveness guarantees.-->
生ポインタは、安全性または生存保証のないポインタです。
<!--Raw pointers are written as `*const T` or `*mut T`, for example `*const i32` means a raw pointer to a 32-bit integer.-->
生ポインタは、`*const T`または`*mut T`として記述されます。例えば、`*const i32`は、32ビット整数への生ポインタを意味します。
<!--Copying or dropping a raw pointer has no effect on the lifecycle of any other value.-->
ローポインタをコピーまたはドロップしても、他の値のライフサイクルに影響はありません。
<!--Dereferencing a raw pointer is an [`unsafe` operation](unsafe-functions.html), this can also be used to convert a raw pointer to a reference by reborrowing it (`&*` or `&mut *`).-->
未処理のポインタを参照解除することは[`unsafe operation`](unsafe-functions.html)はあり[`unsafe operation`](unsafe-functions.html)。これを使用して未使用のポインタを再借用して参照に変換することもできます（ `&*`または`&mut *`）。
<!--Raw pointers are generally discouraged in Rust code;-->
生ポインタは一般に錆コードでは推奨されません。
<!--they exist to support interoperability with foreign code, and writing performance-critical or low-level functions.-->
外部コードとの相互運用性をサポートし、パフォーマンスクリティカルまたは低レベルの機能を記述するために存在します。

<!--When comparing pointers they are compared by their address, rather than by what they point to.-->
ポインタを比較するときには、ポインターで比較するのではなく、アドレスで比較します。
<!--When comparing pointers to [dynamically sized types](dynamically-sized-types.html) they also have their addition data compared.-->
[動的なサイズの型](dynamically-sized-types.html)へのポインタを比較するときには、それらの比較データも比較されます。

### <!--Smart Pointers--> スマートポインタ

<!--The standard library contains additional 'smart pointer' types beyond references and raw pointers.-->
標準ライブラリには、参照や生ポインタ以外の「スマートポインタ」タイプが追加されています。

## <!--Function item types--> 機能項目タイプ

<!--When referred to, a function item, or the constructor of a tuple-like struct or enum variant, yields a zero-sized value of its  _function item type_ .-->
参照されると、関数項目、またはタプルのような構造体または列挙型のコンストラクタは、その _関数項目型の_ サイズがゼロの値を生成します。
<!--That type explicitly identifies the function -its name, its type arguments, and its early-bound lifetime arguments (but not its late-bound lifetime arguments, which are only assigned when the function is called) -so the value does not need to contain an actual function pointer, and no indirection is needed when the function is called.-->
その型は明示的にその名前、型引数、およびその初期バインドされた存続時間引数（関数が呼び出されたときにのみ割り当てられる後期バインドされた存続時間引数ではない）を識別します。実際の関数ポインタ、関数が呼び出されたときの間接参照は必要ありません。

<!--There is no syntax that directly refers to a function item type, but the compiler will display the type as something like `fn(u32) -> i32 {fn_name}` in error messages.-->
関数項目の型を直接参照する構文はありませんが、コンパイラはそのタイプをエラーメッセージに`fn(u32) -> i32 {fn_name}`に表示します。

<!--Because the function item type explicitly identifies the function, the item types of different functions -different items, or the same item with different generics -are distinct, and mixing them will create a type error:-->
関数アイテムタイプは明示的に関数を識別するので、異なる関数のアイテムタイプ（異なるアイテムまたは異なるジェネリックの同じアイテム）が区別され、それらを混合するとタイプエラーが生成されます：

```rust,compile_fail,E0308
fn foo<T>() { }
let x = &mut foo::<i32>;
*x = foo::<u32>; //~ ERROR mismatched types
```

<!--However, there is a [coercion] from function items to [function pointers](#function-pointer-types) with the same signature, which is triggered not only when a function item is used when a function pointer is directly expected, but also when different function item types with the same signature meet in different arms of the same `if` or `match`:-->
しかし、機能項目が直接期待されるときに機能項目が使用されるときだけでなく、同じ署名を持つ異なる機能項目タイプが異なるときにトリガされる、同じ項目を[function pointers](#function-pointer-types)関数項目への[coercion]がある同じ`if`または`match` `if`腕：

[coercion]: type-coercions.html

```rust
# let want_i32 = false;
# fn foo<T>() { }

#// `foo_ptr_1` has function pointer type `fn()` here
//  `foo_ptr_1`は関数ポインタ型`fn()`ます
let foo_ptr_1: fn() = foo::<i32>;

#// ... and so does `foo_ptr_2` - this type-checks.
// ...そして`foo_ptr_2`もそう`foo_ptr_2` -このタイプはチェックします。
let foo_ptr_2 = if want_i32 {
    foo::<i32>
} else {
    foo::<u32>
};
```

<!--All function items implement [`Fn`], [`FnMut`], [`FnOnce`], [`Copy`], [`Clone`], [`Send`], and [`Sync`].-->
すべての関数項目は[`Fn`]、 [`FnMut`]、 [`FnOnce`]、 [`Copy`]、 [`Clone`]、 [`Send`]、 [`Sync`]ます。

## <!--Function pointer types--> 関数ポインタ型

<!--Function pointer types, written using the `fn` keyword, refer to a function whose identity is not necessarily known at compile-time.-->
`fn`キーワードを使用して記述された関数ポインタ型は、コンパイル時にその識別情報が必ずしもわからない関数を指します。
<!--They can be created via a coercion from both [function items](#function-item-types) and non-capturing [closures](#closure-types).-->
これらは、[機能項目](#function-item-types)と非キャプチャ[closures](#closure-types)両方からの強制によって作成することができます。

<!--A function pointer type consists of a possibly-empty set of function-type modifiers (such as `unsafe` or `extern`), a sequence of input types and an output type.-->
関数ポインタ型は、おそらく空の関数型修飾子（`unsafe`や`extern`）、一連の入力型、および出力型で構成されます。

<!--An example where `Binop` is defined as a function pointer type:-->
`Binop`が関数ポインタ型として定義されている例：

```rust
fn add(x: i32, y: i32) -> i32 {
    x + y
}

let mut x = add(5,7);

type Binop = fn(i32, i32) -> i32;
let bo: Binop = add;
x = bo(5,7);
```

## <!--Closure types--> クロージャタイプ

<!--A [closure expression] produces a closure value with a unique, anonymous type that cannot be written out.-->
[closure expression]は、書き出すことができない一意の匿名型のクロージャ値を生成します。
<!--A closure type is approximately equivalent to a struct which contains the captured variables.-->
クロージャ型は、キャプチャされた変数を含む構造体とほぼ同等です。
<!--For instance, the following closure:-->
たとえば、次のようなクロージャがあります。

```rust
fn f<F : FnOnce() -> String> (g: F) {
    println!("{}", g());
}

let mut s = String::from("foo");
let t = String::from("bar");

f(|| {
    s += &*t;
    s
});
#// Prints "foobar".
//  "foobar"を表示します。
```

<!--generates a closure type roughly like the following:-->
次のような閉包型を生成します。

```rust,ignore
struct Closure<'a> {
    s : String,
    t : &'a String,
}

impl<'a> (FnOnce() -> String) for Closure<'a> {
    fn call_once(self) -> String {
        self.s += &*self.t;
        self.s
    }
}
```

<!--so that the call to `f` works as if it were:-->
`f`への呼び出しは、次のように動作します。

```rust,ignore
f(Closure{s: s, t: &t});
```

### <!--Capture modes--> 撮影モード

<!--The compiler prefers to capture a closed-over variable by immutable borrow, followed by unique immutable borrow (see below), by mutable borrow, and finally by move.-->
コンパイラは、変更不能な借用によって閉鎖された変数を取得し、続いて一意の不変の借用（以下を参照）、変更可能な借用、および最後に移動によって取得することを好みます。
<!--It will pick the first choice of these that allows the closure to compile.-->
クロージャーをコンパイルできるようにする最初の選択肢が選択されます。
<!--The choice is made only with regards to the contents of the closure expression;-->
選択はクロージャ式の内容に関してのみ行われます。
<!--the compiler does not take into account surrounding code, such as the lifetimes of involved variables.-->
コンパイラは、関与する変数の存続期間など、周囲のコードを考慮しません。

<!--If the `move` keyword is used, then all captures are by move or, for `Copy` types, by copy, regardless of whether a borrow would work.-->
`move`キーワードが使用されている場合、すべてのキャプチャはmoveによって行われます。また、`Copy`タイプでは、コピーによって、借用が機能するかどうかに関係なくコピーされます。
<!--The `move` keyword is usually used to allow the closure to outlive the captured values, such as if the closure is being returned or used to spawn a new thread.-->
`move`キーワードは、通常、クロージャが返されたり新しいスレッドを生成するために使用された場合など、クロージャがキャプチャされた値よりも長生きできるようにするために使用されます。

<!--Composite types such as structs, tuples, and enums are always captured entirely, not by individual fields.-->
構造体、タプル、列挙型などの複合型は、常に個々のフィールドではなく、完全に取り込まれます。
<!--It may be necessary to borrow into a local variable in order to capture a single field:-->
1つのフィールドを取得するには、ローカル変数に借りる必要があります。

```rust
# use std::collections::HashSet;
#
struct SetVec {
    set: HashSet<u32>,
    vec: Vec<u32>
}

impl SetVec {
    fn populate(&mut self) {
        let vec = &mut self.vec;
        self.set.iter().for_each(|&n| {
            vec.push(n);
        })
    }
}
```

<!--If, instead, the closure were to use `self.vec` directly, then it would attempt to capture `self` by mutable reference.-->
代わりに、クロージャが`self.vec`直接使用する場合は、変更可能な参照によって`self`をキャプチャしようとします。
<!--But since `self.set` is already borrowed to iterate over, the code would not compile.-->
しかし、`self.set`はすでに反復処理のために借りているので、コードはコンパイルされません。

### <!--Unique immutable borrows in captures--> ユニークな不変のキャプチャでの借用

<!--Captures can occur by a special kind of borrow called a  _unique immutable borrow_ , which cannot be used anywhere else in the language and cannot be written out explicitly.-->
キャプチャは、言語の他の場所では使用できず、明示的に書き出すことができない _独自の不変の_ 借用と呼ばれる特別な種類の借用によって行われます。
<!--It occurs when modifying the referent of a mutable reference, as in the following example:-->
次の例のように、可変参照の参照先を変更するときに発生します。

```rust
let mut b = false;
let x = &mut b;
{
    let mut c = || { *x = true; };
#    // The following line is an error:
#    // let y = &x;
    // 次の行はエラーです。let y =＆x;
    c();
}
let z = &x;
```

<!--In this case, borrowing `x` mutably is not possible, because `x` is not `mut`.-->
この場合、`x`は`mut`はないため、`x`可変的に借用することはできません。
<!--But at the same time, borrowing `x` immutably would make the assignment illegal, because a `& &mut` reference may not be unique, so it cannot safely be used to modify a value.-->
しかし、同時に`& &mut` `x` `& &mut`リファレンスは一意ではない可能性があるので、`x`無条件に借用すると、割り当てが不正になるので、値を変更するために安全に使用することはできません。
<!--So a unique immutable borrow is used: it borrows `x` immutably, but like a mutable borrow, it must be unique.-->
したがって、一意の不変の借用が使用されます`x`は不変に借りますが、変更可能な借用のように、それは一意でなければなりません。
<!--In the above example, uncommenting the declaration of `y` will produce an error because it would violate the uniqueness of the closure's borrow of `x`;-->
上記の例では、`y`の宣言のコメントを解除すると、`x`クロージャの借用の一意性に違反するため、エラーが生成されます。
<!--the declaration of z is valid because the closure's lifetime has expired at the end of the block, releasing the borrow.-->
ブロックの終わりにクロージャーの存続期間が切れて、借用を解放するので、zの宣言は有効です。

### <!--Call traits and coercions--> コール特性と強制

<!--Closure types all implement [`FnOnce`], indicating that they can be called once by consuming ownership of the closure.-->
Closure型はすべて[`FnOnce`]実装して[`FnOnce`]、Closureの所有権を消費することで一度呼び出すことができることを示しています。
<!--Additionally, some closures implement more specific call traits:-->
さらに、クロージャによっては、より具体的なコール特性を実装するものもあります。

* <!--A closure which does not move out of any captured variables implements [`FnMut`], indicating that it can be called by mutable reference.-->
   キャプチャされた変数から移動しないクロージャは、[`FnMut`]実装しています。これは、可変参照によって呼び出すことができることを示しています。

* <!--A closure which does not mutate or move out of any captured variables implements [`Fn`], indicating that it can be called by shared reference.-->
   キャプチャされた変数から変化したり移動したりしないクロージャは、共有参照によって呼び出すことができることを示す[`Fn`]実装します。

> <!--Note: `move` closures may still implement [`Fn`] or [`FnMut`], even though they capture variables by move.-->
> 注意： `move`クロージャは、移動によって変数を取得しても、[`Fn`]または[`FnMut`]実装することができます。
> <!--This is because the traits implemented by a closure type are determined by what the closure does with captured values, not how it captures them.-->
> これは、クロージャータイプによって実装された特性は、クロージャーがキャプチャされた値によってどのように処理されるかによって決定され、キャプチャの方法では決まらないからです。

<!--*Non-capturing closures* are closures that don't capture anything from their environment.-->
*非キャプチャクロージャ*は、環境から何もキャプチャしないクロージャです。
<!--They can be coerced to function pointers (`fn`) with the matching signature.-->
一致するシグニチャを使用してポインター（`fn`）を機能させるように強制できます。

```rust
let add = |x, y| x + y;

let mut x = add(5,7);

type Binop = fn(i32, i32) -> i32;
let bo: Binop = add;
x = bo(5,7);
```

### <!--Other traits--> その他の特色

<!--All closure types implement [`Sized`].-->
すべてのクロージャタイプは[`Sized`]実装しています。
<!--Additionally, closure types implement the following traits if allowed to do so by the types of the captures it stores:-->
さらに、格納されているキャプチャの種類によって許可されている場合、クロージャ型は次の特性を実装します。

* [`Clone`]
* [`Copy`]
* [`Sync`]
* [`Send`]

<!--The rules for [`Send`] and [`Sync`] match those for normal struct types, while [`Clone`] and [`Copy`] behave as if [derived][derive].-->
[`Send`]と[`Sync`]のルールは通常のstructタイプのルールと一致し、[`Clone`]と[`Copy`] [derived][derive]れたかのように動作します。
<!--For [`Clone`], the order of cloning of the captured variables is left unspecified.-->
[`Clone`]では、キャプチャされた変数のクローンの順序は不定のままです。

<!--Because captures are often by reference, the following general rules arise:-->
キャプチャはしばしば参考になるため、次の一般的な規則が発生します。

* <!--A closure is [`Sync`] if all captured variables are [`Sync`].-->
   キャプチャされたすべての変数が[`Sync`]場合、クロージャは[`Sync`]です。
* <!--A closure is [`Send`] if all variables captured by non-unique immutable reference are [`Sync`], and all values captured by unique immutable or mutable reference, copy, or move are [`Send`].-->
   クロージャは[`Send`]非固有の不変参照によって取り込まれたすべての変数がある場合[`Sync`]、ユニークな不変又は可変参照、コピー、または移動によって捕捉すべての値である[`Send`]。
* <!--A closure is [`Clone`] or [`Copy`] if it does not capture any values by unique immutable or mutable reference, and if all values it captures by copy or move are [`Clone`] or [`Copy`], respectively.-->
   閉鎖はある[`Clone`]または[`Copy`]それが独特の不変または可変参照することにより任意の値をキャプチャしていない場合は、コピーまたは移動することによって、それはキャプチャすべての値がある場合は[`Clone`]または[`Copy`]それぞれ。

## <!--Trait objects--> 特性オブジェクト

> <!--**<sup>Syntax</sup>**  _TraitObjectType_ : &nbsp;&nbsp;-->
> **<sup>構文</ sup>**  _TraitObjectType_ ：＆nbsp;＆nbsp;
> <!--`dyn`  __?__ -->
> `dyn`  __？__ 
> <!-- _TypeParamBounds_ -->
>  _TypeParamBounds_ 

<!--A *trait object* is an opaque value of another type that implements a set of traits.-->
*特性オブジェクト*は、一連の特性を実装する別のタイプの不透明な値です。
<!--The set of traits is made up of an [object safe] *base trait* plus any number of [auto traits].-->
特性のセットは、[object safe] *ベースの特性*と任意の数の[auto traits]ます。

<!--Trait objects implement the base trait, its auto traits, and any [supertraits] of the base trait.-->
Traitオブジェクトは、基本特性、その自動特性、および基本特性の任意の[supertraits]基準を実装します。

<!--Trait objects are written as the optional keyword `dyn` followed by a set of trait bounds, but with the following restrictions on the trait bounds.-->
特性オブジェクトは、オプションのキーワード`dyn`それに続く特性境界のセットとして記述されますが、特性境界には以下の制限があります。
<!--All traits except the first trait must be auto traits, there may not be more than one lifetime, and opt-out bounds (eg `?sized`) are not allowed.-->
最初の形質を除くすべての形質は自動形質でなければならず、複数の生存期間が存在せず、オプトアウト範囲（例えば、`?sized`）は認められない。
<!--Furthermore, paths to traits may be parenthesized.-->
さらに、形質への経路はカッコで囲むことができます。

<!--For example, given a trait `Trait`, the following are all trait objects:-->
たとえば、特性`Trait`指定すると、以下のすべてが特性オブジェクトです。

* `Trait`
* `dyn Trait`
* `dyn Trait + Send`
* `dyn Trait + Send + Sync`
* `dyn Trait + 'static`
* `dyn Trait + Send + 'static`
* `dyn Trait +`
* <!--`dyn 'static + Trait`.-->
   `dyn 'static + Trait`。
* `dyn (Trait)`

<!--If the first bound of the trait object is a path that starts with `::`, then the `dyn` will be treated as a part of the path.-->
特性オブジェクトの最初の境界が`::`で始まるパスである場合、`dyn`はパスの一部として扱われます。
<!--The first path can be put in parenthesis to get around this.-->
これを回避するために、最初のパスを括弧で入れることができます。
<!--As such, if you want a trait object with the trait `::your_module::Trait`, you should write it as `dyn (::your_module::Trait)`.-->
そのため、trait `::your_module::Trait`で形質オブジェクトが必要な場合は、`dyn (::your_module::Trait)`記述する必要があります。

> <!--Note: For clarity, it is recommended to always use the `dyn` keyword on your trait objects unless your codebase supports compiling with Rust 1.26 or lower.-->
> 注意：コードベースがRust 1.26以下のコンパイルをサポートしていない限り、明快にするために、traitオブジェクトに常に`dyn`キーワードを使用することをお勧めします。

<!--Two trait object types alias each other if the base traits alias each other and if the sets of auto traits are the same and the lifetime bounds are the same.-->
基本特性がお互いに別名であり、かつ自動特性の集合が同じであり、生涯の境界が同じである場合、2つの特性オブジェクト型は互いにエイリアスする。
<!--For example, `dyn Trait + Send + UnwindSafe` is the same as `dyn Trait + Unwindsafe + Send`.-->
たとえば、`dyn Trait + Send + UnwindSafe`は`dyn Trait + Unwindsafe + Send`と同じです。

Div ("",["warning"],[]) [RawBlock (Format "html") "</p>",Plain [LineBreak],Para [Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "*",Space,Strong [Str "Warning:"],Space,Str "*",Space,Str "With",Space,Str "two",Space,Str "trait",Space,Str "object",Space,Str "types,",Space,Str "even",Space,Str "when",Space,Str "the",Space,Str "complete",Space,Str "set",Space,Str "of",Space,Str "traits",Space,Str "is",Space,Str "the",Space,Str "same,",Space,Str "if",Space,Str "the",Space,Str "base",Space,Str "traits",Space,Str "differ,",Space,Str "the",Space,Str "type",Space,Str "is",Space,Str "different."],Space,Str "*",Space,Strong [Str "\35686\21578\65306"],Space,Str "*",Space,Str "2\12388\12398\24418\36074\12458\12502\12472\12455\12463\12488\22411\12391\12399\12289\23436\20840\12394\24418\36074\12475\12483\12488\12364\21516\12376\12391\12354\12387\12390\12418\12289\22522\26412\24418\36074\12364\30064\12394\12427\22580\21512\12289\22411\12364\30064\12394\12426\12414\12377\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "For",Space,Str "example,",Space,Code ("",[],[]) "dyn Send + Sync",Space,Str "is",Space,Str "a",Space,Str "different",Space,Str "type",Space,Str "from",Space,Code ("",[],[]) "dyn Sync + Send",Space,Str "."],Str "\12383\12392\12360\12400\12289",Space,Code ("",[],[]) "dyn Send + Sync",Str "\12399",Code ("",[],[]) "dyn Sync + Send",Str "\12392\12399\30064\12394\12427\12479\12452\12503\12391\12377\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "See",Space,Link ("",["notranslate"],[]) [Str "issue",Space,Str "33140"] ("#4issue%2033140",""),Space,Str "."],Space,Link ("",["notranslate"],[]) [Str "issue",Space,Str "33140"] ("#4issue%2033140",""),Str "\21442\29031\12375\12390\12367\12384\12373\12356\12290"]],Plain [LineBreak]]RawBlock (Format "html") "</p>"
<!--Due to the opaqueness of which concrete type the value is of, trait objects are [dynamically sized types].-->
値がどのような具体的な型であるかの不透明さのため、特性オブジェクトは[dynamically sized types]。
<!--Like all RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTsRawInline (Format "html") "</abbr>", trait objects are used behind some type of pointer;-->
すべてのRawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTRawInline (Format "html") "</abbr>"と同様、特性オブジェクトはある種のポインタの後ろで使用されます。
<!--for example `&dyn SomeTrait` or `Box<dyn SomeTrait>`.-->
たとえば、`&dyn SomeTrait`または`Box<dyn SomeTrait>` `&dyn SomeTrait`（ `Box<dyn SomeTrait>`。
<!--Each instance of a pointer to a trait object includes:-->
traitオブジェクトへのポインタの各インスタンスには、次のものが含まれます。

 - <!--a pointer to an instance of a type `T` that implements `SomeTrait`-->
    `SomeTrait`を実装する`T`型のインスタンスへのポインタ
 - <!--a  _virtual method table_ , often just called a  _vtable_ , which contains, for each method of `SomeTrait` and its [supertraits] that `T` implements, a pointer to `T` 's implementation (ie a function pointer).-->
    `SomeTrait`各メソッドと`T`実装する[supertraits] `SomeTrait`、 `T`の実装（つまり、関数ポインタ）へのポインタを含む _vtable_ と呼ばれる _仮想メソッドテーブル_ です。

<!--The purpose of trait objects is to permit "late binding"of methods.-->
特性オブジェクトの目的は、メソッドの「レイトバインディング」を可能にすることです。
<!--Calling a method on a trait object results in virtual dispatch at runtime: that is, a function pointer is loaded from the trait object vtable and invoked indirectly.-->
traitオブジェクトのメソッドを呼び出すと、実行時に仮想ディスパッチが行われます。つまり、関数ポインタがtraitオブジェクトvtableからロードされ、間接的に呼び出されます。
<!--The actual implementation for each vtable entry can vary on an object-by-object basis.-->
各vtableエントリの実際の実装は、オブジェクトごとに異なる可能性があります。

<!--An example of a trait object:-->
形質オブジェクトの例：

```rust
trait Printable {
    fn stringify(&self) -> String;
}

impl Printable for i32 {
    fn stringify(&self) -> String { self.to_string() }
}

fn print(a: Box<dyn Printable>) {
    println!("{}", a.stringify());
}

fn main() {
    print(Box::new(10) as Box<dyn Printable>);
}
```

<!--In this example, the trait `Printable` occurs as a trait object in both the type signature of `print`, and the cast expression in `main`.-->
この例では、`Printable`という特性は、`print`の型シグネチャと`main`キャスト式の両方で、traitオブジェクトとして発生します。

### <!--Trait Object Lifetime Bounds--> 特性オブジェクトの寿命

<!--Since a trait object can contain references, the lifetimes of those references need to be expressed as part of the trait object.-->
特性オブジェクトは参照を含むことができるので、これらの参照の寿命は特性オブジェクトの一部として表現する必要があります。
<!--This lifetime is written as `Trait + 'a`.-->
この生涯は`Trait + 'a`として書かれ`Trait + 'a`ます。
<!--There are [defaults] that allow this lifetime to usually be inferred with a sensible choice.-->
通常、この生涯を賢明な選択で推論することができる[defaults]があります。

[defaults]: lifetime-elision.html#default-trait-object-lifetimes

## <!--Type parameters--> タイプパラメータ

<!--Within the body of an item that has type parameter declarations, the names of its type parameters are types:-->
型パラメータ宣言を持つ項目の本体内では、型パラメータの名前は型です。

```rust
fn to_vec<A: Clone>(xs: &[A]) -> Vec<A> {
    if xs.is_empty() {
        return vec![];
    }
    let first: A = xs[0].clone();
    let mut rest: Vec<A> = to_vec(&xs[1..]);
    rest.insert(0, first);
    rest
}
```

<!--Here, `first` has type `A`, referring to `to_vec` 's `A` type parameter;-->
ここでは、`first`に`to_vec`の`A`型パラメータを参照する型`A`あります。
<!--and `rest` has type `Vec<A>`, a vector with element type `A`.-->
`rest`は要素型`A`ベクトルである`Vec<A>`型があります。

## <!--Anonymous type parameters--> 匿名型のパラメータ

> <!--Note: This section is a placeholder for more comprehensive reference material.-->
> 注：このセクションは、より包括的なリファレンス資料のプレースホルダーです。

> <!--Note: This is often called "impl Trait in argument position".-->
> 注：これはしばしば「引数位置のimpl Trait」と呼ばれます。

<!--Functions can declare an argument to be an anonymous type parameter where the callee must provide a type that has the bounds declared by the anonymous type parameter and the function can only use the methods available by the trait bounds of the anonymous type parameter.-->
関数は、匿名型パラメータである引数を宣言することができ、匿名型パラメータによって宣言された境界を持つ型を呼び出し元が提供しなければならず、関数は匿名型パラメータの特性境界によって使用可能なメソッドのみを使用できます。

<!--They are written as `impl` followed by a set of trait bounds.-->
彼らは次のように書かれている`impl`形質境界のセットが続きます。

## <!--Abstract return types--> 抽象型の戻り値の型

> <!--Note: This section is a placeholder for more comprehensive reference material.-->
> 注：このセクションは、より包括的なリファレンス資料のプレースホルダーです。

> <!--Note: This is often called "impl Trait in return position".-->
> 注：これは、しばしば "戻り位置でのインプット特性"と呼ばれます。

<!--Functions, except for associated trait functions, can return an abstract return type.-->
関連する特性関数を除く関数は、抽象型の戻り値を返すことができます。
<!--These types stand in for another concrete type where the use-site may only use the trait methods declared by the trait bounds of the type.-->
これらの型は、使用サイトがその型の特性境界によって宣言された形質メソッドのみを使用することができる別の具体的な型のために存在します。

<!--They are written as `impl` followed by a set of trait bounds.-->
彼らは次のように書かれている`impl`形質境界のセットが続きます。

## <!--Self types--> セルフタイプ

<!--The special type `Self` has a meaning within traits and implementations: it refers to the implementing type.-->
特殊型の`Self`は、特性や実装の中で意味を持ちます。実装型を指します。
<!--For example, in:-->
たとえば、次のようになります。

```rust
pub trait From<T> {
    fn from(T) -> Self;
}

impl From<i32> for String {
    fn from(x: i32) -> Self {
        x.to_string()
    }
}
```

<!--The notation `Self` in the impl refers to the implementing type: `String`.-->
表記`Self`：IMPLでは、実装タイプを意味する`String`。
<!--In another example:-->
別の例では：

```rust
trait Printable {
    fn make_string(&self) -> String;
}

impl Printable for String {
    fn make_string(&self) -> String {
        (*self).clone()
    }
}
```

> <!--Note: The notation `&self` is a shorthand for `self: &Self`.-->
> 注記： `&self`という表記は、`self: &Self`略語です。

<!--[`Fn`]: ../std/ops/trait.Fn.html
 [`FnMut`]: ../std/ops/trait.FnMut.html
 [`FnOnce`]: ../std/ops/trait.FnOnce.html
 [`Copy`]: special-types-and-traits.html#copy
 [`Clone`]: special-types-and-traits.html#clone
 [`Send`]: special-types-and-traits.html#send
 [`Sync`]: special-types-and-traits.html#sync
 [`Sized`]: special-types-and-traits.html#sized
 [derive]: attributes.html#derive
 [`Vec<T>`]: ../std/vec/struct.Vec.html
 [dynamically sized type]: dynamically-sized-types.html
 [dynamically sized types]: dynamically-sized-types.html
 [struct expression]: expressions/struct-expr.html
 [closure expression]: expressions/closure-expr.html
 [auto traits]: special-types-and-traits.html#auto-traits
 [object safe]: items/traits.html#object-safety
 [issue 47010]: https://github.com/rust-lang/rust/issues/47010
 [issue 33140]: https://github.com/rust-lang/rust/issues/33140
 [_PATH_]: paths.html
 [_LIFETIME_OR_LABEL_]: tokens.html#lifetimes-and-loop-labels
 [supertraits]: items/traits.html#supertraits
-->
[`Fn`]: ../std/ops/trait.Fn.html
 [`FnMut`]: ../std/ops/trait.FnMut.html
 [`FnOnce`]: ../std/ops/trait.FnOnce.html
 [`Copy`]: special-types-and-traits.html#copy
 [`Clone`]: special-types-and-traits.html#clone
 [`Send`]: special-types-and-traits.html#send
 [`Sync`]: special-types-and-traits.html#sync
 [`Sized`]: special-types-and-traits.html#sized
 [derive]: attributes.html#derive
 [`Vec<T>`]: ../std/vec/struct.Vec.html
 [dynamically sized type]: dynamically-sized-types.html
 [dynamically sized types]: dynamically-sized-types.html
 [struct expression]: expressions/struct-expr.html
 [closure expression]: expressions/closure-expr.html
 [auto traits]: special-types-and-traits.html#auto-traits
 [object safe]: items/traits.html#object-safety
 [issue 47010]: https://github.com/rust-lang/rust/issues/47010
 [issue 33140]: https://github.com/rust-lang/rust/issues/33140
 [_PATH_]: paths.html
 [_LIFETIME_OR_LABEL_]: tokens.html#lifetimes-and-loop-labels
 [supertraits]: items/traits.html#supertraits

