# <!--Implementation--> 実装

<!--Similar to functions, implementations require care to remain generic.-->
関数と同様に、実装では一般的なままにする必要があります。

```rust
#//struct S; // Concrete type `S`
struct S; // コンクリートタイプ`S`
#//struct GenericVal<T>(T,); // Generic type `GenericVal`
struct GenericVal<T>(T,); // 汎用タイプ`GenericVal`

#// impl of GenericVal where we explicitly specify type parameters:
// 私たちが型パラメータを明示的に指定するGenericValのimpl：
#//impl GenericVal<f32> {} // Specify `f32`
impl GenericVal<f32> {} //  `f32`指定する
#//impl GenericVal<S> {} // Specify `S` as defined above
impl GenericVal<S> {} // 上で定義した`S`を指定する

#// `<T>` Must precede the type to remain generic
//  `<T>`ジェネリックのままにする型の前に置かなければならない
impl <T> GenericVal<T> {}
```

```rust,editable
struct Val {
    val: f64
}

struct GenVal<T>{
    gen_val: T
}

#// impl of Val
//  Valのインプラント
impl Val {
    fn value(&self) -> &f64 { &self.val }
}

#// impl of GenVal for a generic type `T`
// ジェネリック型`T` GenValのimpl
impl <T> GenVal<T> {
    fn value(&self) -> &T { &self.gen_val }
}

fn main() {
    let x = Val { val: 3.0 };
    let y = GenVal { gen_val: 3i32 };
    
    println!("{}, {}", x.value(), y.value());
}
```

### <!--See also:--> 参照：

<!--[functions returning references][fn], [`impl`][methods], and [`struct`][structs]-->
[参照][fn]、 [`impl`][methods]、および[`struct`][structs] [返す関数][fn]


<!--[fn]: scope/lifetime/fn.html
 [methods]: fn/methods.html
 [specialization_plans]: https://blog.rust-lang.org/2015/05/11/traits.html#the-future
 [structs]: custom_types/structs.html
-->
[fn]: scope/lifetime/fn.html
 [methods]: fn/methods.html
 [specialization_plans]: https://blog.rust-lang.org/2015/05/11/traits.html#the-future
 [structs]: custom_types/structs.html

