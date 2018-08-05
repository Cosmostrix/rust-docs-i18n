## <!--Generate random numbers with given distribution--> 与えられた分布で乱数を生成する

<!--[!][rand]-->
[！][rand]
<!--[rand-badge] [!][cat-science]-->
[rand-badge] [！][cat-science]
[cat-science-badge]
<!--By default, random numbers have [uniform distribution].-->
デフォルトでは、乱数は[uniform distribution]ます。
<!--To generate numbers with other distributions you instantiate a distribution, then sample from that distribution using [`IndependentSample::ind_sample`] with help of a random-number generator [`rand::Rng`].-->
他のディストリビューションで数値を生成するには、ディストリビューションをインスタンス化し、[`IndependentSample::ind_sample`]を乱数生成器[`rand::Rng`]助けを借りてそのディストリビューションからサンプルします。

<!--The [distributions available are documented here][rand-distributions].-->
[利用可能なディストリビューションはここに記載されています][rand-distributions]。
<!--An example using the [`Normal`] distribution is shown below.-->
[`Normal`]ディストリビューションを使った例を以下に示します。

```rust
extern crate rand;

use rand::distributions::{Normal, Distribution};

fn main() {
  let mut rng = rand::thread_rng();
  let normal = Normal::new(2.0, 3.0);
  let v = normal.sample(&mut rng);
  println!("{} is from a N(2, 9) distribution", v)
}
```

<!--[`Distribution::sample`]: https://docs.rs/rand/*/rand/distributions/trait.Distribution.html#tymethod.sample
 [`Normal`]: https://docs.rs/rand/*/rand/distributions/normal/struct.Normal.html
 [`rand::Rng`]: https://docs.rs/rand/*/rand/trait.Rng.html
 [rand-distributions]: https://docs.rs/rand/*/rand/distributions/index.html
-->
[`Distribution::sample`]: https://docs.rs/rand/*/rand/distributions/trait.Distribution.html#tymethod.sample
 [`Normal`]: https://docs.rs/rand/*/rand/distributions/normal/struct.Normal.html
 [`rand::Rng`]: https://docs.rs/rand/*/rand/trait.Rng.html
 [rand-distributions]: https://docs.rs/rand/*/rand/distributions/index.html


[uniform distribution]: https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)
