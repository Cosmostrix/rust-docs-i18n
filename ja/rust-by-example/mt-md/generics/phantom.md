# <!--Phantom type parameters--> ファントムタイプのパラメータ

<!--A phantom type parameter is one that doesn't show up at runtime, but is checked statically (and only) at compile time.-->
ファントム型のパラメータは、実行時には表示されませんが、コンパイル時には静的にのみチェックされます。

<!--Data types can use extra generic type parameters to act as markers or to perform type checking at compile time.-->
データ型は、余分なジェネリック型パラメータを使用して、マーカーとして動作したり、コンパイル時に型チェックを実行することができます。
<!--These extra parameters hold no storage values, and have no runtime behavior.-->
これらの余分なパラメータは、ストレージ値を保持せず、実行時の動作もありません。

<!--In the following example, we combine [std::marker::PhantomData] with the phantom type parameter concept to create tuples containing different data types.-->
次の例では、[std::marker::PhantomData]をファントム型パラメータの概念と組み合わせて、異なるデータ型を含むタプルを作成します。

```rust,editable
use std::marker::PhantomData;

#// A phantom tuple struct which is generic over `A` with hidden parameter `B`.
// 隠れたパラメータ`B`を`A`に対して一般的なファントムタプル構造体。
#//#[derive(PartialEq)] // Allow equality test for this type.
#[derive(PartialEq)] // このタイプの平等テストを許可する。
struct PhantomTuple<A, B>(A,PhantomData<B>);

#// A phantom type struct which is generic over `A` with hidden parameter `B`.
// 隠れたパラメータ`B`を`A`に対して一般的なファントム型の構造体。
#//#[derive(PartialEq)] // Allow equality test for this type.
#[derive(PartialEq)] // このタイプの平等テストを許可する。
struct PhantomStruct<A, B> { first: A, phantom: PhantomData<B> }

#// Note: Storage is allocated for generic type `A`, but not for `B`.
#//       Therefore, `B` cannot be used in computations.
// 注：ストレージは汎用タイプ`A`割り当てられますが、`B`は割り当てられません。したがって、`B`は計算に使用できません。

fn main() {
#    // Here, `f32` and `f64` are the hidden parameters.
#    // PhantomTuple type specified as `<char, f32>`.
    // ここで、`f32`と`f64`は隠れたパラメータです。PhantomTuple型は`<char, f32>`として指定されています。
    let _tuple1: PhantomTuple<char, f32> = PhantomTuple('Q', PhantomData);
#    // PhantomTuple type specified as `<char, f64>`.
    //  PhantomTuple型は`<char, f64>`指定されています。
    let _tuple2: PhantomTuple<char, f64> = PhantomTuple('Q', PhantomData);

#    // Type specified as `<char, f32>`.
    // タイプは`<char, f32>`指定されています。
    let _struct1: PhantomStruct<char, f32> = PhantomStruct {
        first: 'Q',
        phantom: PhantomData,
    };
#    // Type specified as `<char, f64>`.
    // タイプは`<char, f64>`指定されています。
    let _struct2: PhantomStruct<char, f64> = PhantomStruct {
        first: 'Q',
        phantom: PhantomData,
    };
    
#    // Compile-time Error! Type mismatch so these cannot be compared:
    // コンパイル時エラー！タイプミスマッチのため、比較できません：
    //println!("_tuple1 == _tuple2 yields: {}",
#    //          _tuple1 == _tuple2);
    //   _tuple1 ==_  tuple2）;
    
#    // Compile-time Error! Type mismatch so these cannot be compared:
    // コンパイル時エラー！タイプミスマッチのため、比較できません：
    //println!("_struct1 == _struct2 yields: {}",
#    //          _struct1 == _struct2);
    //   _struct1 ==_  struct2）;
}
```

### <!--See also:--> 参照：

<!--[Derive], [struct], and [TupleStructs]-->
[Derive]、 [struct]、および[TupleStructs]

<!--[Derive]: trait/derive.html
 [struct]: custom_types/structs.html
 [TupleStructs]: custom_types/structs.html
 [std::marker::PhantomData]: https://doc.rust-lang.org/std/marker/struct.PhantomData.html
-->
[Derive]: trait/derive.html
 [struct]: custom_types/structs.html
 [TupleStructs]: custom_types/structs.html
 [std::marker::PhantomData]: https://doc.rust-lang.org/std/marker/struct.PhantomData.html

