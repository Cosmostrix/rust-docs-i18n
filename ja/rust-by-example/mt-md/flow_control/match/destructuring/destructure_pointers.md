# <!--pointers/ref--> ポインタ/リファレンス

<!--For pointers, a distinction needs to be made between destructuring and dereferencing as they are different concepts which are used differently from a language like `C`.-->
ポインタの場合、`C`ような言語とは異なる概念で使用されるため、非構造化と逆参照の区別が必要です。

 * <!--Dereferencing uses `*`-->
    Dereferencingは`*`
 * <!--Destructuring uses `&`, `ref`, and `ref mut`-->
    破壊は`&`、 `ref`、および`ref mut`

```rust,editable
fn main() {
#    // Assign a reference of type `i32`. The `&` signifies there
#    // is a reference being assigned.
    // タイプ`i32`参照を割り当てます。`&`は、参照が割り当てられていることを示します。
    let reference = &4;

    match reference {
#        // If `reference`s is pattern matched against `&val`, it results
#        // in a comparison like:
#        // `&i32`
#        // `&val`
#        // ^ We see that if the matching `&`s are dropped, then the `i32`
#        // should be assigned to `val`.
        //  `reference`が`&val`とパターンマッチングされている場合、次のような比較が行われます。`&i32` `&val` ^一致する`&` sが削除されると、`i32`を`val`に割り当てる必要があります。
        &val => println!("Got a value via destructuring: {:?}", val),
    }

#    // To avoid the `&`, you dereference before matching.
    //  `&`を避けるには、一致する前に逆参照してください。
    match *reference {
        val => println!("Got a value via dereferencing: {:?}", val),
    }

#    // What if you don't start with a reference? `reference` was a `&`
#    // because the right side was already a reference. This is not
#    // a reference because the right side is not one.
    // もしあなたがリファレンスで始まっていないのであれば？ `reference`は既に参考になっていたため、`&` aは`&` aでした。これは、右側が1ではないため、参照ではありません。
    let _not_a_reference = 3;

#    // Rust provides `ref` for exactly this purpose. It modifies the
#    // assignment so that a reference is created for the element; this
#    // reference is assigned.
    // 錆はまさにこの目的のための`ref`となります。要素の参照が作成されるように割り当てを変更します。この参照が割り当てられます。
    let ref _is_a_reference = 3;

#    // Accordingly, by defining 2 values without references, references
#    // can be retrieved via `ref` and `ref mut`.
    // したがって、参照なしで2つの値を定義することによって、`ref`および`ref mut`介して`ref`を取り出すことができます。
    let value = 5;
    let mut mut_value = 6;

#    // Use `ref` keyword to create a reference.
    //  `ref`を作成するには、`ref`キーワードを使用します。
    match value {
        ref r => println!("Got a reference to a value: {:?}", r),
    }

#    // Use `ref mut` similarly.
    // 同様に`ref mut`使用します。
    match mut_value {
        ref mut m => {
#            // Got a reference. Gotta dereference it before we can
#            // add anything to it.
            // 参考になった私たちはそれに何かを加えることができる前に逆参照してください。
            *m += 10;
            println!("We added 10. `mut_value`: {:?}", m);
        },
    }
}
```
