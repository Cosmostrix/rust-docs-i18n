# <!--As output parameters--> 出力パラメータとして

<!--Closures as input parameters are possible, so returning closures as output parameters should also be possible.-->
入力パラメータとしてのクロージャが可能であるため、出力パラメータとしてクロージャを返すことも可能です。
<!--However, returning closure types are problematic because Rust currently only supports returning concrete (non-generic) types.-->
しかし、Rustは現在、コンクリート（非ジェネリック）型を返すだけをサポートしているため、クロージャの型を戻すことは問題があります。
<!--Anonymous closure types are, by definition, unknown and so returning a closure is only possible by making it concrete.-->
匿名のクロージャータイプは、定義上、未知であるため、クロージャーを返すことは、それを具体的にすることによってのみ可能です。
<!--This can be done via boxing.-->
これはボクシングを介して行うことができます。

<!--The valid traits for returns are slightly different than before:-->
返品の有効な特性は、以前とは若干異なります。

* <!--`Fn`: normal-->
   `Fn`：正常
* <!--`FnMut`: normal-->
   `FnMut`：正常
* <!--`FnOnce`: There are some unusual things at play here, so the [`FnBox`][fnbox] type is currently needed, and is unstable.-->
   `FnOnce`：ここでは珍しいことがいくつかありますので、現在[`FnBox`][fnbox]タイプが必要で不安定です。
<!--This is expected to change in the future.-->
   これは将来変更される予定です。

<!--Beyond this, the `move` keyword must be used, which signals that all captures occur by value.-->
これを超えると、すべてのキャプチャが値によって発生することを示す`move`キーワードを使用する必要があります。
<!--This is required because any captures by reference would be dropped as soon as the function exited, leaving invalid references in the closure.-->
ファンクションが終了するとすぐに参照によるキャプチャが削除され、クロージャに無効な参照が残されるため、これが必要です。

```rust,editable
fn create_fn() -> Box<Fn()> {
    let text = "Fn".to_owned();

    Box::new(move || println!("This is a: {}", text))
}

fn create_fnmut() -> Box<FnMut()> {
    let text = "FnMut".to_owned();

    Box::new(move || println!("This is a: {}", text))
}

fn main() {
    let fn_plain = create_fn();
    let mut fn_mut = create_fnmut();

    fn_plain();
    fn_mut();
}
```

### <!--See also:--> 参照：

<!--[Boxing][box], [`Fn`][fn], [`FnMut`][fnmut], and [Generics][generics].-->
[Boxing][box]、 [`Fn`][fn]、 [`FnMut`][fnmut]、 [Generics][generics]。

<!--[box]: std/box.html
 [fn]: https://doc.rust-lang.org/std/ops/trait.Fn.html
 [fnmut]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
 [fnbox]: https://doc.rust-lang.org/std/boxed/trait.FnBox.html%20
 [generics]: generics.html
-->
[box]: std/box.html
 [fn]: https://doc.rust-lang.org/std/ops/trait.Fn.html
 [fnmut]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
 [fnbox]: https://doc.rust-lang.org/std/boxed/trait.FnBox.html%20
 [generics]: generics.html

