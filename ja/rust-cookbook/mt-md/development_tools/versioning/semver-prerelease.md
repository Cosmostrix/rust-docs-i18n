## <!--Check if given version is pre-release.--> 指定されたバージョンがプレリリース版であることを確認してください。

<!--[!][semver]-->
[！][semver]
<!--[semver-badge] [!][cat-config]-->
[semver-badge] [！][cat-config]
[cat-config-badge]
<!--Given two versions, [`is_prerelease`] asserts that one is pre-release and the other is not.-->
2つのバージョンが与えられたとき、[`is_prerelease`]は、1つがプレリリースであり、もう1つがプレリリースであると主張します。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate semver;

use semver::Version;
#
# error_chain! {
#     foreign_links {
#         SemVer(semver::SemVerError);
#     }
# }

fn run() -> Result<()> {
    let version_1 = Version::parse("1.0.0-alpha")?;
    let version_2 = Version::parse("1.0.0")?;

    assert!(version_1.is_prerelease());
    assert!(!version_2.is_prerelease());

    Ok(())
}
#
# quick_main!(run);
```

[`is_prerelease`]: https://docs.rs/semver/*/semver/struct.Version.html#method.is_prerelease
