# <!--Type Layout--> タイプレイアウト

<!--The layout of a type is its size, alignment, and the relative offsets of its fields.-->
型のレイアウトは、そのサイズ、整列、およびフィールドの相対的なオフセットです。
<!--For enums, how the discriminant is laid out and interpreted is also part of type layout.-->
列挙型の場合、判別式がどのようにレイアウトされ、解釈されるかは、レイアウトタイプの一部です。

<!--Type layout can be changed with each compilation.-->
タイプのレイアウトは、コンパイルごとに変更できます。
<!--Instead of trying to document exactly what is done, we only document what is guaranteed today.-->
何が行われたかを正確に文書化しようとするのではなく、今日保証されているものだけを文書化します。

## <!--Size and Alignment--> サイズとアライメント

<!--All values have an alignment and size.-->
すべての値にアライメントとサイズがあります。

<!--The *alignment* of a value specifies what addresses are valid to store the value at.-->
値の*整列*は、値を格納するために有効なアドレスを指定します。
<!--A value of alignment `n` must only be stored at an address that is a multiple of n.-->
整列`n`の値は、nの倍数であるアドレスにのみ格納する必要があります。
<!--For example, a value with an alignment of 2 must be stored at an even address, while a value with an alignment of 1 can be stored at any address.-->
たとえば、整列2の値は偶数アドレスに格納する必要があり、整列1の値は任意のアドレスに格納できます。
<!--Alignment is measured in bytes, and must be at least 1, and always a power of 2. The alignment of a value can be checked with the [`align_of_val`] function.-->
アラインメントはバイト単位で測定され、少なくとも1でなければならず、常に2の累乗でなければなりません。値のアライメントは[`align_of_val`]関数で確認できます。

<!--The *size* of a value is the offset in bytes between successive elements in an array with that item type including alignment padding.-->
値の*サイズ*は、アライメントパディングを含むアイテムタイプの配列内の連続する要素間のバイト単位のオフセットです。
<!--The size of a value is always a multiple of its alignment.-->
値のサイズは、常にその配置の倍数です。
<!--The size of a value can be checked with the [`size_of_val`] function.-->
値の大きさは[`size_of_val`]関数で調べることができます。

<!--Types where all values have the same size and alignment known at compile time implement the [`Sized`] trait and can be checked with the [`size_of`] and [`align_of`] functions.-->
すべての値がコンパイル時に知られている同じサイズとアライメントを持っているタイプは、実装[`Sized`]形質をとで確認することができ[`size_of`]と[`align_of`]機能。
<!--Types that are not [`Sized`] are known as [dynamically sized types].-->
[`Sized`] 」されていないタイプは、[dynamically sized types]呼ばれ[dynamically sized types]。
<!--Since all values of a `Sized` type share the same size and alignment, we refer to those shared values as the size of the type and the alignment of the type respectively.-->
`Sized`型の値はすべて同じサイズと配置で共有されるため、これらの共有値は型のサイズと型の整列としてそれぞれ参照します。

## <!--Primitive Data Layout--> プリミティブデータレイアウト

<!--The size of most primitives is given in this table.-->
この表には、ほとんどのプリミティブのサイズが示されています。

<!--Type |-->
タイプ|
<!--`size_of::<Type>()` -|-->
`size_of::<Type>()` -|
<!---|-->
-|
<!---bool |-->
-ブール|
<!--1 u8 |-->
1 u8 |
<!--1 u16 |-->
1 u16 |
<!--2 u32 |-->
2 u32 |
<!--4 u64 |-->
4 u64 |
<!--8 u128 |-->
8 u128 |
<!--16 i8 |-->
16 i8 |
<!--1 i16 |-->
1 i16 |
<!--2 i32 |-->
2 i32 |
<!--4 i64 |-->
4 i64 |
<!--8 i128 |-->
8 i128 |
<!--16 f32 |-->
16 f32 |
<!--4 f64 |-->
4 f64 |
<!--8 char |-->
8文字|
<!--4-->
4

