# <!--Tuples--> タプル

<!--A tuple is a collection of values of different types.-->
タプルは、異なる型の値の集合です。
<!--Tuples are constructed using parentheses `()`, and each tuple itself is a value with type signature `(T1, T2, ...)`, where `T1`, `T2` are the types of its members.-->
タプルは括弧`()`を使用して作成され、各タプル自体は型シグニチャ`(T1, T2, ...)`持つ値`(T1, T2, ...)`ここで、`T1`、 `T2`はメンバの型です。
<!--Functions can use tuples to return multiple values, as tuples can hold any number of values.-->
タプルは任意の数の値を保持できるため、関数はタプルを使用して複数の値を返すことができます。

```rust,editable
#// Tuples can be used as function arguments and as return values
// タプルは関数の引数と戻り値として使用できます
fn reverse(pair: (i32, bool)) -> (bool, i32) {
#    // `let` can be used to bind the members of a tuple to variables
    //  `let`は、タプルのメンバーを変数にバインドするために使用できます
    let (integer, boolean) = pair;

    (boolean, integer)
}

#// The following struct is for the activity.
// 次の構造体はアクティビティ用です。
#[derive(Debug)]
struct Matrix(f32, f32, f32, f32);

fn main() {
#    // A tuple with a bunch of different types
    // さまざまな種類のタプル
    let long_tuple = (1u8, 2u16, 3u32, 4u64,
                      -1i8, -2i16, -3i32, -4i64,
                      0.1f32, 0.2f64,
                      'a', true);

#    // Values can be extracted from the tuple using tuple indexing
    // タプルの索引付けを使用してタプルから値を抽出できます
    println!("long tuple first value: {}", long_tuple.0);
    println!("long tuple second value: {}", long_tuple.1);

#    // Tuples can be tuple members
    // タプルはタプルメンバーになることができます
    let tuple_of_tuples = ((1u8, 2u16, 2u32), (4u64, -1i8), -2i16);

#    // Tuples are printable
    // タプルは印刷可能です
    println!("tuple of tuples: {:?}", tuple_of_tuples);
    
#    // But long Tuples cannot be printed
#    // let too_long_tuple = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
#    // println!("too long tuple: {:?}", too_long_tuple);
#    // TODO ^ Uncomment the above 2 lines to see the compiler error
    // しかし長いタプルは印刷できません。too_long_tuple =（1,2,3,4,5,6,7,8,9,10,11,12,13）。println！（"長すぎるタプル：{：？}"、too_long_tuple）; TODO ^上記の2行のコメントを外して、コンパイラエラーを確認してください

    let pair = (1, true);
    println!("pair is {:?}", pair);

    println!("the reversed pair is {:?}", reverse(pair));

#    // To create one element tuples, the comma is required to tell them apart
#    // from a literal surrounded by parentheses
    //  1つの要素タプルを作成するには、括弧で囲まれたリテラルとは別にカンマが必要です
    println!("one element tuple: {:?}", (5u32,));
    println!("just an integer: {:?}", (5u32));

    //tuples can be destructured to create bindings
    let tuple = (1, "hello", 4.5, true);

    let (a, b, c, d) = tuple;
    println!("{:?}, {:?}, {:?}, {:?}", a, b, c, d);

    let matrix = Matrix(1.1, 1.2, 2.1, 2.2);
    println!("{:?}", matrix);

}
```

### <!--Activity--> アクティビティ

 1. <!--*Recap*: Add the `fmt::Display` trait to the Matrix `struct` in the above example, so that if you switch from printing the debug format `{:?}` to the display format `{}`, you see the following output:-->
     *要約*： `fmt::Display`特性を上記の例のMatrix `struct`に追加すると、デバッグ形式`{:?}`を表示形式`{}`に印刷すると、次の出力が表示されます。

<!--` ``text ( 1.1 1.2 ) ( 2.1 2.2 )`` `-->
` ``text ( 1.1 1.2 ) ( 2.1 2.2 )`` `

<!--You may want to refer back to the example for [print display][print_display].-->
[印刷の表示][print_display]例を参照してください。
<!--2. Add a `transpose` function using the `reverse` function as a template, which accepts a matrix as an argument, and returns a matrix in which two elements have been swapped.-->
2. `reverse`関数をテンプレートとして使用して`transpose`関数を追加します。これは、行列を引数として受け入れ、2つの要素がスワップされた行列を返します。
<!--For example:-->
例えば：

<!--` ``rust,ignore println!("Matrix:\n{}", matrix); println!("Transpose:\n{}", transpose(matrix));``-->
` ``rust,ignore println!("Matrix:\n{}", matrix); println!("Transpose:\n{}", transpose(matrix));``
``rust,ignore println!("Matrix:\n{}", matrix); println!("Transpose:\n{}", transpose(matrix));`` <!--`-->
`

<!--results in the output:-->
結果は次のようになります。

<!--` ``text Matrix: ( 1.1 1.2 ) ( 2.1 2.2 ) Transpose: ( 1.1 2.1 ) ( 1.2 2.2 )`` `-->
` ``text Matrix: ( 1.1 1.2 ) ( 2.1 2.2 ) Transpose: ( 1.1 2.1 ) ( 1.2 2.2 )`` `

[print_display]: hello/print/print_display.html
