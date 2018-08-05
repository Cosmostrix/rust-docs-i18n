# <!--Scope and Shadowing--> スコープとシャドウイング

<!--Variable bindings have a scope, and are constrained to live in a *block*.-->
変数バインディングはスコープを持ち、*ブロック*内に存在するように制約されてい*ます*。
<!--A block is a collection of statements enclosed by braces `{}`.-->
ブロックとは、中括弧`{}`囲まれたステートメントの集合です。
<!--Also, [variable shadowing][variable-shadow] is allowed.-->
また、[variable shadowing][variable-shadow]が可能です。

```rust,editable,ignore,mdbook-runnable
fn main() {
#    // This binding lives in the main function
    // この結合は主機能に存続する
    let long_lived_binding = 1;

#    // This is a block, and has a smaller scope than the main function
    // これはブロックであり、main関数よりもスコープが狭い
    {
#        // This binding only exists in this block
        // このバインディングはこのブロックにのみ存在します
        let short_lived_binding = 2;

        println!("inner short: {}", short_lived_binding);

#        // This binding *shadows* the outer one
        // この結合*影*外1
        let long_lived_binding = 5_f32;

        println!("inner long: {}", long_lived_binding);
    }
#    // End of the block
    // ブロックの終わり

#    // Error! `short_lived_binding` doesn't exist in this scope
    // エラー！ `short_lived_binding`はこのスコープに存在しません
    println!("outer short: {}", short_lived_binding);
#    // FIXME ^ Comment out this line
    //  FIXME ^この行をコメントアウトする

    println!("outer long: {}", long_lived_binding);
    
#    // This binding also *shadows* the previous binding
    // このバインディングは、以前のバインドも*シャドウ*します
    let long_lived_binding = 'a';
    
    println!("outer long: {}", long_lived_binding);
}
```

[variable-shadow]: https://en.wikipedia.org/wiki/Variable_shadowing
