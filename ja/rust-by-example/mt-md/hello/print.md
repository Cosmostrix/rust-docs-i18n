# <!--Formatted print--> 書式付き印刷

<!--Printing is handled by a series of [`macros`][macros] defined in [`std::fmt`][fmt] some of which include:-->
印刷は、[`std::fmt`][fmt]定義された一連の[`macros`][macros]によって処理されます。

* <!--`format!`: write formatted text to [`String`][string]-->
   `format!`：フォーマットされたテキストを[`String`][string]書き出す
* <!--`print!`: same as `format!` but the text is printed to the console (io::stdout).-->
   `print!`： `format!`と同じ`format!`が、テキストはコンソール（io:: stdout）に出力されます。
* <!--`println!`: same as `print!` but a newline is appended.-->
   `println!`： `println!`と同じ`print!`が、改行が追加されます。
* <!--`eprint!`: same as `format!` but the text is printed to the standard error (io::stderr).-->
   `eprint!`： `format!`と同じ`format!`が、テキストは標準エラー（io:: stderr）に出力されます。
* <!--`eprintln!`: sames as `eprint!` but a newline is appended.-->
   `eprintln!`： `eprint!`が、改行が追加されています。

<!--All parse text in the same fashion.-->
すべてのテキストを同じ方法で解析します。
<!--A plus is that the formatting correctness will be checked at compile time.-->
プラスは、コンパイル時に書式の正しさがチェックされることです。

```rust,editable,ignore,mdbook-runnable
fn main() {
#    // In general, the `{}` will be automatically replaced with any
#    // arguments. These will be stringified.
    // 一般的に、`{}`は自動的に引数に置き換えられます。これらはストリング化されます。
    println!("{} days", 31);

#    // Without a suffix, 31 becomes an i32. You can change what type 31 is,
#    // with a suffix.
    // 接尾辞がなければ、31はi32になります。タイプ31は、接尾辞付きで変更できます。

#    // There are various optional patterns this works with. Positional
#    // arguments can be used.
    // これにはさまざまなオプションパターンがあります。位置的な引数を使うことができます。
    println!("{0}, this is {1}. {1}, this is {0}", "Alice", "Bob");

#    // As can named arguments.
    // 名前付き引数と同じです。
    println!("{subject} {verb} {object}",
             object="the lazy dog",
             subject="the quick brown fox",
             verb="jumps over");

#    // Special formatting can be specified after a `:`.
    // 特別な書式設定は以下の後に指定することができます`:`。
    println!("{} of {:b} people know binary, the other half doesn't", 1, 2);

#    // You can right-align text with a specified width. This will output
#    // "     1". 5 white spaces and a "1".
    // テキストを指定した幅で右揃えにすることができます。これは "1"を出力します。5の空白と「1」。
    println!("{number:>width$}", number=1, width=6);

#    // You can pad numbers with extra zeroes. This will output "000001".
    // あなたは余分なゼロでパッドすることができます。これで "000001"が出力されます。
    println!("{number:>0width$}", number=1, width=6);

#    // It will even check to make sure the correct number of arguments are
#    // used.
    // 正しい数の引数が使用されているかどうかをチェックすることさえできます。
    println!("My name is {0}, {1} {0}", "Bond");
#    // FIXME ^ Add the missing argument: "James"
    //  FIXME ^欠落している引数を追加する： "James"
    
#    // Create a structure which contains an `i32`. Name it `Structure`.
    //  `i32`を含む構造体を作成します。`Structure`名前を付けます。
    #[allow(dead_code)]
    struct Structure(i32);

#    // However, custom types such as this structure require more complicated
#    // handling. This will not work.
    // ただし、このようなカスタムタイプでは、より複雑な処理が必要です。これは動作しません。
    println!("This struct `{}` won't print...", Structure(3));
#    // FIXME ^ Comment out this line.
    //  FIXME ^この行をコメントアウトしてください。
}
```

<!--[`std::fmt`][fmt] contains many [`traits`][traits] which govern the display of text.-->
[`std::fmt`][fmt]は、テキストの表示を制御する多くの[`traits`][traits]が含まれています。
<!--The base form of two important ones are listed below:-->
重要な2つの基本形式を以下に示します。

* <!--`fmt::Debug`: Uses the `{:?}` marker.-->
   `fmt::Debug`： `{:?}` `fmt::Debug` `{:?}`マーカーを使用します。
<!--Format text for debugging purposes.-->
   デバッグのためにテキストをフォーマットします。
* <!--`fmt::Display`: Uses the `{}` marker.-->
   `fmt::Display`： `{}`マーカーを使用します。
<!--Format text in a more elegant, user-->
   より洗練されたユーザーのテキストを書式設定する
<!--friendly fashion.-->
フレンドリーなファッション。

<!--Here, `fmt::Display` was used because the std library provides implementations for these types.-->
ここでは、stdライブラリがこれらの型の実装を提供するため、`fmt::Display`が使用されています。
<!--To print text for custom types, more steps are required.-->
カスタムタイプのテキストを印刷するには、さらに多くの手順が必要です。

### <!--Activities--> アクティビティ

 * <!--Fix the two issues in the above code (see FIXME) so that it runs without error.-->
    上記のコード（FIXMEを参照）の2つの問題を修正して、エラーなく実行してください。
 * <!--Add a `println!` macro that prints: `Pi is roughly 3.142` by controlling the number of decimal places shown.-->
    追加`println!`印刷マクロ： `Pi is roughly 3.142`示される小数点以下の桁数を制御することによって。
<!--For the purposes of this exercise, use `let pi = 3.141592` as an estimate for Pi.-->
    この演習では、Piの推定値として`let pi = 3.141592`を使用します。
<!--(Hint: you may need to check the [`std::fmt`][fmt] documentation for setting the number of decimals to display)-->
    （ヒント：表示する小数の数を設定するために[`std::fmt`][fmt]ドキュメントをチェックする必要があるかもしれません）

### <!--See also--> も参照してください

<!--[`std::fmt`][fmt], [`macros`][macros], [`struct`][structs], and [`traits`][traits]-->
[`std::fmt`][fmt]、 [`macros`][macros]、 [`struct`][structs]、および[`traits`][traits]

<!--[fmt]: https://doc.rust-lang.org/std/fmt/
 [macros]: macros.html
 [string]: std/str.html
 [structs]: custom_types/structs.html
 [traits]: trait.html
-->
[fmt]: https://doc.rust-lang.org/std/fmt/
 [macros]: macros.html
 [string]: std/str.html
 [structs]: custom_types/structs.html
 [traits]: trait.html

