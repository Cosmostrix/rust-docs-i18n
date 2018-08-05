# <!--Binding--> バインディング

<!--Indirectly accessing a variable makes it impossible to branch and use that variable without re-binding.-->
変数に間接的にアクセスすると、その変数を再バインドせずに分岐して使用することができなくなります。
<!--`match` provides the `@` sigil for binding values to names:-->
`match`は名前に値をバインドするための`@` sigilを提供します：

```rust,editable
#// A function `age` which returns a `u32`.
//  `u32`を返す関数の`age`。
fn age() -> u32 {
    15
}

fn main() {
    println!("Tell me type of person you are");

    match age() {
        0             => println!("I'm not born yet I guess"),
#        // Could `match` 1 ... 12 directly but then what age
#        // would the child be? Instead, bind to `n` for the
#        // sequence of 1 .. 12. Now the age can be reported.
        //  1... 12に直接`match`することができましたが、子供は何歳ですか？代わりに、1のシーケンスのために`n`にバインドしてください`n`.今、年齢を報告することができます。
        n @ 1  ... 12 => println!("I'm a child of age {:?}", n),
        n @ 13 ... 19 => println!("I'm a teen of age {:?}", n),
#        // Nothing bound. Return the result.
        // 何もない。結果を返します。
        n             => println!("I'm an old person of age {:?}", n),
    }
}
```

### <!--See also:--> 参照：
[functions]
[functions]: fn.html