<!--`usize` and `isize` have a size big enough to contain every address on the target platform.-->
`usize`と`isize`は、ターゲットプラットフォーム上のすべてのアドレスを格納できる大きさです。
<!--For example, on a 32 bit target, this is 4 bytes and on a 64 bit target, this is 8 bytes.-->
たとえば、32ビットのターゲットでは、これは4バイトで、64ビットのターゲットでは、これは8バイトです。

<!--Most primitives are generally aligned to their size, although this is platform-specific behavior.-->
ほとんどのプリミティブは、プラットフォーム固有の動作ですが、一般にサイズに合わせて配置されます。
<!--In particular, on x86 u64 and f64 are only aligned to 32 bits.-->
特に、x86ではu64とf64は32ビットにしか整列しません。

## <!--Pointers and References Layout--> ポインタと参照のレイアウト

<!--Pointers and references have the same layout.-->
ポインタと参照は同じレイアウトです。
<!--Mutability of the pointer or reference does not change the layout.-->
ポインターまたは参照の変更はレイアウトを変更しません。

<!--Pointers to sized types have the same size and alignment as `usize`.-->
サイズが指定された型へのポインタは、`usize`と同じサイズと整列を`usize`ます。

<!--Pointers to unsized types are sized.-->
サイズの指定されていない型へのポインタのサイズが設定されます。
<!--The size and alignment is guaranteed to be at least equal to the size and alignment of a pointer.-->
サイズと配置は、少なくともポインタのサイズと配置に等しいことが保証されています。

> <!--Note: Though you should not rely on this, all pointers to RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12398\22793\26356\12373\12428\12383\22411\">"DSTsRawInline (Format "html") "</abbr>" are currently twice the size of the size of `usize` and have the same alignment.-->
> 注：このに頼るべきではありませんがRawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12398\22793\26356\12373\12428\12383\22411\">"、DSTSRawInline (Format "html") "</abbr>"へのすべてのポインタは、現在のサイズの2倍のサイズです`usize`と同じ配置を持っています。

## <!--Array Layout--> 配列のレイアウト

<!--Arrays are laid out so that the `nth` element of the array is offset from the start of the array by `n * the size of the type` bytes.-->
配列の`nth`要素は、配列の先頭から`n * the size of the type`バイトの`n * the size of the type`だけオフセットされるように配列が配置されます。
<!--An array of `[T; n]`-->
`[T; n]`
<!--`[T; n]` has a size of `size_of::<T>() * n` and the same alignment of `T`.-->
`[T; n]`は`size_of::<T>() * n`サイズを`size_of::<T>() * n`、同じアライメント`T`持ちます。

## <!--Slice Layout--> スライスレイアウト

<!--Slices have the same layout as the section of the array they slice.-->
スライスは、スライスした配列のセクションと同じレイアウトです。

> <!--Note: This is about the raw `[T]` type, not pointers (`&[T]`, `Box<[T]>`, etc.) to slices.-->
> 注：これはスライスへのポインタ（`&[T]`、 `Box<[T]>`など）ではなく、生の`[T]`タイプに関するものです。

## <!--Tuple Layout--> タプルレイアウト

<!--Tuples do not have any guarantees about their layout.-->
タプルはそのレイアウトについていかなる保証もしていません。

<!--The exception to this is the unit tuple (`()`) which is guaranteed as a zero-sized type to have a size of 0 and an alignment of 1.-->
例外として、サイズが0でアライメントが1のゼロサイズの型として保証されているユニットタプル（`()`）があります。

## <!--Trait Object Layout--> 特性オブジェクトのレイアウト

<!--Trait objects have the same layout as the value the trait object is of.-->
特性オブジェクトは、特性オブジェクトの値と同じレイアウトを持ちます。

> <!--Note: This is about the raw trait object types, not pointers (`&Trait`, `Box<Trait>`, etc.) to trait objects.-->
> 注：これは、生の形質オブジェクトの種類についてのものであり、特性オブジェクトに対するポインタ（`&Trait`、 `Box<Trait>`など）ではありません。

