# <!--Arrays and Slices--> 配列とスライス

<!--An array is a collection of objects of the same type `T`, stored in contiguous memory.-->
配列は、連続したメモリに格納された同じ型`T`オブジェクトの集合です。
<!--Arrays are created using brackets `[]`, and their size, which is known at compile time, is part of their type signature `[T; size]`-->
配列は大括弧`[]`を使用して作成され、コンパイル時に判明しているそのサイズは型シグネチャ`[T; size]`
<!--`[T; size]`.-->
`[T; size]`。

<!--Slices are similar to arrays, but their size is not known at compile time.-->
スライスは配列に似ていますが、そのサイズはコンパイル時には分かりません。
<!--Instead, a slice is a two-word object, the first word is a pointer to the data, and the second word is the length of the slice.-->
代わりに、スライスは2ワードのオブジェクトで、最初のワードはデータへのポインタで、2番目のワードはスライスの長さです。
<!--The word size is the same as usize, determined by the processor architecture eg 64 bits on an x86-64.-->
ワードサイズは、x86-64上の64ビットなど、プロセッサアーキテクチャによって決まるusizeと同じです。
<!--Slices can be used to borrow a section of an array, and have the type signature `&[T]`.-->
スライスは、配列のセクションを借用するために使用することができ、`&[T]`型のシグネチャを持ちます。

```rust,editable,ignore,mdbook-runnable
use std::mem;

#// This function borrows a slice
// この関数はスライスを借りる
fn analyze_slice(slice: &[i32]) {
    println!("first element of the slice: {}", slice[0]);
    println!("the slice has {} elements", slice.len());
}

fn main() {
#    // Fixed-size array (type signature is superfluous)
    // 固定長配列（型シグネチャは余分です）
    let xs: [i32; 5] = [1, 2, 3, 4, 5];

#    // All elements can be initialized to the same value
    // すべての要素を同じ値に初期化することができます
    let ys: [i32; 500] = [0; 500];

#    // Indexing starts at 0
    // インデックスは0から始まります
    println!("first element of the array: {}", xs[0]);
    println!("second element of the array: {}", xs[1]);

#    // `len` returns the size of the array
    //  `len`は配列のサイズを返す
    println!("array size: {}", xs.len());

#    // Arrays are stack allocated
    // 配列はスタックに割り当てられています
    println!("array occupies {} bytes", mem::size_of_val(&xs));

#    // Arrays can be automatically borrowed as slices
    // 配列は自動的にスライスとして借りることができます
    println!("borrow the whole array as a slice");
    analyze_slice(&xs);

#    // Slices can point to a section of an array
    // スライスは配列の一部を指すことができます
    println!("borrow a section of the array as a slice");
    analyze_slice(&ys[1 .. 4]);

#    // Out of bound indexing yields a panic
    // バインドされていない索引付けによってパニックが発生する
    println!("{}", xs[5]);
}
```
