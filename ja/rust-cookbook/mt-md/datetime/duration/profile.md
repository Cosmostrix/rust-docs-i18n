## <!--Measure the elapsed time between two code sections--> 2つのコードセクション間の経過時間を測定する

<!--[!][std]-->
[！][std]
<!--[std-badge] [!][cat-time]-->
[std-badge] [！][cat-time]
[cat-time-badge]
<!--Measures [`time::Instant::elapsed`] since [`time::Instant::now`].-->
[`time::Instant::elapsed`]から[`time::Instant::now`]ます。

<!--Calling [`time::Instant::elapsed`] returns a [`time::Duration`] that we print at the end of the example.-->
[`time::Instant::elapsed`]呼び出すと、例の最後に[`time::Instant::elapsed`]れる[`time::Duration`]が返されます。
<!--This method will not mutate or reset the [`time::Instant`] object.-->
このメソッドは、[`time::Instant`]オブジェクトを変更またはリセットしません。

```rust
use std::time::{Duration, Instant};
# use std::thread;
#
# fn expensive_function() {
#     thread::sleep(Duration::from_secs(1));
# }

fn main() {
    let start = Instant::now();
    expensive_function();
    let duration = start.elapsed();

    println!("Time elapsed in expensive_function() is: {:?}", duration);
}
```

<!--[`time::Duration`]: https://doc.rust-lang.org/std/time/struct.Duration.html
 [`time::Instant::elapsed`]: https://doc.rust-lang.org/std/time/struct.Instant.html#method.elapsed
 [`time::Instant::now`]: https://doc.rust-lang.org/std/time/struct.Instant.html#method.now
-->
[`time::Duration`]: https://doc.rust-lang.org/std/time/struct.Duration.html
 [`time::Instant::elapsed`]: https://doc.rust-lang.org/std/time/struct.Instant.html#method.elapsed
 [`time::Instant::now`]: https://doc.rust-lang.org/std/time/struct.Instant.html#method.now

<!--[`time::Instant`]:https://doc.rust-lang.org/std/time/struct.Instant.html-->
[`time::Instant`]：https：//doc.rust-lang.org/std/time/struct.Instant.html
