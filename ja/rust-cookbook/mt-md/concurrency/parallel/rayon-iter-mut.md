## <!--Mutate the elements of an array in parallel--> 配列の要素を並列に突然変異させる

<!--[!][rayon]-->
[！][rayon]
<!--[rayon-badge] [!][cat-concurrency]-->
[rayon-badge] [！][cat-concurrency]
[cat-concurrency-badge]
<!--The example uses the `rayon` crate, which is a data parallelism library for Rust.-->
この例では、Rustのデータ並列化ライブラリである`rayon`クレートを使用しています。
<!--`rayon` provides the [`par_iter_mut`] method for any parallel iterable data type.-->
`rayon`は、パラレルの反復可能なデータ型に対して[`par_iter_mut`]メソッドを提供します。
<!--This is an iterator-like chain that potentially executes in parallel.-->
これは、並列に実行される可能性のあるイテレータのようなチェーンです。

```rust
extern crate rayon;

use rayon::prelude::*;

fn main() {
    let mut arr = [0, 7, 9, 11];
    arr.par_iter_mut().for_each(|p| *p -= 1);
    println!("{:?}", arr);
}
```

[`par_iter_mut`]: https://docs.rs/rayon/*/rayon/iter/trait.IntoParallelRefMutIterator.html#tymethod.par_iter_mut
