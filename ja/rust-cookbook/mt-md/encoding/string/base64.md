## <!--Encode and decode base64--> base64のエンコードとデコード

<!--[!][base64]-->
[！][base64]
<!--[base64-badge] [!][cat-encoding]-->
[base64-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--Encodes byte slice into `base64` String using [`encode`] and decodes it with [`decode`].-->
バイトのスライスをエンコード`base64`使用して文字列[`encode`]し、それをデコード[`decode`]。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate base64;

use std::str;
use base64::{encode, decode};
#
# error_chain! {
#     foreign_links {
#         Base64(base64::DecodeError);
#         Utf8Error(str::Utf8Error);
#     }
# }

fn run() -> Result<()> {
    let hello = b"hello rustaceans";
    let encoded = encode(hello);
    let decoded = decode(&encoded)?;

    println!("origin: {}", str::from_utf8(hello)?);
    println!("base64 encoded: {}", encoded);
    println!("back to origin: {}", str::from_utf8(&decoded)?);

    Ok(())
}
#
# quick_main!(run);
```

<!--[`decode`]: https://docs.rs/base64/*/base64/fn.decode.html
 [`encode`]: https://docs.rs/base64/*/base64/fn.encode.html
-->
[`decode`]: https://docs.rs/base64/*/base64/fn.decode.html
 [`encode`]: https://docs.rs/base64/*/base64/fn.encode.html