## <!--Closure Layout--> クローズレイアウト

<!--Closures have no layout guarantees.-->
クロージャにはレイアウト保証はありません。

## <!--Representations--> 表現

<!--All user-defined composite types (`struct` s, `enum` s, and `union` s) have a *representation* that specifies what the layout is for the type.-->
すべてのユーザ定義コンポジット型（`struct` s、`enum` s、および`union` s）は、そのレイアウトがその型に対して何であるかを指定する*表現*を持ちます。

<!--The possible representations for a type are the default representation, `C`, the primitive representations, and `packed`.-->
型の考えられる表現は、デフォルト表現`C`、プリミティブ表現、および`packed`表現です。
<!--Multiple representations can be applied to a single type.-->
1つのタイプに複数の表現を適用できます。

<!--The representation of a type can be changed by applying the [`repr` attribute] to it.-->
型の表現は、[`repr` attribute]をそれに適用することによって変更することができます。
<!--The following example shows a struct with a `C` representation.-->
次の例は、`C`表現の構造体を示しています。

```
#[repr(C)]
struct ThreeInts {
    first: i16,
    second: i8,
    third: i32
}
```

> <!--Note: As a consequence of the representation being an attribute on the item, the representation does not depend on generic parameters.-->
> 注意：表現がアイテムの属性であるため、表現は汎用パラメータに依存しません。
> <!--Any two types with the same name have the same representation.-->
> 同じ名前を持つ2つの型はすべて同じ表現です。
> <!--For example, `Foo<Bar>` and `Foo<Baz>` both have the same representation.-->
> たとえば、`Foo<Bar>`と`Foo<Baz>`どちらも同じ表現をしています。

<!--The representation of a type does not change the layout of its fields.-->
型の表現はフィールドのレイアウトを変更しません。
<!--For example, a struct with a `C` representation that contains a struct `Inner` with the default representation will not change the layout of Inner.-->
たとえば、デフォルトの表現で構造体`Inner`を含む`C`表現の構造体は、`Inner`のレイアウトを変更しません。

### <!--The Default Representation--> デフォルト表現

<!--Nominal types without a `repr` attribute have the default representation.-->
`repr`属性を持たない名義型にはデフォルトの表現があります。
<!--Informally, this representation is also called the `rust` representation.-->
非公式には、この表現は`rust`表現とも呼ばれます。

<!--There are no guarantees of data layout made by this representation.-->
この表現によってデータレイアウトが保証されることはありません。

### <!--The `C` Representation--> `C`表現

<!--The `C` representation is designed for dual purposes.-->
`C`表現は、二重目的のために設計されています。
<!--One purpose is for creating types that are interoptable with the C Language.-->
1つの目的は、C言語で互換性のある型を作成することです。
<!--The second purpose is to create types that you can soundly performing operations that rely on data layout such as reinterpreting values as a different type.-->
第2の目的は、値を別のタイプとして再解釈するなど、データレイアウトに依存する操作を健全に実行できるタイプを作成することです。

<!--Because of this dual purpose, it is possible to create types that are not useful for interfacing with the C programming language.-->
この2つの目的のために、Cプログラミング言語とのインタフェースには役に立たない型を作成することは可能です。

<!--This representation can be applied to structs, unions, and enums.-->
この表現は、構造体、共用体、および列挙型に適用できます。

#### <!--\# [repr(C)] Structs--> \ [repr(C)]

<!--The alignment of the struct is the alignment of the most-aligned field in it.-->
構造体の配置は、その中で最も整列したフィールドの配置です。

<!--The size and offset of fields is determined by the following algorithm.-->
フィールドのサイズおよびオフセットは、以下のアルゴリズムによって決定されます。

<!--Start with a current offset of 0 bytes.-->
0バイトの現在のオフセットで開始します。

