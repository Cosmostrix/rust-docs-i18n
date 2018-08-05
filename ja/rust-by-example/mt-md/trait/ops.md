# <!--Operator Overloading--> 演算子のオーバーロード

<!--In Rust, many of the operators can be overloaded via traits.-->
Rustでは、多くの演算子が特性を使ってオーバーロードされる可能性があります。
<!--That is, some operators can be used to accomplish different tasks based on their input arguments.-->
つまり、入力引数に基づいて異なるタスクを実行する演算子もあります。
<!--This is possible because operators are syntactic sugar for method calls.-->
演算子はメソッド呼び出しの構文的な砂糖なので、これは可能です。
<!--For example, the `+` operator in `a + b` calls the `add` method (as in `a.add(b)`).-->
たとえば、`a + b` `+`演算子は`a.add(b)`ように`add`メソッドを呼び出します。
<!--This `add` method is part of the `Add` trait.-->
この`add`メソッドは`Add`特性の一部です。
<!--Hence, the `+` operator can be used by any implementor of the `Add` trait.-->
したがって、`+`演算子は、`Add`特性の任意の実装者によって使用されることができる。

<!--A list of the traits, such as `Add`, that overload operators can be found in [`core::ops`][ops].-->
`Add`などの特性のリストは、overload演算子が[`core::ops`][ops]ます。

```rust,editable
use std::ops;

struct Foo;
struct Bar;

#[derive(Debug)]
struct FooBar;

#[derive(Debug)]
struct BarFoo;

#// The `std::ops::Add` trait is used to specify the functionality of `+`.
#// Here, we make `Add<Bar>` - the trait for addition with a RHS of type `Bar`.
#// The following block implements the operation: Foo + Bar = FooBar
//  `std::ops::Add`特性は、`+`の機能を指定するために使用されます。ここでは、`Add<Bar>`を追加します。これは、`Bar`型のRHSを持つ追加用の特性です。次のブロックは演算を実装します：Foo + Bar = FooBar
impl ops::Add<Bar> for Foo {
    type Output = FooBar;

    fn add(self, _rhs: Bar) -> FooBar {
        println!("> Foo.add(Bar) was called");

        FooBar
    }
}

#// By reversing the types, we end up implementing non-commutative addition.
#// Here, we make `Add<Foo>` - the trait for addition with a RHS of type `Foo`.
#// This block implements the operation: Bar + Foo = BarFoo
// これらの型を逆にすることで、非可換的な追加を実装することになります。ここでは、`Add<Foo>`を追加します。これは`Foo`型のRHSを持つ追加用の特性です。このブロックは次の操作を実装します：Bar + Foo = BarFoo
impl ops::Add<Foo> for Bar {
    type Output = BarFoo;

    fn add(self, _rhs: Foo) -> BarFoo {
        println!("> Bar.add(Foo) was called");

        BarFoo
    }
}

fn main() {
    println!("Foo + Bar = {:?}", Foo + Bar);
    println!("Bar + Foo = {:?}", Bar + Foo);
}
```

### <!--See Also--> 関連項目

<!--[Add][add], [Syntax Index][syntax]-->
[Add][add]、 [構文インデックス][syntax]

<!--[add]: https://doc.rust-lang.org/core/ops/trait.Add.html
 [ops]: https://doc.rust-lang.org/core/ops/
-->
[ops]: https://doc.rust-lang.org/core/ops/
 [add]: https://doc.rust-lang.org/core/ops/trait.Add.html

<!--[syntax]:https://doc.rust-lang.org/book/second-edition/appendix-02-operators.html-->
[syntax]：https：//doc.rust-lang.org/book/second-edition/appendix-02-operators.html
