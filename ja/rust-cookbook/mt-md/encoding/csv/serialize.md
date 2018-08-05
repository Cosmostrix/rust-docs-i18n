## <!--Serialize records to CSV--> レコードをCSVにシリアル化する

<!--[!][csv]-->
[！][csv]
<!--[csv-badge] [!][cat-encoding]-->
[csv-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--This example shows how to serialize a Rust tuple.-->
この例は、Rustタプルをシリアライズする方法を示しています。
<!--[`csv::writer`] supports automatic serialization from Rust types into CSV records.-->
[`csv::writer`]は、Rust型からCSVレコードへの自動直列化をサポートしています。
<!--[`write_record`] writes a simple record containing string data only.-->
[`write_record`]は、文字列データのみを含む単純なレコードを書き込みます。
<!--Data with more complex values such as numbers, floats, and options use [`serialize`].-->
数値、浮動小数点数、オプションなどのより複雑な値を持つデータは[`serialize`]使います。
<!--Since CSV writer uses internal buffer, always explicitly [`flush`] when done.-->
CSVライターは内部バッファーを使用するため、[`flush`]すると常に明示的に[`flush`]ます。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate csv;

use std::io;
#
# error_chain! {
#     foreign_links {
#         CSVError(csv::Error);
#         IOError(std::io::Error);
#    }
# }

fn run() -> Result<()> {
    let mut wtr = csv::Writer::from_writer(io::stdout());

    wtr.write_record(&["Name", "Place", "ID"])?;

    wtr.serialize(("Mark", "Sydney", 87))?;
    wtr.serialize(("Ashley", "Dublin", 32))?;
    wtr.serialize(("Akshat", "Delhi", 11))?;

    wtr.flush()?;
    Ok(())
}
#
# quick_main!(run);
```

<!--[`csv::Writer`]: https://docs.rs/csv/*/csv/struct.Writer.html
 [`flush`]: https://docs.rs/csv/*/csv/struct.Writer.html#method.flush
 [`serialize`]: https://docs.rs/csv/*/csv/struct.Writer.html#method.serialize
 [`write_record`]: https://docs.rs/csv/*/csv/struct.Writer.html#method.write_record
-->
[`csv::Writer`]: https://docs.rs/csv/*/csv/struct.Writer.html
 [`flush`]: https://docs.rs/csv/*/csv/struct.Writer.html#method.flush
 [`serialize`]: https://docs.rs/csv/*/csv/struct.Writer.html#method.serialize
 [`write_record`]: https://docs.rs/csv/*/csv/struct.Writer.html#method.write_record

