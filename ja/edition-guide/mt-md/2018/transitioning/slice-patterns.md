# <!--Basic slice patterns--> 基本スライスパターン

<!--Have you ever tried to pattern match on the contents and structure of a slice?-->
あなたはスライスの内容と構造についてパターンマッチを試みたことがありますか？
<!--Rust 2018 will let you do just that.-->
2018年の錆はあなたにそれをさせるでしょう。

<!--For example, say we want to accept a list of names and respond to that with a greeting.-->
たとえば、名前のリストを受け入れて挨拶で応答するとします。
<!--With slice patterns, we can do that easy as pie with:-->
スライスパターンでは、次のように簡単に円を描くことができます。

```rust
fn main() {
    greet(&[]);
#    // output: Bummer, there's no one here :(
    // 出力：バマー、ここに誰もない:(
    greet(&["Alan"]);
#    // output: Hey, there Alan! You seem to be alone.
    // 出力：ねえ、そこにアラン！あなたは一人のようです。
    greet(&["Joan", "Hugh"]);
#    // output: Hello, Joan and Hugh. Nice to see you are at least 2!
    // 出力：こんにちは、ジョーンとヒュー。あなたが少なくとも2であることを見てうれしい！
    greet(&["John", "Peter", "Stewart"]);
#    // output: Hey everyone, we seem to be 3 here today.
    // 皆さん、今日はここ3人のようです。
}

fn greet(people: &[&str]) {
    match people {
        [] => println!("Bummer, there's no one here :("),
        [only_one] => println!("Hey, there {}! You seem to be alone.", only_one),
        [first, second] => println!(
            "Hello, {} and {}. Nice to see you are at least 2!",
            first, second
        ),
        _ => println!("Hey everyone, we seem to be {} here today.", people.len()),
    }
}
```

<!--Now, you don't have to check the length first.-->
さて、最初に長さを確認する必要はありません。

<!--We can also match on arrays like so:-->
次のように配列をマッチさせることもできます：

```rust
let arr = [1, 2, 3];

assert_eq!("ends with 3", match arr {
    [_, _, 3] => "ends with 3",
    [a, b, c] => "ends with something else",
});
```

## <!--More details--> 詳細

### <!--Exhaustive patterns--> 網羅的なパターン

<!--In the first example, note in particular the `_ => ...` pattern.-->
最初の例では、特に`_ => ...`パターンに注意してください。
<!--Since we are matching on a slice, it could be of any length, so we need a *"catch all pattern"* to handle it.-->
スライス上でマッチしているので、長さに関係なく、*すべてのパターンをキャッチ*する必要があります。
<!--If we forgot the `_ => ...` or `identifier => ...` pattern, we would instead get an error saying:-->
`_ => ...`または`identifier => ...`パターンを忘れた場合は、代わりに次のようなエラーが表示されます。

```ignore
error[E0004]: non-exhaustive patterns: `&[_, _, _]` not covered
```

<!--If we added a case for a slice of size `3` we would instead get:-->
サイズ`3`スライスにケースを追加した場合、代わりに次のようになります。

```ignore
error[E0004]: non-exhaustive patterns: `&[_, _, _, _]` not covered
```

<!--and so on...-->
等々...

### <!--Arrays and exact lengths--> 配列と正確な長さ

<!--In the second example above, since arrays in Rust are of known lengths, we have to match on exactly three elements.-->
上記の2番目の例では、Rustの配列は既知の長さであるため、正確に3つの要素に一致させる必要があります。
<!--If we try to match on 2 or 4 elements,we get the errors:-->
2つまたは4つの要素にマッチしようとすると、エラーが発生します。

```ignore
error[E0527]: pattern requires 2 elements but array has 3
```

<!--and-->
そして

```ignore
error[E0527]: pattern requires 4 elements but array has 3
```

### <!--In the pipeline--> パイプラインで

[the tracking issue]: https://github.com/rust-lang/rust/issues/23121

<!--When it comes to slice patterns, more advanced forms are planned but have not been stabilized yet.-->
スライスパターンに関しては、より高度なフォームが計画されていますが、まだ安定していません。
<!--To learn more, follow [the tracking issue].-->
詳細については[the tracking issue]に従っ[the tracking issue]。
