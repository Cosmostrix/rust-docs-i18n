# <!--repr(Rust)--> レプ（錆）

<!--First and foremost, all types have an alignment specified in bytes.-->
まず第一に、すべての型はバイト単位でアライメントが指定されています。
<!--The alignment of a type specifies what addresses are valid to store the value at.-->
型の整列は、値を格納するために有効なアドレスを指定します。
<!--A value of alignment `n` must only be stored at an address that is a multiple of `n`.-->
整列`n`の値は、`n`倍数であるアドレスにのみ格納する必要があります。
<!--So alignment 2 means you must be stored at an even address, and 1 means that you can be stored anywhere.-->
したがって、アライメント2は偶数アドレスに格納する必要があり、1はどこにでも格納できることを意味します。
<!--Alignment is at least 1, and always a power of 2. Most primitives are generally aligned to their size, although this is platform-specific behavior.-->
アラインメントは少なくとも1であり、常に2の累乗です。ほとんどのプリミティブは、プラットフォーム固有の動作ですが、通常はサイズに合わせて配置されます。
<!--In particular, on x86 `u64` and `f64` may be only aligned to 32 bits.-->
特に、x86の場合、`u64`と`f64`は32ビットにのみ整列させることができます。

<!--A type's size must always be a multiple of its alignment.-->
型のサイズは、常にその整列の倍数でなければなりません。
<!--This ensures that an array of that type may always be indexed by offsetting by a multiple of its size.-->
これにより、その型の配列は常にそのサイズの倍数だけオフセットされてインデックスが作成されます。
<!--Note that the size and alignment of a type may not be known statically in the case of [dynamically sized types][dst].-->
[動的なサイズの型の][dst]場合は、型のサイズと位置合わせが静的にはわからない場合があることに注意してください。

<!--Rust gives you the following ways to lay out composite data:-->
錆は合成データをレイアウトするために以下の方法を提供します：

* <!--structs (named product types)-->
   構造体（名前付き製品タイプ）
* <!--tuples (anonymous product types)-->
   タプル（匿名の製品タイプ）
* <!--arrays (homogeneous product types)-->
   アレイ（均質な製品タイプ）
* <!--enums (named sum types --tagged unions)-->
   enums（名前付き合計型 -タグ付き共用体）

<!--An enum is said to be *field-less* if none of its variants have associated data.-->
列挙型は、そのバリアントにデータが関連付けられてい*ない*場合、*フィールドレスで*あると言われます。

<!--Composite structures will have an alignment equal to the maximum of their fields' alignment.-->
複合構造体は、フィールドのアライメントの最大値に等しいアラインメントを持ちます。
<!--Rust will consequently insert padding where necessary to ensure that all fields are properly aligned and that the overall type's size is a multiple of its alignment.-->
その結果、必要に応じてパディングを挿入して、すべてのフィールドが正しく整列され、全体の型のサイズがその整列の倍数になるようにします。
<!--For instance:-->
例えば：

```rust
struct A {
    a: u8,
    b: u32,
    c: u16,
}
```

<!--will be 32-bit aligned on an architecture that aligns these primitives to their respective sizes.-->
これらのプリミティブをそれぞれのサイズに整列させるアーキテクチャ上で32ビット整列されます。
<!--The whole struct will therefore have a size that is a multiple of 32-bits.-->
したがって、構造体全体のサイズは32ビットの倍数になります。
<!--It will potentially become:-->
潜在的には次のようになります。

```rust
struct A {
    a: u8,
#//    _pad1: [u8; 3], // to align `b`
    _pad1: [u8; 3], //  `b`を整列する
    b: u32,
    c: u16,
#//    _pad2: [u8; 2], // to make overall size multiple of 4
    _pad2: [u8; 2], // 全体のサイズを4の倍数にする
}
```

<!--There is *no indirection* for these types;-->
これらの型*の間接参照*はあり*ません*。
<!--all data is stored within the struct, as you would expect in C. However with the exception of arrays (which are densely packed and in-order), the layout of data is not by default specified in Rust.-->
すべてのデータはCで期待されるように構造体内に格納されますが、配列（密集して順番に配列されている）を除いて、データのレイアウトはデフォルトでRustで指定されていません。
<!--Given the two following struct definitions:-->
以下の2つの構造体定義が与えられているとします。

```rust
struct A {
    a: i32,
    b: u64,
}

struct B {
    a: i32,
    b: u64,
}
```

<!--Rust *does* guarantee that two instances of A have their data laid out in exactly the same way.-->
Rust *は*、Aの2つのインスタンスがまったく同じ方法でデータをレイアウトすることを保証します。
<!--However Rust *does not* currently guarantee that an instance of A has the same field ordering or padding as an instance of B, though in practice there's no reason why they wouldn't.-->
しかし、Rust *は*現在、AのインスタンスがBのインスタンスと同じフィールド順序またはパディングを持つことを保証して*いません*が、実際にはそうでない理由はありません。

