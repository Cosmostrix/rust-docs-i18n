# <!--Program arguments--> プログラムの議論

## <!--Standard Library--> 標準ライブラリ

<!--The command line arguments can be accessed using `std::env::args`, which returns an iterator that yields a `String` for each argument:-->
コマンドライン引数は、`std::env::args`を使ってアクセスできます。これは、各引数に`String`を返すイテレータを返します。

```rust,editable
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();

#    // The first argument is the path that was used to call the program.
    // 最初の引数は、プログラムの呼び出しに使用されたパスです。
    println!("My path is {}.", args[0]);

#    // The rest of the arguments are the passed command line parameters.
#    // Call the program like this:
#    //   $ ./args arg1 arg2
    // 残りの引数は渡されたコマンドラインパラメータです。次のようにプログラムを呼び出します：$./args arg1 arg2
    println!("I got {:?} arguments: {:?}.", args.len() - 1, &args[1..]);
}
```

```bash
$ ./args 1 2 3
My path is ./args.
I got 3 arguments: ["1", "2", "3"].
```

## <!--Crates--> クレート

<!--Alternatively, there are numerous crates that can provide extra functionality when creating command-line applications.-->
あるいは、コマンドラインアプリケーションを作成するときに余分な機能を提供できる多数のクレートがあります。
<!--The [Rust Cookbook] exhibits best practices on how to use one of the more popular command line argument crates, `clap`.-->
[Rust Cookbook]より人気のコマンドライン引数の木箱、のいずれかを使用する方法についてのベストプラクティス示す`clap`。

[Rust Cookbook]: https://rust-lang-nursery.github.io/rust-cookbook/cli/arguments.html
