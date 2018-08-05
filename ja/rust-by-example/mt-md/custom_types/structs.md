# <!--Structures--> 構造

<!--There are three types of structures ("structs") that can be created using the `struct` keyword:-->
`struct`キーワードを使用して作成できる3つのタイプの構造体（「構造体」）があります。

* <!--Tuple structs, which are, basically, named tuples.-->
   基本的にタプルと呼ばれるタプル構造体。
* <!--The classic [C structs][c_struct]-->
   古典的な[C構造体][c_struct]
* <!--Unit structs, which are field-less, are useful for generics.-->
   フィールドレスであるユニット構造体は、ジェネリックで役に立ちます。

```rust,editable
#[derive(Debug)]
struct Person<'a> {
    name: &'a str,
    age: u8,
}

#// A unit struct
// ユニット構造体
struct Nil;

#// A tuple struct
// タプル構造体
struct Pair(i32, f32);

#// A struct with two fields
//  2つのフィールドを持つ構造体
struct Point {
    x: f32,
    y: f32,
}

#// Structs can be reused as fields of another struct
// 構造体は別の構造体のフィールドとして再利用できます
#[allow(dead_code)]
struct Rectangle {
    p1: Point,
    p2: Point,
}

fn main() {
#    // Create struct with field init shorthand
    // フィールドinitを省略した構造体を作成する
    let name = "Peter";
    let age = 27;
    let peter = Person { name, age };

#    // Print debug struct
    // デバッグ構造体を印刷する
    println!("{:?}", peter);


#    // Instantiate a `Point`
    //  `Point`インスタンス化
    let point: Point = Point { x: 0.3, y: 0.4 };

#    // Access the fields of the point
    // ポイントのフィールドにアクセスする
    println!("point coordinates: ({}, {})", point.x, point.y);

#    // Make a new point by using struct update syntax to use the fields of our other one
    //  struct update構文を使用して、他のフィールドのフィールドを使用して新しいポイントを作成する
    let new_point = Point { x: 0.1, ..point };
#    // `new_point.y` will be the same as `point.y` because we used that field from `point`
    //  `new_point.y`同じになります`point.y`たちからそのフィールドを使用しているため`point`
    println!("second point: ({}, {})", new_point.x, new_point.y);

#    // Destructure the point using a `let` binding
    //  `let`バインディングを使用してポイントをデストラクションする
    let Point { x: my_x, y: my_y } = point;

    let _rectangle = Rectangle {
#        // struct instantiation is an expression too
        // 構造体のインスタンス化も式です
        p1: Point { x: my_y, y: my_x },
        p2: point,
    };

#    // Instantiate a unit struct
    // ユニット構造体のインスタンス化
    let _nil = Nil;

#    // Instantiate a tuple struct
    // タプル構造体をインスタンス化する
    let pair = Pair(1, 0.1);

#    // Access the fields of a tuple struct
    // タプル構造体のフィールドにアクセスする
    println!("pair contains {:?} and {:?}", pair.0, pair.1);

#    // Destructure a tuple struct
    // タプル構造体をデストラクトする
    let Pair(integer, decimal) = pair;

    println!("pair contains {:?} and {:?}", integer, decimal);
}
```

### <!--Activity--> アクティビティ

1. <!--Add a function `rect_area` which calculates the area of a rectangle (try using nested destructuring).-->
    四角形の面積を計算する関数`rect_area`を追加します（入れ子構造の破壊を使用してみてください）。
2. <!--Add a function `square` which takes a `Point` and a `f32` as arguments, and returns a `Rectangle` with its lower left corner on the point, and a width and height corresponding to the `f32`.-->
    `Point`と`f32`を引数とする関数`square`を追加し、その点の左下隅と`f32`対応する幅と高さを持つ`Rectangle`を返します。

### <!--See also:--> 参照：

<!--[`attributes`][attributes] and [destructuring][destructuring]-->
[`attributes`][attributes]と[destructuring][destructuring]

<!--[attributes]: attribute.html
 [c_struct]: https://en.wikipedia.org/wiki/Struct_(C_programming_language)
 [destructuring]: flow_control/match/destructuring.html
-->
[attributes]: attribute.html
 [c_struct]: https://en.wikipedia.org/wiki/Struct_(C_programming_language)
 [destructuring]: flow_control/match/destructuring.html

