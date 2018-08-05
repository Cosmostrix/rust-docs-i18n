# <!--Associated Items--> 関連商品

<!--*Associated Items* are the items declared in [traits] or defined in [implementations].-->
*関連項目*は、[traits]宣言された項目または[implementations]定義された項目です。
<!--They are called this because they are defined on an associate type &mdash;-->
これらはアソシエートタイプで定義されているため、これは呼び出されます。
<!--the type in the implementation.-->
実装の型
<!--They are a subset of the kinds of items you can declare in a module.-->
それらはモジュールで宣言できる項目のサブセットです。
<!--Specifically, there are [associated functions] (including methods), [associated types], and [associated constants].-->
具体的には、[associated functions]（メソッドを含む）、 [associated types]、および[associated constants]ます。

<!--[associated functions]: #associated-functions-and-methods
 [associated types]: #associated-types
 [associated constants]: #associated-constants
-->
[associated functions]: #associated-functions-and-methods
 [associated types]: #associated-types
 [associated constants]: #associated-constants


<!--Associated items are useful when the associated item logically is related to the associating item.-->
関連項目は、関連項目が論理的に関連項目に関連している場合に便利です。
<!--For example, the `is_some` method on `Option` is intrinsically related to Options, so should be associated.-->
たとえば、`Option`の`is_some`メソッドは、Optionsと本質的に関連しているため、関連付ける必要があります。

<!--Every associated item kind comes in two varieties: definitions that contain the actual implementation and declarations that declare signatures for definitions.-->
関連するすべてのアイテムの種類には、実際の実装を含む定義と、定義のシグネチャを宣言する宣言の2種類があります。

<!--It is the declarations that make up the contract of traits and what it available on generic types.-->
それは、形質の契約を構成する宣言であり、ジェネリック型で利用可能なものです。

## <!--Associated functions and methods--> 関連する関数とメソッド

<!--*Associated functions* are [functions] associated with a type.-->
*関連する関数*は、型に関連付けられた[functions]です。

<!--An *associated function declaration* declares a signature for an associated function definition.-->
*関連する関数宣言*は、関連する関数定義のシグニチャーを*宣言*します。
<!--It is written as a function item, except the function body is replaced with a `;`-->
関数本体がaで置き換えられている点を除き、関数項目として記述されてい`;`
<!--.-->
。

<!--The identifier if the name of the function.-->
関数の名前であれば識別子。
<!--The generics, parameter list, return type, and where clause of the associated function must be the same as the associated function declarations's.-->
関連する関数のジェネリック、パラメータリスト、戻り値の型、およびwhere句は、関連する関数宣言のものと同じでなければなりません。

<!--An *associated function definition* defines a function associated with another type.-->
*関連する関数定義*は、別の型に関連付け*られた関数を定義し*ます。
<!--It is written the same as a [function item].-->
それは[function item]と同じように書かれてい[function item]。

<!--An example of a common associated function is a `new` function that returns a value of the type the associated function is associated with.-->
共通の関連する関数の例は、関連する関数が関連付けられている型の値を返す`new`関数です。

```rust
struct Struct {
    field: i32
}

impl Struct {
    fn new() -> Struct {
        Struct {
            field: 0i32
        }
    }
}

fn main () {
    let _struct = Struct::new();
}
```

<!--When the associated function is declared on a trait, the function can also be called with a [path] that is a path to the trait appended by the name of the trait.-->
関連する関数が特性上に宣言されている場合、その特性は、特性の名前によって追加された特性への[path]である[path]で呼び出すこともできる。
<!--When this happens, it is substituted for `<_ as Trait>::function_name`.-->
これが起こると、`<_ as Trait>::function_name`代わりになり`<_ as Trait>::function_name`。

```rust
trait Num {
    fn from_i32(n: i32) -> Self;
}

impl Num for f64 {
    fn from_i32(n: i32) -> f64 { n as f64 }
}

#// These 4 are all equivalent in this case.
// この場合、これらの4つはすべて同等です。
let _: f64 = Num::from_i32(42);
let _: f64 = <_ as Num>::from_i32(42);
let _: f64 = <f64 as Num>::from_i32(42);
let _: f64 = f64::from_i32(42);
```

### <!--Methods--> メソッド

