# <!--Multiple bounds--> 複数の境界

<!--Multiple bounds can be applied with a `+`.-->
複数の境界は`+`で適用できます。
<!--Like normal, different types are separated with `,`.-->
通常と同じように、さまざまな種類がで区切られ`,`。

```rust,editable
use std::fmt::{Debug, Display};

fn compare_prints<T: Debug + Display>(t: &T) {
    println!("Debug: `{:?}`", t);
    println!("Display: `{}`", t);
}

fn compare_types<T: Debug, U: Debug>(t: &T, u: &U) {
    println!("t: `{:?}", t);
    println!("u: `{:?}", u);
}

fn main() {
    let string = "words";
    let array = [1, 2, 3];
    let vec = vec![1, 2, 3];

    compare_prints(&string);
    //compare_prints(&array);
#    // TODO ^ Try uncommenting this.
    //  TODO ^これをコメント解除してみてください。

    compare_types(&array, &vec);
}
```

### <!--See also:--> 参照：

<!--[`std::fmt`][fmt] and [`trait` s][traits]-->
[`std::fmt`][fmt]と[`trait` s][traits]

<!--[fmt]: hello/print.html
 [traits]: trait.html
-->
[fmt]: hello/print.html
 [traits]: trait.html

