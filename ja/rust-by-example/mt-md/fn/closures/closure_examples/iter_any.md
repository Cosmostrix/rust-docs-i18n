# <!--Iterator::any--> イテレータ::任意

<!--`Iterator::any` is a function which when passed an iterator, will return `true` if any element satisfies the predicate.-->
`Iterator::any`は、イテレータを渡すと、いずれかの要素が述語を満たす場合に`true`を返す関数です。
<!--Otherwise `false`.-->
それ以外の場合は`false`。
<!--Its signature:-->
その署名：

```rust,ignore
pub trait Iterator {
#    // The type being iterated over.
    // オーバーレイされる型。
    type Item;

#    // `any` takes `&mut self` meaning the caller may be borrowed
#    // and modified, but not consumed.
    //  `any`テイク`&mut self`は、呼び出し元を借りて変更することができますが、消費しないことを意味します。
    fn any<F>(&mut self, f: F) -> bool where
#        // `FnMut` meaning any captured variable may at most be
#        // modified, not consumed. `Self::Item` states it takes
#        // arguments to the closure by value.
        //  `FnMut`は、キャプチャされた変数が最大でも変更され、消費されないことを意味します。`Self::Item`は、値によってクロージャへの引数をとります。
        F: FnMut(Self::Item) -> bool {}
}
```

```rust,editable
fn main() {
    let vec1 = vec![1, 2, 3];
    let vec2 = vec![4, 5, 6];

#    // `iter()` for vecs yields `&i32`. Destructure to `i32`.
    //  vecの`iter()`は`&i32`生成します。Destruct to `i32`。
    println!("2 in vec1: {}", vec1.iter()     .any(|&x| x == 2));
#    // `into_iter()` for vecs yields `i32`. No destructuring required.
    //  `into_iter()`は`i32`生成します。破壊は必要ありません。
    println!("2 in vec2: {}", vec2.into_iter().any(| x| x == 2));

    let array1 = [1, 2, 3];
    let array2 = [4, 5, 6];

#    // `iter()` for arrays yields `&i32`.
    // 配列の`iter()`は`&i32`生成します。
    println!("2 in array1: {}", array1.iter()     .any(|&x| x == 2));
#    // `into_iter()` for arrays unusually yields `&i32`.
    // 配列の`into_iter()`は`&i32`異常に生成します。
    println!("2 in array2: {}", array2.into_iter().any(|&x| x == 2));
}
```

### <!--See also:--> 参照：

[`std::iter::Iterator::any`][any]
[any]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.any
