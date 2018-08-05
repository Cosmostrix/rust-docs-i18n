# <!--Literals--> リテラル

<!--Numeric literals can be type annotated by adding the type as a suffix.-->
数値リテラルには、型を接尾辞として追加することによって型を注釈することができます。
<!--As an example, to specify that the literal `42` should have the type `i32`, write `42i32`.-->
例として、リテラル`42`がタイプ`i32`を持つように指定するには、`42i32`と記述し`42i32`。

<!--The type of unsuffixed numeric literals will depend on how they are used.-->
接尾辞なしの数値リテラルのタイプは、それらの使用方法によって異なります。
<!--If no constraint exists, the compiler will use `i32` for integers, and `f64` for floating-point numbers.-->
制約がない場合、コンパイラは整数に`i32`を、浮動小数点数に`f64`を使用します。

```rust,editable
fn main() {
#    // Suffixed literals, their types are known at initialization
    // 接尾辞付きのリテラルで、その型は初期化時に知られています
    let x = 1u8;
    let y = 2u32;
    let z = 3f32;

#    // Unsuffixed literal, their types depend on how they are used
    // リテラルではなく、それらの型は使用方法に依存します
    let i = 1;
    let f = 1.0;

#    // `size_of_val` returns the size of a variable in bytes
    //  `size_of_val`は変数のサイズをバイト単位で返します。
    println!("size of `x` in bytes: {}", std::mem::size_of_val(&x));
    println!("size of `y` in bytes: {}", std::mem::size_of_val(&y));
    println!("size of `z` in bytes: {}", std::mem::size_of_val(&z));
    println!("size of `i` in bytes: {}", std::mem::size_of_val(&i));
    println!("size of `f` in bytes: {}", std::mem::size_of_val(&f));
}
```

<!--There are some concepts used in the previous code that haven't been explained yet, here's a brief explanation for the impatient readers:-->
前のコードではまだ説明されていないいくつかの概念がありますが、ここでは気楽な読者について簡単に説明します：

* <!--`fun(&foo)` is used to pass an argument to a function *by reference*, rather than by value (`fun(foo)`).-->
   `fun(&foo)`は、値（`fun(foo)`）ではなく*参照によって*関数に引数を渡すために使用されます。
<!--For more details see [borrowing][borrow].-->
   詳細については、[borrowing][borrow]参照してください。
* <!--`std::mem::size_of_val` is a function, but called with its *full path*.-->
   `std::mem::size_of_val`は関数`std::mem::size_of_val`が、*フルパスで*呼び出され*ます*。
<!--Code can be split in logical units called *modules*.-->
   コードは*モジュール*と呼ばれる論理単位で分割でき*ます*。
<!--In this case, the `size_of_val` function is defined in the `mem` module, and the `mem` module is defined in the `std` *crate*.-->
   この場合、`size_of_val`関数で定義され`mem`モジュール、及び`mem`モジュールはで定義されている`std` *クレート*。
<!--For more details, see [modules][mod] and [crates][crate].-->
   詳細については、[modules][mod]と[crates][crate]参照してください。

<!--[borrow]: scope/borrow.html
 [mod]: mod.html
 [crate]: crates.html
-->
[mod]: mod.html
 [crate]: crates.html
 [borrow]: scope/borrow.html

