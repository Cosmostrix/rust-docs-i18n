# <!--Testcase: unit clarification--> テストケース：ユニットの明確化

<!--A useful method of unit conversions can be examined by implementing `Add` with a phantom type parameter.-->
ファントム型パラメータを使用して`Add`を実装することにより、単位変換の有用な方法を調べることができます。
<!--The `Add` `trait` is examined below:-->
`Add` `trait`は以下のとおりです。

```rust,ignore
#// This construction would impose: `Self + RHS = Output`
#// where RHS defaults to Self if not specified in the implementation.
//  `Self + RHS = Output`実装で指定されていない場合、RHSのデフォルトはSelfになります。
pub trait Add<RHS = Self> {
    type Output;

    fn add(self, rhs: RHS) -> Self::Output;
}

#// `Output` must be `T<U>` so that `T<U> + T<U> = T<U>`.
//  `Output`は`T<U> + T<U> = T<U>`となるように`T<U>`なければなりません。
impl<U> Add for T<U> {
    type Output = T<U>;
    ...
}
```

<!--The whole implementation:-->
実装全体：

```rust,editable
use std::ops::Add;
use std::marker::PhantomData;

#///// Create void enumerations to define unit types.
/// 単位の型を定義するvoid列挙を作成します。
#[derive(Debug, Clone, Copy)]
enum Inch {}
#[derive(Debug, Clone, Copy)]
enum Mm {}

#///// `Length` is a type with phantom type parameter `Unit`,
///  `Length`は、ファントムタイプのパラメータ`Unit`持つタイプです。
#///// and is not generic over the length type (that is `f64`).
/// 長さタイプ（つまり`f64`）には一般的ではありません。
///
#///// `f64` already implements the `Clone` and `Copy` traits.
///  `f64`すでに`Clone`と`Copy`特性を実装しています。
#[derive(Debug, Clone, Copy)]
struct Length<Unit>(f64, PhantomData<Unit>);

#///// The `Add` trait defines the behavior of the `+` operator.
///  `Add`特性は、`+`演算子の動作を定義します。
impl<Unit> Add for Length<Unit> {
     type Output = Length<Unit>;

#    // add() returns a new `Length` struct containing the sum.
    //  add（）は、合計を含む新しい`Length`構造体を返します。
    fn add(self, rhs: Length<Unit>) -> Length<Unit> {
#        // `+` calls the `Add` implementation for `f64`.
        //  `+`は`f64`の`Add`実装を呼び出します。
        Length(self.0 + rhs.0, PhantomData)
    }
}

fn main() {
#    // Specifies `one_foot` to have phantom type parameter `Inch`.
    // ファントム型パラメータ`Inch`を持つ`one_foot`を指定します。
    let one_foot:  Length<Inch> = Length(12.0, PhantomData);
#    // `one_meter` has phantom type parameter `Mm`.
    //  `one_meter`は、ファントム型パラメータ`Mm`。
    let one_meter: Length<Mm>   = Length(1000.0, PhantomData);

#    // `+` calls the `add()` method we implemented for `Length<Unit>`.
    //  `+`は、`Length<Unit>`に対して実装した`add()`メソッドを呼び出します。
    //
#    // Since `Length` implements `Copy`, `add()` does not consume
#    // `one_foot` and `one_meter` but copies them into `self` and `rhs`.
    //  `Length`は`Copy`実装しているので、`add()`は`one_foot`と`one_meter`消費せず、`self`と`rhs`コピーします。
    let two_feet = one_foot + one_foot;
    let two_meters = one_meter + one_meter;

#    // Addition works.
    // 追加作業。
    println!("one foot + one_foot = {:?} in", two_feet.0);
    println!("one meter + one_meter = {:?} mm", two_meters.0);

#    // Nonsensical operations fail as they should:
#    // Compile-time Error: type mismatch.
    // コンパイル時エラー：型の不一致。
    //let one_feter = one_foot + one_meter;
}
```

### <!--See also:--> 参照：

<!--[Borrowing (`&`)], [Bounds (`X: Y`)], [enum], [impl & self], [Overloading], [ref], [Traits (`X for Y`)], and [TupleStructs].-->
[Borrowing (`&`)] [Bounds (`X: Y`)] [enum]、 [impl & self]、 [Overloading]、 [ref]、 [Traits (`X for Y`)]および[TupleStructs]。

<!--[Borrowing (`&`)]: scope/borrow.html
 [Bounds (`X: Y`)]: generics/bounds.html
 [enum]: custom_types/enum.html
 [impl & self]: fn/methods.html
 [Overloading]: trait/ops.html
 [ref]: scope/borrow/ref.html
 [Traits (`X for Y`)]: trait.html
 [TupleStructs]: custom_types/structs.html
 [std::marker::PhantomData]: https://doc.rust-lang.org/std/marker/struct.PhantomData.html
-->
[Borrowing (`&`)]: scope/borrow.html
 [Bounds (`X: Y`)]: generics/bounds.html
 [enum]: custom_types/enum.html
 [impl & self]: fn/methods.html
 [Overloading]: trait/ops.html
 [ref]: scope/borrow/ref.html
 [Traits (`X for Y`)]: trait.html
 [TupleStructs]: custom_types/structs.html
 [std::marker::PhantomData]: https://doc.rust-lang.org/std/marker/struct.PhantomData.html

