# <!--Implementations--> 実装

<!--An  _implementation_  is an item that associates items with an *implementing type*.-->
 _実装_ は、項目を*実装タイプに*関連付ける項目です。

<!--There are two types of implementations: inherent implementations and [trait] implementations.-->
インプリメンテーションには固有のインプリメンテーションと[trait]インプリメンテーションの2種類があります。

<!--Implementations are defined with the keyword `impl`.-->
実装はキーワード`impl`定義されます。

## <!--Inherent Implementations--> 固有の実装

<!--An inherent implementation is defined as the sequence of the `impl` keyword, generic type declarations, a path to a nominal type, a where clause, and a bracketed set of associable items.-->
固有の実装は、`impl`キーワードのシーケンス、ジェネリック型宣言、公称型へのパス、where句、および関連項目の括弧で囲まれたセットとして定義されています。

<!--The nominal type is called the *implementing type* and the associable items are the *associated items* to the implementing type.-->
公称タイプは*実装タイプ*と呼ばれ、*関連可能アイテム*は実装タイプへの*関連アイテム*です。

<!--Inherent implementations associate the associated items to the implementing type.-->
固有の実装は、関連する項目を実装タイプに関連付けます。

<!--The associated item has a path of a path to the implementing type followed by the associate item's path component.-->
関連する項目には、実装タイプへのパスのパスがあり、その後に関連項目のパスコンポーネントが続きます。

<!--Inherent implementations cannot contain associated type aliases.-->
固有の実装には、関連付けられた型のエイリアスを含めることはできません。

<!--A type can have multiple inherent implementations.-->
型は複数の固有の実装を持つことができます。

<!--The implementing type must be defined within the same crate.-->
実装タイプは同じクレート内で定義する必要があります。

```rust
struct Point {x: i32, y: i32}

impl Point {
    fn log(&self) {
        println!("Point is at ({}, {})", self.x, self.y);
    }
}

let my_point = Point {x: 10, y:11};
my_point.log();
```

## <!--Trait Implementations--> 特性の実装

