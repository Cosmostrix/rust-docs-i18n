## <!--Find all files with given pattern ignoring filename case.--> ファイル名の大文字小文字を無視して、指定されたパターンを持つすべてのファイル

<!--[!][glob]-->
[！][glob]
<!--[glob-badge] [!][cat-filesystem]-->
[glob-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--Find all image files in the `/media/` directory matching the `img_[0-9]*.png` pattern.-->
`img_[0-9]*.png`パターンと一致する`/media/`ディレクトリ内のすべてのイメージファイルを検索します。

<!--A custom [`MatchOptions`] struct is passed to the [`glob_with`] function making the glob pattern case insensitive while keeping the other options [`Default`].-->
カスタムの[`MatchOptions`]構造体は[`glob_with`]関数に渡され、他のオプション[`Default`]を保持したまま大文字小文字を区別し[`Default`]。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate glob;

use glob::{glob_with, MatchOptions};
#
# error_chain! {
#     foreign_links {
#         Glob(glob::GlobError);
#         Pattern(glob::PatternError);
#     }
# }

fn run() -> Result<()> {
    let options = MatchOptions {
        case_sensitive: false,
        ..Default::default()
    };

    for entry in glob_with("/media/img_[0-9]*.png", &options)? {
        println!("{}", entry?.display());
    }

    Ok(())
}
#
# quick_main!(run);
```

<!--[`Default`]: https://doc.rust-lang.org/std/default/trait.Default.html
 [`glob_with`]: https://docs.rs/glob/*/glob/fn.glob_with.html
 [`MatchOptions`]: https://docs.rs/glob/*/glob/struct.MatchOptions.html
-->
[`Default`]: https://doc.rust-lang.org/std/default/trait.Default.html
 [`glob_with`]: https://docs.rs/glob/*/glob/fn.glob_with.html
 [`MatchOptions`]: https://docs.rs/glob/*/glob/struct.MatchOptions.html

