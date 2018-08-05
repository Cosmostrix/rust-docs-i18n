# <!--Expressions--> 式

<!--A Rust program is (mostly) made up of a series of statements:-->
Rustプログラムは（主に）一連のステートメントで構成されています。

```
fn main() {
#    // statement
#    // statement
#    // statement
    // ステートメントステートメントステートメント
}
```

<!--There are a few kinds of statements in Rust.-->
Rustにはいくつかの種類の文があります。
<!--The most common two are declaring a variable binding, and using a `;`-->
最も一般的な2つは可変バインディングを宣言しています`;`
<!--with an expression:-->
式を使って：

```
fn main() {
#    // variable binding
    // 可変バインディング
    let x = 5;

#    // expression;
    // 発現;
    x;
    x + 1;
    15;
}
```

<!--Blocks are expressions too, so they can be used as [r-values][rvalue] in assignments.-->
ブロックは式でもあるので、代入の[r-values][rvalue]として使用できます。
<!--The last expression in the block will be assigned to the [l-value][lvalue].-->
ブロックの最後の式は[l-value][lvalue]割り当てられ[l-value][lvalue]。
<!--However, if the last expression of the block ends with a semicolon, the return value will be `()`.-->
ただし、ブロックの最後の式がセミコロンで終わる場合、戻り値は`()`ます。

```rust,editable
fn main() {
    let x = 5u32;

    let y = {
        let x_squared = x * x;
        let x_cube = x_squared * x;

#        // This expression will be assigned to `y`
        // この式は`y`に代入されます。
        x_cube + x_squared + x
    };

    let z = {
#        // The semicolon suppresses this expression and `()` is assigned to `z`
        // セミコロンはこの式を抑制し、`()`は`z`
        2 * x;
    };

    println!("x is {:?}", x);
    println!("y is {:?}", y);
    println!("z is {:?}", z);
}
```

<!--[rvalue]: https://en.wikipedia.org/wiki/Value_%28computer_science%29#lrvalue
 [lvalue]: https://en.wikipedia.org/wiki/Value_%28computer_science%29#lrvalue
-->
[rvalue]: https://en.wikipedia.org/wiki/Value_%28computer_science%29#lrvalue
 [lvalue]: https://en.wikipedia.org/wiki/Value_%28computer_science%29#lrvalue

