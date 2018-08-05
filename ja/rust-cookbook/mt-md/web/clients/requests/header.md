## <!--Set custom headers and URL parameters for a REST request--> RESTリクエストのカスタムヘッダーとURLパラメータを設定する

<!--[!][reqwest]-->
[！][reqwest]
<!--[reqwest-badge] [!][hyper]-->
[reqwest-badge] [！][hyper]
<!--[hyper-badge] [!][url]-->
[hyper-badge] [！][url]
<!--[url-badge] [!][cat-net]-->
[url-badge] [！][cat-net]
[cat-net-badge]
<!--Sets both standard and custom HTTP headers as well as URL parameters for a HTTP GET request.-->
HTTP GET要求のURLパラメータと同様に、標準およびカスタムHTTPヘッダーの両方を設定します。
<!--Creates a custom header of type `XPoweredBy` with [`hyper::header!`] macro.-->
[`hyper::header!`]マクロを`XPoweredBy`型のカスタムヘッダを作成します。

<!--Builds complex URL with [`Url::parse_with_params`].-->
[`Url::parse_with_params`]複雑なURLを構築します。
<!--Sets standard headers [`header::UserAgent`], [`header::Authorization`], and custom `XPoweredBy` with [`RequestBuilder::header`] then makes the request with [`RequestBuilder::send`].-->
セット標準ヘッダー[`header::UserAgent`]、 [`header::Authorization`]、およびカスタム`XPoweredBy`と[`RequestBuilder::header`]、その後に要求を行う[`RequestBuilder::send`]。

<!--The request targets-->
リクエスト対象
RawInline (Format "html") "< httpbin.org headers>" <!--service which responds with a JSON dict containing all request headers for easy verification.-->
簡単な確認のためにすべてのリクエストヘッダーを含むJSON dictで応答するサービスです。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate url;
extern crate reqwest;
#[macro_use]
extern crate hyper;
#[macro_use]
extern crate serde_derive;

use std::collections::HashMap;
use url::Url;
use reqwest::Client;
use reqwest::header::{UserAgent, Authorization, Bearer};

header! { (XPoweredBy, "X-Powered-By") => [String] }

#[derive(Deserialize, Debug)]
pub struct HeadersEcho {
    pub headers: HashMap<String, String>,
}
#
# error_chain! {
#     foreign_links {
#         Reqwest(reqwest::Error);
#         UrlParse(url::ParseError);
#     }
# }

fn run() -> Result<()> {
    let url = Url::parse_with_params("http://httpbin.org/headers",
                                     &[("lang", "rust"), ("browser", "servo")])?;

    let mut response = Client::new()
        .get(url)
        .header(UserAgent::new("Rust-test"))
        .header(Authorization(Bearer { token: "DEadBEEfc001cAFeEDEcafBAd".to_owned() }))
        .header(XPoweredBy("Guybrush Threepwood".to_owned()))
        .send()?;

    let out: HeadersEcho = response.json()?;
    assert_eq!(out.headers["Authorization"],
               "Bearer DEadBEEfc001cAFeEDEcafBAd");
    assert_eq!(out.headers["User-Agent"], "Rust-test");
    assert_eq!(out.headers["X-Powered-By"], "Guybrush Threepwood");
    assert_eq!(response.url().as_str(),
               "http://httpbin.org/headers?lang=rust&browser=servo");

    println!("{:?}", out);
    Ok(())
}
#
# quick_main!(run);
```

<!--[`header::Authorization`]: https://doc.servo.org/hyper/header/struct.Authorization.html
 [`header::UserAgent`]: https://doc.servo.org/hyper/header/struct.UserAgent.html
 [`hyper::header!`]: https://doc.servo.org/hyper/macro.header.html
 [`RequestBuilder::header`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.header
 [`RequestBuilder::send`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.send
 [`Url::parse_with_params`]: https://docs.rs/url/*/url/struct.Url.html#method.parse_with_params
-->
[`header::Authorization`]: https://doc.servo.org/hyper/header/struct.Authorization.html
 [`header::UserAgent`]: https://doc.servo.org/hyper/header/struct.UserAgent.html
 [`hyper::header!`]: https://doc.servo.org/hyper/macro.header.html
 [`RequestBuilder::header`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.header
 [`RequestBuilder::send`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.send
 [`Url::parse_with_params`]: https://docs.rs/url/*/url/struct.Url.html#method.parse_with_params

