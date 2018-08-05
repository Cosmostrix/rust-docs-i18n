# `extern crate`
<!--To link a crate to this new library, the `extern crate` declaration must be used.-->
クレートをこの新しいライブラリにリンクするには、`extern crate`宣言を使用する必要があります。
<!--This will not only link the library, but also import all its items under a module named the same as the library.-->
これはライブラリをリンクするだけでなく、ライブラリと同じ名前のモジュールの下にあるすべてのアイテムをインポートします。
<!--The visibility rules that apply to modules also apply to libraries.-->
モジュールに適用される表示ルールは、ライブラリにも適用されます。

```rust,ignore
#// Link to `library`, import items under the `rary` module
//  `library`にリンクし、`rary`モジュールの下にあるアイテムをインポートする
extern crate rary;

fn main() {
    rary::public_function();

#    // Error! `private_function` is private
    // エラー！ `private_function`はプライベートです
    //rary::private_function();

    rary::indirect_access();
}
```

```bash
# Where library.rlib is the path to the compiled library, assumed that it's
# in the same directory here:
$ rustc executable.rs --extern rary=library.rlib && ./executable
called rary's `public_function()`
called rary's `indirect_access()`, that
> called rary's `private_function()`
```
