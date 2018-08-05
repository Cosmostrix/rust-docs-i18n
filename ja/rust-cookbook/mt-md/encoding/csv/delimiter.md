## <!--Read CSV records with different delimiter--> 異なる区切り文字を使用してCSVレコードを読み取る

<!--[!][csv]-->
[！][csv]
<!--[csv-badge] [!][cat-encoding]-->
[csv-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--Reads CSV records with a tab [`delimiter`].-->
CSVレコードをタブ[`delimiter`]で読み込みます。

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

use csv::ReaderBuilder;
#
# error_chain! {
#     foreign_links {
#         CsvError(csv::Error);
#     }
# }

fn run() -> Result<()> {
    let data = "name\tplace\tid
Mark\tMelbourne\t46
Ashley\tZurich\t92";

    let mut reader = ReaderBuilder::new().delimiter(b'\t').from_reader(data.as_bytes());
    for result in reader.records() {
        println!("{:?}", result?);
    }

    Ok(())
}
#
# quick_main!(run);
```

[`delimiter`]: https://docs.rs/csv/1.0.0-beta.3/csv/struct.ReaderBuilder.html#method.delimiter
