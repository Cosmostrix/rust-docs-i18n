# <!--use--> つかいます

<!--The `use` declaration can be used so manual scoping isn't needed:-->
`use`宣言を使用すると、手動スコープが不要になります。

```rust,editable
#// An attribute to hide warnings for unused code.
// 未使用コードの警告を隠す属性。
#![allow(dead_code)]

enum Status {
    Rich,
    Poor,
}

enum Work {
    Civilian,
    Soldier,
}

fn main() {
#    // Explicitly `use` each name so they are available without
#    // manual scoping.
    // それぞれの名前を明示的に`use`、手動スコープなしで利用できるようになります。
    use Status::{Poor, Rich};
#    // Automatically `use` each name inside `Work`.
    //  `Work`内の各名前を自動的に`use`。
    use Work::*;

#    // Equivalent to `Status::Poor`.
    //  `Status::Poor`相当します。
    let status = Poor;
#    // Equivalent to `Work::Civilian`.
    //  `Work::Civilian`同等です。
    let work = Civilian;

    match status {
#        // Note the lack of scoping because of the explicit `use` above.
        // 上記の明示的な`use`ためにスコープがないことに注意してください。
        Rich => println!("The rich have lots of money!"),
        Poor => println!("The poor have no money..."),
    }

    match work {
#        // Note again the lack of scoping.
        // 再びスコープの欠如に注意してください。
        Civilian => println!("Civilians work!"),
        Soldier  => println!("Soldiers fight!"),
    }
}
```

### <!--See also:--> 参照：

<!--[`match`][match] and [`use`][use]-->
[`match`][match]して[`use`][use]

<!--[use]: mod/use.html
 [match]: flow_control/match.html
-->
[match]: flow_control/match.html
 [use]: mod/use.html

