# <!--Dependencies--> 依存関係

<!--Most programs have dependencies on some libraries.-->
ほとんどのプログラムはいくつかのライブラリに依存しています。
<!--If you have ever managed dependencies by hand, you know how much of a pain this can be.-->
依存関係を手で管理したことがあれば、どれくらいの苦痛があるかも知っています。
<!--Luckily, the Rust ecosystem comes standard with `cargo`!-->
幸いなことに、Rustエコシステムには`cargo`が標準装備されています！
<!--`cargo` can manage dependencies for a project.-->
`cargo`はプロジェクトの依存関係を管理できます。

<!--To create a new Rust project,-->
新しいRustプロジェクトを作成するには、

```sh
# A binary
cargo new foo

# OR A library
cargo new --lib foo
```

<!--For the rest of this chapter, I will assume we are making a binary, rather than a library, but all of the concepts are the same.-->
この章の残りの部分では、ライブラリではなくバイナリを作っていると仮定しますが、すべての概念は同じです。

<!--After the above commands, you should see something like this:-->
上記のコマンドの後、あなたは次のようなものを見なければなりません：

```txt
foo
├── Cargo.toml
└── src
    └── main.rs
```

<!--The `main.rs` is the root source file for your new project --nothing new there.-->
`main.rs`は新しいプロジェクトのルートソースファイルです。新しいものはありません。
<!--The `Cargo.toml` is the config file for `cargo` for this project (`foo`).-->
`Cargo.toml`は、このプロジェクト（`foo`）用の`cargo`の設定ファイルです。
<!--If you look inside it, you should see something like this:-->
内部を見ると、次のような表示になります。

```toml
[package]
name = "foo"
version = "0.1.0"
authors = ["mark"]

[dependencies]
```

<!--The `name` field under `package` determines the name of the project.-->
`package`の`name`フィールドは、プロジェクトの名前を決定します。
<!--This is used by `crates.io` if you publish the crate (more later).-->
これは、あなたがクレートを公開した場合（後で）、`crates.io`によって使用されます。
<!--It is also the name of the output binary when you compile.-->
コンパイル時の出力バイナリの名前でもあります。

<!--The `version` field is a crate version number using [Semantic Versioning](http://semver.org/).-->
`version`フィールドは、[Semantic Versioning](http://semver.org/)を使用するクレートバージョン番号です。

<!--The `authors` field is a list of authors used when publishing the crate.-->
`authors`フィールドは、クレートを発行するときに使用される著者のリストです。

<!--The `dependencies` section lets you add a dependency for your project.-->
`dependencies`セクションでは、プロジェクトの依存関係を追加できます。

<!--For example, suppose that I want my program to have a great CLI.-->
たとえば、自分のプログラムに素晴らしいCLIを持たせたいとします。
<!--You can find lots of great packages on [crates.io](https://crates.io) (the official Rust package registry).-->
[crates.io](https://crates.io)（Rustパッケージレジストリの公式[crates.io](https://crates.io)）にたくさんの素晴らしいパッケージがあります。
<!--One popular choice is [clap](https://crates.io/crates/clap).-->
1つの一般的な選択肢は[clap](https://crates.io/crates/clap)です。
<!--As of this writing, the most recent published version of `clap` is `2.27.1`.-->
この記事の執筆時点では、最新の公開されたバージョンの`clap`は`2.27.1`です。
<!--To add a dependency to our program, we can simply add the following to our `Cargo.toml` under `dependencies`: `clap = "2.27.1"`.-->
私たちのプログラムに依存関係を追加するには、我々は単に私たちに以下を追加することができます`Cargo.toml`下`dependencies`： `clap = "2.27.1"`。
<!--And of course, `extern crate clap` in `main.rs`, just like normal.-->
そして、もちろん、通常のように`main.rs` `extern crate clap` `main.rs` `extern crate clap`。
<!--And that's it!-->
以上です！
<!--You can start using `clap` in your program.-->
あなたはあなたのプログラムで`clap`を使うことができます。

<!--`cargo` also supports [other types of dependencies][dependencies].-->
`cargo`は[他のタイプの依存性][dependencies]もサポートして[います][dependencies]。
<!--Here is just a small sampling:-->
ここにちょっとしたサンプルがあります：

```toml
[package]
name = "foo"
version = "0.1.0"
authors = ["mark"]

[dependencies]
clap = "2.27.1" # from crates.io
rand = { git = "https://github.com/rust-lang-nursery/rand" } # from online repo
bar = { path = "../bar" } # from a path in the local filesystem
```

<!--`cargo` is more than a dependency manager.-->
`cargo`は依存マネージャー以上のものです。
<!--All of the available configuration options are listed in the [format specification][manifest] of `Cargo.toml`.-->
使用可能なすべての設定オプションは、`Cargo.toml` [書式仕様][manifest]にリストされてい[ます][manifest]。

<!--To build our project we can execute `cargo build` anywhere in the project directory (including subdirectories!).-->
私たちのプロジェクトを`cargo build`に、プロジェクトディレクトリ（サブディレクトリを含む）のどこにでも`cargo build`を実行することができます。
<!--We can also do `cargo run` to build and run.-->
また、`cargo run`を行い、ビルドして運行`cargo run`こともできます。
<!--Notice that these commands will resolve all dependencies, download crates if needed, and build everything, including your crate.-->
これらのコマンドはすべての依存関係を解決し、必要に応じてクレートをダウンロードし、クレートを含むすべてをビルドすることに注意してください。
<!--(Note that it only rebuilds what it has not already built, similar to `make`).-->
（`make`と同様に、まだビルドしていないものだけを再構築することに注意してください）。

<!--Voila!-->
Voila！
<!--That's all there is to it!-->
それはすべてそこにある！


<!--[manifest]: https://doc.rust-lang.org/cargo/reference/manifest.html
 [dependencies]: https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html
-->
[dependencies]: https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html
 [manifest]: https://doc.rust-lang.org/cargo/reference/manifest.html