<!--Associated functions whose first parameter is named `self` are called *methods* and may be invoked using the [method call operator], for example, `x.foo()`, as well as the usual function call notation.-->
最初のパラメータが`self`である関連関数は、*メソッド*と呼ばれ、[method call operator] `x.foo()`など`x.foo()`と通常の関数呼び出し表記を使用して呼び出すことができます。

<!--The `self` parameter must have one of the following types.-->
`self`パラメータは、次のいずれかの型を持つ必要があります。
<!--As a result, the following shorthands may be used to declare `self`:-->
その結果、以下の省略表現を使用して`self`を宣言することができます。

* <!--`self` -> `self: Self`-->
   `self` -`self: Self`
* <!--`&'lifetime self` -> `self: &'lifetime Self`-->
   `&'lifetime self` -> `self: &'lifetime Self`
* <!--`&'lifetime mut self` -> `self: &'lifetime mut Self`-->
   `&'lifetime mut self` -> `self: &'lifetime mut Self`
* <!--`self : Box<Self>` (no shorthand)-->
   `self : Box<Self>`（略語なし）

> <!--Note: Lifetimes can be and usually are elided with this shorthand.-->
> 注：生涯はこの省略形で省略することができ、通常は省略されます。

<!--Consider the following trait:-->
次のような特性を考えてみましょう。

```rust
# type Surface = i32;
# type BoundingBox = i32;
trait Shape {
    fn draw(&self, Surface);
    fn bounding_box(&self) -> BoundingBox;
}
```

<!--This defines a trait with two methods.-->
これは、2つの方法で形質を定義します。
<!--All values that have [implementations] of this trait while the trait is in scope can have their `draw` and `bounding_box` methods called.-->
特性が有効範囲にある間にこの特性の[implementations]を持つすべての値は、その`draw`および`bounding_box`メソッドを呼び出すことができます。

```rust
# type Surface = i32;
# type BoundingBox = i32;
# trait Shape {
#     fn draw(&self, Surface);
#     fn bounding_box(&self) -> BoundingBox;
# }
#
struct Circle {
#    // ...
    // ...
}

impl Shape for Circle {
#    // ...
    // ...
#   fn draw(&self, _: Surface) {}
#   fn bounding_box(&self) -> BoundingBox { 0i32 }
}

# impl Circle {
#     fn new() -> Circle { Circle{} }
# }
#
let circle_shape = Circle::new();
let bounding_box = circle_shape.bounding_box();
```

## <!--Associated Types--> 関連タイプ

<!--*Associated types* are [type aliases] associated with another type.-->
*関連タイプ*は、別のタイプに関連付けられた[type aliases]です。
<!--Associated types cannot be defined in [inherent implementations] nor can they be given a default implementation in traits.-->
関連する型は[inherent implementations]では定義できませんし、特性のデフォルト実装を与えることもできません。

<!--An *associated type declaration* declares a signature for associated type definitions.-->
*関連する型宣言は*、関連する型定義のための署名を*宣言*します。
<!--It is written as `type`, then an [identifier], and finally an optional list of trait bounds.-->
これは`type`として、次に[identifier]に、最後に特性の境界のオプションリストとして記述されます。

<!--The identifier is the name of the declared type alias.-->
識別子は、宣言された型エイリアスの名前です。
<!--The optional trait bounds must be fulfilled by the implementations of the type alias.-->
オプションの特性境界は、型エイリアスの実装によって満たされなければなりません。

<!--An *associated type definition* defines a type alias on another type.-->
*関連する型定義*は、別の型の*型名を定義し*ます。
<!--It is written as `type`, then an [identifier], then an `=`, and finally a [type].-->
これは`type`として記述され、次に[identifier]、次に`=`、そして最後に[type]です。

<!--If a type `Item` has an associated type `Assoc` from a trait `Trait`, then `<Item as Trait>::Assoc` is a type that is an alias of the type specified in the associated type definition.-->
タイプ`Item`が特性`Trait`からの関連タイプ`Assoc`持つ場合、`<Item as Trait>::Assoc`は、関連付けられたタイプ定義で指定されたタイプのエイリアスであるタイプです。
<!--Furthermore, if `Item` is a type parameter, then `Item::Assoc` can be used in type parameters.-->
さらに、`Item`が型パラメータである場合、`Item::Assoc`を型パラメータで使用できます。

