## <!--Compile a C library while setting custom defines--> カスタム定義を設定しているときにCライブラリをコンパイルする

<!--[!][cc]-->
[！][cc]
<!--[cc-badge] [!][cat-development-tools]-->
[cc-badge] [！][cat-development-tools]
[cat-development-tools-badge]
<!--It is simple to build bundled C code with custom defines using [`cc::Build::define`].-->
[`cc::Build::define`]を使って、カスタム定義でバンドルされたCコードを作るのは簡単[`cc::Build::define`]。
<!--The method takes an [`Option`] value, so it is possible to create defines such as `#define APP_NAME "foo"` as well as `#define WELCOME` (pass `None` as the value for a value-less define).-->
このメソッドは[`Option`]値を取るので、`#define APP_NAME "foo"`や`#define WELCOME`（値`None`定義の値として渡す）などの定義を作成することができます。
<!--This example builds a bundled C file with dynamic defines set in `build.rs` and prints "**Welcome to foo -version 1.0.2** "when run.-->
この例では、`build.rs`で設定された動的定義を含むバンドルされたCファイルをビルドし、実行時に "**Welcome to foo -version 1.0.2** "を出力します。
<!--Cargo sets some [environment variables][cargo-env] which may be useful for some custom defines.-->
Cargoはいくつかのカスタム[変数][cargo-env]に便利な[環境変数][cargo-env]をいくつか設定します。


### `Cargo.toml`
```toml
[package]
...
version = "1.0.2"
build = "build.rs"

[build-dependencies]
cc = "1"
```

### `build.rs`
```rust,no_run
extern crate cc;

fn main() {
    cc::Build::new()
        .define("APP_NAME", "\"foo\"")
        .define("VERSION", format!("\"{}\"", env!("CARGO_PKG_VERSION")).as_str())
        .define("WELCOME", None)
        .file("src/foo.c")
        .compile("foo");
}
```

### `src/foo.c`
```c
#include <stdio.h>

void print_app_info() {
#ifdef WELCOME
    printf("Welcome to ");
#endif
    printf("%s - version %s\n", APP_NAME, VERSION);
}
```

### `src/main.rs`
```rust,ignore
extern {
    fn print_app_info();
}

fn main(){
    unsafe {
        print_app_info();
    }   
}
```

[cargo-env]: https://doc.rust-lang.org/cargo/reference/environment-variables.html
