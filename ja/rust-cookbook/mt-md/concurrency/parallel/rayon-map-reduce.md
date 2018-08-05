## <!--Map-reduce in parallel--> マップを並行して減らす

<!--[!][rayon]-->
[！][rayon]
<!--[rayon-badge] [!][cat-concurrency]-->
[rayon-badge] [！][cat-concurrency]
[cat-concurrency-badge]
<!--This example uses [`rayon::filter`], [`rayon::map`], and [`rayon::reduce`] to calculate the average age of `Person` objects whose age is over 30.-->
この例では、[`rayon::filter`]、 [`rayon::map`]、 [`rayon::reduce`]を使って、年齢が30歳を超える`Person`オブジェクトの平均年齢を計算します。

<!--[`rayon::filter`] returns elements from a collection that satisfy the given predicate.-->
[`rayon::filter`]は、与えられた述語を満たす要素をコレクションから返します。
<!--[`rayon::map`] performs an operation on every element, creating a new iteration, and [`rayon::reduce`] performs an operation given the previous reduction and the current element.-->
[`rayon::map`]はすべての要素に対して操作を実行し、新しい反復を作成し、[`rayon::reduce`]は前回の縮小と現在の要素が与えられた操作を実行します。
<!--Also shows use of [`rayon::sum`], which has the same result as the reduce operation in this example.-->
この例のreduce操作と同じ結果を持つ[`rayon::sum`]使用法も示しています。

```rust
extern crate rayon;

use rayon::prelude::*;

struct Person {
    age: u32,
}

fn main() {
    let v: Vec<Person> = vec![
        Person { age: 23 },
        Person { age: 19 },
        Person { age: 42 },
        Person { age: 17 },
        Person { age: 17 },
        Person { age: 31 },
        Person { age: 30 },
    ];

    let num_over_30 = v.par_iter().filter(|&x| x.age > 30).count() as f32;
    let sum_over_30 = v.par_iter()
        .map(|x| x.age)
        .filter(|&x| x > 30)
        .reduce(|| 0, |x, y| x + y);

    let alt_sum_30: u32 = v.par_iter()
        .map(|x| x.age)
        .filter(|&x| x > 30)
        .sum();

    let avg_over_30 = sum_over_30 as f32 / num_over_30;
    let alt_avg_over_30 = alt_sum_30 as f32/ num_over_30;

    assert!((avg_over_30 - alt_avg_over_30).abs() < std::f32::EPSILON);
    println!("The average age of people older than 30 is {}", avg_over_30);
}
```

<!--[`rayon::filter`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.filter
 [`rayon::map`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.map
 [`rayon::reduce`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.reduce
 [`rayon::sum`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.sum
-->
[`rayon::filter`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.filter
 [`rayon::map`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.map
 [`rayon::reduce`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.reduce
 [`rayon::sum`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.sum

