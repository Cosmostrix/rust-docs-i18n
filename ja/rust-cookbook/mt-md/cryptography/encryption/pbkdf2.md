<span id="ex-pbkdf2"></span><!--## Salt and hash a password with PBKDF2-->
## PBKDF2でパスワードを暗号化してハッシュする

<!--[!][ring]-->
[！][ring]
<!--[ring-badge] [!][data-encoding]-->
[ring-badge] [！][data-encoding]
<!--[data-encoding-badge] [!][cat-cryptography]-->
[data-encoding-badge] [！][cat-cryptography]
[cat-cryptography-badge]
<!--Uses [`ring::pbkdf2`] to hash a salted password using the PBKDF2 key derivation function [`pbkdf2::derive`].-->
[`ring::pbkdf2`]を使用して、PBKDF2キー派生関数[`pbkdf2::derive`]を使用して、暗号化されたパスワードをハッシュします。
<!--Verifies the hash is correct with [`pbkdf2::verify`].-->
[`pbkdf2::verify`]でハッシュが正しいことを確認します。
<!--The salt is generated using [`SecureRandom::fill`], which fills the salt byte array with securely generated random numbers.-->
saltは[`SecureRandom::fill`]を使って生成され、安全に生成された乱数でsaltバイト配列を埋めます。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate data_encoding;
extern crate ring;
#
# error_chain! {
#   foreign_links {
#     Ring(ring::error::Unspecified);
#   }
# }

use data_encoding::HEXUPPER;
use ring::{digest, pbkdf2, rand};
use ring::rand::SecureRandom;

fn run() -> Result<()> {
  const CREDENTIAL_LEN: usize = digest::SHA512_OUTPUT_LEN;
  const N_ITER: u32 = 100_000;
  let rng = rand::SystemRandom::new();

  let mut salt = [0u8; CREDENTIAL_LEN];
  rng.fill(&mut salt)?;

  let password = "Guess Me If You Can!";
  let mut pbkdf2_hash = [0u8; CREDENTIAL_LEN];
  pbkdf2::derive(
      &digest::SHA512,
      N_ITER,
      &salt,
      password.as_bytes(),
      &mut pbkdf2_hash,
  );
  println!("Salt: {}", HEXUPPER.encode(&salt));
  println!("PBKDF2 hash: {}", HEXUPPER.encode(&pbkdf2_hash));

  let should_succeed = pbkdf2::verify(
      &digest::SHA512,
      N_ITER,
      &salt,
      password.as_bytes(),
      &pbkdf2_hash,
  );
  let wrong_password = "Definitely not the correct password";
  let should_fail = pbkdf2::verify(
      &digest::SHA512,
      N_ITER,
      &salt,
      wrong_password.as_bytes(),
      &pbkdf2_hash,
  );

  assert!(should_succeed.is_ok());
  assert!(!should_fail.is_ok());

  Ok(())
}
#
# quick_main!(run);
```

<!--[`pbkdf2::derive`]: https://briansmith.org/rustdoc/ring/pbkdf2/fn.derive.html
 [`pbkdf2::verify`]: https://briansmith.org/rustdoc/ring/pbkdf2/fn.verify.html
 [`ring::pbkdf2`]: https://briansmith.org/rustdoc/ring/pbkdf2/index.html
 [`SecureRandom::fill`]: https://briansmith.org/rustdoc/ring/rand/trait.SecureRandom.html#tymethod.fill
-->
[`pbkdf2::derive`]: https://briansmith.org/rustdoc/ring/pbkdf2/fn.derive.html
 [`pbkdf2::verify`]: https://briansmith.org/rustdoc/ring/pbkdf2/fn.verify.html
 [`ring::pbkdf2`]: https://briansmith.org/rustdoc/ring/pbkdf2/index.html
 [`SecureRandom::fill`]: https://briansmith.org/rustdoc/ring/rand/trait.SecureRandom.html#tymethod.fill

