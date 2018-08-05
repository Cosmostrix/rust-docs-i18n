# <!--Variable Bindings--> 変数バインディング

<!--Rust provides type safety via static typing.-->
Rustは静的タイピングを介して型の安全性を提供します。
<!--Variable bindings can be type annotated when declared.-->
変数バインディングには、宣言されたときに注釈を付けることができます。
<!--However, in most cases, the compiler will be able to infer the type of the variable from the context, heavily reducing the annotation burden.-->
しかし、ほとんどの場合、コンパイラはコンテキストの変数の型を推測し、注釈の負担を大幅に減らすことができます。

<!--Values (like literals) can be bound to variables, using the `let` binding.-->
値（リテラルなど）は、`let`バインディングを使用して変数にバインドできます。

```rust,editable
fn main() {
    let an_integer = 1u32;
    let a_boolean = true;
    let unit = ();

#    // copy `an_integer` into `copied_integer`
    //  `an_integer`を`copied_integer`コピーする
    let copied_integer = an_integer;

    println!("An integer: {:?}", copied_integer);
    println!("A boolean: {:?}", a_boolean);
    println!("Meet the unit value: {:?}", unit);

#    // The compiler warns about unused variable bindings; these warnings can
#    // be silenced by prefixing the variable name with an underscore
    // コンパイラは未使用の変数バインディングについて警告します。これらの警告は、変数名の先頭にアンダースコア
    let _unused_variable = 3u32;

    let noisy_unused_variable = 2u32;
#    // FIXME ^ Prefix with an underscore to suppress the warning
    //  FIXME ^警告を抑制するアンダースコアの接頭辞
}
```
