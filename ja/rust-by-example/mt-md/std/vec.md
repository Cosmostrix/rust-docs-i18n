# <!--Vectors--> ベクトル

<!--Vectors are re-sizable arrays.-->
ベクトルはサイズ変更可能な配列です。
<!--Like slices, their size is not known at compile time, but they can grow or shrink at any time.-->
スライスのように、そのサイズはコンパイル時にはわかりませんが、いつでも拡大または縮小することができます。
<!--A vector is represented using 3 words: a pointer to the data, its length, and its capacity.-->
ベクトルは、データへのポインタ、その長さ、およびその容量の3つのワードを使用して表されます。
<!--The capacity indicates how much memory is reserved for the vector.-->
容量は、ベクトルにどれだけのメモリが予約されているかを示します。
<!--The vector can grow as long as the length is smaller than the capacity.-->
ベクトルは、長さが容量よりも小さい限り長くなります。
<!--When this threshold needs to be surpassed, the vector is reallocated with a larger capacity.-->
このしきい値を超える必要がある場合、ベクトルはより大きな容量で再割り当てされます。

```rust,editable,ignore,mdbook-runnable
fn main() {
#    // Iterators can be collected into vectors
    // イテレータはベクトルに集めることができます
    let collected_iterator: Vec<i32> = (0..10).collect();
    println!("Collected (0..10) into: {:?}", collected_iterator);

#    // The `vec!` macro can be used to initialize a vector
    //  `vec!`マクロを使用してベクトルを初期化することができます
    let mut xs = vec![1i32, 2, 3];
    println!("Initial vector: {:?}", xs);

#    // Insert new element at the end of the vector
    // ベクトルの最後に新しい要素を挿入する
    println!("Push 4 into the vector");
    xs.push(4);
    println!("Vector: {:?}", xs);

#    // Error! Immutable vectors can't grow
    // エラー！不変なベクターは成長できません
    collected_iterator.push(0);
#    // FIXME ^ Comment out this line
    //  FIXME ^この行をコメントアウトする

#    // The `len` method yields the current size of the vector
    //  `len`メソッドは、ベクトルの現在のサイズを返します
    println!("Vector size: {}", xs.len());

#    // Indexing is done using the square brackets (indexing starts at 0)
    // 索引付けは大括弧で行います（索引付けは0から始まります）
    println!("Second element: {}", xs[1]);

#    // `pop` removes the last element from the vector and returns it
    //  `pop`は最後の要素をベクトルから削除して返します
    println!("Pop last element: {:?}", xs.pop());

#    // Out of bounds indexing yields a panic
    // 範囲外のインデックス作成によりパニックが発生する
    println!("Fourth element: {}", xs[3]);
#    // FIXME ^ Comment out this line
    //  FIXME ^この行をコメントアウトする

#    // `Vector`s can be easily iterated over
    //  `Vector`は簡単に繰り返すことができます
    println!("Contents of xs:");
    for x in xs.iter() {
        println!("> {}", x);
    }

#    // A `Vector` can also be iterated over while the iteration
#    // count is enumerated in a separate variable (`i`)
    // 反復回数が別の変数に列挙されている間に、`Vector`を反復することもできます（`i`）
    for (i, x) in xs.iter().enumerate() {
        println!("In position {} we have value {}", i, x);
    }

#    // Thanks to `iter_mut`, mutable `Vector`s can also be iterated
#    // over in a way that allows modifying each value
    //  `iter_mut`おかげで、変更可能な`Vector`各値を変更できるように反復処理することもできます
    for x in xs.iter_mut() {
        *x *= 3;
    }
    println!("Updated vector: {:?}", xs);
}
```

<!--More `Vec` methods can be found under the [std::vec][vec] module-->
より多くの`Vec`メソッドは[std::vec][vec]モジュールの下にあります

[vec]: https://doc.rust-lang.org/std/vec/
