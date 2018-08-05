## <!--Parse a complex version string.--> 複雑なバージョンの文字列を解析します。

<!--[!][semver]-->
[！][semver]
<!--[semver-badge] [!][cat-config]-->
[semver-badge] [！][cat-config]
[cat-config-badge]
<!--Constructs a [`semver::Version`] from a complex version string using [`Version::parse`].-->
構築[`semver::Version`]複雑なバージョン文字列から使用して[`Version::parse`]。
<!--The string contains pre-release and build metadata as defined in the [Semantic Versioning Specification].-->
文字列には、[Semantic Versioning Specification]定義されているように、プレリリースおよびビルドメタデータが含まれています。

<!--Note that, in accordance with the Specification, build metadata is parsed but not considered when comparing versions.-->
仕様に従って、ビルドメタデータは解析されますが、バージョンを比較するときは考慮されません。
<!--In other words, two versions may be equal even if their build strings differ.-->
つまり、ビルド文字列が異なる場合でも、2つのバージョンが同じである可能性があります。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate semver;

use semver::{Identifier, Version};
#
# error_chain! {
#     foreign_links {
#         SemVer(semver::SemVerError);
#     }
# }

fn run() -> Result<()> {
    let version_str = "1.0.49-125+g72ee7853";
    let parsed_version = Version::parse(version_str)?;

    assert_eq!(
        parsed_version,
        Version {
            major: 1,
            minor: 0,
            patch: 49,
            pre: vec![Identifier::Numeric(125)],
            build: vec![],
        }
    );
    assert_eq!(
        parsed_version.build,
        vec![Identifier::AlphaNumeric(String::from("g72ee7853"))]
    );

    let serialized_version = parsed_version.to_string();
    assert_eq!(&serialized_version, version_str);

    Ok(())
}
#
# quick_main!(run);
```

<!--[`semver::Version`]: https://docs.rs/semver/*/semver/struct.Version.html
 [`Version::parse`]: https://docs.rs/semver/*/semver/struct.Version.html#method.parse
-->
[`semver::Version`]: https://docs.rs/semver/*/semver/struct.Version.html
 [`Version::parse`]: https://docs.rs/semver/*/semver/struct.Version.html#method.parse
 [`semver::Version`]: https://docs.rs/semver/*/semver/struct.Version.html


[Semantic Versioning Specification]: http://semver.org/
