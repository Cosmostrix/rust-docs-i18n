# <!--Borrowing--> 借りる

<!--Most of the time, we'd like to access data without taking ownership over it.-->
ほとんどの場合、所有権を持たずにデータにアクセスしたいと考えています。
<!--To accomplish this, Rust uses a *borrowing* mechanism.-->
これを達成するために、Rustは*借用*メカニズムを使用します。
<!--Instead of passing objects by value (`T`), objects can be passed by reference (`&T`).-->
オブジェクトを値（`T`）で渡す代わりに、オブジェクトを参照（ `&T`）で渡すことができます。

<!--The compiler statically guarantees (via its borrow checker) that references *always* point to valid objects.-->
コンパイラは、参照が*常に*有効なオブジェクトを指すことを静的に保証します（貸借チェッカーを介して）。
<!--That is, while references to an object exist, the object cannot be destroyed.-->
すなわち、オブジェクトへの参照が存在するが、オブジェクトを破棄することはできない。

```rust,editable,ignore,mdbook-runnable
#// This function takes ownership of a box and destroys it
// この関数は、ボックスの所有権を取得し、それを破壊します。
fn eat_box_i32(boxed_i32: Box<i32>) {
    println!("Destroying box that contains {}", boxed_i32);
}

#// This function borrows an i32
// この関数は、i32を借用します。
fn borrow_i32(borrowed_i32: &i32) {
    println!("This int is: {}", borrowed_i32);
}

fn main() {
#    // Create a boxed i32, and a stacked i32
    // ボックス化されたi32と積み重ねられたi32を作成する
    let boxed_i32 = Box::new(5_i32);
    let stacked_i32 = 6_i32;

#    // Borrow the contents of the box. Ownership is not taken,
#    // so the contents can be borrowed again.
    // 箱の内容を借りてください。所有権が取られないので、内容を再度借りることができます。
    borrow_i32(&boxed_i32);
    borrow_i32(&stacked_i32);

    {
#        // Take a reference to the data contained inside the box
        // 箱の中に入っているデータを参照してください
        let _ref_to_i32: &i32 = &boxed_i32;

#        // Error!
#        // Can't destroy `boxed_i32` while the inner value is borrowed.
        // エラー！内側の値を借りている間に`boxed_i32`を破棄することはできません。
        eat_box_i32(boxed_i32);
#        // FIXME ^ Comment out this line
        //  FIXME ^この行をコメントアウトする

#        // `_ref_to_i32` goes out of scope and is no longer borrowed.
        //  `_ref_to_i32`は範囲外になり、もはや借用されません。
    }

#    // `boxed_i32` can now give up ownership to `eat_box` and be destroyed
    //  `boxed_i32`は`boxed_i32`所有権を`eat_box`して破壊することができるようになりました
    eat_box_i32(boxed_i32);
}
```
