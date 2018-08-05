## <!--Search items using given predicate in parallel--> 与えられた述語を並行して使用して項目を検索する

<!--[!][rayon]-->
[！][rayon]
<!--[rayon-badge] [!][cat-concurrency]-->
[rayon-badge] [！][cat-concurrency]
[cat-concurrency-badge]
<!--This example uses [`rayon::find_any`] and [`par_iter`] to search a vector in parallel for an element satisfying the predicate in the given closure.-->
この例では[`rayon::find_any`]と[`par_iter`]を[`par_iter`]て、与えられたクロージャの述語を満たす要素をパラレルで検索します。

<!--If there are multiple elements satisfying the predicate defined in the closure argument of [`rayon::find_any`], `rayon` returns the first one found, not necessarily the first one.-->
[`rayon::find_any`]クロージャ引数で定義された述語を満たす複数の要素がある場合、`rayon`は最初に見つかったものを返します。必ずしも最初のものではありません。

<!--Also note that the argument to the closure is a reference to a reference (`&&x`).-->
また、クロージャへの引数は参照（`&&x`）への参照であることにも注意してください。
<!--See the discussion on [`std::find`] for additional details.-->
詳細は、[`std::find`]説明を参照してください。

```rust
extern crate rayon;

use rayon::prelude::*;

fn main() {
    let v = vec![6, 2, 1, 9, 3, 8, 11];

    let f1 = v.par_iter().find_any(|&&x| x == 9);
    let f2 = v.par_iter().find_any(|&&x| x % 2 == 0 && x > 6);
    let f3 = v.par_iter().find_any(|&&x| x > 8);

    assert_eq!(f1, Some(&9));
    assert_eq!(f2, Some(&8));
    assert!(f3 > Some(&8));
}
```

<!--[`par_iter`]: https://docs.rs/rayon/*/rayon/iter/trait.IntoParallelRefIterator.html#tymethod.par_iter
 [`rayon::find_any`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.find_any
 [`std::find`]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.find
-->
[`par_iter`]: https://docs.rs/rayon/*/rayon/iter/trait.IntoParallelRefIterator.html#tymethod.par_iter
 [`rayon::find_any`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.find_any
 [`std::find`]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.find
 [`rayon::find_any`]: https://docs.rs/rayon/*/rayon/iter/trait.ParallelIterator.html#method.find_any

