# <!--File hierarchy--> ファイル階層

<!--Modules can be mapped to a file/directory hierarchy.-->
モジュールは、ファイル/ディレクトリ階層にマップすることができます。
<!--Let's break down the [visibility example][visibility] in files:-->
ファイルの[可視性の例を][visibility]解説しましょう：

```bash
$ tree .
.
|-- my
|   |-- inaccessible.rs
|   |-- mod.rs
|   `-- nested.rs
`-- split.rs
```

<!--In `split.rs`:-->
`split.rs`：

```rust,ignore
#// This declaration will look for a file named `my.rs` or `my/mod.rs` and will
#// insert its contents inside a module named `my` under this scope
// この宣言では、`my.rs`または`my/mod.rs`という名前のファイルが検索され、その内容がこのスコープの下にある`my`というモジュール内に挿入されます
mod my;

fn function() {
    println!("called `function()`");
}

fn main() {
    my::function();

    function();

    my::indirect_access();

    my::nested::function();
}

```

<!--In `my/mod.rs`:-->
`my/mod.rs`：

```rust,ignore
#// Similarly `mod inaccessible` and `mod nested` will locate the `nested.rs`
#// and `inaccessible.rs` files and insert them here under their respective
#// modules
// 同様に、`mod inaccessible`、 `mod nested`場合、`nested.rs`ファイルと`inaccessible.rs`ファイルが見つけられ、それぞれのモジュールの下に挿入されます
mod inaccessible;
pub mod nested;

pub fn function() {
    println!("called `my::function()`");
}

fn private_function() {
    println!("called `my::private_function()`");
}

pub fn indirect_access() {
    print!("called `my::indirect_access()`, that\n> ");

    private_function();
}
```

<!--In `my/nested.rs`:-->
`my/nested.rs`：

```rust,ignore
pub fn function() {
    println!("called `my::nested::function()`");
}

#[allow(dead_code)]
fn private_function() {
    println!("called `my::nested::private_function()`");
}
```

<!--In `my/inaccessible.rs`:-->
`my/inaccessible.rs`：

```rust,ignore
#[allow(dead_code)]
pub fn public_function() {
    println!("called `my::inaccessible::public_function()`");
}
```

<!--Let's check that things still work as before:-->
前と同じように動作することを確認しましょう。

```bash
$ rustc split.rs && ./split
called `my::function()`
called `function()`
called `my::indirect_access()`, that
> called `my::private_function()`
called `my::nested::function()`
```

[visibility]: mod/visibility.html
