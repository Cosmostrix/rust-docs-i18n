## <!--Recursively find all files with given predicate--> 与えられた述語を持つすべてのファイルを再帰的に見つける

<!--[!][walkdir]-->
[！][walkdir]
<!--[walkdir-badge] [!][cat-filesystem]-->
[walkdir-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--Find JSON files modified within the last day in the current directory.-->
最終日に変更されたJSONファイルを現在のディレクトリで検索します。
<!--Using [`follow_links`] ensures symbolic links are followed like they were normal directories and files.-->
[`follow_links`]を使うと、通常のディレクトリやファイルのようにシンボリックリンクを辿ることができます。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate walkdir;

use walkdir::WalkDir;
#
# error_chain! {
#     foreign_links {
#         WalkDir(walkdir::Error);
#         Io(std::io::Error);
#         SystemTime(std::time::SystemTimeError);
#     }
# }

fn run() -> Result<()> {
    for entry in WalkDir::new(".")
            .follow_links(true)
            .into_iter()
            .filter_map(|e| e.ok()) {
        let f_name = entry.file_name().to_string_lossy();
        let sec = entry.metadata()?.modified()?;

        if f_name.ends_with(".json") && sec.elapsed()?.as_secs() < 86400 {
            println!("{}", f_name);
        }
    }

    Ok(())
}
#
# quick_main!(run);
```

[`follow_links`]: https://docs.rs/walkdir/*/walkdir/struct.WalkDir.html#method.follow_links
