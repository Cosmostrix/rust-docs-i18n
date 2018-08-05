## <!--Verify and extract login from an email address--> 電子メールアドレスからのログインの確認と抽出

<!--[!][regex]-->
[！][regex]
<!--[regex-badge] [!][lazy_static]-->
[regex-badge] [！][lazy_static]
<!--[lazy_static-badge] [!][cat-text-processing]-->
[lazy_static-badge] [！][cat-text-processing]
[cat-text-processing-badge]
<!--Validates that an email address is formatted correctly, and extracts everything before the @ symbol.-->
電子メールアドレスが正しくフォーマットされていることを検証し、@記号の前のすべてを抽出します。

```rust
#[macro_use]
extern crate lazy_static;
extern crate regex;

use regex::Regex;

fn extract_login(input: &str) -> Option<&str> {
    lazy_static! {
        static ref RE: Regex = Regex::new(r"(?x)
            ^(?P<login>[^@\s]+)@
            ([[:word:]]+\.)*
            [[:word:]]+$
            ").unwrap();
    }
    RE.captures(input).and_then(|cap| {
        cap.name("login").map(|login| login.as_str())
    })
}

fn main() {
    assert_eq!(extract_login(r"I❤email@example.com"), Some(r"I❤email"));
    assert_eq!(
        extract_login(r"sdf+sdsfsd.as.sdsd@jhkk.d.rl"),
        Some(r"sdf+sdsfsd.as.sdsd")
    );
    assert_eq!(extract_login(r"More@Than@One@at.com"), None);
    assert_eq!(extract_login(r"Not an email@email"), None);
}
```
