# <!--while let--> しながら

<!--Similar to `if let`, `while let` can make awkward `match` sequences more tolerable.-->
同様に`if let`、 `while let`厄介なことができます`match`シーケンスがより許容。
<!--Consider the following sequence that increments `i`:-->
`i`をインクリメントする次のシーケンスを考えてみましょう。

```rust
#// Make `optional` of type `Option<i32>`
//  `optional`のタイプを作成する`Option<i32>`
let mut optional = Some(0);

#// Repeatedly try this test.
// このテストを繰り返し試みてください。
loop {
    match optional {
#        // If `optional` destructures, evaluate the block.
        //  `optional`破棄がある場合は、ブロックを評価します。
        Some(i) => {
            if i > 9 {
                println!("Greater than 9, quit!");
                optional = None;
            } else {
                println!("`i` is `{:?}`. Try again.", i);
                optional = Some(i + 1);
            }
#            // ^ Requires 3 indentations!
            //  ^ 3つのインデントが必要です！
        },
#        // Quit the loop when the destructure fails:
        // 破壊が失敗したときにループを終了する：
        _ => { break; }
#        // ^ Why should this be required? There must be a better way!
        //  ^これはなぜ必要なのですか？より良い方法が必要です！
    }
}
```

<!--Using `while let` makes this sequence much nicer:-->
`while let`を使用すると、このシーケンスはもっとうまくできます：

```rust,editable
fn main() {
#    // Make `optional` of type `Option<i32>`
    //  `optional`のタイプを作成する`Option<i32>`
    let mut optional = Some(0);

#    // This reads: "while `let` destructures `optional` into
#    // `Some(i)`, evaluate the block (`{}`). Else `break`.
    // これは読む：「ながら`let` destructuresは`optional`に`Some(i)`ブロックを評価（`{}`エルス。`break`。
    while let Some(i) = optional {
        if i > 9 {
            println!("Greater than 9, quit!");
            optional = None;
        } else {
            println!("`i` is `{:?}`. Try again.", i);
            optional = Some(i + 1);
        }
#        // ^ Less rightward drift and doesn't require
#        // explicitly handling the failing case.
        //  ^右方向にドリフトが少なく、失敗したケースを明示的に処理する必要はありません。
    }
#    // ^ `if let` had additional optional `else`/`else if`
#    // clauses. `while let` does not have these.
    //  ^ `if let`に追加のオプションの`else` / `else if`節`else if`。 `while let`はこれらを持っていません。
}
```

### <!--See also:--> 参照：

<!--[`enum`][enum], [`Option`][option], and the [RFC][while_let_rfc]-->
[`enum`][enum]、 [`Option`][option]、および[RFC][while_let_rfc]

<!--[enum]: custom_types/enum.html
 [option]: std/option.html
 [while_let_rfc]: https://github.com/rust-lang/rfcs/pull/214
-->
[enum]: custom_types/enum.html
 [option]: std/option.html
 [while_let_rfc]: https://github.com/rust-lang/rfcs/pull/214

