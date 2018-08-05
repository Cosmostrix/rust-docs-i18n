## <!--Recursively calculate file sizes at given depth--> 与えられた深さでファイルサイズを再帰的に計算する

<!--[!][walkdir]-->
[！][walkdir]
<!--[walkdir-badge] [!][cat-filesystem]-->
[walkdir-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--Recursion depth can be flexibly set by [`WalkDir::min_depth`] & [`WalkDir::max_depth`] methods.-->
再帰深度は、[`WalkDir::min_depth`]と[`WalkDir::max_depth`]メソッドによって柔軟に設定できます。
<!--Calculates sum of all file sizes to 3 subfolders depth, ignoring files in the root folder.-->
すべてのファイルサイズの合計を3つのサブフォルダの深さに計算し、ルートフォルダ内のファイルは無視します。

```rust
extern crate walkdir;

use walkdir::WalkDir;

fn main() {
    let total_size = WalkDir::new(".")
        .min_depth(1)
        .max_depth(3)
        .into_iter()
        .filter_map(|entry| entry.ok())
        .filter_map(|entry| entry.metadata().ok())
        .filter(|metadata| metadata.is_file())
        .fold(0, |acc, m| acc + m.len());

    println!("Total size: {} bytes.", total_size);
}
```

<!--[`WalkDir::max_depth`]: https://docs.rs/walkdir/*/walkdir/struct.WalkDir.html#method.max_depth
 [`WalkDir::min_depth`]: https://docs.rs/walkdir/*/walkdir/struct.WalkDir.html#method.min_depth
-->
[`WalkDir::max_depth`]: https://docs.rs/walkdir/*/walkdir/struct.WalkDir.html#method.max_depth
 [`WalkDir::min_depth`]: https://docs.rs/walkdir/*/walkdir/struct.WalkDir.html#method.min_depth

