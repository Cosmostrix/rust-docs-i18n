## <!--Handle invalid CSV data with Serde--> Serdeで無効なCSVデータを処理する

<!--[!][csv]-->
[！][csv]
<!--[csv-badge] [!][serde]-->
[csv-badge] [！][serde]
<!--[serde-badge] [!][cat-encoding]-->
[serde-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--CSV files often contain invalid data.-->
CSVファイルには無効なデータが含まれることがよくあります。
<!--For these cases, the `csv` crate provides a custom deserializer, [`csv::invalid_option`], which automatically converts invalid data to None values.-->
このような場合、`csv` [`csv::invalid_option`]はカスタムデシリアライザ[`csv::invalid_option`]提供します。これは無効なデータを自動的にNone値に変換します。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate csv;
#[macro_use]
extern crate serde_derive;

#[derive(Debug, Deserialize)]
struct Record {
    name: String,
    place: String,
    #[serde(deserialize_with = "csv::invalid_option")]
    id: Option<u64>,
}
#
# error_chain! {
#     foreign_links {
#         CsvError(csv::Error);
#     }
# }

fn run() -> Result<()> {
    let data = "name,place,id
mark,sydney,46.5
ashley,zurich,92
akshat,delhi,37
alisha,colombo,xyz";

    let mut rdr = csv::Reader::from_reader(data.as_bytes());
    for result in rdr.deserialize() {
        let record: Record = result?;
        println!("{:?}", record);
    }

    Ok(())
}
#
# quick_main!(run);
```

[`csv::invalid_option`]: https://docs.rs/csv/*/csv/fn.invalid_option.html
