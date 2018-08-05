## <!--Access a file randomly using a memory map--> メモリマップを使用してランダムにファイルにアクセスする

<!--[!][memmap]-->
[！][memmap]
<!--[memmap-badge] [!][cat-filesystem]-->
[memmap-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--Creates a memory map of a file using [memmap] and simulates some non-sequential reads from the file.-->
[memmap]を使用してファイルのメモリマップを作成し、ファイルからの非シーケンシャル読み取りをシミュレートします。
<!--Using a memory map means you just index into a slice rather than dealing with [`seek`] to navigate a File.-->
メモリマップを使用すると、ファイルをナビゲートするための[`seek`]を扱うのではなく、スライスにインデックスを[`seek`]です。

<!--The [`Mmap::map`] function assumes the file behind the memory map is not being modified at the same time by another process or else a [race condition] occurs.-->
[`Mmap::map`]関数は、メモリマップの背後にあるファイルが別のプロセスによって同時に変更されていないか、[race condition]が発生していると[`Mmap::map`]ます。

```rust
# #[macro_use]
# extern crate error_chain;
extern crate memmap;

use memmap::Mmap;
# use std::fs::File;
# use std::io::Write;
#
# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#     }
# }

fn run() -> Result<()> {
#     write!(File::create("content.txt")?, "My hovercraft is full of eels!")?;
#
    let file = File::open("content.txt")?;
    let map = unsafe { Mmap::map(&file)? };

    let random_indexes = [0, 1, 2, 19, 22, 10, 11, 29];
    assert_eq!(&map[3..13], b"hovercraft");
    let random_bytes: Vec<u8> = random_indexes.iter()
        .map(|&idx| map[idx])
        .collect();
    assert_eq!(&random_bytes[..], b"My loaf!");
    Ok(())
}
#
# quick_main!(run);
```

<!--[`Mmap::map`]: https://docs.rs/memmap/*/memmap/struct.Mmap.html#method.map
 [`seek`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.seek
-->
[`Mmap::map`]: https://docs.rs/memmap/*/memmap/struct.Mmap.html#method.map
 [`seek`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.seek


[race condition]: https://en.wikipedia.org/wiki/Race_condition#File_systems
