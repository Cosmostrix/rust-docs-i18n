# <!--Transitioning your code to a new edition--> コードを新しいエディションに移行する

<!--New editions might change the way you write Rust --they add new syntax, language, and library features but also remove features.-->
新しい版では、構文、言語、ライブラリの新しい機能を追加するだけでなく、機能を削除するというRustの書き方も変わるかもしれません。
<!--For example, `async` / `await` are keywords in Rust 2018, but not Rust 2015. Despite this it's our intention that the migration to new editions is as smooth an experience as possible.-->
たとえば、`async` / `await`はRust 2018のキーワードですが、Rust 2015はありません。これにもかかわらず、新しいエディションへの移行は可能な限りスムーズな体験です。
<!--It's considered a bug if it's difficult to upgrade your crate to a new edition.-->
あなたのクレートを新しいエディションにアップグレードすることが難しい場合は、バグとみなされます。
<!--If you have a difficult time then a bug should be filed with Rust itself.-->
あなたが困難な場合は、バグをRust自身に提出する必要があります。

<!--Transitioning between editions is built around compiler lints.-->
エディション間の移行は、コンパイラlintsの周りに構築されます。
<!--Fundamentally, the process works like this:-->
基本的に、プロセスは次のように動作します。

* <!--Turn on lints to indicate where code is incompatible with a new edition-->
   lintをオンにして、コードが新しいエディションと互換性がない場所を示します
* <!--Get your code compiling with no warnings.-->
   警告なしでコードをコンパイルしてください。
* <!--Opt in to the new edition, the code should compile.-->
   新しい版にオプトインすると、コードがコンパイルされるはずです。
* <!--Optionally, enable lints about *idiomatic* code in the new edition.-->
   オプションで、新版の*慣用*コードに関するlintsを有効にします。

<!--Luckily, we've been working on Cargo to help assist with this process, culminating in a new built-in subcommand `cargo fix`.-->
幸いにも、私たちはこのプロセスを支援するために貨物に取り組んできました。新しいサブコマンド`cargo fix`完成しました。
<!--It can take suggestions from the compiler and automatically re-write your code to comply with new features and idioms, drastically reducing the number of warnings you need to fix manually!-->
コンパイラからの提案を受け取り、新しい機能やイディオムに準拠するようにコードを自動的に書き直し、手動で修正する必要がある警告の数を大幅に減らすことができます。

> <!--`cargo fix` is still quite young, and very much a work in development.-->
> `cargo fix`はまだかなり若く、非常に多くの開発作業です。
> <!--But it works for the basics!-->
> しかし、それは基本のために働く！
> <!--We're working hard on making it better and more robust, but please bear with us for now.-->
> 私たちはそれをより頑強にすることに熱心に取り組んでいますが、今は私たちと一緒にご負担ください。

## <!--The preview period--> プレビュー期間

<!--Before an edition is released, it will have a "preview"phase which lets you try out the new edition in nightly Rust before its release.-->
エディションがリリースされる前に、リリース前の夜間のRustで新しいエディションを試すことができる「プレビュー」フェーズがあります。
<!--Currently Rust 2018 is in its preview phase and because of this, there's an extra step you need to take to opt in. Add this feature flag to your `lib.rs` or `main.rs`:-->
現在、Rust 2018はプレビュー段階にあります。このため、オプトインするために必要なステップがあります。この機能フラグを`lib.rs`または`main.rs`追加してください：

```rust
#![feature(rust_2018_preview)]
```

<!--This will enable the unstable features listed in the [feature status][status] page.-->
これにより、[機能ステータス][status]ページに記載されている不安定な機能が有効になります。
<!--Note that some features require a miniumum of Rust 2018 and these features will require a Cargo.toml change to enable (described in the sections below).-->
いくつかの機能はRust 2018の最小値を必要とすることに注意してください。これらの機能には、Cargo.tomlの変更が必要です（以下のセクションで説明します）。
<!--Also note that during the time the preview is available, we may continue to add/enable new features with this flag!-->
また、プレビューが利用可能な間は、このフラグを使用して新しい機能を追加/有効にすることがあります。

[status]: 2018/status.html

## <!--Fix edition compatibility warnings--> 修正プログラムの互換性の警告を修正

