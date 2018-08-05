## <!--Serialize and deserialize unstructured JSON--> 構造化されていないJSONを直列化および逆シリアル化する

<!--[!][serde-json]-->
[！][serde-json]
<!--[serde-json-badge] [!][cat-encoding]-->
[serde-json-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--The [`serde_json`] crate provides a [`from_str`] function to parse a `&str` of JSON.-->
[`serde_json`]枠はJSONの`&str`を解析する[`from_str`]関数を提供します。

<!--Unstructured JSON can be parsed into a universal [`serde_json::Value`] type that is able to represent any valid JSON data.-->
構造化されていないJSONは、有効なJSONデータを表すことができる普遍的な[`serde_json::Value`]型に解析できます。

<!--The example below shows a `&str` of JSON being parsed.-->
以下の例は、解析されているJSONの`&str`を示してい`&str`。
<!--The expected value is declared using the [`json!`] macro.-->
期待値は[`json!`]マクロを使って宣言されます。

```rust
# #[macro_use]
# extern crate error_chain;
#[macro_use]
extern crate serde_json;

use serde_json::Value;
#
# error_chain! {
#     foreign_links {
#         Json(serde_json::Error);
#     }
# }

fn run() -> Result<()> {
    let j = r#"{
                 "userid": 103609,
                 "verified": true,
                 "access_privileges": [
                   "user",
                   "admin"
                 ]
               }"#;

    let parsed: Value = serde_json::from_str(j)?;

    let expected = json!({
        "userid": 103609,
        "verified": true,
        "access_privileges": [
            "user",
            "admin"
        ]
    });

    assert_eq!(parsed, expected);

    Ok(())
}
#
# quick_main!(run);
```

<!--[`from_str`]: https://docs.serde.rs/serde_json/fn.from_str.html
 [`json!`]: https://docs.serde.rs/serde_json/macro.json.html
 [`serde_json`]: https://docs.serde.rs/serde_json/
 [`serde_json::Value`]: https://docs.serde.rs/serde_json/enum.Value.html
-->
[`from_str`]: https://docs.serde.rs/serde_json/fn.from_str.html
 [`json!`]: https://docs.serde.rs/serde_json/macro.json.html
 [`serde_json`]: https://docs.serde.rs/serde_json/
 [`serde_json::Value`]: https://docs.serde.rs/serde_json/enum.Value.html

