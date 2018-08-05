## <!--Create random passwords from a set of user-defined characters--> 一連のユーザー定義文字からランダムなパスワードを作成する

<!--[!][rand]-->
[！][rand]
<!--[rand-badge] [!][cat-os]-->
[rand-badge] [！][cat-os]
[cat-os-badge]
<!--Randomly generates a string of given length ASCII characters with custom user-defined bytestring, with [`choose`].-->
[`choose`]使って、カスタムのユーザ定義のバイトコードで任意の長さのASCII文字列をランダムに生成します。

```rust
extern crate rand;

use rand::{thread_rng, Rng};

fn main() {
    const CHARSET: &[u8] =  b"ABCDEFGHIJKLMNOPQRSTUVWXYZ\
    abcdefghijklmnopqrstuvwxyz\
    0123456789)(*&^%$#@!~";

    let mut rng = thread_rng();
    let password: Option<String> = (0..30)
        .map(|_| Some(*rng.choose(CHARSET)? as char))
        .collect();

    println!("{:?}", password);
}
```

[`choose`]: https://docs.rs/rand/*/rand/trait.Rng.html#method.choose
