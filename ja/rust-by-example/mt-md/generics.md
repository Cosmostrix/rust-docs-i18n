# <!--Generics--> ジェネリックス

<!--*Generics* is the topic of generalizing types and functionalities to broader cases.-->
*ジェネリックス*は、より広範なケースに対してタイプと機能を一般化するトピックです。
<!--This is extremely useful for reducing code duplication in many ways, but can call for rather involving syntax.-->
これは、さまざまな方法でコードの重複を減らすのに非常に便利ですが、構文を必要とすることもあります。
<!--Namely, being generic requires taking great care to specify over which types a generic type is actually considered valid.-->
すなわち、ジェネリックであることは、ジェネリックタイプが実際に有効と考えられるタイプを特定するために細心の注意を払うことを必要とする。
<!--The simplest and most common use of generics is for type parameters.-->
ジェネリックの最も簡単で一般的な使い方は型パラメータです。

<!--A type parameter is specified as generic by the use of angle brackets and upper [camel case][camelcase]: `<Aaa, Bbb, ...>`.-->
タイプパラメタは、山カッコとアッパー`<Aaa, Bbb, ...>` [場合は][camelcase] `<Aaa, Bbb, ...>`使用してジェネリックとして指定します。
<!--"Generic type parameters"are typically represented as `<T>`.-->
「汎用型パラメータ」は、通常、`<T>`表されます。
<!--In Rust, "generic"also describes anything that accepts one or more generic type parameters `<T>`.-->
Rustでは、"generic"は、1つ以上のジェネリック型パラメータ`<T>`を受け入れるものも記述します。
<!--Any type specified as a generic type parameter is generic, and everything else is concrete (non-generic).-->
ジェネリック型パラメータとして指定された型はジェネリックで、その他はすべて具体的（非ジェネリック型）です。

<!--For example, defining a *generic function* named `foo` that takes an argument `T` of any type:-->
たとえば、任意の型の引数`T`をとる`foo`という*汎用関数を*定義します。

```rust,ignore
fn foo<T>(arg: T) { ... }
```

<!--Because `T` has been specified as a generic type parameter using `<T>`, it is considered generic when used here as `(arg: T)`.-->
`T`は、`<T>`を使用してジェネリック型パラメータとして指定されているため、ここで`(arg: T)`として使用すると汎用型と見なされます。
<!--This is the case even if `T` has previously been defined as a `struct`.-->
これは、`T`が以前に`struct`として定義されていたとしても`struct`ます。

<!--This example shows some of the syntax in action:-->
この例では、動作中の構文の一部を示します。

```rust,editable
#// A concrete type `A`.
// 具体的なタイプ`A`
struct A;

#// In defining the type `Single`, the first use of `A` is not preceded by `<A>`.
#// Therefore, `Single` is a concrete type, and `A` is defined as above.
//  `Single`型の定義では、`A`の最初の使用の前に`<A>`はありません。したがって、`Single`は具体的な型であり、`A`は上記のように定義されます。
struct Single(A);
#//            ^ Here is `Single`s first use of the type `A`.
//  ^ここでは`Single`の最初のタイプ`A`使用があります。

#// Here, `<T>` precedes the first use of `T`, so `SingleGen` is a generic type.
#// Because the type parameter `T` is generic, it could be anything, including
#// the concrete type `A` defined at the top.
// ここで、`<T>`最初の使用の前に`T`ので、`SingleGen`ジェネリック型です。型パラメータ`T`は汎用型なので、上部に定義された具象型`A`を含む何でも構いません。
struct SingleGen<T>(T);

fn main() {
#    // `Single` is concrete and explicitly takes `A`.
    //  `Single`は具体的で明示的に`A`とる。
    let _s = Single(A);
    
#    // Create a variable `_char` of type `SingleGen<char>`
#    // and give it the value `SingleGen('a')`.
#    // Here, `SingleGen` has a type parameter explicitly specified.
    //  `SingleGen<char>`型の変数`_char`を作成し、`SingleGen('a')`という値を与えます。ここでは、`SingleGen`には型パラメータが明示的に指定されています。
    let _char: SingleGen<char> = SingleGen('a');

#    // `SingleGen` can also have a type parameter implicitly specified:
    //  `SingleGen`は、暗黙的に指定された型パラメータを持つこともできます：
#//    let _t    = SingleGen(A); // Uses `A` defined at the top.
    let _t    = SingleGen(A); // 一番上に定義された`A`使用します。
#//    let _i32  = SingleGen(6); // Uses `i32`.
    let _i32  = SingleGen(6); //  `i32`使用します。
#//    let _char = SingleGen('a'); // Uses `char`.
    let _char = SingleGen('a'); //  `char`使用します。
}
```

### <!--See also:--> 参照：

[`struct` s][structs]
<!--[structs]: custom_types/structs.html
 [camelcase]: https://en.wikipedia.org/wiki/CamelCase
-->
[structs]: custom_types/structs.html
 [camelcase]: https://en.wikipedia.org/wiki/CamelCase

