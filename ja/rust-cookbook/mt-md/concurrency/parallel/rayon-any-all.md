## <!--Test in parallel if any or all elements of a collection match a given predicate--> コレクションの任意の要素またはすべての要素が指定された述部に一致するかどうかを並行してテストする

<!--[!][rayon]-->
[！][rayon]
<!--[rayon-badge] [!][cat-concurrency]-->
[rayon-badge] [！][cat-concurrency]
[cat-concurrency-badge]
<!--This example demonstrates using the [`rayon::any`] and [`rayon::all`] methods, which are parallelized counterparts to [`std::any`] and [`std::all`].-->
この例では[`rayon::any`]と[`rayon::all`]メソッドを使用しています。これらのメソッドは[`std::any`]と[`std::all`]並列化されています。
<!--[`rayon::any`] checks in parallel whether any element of the iterator matches the predicate, and returns as soon as one is found.-->
[`rayon::any`]は、イテレータの要素が述語と一致するかどうかを並行してチェックし、見つかったらすぐに戻ります。
<!--[`rayon::all`] checks in parallel whether all elements of the iterator match the predicate, and returns as soon as a non-matching element is found.-->
[`rayon::all`]は、イテレータのすべての要素が述語と一致するかどうかを並列にチェックし、一致しない要素が見つかるとすぐに返します。

```rust
extern crate rayon;

use rayon::prelude::*;

fn main() {
    let mut vec = vec![2, 4, 6, 8];

    assert!(!vec.par_iter().any(|n| (*n % 2) != 0));
    assert!(vec.par_iter().all(|n| (*n % 2) == 0));
    assert!(!vec.par_iter().any(|n| *n > 8 ));
    assert!(vec.par_iter().all(|n| *n <= 8 ));

    vec.push(9);

    assert!(vec.par_iter().any(|n| (*n % 2) != 0));
    assert!(!vec.par_iter().all(|n| (*n % 2) == 0));
    assert!(vec.par_iter().any(|n| *n > 8 ));
    assert!(!vec.par_iter().all(|n| *n <= 8 )); 
}
```

<!--[`rayon::all`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.all
 [`rayon::any`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.any
 [`std::all`]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.all
 [`std::any`]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.any
-->
[`rayon::all`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.all
 [`rayon::any`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.any
 [`std::all`]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.all
 [`std::any`]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.any

