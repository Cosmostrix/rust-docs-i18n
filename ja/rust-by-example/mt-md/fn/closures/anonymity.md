# <!--Type anonymity--> タイプ匿名性

<!--Closures succinctly capture variables from enclosing scopes.-->
クローズは、囲みスコープから変数を簡単に取得します。
<!--Does this have any consequences?-->
これには何らかの影響がありますか？
<!--It surely does.-->
確かにそうです。
<!--Observe how using a closure as a function parameter requires [generics], which is necessary because of how they are defined:-->
クロージャを関数パラメータとして使用するには[generics]が必要であることに注意してください。これは[generics]定義のために必要です。

```rust
#// `F` must be generic.
//  `F`は汎用でなければなりません。
fn apply<F>(f: F) where
    F: FnOnce() {
    f();
}
```

<!--When a closure is defined, the compiler implicitly creates a new anonymous structure to store the captured variables inside, meanwhile implementing the functionality via one of the `traits`: `Fn`, `FnMut`, or `FnOnce` for this unknown type.-->
クロージャが定義されると、コンパイラは暗黙のうちにキャプチャされた変数を格納するための新しい匿名構造を作成し、この未知の型の`Fn`、 `FnMut`、または`FnOnce`いずれかの`traits`を使用して機能を実装します。
<!--This type is assigned to the variable which is stored until calling.-->
この型は、呼び出すまで格納されている変数に割り当てられます。

<!--Since this new type is of unknown type, any usage in a function will require generics.-->
この新しい型は型が不明なので、関数内での使用にはジェネリックが必要です。
<!--However, an unbounded type parameter `<T>` would still be ambiguous and not be allowed.-->
ただし、無制限の型パラメータ`<T>`はあいまいであり、許可されません。
<!--Thus, bounding by one of the `traits`: `Fn`, `FnMut`, or `FnOnce` (which it implements) is sufficient to specify its type.-->
したがって、`Fn`、 `FnMut`、または`FnOnce`（これは実装されています）のいずれかの`traits`によって境界を定めて、その型を指定するのに十分です。

```rust,editable
#// `F` must implement `Fn` for a closure which takes no
#// inputs and returns nothing - exactly what is required
#// for `print`.
//  `F`は、入力を必要とせず、何も返さないクロージャーのために`Fn`を実装する必要があり`print`。
fn apply<F>(f: F) where
    F: Fn() {
    f();
}

fn main() {
    let x = 7;

#    // Capture `x` into an anonymous type and implement
#    // `Fn` for it. Store it in `print`.
    //  `x`を匿名型にキャプチャし、`Fn`を実装し`Fn`。それを`print`。
    let print = || println!("{}", x);

    apply(print);
}
```

### <!--See also:--> 参照：

<!--[A thorough analysis][thorough_analysis], [`Fn`][fn], [`FnMut`][fn_mut], and [`FnOnce`][fn_once]-->
[徹底的な分析][thorough_analysis]、 [`Fn`][fn]、 [`FnMut`][fn_mut]、および[`FnOnce`][fn_once]

<!--[generics]: generics.html
 [fn]: https://doc.rust-lang.org/std/ops/trait.Fn.html
 [fn_mut]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
 [fn_once]: https://doc.rust-lang.org/std/ops/trait.FnOnce.html
 [thorough_analysis]: https://huonw.github.io/blog/2015/05/finding-closure-in-rust/
-->
[generics]: generics.html
 [fn]: https://doc.rust-lang.org/std/ops/trait.Fn.html
 [fn_mut]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
 [fn_once]: https://doc.rust-lang.org/std/ops/trait.FnOnce.html
 [thorough_analysis]: https://huonw.github.io/blog/2015/05/finding-closure-in-rust/