<!--A *trait implementation* is defined like an inherent implementation except that the optional generic type declarations is followed by a [trait] followed by the keyword `for`.-->
*特性実装*は、オプションのジェネリック型宣言の後に[trait]後にキーワード`for`が続くという点を除いて、固有の実装のように定義さ`for`ます。
<!-- To understand this, you have to back-reference to
the previous section. :( -->

<!--The trait is known as the *implemented trait*.-->
この形質は、*実施された形質*として知られて*いる*。

<!--The implementing type implements the implemented trait.-->
実装タイプは、実装された特性を実装します。

<!--A trait implementation must define all non-default associated items declared by the implemented trait, may redefine default associated items defined by the implemented trait, and cannot define any other items.-->
特性実装は、実装された特性によって宣言されたデフォルト以外の関連項目をすべて定義しなければならず、実装された特性によって定義されたデフォルトの関連項目を再定義し、他の項目を定義することはできません。

<!--The path to the associated items is `<` followed by a path to the implementing type followed by `as` followed by a path to the trait followed by `>` as a path component followed by the associated item's path component.-->
関連項目へのパスをさ`<`続い実装タイプのパスが続く`as`、続いて形質へのパスが続く`>`関連アイテムのパスコンポーネントが続くパスコンポーネントとして。

```rust
# #[derive(Copy, Clone)]
# struct Point {x: f64, y: f64};
# type Surface = i32;
# struct BoundingBox {x: f64, y: f64, width: f64, height: f64};
# trait Shape { fn draw(&self, Surface); fn bounding_box(&self) -> BoundingBox; }
# fn do_draw_circle(s: Surface, c: Circle) { }
struct Circle {
    radius: f64,
    center: Point,
}

impl Copy for Circle {}

impl Clone for Circle {
    fn clone(&self) -> Circle { *self }
}

impl Shape for Circle {
    fn draw(&self, s: Surface) { do_draw_circle(s, *self); }
    fn bounding_box(&self) -> BoundingBox {
        let r = self.radius;
        BoundingBox {
            x: self.center.x - r,
            y: self.center.y - r,
            width: 2.0 * r,
            height: 2.0 * r,
        }
    }
}
```

### <!--Trait Implementation Coherence--> 特性実現の一貫性

<!--A trait implementation is considered incoherent if either the orphan check fails or there are overlapping implementation instances.-->
孤児チェックが失敗するか、重複している実装インスタンスがある場合、特性実装はインコヒーレントであるとみなされます。

<!--Two trait implementations overlap when there is a non-empty intersection of the traits the implementation is for, the implementations can be instantiated with the same type.-->
2つの特性の実装は、実装がある特性の空でない共通部分がある場合に重複し、実装は同じタイプでインスタンス化できます。
<!-- This is probably wrong? Source: No two implementations can
be instantiable with the same set of types for the input type parameters. -->

<!--The `Orphan Check` states that every trait implementation must meet either of the following conditions:-->
`Orphan Check`は、すべての特性実装が次のいずれかの条件を満たす必要があることを示しています。

1. <!--The trait being implemented is defined in the same crate.-->
    実装されている特性は同じクレートで定義されています。

2. <!--At least one of either `Self` or a generic type parameter of the trait must meet the following grammar, where `C` is a nominal type defined within the containing crate:-->
    `Self`または特性のジェネリック型パラメータの少なくとも1つは、以下の文法を満たさなければなりません。ここで、`C`は、含まれているクレート内で定義された名目型です。

<!--` ``ignore T = C | &C | &mut C | Box<C>``-->
` ``ignore T = C | &C | &mut C | Box<C>``
``ignore T = C | &C | &mut C | Box<C>`` <!--``ignore T = C | &C | &mut C | Box<C>`` `-->
``ignore T = C | &C | &mut C | Box<C>`` `

## <!--Generic Implementations--> 一般的な実装

<!--An implementation can take type and lifetime parameters, which can be used in the rest of the implementation.-->
インプリメンテーションでは、タイプとライフタイムのパラメータを取ることができ、残りの実装で使用できます。
<!--Type parameters declared for an implementation must be used at least once in either the trait or the implementing type of an implementation.-->
インプリメンテーションに対して宣言された型パラメータは、インプリメンテーションの特性またはインプリメンテーション型のいずれかで最低1回使用する必要があります。
<!--Implementation parameters are written directly after the `impl` keyword.-->
実装パラメータは、`impl`キーワードの直後に記述されます。

```rust
# trait Seq<T> { fn dummy(&self, _: T) { } }
impl<T> Seq<T> for Vec<T> {
    /* ... */
}
impl Seq<bool> for u32 {
    /* Treat the integer as a sequence of bits */
}
```

## <!--Attributes on Implementations--> 実装に関する属性

<!--Implementations may contain outer [attributes] before the `impl` keyword and inner [attributes] inside the brackets that contain the associated items.-->
インプリメンテーションは、`impl`キーワードの前に外部[attributes]、関連する項目を含む括弧内に内部[attributes]を含むことができます。
<!--Inner attributes must come before any associated items.-->
内部属性は関連する項目の前に来なければなりません。
<!--That attributes that have meaning here are [`cfg`], [`deprecated`], [`doc`], and [the lint check attributes].-->
ここで意味を持つ属性は、[`cfg`]、 [`deprecated`]、 [`doc`]、および[the lint check attributes]。

<!--[trait]: items/traits.html
 [attributes]: attributes.html
 [`cfg`]: attributes.html#conditional-compilation
 [`deprecated`]: attributes.html#deprecation
 [`doc`]: attributes.html#documentation
 [the lint check attributes]: attributes.html#lint-check-attributes
-->
[trait]: items/traits.html
 [attributes]: attributes.html
 [`cfg`]: attributes.html#conditional-compilation
 [`deprecated`]: attributes.html#deprecation
 [`doc`]: attributes.html#documentation
 [the lint check attributes]: attributes.html#lint-check-attributes

