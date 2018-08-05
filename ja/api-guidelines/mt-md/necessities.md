# <!--Necessities--> 必要性


<span id="c-stable"></span><!--## Public dependencies of a stable crate are stable (C-STABLE)-->
安定したクレートのパブリック依存関係は安定している（C-STABLE）

<!--A crate cannot be stable (>=1.0.0) without all of its public dependencies being stable.-->
クレートは、パブリック依存関係のすべてが安定していなくても、安定（> = 1.0.0）することはできません。

<!--Public dependencies are crates from which types are used in the public API of the current crate.-->
パブリック依存関係は、現在のクレートのパブリックAPIでタイプが使用されているクレートです。

```rust
pub fn do_my_thing(arg: other_crate::TheirThing) { /* ... */ }
```

<!--A crate containing this function cannot be stable unless `other_crate` is also stable.-->
`other_crate`も安定しない限り、この関数を含む木枠は安定していません。

<!--Be careful because public dependencies can sneak in at unexpected places.-->
予期しない場所でパブリックな依存関係が忍び込む可能性があるので注意してください。

```rust
pub struct Error {
    private: ErrorImpl,
}

enum ErrorImpl {
    Io(io::Error),
#    // Should be okay even if other_crate isn't
#    // stable, because ErrorImpl is private.
    //  ErrorImplがプライベートなので、other_crateが安定していなくても大丈夫です。
    Dep(other_crate::Error),
}

#// Oh no! This puts other_crate into the public API
#// of the current crate.
// あらいやだ！これはother_crateを現在のクレートのパブリックAPIに置きます。
impl From<other_crate::Error> for Error {
    fn from(err: other_crate::Error) -> Self {
        Error { private: ErrorImpl::Dep(err) }
    }
}
```


<span id="c-permissive"></span><!--## Crate and its dependencies have a permissive license (C-PERMISSIVE)-->
##クレートとその依存関係には許容ライセンス（C-PERMISSIVE）があります。

<!--The software produced by the Rust project is dual-licensed, under either the [MIT] or [Apache 2.0] licenses.-->
Rustプロジェクトで作成されたソフトウェアは、[MIT]または[Apache 2.0]ライセンスのもとで、二重ライセンスを取得しています。
<!--Crates that simply need the maximum compatibility with the Rust ecosystem are recommended to do the same, in the manner described herein.-->
Rustエコシステムとの最大限の互換性が必要なクレートは、ここに記載されている方法でこれを行うことをお勧めします。
<!--Other options are described below.-->
その他のオプションについては後述します。

<!--These API guidelines do not provide a detailed explanation of Rust's license, but there is a small amount said in the [Rust FAQ].-->
これらのAPIガイドラインでは、Rustのライセンスの詳細な説明はありませんが、[Rust FAQ]には[Rust FAQ]ます。
<!--These guidelines are concerned with matters of interoperability with Rust, and are not comprehensive over licensing options.-->
これらのガイドラインは、Rustとの相互運用性の問題に関係しており、ライセンスオプションについて包括的ではありません。

<!--[MIT]: https://github.com/rust-lang/rust/blob/master/LICENSE-MIT
 [Apache 2.0]: https://github.com/rust-lang/rust/blob/master/LICENSE-APACHE
 [Rust FAQ]: https://www.rust-lang.org/en-US/faq.html#why-a-dual-mit-asl2-license
-->
[MIT]: https://github.com/rust-lang/rust/blob/master/LICENSE-MIT
 [Apache 2.0]: https://github.com/rust-lang/rust/blob/master/LICENSE-APACHE
 [Rust FAQ]: https://www.rust-lang.org/en-US/faq.html#why-a-dual-mit-asl2-license


<!--To apply the Rust license to your project, define the `license` field in your `Cargo.toml` as:-->
Rustライセンスをプロジェクトに適用するには、`Cargo.toml` `license`フィールドを次のように定義します。

```toml
[package]
name = "..."
version = "..."
authors = ["..."]
license = "MIT OR Apache-2.0"
```

<!--And toward the end of your README.md:-->
あなたのREADME.mdの終わりに向かって：

```
## License

Licensed under either of

 * Apache License, Version 2.0
   ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
 * MIT license
   ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

## Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.
```

<!--Besides the dual MIT/Apache-2.0 license, another common licensing approach used by Rust crate authors is to apply a single permissive license such as MIT or BSD.-->
デュアルMIT / Apache-2.0ライセンスの他に、Rust crateの著者が使用しているもう1つの一般的なライセンス・アプローチは、MITやBSDなどの単一の許容ライセンスを適用することです。
<!--This license scheme is also entirely compatible with Rust's, because it imposes the minimal restrictions of Rust's MIT license.-->
このライセンススキームは、RustのMITライセンスの最小限の制限を課すため、Rustと完全に互換性があります。

<!--Crates that desire perfect license compatibility with Rust are not recommended to choose only the Apache license.-->
Rustとの完全なライセンス互換性を望むクレートは、Apacheライセンスだけを選択することはお勧めしません。
<!--The Apache license, though it is a permissive license, imposes restrictions beyond the MIT and BSD licenses that can discourage or prevent their use in some scenarios, so Apache-only software cannot be used in some situations where most of the Rust runtime stack can.-->
Apacheライセンスは、許可されたライセンスですが、MITおよびBSDライセンスを超えていくつかのシナリオでの使用を阻止または阻止する制限が課せられているため、Rustランタイムスタックのほとんどが使用できる状況ではApache専用ソフトウェアを使用できません。

<!--The license of a crate's dependencies can affect the restrictions on distribution of the crate itself, so a permissively-licensed crate should generally only depend on permissively-licensed crates.-->
クレートの依存関係のライセンスは、クレート自体の配布に関する制限に影響する可能性があるため、許可されたクレートは一般に許可されたクレートにのみ依存する必要があります。
