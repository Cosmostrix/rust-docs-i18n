## <!--Generate random numbers within a range--> ある範囲内の乱数を生成する

<!--[!][rand]-->
[！][rand]
<!--[rand-badge] [!][cat-science]-->
[rand-badge] [！][cat-science]
[cat-science-badge]
<!--Generates a random value within half-open `[0, 10)` range (not including `10`) with [`Rng::gen_range`].-->
[`Rng::gen_range`] `[0, 10)`範囲（`10`を含まない`[0, 10)`ランダムな値を生成します。

```rust
extern crate rand;

use rand::Rng;

fn main() {
    let mut rng = rand::thread_rng();
    println!("Integer: {}", rng.gen_range(0, 10));
    println!("Float: {}", rng.gen_range(0.0, 10.0));
}
```

<!--[`Range`] can obtain values with [uniform distribution].-->
[`Range`]は[uniform distribution]値を得ることができます。
<!--This has the same effect, but may be faster when repeatedly generating numbers in the same range.-->
これは同じ効果がありますが、同じ範囲で繰り返し数値を生成すると高速になることがあります。

```rust
extern crate rand;

use rand::distributions::{Range, Distribution};

fn main() {
    let mut rng = rand::thread_rng();
    let die = Range::new(1, 7);

    loop {
        let throw = die.sample(&mut rng);
        println!("Roll the die: {}", throw);
        if throw == 6 {
            break;
        }
    }
}
```

<!--[`Uniform`]: https://docs.rs/rand/*/rand/distributions/uniform/struct.Uniform.html
 [`Rng::gen_range`]: https://doc.rust-lang.org/rand/*/rand/trait.Rng.html#method.gen_range
 [uniform distribution]: https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)
-->
[`Uniform`]: https://docs.rs/rand/*/rand/distributions/uniform/struct.Uniform.html
 [`Rng::gen_range`]: https://doc.rust-lang.org/rand/*/rand/trait.Rng.html#method.gen_range
 [uniform distribution]: https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)

