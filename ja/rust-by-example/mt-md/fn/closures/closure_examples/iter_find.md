# <!--Iterator::find--> Iterator:: find

<!--`Iterator::find` is a function which when passed an iterator, will return the first element which satisfies the predicate as an `Option`.-->
`Iterator::find`は、イテレータを渡すと、述語を満たす最初の要素を`Option`として返す関数です。
<!--Its signature:-->
その署名：

```rust,ignore
pub trait Iterator {
#    // The type being iterated over.
    // オーバーレイされる型。
    type Item;

#    // `find` takes `&mut self` meaning the caller may be borrowed
#    // and modified, but not consumed.
    //  `find` `&mut self`は、呼び出し元が借用され、変更されても消費されないことを意味します。
    fn find<P>(&mut self, predicate: P) -> Option<Self::Item> where
#        // `FnMut` meaning any captured variable may at most be
#        // modified, not consumed. `&Self::Item` states it takes
#        // arguments to the closure by reference.
        //  `FnMut`は、キャプチャされた変数が最大でも変更され、消費されないことを意味します。`&Self::Item`は、参照によってクロージャへの引数をとります。
        P: FnMut(&Self::Item) -> bool {}
}
```

```rust,editable
fn main() {
    let vec1 = vec![1, 2, 3];
    let vec2 = vec![4, 5, 6];

#    // `iter()` for vecs yields `&i32`.
    //  vecの`iter()`は`&i32`生成します。
    let mut iter = vec1.iter();
#    // `into_iter()` for vecs yields `i32`.
    //  `into_iter()`は`i32`生成します。
    let mut into_iter = vec2.into_iter();

#    // A reference to what is yielded is `&&i32`. Destructure to `i32`.
    // 生成されるものへの参照は`&&i32`です。Destruct to `i32`。
    println!("Find 2 in vec1: {:?}", iter     .find(|&&x| x == 2));
#    // A reference to what is yielded is `&i32`. Destructure to `i32`.
    // 生成されるものへの参照は`&i32`です。Destruct to `i32`。
    println!("Find 2 in vec2: {:?}", into_iter.find(| &x| x == 2));

    let array1 = [1, 2, 3];
    let array2 = [4, 5, 6];

#    // `iter()` for arrays yields `&i32`
    // 配列の`iter()`は`&i32`生成する
    println!("Find 2 in array1: {:?}", array1.iter()     .find(|&&x| x == 2));
#    // `into_iter()` for arrays unusually yields `&i32`
    // 配列の`into_iter()`は通常とは`into_iter()`、 `&i32`
    println!("Find 2 in array2: {:?}", array2.into_iter().find(|&&x| x == 2));
}
```

### <!--See also:--> 参照：

[`std::iter::Iterator::find`][find]
[find]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.find
