## <!--Encode a string as application/x-www-form-urlencoded--> application / x-www-form-urlencodedとして文字列をエンコードする

<!--[!][url]-->
[！][url]
<!--[url-badge] [!][cat-encoding]-->
[url-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--Encodes a string into [application/x-www-form-urlencoded] syntax using the [`form_urlencoded::byte_serialize`] and subsequently decodes it with [`form_urlencoded::parse`].-->
文字列エンコード[application/x-www-form-urlencoded]使用する構文[`form_urlencoded::byte_serialize`]し、その後でそれをデコード[`form_urlencoded::parse`]。
<!--Both functions return iterators that collect into a `String`.-->
どちらの関数も、`String`集めるイテレータを返します。

```rust
extern crate url;
use url::form_urlencoded::{byte_serialize, parse};

fn main() {
    let urlencoded: String = byte_serialize("What is â ¤?".as_bytes()).collect();
    assert_eq!(urlencoded, "What+is+%E2%9D%A4%3F");
    println!("urlencoded:'{}'", urlencoded);

    let decoded: String = parse(urlencoded.as_bytes())
        .map(|(key, val)| [key, val].concat())
        .collect();
    assert_eq!(decoded, "What is â ¤?");
    println!("decoded:'{}'", decoded);
}
```

<!--[`form_urlencoded::byte_serialize`]: https://docs.rs/url/*/url/form_urlencoded/fn.byte_serialize.html
 [`form_urlencoded::parse`]: https://docs.rs/url/*/url/form_urlencoded/fn.parse.html
-->
[`form_urlencoded::byte_serialize`]: https://docs.rs/url/*/url/form_urlencoded/fn.byte_serialize.html
 [`form_urlencoded::parse`]: https://docs.rs/url/*/url/form_urlencoded/fn.parse.html


[application/x-www-form-urlencoded]: https://url.spec.whatwg.org/#application/x-www-form-urlencoded
