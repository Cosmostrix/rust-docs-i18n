# <!--About "Cookin' with Rust"--> 「クッキング・アンド・ルース」について

## <!--Table of contents--> 目次

- <!--[Who this book is for](#who-this-book-is-for)-->
   [この本の対象者](#who-this-book-is-for)
- <!--[How to read this book](#how-to-read-this-book)-->
   [この本を読むには](#how-to-read-this-book)
- <!--[How to use the recipes](#how-to-use-the-recipes)-->
   [レシピの使い方](#how-to-use-the-recipes)
- <!--[A note about error handling](#a-note-about-error-handling)-->
   [エラー処理に関する注意](#a-note-about-error-handling)
- <!--[A note about crate representation](#a-note-about-crate-representation)-->
   [クレート表現に関する注釈](#a-note-about-crate-representation)

## <!--Who this book is for--> この本の対象者

<!--This cookbook is intended for new Rust programmers, so that they may quickly get an overview of the capabilities of the Rust crate ecosystem.-->
この料理本は新しいRustプログラマーを対象としているので、Rust crateエコシステムの機能の概要をすぐに知ることができます。
<!--It is also intended for experienced Rust programmers, who should find in the recipes an easy reminder of how to accomplish common tasks.-->
また、レシピで一般的なタスクを達成する方法を簡単に思い出させる経験豊かなRustプログラマーを対象としています。

## <!--How to read this book--> この本を読むには

<!--The cookbook [index] contains the full list of recipes, organized into a number of sections: "basics", "encoding", "concurrency", etc. The sections themselves are more or less ordered in progression, with later sections being more advanced, and occasionally building on concepts from earlier sections.-->
料理本の[index]は、"基本"、"エンコーディング"、"並行性"などのいくつかのセクションに編成されたレシピの完全なリストが含まれています。セクション自体は、多かれ少なかれプログレッションで順序付けされ、以前のセクションのコンセプトを時々構築しています。

<!--Within the index, each section contains a list of recipes.-->
インデックス内には、各セクションにレシピのリストが含まれています。
<!--The recipes are simple statements of a task to accomplish, like "generate random numbers in a range";-->
レシピは、「範囲内の乱数を生成する」のように、達成するためのタスクの簡単なステートメントです。
<!--and each recipe is tagged with badges indicating which  _crates_  they use, like [!][rand]-->
各レシピにはどのような _クレジット_ が使用されているかを示すバッジが付いています[。][rand]
<!--[rand-badge], and which categories on [crates.io] those crates belong to, like [!][cat-science]-->
[rand-badge]、そしてどのカテゴリが[crates.io]カテゴリに属してい[ますか？][cat-science]
<!--[cat-science-badge].-->
[cat-science-badge]。

<!--New Rust programmers should be comfortable reading from the first section to the last, and doing so should give one a strong overview of the crate ecosystem.-->
新しいRustプログラマーは最初のセクションから最後のセクションまで読むのが快適でなければなりません。そうすることで、クレートの生態系を強く概観することができます。
<!--Click on the section header in the index, or in the sidebar to navigate to the page for that section of the book.-->
索引のセクションヘッダーまたはサイドバーをクリックして、ブックのそのセクションのページに移動します。

<!--If you are simply looking for the solution to a simple task, the cookbook is today more difficult to navigate.-->
単に単純なタスクの解決策を探しているのであれば、今日は料理の本をナビゲートするのが難しくなります。
<!--The easiest way to find a specific recipe is to scan the index looking for the crates and categories one is interested in. From there, click on the name of the recipe to view it.-->
特定のレシピを見つける最も簡単な方法は、索引をスキャンして、関心のあるクレートとカテゴリを探します。そこから、レシピの名前をクリックして表示します。
<!--This will improve in the future.-->
これは将来的に改善されるでしょう。

## <!--How to use the recipes--> レシピの使い方

<!--Recipes are designed to give you instant access to working code, along with a full explanation of what it is doing, and to guide you to further information.-->
レシピは、作業中のコードに瞬時にアクセスし、それが何をしているのかの詳細な説明と、さらに詳しい情報を案内するように設計されています。

<!--All recipes in the cookbook are full, self contained programs, so that they may be copied directly into your own projects for experimentation.-->
料理本のすべてのレシピは完全な自己完結型のプログラムなので、実験のために自分のプロジェクトに直接コピーすることができます。
<!--To do so follow the instructions below.-->
これを行うには、以下の手順に従ってください。

<!--Consider this example for "generate random numbers within a range":-->
次の例を「範囲内で乱数を生成する」ことを考えてみましょう。

<!--[!][rand]-->
[！][rand]
<!--[rand-badge] [!][cat-science]-->
[rand-badge] [！][cat-science]
[cat-science-badge]
```rust
extern crate rand;
use rand::Rng;

fn main() {
    let mut rng = rand::thread_rng();
    println!("Random f64: {}", rng.gen::<f64>());
}
```

<!--To work with it locally we can run the following commands to create a new cargo project, and change to that directory:-->
ローカルで作業するには、次のコマンドを実行して新しい貨物プロジェクトを作成し、そのディレクトリに移動します。


```sh
cargo new my-example --bin
cd my-example
```

<!--Now, we also need to add the necessary crates to [Cargo.toml], as indicated by the crate badges, in this case just "rand".-->
今度は、クレートバッジ、この場合は「ランド」で示されるように、必要なクレートを[Cargo.toml]に追加する必要があります。
<!--To do so, we'll use the `cargo add` command, which is provided by the [`cargo-edit`] crate, which we need to install first:-->
これを行うには、最初にインストールする必要がある[`cargo-edit`]クレートによって提供される`cargo add`コマンドを使用します。

```sh
cargo install cargo-edit
cargo add rand
```

<!--Now you can replace `src/main.rs` with the full contents of the example and run it:-->
`src/main.rs`を例の完全な内容に置き換えて実行することができます：

```sh
cargo run
```

<!--The crate badges that accompany the examples link to the crates' full documentation on [docs.rs], and is often the next documentation you should read after deciding which crate suites your purpose.-->
例に付随するクレートバッジは、[docs.rs]に関するクレートの完全なドキュメントにリンクしており、目的に合ったクレートスイートを決定した後で読むべき次のドキュメントです。

## <!--A note about error handling--> エラー処理に関する注意

<!--Error handling in Rust is robust when done correctly, but in today's Rust it requires a fair bit of boilerplate.-->
Rustのエラー処理は正しく行われると堅牢ですが、今日のRustではかなりの量の定型文が必要です。
<!--Because of this one often sees Rust examples filled with `unwrap` calls instead of proper error handling.-->
このため、適切なエラー処理ではなく、Rustの例が`unwrap`呼び出しで満たされていることがよくあります。

<!--Since these recipes are intended to be reused as-is and encourage best practices, they set up error handling correctly when there are `Result` types involved.-->
これらのレシピは、そのままの状態で再利用し、ベスト・プラクティスを奨励することを目的としているため、`Result`型が含まれている場合は、エラー処理が正しく設定されます。

<!--The basic pattern we use is to have a `fn run() -> Result` that acts like the "real"main function.-->
使用する基本パターンは、`fn run() -> Result`を "本物の"メイン関数のように動作させることです。
<!--We use the [error-chain] crate to make `?`-->
我々は、[error-chain]クレートを使用して`?`
<!--work within `run`.-->
`run`作業。

<!--The structure generally looks like:-->
構造は一般的に次のようになります。

```rust
#[macro_use]
extern crate error_chain;

use std::net::IpAddr;
use std::str;

error_chain! {
    foreign_links {
        Utf8(std::str::Utf8Error);
        AddrParse(std::net::AddrParseError);
    }
}

fn run() -> Result<()> {
    let bytes = b"2001:db8::1";

#    // Bytes to string.
    // 文字列へのバイト数。
    let s = str::from_utf8(bytes)?;

#    // String to IP address.
    //  IPアドレスへの文字列。
    let addr: IpAddr = s.parse()?;

    println!("{:?}", addr);
    Ok(())
}

quick_main!(run);
```

<!--This is using the `error_chain!` macro to define a custom `Error` and `Result` type, along with automatic conversions from two standard library error types.-->
これは、`error_chain!`マクロを使用してカスタムの`Error`および`Result`型を定義し、2つの標準ライブラリエラータイプからの自動変換を定義しています。
<!--The automatic conversions make the `?`-->
自動変換によって`?`
<!--operator work.-->
オペレータ作業。
<!--The `quick_main!` macro generates the actual `main` function and prints out the error if one occurred.-->
`quick_main!`マクロは実際の`main`関数を生成し、エラーが発生した場合はそれを出力します。

<!--For the sake of readability error handling boilerplate is hidden by default like below.-->
可読性のエラー処理のために、定型文は以下のようにデフォルトでは隠されています。
<!--In order to read full contents click on the "expand"(-->
完全な内容を読むためには、"expand"をクリックしてください（
** <!--) button located in the top right corner of the snippet.-->
）スニペットの右上隅にあるボタンをクリックします。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate url;

use url::{Url, Position};
#
# error_chain! {
#     foreign_links {
#         UrlParse(url::ParseError);
#     }
# }

fn run() -> Result<()> {
    let parsed = Url::parse("https://httpbin.org/cookies/set?k2=v2&k1=v1")?;
    let cleaned: &str = &parsed[..Position::AfterPath];
    println!("cleaned: {}", cleaned);
    Ok(())
}
#
# quick_main!(run);
```

<!--For more background on error handling in Rust, read [this page of the Rust book][error-docs] and [this blog post][error-blog].-->
Rustのエラー処理の背景について[は、Rustの本のこのページ][error-docs]と[このブログの記事を][error-blog]読んで[ください][error-docs]。

## <!--A note about crate representation--> クレート表現に関する注釈

<!--This cookbook is intended eventually to provide expansive coverage of the Rust crate ecosystem, but today is limited in scope while we get it bootstrapped and work on the presentation.-->
この料理本は、最終的に錆の生態系を広範囲にカバーすることを目的としていますが、今日は範囲が限定されており、ブートストラップしてプレゼンテーションに取り組んでいます。
<!--Hopefully, starting from a small scope and slowly expanding will help the cookbook become a high-quality resource sooner, and allow it to maintain consistent quality levels as it grows.-->
うまくいけば、小さな範囲から始まりゆっくりと広がることは、料理本書がより早く質の高いリソースになるのを助け、成長するにつれて一貫した品質レベルを維持することを望むでしょう。

<!--At present the cookbook is focused on the standard library, and on "core", or "foundational", crates—those crates that make up the most common programming tasks, and that the rest of the ecosystem builds off of.-->
現在、料理本は、標準ライブラリと、最も一般的なプログラミングタスクを構成する「コア」すなわち「基礎」のクレート（クレート）に焦点を当てています。残りのエコシステムは構築されています。

<!--The cookbook is closely tied to the [Rust Libz Blitz], a project to identify, and improve the quality of such crates, and so it largely defers crate selection to that project.-->
料理本は[Rust Libz Blitz]と密接に結びついています[Rust Libz Blitz]は、このような木箱の品質を確認し改善するプロジェクトです。
<!--Any crates that have already been evaluated as part of that process are in scope for the cookbook, as are crates that are pending evaluation.-->
そのプロセスの一部としてすでに評価されているクレートは、評価が保留中のクレートと同様に、クックブックの対象となります。

<!--{{#include links.md}}-->
{{#include links.md}}

<!--[index]: intro.html
 [error-docs]: https://doc.rust-lang.org/book/error-handling.html
 [error-blog]: https://brson.github.io/2016/11/30/starting-with-error-chain
 [error-chain]: https://docs.rs/error-chain/
 [Rust Libz Blitz]: https://internals.rust-lang.org/t/rust-libz-blitz/5184
 [crates.io]: https://crates.io
 [docs.rs]: https://docs.rs
 [Cargo.toml]: http://doc.crates.io/manifest.html
 [`cargo-edit`]: https://github.com/killercup/cargo-edit
-->
[index]: intro.html
 [error-docs]: https://doc.rust-lang.org/book/error-handling.html
 [error-blog]: https://brson.github.io/2016/11/30/starting-with-error-chain
 [error-chain]: https://docs.rs/error-chain/
 [Rust Libz Blitz]: https://internals.rust-lang.org/t/rust-libz-blitz/5184
 [crates.io]: https://crates.io
 [docs.rs]: https://docs.rs
 [Cargo.toml]: http://doc.crates.io/manifest.html
 [`cargo-edit`]: https://github.com/killercup/cargo-edit

