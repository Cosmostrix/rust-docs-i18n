## <!--Create random passwords from a set of alphanumeric characters--> 英数字のセットからランダムなパスワードを作成する

<!--[!][rand]-->
[！][rand]
<!--[rand-badge] [!][cat-os]-->
[rand-badge] [！][cat-os]
[cat-os-badge]
<!--Randomly generates a string of given length ASCII characters in the range `AZ, az, 0-9`, with [`Alphanumeric`] sample.-->
[`Alphanumeric`] `AZ, az, 0-9`範囲にある任意の長さのASCII文字列を[`Alphanumeric`]サンプルで無作為に生成します。

```rust
extern crate rand;

use rand::{thread_rng, Rng};
use rand::distributions::Alphanumeric;

fn main() {
    let rand_string: String = thread_rng()
        .sample_iter(&Alphanumeric)
        .take(30)
        .collect();

    println!("{}", rand_string);
}
```

[`Alphanumeric`]: https://docs.rs/rand/*/rand/distributions/struct.Alphanumeric.html
