## <!--POST a file to paste-rs.--> paste-rsにファイルをPOSTします。

<!--[!][reqwest]-->
[！][reqwest]
<!--[reqwest-badge] [!][cat-net]-->
[reqwest-badge] [！][cat-net]
[cat-net-badge]
<!--[`reqwest::Client`] establishes a connection to https://paste.rs following the [`reqwest::RequestBuilder`] pattern.-->
[`reqwest::Client`]は[`reqwest::RequestBuilder`]パターンに従ってhttps：//paste.rsへの接続を確立します。
<!--Calling [`Client::post`] with a URL establishes the destination, [`RequestBuilder::body`] sets the content to send by reading the file, and [`RequestBuilder::send`] blocks until the file uploads and the response returns.-->
呼び出し[`Client::post`] URLとは、宛先、確立[`RequestBuilder::body`]ファイルを読み出すことにより、送信するコンテンツを設定し、[`RequestBuilder::send`]ファイルのアップロードと応答が戻るまでブロックを。
<!--[`read_to_string`] returns the response and displays in the console.-->
[`read_to_string`]は応答を返し、コンソールに表示します。

```rust,no_run
extern crate reqwest;

# #[macro_use]
# extern crate error_chain;
#
use std::fs::File;
use std::io::Read;
use reqwest::Client;
#
# error_chain! {
#     foreign_links {
#         HttpRequest(reqwest::Error);
#         IoError(::std::io::Error);
#     }
# }

fn run() -> Result<()> {
    let paste_api = "https://paste.rs";
    let file = File::open("message")?;

    let mut response = Client::new().post(paste_api).body(file).send()?;
    let mut response_body = String::new();
    response.read_to_string(&mut response_body)?;
    println!("Your paste is located at: {}", response_body);
    Ok(())
}
#
# quick_main!(run);
```

<!--[`Client::post`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.post
 [`read_to_string`]: https://doc.rust-lang.org/std/io/trait.Read.html#method.read_to_string
 [`RequestBuilder::body`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.body
 [`RequestBuilder::send`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.send
 [`reqwest::Client`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html
 [`reqwest::RequestBuilder`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html
-->
[`Client::post`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.post
 [`read_to_string`]: https://doc.rust-lang.org/std/io/trait.Read.html#method.read_to_string
 [`RequestBuilder::body`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.body
 [`RequestBuilder::send`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.send
 [`reqwest::Client`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html
 [`reqwest::RequestBuilder`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html

