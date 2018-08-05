# <!--Crates--> クレート

<!--The `crate_type` attribute can be used to tell the compiler whether a crate is a binary or a library (and even which type of library), and the `crate_name` attribute can be used to set the name of the crate.-->
`crate_type`属性を使用して、クレートがバイナリかライブラリか（そしてどのタイプのライブラリさえも）コンパイラに知らせることができ、`crate_name`属性を使用してクレートの名前を設定することができます。

<!--However, it is important to note that both the `crate_type` and `crate_name` attributes have **no** effect whatsoever when using Cargo, the Rust package manager.-->
ただし、`crate_type`と`crate_name`両方の属性は、RustパッケージマネージャであるCargoを使用して**も**効果が**ない**ことに注意することが重要です。
<!--Since Cargo is used for the majority of Rust projects, this means real-world uses of `crate_type` and `crate_name` are relatively limited.-->
Cargoは大部分のRustプロジェクトに使用されているため、実際の`crate_type`と`crate_name`使用は比較的限られています。

```rust,editable
#// This crate is a library
// この箱は図書館です
#![crate_type = "lib"]
#// The library is named "rary"
// ライブラリの名前は "rary"
#![crate_name = "rary"]

pub fn public_function() {
    println!("called rary's `public_function()`");
}

fn private_function() {
    println!("called rary's `private_function()`");
}

pub fn indirect_access() {
    print!("called rary's `indirect_access()`, that\n> ");

    private_function();
}
```

<!--When the `crate_type` attribute is used, we no longer need to pass the `--crate-type` flag to `rustc`.-->
`crate_type`属性を使用すると、`--crate-type`フラグを`rustc`に渡す必要が`rustc`。

```bash
$ rustc lib.rs
$ ls lib*
library.rlib
```
