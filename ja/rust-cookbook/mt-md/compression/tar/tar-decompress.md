## <!--Decompress a tarball--> タールボールを解凍する

<!--[!][flate2]-->
[！][flate2]
<!--[flate2-badge] [!][tar]-->
[flate2-badge] [！][tar]
<!--[tar-badge] [!][cat-compression]-->
[tar-badge] [！][cat-compression]
[cat-compression-badge]
<!--Decompress ([`GzDecoder`]) and extract ([`Archive::unpack`]) all files from a compressed tarball named `archive.tar.gz` located in the current working directory to the same location.-->
現在の作業ディレクトリにある`archive.tar.gz`という圧縮されたタールボールからすべてのファイルを解凍（[`GzDecoder`]）し、解凍します（ [`Archive::unpack`]）。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate flate2;
extern crate tar;

use std::fs::File;
use flate2::read::GzDecoder;
use tar::Archive;
#
# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#     }
# }

fn run() -> Result<()> {
    let path = "archive.tar.gz";

    let tar_gz = File::open(path)?;
    let tar = GzDecoder::new(tar_gz);
    let mut archive = Archive::new(tar);
    archive.unpack(".")?;

    Ok(())
}
#
# quick_main!(run);
```

<!--[`Archive::unpack`]: https://docs.rs/tar/*/tar/struct.Archive.html#method.unpack
 [`GzDecoder`]: https://docs.rs/flate2/*/flate2/read/struct.GzDecoder.html
-->
[`Archive::unpack`]: https://docs.rs/tar/*/tar/struct.Archive.html#method.unpack
 [`GzDecoder`]: https://docs.rs/flate2/*/flate2/read/struct.GzDecoder.html

