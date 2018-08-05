# <!--constants--> 定数

<!--Rust has two different types of constants which can be declared in any scope including global.-->
Rustにはグローバルを含む任意のスコープで宣言できる2種類の定数があります。
<!--Both require explicit type annotation:-->
どちらも明示的な型の注釈が必要です。

* <!--`const`: An unchangeable value (the common case).-->
   `const`：変更不可能な値（一般的なケース）。
* <!--`static`: A possibly `mut` able variable with [`'static`][static] lifetime.-->
   `static`： [`'static`][static] lifetime [`'static`][static]持つ`mut`可能な変数です。

<!--One special case is the `"string"` literal.-->
1つの特別なケースは`"string"`リテラルです。
<!--It can be assigned directly to a `static` variable without modification because its type signature: `&'static str` has the required lifetime of `'static`.-->
これは、型シグネチャが`&'static str`の所要ライフタイムが`&'static str`ため、変更せずに直接`static`変数に割り当てることができ`'static`。
<!--All other reference types must be specifically annotated so that they fulfill the `'static` lifetime.-->
他のすべての参照型には、`'static`存続期間`'static`を満たすように特別な注釈を付ける必要があります。
<!--This may seem minor though because the required explicit annotation hides the distinction.-->
必要な明示的な注釈が区別を隠すため、これはマイナーなように見えるかもしれません。

```rust,editable,ignore,mdbook-runnable
#// Globals are declared outside all other scopes.
// グローバルは他のスコープの外に宣言されます。
static LANGUAGE: &'static str = "Rust";
const  THRESHOLD: i32 = 10;

fn is_big(n: i32) -> bool {
#    // Access constant in some function
    // 一部の関数で定数にアクセスする
    n > THRESHOLD
}

fn main() {
    let n = 16;

#    // Access constant in the main thread
    // メインスレッドのアクセス定数
    println!("This is {}", LANGUAGE);
    println!("The threshold is {}", THRESHOLD);
    println!("{} is {}", n, if is_big(n) { "big" } else { "small" });

#    // Error! Cannot modify a `const`.
    // エラー！ `const`変更することはできません。
    THRESHOLD = 5;
#    // FIXME ^ Comment out this line
    //  FIXME ^この行をコメントアウトする
}
```

### <!--See also:--> 参照：

<!--[The `const` / `static` RFC](https://github.com/rust-lang/rfcs/blob/master/text/0246-const-vs-static.md), [`'static` lifetime][static]-->
[`const` / `static` RFC](https://github.com/rust-lang/rfcs/blob/master/text/0246-const-vs-static.md)、 [`'static`寿命][static]

[static]: scope/lifetime/static_lifetime.html
