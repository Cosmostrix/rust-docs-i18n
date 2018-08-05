# <!--Repeat--> 繰り返す

<!--Macros can use `+` in the argument list to indicate that an argument may repeat at least once, or `*`, to indicate that the argument may repeat zero or more times.-->
マクロは引数リストに`+`を使用して、引数が少なくとも1回繰り返されることを示すことができます。`*`は、引数がゼロ回以上繰り返されることを示します。

<!--In the following example, surrounding the matcher with `$(...),+` will match one or more expression, separated by commas.-->
次の例では、`$(...),+`マッチャーを囲むことは、カンマで区切られた1つ以上の式にマッチします。
<!--Also note that the semicolon is optional on the last case.-->
最後のケースでは、セミコロンは省略可能です。

```rust,editable
#// `min!` will calculate the minimum of any number of arguments.
//  `min!`は任意の数の引数の最小値を計算します。
macro_rules! find_min {
#    // Base case:
    // 規範事例：
    ($x:expr) => ($x);
#    // `$x` followed by at least one `$y,`
    //  `$x`後に少なくとも1つの`$y,`
    ($x:expr, $($y:expr),+) => (
#        // Call `find_min!` on the tail `$y`
        // テール`$y` `find_min!`を呼び出す
        std::cmp::min($x, find_min!($($y),+))
    )
}

fn main() {
    println!("{}", find_min!(1u32));
    println!("{}", find_min!(1u32 + 2 , 2u32));
    println!("{}", find_min!(5u32, 2u32 * 3, 4u32));
}
```
