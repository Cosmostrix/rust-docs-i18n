# <!--Enumerations--> 列挙型

> <!--**<sup>Syntax</sup>** \  _Enumeration_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _Enumeration_ ：\＆nbsp;＆nbsp;
> <!--`enum` [IDENTIFIER] &nbsp;-->
> `enum` [IDENTIFIER] ＆amp; nbsp;
> <!--[_Generics_]  __?__ -->
> [_Generics_]  __？__ 
> <!--[_WhereClause_]  __?__ -->
> [_WhereClause_]  __？__ 
> <!--`{`  _EnumItems_   __?__ -->
> `{`  _EnumItems_   __？__ 
> `}`
> <!-- _EnumItems_ :\ &nbsp;&nbsp;-->
>  _EnumItems_ ：\＆nbsp;＆nbsp;
> <!-- _EnumItem_  (`,`  _EnumItem_ )  __\ *</sup> `,`<sup>?</sup> _EnumItem_:\ &nbsp;&nbsp;*__ -->
>  _EnumItem_ （ `,`  _EnumItem_ ）  __\ *</ sup> `、` <sup>？</ sup> _EnumItem_：\＆nbsp;＆nbsp;*__ 
> <!-- __*_OuterAttribute_<sup>\*__  \ &nbsp;&nbsp;-->
>  __*_OuterAttribute_ <sup> \*__  \＆nbsp;＆nbsp;
> <!--[IDENTIFIER] &nbsp;( _EnumItemTuple_  |  _EnumItemStruct_  |  _EnumItemDiscriminant_ )  __?__ -->
> [IDENTIFIER] ＆nbsp;（ _EnumItemTuple_  |  _EnumItemStruct_  |  _EnumItemDiscriminant_ ）  __？__ 
> 
> <!-- _EnumItemTuple_ :\ &nbsp;&nbsp;-->
>  _EnumItemTuple_ ：\＆nbsp;＆nbsp;
> <!--`(` [_TupleFields_]  __?__  `)`-->
> `(` [_TupleFields_]  __？__  `)`
> 
> <!-- _EnumItemStruct_ :\ &nbsp;&nbsp;-->
>  _EnumItemStruct_ ：\＆nbsp;＆nbsp;
> <!--`{` [_StructFields_]  __?__ -->
> `{` [_StructFields_]  __？__ 
> `}`
> <!-- _EnumItemDiscriminant_ :\ &nbsp;&nbsp;-->
>  _EnumItemDiscriminant_ ：\＆nbsp;＆nbsp;
> <!--`=` [_Expression_]-->
> `=` [_Expression_]

<!--An *enumeration*, also referred to as *enum* is a simultaneous definition of a nominal [enumerated type] as well as a set of *constructors*, that can be used to create or pattern-match values of the corresponding enumerated type.-->
また、*列挙型*と呼ばれる*列挙は*、公称の同時定義で[enumerated type]ならびに*コンストラクタ*のセットを作成するために使用することができ、または、対応する列挙型のパターンマッチの値。

<!--Enumerations are declared with the keyword `enum`.-->
列挙はキーワード`enum`宣言されます。

<!--An example of an `enum` item and its use:-->
`enum`アイテムとその使用例：

```rust
enum Animal {
    Dog,
    Cat,
}

let mut a: Animal = Animal::Dog;
a = Animal::Cat;
```

<!--Enum constructors can have either named or unnamed fields:-->
Enumコンストラクタは、名前付きフィールドまたは名前のないフィールドのいずれかを持つことができます。

```rust
enum Animal {
    Dog(String, f64),
    Cat { name: String, weight: f64 },
}

let mut a: Animal = Animal::Dog("Cocoa".to_string(), 37.2);
a = Animal::Cat { name: "Spotty".to_string(), weight: 2.7 };
```

<!--In this example, `Cat` is a  _struct-like enum variant_ , whereas `Dog` is simply called an enum variant.-->
この例では、`Cat`は _構造体のような列挙型です_ が、`Dog`は単に列挙型と呼ばれます。
<!--Each enum instance has a  _discriminant_  which is an integer associated to it that is used to determine which variant it holds.-->
各enumインスタンスには、どのバリアントが保持されているかを判断するために使用される、関連する整数である _判別式が_ あります。
<!--An opaque reference to this discriminant can be obtained with the [`mem::discriminant`] function.-->
この判別式への不透明な参照は[`mem::discriminant`]関数で得ることができます。

## <!--Custom Discriminant Values for Field-Less Enumerations--> フィールドレス列挙型のカスタム識別値

