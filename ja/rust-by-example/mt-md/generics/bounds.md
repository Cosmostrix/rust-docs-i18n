# <!--Bounds--> 境界

<!--When working with generics, the type parameters often must use traits as *bounds* to stipulate what functionality a type implements.-->
ジェネリックで作業する場合、タイプパラメータは、型が実装する機能を規定するために、しばしば特性を*境界*として使用する必要があります。
<!--For example, the following example uses the trait `Display` to print and so it requires `T` to be bound by `Display`;-->
たとえば、次の例では、Trait `Display`を使用して印刷するため、`T`が`Display`にバインドされている必要があります。
<!--that is, `T` *must* implement `Display`.-->
つまり、`T` *は* `Display`実装する*必要があり*ます。

```rust,ignore
#// Define a function `printer` that takes a generic type `T` which
#// must implement trait `Display`.
// 特性`Display`実装する必要がある汎用タイプ`T`をとる関数`printer`を定義します。
fn printer<T: Display>(t: T) {
    println!("{}", t);
}
```

<!--Bounding restricts the generic to types that conform to the bounds.-->
Boundingは、汎用をその境界に適合するタイプに制限します。
<!--That is:-->
あれは：

```rust,ignore
struct S<T: Display>(T);

#// Error! `Vec<T>` does not implement `Display`. This
#// specialization will fail.
// エラー！ `Vec<T>`は`Display`実装していません。この専門化は失敗します。
let s = S(vec![1]);
```

<!--Another effect of bounding is that generic instances are allowed to access the [methods] of traits specified in the bounds.-->
境界の別の効果は、汎用インスタンスが境界で指定された形質の[methods]にアクセスできることです。
<!--For example:-->
例えば：

```rust,editable
#// A trait which implements the print marker: `{:?}`.
// 印刷マーカーを実装する特性： `{:?}`：？ `{:?}`。
use std::fmt::Debug;

trait HasArea {
    fn area(&self) -> f64;
}

impl HasArea for Rectangle {
    fn area(&self) -> f64 { self.length * self.height }
}

#[derive(Debug)]
struct Rectangle { length: f64, height: f64 }
#[allow(dead_code)]
struct Triangle  { length: f64, height: f64 }

#// The generic `T` must implement `Debug`. Regardless
#// of the type, this will work properly.
// ジェネリック`T`は`Debug`実装する必要があります。タイプにかかわらず、これは適切に動作します。
fn print_debug<T: Debug>(t: &T) {
    println!("{:?}", t);
}

#// `T` must implement `HasArea`. Any function which meets
#// the bound can access `HasArea`'s function `area`.
//  `T`は`HasArea`実装する必要があります。バインディングを満たす関数は、`HasArea`の関数`area`アクセスできます。
fn area<T: HasArea>(t: &T) -> f64 { t.area() }

fn main() {
    let rectangle = Rectangle { length: 3.0, height: 4.0 };
    let _triangle = Triangle  { length: 3.0, height: 4.0 };

    print_debug(&rectangle);
    println!("Area: {}", area(&rectangle));

    //print_debug(&_triangle);
    //println!("Area: {}", area(&_triangle));
#    // ^ TODO: Try uncommenting these.
#    // | Error: Does not implement either `Debug` or `HasArea`. 
    //  ^ TODO：これらのコメントを外してみてください。|エラー： `Debug`または`HasArea`いずれも実装しません。
}
```

<!--As an additional note, [`where`][where] clauses can also be used to apply bounds in some cases to be more expressive.-->
さらに注意すべき点として、[`where`][where]句を使用して境界を適用して、より表現力豊かな場合があります。

### <!--See also:--> 参照：

<!--[`std::fmt`][fmt], [`struct` s][structs], and [`trait` s][traits]-->
[`std::fmt`][fmt]、 [`struct` s][structs]、および[`trait` s][traits]

<!--[fmt]: hello/print.html
 [methods]: fn/methods.html
 [structs]: custom_types/structs.html
 [traits]: trait.html
 [where]: generics/where.html
-->
[fmt]: hello/print.html
 [methods]: fn/methods.html
 [structs]: custom_types/structs.html
 [traits]: trait.html
 [where]: generics/where.html

