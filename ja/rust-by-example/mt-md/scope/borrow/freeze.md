# <!--Freezing--> 凍結

<!--When data is immutably borrowed, it also *freezes*.-->
データが不変に借用されると、データも*フリーズし*ます。
<!--*Frozen* data can't be modified via the original object until all references to it go out of scope:-->
*凍結された*データは、元のオブジェクトへのすべての参照が範囲外になるまで、元のオブジェクトから変更することはできません。

```rust,editable,ignore,mdbook-runnable
fn main() {
    let mut _mutable_integer = 7i32;

    {
#        // Borrow `_mutable_integer`
        // 借りる`_mutable_integer`
        let _large_integer = &_mutable_integer;

#        // Error! `_mutable_integer` is frozen in this scope
        // エラー！ `_mutable_integer`はこのスコープ内でフリーズしています
        _mutable_integer = 50;
#        // FIXME ^ Comment out this line
        //  FIXME ^この行をコメントアウトする

#        // `_large_integer` goes out of scope
        //  `_large_integer`が範囲外になる
    }

#    // Ok! `_mutable_integer` is not frozen in this scope
    //  OK！ `_mutable_integer`はこのスコープ内で`_mutable_integer`ていません
    _mutable_integer = 3;
}
```
