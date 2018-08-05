# <!--Box, stack and heap--> ボックス、スタック、ヒープ

<!--All values in Rust are stack allocated by default.-->
Rustのすべての値はデフォルトでスタックに割り当てられます。
<!--Values can be *boxed* (allocated in the heap) by creating a `Box<T>`.-->
`Box<T>`作成することで、値を*ボックス化*（ヒープ内で割り当て）することができます。
<!--A box is a smart pointer to a heap allocated value of type `T`.-->
ボックスは、タイプ`T`ヒープ割り当て値へのスマートポインタです。
<!--When a box goes out of scope, its destructor is called, the inner object is destroyed, and the memory in the heap is freed.-->
ボックスが有効範囲外になると、そのデストラクタが呼び出され、内部オブジェクトが破棄され、ヒープ内のメモリが解放されます。

<!--Boxed values can be dereferenced using the `*` operator;-->
ボックス化された値は、`*`演算子を使用して逆参照できます。
<!--this removes one layer of indirection.-->
1つの間接指定を削除します。

```rust,editable
use std::mem;

#[allow(dead_code)]
#[derive(Debug, Clone, Copy)]
struct Point {
    x: f64,
    y: f64,
}

#[allow(dead_code)]
struct Rectangle {
    p1: Point,
    p2: Point,
}

fn origin() -> Point {
    Point { x: 0.0, y: 0.0 }
}

fn boxed_origin() -> Box<Point> {
#    // Allocate this point in the heap, and return a pointer to it
    // このポイントをヒープに割り当て、ポインタを返します
    Box::new(Point { x: 0.0, y: 0.0 })
}

fn main() {
#    // (all the type annotations are superfluous)
#    // Stack allocated variables
    // （すべての型の注釈は余計です）スタックに割り当てられた変数
    let point: Point = origin();
    let rectangle: Rectangle = Rectangle {
        p1: origin(),
        p2: Point { x: 3.0, y: 4.0 }
    };

#    // Heap allocated rectangle
    // ヒープ割り当て矩形
    let boxed_rectangle: Box<Rectangle> = Box::new(Rectangle {
        p1: origin(),
        p2: origin()
    });

#    // The output of functions can be boxed
    // 関数の出力はボックス化することができます
    let boxed_point: Box<Point> = Box::new(origin());

#    // Double indirection
    // ダブルインダイレクション
    let box_in_a_box: Box<Box<Point>> = Box::new(boxed_origin());

    println!("Point occupies {} bytes in the stack",
             mem::size_of_val(&point));
    println!("Rectangle occupies {} bytes in the stack",
             mem::size_of_val(&rectangle));

#    // box size = pointer size
    // ボックスサイズ=ポインタサイズ
    println!("Boxed point occupies {} bytes in the stack",
             mem::size_of_val(&boxed_point));
    println!("Boxed rectangle occupies {} bytes in the stack",
             mem::size_of_val(&boxed_rectangle));
    println!("Boxed box occupies {} bytes in the stack",
             mem::size_of_val(&box_in_a_box));

#    // Copy the data contained in `boxed_point` into `unboxed_point`
    // 含まれるデータのコピー`boxed_point`に`unboxed_point`
    let unboxed_point: Point = *boxed_point;
    println!("Unboxed point occupies {} bytes in the stack",
             mem::size_of_val(&unboxed_point));
}
```
