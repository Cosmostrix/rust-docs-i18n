## <!--Create a base URL by removing path segments--> パスセグメントを削除してベースURLを作成する

<!--[!][url]-->
[！][url]
<!--[url-badge] [!][cat-net]-->
[url-badge] [！][cat-net]
[cat-net-badge]
<!--A base URL includes a protocol and a domain.-->
ベースURLには、プロトコルとドメインが含まれます。
<!--Base URLs have no folders, files or query strings.-->
ベースURLには、フォルダ、ファイル、またはクエリ文字列はありません。
<!--Each of those items are stripped out of the given URL.-->
これらの各アイテムは、指定されたURLから削除されます。
<!--[`PathSegmentsMut::clear`] removes paths and [`Url::set_query`] removes query string.-->
[`PathSegmentsMut::clear`]はパスを削除し、[`Url::set_query`]はクエリ文字列を削除します。

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
#     errors {
#         CannotBeABase
#     }
# }

fn run() -> Result<()> {
    let full = "https://github.com/rust-lang/cargo?asdf";

    let url = Url::parse(full)?;
    let base = base_url(url)?;

    assert_eq!(base.as_str(), "https://github.com/");
    println!("The base of the URL is: {}", base);

    Ok(())
}

fn base_url(mut url: Url) -> Result<Url> {
    match url.path_segments_mut() {
        Ok(mut path) => {
            path.clear();
        }
        Err(_) => {
            return Err(Error::from_kind(ErrorKind::CannotBeABase));
        }
    }

    url.set_query(None);

    Ok(url)
}
#
# quick_main!(run);
```

<!--[`PathSegmentsMut::clear`]: https://docs.rs/url/*/url/struct.PathSegmentsMut.html#method.clear
 [`Url::set_query`]: https://docs.rs/url/*/url/struct.Url.html#method.set_query
-->
[`PathSegmentsMut::clear`]: https://docs.rs/url/*/url/struct.PathSegmentsMut.html#method.clear
 [`Url::set_query`]: https://docs.rs/url/*/url/struct.Url.html#method.set_query

