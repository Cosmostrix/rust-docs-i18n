## <!--Generate random values of a custom type--> カスタムタイプのランダムな値を生成する

<!--[!][rand]-->
[！][rand]
<!--[rand-badge] [!][cat-science]-->
[rand-badge] [！][cat-science]
[cat-science-badge]
<!--Randomly generates a tuple `(i32, bool, f64)` and variable of user defined type `Point`.-->
タプル`(i32, bool, f64)`とユーザー定義型`Point`変数をランダムに生成します。
<!--Implements the [`Distribution`] trait on type Point for [`Standard`] in order to allow random generation.-->
ランダム生成を可能にするために、[`Standard`]ためのPoint型の[`Distribution`]特性を実装します。

```rust
extern crate rand;

use rand::Rng;
use rand::distributions::{Distribution, Standard};

#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

impl Distribution<Point> for Standard {
    fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Point {
        let (rand_x, rand_y) = rng.gen();
        Point {
            x: rand_x,
            y: rand_y,
        }
    }
}

fn main() {
    let mut rng = rand::thread_rng();
    let rand_tuple = rng.gen::<(i32, bool, f64)>();
    let rand_point: Point = rng.gen();
    println!("Random tuple: {:?}", rand_tuple);
    println!("Random Point: {:?}", rand_point);
}
```

<!--[`Distribution`]: https://docs.rs/rand/*/rand/distributions/trait.Distribution.html
 [`Standard`]: https://docs.rs/rand/*/rand/distributions/struct.Standard.html
-->
[`Distribution`]: https://docs.rs/rand/*/rand/distributions/trait.Distribution.html
 [`Standard`]: https://docs.rs/rand/*/rand/distributions/struct.Standard.html

