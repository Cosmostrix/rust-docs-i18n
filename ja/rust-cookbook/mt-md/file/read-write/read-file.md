## <!--Read lines of strings from a file--> ファイルから文字列の行を読み込む

<!--[!][std]-->
[！][std]
<!--[std-badge] [!][cat-filesystem]-->
[std-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--Writes a three-line message to a file, then reads it back a line at a time with the [`Lines`] iterator created by [`BufRead::lines`].-->
3行のメッセージをファイルに書き込み、[`BufRead::lines`]作成した[`Lines`]イテレータで一度に1行ずつ[`Lines`]ます。
<!--[`File`] implements [`Read`] which provides [`BufReader`] trait.-->
[`File`]実装[`Read`]提供[`BufReader`]形質を。
<!--[`File::create`] opens a [`File`] for writing, [`File::open`] for reading.-->
[`File::create`]開き[`File`]書き込みのために、[`File::open`]読書のために。

```rust
# #[macro_use]
# extern crate error_chain;
#
use std::fs::File;
use std::io::{Write, BufReader, BufRead};
#
# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#     }
# }

fn run() -> Result<()> {
    let path = "lines.txt";

    let mut output = File::create(path)?;
    write!(output, "Rust\nðŸ’–\nFun")?;

    let input = File::open(path)?;
    let buffered = BufReader::new(input);

    for line in buffered.lines() {
        println!("{}", line?);
    }

    Ok(())
}
#
# quick_main!(run);
```

<!--[`BufRead::lines`]: https://doc.rust-lang.org/std/io/trait.BufRead.html#method.lines
 [`BufRead`]: https://doc.rust-lang.org/std/io/trait.BufRead.html
 [`BufReader`]: https://doc.rust-lang.org/std/io/struct.BufReader.html
 [`File::create`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.create
 [`File::open`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.open
 [`File`]: https://doc.rust-lang.org/std/fs/struct.File.html
 [`Lines`]: https://doc.rust-lang.org/std/io/struct.Lines.html
 [`Read`]: https://doc.rust-lang.org/std/io/trait.Read.html
-->
[`BufRead::lines`]: https://doc.rust-lang.org/std/io/trait.BufRead.html#method.lines
 [`BufRead`]: https://doc.rust-lang.org/std/io/trait.BufRead.html
 [`BufReader`]: https://doc.rust-lang.org/std/io/struct.BufReader.html
 [`File::create`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.create
 [`File::open`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.open
 [`File`]: https://doc.rust-lang.org/std/fs/struct.File.html
 [`Lines`]: https://doc.rust-lang.org/std/io/struct.Lines.html
 [`Read`]: https://doc.rust-lang.org/std/io/trait.Read.html

