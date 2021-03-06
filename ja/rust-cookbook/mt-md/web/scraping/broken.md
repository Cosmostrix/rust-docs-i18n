## <!--Check a webpage for broken links--> Webページで壊れたリンクを確認する

<!--[!][reqwest]-->
[！][reqwest]
<!--[reqwest-badge] [!][select]-->
[reqwest-badge] [！][select]
<!--[select-badge] [!][url]-->
[select-badge] [！][url]
<!--[url-badge] [!][cat-net]-->
[url-badge] [！][cat-net]
[cat-net-badge]
<!--Call `get_base_url` to retrieve the base URL.-->
`get_base_url`を呼び出してベースURLを取得します。
<!--If the document has a base tag, get the href [`attr`] from base tag.-->
ドキュメントにベースタグがある場合は、ベースタグからhref [`attr`]取得します。
<!--[`Position::BeforePath`] of the original URL acts as a default.-->
元のURLの[`Position::BeforePath`]がデフォルトとして機能します。

<!--Iterate through links in the document and parse with [`url::ParseOptions`] and [`Url::parse`]).-->
ドキュメント内のリンクを繰り返し、[`url::ParseOptions`]と[`Url::parse`] [`url::ParseOptions`] [`Url::parse`]）。
<!--Makes a request to the links with reqwest and verifies [`StatusCode`].-->
reqwestとのリンクを要求し、[`StatusCode`]を確認し[`StatusCode`]。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate reqwest;
extern crate select;
extern crate url;

use std::collections::HashSet;

use url::{Url, Position};
use reqwest::StatusCode;
use select::document::Document;
use select::predicate::Name;
#
# error_chain! {
#   foreign_links {
#       ReqError(reqwest::Error);
#       IoError(std::io::Error);
#       UrlParseError(url::ParseError);
#   }
# }

fn get_base_url(url: &Url, doc: &Document) -> Result<Url> {
    let base_tag_href = doc.find(Name("base")).filter_map(|n| n.attr("href")).nth(0);

    let base_url = base_tag_href.map_or_else(
        || Url::parse(&url[..Position::BeforePath]),
        Url::parse,
    )?;

    Ok(base_url)
}

fn check_link(url: &Url) -> Result<bool> {
    let res = reqwest::get(url.as_ref())?;

    Ok(res.status() != StatusCode::NotFound)
}

fn run() -> Result<()> {
    let url = Url::parse("https://www.rust-lang.org/en-US/")?;

    let res = reqwest::get(url.as_ref())?;
    let document = Document::from_read(res)?;

    let base_url = get_base_url(&url, &document)?;

    let base_parser = Url::options().base_url(Some(&base_url));

    let links: HashSet<Url> = document
        .find(Name("a"))
        .filter_map(|n| n.attr("href"))
        .filter_map(|link| base_parser.parse(link).ok())
        .collect();

    links
        .iter()
        .filter(|link| check_link(link).ok() == Some(false))
        .for_each(|x| println!("{} is broken.", x));

    Ok(())
}
#
# quick_main!(run);
```

<!--[`attr`]: https://docs.rs/select/*/select/node/struct.Node.html#method.attr
 [`Position::BeforePath`]: https://docs.rs/url/*/url/enum.Position.html#variant.BeforePath
 [`StatusCode`]: https://docs.rs/reqwest/*/reqwest/enum.StatusCode.html
 [`url::Parse`]: https://docs.rs/url/*/url/struct.Url.html#method.parse
 [`url::ParseOptions`]: https://docs.rs/url/*/url/struct.ParseOptions.html
-->
[`attr`]: https://docs.rs/select/*/select/node/struct.Node.html#method.attr
 [`Position::BeforePath`]: https://docs.rs/url/*/url/enum.Position.html#variant.BeforePath
 [`StatusCode`]: https://docs.rs/reqwest/*/reqwest/enum.StatusCode.html
 [`url::Parse`]: https://docs.rs/url/*/url/struct.Url.html#method.parse
 [`url::ParseOptions`]: https://docs.rs/url/*/url/struct.ParseOptions.html