<!--Next up is to enable compiler warnings about code which is incompatible with the new 2018 edition.-->
次に、新しい2018版と互換性のないコードについてのコンパイラの警告を有効にします。
<!--This is where the handy `cargo fix` tool comes into the picture.-->
これは、便利な`cargo fix`ツールが画像に入る場所です。
<!--To enable the compatibility lints for your project you run:-->
プロジェクトに互換性のあるlintを有効にするには：

```shell
$ cargo +nightly fix --prepare-for 2018 --all-targets --all-features
```

<!--This will instruct Cargo to compile all targets in your project (libraries, binaries, tests, etc.) while enabling all Cargo features and prepare them for the 2018 edition.-->
これにより、Cargoにすべての貨物の機能を有効にしながら、プロジェクトのすべてのターゲット（ライブラリ、バイナリ、テストなど）をコンパイルし、2018年版用に準備するように指示します。
<!--Cargo will likely automatically fix a number of files, informing you as it goes along.-->
Cargoは複数のファイルを自動的に修正して、それが進むにつれてあなたに通知します。
<!--Note that this does not enable any new Rust 2018 features;-->
これにより、Rust 2018の新しい機能は有効になりません。
<!--it only makes sure your code is compatible with Rust 2018.-->
あなたのコードはRust 2018と互換性があります。

<!--If Cargo can't automatically fix everything it'll print out the remaining warnings.-->
Cargoが自動的にすべてを修正できない場合は、残りの警告が表示されます。
<!--Continue to run the above command until all warnings have been solved.-->
すべての警告が解決されるまで上記のコマンドを実行し続けます。

<!--You can explore more about the `cargo fix` command with:-->
`cargo fix`コマンドの詳細については、次を参照してください。

```shell
$ cargo +nightly fix --help
```

## <!--Switch to the next edition--> 次のエディションに切り替える

<!--Once you're happy with those changes, it's time to use the new edition.-->
これらの変更に満足したら、新しいエディションを使用するときです。
<!--Add this to your `Cargo.toml`:-->
これをあなたの`Cargo.toml`追加してください：

```toml
cargo-features = ["edition"]

[package]
edition = '2018'
```

<!--That `cargo-features` line should go at the very top;-->
その`cargo-features`ラインは一番上になければなりません。
<!--and `edition` goes into the `[package]` section.-->
`edition`は`[package]`セクションに入ります。
<!--As mentioned above, right now this is a nightly-only feature of Cargo, so you need to enable it for things to work.-->
上記のように、今はこれが夜間のみの貨物の機能なので、機能させるためにはそれを有効にする必要があります。

<!--At this point, your project should compile with a regular old `cargo +nightly build`.-->
この時点で、プロジェクトは通常の古い`cargo +nightly build`コンパイルする必要があります。
<!--If it does not, this is a bug!-->
そうでなければ、これはバグです！
<!--Please [file an issue][issue].-->
[問題を提出して][issue]ください。

[issue]: https://github.com/rust-lang/rust/issues/new

## <!--Writing idiomatic code in a new edition--> 新版に慣用コードを書く

<!--Your crate has now entered the 2018 edition of Rust, congrats!-->
あなたの箱は今2018年版のRustに入りました、おめでとうございます！
<!--Recall though that Editions in Rust signify a shift in idioms over time.-->
RustのEditionsは時間の経過とともにイディオムの変化を示していることを思い出してください。
<!--While much old code will continue to compile it might be written with different idioms today.-->
多くの古いコードはコンパイルを続けるが、今日は異なるイディオムで記述される可能性がある。

<!--An optional next step you can take is to update your code to be idiomatic within the new edition.-->
オプションの次のステップは、新しいエディションでコードを慣用的に更新することです。
<!--This is done with a different set of "idiom lints".-->
これは "イディオムリント"の別のセットで行われます。
<!--To enable these lints add this to your `lib.rs` or `main.rs`:-->
これらのlintを有効にするには、これをあなたの`lib.rs`または`main.rs`追加してください：

```rust
#![warn(rust_2018_idioms)]
```

<!--and then execute:-->
実行します：

```shell
$ cargo +nightly fix
```

<!--As before Cargo will automatically fix as much as it can, but you may also need to fix some warnings manually.-->
前と同じように、Cargoは可能な限り自動的に修正されますが、いくつかの警告を手動で修正する必要があります。
<!--Once all warnings have been solved you're not only compiling with the 2018 edition but you're also already writing idiomatic 2018 code!-->
すべての警告が解決されたら、2018年版でコンパイルするだけでなく、すでに慣用的な2018年のコードを作成しています！