<!--For each field in declaration order in the struct, first determine the size and alignment of the field.-->
構造体の宣言順の各フィールドについて、まずフィールドのサイズと配置を決定します。
<!--If the current offset is not a multiple of the field's alignment, then add padding bytes to the current offset until it is a multiple of the field's alignment.-->
現在のオフセットがフィールドの配置の倍数でない場合は、フィールドの配置の倍数になるまで現在のオフセットにパディングバイトを追加します。
<!--The offset for the field is what the current offset is now.-->
フィールドのオフセットは現在のオフセットとなります。
<!--Then increase the current offset by the size of the field.-->
次に、現在のオフセットをフィールドのサイズだけ大きくします。

<!--Finally, the size of the struct is the current offset rounded up to the nearest multiple of the struct's alignment.-->
最後に、構造体のサイズは、構造体の配置の最も近い倍数に切り上げられた現在のオフセットです。

<!--Here is this algorithm described in pseudocode.-->
ここに、擬似コードで説明されているアルゴリズムがあります。

```rust,ignore
struct.alignment = struct.fields().map(|field| field.alignment).max();

let current_offset = 0;

for field in struct.fields_in_declaration_order() {
#    // Increase the current offset so that it's a multiple of the alignment
#    // of this field. For the first field, this will always be zero.
#    // The skipped bytes are called padding bytes.
    // このフィールドの位置合わせの倍数になるように、現在のオフセットを増やします。最初のフィールドでは、これは常にゼロになります。スキップされたバイトはパディングバイトと呼ばれます。
    current_offset += field.alignment % current_offset;

    struct[field].offset = current_offset;

    current_offset += field.size;
}

struct.size = current_offset + current_offset % struct.alignment;
```

> <!--Note: This algorithm can produce zero-sized structs.-->
> 注：このアルゴリズムはサイズがゼロの構造体を生成できます。
> <!--This differs from C where structs without data still have a size of one byte.-->
> これは、データのないstructsのサイズがまだ1バイトであるCとは異なります。

#### <!--\# [repr(C)] Unions--> \ [repr(C)]共用体

<!--A union declared with `#[repr(C)]` will have the same size and alignment as an equivalent C union declaration in the C language for the target platform.-->
`#[repr(C)]`宣言された共用体は、ターゲットプラットフォームのC言語で同等のC共用体宣言と同じサイズと位置合わせを持ちます。
<!--The union will have a size of the maximum size of all of its fields rounded to its alignment, and an alignment of the maximum alignment of all of its fields.-->
共用体は、すべてのフィールドの最大サイズが、その整列に丸められ、すべてのフィールドの最大整列が整列されます。
<!--These maximums may come from different fields.-->
これらの最大値は、異なるフィールドから来る場合があります。

```
#[repr(C)]
union Union {
    f1: u16,
    f2: [u8; 4],
}

#//assert_eq!(std::mem::size_of::<Union>(), 4);  // From f2
assert_eq!(std::mem::size_of::<Union>(), 4);  //  f2から
#//assert_eq!(std::mem::align_of::<Union>(), 2); // From f1
assert_eq!(std::mem::align_of::<Union>(), 2); //  f1から

#[repr(C)]
union SizeRoundedUp {
   a: u32,
   b: [u16; 3],
}

#//assert_eq!(std::mem::size_of::<SizeRoundedUp>(), 8);  // Size of 6 from b,
#                                                      // rounded up to 8 from
#                                                      // alignment of a.
assert_eq!(std::mem::size_of::<SizeRoundedUp>(), 8);  //  bからの6のサイズ、aの整列から8までの切り上げ。
#//assert_eq!(std::mem::align_of::<SizeRoundedUp>(), 4); // From a
assert_eq!(std::mem::align_of::<SizeRoundedUp>(), 4); // から
```

#### <!--\# [repr(C)] Enums--> \＃repr [repr(C)]列挙型

<!--For [C-like enumerations], the `C` representation has the size and alignment of the default `enum` size and alignment for the target platform's C ABI.-->
[C-like enumerations]場合、`C`表現は、ターゲットプラットフォームのC ABIのデフォルトの`enum`サイズと配置のサイズと配置を持ちます。

