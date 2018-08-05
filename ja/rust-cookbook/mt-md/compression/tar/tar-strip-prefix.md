## <!--Decompress a tarball while removing a prefix from the paths--> パスからプレフィックスを削除しながらtarballを解凍する

<!--[!][flate2]-->
[！][flate2]
<!--[flate2-badge] [!][tar]-->
[flate2-badge] [！][tar]
<!--[tar-badge] [!][cat-compression]-->
[tar-badge] [！][cat-compression]
[cat-compression-badge]
<!--Iterate over the [`Archive::entries`].-->
[`Archive::entries`]ます。
<!--Use [`Path::strip_prefix`] to remove the specified path prefix (`bundle/logs`).-->
[`Path::strip_prefix`]を使用して、指定されたパスプレフィックス（`bundle/logs`）を削除します。
<!--Finally, extract the [`tar::Entry`] via [`Entry::unpack`].-->
最後に、[`Entry::unpack`]介して[`tar::Entry`]を[`Entry::unpack`]ます。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate flate2;
extern crate tar;
#
# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#         StripPrefixError(::std::path::StripPrefixError);
#     }
# }

use std::fs::File;
use std::path::PathBuf;
use flate2::read::GzDecoder;
use tar::Archive;

fn run() -> Result<()> {
    let file = File::open("archive.tar.gz")?;
    let mut archive = Archive::new(GzDecoder::new(file));
    let prefix = "bundle/logs";

    println!("Extracted the following files:");
    archive
        .entries()?
        .filter_map(|e| e.ok())
        .map(|mut entry| -> Result<PathBuf> {
            let path = entry.path()?.strip_prefix(prefix)?.to_owned();
            entry.unpack(&path)?;
            Ok(path)
        })
        .filter_map(|e| e.ok())
        .for_each(|x| println!("> {}", x.display()));

    Ok(())
}
#
# quick_main!(run);
```

<!--[`Archive::entries`]: https://docs.rs/tar/*/tar/struct.Archive.html#method.entries
 [`Entry::unpack`]: https://docs.rs/tar/*/tar/struct.Entry.html#method.unpack
 [`Path::strip_prefix`]: https://doc.rust-lang.org/std/path/struct.Path.html#method.strip_prefix
 [`tar::Entry`]: https://docs.rs/tar/*/tar/struct.Entry.html
-->
[`Archive::entries`]: https://docs.rs/tar/*/tar/struct.Archive.html#method.entries
 [`Entry::unpack`]: https://docs.rs/tar/*/tar/struct.Entry.html#method.unpack
 [`Path::strip_prefix`]: https://doc.rust-lang.org/std/path/struct.Path.html#method.strip_prefix
 [`tar::Entry`]: https://docs.rs/tar/*/tar/struct.Entry.html

