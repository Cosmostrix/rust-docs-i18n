## <!--Extract all unique links from a MediaWiki markup--> MediaWikiのマークアップからすべてのユニークなリンクを抽出する

<!--[!][reqwest]-->
[！][reqwest]
<!--[reqwest-badge] [!][regex]-->
[reqwest-badge] [！][regex]
<!--[regex-badge] [!][cat-net]-->
[regex-badge] [！][cat-net]
[cat-net-badge]
<!--Pull the source of a MediaWiki page using [`reqwest::get`] and then look for all entries of internal and external links with [`Regex::captures_iter`].-->
[`reqwest::get`]を使ってMediaWikiページのソースを引っ張り、[`Regex::captures_iter`]で内部リンクと外部リンクのすべてのエントリを探します。
<!--Using [`Cow`] avoids excessive [`String`] allocations.-->
[`Cow`]を使うと[`Cow`]過剰な[`String`]割り当てを避けることができます。

<!--MediaWiki link syntax is described [here][MediaWiki%20link%20syntax].-->
[here][MediaWiki%20link%20syntax]は、MediaWikiのリンク構文について説明し[here][MediaWiki%20link%20syntax]。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
#[macro_use]
extern crate lazy_static;
extern crate reqwest;
extern crate regex;

use std::io::Read;
use std::collections::HashSet;
use std::borrow::Cow;
use regex::Regex;

# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#         Reqwest(reqwest::Error);
#         Regex(regex::Error);
#     }
# }
#
fn extract_links(content: &str) -> Result<HashSet<Cow<str>>> {
    lazy_static! {
        static ref WIKI_REGEX: Regex =
            Regex::new(r"(?x)
                \[\[(?P<internal>[^\[\]|]*)[^\[\]]*\]\]    # internal links
                |
                (url=|URL\||\[)(?P<external>http.*?)[ \|}] # external links
            ").unwrap();
    }

    let links: HashSet<_> = WIKI_REGEX
        .captures_iter(content)
        .map(|c| match (c.name("internal"), c.name("external")) {
            (Some(val), None) => Cow::from(val.as_str().to_lowercase()),
            (None, Some(val)) => Cow::from(val.as_str()),
            _ => unreachable!(),
        })
        .collect();

    Ok(links)
}

fn run() -> Result<()> {
    let mut content = String::new();
    reqwest::get(
        "https://en.wikipedia.org/w/index.php?title=Rust_(programming_language)&action=raw",
    )?
        .read_to_string(&mut content)?;

    println!("{:#?}", extract_links(&content)?);

    Ok(())
}
#
# quick_main!(run);
```

<!--[`Cow`]: https://doc.rust-lang.org/std/borrow/enum.Cow.html
 [`reqwest::get`]: https://docs.rs/reqwest/*/reqwest/fn.get.html
 [`Regex::captures_iter`]: https://docs.rs/regex/*/regex/struct.Regex.html#method.captures_iter
 [`String`]: https://doc.rust-lang.org/std/string/struct.String.html
-->
[`Cow`]: https://doc.rust-lang.org/std/borrow/enum.Cow.html
 [`reqwest::get`]: https://docs.rs/reqwest/*/reqwest/fn.get.html
 [`Regex::captures_iter`]: https://docs.rs/regex/*/regex/struct.Regex.html#method.captures_iter
 [`String`]: https://doc.rust-lang.org/std/string/struct.String.html


[MediaWiki link syntax]: https://www.mediawiki.org/wiki/Help:Links
