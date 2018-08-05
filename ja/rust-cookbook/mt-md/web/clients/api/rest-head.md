## <!--Check if an API resource exists--> APIリソースが存在するかどうかを確認する

<!--[!][reqwest]-->
[！][reqwest]
<!--[reqwest-badge] [!][cat-net]-->
[reqwest-badge] [！][cat-net]
[cat-net-badge]
<!--Query the GitHub Users Endpoint using a HEAD request ([`Client::head`]) and then inspect the response code to determine success.-->
HEAD要求（[`Client::head`]）を使用してGitHubユーザーエンドポイントを照会し、応答コードを検査して成功を判断します。
<!--This is a quick way to query a rest resource without needing to receive a body.-->
これは、ボディを受け取ることなく、残りのリソースに問い合わせる簡単な方法です。
<!--[`reqwest::Client`] cofigured with [`ClientBuilder::timeout`] ensures a request will not last longer than a timeout.-->
[`reqwest::Client`]でcofigured [`ClientBuilder::timeout`]、要求がタイムアウトよりも長くは続かないことが保証されます。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate reqwest;

use std::time::Duration;
use reqwest::ClientBuilder;
#
# error_chain! {
#     foreign_links {
#         Reqwest(reqwest::Error);
#     }
# }

fn run() -> Result<()> {
    let user = "ferris-the-crab";
    let request_url = format!("https://api.github.com/users/{}", user);
    println!("{}", request_url);

    let timeout = Duration::new(5, 0);
    let client = ClientBuilder::new().timeout(timeout).build()?;
    let response = client.head(&request_url).send()?;

    if response.status().is_success() {
        println!("{} is a user!", user);
    } else {
        println!("{} is not a user!", user);
    }

    Ok(())
}
#
# quick_main!(run);
```

<!--[`Client::head`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.head
 [`ClientBuilder::timeout`]: https://docs.rs/reqwest/*/reqwest/struct.ClientBuilder.html#method.timeout
 [`reqwest::Client`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html
-->
[`Client::head`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.head
 [`ClientBuilder::timeout`]: https://docs.rs/reqwest/*/reqwest/struct.ClientBuilder.html#method.timeout
 [`reqwest::Client`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html