```rust
trait AssociatedType {
#    // Associated type declaration
    // 関連型宣言
    type Assoc;
}

struct Struct;

struct OtherStruct;

impl AssociatedType for Struct {
#    // Associated type definition
    // 関連付けられた型定義
    type Assoc = OtherStruct;
}

impl OtherStruct {
    fn new() -> OtherStruct {
        OtherStruct
    }
}

fn main() {
#    // Usage of the associated type to refer to OtherStruct as <Struct as AssociatedType>::Assoc
    //  OtherStructを参照する関連型の使用法::アソーク
    let _other_struct: OtherStruct = <Struct as AssociatedType>::Assoc::new();
}
```

### <!--Associated Types Container Example--> 関連するタイプのコンテナの例

<!--Consider the following example of a `Container` trait.-->
次の`Container`特性の例を考えてみましょう。
<!--Notice that the type is available for use in the method signatures:-->
型シグネチャで使用できることに注意してください。

```rust
trait Container {
    type E;
    fn empty() -> Self;
    fn insert(&mut self, Self::E);
}
```

<!--In order for a type to implement this trait, it must not only provide implementations for every method, but it must specify the type `E`.-->
型がこの特性を実装するためには、すべてのメソッドに対して実装を提供するだけでなく、型`E`指定する必要があります。
<!--Here's an implementation of `Container` for the standard library type `Vec`:-->
標準ライブラリ型`Vec`に対する`Container`実装を以下に示します。

```rust
# trait Container {
#     type E;
#     fn empty() -> Self;
#     fn insert(&mut self, Self::E);
# }
impl<T> Container for Vec<T> {
    type E = T;
    fn empty() -> Vec<T> { Vec::new() }
    fn insert(&mut self, x: T) { self.push(x); }
}
```

## <!--Associated Constants--> 関連する定数

<!--*Associated constants* are [constants] associated with a type.-->
*関連する定数*は、型に関連付けられた[constants]です。

<!--An *associated constant declaration* declares a signature for associated constant definitions.-->
*関連する定数宣言は*、関連する定数定義のシグニチャーを*宣言*します。
<!--It is written as `const`, then an identifier, then `:`, then a type, finished by a `;`-->
これは`const`、次に識別子として書かれ、次に`:`、次に型によって終了され`;`
<!--.-->
。

<!--The identifier is the name of the constant used in the path.-->
識別子は、パスで使用される定数の名前です。
<!--The type is the type that the definition has to implement.-->
型は、定義が実装しなければならない型です。

<!--An *associated constant definition* defines a constant associated with a type.-->
*関連する定数定義*は、型に関連付け*られた定数を定義し*ます。
<!--It is written the same as a [constant item].-->
それは[constant item]と同じように書かれてい[constant item]。

### <!--Associated Constants Examples--> 関連する定数の例

<!--A basic example:-->
基本的な例：

```rust
trait ConstantId {
    const ID: i32;
}

struct Struct;

impl ConstantId for Struct {
    const ID: i32 = 1;
}

fn main() {
    assert_eq!(1, Struct::ID);
}
```

<!--Using default values:-->
デフォルト値を使う：

```rust
trait ConstantIdDefault {
    const ID: i32 = 1;
}

struct Struct;
struct OtherStruct;

impl ConstantIdDefault for Struct {}

impl ConstantIdDefault for OtherStruct {
    const ID: i32 = 5;
}

fn main() {
    assert_eq!(1, Struct::ID);
    assert_eq!(5, OtherStruct::ID);
}
```

<!--[trait]: items/traits.html
 [traits]: items/traits.html
 [type aliases]: items/type-aliases.html
 [inherent implementations]: items/implementations.html#inherent-implementations
 [identifier]: identifiers.html
 [trait object]: types.html#trait-objects
 [implementations]: items/implementations.html
 [type]: types.html
 [constants]: items/constant-items.html
 [constant item]: items/constant-items.html
 [functions]: items/functions.html
 [method call operator]: expressions/method-call-expr.html
 [block]: expressions/block-expr.html
 [path]: paths.html
-->
[trait]: items/traits.html
 [traits]: items/traits.html
 [type aliases]: items/type-aliases.html
 [inherent implementations]: items/implementations.html#inherent-implementations
 [identifier]: identifiers.html
 [trait object]: types.html#trait-objects
 [implementations]: items/implementations.html
 [type]: types.html
 [constants]: items/constant-items.html
 [constant item]: items/constant-items.html
 [functions]: items/functions.html
 [method call operator]: expressions/method-call-expr.html
 [block]: expressions/block-expr.html
 [path]: paths.html

