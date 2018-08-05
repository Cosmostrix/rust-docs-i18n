## <!--Deserialize a TOML configuration file--> TOML構成ファイルをデシリアライズする

<!--[!][toml]-->
[！][toml]
<!--[toml-badge] [!][cat-encoding]-->
[toml-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--Parse some TOML into a universal `toml::Value` that is able to represent any valid TOML data.-->
いくつかのTOMLを解析して、有効なTOMLデータを表すことができるuniversal `toml::Value`変換します。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate toml;

use toml::Value;
#
# error_chain! {
#     foreign_links {
#         Toml(toml::de::Error);
#     }
# }

fn run() -> Result<()> {
    let toml_content = r#"
          [package]
          name = "your_package"
          version = "0.1.0"
          authors = ["You! <you@example.org>"]

          [dependencies]
          serde = "1.0"
          "#;

    let package_info: Value = toml::from_str(toml_content)?;

    assert_eq!(package_info["dependencies"]["serde"].as_str(), Some("1.0"));
    assert_eq!(package_info["package"]["name"].as_str(),
               Some("your_package"));

    Ok(())
}
#
# quick_main!(run);
```

<!--Parse TOML into your own structs using [Serde].-->
使用して独自の構造体にTOMLを解析し[Serde]。

```rust
# #[macro_use]
# extern crate error_chain;
#[macro_use]
extern crate serde_derive;
extern crate toml;

use std::collections::HashMap;

#[derive(Deserialize)]
struct Config {
    package: Package,
    dependencies: HashMap<String, String>,
}

#[derive(Deserialize)]
struct Package {
    name: String,
    version: String,
    authors: Vec<String>,
}
#
# error_chain! {
#     foreign_links {
#         Toml(toml::de::Error);
#     }
# }

fn run() -> Result<()> {
    let toml_content = r#"
          [package]
          name = "your_package"
          version = "0.1.0"
          authors = ["You! <you@example.org>"]

          [dependencies]
          serde = "1.0"
          "#;

    let package_info: Config = toml::from_str(toml_content)?;

    assert_eq!(package_info.package.name, "your_package");
    assert_eq!(package_info.package.version, "0.1.0");
    assert_eq!(package_info.package.authors, vec!["You! <you@example.org>"]);
    assert_eq!(package_info.dependencies["serde"], "1.0");

    Ok(())
}
#
# quick_main!(run);
```
