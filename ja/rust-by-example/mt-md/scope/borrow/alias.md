# <!--Aliasing--> エイリアス

<!--Data can be immutably borrowed any number of times, but while immutably borrowed, the original data can't be mutably borrowed.-->
データは何度でも不用意に借りることができますが、借り換えは不可能ですが、元のデータを変更することはできません。
<!--On the other hand, only *one* mutable borrow is allowed at a time.-->
他方では、*一度に1つの*変更可能な借用しか許されない。
<!--The original data can be borrowed again only *after* the mutable reference goes out of scope.-->
変更可能な参照が範囲外になった*後*にのみ*、*元のデータを再度借用することができます。

```rust,editable
struct Point { x: i32, y: i32, z: i32 }

fn main() {
    let mut point = Point { x: 0, y: 0, z: 0 };

    {
        let borrowed_point = &point;
        let another_borrow = &point;

#        // Data can be accessed via the references and the original owner
        // 参照と元の所有者を介してデータにアクセスできます
        println!("Point has coordinates: ({}, {}, {})",
                 borrowed_point.x, another_borrow.y, point.z);

#        // Error! Can't borrow point as mutable because it's currently
#        // borrowed as immutable.
        // エラー！現在不変として借用されているため、ポイントを変更可能として借りることはできません。
        //let mutable_borrow = &mut point;
#        // TODO ^ Try uncommenting this line
        //  TODO ^この行のコメントを外してみる

#        // Immutable references go out of scope
        // 変更が不可能な参照は範囲外になります
    }

    {
        let mutable_borrow = &mut point;

#        // Change data via mutable reference
        // 変更可能な参照を介してデータを変更する
        mutable_borrow.x = 5;
        mutable_borrow.y = 2;
        mutable_borrow.z = 1;

#        // Error! Can't borrow `point` as immutable because it's currently
#        // borrowed as mutable.
        // エラー！現在変更可能なものとして借用されているため、`point`を不変として借りることはできません。
        //let y = &point.y;
#        // TODO ^ Try uncommenting this line
        //  TODO ^この行のコメントを外してみる

#        // Error! Can't print because `println!` takes an immutable reference.
        // エラー！ `println!`は不変の参照を取るため、印刷できません。
        //println!("Point Z coordinate is {}", point.z);
#        // TODO ^ Try uncommenting this line
        //  TODO ^この行のコメントを外してみる

#        // Ok! Mutable references can be passed as immutable to `println!`
        //  OK！変更可能な参照は`println!`不変として渡すことができます`println!`
        println!("Point has coordinates: ({}, {}, {})",
                 mutable_borrow.x, mutable_borrow.y, mutable_borrow.z);

#        // Mutable reference goes out of scope
        // 変更可能な参照が範囲外になる
    }

#    // Immutable references to point are allowed again
    // ポイントへの不変参照は再び許可されます
    let borrowed_point = &point;
    println!("Point now has coordinates: ({}, {}, {})",
             borrowed_point.x, borrowed_point.y, borrowed_point.z);
}
```
