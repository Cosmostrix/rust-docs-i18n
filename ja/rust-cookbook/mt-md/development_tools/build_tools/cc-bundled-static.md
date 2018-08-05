## <!--Compile and link statically to a bundled C library--> バンドルされたCライブラリに静的にコンパイルおよびリンクする

<!--[!][cc]-->
[！][cc]
<!--[cc-badge] [!][cat-development-tools]-->
[cc-badge] [！][cat-development-tools]
[cat-development-tools-badge]
<!--To accommodate scenarios where additional C, C++, or assembly is required in a project, the [**cc**][cc] crate offers a simple api for compiling bundled C/C++/asm code into static libraries (**.a**) that can be statically linked to by **rustc**.-->
追加のC、C ++、又はアセンブリは、プロジェクトに必要とされるシナリオに対応するために、[**cc**][cc]クレート静的**rustc**によって連結することができるスタティックライブラリ**（.A）**にバンドルC / C ++ /アセンブラコードをコンパイルするためのシンプルなAPIを提供します。

<!--The following example has some bundled C code (**src/hello.c**) that will be used from rust.-->
次の例には、錆から使用されるいくつかのバンドルされたCコード（**src / hello.c**）があります。
<!--Before compiling rust source code, the "build"file (**build.rs**) specified in **Cargo.toml** runs.-->
さびソースコードをコンパイルする前に、**Cargo.tomlで**指定された "build"ファイル（**build.rs**）が実行されます。
<!--Using the [**cc**][cc] crate, a static library file will be produced (in this case, **libhello.a**, see [`compile` docs][cc-build-compile]) which can then be used from rust by declaring the external function signatures in an `extern` block.-->
[**cc**][cc] crateを使用すると、スタティックライブラリファイル（この場合は**libhello.a**、 [`compile` docsを][cc-build-compile]参照）が生成され、`extern`ブロック内に外部関数のシグネチャを宣言して錆から使用することができます。

<!--Since the bundled C is very simple, only a single source file needs to be passed to [`cc::Build`][cc-build].-->
バンドルされたCは非常に単純なので、[`cc::Build`][cc-build]渡す必要のあるソースファイルは1つだけです。
<!--For more complex build requirements, [`cc::Build`][cc-build] offers a full suite of builder methods for specifying [`include`][cc-build-include] paths and extra compiler [`flag`][cc-build-flag] s.-->
より複雑なビルド要件の場合、[`cc::Build`][cc-build]は、[`include`][cc-build-include]パスと追加のコンパイラ[`flag`][cc-build-flag]を指定するための[`cc::Build`][cc-build]メソッドの完全なスイートを提供します。

### `Cargo.toml`
```toml
[package]
...
build = "build.rs"

[build-dependencies]
cc = "1"

[dependencies]
error-chain = "0.11"
```

### `build.rs`
```rust,no_run
extern crate cc;

fn main() {
    cc::Build::new()
        .file("src/hello.c")
#//        .compile("hello");   // outputs `libhello.a`
        .compile("hello");   //  `libhello.a`出力する
}
```

### `src/hello.c`
```c
#include <stdio.h>


void hello() {
    printf("Hello from C!\n");
}

void greet(const char* name) {
    printf("Hello, %s!\n", name);
}
```

### `src/main.rs`
```rust,ignore
# #[macro_use] extern crate error_chain;
use std::ffi::CString;
use std::os::raw::c_char;
#
# error_chain! {
#     foreign_links {
#         NulError(::std::ffi::NulError);
#         Io(::std::io::Error);
#     }
# }
#
# fn prompt(s: &str) -> Result<String> {
#     use std::io::Write;
#     print!("{}", s);
#     std::io::stdout().flush()?;
#     let mut input = String::new();
#     std::io::stdin().read_line(&mut input)?;
#     Ok(input.trim().to_string())
# }

extern {
    fn hello();
    fn greet(name: *const c_char);
}

fn run() -> Result<()> {
    unsafe { hello() }
    let name = prompt("What's your name? ")?;
    let c_name = CString::new(name)?;
    unsafe { greet(c_name.as_ptr()) }
    Ok(())
}
#
# quick_main!(run);
```

<!--[`cc::Build::define`]: https://docs.rs/cc/*/cc/struct.Build.html#method.define
 [`Option`]: https://doc.rust-lang.org/std/option/enum.Option.html
 [cc-build-compile]: https://docs.rs/cc/*/cc/struct.Build.html#method.compile
 [cc-build-cpp]: https://docs.rs/cc/*/cc/struct.Build.html#method.cpp
 [cc-build-flag]: https://docs.rs/cc/*/cc/struct.Build.html#method.flag
 [cc-build-include]: https://docs.rs/cc/*/cc/struct.Build.html#method.include
 [cc-build]: https://docs.rs/cc/*/cc/struct.Build.html
-->
[`cc::Build::define`]: https://docs.rs/cc/*/cc/struct.Build.html#method.define
 [`Option`]: https://doc.rust-lang.org/std/option/enum.Option.html
 [cc-build-compile]: https://docs.rs/cc/*/cc/struct.Build.html#method.compile
 [cc-build-cpp]: https://docs.rs/cc/*/cc/struct.Build.html#method.cpp
 [cc-build-flag]: https://docs.rs/cc/*/cc/struct.Build.html#method.flag
 [cc-build-include]: https://docs.rs/cc/*/cc/struct.Build.html#method.include
 [cc-build]: https://docs.rs/cc/*/cc/struct.Build.html

