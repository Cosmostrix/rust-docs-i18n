## <!--Find all png files recursively--> すべてのpngファイルを再帰的に検索する

<!--[!][glob]-->
[！][glob]
<!--[glob-badge] [!][cat-filesystem]-->
[glob-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--Recursively find all PNG files in the current directory.-->
現在のディレクトリ内のすべてのPNGファイルを再帰的に検索します。
<!--In this case, the `**` pattern matches the current directory and all subdirectories.-->
この場合、`**`パターンは現在のディレクトリとすべてのサブディレクトリと一致します。

<!--Use the `**` pattern in any path portion.-->
任意のパス部分に`**`パターンを使用します。
<!--For example, `/media/**/*.png` matches all PNGs in `media` and it's subdirectories.-->
たとえば、`/media/**/*.png` `media` /**/*.pngは、`media`内のすべてのPNGとそのサブディレクトリを照合し`media`。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate glob;

use glob::glob;
#
# error_chain! {
#     foreign_links {
#         Glob(glob::GlobError);
#         Pattern(glob::PatternError);
#     }
# }

fn run() -> Result<()> {
    for entry in glob("**/*.png")? {
        println!("{}", entry?.display());
    }

    Ok(())
}
#
# quick_main!(run);
```
