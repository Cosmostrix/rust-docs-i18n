## <!--Extract the URL origin (scheme / host / port)--> URL原点（scheme / host / port）を抽出します。

<!--[!][url]-->
[！][url]
<!--[url-badge] [!][cat-net]-->
[url-badge] [！][cat-net]
[cat-net-badge]
<!--The [`Url`] struct exposes various methods to extract information about the URL it represents.-->
[`Url`]構造体は、それが表すURLに関する情報を抽出するさまざまなメソッドを公開します。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate url;

use url::{Url, Host};

# error_chain! {
#     foreign_links {
#         UrlParse(url::ParseError);
#     }
# }
#
fn run() -> Result<()> {
    let s = "ftp://rust-lang.org/examples";

    let url = Url::parse(s)?;

    assert_eq!(url.scheme(), "ftp");
    assert_eq!(url.host(), Some(Host::Domain("rust-lang.org")));
    assert_eq!(url.port_or_known_default(), Some(21));
    println!("The origin is as expected!");

    Ok(())
}
#
# quick_main!(run);
```

<!--[`origin`] produces the same result.-->
[`origin`]は同じ結果をもたらします。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate url;

use url::{Url, Origin, Host};

# error_chain! {
#     foreign_links {
#         UrlParse(url::ParseError);
#     }
# }
#
fn run() -> Result<()> {
    let s = "ftp://rust-lang.org/examples";

    let url = Url::parse(s)?;

    let expected_scheme = "ftp".to_owned();
    let expected_host = Host::Domain("rust-lang.org".to_owned());
    let expected_port = 21;
    let expected = Origin::Tuple(expected_scheme, expected_host, expected_port);

    let origin = url.origin();
    assert_eq!(origin, expected);
    println!("The origin is as expected!");

    Ok(())
}
#
# quick_main!(run);
```

<!--[`origin`]: https://docs.rs/url/*/url/struct.Url.html#method.origin
 [`Url`]: https://docs.rs/url/*/url/struct.Url.html
-->
[`origin`]: https://docs.rs/url/*/url/struct.Url.html#method.origin
 [`Url`]: https://docs.rs/url/*/url/struct.Url.html

