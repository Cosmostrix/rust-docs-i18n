# <!--if/else--> if / else

<!--Branching with `if` -`else` is similar to other languages.-->
`if` -`else`分岐する`else`は他の言語に似ています。
<!--Unlike many of them, the boolean condition doesn't need to be surrounded by parentheses, and each condition is followed by a block.-->
多くの場合と違って、ブール条件は括弧で囲む必要はなく、各条件の後にブロックが続きます。
<!--`if` -`else` conditionals are expressions, and, all branches must return the same type.-->
`if` -`else`条件文が式であり、すべてのブランチが同じ型を返す必要があります。

```rust,editable
fn main() {
    let n = 5;

    if n < 0 {
        print!("{} is negative", n);
    } else if n > 0 {
        print!("{} is positive", n);
    } else {
        print!("{} is zero", n);
    }

    let big_n =
        if n < 10 && n > -10 {
            println!(", and is a small number, increase ten-fold");

#            // This expression returns an `i32`.
            // この式は`i32`返します。
            10 * n
        } else {
            println!(", and is a big number, half the number");

#            // This expression must return an `i32` as well.
            // この式は`i32`も返さなければなりません。
            n / 2
#            // TODO ^ Try suppressing this expression with a semicolon.
            //  TODO ^この式をセミコロンで抑制してみてください。
        };
#    //   ^ Don't forget to put a semicolon here! All `let` bindings need it.
    //  ^ここにセミコロンを置くことを忘れないでください！すべての`let`バインディングはそれを必要とします。

    println!("{} -> {}", n, big_n);
}
```