<!--With A and B as written, this point would seem to be pedantic, but several other features of Rust make it desirable for the language to play with data layout in complex ways.-->
AとBが書かれているように、この点は賢明ではないように思えますが、Rustの他のいくつかの機能は、言語が複雑な方法でデータレイアウトを演奏することを望ましいものにしています。

<!--For instance, consider this struct:-->
たとえば、この構造体を考えてみましょう：

```rust
struct Foo<T, U> {
    count: u16,
    data1: T,
    data2: U,
}
```

<!--Now consider the monomorphizations of `Foo<u32, u16>` and `Foo<u16, u32>`.-->
ここで、`Foo<u32, u16>`と`Foo<u16, u32>`の単形化を考えてみましょう。
<!--If Rust lays out the fields in the order specified, we expect it to pad the values in the struct to satisfy their alignment requirements.-->
Rustが指定された順序でフィールドをレイアウトする場合、構造体内の値をパディングして、アライメント要件を満たすことが期待されます。
<!--So if Rust didn't reorder fields, we would expect it to produce the following:-->
したがって、Rustがフィールドの順序を変更しなかった場合は、次のものを生成することが期待されます。

```rust,ignore
struct Foo<u16, u32> {
    count: u16,
    data1: u16,
    data2: u32,
}

struct Foo<u32, u16> {
    count: u16,
    _pad1: u16,
    data1: u32,
    data2: u16,
    _pad2: u16,
}
```

<!--The latter case quite simply wastes space.-->
後者の場合は、単にスペースを無駄にするだけです。
<!--An optimal use of space therefore requires different monomorphizations to have *different field orderings*.-->
したがって、空間を最適に使用するには、*異なるフィールド順序*を持つために異なる単形化が必要です。

<!--Enums make this consideration even more complicated.-->
列挙型は、この考慮をさらに複雑にします。
<!--Naively, an enum such as:-->
Naively、enumなど：

```rust
enum Foo {
    A(u32),
    B(u64),
    C(u8),
}
```

<!--would be laid out as:-->
次のように配置されます：

```rust
struct FooRepr {
#//    data: u64, // this is either a u64, u32, or u8 based on `tag`
    data: u64, // これは、`tag`基づくu64、u32、またはu8のいずれかです
#//    tag: u8,   // 0 = A, 1 = B, 2 = C
    tag: u8,   //  0 = A、1 = B、2 = C
}
```

<!--And indeed this is approximately how it would be laid out in general (modulo the size and position of `tag`).-->
実際、これは一般的に（`tag`大きさと位置を`tag`）どのようにレイアウトされるかです。

<!--However there are several cases where such a representation is inefficient.-->
しかしながら、そのような表現が非効率的であるいくつかの場合がある。
<!--The classic case of this is Rust's "null pointer optimization": an enum consisting of a single outer unit variant (eg `None`) and a (potentially nested) non-nullable pointer variant (eg `&T`) makes the tag unnecessary, because a null pointer value can safely be interpreted to mean that the unit variant is chosen instead.-->
古典的なケースは、Rustの "null pointer optimization"です.1つの外部単位バリアント（たとえば`None`）と（nullの可能性のある）ネストされていないポインタ変形（例えば`&T`）からなるenumは、タグを不要にします。値は、単位バリアントが代わりに選択されていることを意味するために安全に解釈できます。
<!--The net result is that, for example, `size_of::<Option<&T>>() == size_of::<&T>()`.-->
正味の結果は、例えば`size_of::<Option<&T>>() == size_of::<&T>()`です。

<!--There are many types in Rust that are, or contain, non-nullable pointers such as `Box<T>`, `Vec<T>`, `String`, `&T`, and `&mut T`.-->
Rustには、`Box<T>`、 `Vec<T>`、 `String`、 `&T`、および`&mut T`などのnullを許可しないポインタが含まれています。
<!--Similarly, one can imagine nested enums pooling their tags into a single discriminant, as they are by definition known to have a limited range of valid values.-->
同様に、定義された有効な値の範囲が限られていることがわかっているので、入れ子になった列挙型がそのタグを単一の判別式にプールすると想像することができます。
<!--In principle enums could use fairly elaborate algorithms to cache bits throughout nested types with special constrained representations.-->
原理的には、列挙型は、厳密な制約付き表現でネストされた型全体に渡ってビットをキャッシュするかなり精巧なアルゴリズムを使用することができます。
<!--As such it is *especially* desirable that we leave enum layout unspecified today.-->
そのため、*特に*今日は不特定のenumレイアウトを残しておくことが望ましいです。

[dst]: exotic-sizes.html#dynamically-sized-types-dsts
