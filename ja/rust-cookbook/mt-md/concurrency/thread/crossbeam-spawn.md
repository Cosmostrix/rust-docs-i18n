## <!--Spawn a short-lived thread--> 短命のスレッドを生成する

<!--[!][crossbeam]-->
[！][crossbeam]
<!--[crossbeam-badge] [!][cat-concurrency]-->
[crossbeam-badge] [！][cat-concurrency]
[cat-concurrency-badge]
<!--The example uses the [crossbeam] crate, which provides data structures and functions for concurrent and parallel programming.-->
この例では、[crossbeam]クレートを使用しています。これは、並行および並列プログラミングのためのデータ構造および機能を提供します。
<!--[`Scope::spawn`] spawns a new scoped thread that is guaranteed to terminate before returning from the closure that passed into [`crossbeam::scope`] function, meaning that you can reference data from the calling function.-->
[`Scope::spawn`]は[`crossbeam::scope`]関数に渡されたクロージャから戻る前に終了することが保証された新しいスコープ付きスレッドを生成します。つまり、呼び出し元関数からデータを参照できます。

<!--This example splits the array in half and performs the work in separate threads.-->
この例では、配列を半分に分割し、別々のスレッドで作業を実行します。

```rust
extern crate crossbeam;

use std::cmp;

fn main() {
    let arr = &[-4, 1, 10, 25];
    let max = find_max(arr, 0, arr.len());
    assert_eq!(25, max);
}

fn find_max(arr: &[i32], start: usize, end: usize) -> i32 {
    const THRESHOLD: usize = 2;
    if end - start <= THRESHOLD {
        return *arr.iter().max().unwrap();
    }

    let mid = start + (end - start) / 2;
    crossbeam::scope(|scope| {
        let left = scope.spawn(|| find_max(arr, start, mid));
        let right = scope.spawn(|| find_max(arr, mid, end));

        cmp::max(left.join(), right.join())
    })
}
```

<!--[`crossbeam::scope`]: https://docs.rs/crossbeam/*/crossbeam/fn.scope.html
 [`Scope::spawn`]: https://docs.rs/crossbeam/*/crossbeam/struct.Scope.html#method.spawn
-->
[`crossbeam::scope`]: https://docs.rs/crossbeam/*/crossbeam/fn.scope.html
 [`Scope::spawn`]: https://docs.rs/crossbeam/*/crossbeam/struct.Scope.html#method.spawn

