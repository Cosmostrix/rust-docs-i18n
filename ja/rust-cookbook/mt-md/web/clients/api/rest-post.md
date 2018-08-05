## <!--Create and delete Gist with GitHub API--> GitHub APIを使用したGistの作成と削除

<!--[!][reqwest]-->
[！][reqwest]
<!--[reqwest-badge] [!][serde]-->
[reqwest-badge] [！][serde]
<!--[serde-badge] [!][cat-net]-->
[serde-badge] [！][cat-net]
<!--[cat-net-badge] [!][cat-encoding]-->
[cat-net-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--Creates a gist with POST request to GitHub [gists API v3](https://developer.github.com/v3/gists/) using [`Client::post`] and removes it with DELETE request using [`Client::delete`].-->
[`Client::post`]を使ってGitHub [gists API v3](https://developer.github.com/v3/gists/)へのPOST要求の要点を作成し、[`Client::delete`]を使ってDELETE要求で削除します。

<!--The [`reqwest::Client`] is responsible for details of both requests including URL, body and authentication.-->
[`reqwest::Client`]は、URL、本文、認証などの両方の要求の詳細を処理します。
<!--The POST body from [`serde_json::json!`] macro provides arbitrary JSON body.-->
[`serde_json::json!`]マクロのPOST本体は、任意のJSON本体を提供します。
<!--Call to [`RequestBuilder::json`] sets the request body.-->
[`RequestBuilder::json`]呼び出すと、要求本体が設定されます。
<!--[`RequestBuilder::basic_auth`] handles authentication.-->
[`RequestBuilder::basic_auth`]は認証を処理します。
<!--The call to [`RequestBuilder::send`] synchronously executes the requests.-->
[`RequestBuilder::send`]の呼び出しは、要求を同期的に実行します。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate reqwest;
#[macro_use]
extern crate serde_derive;
#[macro_use]
extern crate serde_json;

use std::env;
use reqwest::Client;
#
# error_chain! {
#     foreign_links {
#         EnvVar(env::VarError);
#         HttpRequest(reqwest::Error);
#     }
# }

#[derive(Deserialize, Debug)]
struct Gist {
    id: String,
    html_url: String,
}

fn run() -> Result<()> {
    let gh_user = env::var("GH_USER")?;
    let gh_pass = env::var("GH_PASS")?;

    let gist_body = json!({
        "description": "the description for this gist",
        "public": true,
        "files": {
             "main.rs": {
             "content": r#"fn main() { println!("hello world!");}"#
            }
        }});

    let request_url = "https://api.github.com/gists";
    let mut response = Client::new()
        .post(request_url)
        .basic_auth(gh_user.clone(), Some(gh_pass.clone()))
        .json(&gist_body)
        .send()?;

    let gist: Gist = response.json()?;
    println!("Created {:?}", gist);

    let request_url = format!("{}/{}",request_url, gist.id);
    let response = Client::new()
        .delete(&request_url)
        .basic_auth(gh_user, Some(gh_pass))
        .send()?;

    println!("Gist {} deleted! Status code: {}",gist.id, response.status());
    Ok(())
}
#
# quick_main!(run);
```

<!--The example uses [HTTP Basic Auth] in order to authorize access to [GitHub API].-->
この例では、[HTTP Basic Auth]を使用し[GitHub API]へのアクセスを許可し[GitHub API]。
<!--Typical use case would employ one of the much more complex [OAuth] authorization flows.-->
典型的なユースケースでは、はるかに複雑な[OAuth]認証フローの1つを使用します。

<!--[`Client::delete`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.delete
 [`Client::post`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.post
 [`RequestBuilder::basic_auth`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.basic_auth
 [`RequestBuilder::json`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.json
 [`RequestBuilder::send`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.send
 [`reqwest::Client`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html
 [`serde_json::json!`]: https://docs.rs/serde_json/*/serde_json/macro.json.html
-->
[`Client::delete`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.delete
 [`Client::post`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html#method.post
 [`RequestBuilder::basic_auth`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.basic_auth
 [`RequestBuilder::json`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.json
 [`RequestBuilder::send`]: https://docs.rs/reqwest/*/reqwest/struct.RequestBuilder.html#method.send
 [`reqwest::Client`]: https://docs.rs/reqwest/*/reqwest/struct.Client.html
 [`serde_json::json!`]: https://docs.rs/serde_json/*/serde_json/macro.json.html


<!--[GitHub API]: https://developer.github.com/v3/auth/
 [HTTP Basic Auth]: https://tools.ietf.org/html/rfc2617
 [OAuth]: https://oauth.net/getting-started/
-->
[GitHub API]: https://developer.github.com/v3/auth/
 [HTTP Basic Auth]: https://tools.ietf.org/html/rfc2617
 [OAuth]: https://oauth.net/getting-started/

