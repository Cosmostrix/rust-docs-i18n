# <!--Declare first--> 最初に宣言する

<!--It's possible to declare variable bindings first, and initialize them later.-->
可変バインディングを宣言し、後でそれらを初期化することは可能です。
<!--However, this form is seldom used, as it may lead to the use of uninitialized variables.-->
ただし、初期化されていない変数を使用する可能性があるため、この形式はあまり使用されません。

```rust,editable,ignore,mdbook-runnable
fn main() {
#    // Declare a variable binding
    // 変数バインディングを宣言する
    let a_binding;

    {
        let x = 2;

#        // Initialize the binding
        // バインディングを初期化する
        a_binding = x * x;
    }

    println!("a binding: {}", a_binding);

    let another_binding;

#    // Error! Use of uninitialized binding
    // エラー！初期化されていないバインディングの使用
    println!("another binding: {}", another_binding);
#    // FIXME ^ Comment out this line
    //  FIXME ^この行をコメントアウトする

    another_binding = 1;

    println!("another binding: {}", another_binding);
}
```

<!--The compiler forbids use of uninitialized variables, as this would lead to undefined behavior.-->
コンパイラは、初期化されていない変数の使用を禁止します。これは未定義の動作につながります。
