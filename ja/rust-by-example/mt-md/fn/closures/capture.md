# <!--Capturing--> キャプチャ

<!--Closures are inherently flexible and will do what the functionality requires to make the closure work without annotation.-->
クロージャは、本質的に柔軟性があり、アノテーションなしでクロージャを機能させるために機能が必要とすることを行います。
<!--This allows capturing to flexibly adapt to the use case, sometimes moving and sometimes borrowing.-->
これにより、キャプチャをユースケースに柔軟に適応させることができます。時には移動したり、時には借りることもあります。
<!--Closures can capture variables:-->
クロージャは変数を取り込むことができます：

* <!--by reference: `&T`-->
   参考： `&T`
* <!--by mutable reference: `&mut T`-->
   可変参照： `&mut T`
* <!--by value: `T`-->
   値による： `T`

<!--They preferentially capture variables by reference and only go lower when required.-->
彼らは優先的に参照によって変数を取り込み、必要なときだけ低くなる。

```rust,editable
fn main() {
    use std::mem;
    
    let color = "green";

#    // A closure to print `color` which immediately borrows (`&`)
#    // `color` and stores the borrow and closure in the `print`
#    // variable. It will remain borrowed until `print` goes out of
#    // scope. `println!` only requires `by reference` so it doesn't
#    // impose anything more restrictive.
    // 印刷する閉鎖`color`直ちに（借り`&`） `color`及び店舗で借りて閉鎖`print`変数。それは`print`が範囲外になるまで借用されたままです。`println!`は`by reference`のみ要求`by reference`ので、より制限的なものを課しません。
    let print = || println!("`color`: {}", color);

#    // Call the closure using the borrow.
    // 借り手を使ってクロージャを呼び出します。
    print();
    print();

    let mut count = 0;

#    // A closure to increment `count` could take either `&mut count`
#    // or `count` but `&mut count` is less restrictive so it takes
#    // that. Immediately borrows `count`.
    //  `count`を増やすクロージャは`&mut count`または`count`いずれかをとることができ`count`が、`&mut count`はそれほど制限がありません。すぐに`count`借り`count`。
    //
#    // A `mut` is required on `inc` because a `&mut` is stored inside.
#    // Thus, calling the closure mutates the closure which requires
#    // a `mut`.
    //  `&mut`が内部に格納されているため、`inc`は`mut`が必要です。したがって、closureを呼び出すと、`mut`を必要とするクロージャが変更されます。
    let mut inc = || {
        count += 1;
        println!("`count`: {}", count);
    };

#    // Call the closure.
    // クロージャを呼び出します。
    inc();
    inc();

    //let _reborrow = &mut count;
#    // ^ TODO: try uncommenting this line.
    //  ^ TODO：この行のコメントを外してみてください。
    
#    // A non-copy type.
    // 非コピータイプ。
    let movable = Box::new(3);

#    // `mem::drop` requires `T` so this must take by value. A copy type
#    // would copy into the closure leaving the original untouched.
#    // A non-copy must move and so `movable` immediately moves into
#    // the closure.
    //  `mem::drop`は`T`が必要なので、これは価値が必要です。コピータイプはクロージャーにコピーし、元のままにします。非コピーは移動しなければならず、移動`movable`のですぐにクロージャーに移動します。
    let consume = || {
        println!("`movable`: {:?}", movable);
        mem::drop(movable);
    };

#    // `consume` consumes the variable so this can only be called once.
    //  `consume`は変数を`consume`するので、これは一度だけ呼び出すことができます。
    consume();
    //consume();
#    // ^ TODO: Try uncommenting this line.
    //  ^ TODO：この行のコメントを外してみてください。
}
```

<!--Using `move` before vertical pipes forces closure to take ownership of captured variables:-->
垂直パイプの前に`move`を使用`move`クロージャはキャプチャされた変数の所有権を取得します。

```rust,editable
fn main() {
#    // `Vec` has non-copy semantics.
    //  `Vec`は非コピーセマンティクスを持っています。
    let haystack = vec![1, 2, 3];

    let contains = move |needle| haystack.contains(needle);

    println!("{}", contains(&1));
    println!("{}", contains(&4));

#    // `println!("There're {} elements in vec", haystack.len());`
#    // ^ Uncommenting above line will result in compile-time error
#    // because borrow checker doesn't allow re-using variable after it
#    // has been moved.
    //  ^上記の行をコメント解除すると、ボローチェッカーは移動後に再利用変数を許可しないため、コンパイル時にエラーが発生します。
    
#    // Removing `move` from closure's signature will cause closure
#    // to borrow _haystack_ variable immutably, hence _haystack_ is still
#    // available and uncommenting above line will not cause an error.
    // クロージャの署名からの`move`を削除`move`、クロージャが _haystack_ 変数を不変に借りるため、 _haystack_ は引き続き利用でき、上記のコメントを外してもエラーは発生しません。
}
```

### <!--See also:--> 参照：

<!--[`Box`][box] and [`std::mem::drop`][drop]-->
[`Box`][box]と[`std::mem::drop`][drop]

<!--[box]: std/box.html
 [drop]: https://doc.rust-lang.org/std/mem/fn.drop.html
-->
[box]: std/box.html
 [drop]: https://doc.rust-lang.org/std/mem/fn.drop.html

