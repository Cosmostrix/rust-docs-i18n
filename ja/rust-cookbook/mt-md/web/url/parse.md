## <!--Parse a URL from a string to a `Url` type--> 文字列から`Url`型へのURLの解析

<!--[!][url]-->
[！][url]
<!--[url-badge] [!][cat-net]-->
[url-badge] [！][cat-net]
[cat-net-badge]
<!--The [`parse`] method from the `url` crate validates and parses a `&str` into a [`Url`] struct.-->
[`parse`]からメソッド`url`クレートは検証して解析する`&str`に[`Url`]構造体。
<!--The input string may be malformed so this method returns `Result<Url, ParseError>`.-->
このメソッドは`Result<Url, ParseError>`返すように入力文字列の形式が誤っている可能性があります。

<!--Once the URL has been parsed, it can be used with all of the methods in the `Url` type.-->
URLが解析されると、`Url`タイプのすべてのメソッドで使用できます。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate url;

use url::Url;
#
# error_chain! {
#     foreign_links {
#         UrlParse(url::ParseError);
#     }
# }

fn run() -> Result<()> {
    let s = "https://github.com/rust-lang/rust/issues?labels=E-easy&state=open";

    let parsed = Url::parse(s)?;
    println!("The path part of the URL is: {}", parsed.path());

    Ok(())
}
#
# quick_main!(run);
```

<!--[`parse`]: https://docs.rs/url/*/url/struct.Url.html#method.parse
 [`Url`]: https://docs.rs/url/*/url/struct.Url.html
-->
[`parse`]: https://docs.rs/url/*/url/struct.Url.html#method.parse
 [`Url`]: https://docs.rs/url/*/url/struct.Url.html
 [`parse`]: https://docs.rs/url/*/url/struct.Url.html#method.parse
 [`Url`]: https://docs.rs/url/*/url/struct.Url.html

