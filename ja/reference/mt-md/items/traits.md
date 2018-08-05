# <!--Traits--> 形質

<!--A  _trait_  describes an abstract interface that types can implement.-->
 _特性_ は、型が実装できる抽象的なインタフェースを記述します。
<!--This interface consists of [associated items], which come in three varieties:-->
このインタフェースは、[associated items]で構成され、3つの種類があります。

- [functions](items/associated-items.html#associated-functions-and-methods)
- [types](items/associated-items.html#associated-types)
- [constants](items/associated-items.html#associated-constants)

<!--All traits define an implicit type parameter `Self` that refers to "the type that is implementing this interface".-->
すべての特性は、「このインタフェースを実装している型」を参照する暗黙の型パラメータ`Self`を定義します。
<!--Traits may also contain additional type parameters.-->
形質には、追加の型パラメーターも含まれます。
<!--These type parameters, including `Self`, may be constrained by other traits and so forth [as usual][generics].-->
`Self`を含むこれらのタイプパラメータは、他の特性などによって[通常どおりに][generics]制限されることがあります。

<!--Traits are implemented for specific types through separate [implementations].-->
形質は、別々の[implementations]を通じて特定のタイプに対して[implementations]ます。

<!--Items associated with a trait do not need to be defined in the trait, but they may be.-->
形質に関連するアイテムは、その形質に定義する必要はありませんが、そうであるかもしれません。
<!--If the trait provides a definition, then this definition acts as a default for any implementation which does not override it.-->
特性が定義を提供する場合、この定義は、それを上書きしない実装のデフォルトとして機能します。
<!--If it does not, then any implementation must provide a definition.-->
そうでなければ、どの実装でも定義を提供する必要があります。

## <!--Trait bounds--> 特性限界

<!--Generic items may use traits as [bounds] on their type parameters.-->
一般的な項目は、型パラメータの[bounds]としての特性を使用することがあります。

## <!--Generic Traits--> 一般的な特性

<!--Type parameters can be specified for a trait to make it generic.-->
型パラメータは、特性を汎用にするために指定できます。
<!--These appear after the trait name, using the same syntax used in [generic functions].-->
これらは、[generic functions]使用されているのと同じ構文を使用して、特性名の後に表示され[generic functions]。

```rust
trait Seq<T> {
    fn len(&self) -> u32;
    fn elt_at(&self, n: u32) -> T;
    fn iter<F>(&self, F) where F: Fn(T);
}
```

## <!--Object Safety--> オブジェクトの安全

<!--Object safe traits can be the base trait of a [trait object].-->
オブジェクトセーフな形質は、[trait object]基本形質であり得る。
<!--A trait is *object safe* if it has the following qualities (defined in [RFC 255]):-->
特性は、以下の性質（[RFC 255]定義され[RFC 255]）を有する場合、 *オブジェクトセーフである*。

* <!--It must not require `Self: Sized`-->
   `Self: Sized`必要としてはいけません`Self: Sized`
* <!--All associated functions must either have a `where Self: Sized` bound, or-->
   関連するすべての関数は`where Self: Sized`境界の`where Self: Sized`かにあるか、または
    * <!--Not have any type parameters (although lifetime parameters are allowed), and-->
       タイプパラメータはありません（ライフタイムパラメータは使用できます）。
    * <!--Be a [method] that does not use `Self` except in the type of the receiver.-->
       受信者の種類を除いて、`Self`を使用しない[method]です。
* <!--It must not have any associated constants.-->
   関連する定数は存在してはいけません。
* <!--All supertraits must also be object safe.-->
   すべてのスーパートレートは、オブジェクトセーフでなければなりません。

## <!--Supertraits--> 大怪獣

<!--**Supertraits** are traits that are required to be implemented for a type to implement a specific trait.-->
**尺度**は、特定の形質を実装するために型に実装する必要がある形質です。
<!--Furthermore, anywhere a [generic] or [trait object] is bounded by a trait, it has access to the associated items of its supertraits.-->
さらに、[generic]または[trait object]が[trait object]によって束縛されるところでは、それはそのスーパートレートの関連項目にアクセスすることができます。

<!--Supertraits are declared by trait bounds on the `Self` type of a trait and transitively the supertraits of the traits declared in those trait bounds.-->
尺度は、形質の`Self`型の形質境界と、それらの形質境界内で宣言された形質の超過尺度によって宣言される。
<!--It is an error for a trait to be its own supertrait.-->
特色がそれ自身のスーパートゥートレイトであることは誤りである。

<!--The trait with a supertrait is called a **subtrait** of its supertrait.-->
supertraitを持つ特性はsupertraitの**subtrait**と呼ばれます。

<!--The following is an example of declaring `Shape` to be a supertrait of `Circle`.-->
以下は、`Shape`を`Circle` supertraitと宣言した例です。

```rust
trait Shape { fn area(&self) -> f64; }
trait Circle : Shape { fn radius(&self) -> f64; }
```

<!--And the following is the same example, except using [where clauses].-->
以下は[where clauses]を使用した[where clauses]を除いて同じ例です。

```rust
trait Shape { fn area(&self) -> f64; }
trait Circle where Self: Shape { fn radius(&self) -> f64; }
```

<!--This next example gives `radius` a default implementation using the `area` function from `Shape`.-->
この次の例は、`Shape` `area`関数を使用した`radius`のデフォルトの実装です。

```rust
# trait Shape { fn area(&self) -> f64; }
trait Circle where Self: Shape {
    fn radius(&self) -> f64 {
#        // A = pi * r^2
#        // so algebraically,
#        // r = sqrt(A / pi)
        //  A = pi * r ^ 2したがって代数的には、r = sqrt（A / pi）
        (self.area() /std::f64::consts::PI).sqrt()
    }
}
```

<!--This next example calls a supertrait method on a generic parameter.-->
次の例では、汎用パラメータに対してsupertraitメソッドを呼び出します。

```rust
# trait Shape { fn area(&self) -> f64; }
# trait Circle : Shape { fn radius(&self) -> f64; }
fn print_area_and_radius<C: Circle>(c: C) {
#    // Here we call the area method from the supertrait `Shape` of `Circle`.
    // ここでは、supertraitから地域のメソッドを呼び出す`Shape`の`Circle`。
    println!("Area: {}", c.area());
    println!("Radius: {}", c.radius());
}
```

<!--Similarly, here is an example of calling supertrait methods on trait objects.-->
同様に、traitオブジェクトに対するsupertraitメソッドの呼び出しの例を次に示します。

```rust
# trait Shape { fn area(&self) -> f64; }
# trait Circle : Shape { fn radius(&self) -> f64; }
# struct UnitCircle;
# impl Shape for UnitCircle { fn area(&self) -> f64 { std::f64::consts::PI } }
# impl Circle for UnitCircle { fn radius(&self) -> f64 { 1.0 } }
# let circle = UnitCircle;
let circle = Box::new(circle) as Box<dyn Circle>;
let nonsense = circle.radius() * circle.area();
```

<!--[bounds]: trait-bounds.html
 [trait object]: types.html#trait-objects
 [explicit]: expressions/operator-expr.html#type-cast-expressions
 [RFC 255]: https://github.com/rust-lang/rfcs/blob/master/text/0255-object-safety.md
 [associated items]: items/associated-items.html
 [method]: items/associated-items.html#methods
 [implementations]: items/implementations.html
 [generics]: items/generics.html
 [where clauses]: items/generics.html#where-clauses
 [generic functions]: items/functions.html#generic-functions
-->
[bounds]: trait-bounds.html
 [trait object]: types.html#trait-objects
 [explicit]: expressions/operator-expr.html#type-cast-expressions
 [RFC 255]: https://github.com/rust-lang/rfcs/blob/master/text/0255-object-safety.md
 [associated items]: items/associated-items.html
 [method]: items/associated-items.html#methods
 [implementations]: items/implementations.html
 [generics]: items/generics.html
 [where clauses]: items/generics.html#where-clauses
 [generic functions]: items/functions.html#generic-functions

