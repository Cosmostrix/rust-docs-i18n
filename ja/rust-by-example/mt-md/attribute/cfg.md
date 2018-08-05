# `cfg`
<!--Conditional compilation is possible through two different operators:-->
条件付きコンパイルは、2つの異なる演算子によって可能です。

* <!--the `cfg` attribute: `#[cfg(...)]` in attribute position-->
   `cfg`属性：属性位置の`#[cfg(...)]`
* <!--the `cfg!` macro: `cfg!(...)` in boolean expressions-->
   ブール式の`cfg!`マクロ： `cfg!(...)`

<!--Both utilize identical argument syntax.-->
どちらも同じ引数構文を使用します。

```rust,editable
#// This function only gets compiled if the target OS is linux
// この機能はターゲットOSがLinuxの場合のみコンパイルされます
#[cfg(target_os = "linux")]
fn are_you_on_linux() {
    println!("You are running linux!");
}

#// And this function only gets compiled if the target OS is *not* linux
// そして、この機能はターゲットOSがLinuxで*ない*場合にのみコンパイルされます
#[cfg(not(target_os = "linux"))]
fn are_you_on_linux() {
    println!("You are *not* running linux!");
}

fn main() {
    are_you_on_linux();
    
    println!("Are you sure?");
    if cfg!(target_os = "linux") {
        println!("Yes. It's definitely linux!");
    } else {
        println!("Yes. It's definitely *not* linux!");
    }
}
```

### <!--See also:--> 参照：

<!--[the reference][ref], [`cfg!`][cfg], and [macros][macros].-->
[`cfg!`][cfg]、および[macros][macros] [参照してください][ref]。

<!--[cfg]: https://doc.rust-lang.org/std/macro.cfg!.html
 [macros]: macros.html
 [ref]: https://doc.rust-lang.org/reference/attributes.html#conditional-compilation
-->
[cfg]: https://doc.rust-lang.org/std/macro.cfg!.html
 [macros]: macros.html
 [ref]: https://doc.rust-lang.org/reference/attributes.html#conditional-compilation

