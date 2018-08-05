# <!--tuples--> タプル

<!--Tuples can be destructured in a `match` as follows:-->
タプルは次のように`match`で破壊することができます：

```rust,editable
fn main() {
    let pair = (0, -2);
#    // TODO ^ Try different values for `pair`
    //  TODO ^ `pair`異なる値を試してください

    println!("Tell me about {:?}", pair);
#    // Match can be used to destructure a tuple
    // マッチを使ってタプルの構造を解く
    match pair {
#        // Destructure the second
        // 第2のものを破壊する
        (0, y) => println!("First is `0` and `y` is `{:?}`", y),
        (x, 0) => println!("`x` is `{:?}` and last is `0`", x),
        _      => println!("It doesn't matter what they are"),
#        // `_` means don't bind the value to a variable
        //  `_`は値を変数にバインドしないことを意味します
    }
}
```

### <!--See also:--> 参照：

[Tuples](primitives/tuples.html)