> <!--Note: The enum representation in C is implementation defined, so this is really a "best guess".-->
> 注：Cでのenum表現は実装定義されているので、これは実際には「最良の推測」です。
> <!--In particular, this may be incorrect when the C code of interest is compiled with certain flags.-->
> 特に、関心のあるCコードが特定のフラグでコンパイルされていると、これは正しくない可能性があります。

Div ("",["warning"],[]) [RawBlock (Format "html") "</p>",Plain [LineBreak],Para [Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "Warning:",Space,Str "There",Space,Str "are",Space,Str "crucial",Space,Str "differences",Space,Str "between",Space,Str "an",Space,Code ("",[],[]) "enum",Space,Str "in",Space,Str "the",Space,Str "C",Space,Str "language",Space,Str "and",Space,Str "Rust's",Space,Str "C-like",Space,Str "enumerations",Space,Str "with",Space,Str "this",Space,Str "representation."],Str "\35686\21578\65306\12398\38291\12395\27770\23450\30340\12394\36949\12356\12364\12354\12426\12414\12377",Code ("",[],[]) "enum",Space,Str "\12289C\35328\35486\12392\12371\12398\34920\29694\12391\37638\12398C-\12398\12424\12358\12394\21015\25369\22411\12391\12399\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "An",Space,Code ("",[],[]) "enum",Space,Str "in",Space,Str "C",Space,Str "is",Space,Str "mostly",Space,Str "a",Space,Code ("",[],[]) "typedef",Space,Str "plus",Space,Str "some",Space,Str "named",Space,Str "constants;"],Space,Str "C\12398",Code ("",[],[]) "enum",Str "\12399\20027\12395",Code ("",[],[]) "typedef",Str "\12392\12356\12367\12388\12363\12398\21517\21069\20184\12365\23450\25968\12391\12377\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "in",Space,Str "other",Space,Str "words,",Space,Str "an",Space,Str "object",Space,Str "of",Space,Str "an",Space,Code ("",[],[]) "enum",Space,Str "type",Space,Str "can",Space,Str "hold",Space,Str "any",Space,Str "integer",Space,Str "value."],Str "\12388\12414\12426\12289",Space,Code ("",[],[]) "enum",Str "\22411\12398\12458\12502\12472\12455\12463\12488\12399\20219\24847\12398\25972\25968\20516\12434\20445\25345\12391\12365\12414\12377\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "For",Space,Str "example,",Space,Str "this",Space,Str "is",Space,Str "often",Space,Str "used",Space,Str "for",Space,Str "bitflags",Space,Str "in",Space,Code ("",[],[]) "C",Space,Str "."],Str "\12383\12392\12360\12400\12289\12371\12428\12399",Code ("",[],[]) "C",Str "\12499\12483\12488\12501\12521\12483\12464\12395\12424\12367\20351\29992\12373\12428\12414\12377\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "In",Space,Str "contrast,",Space,Str "Rust's",Space,Str "C-like",Space,Str "enumerations",Space,Str "can",Space,Str "only",Space,Str "legally",Space,Str "hold",Space,Str "the",Space,Str "discriminant",Space,Str "values,",Space,Str "everything",Space,Str "else",Space,Str "is",Space,Str "undefined",Space,Str "behaviour."],Str "\23550\29031\30340\12395\12289Rust\12398C\12398\12424\12358\12394\21015\25369\22411\12399\24321\21029\20516\12434\21512\27861\30340\12395\20445\25345\12377\12427\12384\12369\12391\12289\20182\12398\12377\12409\12390\12399\26410\23450\32681\12398\25391\12427\33310\12356\12391\12377\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "Therefore,",Space,Str "using",Space,Str "a",Space,Str "C-like",Space,Str "enumeration",Space,Str "in",Space,Str "FFI",Space,Str "to",Space,Str "model",Space,Str "a",Space,Str "C",Space,Code ("",[],[]) "enum",Space,Str "is",Space,Str "often",Space,Str "wrong."],Str "\12375\12383\12364\12387\12390\12289C\12398",Code ("",[],[]) "enum",Str "\22411\12434\12514\12487\12523\21270\12377\12427\12383\12417\12395FFI\12391C\12398\12424\12358\12394\21015\25369\12434\20351\29992\12377\12427\12371\12392\12399\12289\12375\12400\12375\12400\38291\36949\12387\12390\12356\12414\12377\12290"]],Plain [LineBreak]]RawBlock (Format "html") "</p>"
<!--It is an error for [zero-variant enumerations] to have the `C` representation.-->
[zero-variant enumerations]が`C`表現を持つことは誤りです。

