# <!--Closures--> 閉鎖

<!--Closures in Rust, also called lambda expressions or lambdas, are functions that can capture the enclosing environment.-->
RustのClosureは、ラムダ式またはラムダとも呼ばれ、囲む環境をキャプチャできる関数です。
<!--For example, a closure that captures the x variable: ` ``Rust |val| val + x``-->
たとえば、x変数をキャプチャするクロージャ： ` ``Rust |val| val + x``
<!--``Rust |val| val + x`` `-->
``Rust |val| val + x`` `

<!--The syntax and capabilities of closures make them very convenient for on the fly usage.-->
クロージャの構文と機能は、オンザフライでの使用に非常に便利です。
<!--Calling a closure is exactly like calling a function.-->
クロージャを呼び出すことは、関数を呼び出すこととまったく同じです。
<!--However, both input and return types *can* be inferred and input variable names *must* be specified.-->
ただし、入力型と戻り型の両方を推論*すること*が*でき*、入力変数名を指定する*必要*があります。

<!--Other characteristics of closures include: * using `||`-->
クロージャーの他の特性には以下が含まれます：*使用`||`
<!--instead of `()` around input variables.-->
入力変数のまわりで`()`代わりに。
<!--* optional body delimination (`{}`) for a single expression (mandatory otherwise).-->
*単一の式に対する省略可能なボディ区切り（`{}`）（別途必須）。
<!--* the ability to capture the outer environment variables.-->
*外部環境変数をキャプチャする能力。

```rust,editable
fn main() {
#    // Increment via closures and functions.
    // クロージャと関数を使用してインクリメントします。
    fn  function            (i: i32) -> i32 { i + 1 }

#    // Closures are anonymous, here we are binding them to references
#    // Annotation is identical to function annotation but is optional
#    // as are the `{}` wrapping the body. These nameless functions
#    // are assigned to appropriately named variables.
    // クロージャは匿名ですが、ここではそれらを参照にバインドしています。アノテーションは関数アノテーションと同じですが、ボディをラップする`{}`ようにオプションです。これらの名前のない関数は、適切に名前が付けられた変数に割り当てられます。
    let closure_annotated = |i: i32| -> i32 { i + 1 };
    let closure_inferred  = |i     |          i + 1  ;

    let i = 1;
#    // Call the function and closures.
    // 関数とクロージャを呼び出します。
    println!("function: {}", function(i));
    println!("closure_annotated: {}", closure_annotated(i));
    println!("closure_inferred: {}", closure_inferred(i));

#    // A closure taking no arguments which returns an `i32`.
#    // The return type is inferred.
    //  `i32`を返す引数を取らないクロージャ。戻り値の型が推測されます。
    let one = || 1;
    println!("closure returning one: {}", one());

}
```
