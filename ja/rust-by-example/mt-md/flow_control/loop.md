# <!--loop--> ループ

<!--Rust provides a `loop` keyword to indicate an infinite loop.-->
Rustは、無限ループを示す`loop`キーワードを提供します。

<!--The `break` statement can be used to exit a loop at anytime, whereas the `continue` statement can be used to skip the rest of the iteration and start a new one.-->
`break`ステートメントはいつでもループを終了するのに使用できますが、`continue`ステートメントを使用して残りの繰り返しをスキップして新しいステートメントを開始することができます。

```rust,editable
fn main() {
    let mut count = 0u32;

    println!("Let's count until infinity!");

#    // Infinite loop
    // 無限ループ
    loop {
        count += 1;

        if count == 3 {
            println!("three");

#            // Skip the rest of this iteration
            // この繰り返しの残りの部分をスキップする
            continue;
        }

        println!("{}", count);

        if count == 5 {
            println!("OK, that's enough");

#            // Exit this loop
            // このループを終了する
            break;
        }
    }
}
```
