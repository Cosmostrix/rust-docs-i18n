## <!--Serialize records to CSV using Serde--> Serdeを使用してレコードをCSVにシリアル化する

<!--[!][csv]-->
[！][csv]
<!--[csv-badge] [!][serde]-->
[csv-badge] [！][serde]
<!--[serde-badge] [!][cat-encoding]-->
[serde-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--The following example shows how to serialize custom structs as CSV records using the [serde] crate.-->
次の例は、[serde]を使用してカスタム構造体をCSVレコードとしてシリアル化する方法を示しています。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate csv;
#[macro_use]
extern crate serde_derive;

use std::io;
#
# error_chain! {
#    foreign_links {
#        IOError(std::io::Error);
#        CSVError(csv::Error);
#    }
# }

#[derive(Serialize)]
struct Record<'a> {
    name: &'a str,
    place: &'a str,
    id: u64,
}

fn run() -> Result<()> {
    let mut wtr = csv::Writer::from_writer(io::stdout());

    let rec1 = Record { name: "Mark", place: "Melbourne", id: 56};
    let rec2 = Record { name: "Ashley", place: "Sydney", id: 64};
    let rec3 = Record { name: "Akshat", place: "Delhi", id: 98};

    wtr.serialize(rec1)?;
    wtr.serialize(rec2)?;
    wtr.serialize(rec3)?;

    wtr.flush()?;

    Ok(())
}
#
# quick_main!(run);
```