<!--If there is no data attached to *any* of the variants of an enumeration, then the discriminant can be directly chosen and accessed.-->
列挙の変種の*いずれか*にデータが添付されていない場合、判別式を直接選択してアクセスすることができます。

<!--These enumerations can be cast to integer types with the `as` operator by a [numeric cast].-->
これらの列挙型は、[numeric cast] `as`演算子を使用して整数型にキャストできます。
<!--The enumeration can optionally specify which integer each discriminant gets by following the variant name with `=` and then an integer literal.-->
列挙では、任意の整数を指定することができます。各整数は、`=`と整数リテラルのあいだのバリアント名の後に置かれます。
<!--If the first variant in the declaration is unspecified, then it is set to zero.-->
宣言の最初の変種が指定されていない場合は、ゼロに設定されます。
<!--For every unspecified discriminant, it is set to one higher than the previous variant in the declaration.-->
指定されていない判別子ごとに、宣言の前の変種よりも1つ高い値に設定されます。

```rust
enum Foo {
#//    Bar,            // 0
    Bar,            //  0
#//    Baz = 123,      // 123
    Baz = 123,      //  123
#//    Quux,           // 124
    Quux,           //  124
}

let baz_discriminant = Foo::Baz as u32;
assert_eq!(baz_discriminant, 123);
```

<!--Under the [default representation], the specified discriminant is interpreted as an `isize` value although the compiler is allowed to use a smaller type in the actual memory layout.-->
[default representation]では、コンパイラは実際のメモリレイアウトでより小さな型を使用することができますが、指定された判別式は`isize`値として解釈されます。
<!--The size and thus acceptable values can be changed by using a [primitive representation] or the [`C` representation].-->
サイズおよび許容可能な値は、[primitive representation]または[`C` representation]を使用することによって変更することができる。

<!--It is an error when two variants share the same discriminant.-->
2つの変種が同じ判別式を共有するのは誤りです。

```rust,ignore
enum SharedDiscriminantError {
    SharedA = 1,
    SharedB = 1
}

enum SharedDiscriminantError2 {
#//    Zero,       // 0
    Zero,       //  0
#//    One,        // 1
    One,        //  1
#//    OneToo = 1  // 1 (collision with previous!)
    OneToo = 1  //  1（前との衝突！）
}
```

<!--It is also an error to have an unspecified discriminant where the previous discriminant is the maximum value for the size of the discriminant.-->
また、前の判別式が判別式の大きさの最大値である判別できない判別式を持つことも誤りである。

```rust,ignore
#[repr(u8)]
enum OverflowingDiscriminantError {
    Max = 255,
#//    MaxPlusOne // Would be 256, but that overflows the enum.
    MaxPlusOne //  256になりますが、それはenumをオーバーフローさせます。
}

#[repr(u8)]
enum OverflowingDiscriminantError2 {
#//    MaxMinusOne = 254, // 254
    MaxMinusOne = 254, //  254
#//    Max,               // 255
    Max,               //  255
#//    MaxPlusOne         // Would be 256, but that overflows the enum.
    MaxPlusOne         //  256になりますが、それはenumをオーバーフローさせます。
}
```

## <!--Zero-variant Enums--> ゼロ改変列挙型

<!--Enums with zero variants are known as *zero-variant enums*.-->
*ゼロの変種を持つ列挙型は*、 *ゼロ変形列挙型*として知られてい*ます*。
<!--As they have no valid values, they cannot be instantiated.-->
有効な値がないため、インスタンス化することはできません。

```rust
enum ZeroVariants {}
```

<!--[IDENTIFIER]: identifiers.html
 [_Generics_]: items/generics.html
 [_WhereClause_]: items/generics.html#where-clauses
 [_Expression_]: expressions.html
 [_TupleFields_]: items/structs.html
 [_StructFields_]: items/structs.html
 [enumerated type]: types.html#enumerated-types
 [`mem::discriminant`]: ../std/mem/fn.discriminant.html
 [numeric cast]: expressions/operator-expr.html#semantics
 [`repr` attribute]: attributes.html#ffi-attributes
-->
[IDENTIFIER]: identifiers.html
 [_Generics_]: items/generics.html
 [_WhereClause_]: items/generics.html#where-clauses
 [_Expression_]: expressions.html
 [_TupleFields_]: items/structs.html
 [_StructFields_]: items/structs.html
 [enumerated type]: types.html#enumerated-types
 [`mem::discriminant`]: ../std/mem/fn.discriminant.html
 [numeric cast]: expressions/operator-expr.html#semantics
 [`repr` attribute]: attributes.html#ffi-attributes

