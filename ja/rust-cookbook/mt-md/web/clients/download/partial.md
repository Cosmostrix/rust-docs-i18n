## <!--Make a partial download with HTTP range headers--> HTTP範囲ヘッダーで部分的にダウンロードする

<!--[!][reqwest]-->
[！][reqwest]
<!--[reqwest-badge] [!][cat-net]-->
[reqwest-badge] [！][cat-net]
[cat-net-badge]
<!--Uses [`reqwest::Client::head`] to get the content-length and validates the server setting the header [`reqwest::header::ContentRange`].-->
[`reqwest::Client::head`]を使用してコンテンツ長を取得し、ヘッダ[`reqwest::header::ContentRange`]設定するサーバを検証します。

<!--If supported, downloads the content using [`reqwest::get`] by setting the [`reqwest::header::Range`] to do partial downloads printing basic progress messages in chunks of 10240 bytes.-->
サポートされている場合は、[`reqwest::header::Range`]を設定して、10240バイトのチャンクで基本的な進捗メッセージを印刷するように[`reqwest::get`]を使用してコンテンツをダウンロードします。

<!--Range header is defined in [RFC7233][HTTP%20Range%20RFC7233].-->
Rangeヘッダーは[RFC7233][HTTP%20Range%20RFC7233]で定義されてい[RFC7233][HTTP%20Range%20RFC7233]。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate reqwest;

use std::fs::File;
use reqwest::header::{ContentRange, ContentRangeSpec, Range};
use reqwest::StatusCode;
#
# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#         Reqwest(reqwest::Error);
#     }
# }
#
# struct PartialRangeIter {
#     start: u64,
#     end: u64,
#     buffer_size: u32,
# }
#
# impl PartialRangeIter {
#     pub fn new(content_range: &ContentRangeSpec, buffer_size: u32) -> Result<Self> {
#         if buffer_size == 0 {
#             Err("invalid buffer_size, give a value greater than zero.")?;
#         }
#
#         match *content_range {
#             ContentRangeSpec::Bytes { range: Some(range), .. } => Ok(PartialRangeIter {
#                 start: range.0,
#                 end: range.1,
#                 buffer_size,
#             }),
#             _ => Err("invalid range specification")?,
#         }
#     }
# }
#
# impl Iterator for PartialRangeIter {
#     type Item = Range;
#
#     fn next(&mut self) -> Option<Self::Item> {
#         if self.start > self.end {
#             None
#         } else {
#             let prev_start = self.start;
#             self.start += std::cmp::min(self.buffer_size as u64, self.end - self.start + 1);
#             Some(Range::bytes(prev_start, self.start - 1))
#         }
#     }
# }

fn run() -> Result<()> {
    let url = "https://httpbin.org/range/102400?duration=2";
    const CHUNK_SIZE: u32 = 10240;

    let client = reqwest::Client::new();
    let response = client.head(url).send()?;
    let range = response.headers().get::<ContentRange>().ok_or(
        "response doesn't include the expected ranges",
    )?;

    let mut output_file = File::create("download.bin")?;

    println!("starting download...");
    for range in PartialRangeIter::new(range, CHUNK_SIZE)? {

        println!("range {:?}", range);
        let mut response = client.get(url).header(range).send()?;

        let status = response.status();
        if !(status == StatusCode::Ok || status == StatusCode::PartialContent) {
            bail!("Unexpected server response: {}", status)
        }

        std::io::copy(&mut response, &mut output_file)?;
    }

    println!("Finished with success!");
    Ok(())
}
#
# quick_main!(run);
```

<!--[`reqwest::Client::head`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.head
 [`reqwest::get`]: https://docs.rs/reqwest/*/reqwest/fn.get.html
 [`reqwest::header::ContentRange`]: https://docs.rs/reqwest/*/reqwest/header/struct.ContentRange.html
 [`reqwest::header::Range`]: https://docs.rs/reqwest/*/reqwest/header/enum.Range.html
-->
[`reqwest::Client::head`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.head
 [`reqwest::get`]: https://docs.rs/reqwest/*/reqwest/fn.get.html
 [`reqwest::header::ContentRange`]: https://docs.rs/reqwest/*/reqwest/header/struct.ContentRange.html
 [`reqwest::header::Range`]: https://docs.rs/reqwest/*/reqwest/header/enum.Range.html


[HTTP Range RFC7233]: https://tools.ietf.org/html/rfc7233#section-3.1
