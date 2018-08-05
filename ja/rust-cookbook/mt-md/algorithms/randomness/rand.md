## <!--Generate random numbers--> 乱数を生成する

<!--[!][rand]-->
[！][rand]
<!--[rand-badge] [!][cat-science]-->
[rand-badge] [！][cat-science]
[cat-science-badge]
<!--Generates random numbers with help of random-number generator [`rand::Rng`] obtained via [`rand::thread_rng`].-->
乱数生成器の助けを借りて、乱数を生成し[`rand::Rng`]介して取得した[`rand::thread_rng`]。
<!--Each thread has an intialized generator.-->
各スレッドには初期化されたジェネレータがあります。
<!--Integers are uniformly distributed over the range of the type, and floating point numbers are uniformly distributed from 0 up to but not including 1.-->
整数は型の範囲に渡って一様に分布し、浮動小数点数は0から1までは一様に分布します。

```rust
extern crate rand;

use rand::Rng;

fn main() {
    let mut rng = rand::thread_rng();

    let n1: u8 = rng.gen();
    let n2: u16 = rng.gen();
    println!("Random u8: {}", n1);
    println!("Random u16: {}", n2);
    println!("Random u32: {}", rng.gen::<u32>());
    println!("Random i32: {}", rng.gen::<i32>());
    println!("Random float: {}", rng.gen::<f64>());
}
```

<!--[`rand::Rng`]: https://docs.rs/rand/*/rand/trait.Rng.html
 [`rand::thread_rng`]: https://docs.rs/rand/*/rand/fn.thread_rng.html
-->
[`rand::Rng`]: https://docs.rs/rand/*/rand/trait.Rng.html
 [`rand::thread_rng`]: https://docs.rs/rand/*/rand/fn.thread_rng.html

