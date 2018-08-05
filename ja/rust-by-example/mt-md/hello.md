# <!--Hello World--> こんにちは世界

<!--This is the source code of the traditional Hello World program.-->
これは、従来のHello Worldプログラムのソースコードです。

```rust,editable
#// This is a comment, and will be ignored by the compiler
#// You can test this code by clicking the "Run" button over there ->
#// or if prefer to use your keyboard, you can use the "Ctrl + Enter" shortcut
// これはコメントであり、コンパイラによって無視されます。"Run"ボタンをクリックしてこのコードをテストすることができます ->またはキーボードを使いたい場合は "Ctrl + Enter"ショートカットを使用できます

#// This code is editable, feel free to hack it!
#// You can always return to the original code by clicking the "Reset" button ->
// このコードは編集可能です。ハックするのは自由です。あなたはいつでも元のコードに戻ることができます "リセット"ボタンをクリックして ->

#// This is the main function
// これが主な機能です
fn main() {
#    // The statements here will be executed when the compiled binary is called
    // ここのステートメントは、コンパイルされたバイナリが呼び出されたときに実行されます

#    // Print text to the console
    // コンソールにテキストを出力する
    println!("Hello World!");
}
```

<!--`println!` is a [*macro*][macros] that prints text to the console.-->
`println!`は、コンソールにテキストを印刷する[*macro*][macros]です。

<!--A binary can be generated using the Rust compiler: `rustc`.-->
バイナリは、Rustコンパイラ： `rustc`を使用して生成できます。

```bash
$ rustc hello.rs
```

<!--`rustc` will produce a `hello` binary that can be executed.-->
`rustc`は実行可能な`hello`バイナリを生成します。

```bash
$ ./hello
Hello World!
```

### <!--Activity--> アクティビティ

<!--Click 'Run' above to see the expected output.-->
上記の「実行」をクリックすると、予想される出力が表示されます。
<!--Next, add a new line with a second `println!` macro so that the output shows:-->
次に、出力が表示されるように、2番目の`println!`マクロを付けた新しい行を追加します。

```text
Hello World!
I'm a Rustacean!
```

[macros]: macros.html
