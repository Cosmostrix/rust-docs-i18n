## <!--Compress a directory into tarball--> ディレクトリをtarballに圧縮する

<!--[!][flate2]-->
[！][flate2]
<!--[flate2-badge] [!][tar]-->
[flate2-badge] [！][tar]
<!--[tar-badge] [!][cat-compression]-->
[tar-badge] [！][cat-compression]
[cat-compression-badge]
<!--Compress `/var/log` directory into `archive.tar.gz`.-->
`archive.tar.gz` `/var/log`ディレクトリを圧縮し`/var/log`。

<!--Creates a [`File`] wrapped in [`GzEncoder`] and [`tar::Builder`].-->
[`GzEncoder`]と[`tar::Builder`] [`File`]ラップして作成します。
RawInline (Format "html") "</br>" <!--Adds contents of `/var/log` directory recursively into the archive under `backup/logs` path with [`Builder::append_dir_all`].-->
[`Builder::append_dir_all`]で`/var/log`ディレクトリの内容を`backup/logs`下のアーカイブに再帰的に追加し`/var/log`。
<!--[`GzEncoder`] is responsible for transparently compressing the data prior to writing it into `archive.tar.gz`.-->
[`GzEncoder`]は、`archive.tar.gz`に書き込む前にデータを透過的に圧縮します。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate tar;
extern crate flate2;
#
# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#     }
# }

use std::fs::File;
use flate2::Compression;
use flate2::write::GzEncoder;

fn run() -> Result<()> {
    let tar_gz = File::create("archive.tar.gz")?;
    let enc = GzEncoder::new(tar_gz, Compression::default());
    let mut tar = tar::Builder::new(enc);
    tar.append_dir_all("backup/logs", "/var/log")?;
    Ok(())
}
#
# quick_main!(run);
```

<!--[`Builder::append_dir_all`]: https://docs.rs/tar/*/tar/struct.Builder.html#method.append_dir_all
 [`File`]: https://doc.rust-lang.org/std/fs/struct.File.html
 [`GzEncoder`]: https://docs.rs/flate2/*/flate2/write/struct.GzEncoder.html
 [`tar::Builder`]: https://docs.rs/tar/*/tar/struct.Builder.html
-->
[`Builder::append_dir_all`]: https://docs.rs/tar/*/tar/struct.Builder.html#method.append_dir_all
 [`File`]: https://doc.rust-lang.org/std/fs/struct.File.html
 [`GzEncoder`]: https://docs.rs/flate2/*/flate2/write/struct.GzEncoder.html
 [`tar::Builder`]: https://docs.rs/tar/*/tar/struct.Builder.html

