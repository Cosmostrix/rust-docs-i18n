## <!--Encode and decode hex--> 16進数のエンコードとデコード

<!--[!][data-encoding]-->
[！][data-encoding]
<!--[data-encoding-badge] [!][cat-encoding]-->
[data-encoding-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--The [`data_encoding`] crate provides a `HEXUPPER::encode` method which takes a `&[u8]` and returns a `String` containing the hexadecimal representation of the data.-->
[`data_encoding`]クレートは、`&[u8]`をとり、データの16進表現を含む`String`を返す`HEXUPPER::encode`メソッドを提供します。

<!--Similarly, a `HEXUPPER::decode` method is provided which takes a `&[u8]` and returns a `Vec<u8>` if the input data is successfully decoded.-->
同様に、`HEXUPPER::decode`メソッドが提供され、入力データが正常にデコードされた場合は`&[u8]`を返し、`Vec<u8>`を返します。

<!--The example below coverts `&[u8]` data to hexadecimal equivalent.-->
以下の例は、カバット`&[u8]`データを16進数に変換したものです。
<!--Compares this value to the expected value.-->
この値を期待値と比較します。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate data_encoding;

use data_encoding::{HEXUPPER, DecodeError};
#
# error_chain! {
#     foreign_links {
#         Decode(DecodeError);
#     }
# }

fn run() -> Result<()> {
    let original = b"The quick brown fox jumps over the lazy dog.";
    let expected = "54686520717569636B2062726F776E20666F78206A756D7073206F76\
        657220746865206C617A7920646F672E";

    let encoded = HEXUPPER.encode(original);
    assert_eq!(encoded, expected);

    let decoded = HEXUPPER.decode(&encoded.into_bytes())?;
    assert_eq!(&decoded[..], &original[..]);

    Ok(())
}
#
# quick_main!(run);
```

[`data_encoding`]: https://docs.rs/data-encoding/*/data_encoding/
