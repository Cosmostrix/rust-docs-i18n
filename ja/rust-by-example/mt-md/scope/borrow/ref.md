# <!--The ref pattern--> refパターン

<!--When doing pattern matching or destructuring via the `let` binding, the `ref` keyword can be used to take references to the fields of a struct/tuple.-->
`let`バインディングを介してパターンマッチングや構造解除を行う場合、`ref`キーワードを使用して構造体/タプルのフィールドへの参照を取得できます。
<!--The example below shows a few instances where this can be useful:-->
以下の例は、これが役に立ついくつかの例を示しています。

```rust,editable
#[derive(Clone, Copy)]
struct Point { x: i32, y: i32 }

fn main() {
    let c = 'Q';

#    // A `ref` borrow on the left side of an assignment is equivalent to
#    // an `&` borrow on the right side.
    //  `ref`割り当ての左側にボローはと等価である`&`右側借ります。
    let ref ref_c1 = c;
    let ref_c2 = &c;

    println!("ref_c1 equals ref_c2: {}", *ref_c1 == *ref_c2);

    let point = Point { x: 0, y: 0 };

#    // `ref` is also valid when destructuring a struct.
    //  `ref`はstructを破壊するときにも有効です。
    let _copy_of_x = {
#        // `ref_to_x` is a reference to the `x` field of `point`.
        //  `ref_to_x`は`point`の`x`フィールドへの参照です。
        let Point { x: ref ref_to_x, y: _ } = point;

#        // Return a copy of the `x` field of `point`.
        //  `point`の`x`フィールドのコピーを返します。
        *ref_to_x
    };

#    // A mutable copy of `point`
    // 変更可能な`point`コピー
    let mut mutable_point = point;

    {
#        // `ref` can be paired with `mut` to take mutable references.
        //  `ref`は`mut`と対になって可変参照を取ることができます。
        let Point { x: _, y: ref mut mut_ref_to_y } = mutable_point;

#        // Mutate the `y` field of `mutable_point` via a mutable reference.
        // 変異`y`のフィールド`mutable_point`変更可能な参照を介し。
        *mut_ref_to_y = 1;
    }

    println!("point is ({}, {})", point.x, point.y);
    println!("mutable_point is ({}, {})", mutable_point.x, mutable_point.y);

#    // A mutable tuple that includes a pointer
    // ポインタを含む変更可能なタプル
    let mut mutable_tuple = (Box::new(5u32), 3u32);
    
    {
#        // Destructure `mutable_tuple` to change the value of `last`.
        //  `last`の値を変更するには、`mutable_tuple`を`mutable_tuple`します。
        let (_, ref mut last) = mutable_tuple;
        *last = 2u32;
    }
    
    println!("tuple is {:?}", mutable_tuple);
}
```
