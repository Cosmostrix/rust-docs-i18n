# <!--As input parameters--> 入力パラメータとして

<!--While Rust chooses how to capture variables on the fly mostly without type annotation, this ambiguity is not allowed when writing functions.-->
Rustは型の注釈なしで大部分の変数を取り込む方法を選択しますが、関数を書くときはこのあいまいさは許されません。
<!--When taking a closure as an input parameter, the closure's complete type must be annotated using one of a few `traits`.-->
クロージャを入力パラメータとして使用する場合、クロージャの完全型には、いくつかの`traits` 1つを使用して注釈を付ける必要があります。
<!--In order of decreasing restriction, they are:-->
制限が減少する順に、以下のとおりです。

* <!--`Fn`: the closure captures by reference (`&T`)-->
   `Fn`：参照（ `&T`）によるクロージャのキャプチャ
* <!--`FnMut`: the closure captures by mutable reference (`&mut T`)-->
   `FnMut`：可変参照（ `&mut T`）によるクロージャのキャプチャ
* <!--`FnOnce`: the closure captures by value (`T`)-->
   `FnOnce`：値（ `T`）によるクロージャのキャプチャ

<!--On a variable-by-variable basis, the compiler will capture variables in the least restrictive manner possible.-->
変数ごとに、コンパイラは可能な限り最も制限の少ない方法で変数を取り込みます。

<!--For instance, consider a parameter annotated as `FnOnce`.-->
たとえば、`FnOnce`として注釈が付けられたパラメータを考えてみ`FnOnce`。
<!--This specifies that the closure *may* capture by `&T`, `&mut T`, or `T`, but the compiler will ultimately choose based on how the captured variables are used in the closure.-->
これは、クロージャ*が* `&T`、 `&mut T`、または`T`でキャプチャ*できることを*指定しますが、コンパイラは最終的に、キャプチャされた変数がクロージャでどのように使用されるかに基づいて選択します。

<!--This is because if a move is possible, then any type of borrow should also be possible.-->
これは、移動が可能であれば、どんなタイプの借用も可能でなければならないからです。
<!--Note that the reverse is not true.-->
その逆は真ではないことに注意してください。
<!--If the parameter is annotated as `Fn`, then capturing variables by `&mut T` or `T` are not allowed.-->
パラメータに`Fn`と注釈が付けられている場合、`&mut T`または`T` `&mut T`変数を取り込むことはできません。

<!--In the following example, try swapping the usage of `Fn`, `FnMut`, and `FnOnce` to see what happens:-->
次の例では、`Fn`、 `FnMut`、および`FnOnce`使用方法を交換して、何が起こるかを確認してください。

```rust,editable
#// A function which takes a closure as an argument and calls it.
// クロージャを引数として呼び出して呼び出す関数。
fn apply<F>(f: F) where
#    // The closure takes no input and returns nothing.
    // クロージャは入力を受けず、何も返しません。
    F: FnOnce() {
#    // ^ TODO: Try changing this to `Fn` or `FnMut`.
    //  ^ TODO：これを`Fn`または`FnMut`変更してみてください。

    f();
}

#// A function which takes a closure and returns an `i32`.
// クロージャを受け取り、`i32`を返す関数。
fn apply_to_3<F>(f: F) -> i32 where
#    // The closure takes an `i32` and returns an `i32`.
    // 閉鎖は取り`i32`して返す`i32`。
    F: Fn(i32) -> i32 {

    f(3)
}

fn main() {
    use std::mem;

    let greeting = "hello";
#    // A non-copy type.
#    // `to_owned` creates owned data from borrowed one
    // 非コピータイプ。`to_owned`は借りたデータから所有データを作成します。
    let mut farewell = "goodbye".to_owned();

#    // Capture 2 variables: `greeting` by reference and
#    // `farewell` by value.
    //  2つの変数をキャプチャ： `greeting`参照とで`farewell`た値で。
    let diary = || {
#        // `greeting` is by reference: requires `Fn`.
        //  `greeting`は参考になります： `Fn`が必要です。
        println!("I said {}.", greeting);

#        // Mutation forces `farewell` to be captured by
#        // mutable reference. Now requires `FnMut`.
        // 突然変異軍の`farewell`可変参照して撮影します。`FnMut`が必要`FnMut`。
        farewell.push_str("!!!");
        println!("Then I screamed {}.", farewell);
        println!("Now I can sleep. zzzzz");

#        // Manually calling drop forces `farewell` to
#        // be captured by value. Now requires `FnOnce`.
        // 手動でドロップ軍の呼び出し`farewell`値によって捕捉されます。今`FnOnce`が必要`FnOnce`。
        mem::drop(farewell);
    };

#    // Call the function which applies the closure.
    // クロージャを適用する関数を呼び出します。
    apply(diary);

#    // `double` satisfies `apply_to_3`'s trait bound
    //  `double` `apply_to_3`の特性を満たす
    let double = |x| 2 * x;

    println!("3 doubled: {}", apply_to_3(double));
}
```

### <!--See also:--> 参照：

<!--[`std::mem::drop`][drop], [`Fn`][fn], [`FnMut`][fnmut], and [`FnOnce`][fnonce]-->
[`std::mem::drop`][drop]、 [`Fn`][fn]、 [`FnMut`][fnmut]、および[`FnOnce`][fnonce]

<!--[drop]: https://doc.rust-lang.org/std/mem/fn.drop.html
 [fn]: https://doc.rust-lang.org/std/ops/trait.Fn.html
 [fnmut]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
 [fnonce]: https://doc.rust-lang.org/std/ops/trait.FnOnce.html
-->
[drop]: https://doc.rust-lang.org/std/mem/fn.drop.html
 [fn]: https://doc.rust-lang.org/std/ops/trait.Fn.html
 [fnmut]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
 [fnonce]: https://doc.rust-lang.org/std/ops/trait.FnOnce.html

