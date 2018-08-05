# <!--`Option` & `unwrap`--> `Option` ＆ `unwrap`

<!--In the last example, we showed that we can induce program failure at will.-->
最後の例では、自由にプログラムの失敗を誘導できることを示しました。
<!--We told our program to `panic` if the princess received an inappropriate gift -a snake.-->
私たちは、プリンセスが不適切な贈り物、すなわちヘビを受け取った場合、私たちのプログラムに`panic`て言いました。
<!--But what if the princess expected a gift and didn't receive one?-->
しかし、王女が贈り物を期待し、贈り物を受け取らなかったらどうなるでしょうか？
<!--That case would be just as bad, so it needs to be handled!-->
その場合も同様に悪いので、処理する必要があります！

<!--We *could* test this against the null string (`""`) as we do with a snake.-->
私たち*が*ヘビで行うように、これをヌル文字列（`""`）に対してテストする*ことができ*ました。
<!--Since we're using Rust, let's instead have the compiler point out cases where there's no gift.-->
私たちはRustを使用しているので、代わりにコンパイラに贈り物のないケースを指摘させてもらいましょう。

<!--An `enum` called `Option<T>` in the `std` library is used when absence is a possibility.-->
存在しない可能性がある場合、`std`ライブラリの`Option<T>`という`enum`が使用されます。
<!--It manifests itself as one of two "options":-->
それは2つの「オプション」の1つとして現れます。

* <!--`Some(T)`: An element of type `T` was found-->
   `Some(T)`：タイプ`T`の要素が見つかりました
* <!--`None`: No element was found-->
   `None`：要素が見つかりませんでした

<!--These cases can either be explicitly handled via `match` or implicitly with `unwrap`.-->
これらのケースは、明示的に`match`または暗黙のうちに`unwrap`処理することができます。
<!--Implicit handling will either return the inner element or `panic`.-->
暗黙のハンドリングは、内部要素または`panic`返すかのいずれかです。

<!--Note that it's possible to manually customize `panic` with [expect][expect], but `unwrap` otherwise leaves us with a less meaningful output than explicit handling.-->
それは手動でカスタマイズすることも可能だということに注意してください`panic`と[expect][expect]たが、`unwrap`そうでない場合は、明示的な取り扱い未満有意義な出力を私たちに残します。
<!--In the following example, explicit handling yields a more controlled result while retaining the option to `panic` if desired.-->
次の例では、明示的な処理により、必要に応じて`panic`するオプションを保持したまま、より制御された結果が得られます。

```rust,editable,ignore,mdbook-runnable
#// The commoner has seen it all, and can handle any gift well.
#// All gifts are handled explicitly using `match`.
// コモンナーはそれをすべて見て、どんな贈り物にもうまく対処できます。すべてのギフトは、`match`を使って明示的に処理され
fn give_commoner(gift: Option<&str>) {
#    // Specify a course of action for each case.
    // それぞれのケースの行動のコースを指定します。
    match gift {
        Some("snake") => println!("Yuck! I'm throwing that snake in a fire."),
        Some(inner)   => println!("{}? How nice.", inner),
        None          => println!("No gift? Oh well."),
    }
}

#// Our sheltered princess will `panic` at the sight of snakes.
#// All gifts are handled implicitly using `unwrap`.
// 私たちの保護された王女は、ヘビの目の前で`panic`になります。すべてのギフトは、`unwrap`を使用して暗黙的に処理されます。
fn give_princess(gift: Option<&str>) {
#    // `unwrap` returns a `panic` when it receives a `None`.
    //  `unwrap`は`None`を受け取ったときに`panic`返します。
    let inside = gift.unwrap();
    if inside == "snake" { panic!("AAAaaaaa!!!!"); }

    println!("I love {}s!!!!!", inside);
}

fn main() {
    let food  = Some("cabbage");
    let snake = Some("snake");
    let void  = None;

    give_commoner(food);
    give_commoner(snake);
    give_commoner(void);

    let bird = Some("robin");
    let nothing = None;

    give_princess(bird);
    give_princess(nothing);
}
```

[expect]: https://doc.rust-lang.org/std/option/enum.Option.html#method.expect
