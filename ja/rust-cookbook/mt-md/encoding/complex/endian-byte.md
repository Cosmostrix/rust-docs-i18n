## <!--Read and write integers in little-endian byte order--> リトルエンディアンのバイト順で整数を読み書きする

<!--[!][byteorder]-->
[！][byteorder]
<!--[byteorder-badge] [!][cat-encoding]-->
[byteorder-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--`byteorder` can reverse the significant bytes of structured data.-->
`byteorder`は、構造化データの重要なバイトを逆にすることができます。
<!--This may be necessary when receiving information over the network, such that bytes received are from another system.-->
これは、受信したバイトが別のシステムからのものであるように、ネットワークを介して情報を受信する場合に必要となる可能性があります。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate byteorder;

use byteorder::{LittleEndian, ReadBytesExt, WriteBytesExt};

#[derive(Default, PartialEq, Debug)]
struct Payload {
    kind: u8,
    value: u16,
}
#
# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#     }
# }

fn run() -> Result<()> {
    let original_payload = Payload::default();
    let encoded_bytes = encode(&original_payload)?;
    let decoded_payload = decode(&encoded_bytes)?;
    assert_eq!(original_payload, decoded_payload);
    Ok(())
}

fn encode(payload: &Payload) -> Result<Vec<u8>> {
    let mut bytes = vec![];
    bytes.write_u8(payload.kind)?;
    bytes.write_u16::<LittleEndian>(payload.value)?;
    Ok(bytes)
}

fn decode(mut bytes: &[u8]) -> Result<Payload> {
    let payload = Payload {
        kind: bytes.read_u8()?,
        value: bytes.read_u16::<LittleEndian>()?,
    };
    Ok(payload)
}
#
# quick_main!(run);
```
