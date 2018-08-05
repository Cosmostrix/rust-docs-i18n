## <!--Percent-encode a string--> パーセントエンコードの文字列

<!--[!][url]-->
[！][url]
<!--[url-badge] [!][cat-encoding]-->
[url-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--Encode an input string with [percent-encoding] using the [`utf8_percent_encode`] function from the `percent-encoding` crate.-->
`percent-encoding`クレートからの[`utf8_percent_encode`]関数を使用して、[percent-encoding]入力文字列をエンコードします。
<!--Then decode using the [`percent_decode`] function.-->
その後、[`percent_decode`]関数を使ってデコードします。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate url;

use url::percent_encoding::{utf8_percent_encode, percent_decode, DEFAULT_ENCODE_SET};
#
# error_chain! {
#     foreign_links {
#         Utf8(std::str::Utf8Error);
#     }
# }

fn run() -> Result<()> {
    let input = "confident, productive systems programming";

    let iter = utf8_percent_encode(input, DEFAULT_ENCODE_SET);
    let encoded: String = iter.collect();
    assert_eq!(encoded, "confident,%20productive%20systems%20programming");

    let iter = percent_decode(encoded.as_bytes());
    let decoded = iter.decode_utf8()?;
    assert_eq!(decoded, "confident, productive systems programming");

    Ok(())
}
#
# quick_main!(run);
```

<!--The encode set defines which bytes (in addition to non-ASCII and controls) need to be percent-encoded.-->
エンコードセットは、（非ASCIIおよびコントロールに加えて）パーセントエンコードする必要があるバイトを定義します。
<!--The choice of this set depends on context.-->
このセットの選択は、文脈に依存する。
<!--For example, `url` encodes `?`-->
たとえば、`url`は`?`
<!--in a URL path but not in a query string.-->
URLパスには含まれていますが、クエリ文字列にはありません。

<!--The return value of encoding is an iterator of `&str` slices which collect into a `String`.-->
エンコーディングの戻り値は、`String`収集される`&str`スライスの反復子です。

<!--[`percent_decode`]: https://docs.rs/percent-encoding/*/percent_encoding/fn.percent_decode.html
 [`utf8_percent_encode`]: https://docs.rs/percent-encoding/*/percent_encoding/fn.utf8_percent_encode.html
-->
[`percent_decode`]: https://docs.rs/percent-encoding/*/percent_encoding/fn.percent_decode.html
 [`utf8_percent_encode`]: https://docs.rs/percent-encoding/*/percent_encoding/fn.utf8_percent_encode.html


[percent-encoding]: https://en.wikipedia.org/wiki/Percent-encoding
