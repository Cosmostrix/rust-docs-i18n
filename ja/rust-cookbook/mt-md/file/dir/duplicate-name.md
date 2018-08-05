## <!--Recursively find duplicate file names--> 再帰的に重複するファイル名を見つける

<!--[!][walkdir]-->
[！][walkdir]
<!--[walkdir-badge] [!][cat-filesystem]-->
[walkdir-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--Find recursively in the current directory duplicate filenames, printing them only once.-->
カレントディレクトリのファイル名を複製して再帰的に検索し、一度だけ印刷します。

```rust,no_run
extern crate walkdir;

use std::collections::HashMap;
use walkdir::WalkDir;

fn main() {
    let mut filenames = HashMap::new();

    for entry in WalkDir::new(".")
            .into_iter()
            .filter_map(Result::ok)
            .filter(|e| !e.file_type().is_dir()) {
        let f_name = String::from(entry.file_name().to_string_lossy());
        let counter = filenames.entry(f_name.clone()).or_insert(0);
        *counter += 1;

        if *counter == 2 {
            println!("{}", f_name);
        }
    }
}
```
