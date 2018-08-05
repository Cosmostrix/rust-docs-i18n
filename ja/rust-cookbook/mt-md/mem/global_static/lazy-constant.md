## <!--Declare lazily evaluated constant--> 遅れて評価される定数を宣言する

<!--[!][lazy_static]-->
[！][lazy_static]
<!--[lazy_static-badge] [!][cat-caching]-->
[lazy_static-badge] [！][cat-caching]
<!--[cat-caching-badge] [!][cat-rust-patterns]-->
[cat-caching-badge] [！][cat-rust-patterns]
[cat-rust-patterns-badge]
<!--Declares a lazily evaluated constant [`HashMap`].-->
遅延評価された定数[`HashMap`]宣言します。
<!--The [`HashMap`] will be evaluated once and stored behind a global static reference.-->
[`HashMap`]は一度評価され、グローバルな静的参照の後ろに格納されます。

```rust
#[macro_use]
extern crate lazy_static;

use std::collections::HashMap;

lazy_static! {
    static ref PRIVILEGES: HashMap<&'static str, Vec<&'static str>> = {
        let mut map = HashMap::new();
        map.insert("James", vec!["user", "admin"]);
        map.insert("Jim", vec!["user"]);
        map
    };
}

fn show_access(name: &str) {
    let access = PRIVILEGES.get(name);
    println!("{}: {:?}", name, access);
}

fn main() {
    let access = PRIVILEGES.get("James");
    println!("James: {:?}", access);

    show_access("Jim");
}
```

[`HashMap`]: https://doc.rust-lang.org/std/collections/struct.HashMap.html
