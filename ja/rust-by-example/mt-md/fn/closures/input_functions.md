# <!--Input functions--> 入力機能

<!--Since closures may be used as arguments, you might wonder if the same can be said about functions.-->
クロージャは引数として使用できるので、関数についても同じことが言えるのだろうかと疑問に思うかもしれません。
<!--And indeed they can!-->
そして確かに彼らはすることができます！
<!--If you declare a function that takes a closure as parameter, then any function that satisfies the trait bound of that closure can be passed as a parameter.-->
クロージャをパラメータとして受け取る関数を宣言すると、そのクロージャの特性境界を満たす任意の関数をパラメータとして渡すことができます。

```rust,editable
#// Define a function which takes a generic `F` argument
#// bounded by `Fn`, and calls it
//  `Fn`で囲まれた汎用の`F`引数をとり、それを呼び出す関数を定義する
fn call_me<F: Fn()>(f: F) {
    f();
}

#// Define a wrapper function satisfying the `Fn` bound
//  `Fn` boundを満たすラッパー関数を定義する
fn function() {
    println!("I'm a function!");
}

fn main() {
#    // Define a closure satisfying the `Fn` bound
    //  `Fn` boundを満たすクロージャを定義する
    let closure = || println!("I'm a closure!");

    call_me(closure);
    call_me(function);
}
```

<!--As an additional note, the `Fn`, `FnMut`, and `FnOnce` `traits` dictate how a closure captures variables from the enclosing scope.-->
さらに注意すべき点として、`Fn`、 `FnMut`、および`FnOnce` `traits`、クロージャが囲みスコープから変数を取り込む方法を決定します。

### <!--See also:--> 参照：

<!--[`Fn`][fn], [`FnMut`][fn_mut], and [`FnOnce`][fn_once]-->
[`Fn`][fn]、 [`FnMut`][fn_mut]、および[`FnOnce`][fn_once]

<!--[fn]: https://doc.rust-lang.org/std/ops/trait.Fn.html
 [fn_mut]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
 [fn_once]: https://doc.rust-lang.org/std/ops/trait.FnOnce.html
-->
[fn]: https://doc.rust-lang.org/std/ops/trait.Fn.html
 [fn_mut]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
 [fn_once]: https://doc.rust-lang.org/std/ops/trait.FnOnce.html

