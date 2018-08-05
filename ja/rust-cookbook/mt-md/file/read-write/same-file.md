## <!--Avoid writing and reading from a same file--> 同じファイルからの書き込みと読み取りを避ける

<!--[!][same_file]-->
[！][same_file]
<!--[same_file-badge] [!][cat-filesystem]-->
[same_file-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--Use [`same_file::Handle`] to a file that can be tested for equality with other handles.-->
[`same_file::Handle`]を他のハンドルと同等かどうかをテストできるファイルに使用してください。
<!--In this example, the handles of file to be read from and to be written to are tested for equality.-->
この例では、読み取られるファイルと書き込まれるファイルのハンドルが等しいかどうかがテストされます。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate same_file;

use same_file::Handle;
use std::path::Path;
use std::fs::File;
use std::io::{BufRead, BufReader};
#
# error_chain! {
#     foreign_links {
#          IOError(::std::io::Error);
#     }
# }

fn run() -> Result<()> {
    let path_to_read = Path::new("new.txt");

    let stdout_handle = Handle::stdout()?;
    let handle = Handle::from_path(path_to_read)?;

    if stdout_handle == handle {
        bail!("You are reading and writing to the same file");
    } else {
        let file = File::open(&path_to_read)?;
        let file = BufReader::new(file);
        for (num, line) in file.lines().enumerate() {
            println!("{} : {}", num, line?.to_uppercase());
        }
    }

    Ok(())
}
#
# quick_main!(run);
```

```bash
cargo run
```
<!--displays the contents of the file new.txt.-->
new.txtファイルの内容を表示します。

```bash
cargo run >> ./new.txt
```
<!--errors because the two files are same.-->
2つのファイルが同じであるためにエラーが発生します。

[`same_file::Handle`]: https://docs.rs/same-file/*/same_file/struct.Handle.html