<!--For all other enumerations, the layout is unspecified.-->
その他のすべての列挙では、レイアウトは指定されていません。

<!--Likewise, combining the `C` representation with a primitive representation, the layout is unspecified.-->
同様に、`C`表現をプリミティブ表現と組み合わせると、レイアウトは指定されません。

### <!--Primitive representations--> プリミティブ表現

<!--The *primitive representations* are the representations with the same names as the primitive integer types.-->
*プリミティブ表現*はプリミティブ整数型と同じ名前の表現です。
<!--That is: `u8`, `u16`, `u32`, `u64`, `usize`, `i8`, `i16`, `i32`, `i64`, and `isize`.-->
つまり： `u8`、 `u16`、 `u32`、 `u64`、 `usize`、 `i8`、 `i16`、 `i32`、 `i64`、 `isize`です。

<!--Primitive representations can only be applied to enumerations.-->
プリミティブ表現は列挙にのみ適用できます。

<!--For [C-like enumerations], they set the size and alignment to be the same as the primitive type of the same name.-->
[C-like enumerations]では、同じ名前のプリミティブ型と同じになるようにサイズと配置を設定します。
<!--For example, a C-like enumeration with a `u8` representation can only have discriminants between 0 and 255 inclusive.-->
たとえば、`u8`表現を使用したCのような列挙では、0と255の間の判別式を持つことしかできません。

<!--It is an error for [zero-variant enumerations] to have a primitive representation.-->
[zero-variant enumerations]がプリミティブ表現を持つのは誤りです。

<!--For all other enumerations, the layout is unspecified.-->
その他のすべての列挙では、レイアウトは指定されていません。

<!--Likewise, combining two primitive representations together is unspecified.-->
同様に、2つのプリミティブ表現を組み合わせることも不特定である。

### <!--The `align` Representation--> `align`表現

<!--The `align` representation can be used on `struct` s and `union` s to raise the alignment of the type to a given value.-->
`align`表現は、`struct`および`union` `struct`で使用して、型の整列を所定の値に上げることができます。

<!--Alignment is specified as a parameter in the form of `#[repr(align(x))]`.-->
アラインメントは`#[repr(align(x))]`の形式でパラメータとして指定されます。
<!--The alignment value must be a power of two of type `u32`.-->
アライメント値は、タイプ`u32`の2の累乗でなければなりません。
<!--The `align` representation can raise the alignment of a type to be greater than it's primitive alignment, it cannot lower the alignment of a type.-->
`align`表現は、型の整列をプリミティブ整列よりも大きくすることができます。型の整列を下げることはできません。

<!--The `align` and `packed` representations cannot be applied on the same type and a `packed` type cannot transitively contain another `align` ed type.-->
`align`と`packed`表現は同じ型には適用できません。また、`packed`型は別の`align`型を`align`的に含むことはできません。

### <!--The `packed` Representation--> `packed`表現

<!--The `packed` representation can only be used on `struct` s and `union` s.-->
`packed`表現は、`struct`および`union` `struct`のみ使用できます。

<!--It modifies the representation (either the default or `C`) by removing any padding bytes and forcing the alignment of the type to `1`.-->
パディングバイトを削除し、タイプのアラインメントを`1`強制することによって、表現（デフォルトまたは`C`いずれか）を変更します。

