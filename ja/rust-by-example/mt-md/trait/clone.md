# <!--Clone--> クローン

<!--When dealing with resources, the default behavior is to transfer them during assignments or function calls.-->
リソースを扱うとき、デフォルトの振る舞いは、代入や関数呼び出し中にそれらを転送することです。
<!--However, sometimes we need to make a copy of the resource as well.-->
しかし、時にはリソースのコピーも作成する必要があります。

<!--The [`Clone`][clone] trait helps us do exactly this.-->
[`Clone`][clone]形質は、これを正確に行うのに役立ちます。
<!--Most commonly, we can use the `.clone()` method defined by the `Clone` trait.-->
最も一般的には、`Clone`特性によって定義された`.clone()`メソッドを使用できます。

```rust,editable
#// A unit struct without resources
// リソースのないユニット構造体
#[derive(Debug, Clone, Copy)]
struct Nil;

#// A tuple struct with resources that implements the `Clone` trait
//  `Clone`特性を実装するリソースを持つタプル構造体
#[derive(Clone, Debug)]
struct Pair(Box<i32>, Box<i32>);

fn main() {
#    // Instantiate `Nil`
    //  `Nil`インスタンス化する
    let nil = Nil;
#    // Copy `Nil`, there are no resources to move
    // コピー`Nil`、移動する一切のリソースはありません
    let copied_nil = nil;

#    // Both `Nil`s can be used independently
    // 両方`Nil` Sは、独立して使用することができます
    println!("original: {:?}", nil);
    println!("copy: {:?}", copied_nil);

#    // Instantiate `Pair`
    //  `Pair`インスタンス化する
    let pair = Pair(Box::new(1), Box::new(2));
    println!("original: {:?}", pair);

#    // Copy `pair` into `moved_pair`, moves resources
    //  `pair`を`moved_pair`にコピーし、リソースを移動する
    let moved_pair = pair;
    println!("copy: {:?}", moved_pair);

#    // Error! `pair` has lost its resources
    // エラー！ `pair`がリソースを失った
    //println!("original: {:?}", pair);
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる
    
#    // Clone `moved_pair` into `cloned_pair` (resources are included)
    //  `moved_pair`を`cloned_pair`クローンし`cloned_pair`（リソースは含まれています）。
    let cloned_pair = moved_pair.clone();
#    // Drop the original pair using std::mem::drop
    //  std:: mem:: dropを使って元のペアを削除する
    drop(moved_pair);

#    // Error! `moved_pair` has been dropped
    // エラー！ `moved_pair`が削除されました
    //println!("copy: {:?}", moved_pair);
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる

#    // The result from .clone() can still be used!
    // .clone（）の結果は引き続き使用できます！
    println!("clone: {:?}", cloned_pair);
}
```

[clone]: https://doc.rust-lang.org/std/clone/trait.Clone.html
