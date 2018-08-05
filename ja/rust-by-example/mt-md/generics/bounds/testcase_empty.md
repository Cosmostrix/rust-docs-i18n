# <!--Testcase: empty bounds--> テストケース：空の境界

<!--A consequence of how bounds work is that even if a `trait` doesn't include any functionality, you can still use it as a bound.-->
境界がどのように機能するかの結果は、`trait`機能が含まれていなくても、それを境界として使用することができるということです。
<!--`Eq` and `Ord` are examples of such `trait` s from the `std` library.-->
`Eq`と`Ord`は`std`ライブラリのそのような`trait`の例です。

```rust,editable
struct Cardinal;
struct BlueJay;
struct Turkey;

trait Red {}
trait Blue {}

impl Red for Cardinal {}
impl Blue for BlueJay {}

#// These functions are only valid for types which implement these
#// traits. The fact that the traits are empty is irrelevant.
// これらの関数は、これらの特性を実装する型に対してのみ有効です。形質が空であるという事実は無関係です。
fn red<T: Red>(_: &T)   -> &'static str { "red" }
fn blue<T: Blue>(_: &T) -> &'static str { "blue" }

fn main() {
    let cardinal = Cardinal;
    let blue_jay = BlueJay;
    let _turkey   = Turkey;

#    // `red()` won't work on a blue jay nor vice versa
#    // because of the bounds.
    // 境界線のために青いジェイでは`red()`は機能しません。
    println!("A cardinal is {}", red(&cardinal));
    println!("A blue jay is {}", blue(&blue_jay));
    //println!("A turkey is {}", red(&_turkey));
#    // ^ TODO: Try uncommenting this line.
    //  ^ TODO：この行のコメントを外してみてください。
}
```

### <!--See also:--> 参照：

<!--[`std::cmp::Eq`][eq], [`std::cmp::Ord` s][ord], and [`trait` s][traits]-->
[`std::cmp::Eq`][eq]、 [`std::cmp::Ord` s][ord]、および[`trait` s][traits]

<!--[eq]: https://doc.rust-lang.org/std/cmp/trait.Eq.html
 [ord]: https://doc.rust-lang.org/std/cmp/trait.Ord.html
 [traits]: trait.html
-->
[eq]: https://doc.rust-lang.org/std/cmp/trait.Eq.html
 [ord]: https://doc.rust-lang.org/std/cmp/trait.Ord.html
 [traits]: trait.html