<!--The `align` and `packed` representations cannot be applied on the same type and a `packed` type cannot transitively contain another `align` ed type.-->
`align`と`packed`表現は同じ型には適用できません。また、`packed`型は別の`align`型を`align`的に含むことはできません。

Div ("",["warning"],[]) [RawBlock (Format "html") "</p>",Plain [LineBreak],Para [Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "*",Space,Strong [Str "Warning:"],Space,Str "*",Space,Str "Dereferencing",Space,Str "an",Space,Str "unaligned",Space,Str "pointer",Space,Str "is",Space,Link ("",["notranslate"],[]) [Str "undefined",Space,Str "behaviour"] ("#4undefined%20behaviour",""),Space,Str "and",Space,Str "it",Space,Str "is",Space,Str "possible",Space,Str "to",Space,Link ("",[],[]) [Str "safely",Space,Str "create",Space,Str "unaligned",Space,Str "pointers",Space,Str "to",Space,Code ("",[],[]) "packed",Space,Str "fields"] ("#327060",""),Space,Str "."],Space,Str "*",Space,Strong [Str "\35686\21578\65306"],Space,Str "*\25972\21015\12373\12428\12390\12356\12394\12356\12509\12452\12531\12479\12434\21442\29031\35299\38500\12377\12427\12392\12289",Space,Link ("",["notranslate"],[]) [Str "undefined",Space,Str "behaviour"] ("#4undefined%20behaviour",""),Str "\12392\12394\12426",Link ("",[],[]) [Str "\12289",Space,Code ("",[],[]) "packed",Str "\12501\12451\12540\12523\12489\12408\12398\12450\12521\12452\12531\12373\12428\12390\12356\12394\12356\12509\12452\12531\12479\12434\23433\20840\12395\20316\25104\12377\12427"] ("#327060",""),Str "\12371\12392\12364\12391\12365",Link ("",[],[]) [Str "\12414\12377"] ("#327060",""),Space,Str "\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "Like",Space,Str "all",Space,Str "ways",Space,Str "to",Space,Str "create",Space,Str "undefined",Space,Str "behavior",Space,Str "in",Space,Str "safe",Space,Str "Rust,",Space,Str "this",Space,Str "is",Space,Str "a",Space,Str "bug."],Str "\23433\20840\12394Rust\12391\26410\23450\32681\12398\21205\20316\12434\20316\25104\12377\12427\12377\12409\12390\12398\26041\27861\12392\21516\27096\12395\12289\12371\12428\12399\12496\12464\12391\12377\12290"]],Plain [LineBreak]]RawBlock (Format "html") "</p>"
<!--[`align_of_val`]: ../std/mem/fn.align_of_val.html
 [`size_of_val`]: ../std/mem/fn.size_of_val.html
 [`align_of`]: ../std/mem/fn.align_of.html
 [`size_of`]: ../std/mem/fn.size_of.html
 [`Sized`]: ../std/marker/trait.Sized.html
 [dynamically sized types]: dynamically-sized-types.html
 [C-like enumerations]: %20items/enumerations.html#custom-discriminant-values-for-field-less-enumerations
 [zero-variant enumerations]: items/enumerations.html#zero-variant-enums
 [undefined behavior]: behavior-considered-undefined.html
 [27060]: https://github.com/rust-lang/rust/issues/27060
-->
[`align_of_val`]: ../std/mem/fn.align_of_val.html
 [`size_of_val`]: ../std/mem/fn.size_of_val.html
 [`align_of`]: ../std/mem/fn.align_of.html
 [`size_of`]: ../std/mem/fn.size_of.html
 [`Sized`]: ../std/marker/trait.Sized.html
 [dynamically sized types]: dynamically-sized-types.html
 [C-like enumerations]: %20items/enumerations.html#custom-discriminant-values-for-field-less-enumerations
 [zero-variant enumerations]: items/enumerations.html#zero-variant-enums
 [undefined behavior]: behavior-considered-undefined.html
 [27060]: https://github.com/rust-lang/rust/issues/27060

