# <!--Guards--> 警備員

<!--A `match` *guard* can be added to filter the arm.-->
`match` *ガード*を追加してアームをフィルタリングすることができます。

```rust,editable
fn main() {
    let pair = (2, -2);
#    // TODO ^ Try different values for `pair`
    //  TODO ^ `pair`異なる値を試してください

    println!("Tell me about {:?}", pair);
    match pair {
        (x, y) if x == y => println!("These are twins"),
#        // The ^ `if condition` part is a guard
        //  ^ `if condition`部分はガードです
        (x, y) if x + y == 0 => println!("Antimatter, kaboom!"),
        (x, _) if x % 2 == 1 => println!("The first one is odd"),
        _ => println!("No correlation..."),
    }
}
```

### <!--See also:--> 参照：

[Tuples](primitives/tuples.html)