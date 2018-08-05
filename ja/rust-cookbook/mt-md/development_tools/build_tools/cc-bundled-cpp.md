## <!--Compile and link statically to a bundled C++ library--> バンドルされたC ++ライブラリに静的にコンパイルおよびリンクする

<!--[!][cc]-->
[！][cc]
<!--[cc-badge] [!][cat-development-tools]-->
[cc-badge] [！][cat-development-tools]
[cat-development-tools-badge]
<!--Linking a bundled C++ library is very similar to linking a bundled C library.-->
バンドルされたC ++ライブラリをリンクすることは、バンドルされたCライブラリをリンクすることと非常によく似ています。
<!--The two core differences when compiling and statically linking a bundled C++ library are specifying a C++ compiler via the builder method [`cpp(true)`][cc-build-cpp] and preventing name mangling by the C++ compiler by adding the `extern "C"` section at the top of our C++ source file.-->
バンドルされたC ++ライブラリをコンパイルおよび静的にリンクする際の2つのコアの違いは、ビルダーメソッド[`cpp(true)`][cc-build-cpp]を使用してC ++コンパイラを指定し、C ++ソースファイルの先頭に`extern "C"`セクションを追加することによって、。


### `Cargo.toml`
```toml
[package]
...
build = "build.rs"

[build-dependencies]
cc = "1"
```

### `build.rs`
```rust,no_run
extern crate cc;

fn main() {
    cc::Build::new()
        .cpp(true)
        .file("src/foo.cpp")
        .compile("foo");   
}
```

### `src/foo.cpp`
```cpp
extern "C" {
    int multiply(int x, int y);
}

int multiply(int x, int y) {
    return x*y;
}
```

### `src/main.rs`
```rust,ignore
extern {
    fn multiply(x : i32, y : i32) -> i32;
}

fn main(){
    unsafe {
        println!("{}", multiply(5,7));
    }   
}
```

[cc-build-cpp]: https://docs.rs/cc/*/cc/struct.Build.html#method.cpp
