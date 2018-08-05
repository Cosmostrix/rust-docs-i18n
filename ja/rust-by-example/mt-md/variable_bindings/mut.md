# <!--Mutability--> 変異性

<!--Variable bindings are immutable by default, but this can be overridden using the `mut` modifier.-->
変数バインディングはデフォルトでは変更できませんが、これは`mut`修飾子を使用してオーバーライドできます。

```rust,editable,ignore,mdbook-runnable
fn main() {
    let _immutable_binding = 1;
    let mut mutable_binding = 1;

    println!("Before mutation: {}", mutable_binding);

#    // Ok
    //  OK
    mutable_binding += 1;

    println!("After mutation: {}", mutable_binding);

#    // Error!
    // エラー！
    _immutable_binding += 1;
#    // FIXME ^ Comment out this line
    //  FIXME ^この行をコメントアウトする
}
```

<!--The compiler will throw a detailed diagnostic about mutability errors.-->
コンパイラは、可変エラーに関する詳細な診断をスローします。
