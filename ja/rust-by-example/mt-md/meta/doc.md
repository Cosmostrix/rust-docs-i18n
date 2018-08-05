# <!--Documentation--> ドキュメンテーション

<!--Doc comments are very useful for big projects that require documentation.-->
ドキュメントのコメントは、ドキュメントを必要とする大きなプロジェクトで非常に役立ちます。
<!--When running [Rustdoc][1], these are the comments that get compiled into documentation.-->
[Rustdoc][1]実行している[Rustdoc][1]、これらのコメントがドキュメントにコンパイルされます。
<!--They are denoted by a `///`, and support [Markdown][2].-->
それらは`///`で示され、[Markdown][2]をサポートします。

```rust,editable,ignore,mdbook-runnable
#![crate_name = "doc"]

#///// A human being is represented here
/// ここに人間が表現されている
pub struct Person {
#//    /// A person must have a name, no matter how much Juliet may hate it
    /// ジュリエットがそれをどれだけ憎むことができるかに関わらず、誰かが名前を持たなければならない
    name: String,
}

impl Person {
#//    /// Returns a person with the name given them
    /// 与えられた名前の人を返す
    ///
#//    /// # Arguments
    ///  ＃引数
    ///
#//    /// * `name` - A string slice that holds the name of the person
    ///  * `name` -人の名前を保持する文字列スライス
    ///
#//    /// # Example
    ///  ＃例
    ///
#//    /// ```
    ///  `` ``
#//    /// // You can have rust code between fences inside the comments
    ///  //コメントの内側にフェンスの間に錆のコードを入れることができます
#//    /// // If you pass --test to Rustdoc, it will even test it for you!
    ///  // --testをRustdocに渡すと、それはあなたのためにテストされます！
#//    /// use doc::Person;
    ///  doc:: Personを使用します。
#//    /// let person = Person::new("name");
    ///  let person = Person:: new（"name"）;
#//    /// ```
    ///  `` ``
    pub fn new(name: &str) -> Person {
        Person {
            name: name.to_string(),
        }
    }

#//    /// Gives a friendly hello!
    /// フレンドリーなこんにちは！
    ///
#//    /// Says "Hello, [name]" to the `Person` it is called on.
    /// それが呼び出された`Person`に「こんにちは、[name] 」と言っています。
    pub fn hello(& self) {
        println!("Hello, {}!", self.name);
    }
}

fn main() {
    let john = Person::new("John");

    john.hello();
}
```

<!--To run the tests, first build the code as a library, then tell rustdoc where to find the library so it can link it into each doctest program:-->
テストを実行するには、まずコードをライブラリとしてビルドし、次にrustdocにライブラリを見つける場所を教えて、それを各doctestプログラムにリンクできるようにします：

```bash
$ rustc doc.rs --crate-type lib
$ rustdoc --test --extern doc="libdoc.rlib" doc.rs
```

<!--(When you run `cargo test` on a library crate, Cargo will automatically generate and run the correct rustc and rustdoc commands.)-->
（ライブラリクレートでカーゴ`cargo test`を実行すると、Cargoは自動的に正しいrustcコマンドとrustdocコマンドを生成して実行します）。

<!--[1]: https://doc.rust-lang.org/book/documentation.html
 [2]: https://en.wikipedia.org/wiki/Markdown
-->
[1]: https://doc.rust-lang.org/book/documentation.html
 [2]: https://en.wikipedia.org/wiki/Markdown

