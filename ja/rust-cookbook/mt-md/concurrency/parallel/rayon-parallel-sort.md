## <!--Sort a vector in parallel--> ベクトルを並行してソートする

<!--[!][rayon]-->
[！][rayon]
<!--[rayon-badge] [!][rand]-->
[rayon-badge] [！][rand]
<!--[rand-badge] [!][cat-concurrency]-->
[rand-badge] [！][cat-concurrency]
[cat-concurrency-badge]
<!--This example will sort in parallel a vector of Strings.-->
この例では、Stringのベクトルを並行してソートします。

<!--Allocate a vector of empty Strings.-->
空のStringのベクトルを割り当てます。
<!--`par_iter_mut().for_each` populates random values in parallel.-->
`par_iter_mut().for_each`ランダムな値を並列に取り込みます。
<!--Although [multiple options] exist to sort an enumerable data type, [`par_sort_unstable`] is usually faster than [stable sorting] algorithms.-->
列挙可能なデータ型をソートするには[multiple options]が[multiple options]が、通常、[`par_sort_unstable`]は[stable sorting]アルゴリズムより高速です。

```rust
extern crate rand;
extern crate rayon;

use rand::{Rng, thread_rng};
use rand::distributions::Alphanumeric;
use rayon::prelude::*;

fn main() {
  let mut vec = vec![String::new(); 100_000];
  vec.par_iter_mut().for_each(|p| {
    let mut rng = thread_rng();
    *p = (0..5).map(|_| rng.sample(&Alphanumeric)).collect()
  });
  vec.par_sort_unstable();
}
```

<!--[`par_sort_unstable`]: https://docs.rs/rayon/*/rayon/slice/trait.ParallelSliceMut.html#method.par_sort_unstable
 [multiple options]: https://docs.rs/rayon/*/rayon/slice/trait.ParallelSliceMut.html
 [stable sorting]: https://docs.rs/rayon/*/rayon/slice/trait.ParallelSliceMut.html#method.par_sort
-->
[`par_sort_unstable`]: https://docs.rs/rayon/*/rayon/slice/trait.ParallelSliceMut.html#method.par_sort_unstable
 [multiple options]: https://docs.rs/rayon/*/rayon/slice/trait.ParallelSliceMut.html
 [stable sorting]: https://docs.rs/rayon/*/rayon/slice/trait.ParallelSliceMut.html#method.par_sort

