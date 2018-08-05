# <!--Comments--> コメント

<!--Any program requires comments and indeed Rust supports a few different varieties:-->
どんなプログラムでもコメントが必要です.Rustはいくつかの異なる種類をサポートしています。

* <!--*Regular comments* which are ignored by the compiler:-->
   コンパイラによって無視される*通常のコメント*：
 - `// Line comments which go to the end of the line.`
 - `/* Block comments which go to the closing delimiter. */`
* <!--*Doc comments* which are parsed into HTML library-->
   HTMLライブラリに解析される*文書コメント*
<!--[documentation][docs]: -`/// Generate library docs for the following item.`-->
[documentation][docs]： -`/// Generate library docs for the following item.`
<!---`//! Generate library docs for the enclosing item.`-->
-`//! Generate library docs for the enclosing item.`

```rust,editable
fn main() {
#    // This is an example of a line comment
#    // Notice how there are two slashes at the beginning of the line
#    // And that nothing written inside these will be read by the compiler
    // これは、行コメントの例です。行の先頭に2つのスラッシュがあることに注意してください。そして、これらの中に書かれたものは、コンパイラーによって読み取られません

#    // println!("Hello, world!");
    //  println！（"こんにちは、世界！"）;

#    // Run it. See? Now try deleting the two slashes, and run it again.
    // それを実行します。見る？ 2つのスラッシュを削除して、もう一度実行してみましょう。

    /* 
     * This is another type of comment, the block comment. In general,
     * the line comment is the recommended comment style however the
     * block comment is extremely useful for temporarily disabling
     * a large chunk of code. /* Block comments can be /* nested, */ */
     * so it takes only a few keystrokes to comment out all the lines
     * in this main() function. /*/*/* Try it yourself! */*/*/
     */

    /*
    Note, the previous column of `*` was entirely for style. There's
    no actual need for it.
    */

#    // Observe how block comments allow easy expression manipulation
#    // which line comments do not. Deleting the comment delimiters
#    // will change the result:
    // ブロックコメントが、どの行コメントでも簡単に式を操作できるようにする。コメント区切り文字を削除すると、結果が変更されます。
    let x = 5 + /* 90 + */ 5;
    println!("Is `x` 10 or 100? x = {}", x);
}

```

### <!--See also:--> 参照：

<!--[Library documentation][docs]-->
[ライブラリのドキュメント][docs]

[docs]: meta/doc.html
