# <!--Mutability--> 変異性

<!--Mutability of data can be changed when ownership is transferred.-->
所有権が移譲されると、データの変更が可能になります。

```rust,editable
fn main() {
    let immutable_box = Box::new(5u32);

    println!("immutable_box contains {}", immutable_box);

#    // Mutability error
    // 変異エラー
    //*immutable_box = 4;

#    // *Move* the box, changing the ownership (and mutability)
    // ボックスを*移動*し、所有権（および変更可能性）を変更します。
    let mut mutable_box = immutable_box;

    println!("mutable_box contains {}", mutable_box);

#    // Modify the contents of the box
    // ボックスの内容を変更する
    *mutable_box = 4;

    println!("mutable_box now contains {}", mutable_box);
}
```
