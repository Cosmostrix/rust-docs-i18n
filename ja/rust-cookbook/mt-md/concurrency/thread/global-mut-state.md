## <!--Maintain global mutable state--> グローバル可変状態を維持する

<!--[!][lazy_static]-->
[！][lazy_static]
<!--[lazy_static-badge] [!][cat-rust-patterns]-->
[lazy_static-badge] [！][cat-rust-patterns]
[cat-rust-patterns-badge]
<!--Declare global state using [lazy_static].-->
[lazy_static]を使用してグローバル状態を宣言し[lazy_static]。
<!--[lazy_static] creates a globally available `static ref` which requires a [`Mutex`] to allow mutation (also see [`RwLock`]).-->
[lazy_static]は、[`Mutex`]を許可するために[`Mutex`]を必要とするグローバルに利用可能`static ref`を作成します（[`RwLock`]も参照してください）。
<!--The [`Mutex`] wrap ensures the state cannot be simultaneously accessed by multiple threads, preventing race conditions.-->
[`Mutex`]ラップは、状態が複数のスレッドによって同時にアクセスされることを防ぎ、競合状態を防ぎます。
<!--A [`MutexGuard`] must be acquired to read or mutate the value stored in a [`Mutex`].-->
[`MutexGuard`]は、[`Mutex`]格納された値を読み込んだり[`MutexGuard`]必要があります。

```rust
# #[macro_use]
# extern crate error_chain;
#[macro_use]
extern crate lazy_static;

use std::sync::Mutex;
#
# error_chain!{ }

lazy_static! {
    static ref FRUIT: Mutex<Vec<String>> = Mutex::new(Vec::new());
}

fn insert(fruit: &str) -> Result<()> {
    let mut db = FRUIT.lock().map_err(|_| "Failed to acquire MutexGuard")?;
    db.push(fruit.to_string());
    Ok(())
}

fn run() -> Result<()> {
    insert("apple")?;
    insert("orange")?;
    insert("peach")?;
    {
        let db = FRUIT.lock().map_err(|_| "Failed to acquire MutexGuard")?;

        db.iter().enumerate().for_each(|(i, item)| println!("{}: {}", i, item));
    }
    insert("grape")?;
    Ok(())
}
#
# quick_main!(run);
```

<!--[`Mutex`]: https://doc.rust-lang.org/std/sync/struct.Mutex.html
 [`MutexGuard`]: https://doc.rust-lang.org/std/sync/struct.MutexGuard.html
 [`RwLock`]: https://doc.rust-lang.org/std/sync/struct.RwLock.html
-->
[`Mutex`]: https://doc.rust-lang.org/std/sync/struct.Mutex.html
 [`MutexGuard`]: https://doc.rust-lang.org/std/sync/struct.MutexGuard.html
 [`RwLock`]: https://doc.rust-lang.org/std/sync/struct.RwLock.html

