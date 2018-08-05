## <!--Sign and verify a message with HMAC digest--> HMACダイジェストでメッセージに署名し、検証する

<!--[!][ring]-->
[！][ring]
<!--[ring-badge] [!][cat-cryptography]-->
[ring-badge] [！][cat-cryptography]
[cat-cryptography-badge]
<!--Uses [`ring::hmac`] to creates a [`hmac::Signature`] of a string then verifies the signature is correct.-->
[`ring::hmac`]を[`ring::hmac`]て文字列の[`hmac::Signature`]を作成し、署名が正しいことを確認します。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate ring;
#
# error_chain! {
#     foreign_links {
#         Ring(ring::error::Unspecified);
#     }
# }

use ring::{digest, hmac, rand};
use ring::rand::SecureRandom;

fn run() -> Result<()> {
    let mut key_value = [0u8; 48];
    let rng = rand::SystemRandom::new();
    rng.fill(&mut key_value)?;
    let key = hmac::SigningKey::new(&digest::SHA256, &key_value);

    let message = "Legitimate and important message.";
    let signature = hmac::sign(&key, message.as_bytes());
    hmac::verify_with_own_key(&key, message.as_bytes(), signature.as_ref())?;

    Ok(())
}
#
# quick_main!(run);
```

<!--[`hmac::Signature`]: https://briansmith.org/rustdoc/ring/hmac/struct.Signature.html
 [`ring::hmac`]: https://briansmith.org/rustdoc/ring/hmac/
-->
[`hmac::Signature`]: https://briansmith.org/rustdoc/ring/hmac/struct.Signature.html
 [`ring::hmac`]: https://briansmith.org/rustdoc/ring/hmac/

