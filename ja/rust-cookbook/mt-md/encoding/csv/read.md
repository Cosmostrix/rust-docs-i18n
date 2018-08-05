## <!--Read CSV records--> CSVレコードを読む

<!--[!][csv]-->
[！][csv]
<!--[csv-badge] [!][cat-encoding]-->
[csv-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--Reads standard CSV records into [`csv::StringRecord`] — a weakly typed data representation which expects valid UTF-8 rows.-->
標準のCSVレコードを[`csv::StringRecord`] -有効なUTF-8の行を必要とする弱く型付けされたデータ表現に読み込みます。
<!--Alternatively, [`csv::ByteRecord`] makes no assumptions about UTF-8.-->
あるいは、[`csv::ByteRecord`]はUTF-8について何も仮定しません。

```rust
extern crate csv;
# #[macro_use]
# extern crate error_chain;
#
# error_chain! {
#     foreign_links {
#         Reader(csv::Error);
#     }
# }

fn run() -> Result<()> {
    let csv = "year,make,model,description
1948,Porsche,356,Luxury sports car
1967,Ford,Mustang fastback 1967,American car";

    let mut reader = csv::Reader::from_reader(csv.as_bytes());
    for record in reader.records() {
        let record = record?;
        println!(
            "In {}, {} built the {} model. It is a {}.",
            &record[0],
            &record[1],
            &record[2],
            &record[3]
        );
    }

    Ok(())
}
#
# quick_main!(run);
```

<!--Serde deserializes data into strongly type structures.-->
Serdeは、データを強く型付けされた構造に逆直列化します。
<!--See the [`csv::Reader::deserialize`] method.-->
[`csv::Reader::deserialize`]メソッドを参照してください。

```rust
extern crate csv;
# #[macro_use]
# extern crate error_chain;
#[macro_use]
extern crate serde_derive;

# error_chain! {
#     foreign_links {
#         Reader(csv::Error);
#     }
# }
#
#[derive(Deserialize)]
struct Record {
    year: u16,
    make: String,
    model: String,
    description: String,
}

fn run() -> Result<()> {
    let csv = "year,make,model,description
1948,Porsche,356,Luxury sports car
1967,Ford,Mustang fastback 1967,American car";

    let mut reader = csv::Reader::from_reader(csv.as_bytes());

    for record in reader.deserialize() {
        let record: Record = record?;
        println!(
            "In {}, {} built the {} model. It is a {}.",
            record.year,
            record.make,
            record.model,
            record.description
        );
    }

    Ok(())
}
#
# quick_main!(run);
```

<!--[`csv::ByteRecord`]: https://docs.rs/csv/*/csv/struct.ByteRecord.html
 [`csv::Reader::deserialize`]: https://docs.rs/csv/*/csv/struct.Reader.html#method.deserialize
 [`csv::StringRecord`]: https://docs.rs/csv/*/csv/struct.StringRecord.html
-->
[`csv::ByteRecord`]: https://docs.rs/csv/*/csv/struct.ByteRecord.html
 [`csv::Reader::deserialize`]: https://docs.rs/csv/*/csv/struct.Reader.html#method.deserialize
 [`csv::ByteRecord`]: https://docs.rs/csv/*/csv/struct.ByteRecord.html
 [`csv::StringRecord`]: https://docs.rs/csv/*/csv/struct.StringRecord.html

