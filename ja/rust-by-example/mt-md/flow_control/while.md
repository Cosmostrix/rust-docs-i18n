# <!--while--> while

<!--The `while` keyword can be used to loop until a condition is met.-->
`while`キーワードは、条件が満たされるまでループするのに使用できます。

<!--Let's write the infamous [FizzBuzz][fizzbuzz] using a `while` loop.-->
`while`ループを使って悪名高い[FizzBuzz][fizzbuzz]を書きましょう。

```rust,editable
fn main() {
#    // A counter variable
    // カウンタ変数
    let mut n = 1;

#    // Loop while `n` is less than 101
    //  `n`が101未満のときのループ
    while n < 101 {
        if n % 15 == 0 {
            println!("fizzbuzz");
        } else if n % 3 == 0 {
            println!("fizz");
        } else if n % 5 == 0 {
            println!("buzz");
        } else {
            println!("{}", n);
        }

#        // Increment counter
        // インクリメントカウンタ
        n += 1;
    }
}
```

[fizzbuzz]: https://en.wikipedia.org/wiki/Fizz_buzz
