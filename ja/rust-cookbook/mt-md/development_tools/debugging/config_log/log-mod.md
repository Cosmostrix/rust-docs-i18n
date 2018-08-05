## <!--Enable log levels per module--> モジュールごとのログレベルを有効にする

<!--[!][log]-->
[！][log]
<!--[log-badge] [!][env_logger]-->
[log-badge] [！][env_logger]
<!--[env_logger-badge] [!][cat-debugging]-->
[env_logger-badge] [！][cat-debugging]
[cat-debugging-badge]
<!--Creates two modules `foo` and nested `foo::bar` with logging directives controlled separately with [`RUST_LOG`] environmental variable.-->
[`RUST_LOG`]環境変数で個別に制御されたロギング指令を持つ`foo`と`foo::bar` 2つのモジュールを作成します。

```rust
#[macro_use]
extern crate log;
extern crate env_logger;

mod foo {
    mod bar {
        pub fn run() {
            warn!("[bar] warn");
            info!("[bar] info");
            debug!("[bar] debug");
        }
    }

    pub fn run() {
        warn!("[foo] warn");
        info!("[foo] info");
        debug!("[foo] debug");
        bar::run();
    }
}

fn main() {
    env_logger::init();
    warn!("[root] warn");
    info!("[root] info");
    debug!("[root] debug");
    foo::run();
}
```

<!--[`RUST_LOG`] environment variable controls [`env_logger`][env_logger] output.-->
[`RUST_LOG`]環境変数は[`env_logger`][env_logger]出力を制御します。
<!--Module declarations take comma separated entries formatted like `path::to::module=log_level`.-->
モジュール宣言は、`path::to::module=log_level`ようにフォーマットされたカンマ区切りのエントリを取ります。
<!--Run the `test` application as follows:-->
次のように`test`アプリケーションを実行します。

```bash
RUST_LOG="warn,test::foo=info,test::foo::bar=debug" ./test
```

<!--Sets the default [`log::Level`] to `warn`, module `foo` and module `foo::bar` to `info` and `debug`.-->
デフォルトの[`log::Level`]を`warn`、モジュール`foo`とモジュール`foo::bar`を`info`と`debug`ます。

```bash
WARN:test: [root] warn
WARN:test::foo: [foo] warn
INFO:test::foo: [foo] info
WARN:test::foo::bar: [bar] warn
INFO:test::foo::bar: [bar] info
DEBUG:test::foo::bar: [bar] debug
```

<!--[`log::Level`]: https://docs.rs/log/*/log/enum.Level.html
 [`RUST_LOG`]: https://docs.rs/env_logger/*/env_logger/#enabling-logging
-->
[`log::Level`]: https://docs.rs/log/*/log/enum.Level.html
 [`RUST_LOG`]: https://docs.rs/env_logger/*/env_logger/#enabling-logging

