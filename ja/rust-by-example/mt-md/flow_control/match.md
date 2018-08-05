# <!--match--> 一致

<!--Rust provides pattern matching via the `match` keyword, which can be used like a C `switch`.-->
Rustは、C `switch`ように使用できる`match`キーワードによるパターンマッチングを提供します。

```rust,editable
fn main() {
    let number = 13;
#    // TODO ^ Try different values for `number`
    //  TODO ^ `number`異なる値を試してください

    println!("Tell me about {}", number);
    match number {
#        // Match a single value
        // 単一の値に一致させる
        1 => println!("One!"),
#        // Match several values
        // 複数の値を一致させる
        2 | 3 | 5 | 7 | 11 => println!("This is a prime"),
#        // Match an inclusive range
        // 包括的な範囲にマッチする
        13...19 => println!("A teen"),
#        // Handle the rest of cases
        // 残りのケースを処理する
        _ => println!("Ain't special"),
    }

    let boolean = true;
#    // Match is an expression too
    // マッチも式です
    let binary = match boolean {
#        // The arms of a match must cover all the possible values
        // マッチの腕はすべての可能な値をカバーしなければならない
        false => 0,
        true => 1,
#        // TODO ^ Try commenting out one of these arms
        //  TODO ^これらの武器をコメントアウトしてみてください
    };

    println!("{} -> {}", boolean, binary);
}
```
