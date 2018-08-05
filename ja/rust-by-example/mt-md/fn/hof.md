# <!--Higher Order Functions--> 高次関数

<!--Rust provides Higher Order Functions (HOF).-->
錆は高次関数（HOF）を提供します。
<!--These are functions that take one or more functions and/or produce a more useful function.-->
これらは、1つまたは複数の機能を取り、および/またはより有用な機能を生成する機能です。
<!--HOFs and lazy iterators give Rust its functional flavor.-->
HOFとレイジーイテレータは、Rustに機能的な味を与えます。

```rust,editable
fn is_odd(n: u32) -> bool {
    n % 2 == 1
}

fn main() {
    println!("Find the sum of all the squared odd numbers under 1000");
    let upper = 1000;

#    // Imperative approach
#    // Declare accumulator variable
    // 命令的アプローチアキュムレータ変数を宣言する
    let mut acc = 0;
#    // Iterate: 0, 1, 2, ... to infinity
    // 反復：0,1,2、...から無限大へ
    for n in 0.. {
#        // Square the number
        // 番号を正方形にする
        let n_squared = n * n;

        if n_squared >= upper {
#            // Break loop if exceeded the upper limit
            // 上限を超えるとブレークループ
            break;
        } else if is_odd(n_squared) {
#            // Accumulate value, if it's odd
            // 奇数の場合、累積値
            acc += n_squared;
        }
    }
    println!("imperative style: {}", acc);

#    // Functional approach
    // 機能的アプローチ
    let sum_of_squared_odd_numbers: u32 =
#//        (0..).map(|n| n * n)                             // All natural numbers squared
        (0..).map(|n| n * n)                             // すべての自然数の二乗
#//             .take_while(|&n_squared| n_squared < upper) // Below upper limit
             .take_while(|&n_squared| n_squared < upper) // 上限以下
#//             .filter(|&n_squared| is_odd(n_squared))     // That are odd
             .filter(|&n_squared| is_odd(n_squared))     // それは奇妙です
#//             .fold(0, |acc, n_squared| acc + n_squared); // Sum them
             .fold(0, |acc, n_squared| acc + n_squared); // それらを合計する
    println!("functional style: {}", sum_of_squared_odd_numbers);
}
```

<!--[Option][option] and [Iterator][iter] implement their fair share of HOFs.-->
[Option][option]と[Iterator][iter]はHOFの公平な分担を実装します。

<!--[option]: https://doc.rust-lang.org/core/option/enum.Option.html
 [iter]: https://doc.rust-lang.org/core/iter/trait.Iterator.html
-->
[option]: https://doc.rust-lang.org/core/option/enum.Option.html
 [iter]: https://doc.rust-lang.org/core/iter/trait.Iterator.html

