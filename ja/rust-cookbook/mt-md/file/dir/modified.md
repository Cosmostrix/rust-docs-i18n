## <!--File names that have been modified in the last 24 hours--> 過去24時間以内に変更されたファイル名

<!--[!][std]-->
[！][std]
<!--[std-badge] [!][cat-filesystem]-->
[std-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--Gets the current working directory by calling [`env::current_dir`], then for each entries in [`fs::read_dir`], extracts the [`DirEntry::path`] and gets the metada via [`fs::Metadata`].-->
[`env::current_dir`]呼び出して現在の作業ディレクトリを取得し、[`fs::read_dir`]各エントリに対して[`DirEntry::path`]を抽出し、[`fs::Metadata`]介して[`fs::Metadata`]を取得します。
<!--The [`Metadata::modified`] returns the [`SystemTime::elapsed`] time since last modification.-->
[`Metadata::modified`]は最後の変更から[`SystemTime::elapsed`]時間を返します。
<!--[`Duration::as_secs`] converts the time to seconds and compared with 24 hours (24 * 60 * 60 seconds).-->
[`Duration::as_secs`]は時間を秒に変換し、24時間（24 * 60 * 60秒）と比較します。
<!--[`Metadata::is_file`] filters out directories.-->
[`Metadata::is_file`]ディレクトリをフィルタリングします。

```rust
# #[macro_use]
# extern crate error_chain;
#
use std::{env, fs};

# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#         SystemTimeError(std::time::SystemTimeError);
#     }
# }
#
fn run() -> Result<()> {
    let current_dir = env::current_dir()?;
    println!(
        "Entries modified in the last 24 hours in {:?}:",
        current_dir
    );

    for entry in fs::read_dir(current_dir)? {
        let entry = entry?;
        let path = entry.path();

        let metadata = fs::metadata(&path)?;
        let last_modified = metadata.modified()?.elapsed()?.as_secs();

        if last_modified < 24 * 3600 && metadata.is_file() {
            println!(
                "Last modified: {:?} seconds, is read only: {:?}, size: {:?} bytes, filename: {:?}",
                last_modified,
                metadata.permissions().readonly(),
                metadata.len(),
                path.file_name().ok_or("No filename")?
            );
        }
    }

    Ok(())
}
#
# quick_main!(run);
```

<!--[`DirEntry::path`]: https://doc.rust-lang.org/std/fs/struct.DirEntry.html#method.path
 [`Duration::as_secs`]: https://doc.rust-lang.org/std/time/struct.Duration.html#method.as_secs
 [`env::current_dir`]: https://doc.rust-lang.org/std/env/fn.current_dir.html
 [`fs::Metadata`]: https://doc.rust-lang.org/std/fs/struct.Metadata.html
 [`fs::read_dir`]: https://doc.rust-lang.org/std/fs/fn.read_dir.html
 [`Metadata::is_file`]: https://doc.rust-lang.org/std/fs/struct.Metadata.html#method.is_file
 [`Metadata::modified`]: https://doc.rust-lang.org/std/fs/struct.Metadata.html#method.modified
 [`SystemTime::elapsed`]: https://doc.rust-lang.org/std/time/struct.SystemTime.html#method.elapsed
-->
[`DirEntry::path`]: https://doc.rust-lang.org/std/fs/struct.DirEntry.html#method.path
 [`Duration::as_secs`]: https://doc.rust-lang.org/std/time/struct.Duration.html#method.as_secs
 [`env::current_dir`]: https://doc.rust-lang.org/std/env/fn.current_dir.html
 [`fs::Metadata`]: https://doc.rust-lang.org/std/fs/struct.Metadata.html
 [`fs::read_dir`]: https://doc.rust-lang.org/std/fs/fn.read_dir.html
 [`Metadata::is_file`]: https://doc.rust-lang.org/std/fs/struct.Metadata.html#method.is_file
 [`Metadata::modified`]: https://doc.rust-lang.org/std/fs/struct.Metadata.html#method.modified
 [`SystemTime::elapsed`]: https://doc.rust-lang.org/std/time/struct.SystemTime.html#method.elapsed

