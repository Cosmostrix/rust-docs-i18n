# <!--Filesystem Operations--> ファイルシステム操作

<!--The `std::fs` module contains several functions that deal with the filesystem.-->
`std::fs`モジュールには、ファイルシステムを扱ういくつかの関数が含まれています。

```rust,ignore
use std::fs;
use std::fs::{File, OpenOptions};
use std::io;
use std::io::prelude::*;
use std::os::unix;
use std::path::Path;

#// A simple implementation of `% cat path`
//  `% cat path`簡単な実装
fn cat(path: &Path) -> io::Result<String> {
    let mut f = File::open(path)?;
    let mut s = String::new();
    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}

#// A simple implementation of `% echo s > path`
//  `% echo s > path`簡単な実装
fn echo(s: &str, path: &Path) -> io::Result<()> {
    let mut f = File::create(path)?;

    f.write_all(s.as_bytes())
}

#// A simple implementation of `% touch path` (ignores existing files)
//  `% touch path`簡単な実装（既存のファイルを無視する）
fn touch(path: &Path) -> io::Result<()> {
    match OpenOptions::new().create(true).write(true).open(path) {
        Ok(_) => Ok(()),
        Err(e) => Err(e),
    }
}

fn main() {
    println!("`mkdir a`");
#    // Create a directory, returns `io::Result<()>`
    // ディレクトリを作成し、`io::Result<()>`返します。
    match fs::create_dir("a") {
        Err(why) => println!("! {:?}", why.kind()),
        Ok(_) => {},
    }

    println!("`echo hello > a/b.txt`");
#    // The previous match can be simplified using the `unwrap_or_else` method
    // 前のマッチは、`unwrap_or_else`メソッドを使って簡略化できます
    echo("hello", &Path::new("a/b.txt")).unwrap_or_else(|why| {
        println!("! {:?}", why.kind());
    });

    println!("`mkdir -p a/c/d`");
#    // Recursively create a directory, returns `io::Result<()>`
    // 再帰的にディレクトリを作成し、`io::Result<()>`返します。
    fs::create_dir_all("a/c/d").unwrap_or_else(|why| {
        println!("! {:?}", why.kind());
    });

    println!("`touch a/c/e.txt`");
    touch(&Path::new("a/c/e.txt")).unwrap_or_else(|why| {
        println!("! {:?}", why.kind());
    });

    println!("`ln -s ../b.txt a/c/b.txt`");
#    // Create a symbolic link, returns `io::Result<()>`
    // シンボリックリンクを作成し、`io::Result<()>`返します。
    if cfg!(target_family = "unix") {
        unix::fs::symlink("../b.txt", "a/c/b.txt").unwrap_or_else(|why| {
        println!("! {:?}", why.kind());
        });
    }

    println!("`cat a/c/b.txt`");
    match cat(&Path::new("a/c/b.txt")) {
        Err(why) => println!("! {:?}", why.kind()),
        Ok(s) => println!("> {}", s),
    }

    println!("`ls a`");
#    // Read the contents of a directory, returns `io::Result<Vec<Path>>`
    // ディレクトリの内容を読み込み、`io::Result<Vec<Path>>`返します。
    match fs::read_dir("a") {
        Err(why) => println!("! {:?}", why.kind()),
        Ok(paths) => for path in paths {
            println!("> {:?}", path.unwrap().path());
        },
    }

    println!("`rm a/c/e.txt`");
#    // Remove a file, returns `io::Result<()>`
    // ファイルを削除し、`io::Result<()>`返します。
    fs::remove_file("a/c/e.txt").unwrap_or_else(|why| {
        println!("! {:?}", why.kind());
    });

    println!("`rmdir a/c/d`");
#    // Remove an empty directory, returns `io::Result<()>`
    // 空のディレクトリを削除し、`io::Result<()>`返します。
    fs::remove_dir("a/c/d").unwrap_or_else(|why| {
        println!("! {:?}", why.kind());
    });
}

```

<!--Here's the expected successful output:-->
予想される成果は次のとおりです。

```bash
$ rustc fs.rs && ./fs
`mkdir a`
`echo hello > a/b.txt`
`mkdir -p a/c/d`
`touch a/c/e.txt`
`ln -s ../b.txt a/c/b.txt`
`cat a/c/b.txt`
> hello
`ls a`
> "a/b.txt"
> "a/c"
`rm a/c/e.txt`
`rmdir a/c/d`
```

<!--And the final state of the `a` directory is:-->
そして、の最終状態ディレクトリは次のとおりです。`a`

```text
$ tree a
a
|-- b.txt
`-- c
    `-- b.txt -> ../b.txt

1 directory, 2 files
```

<!--An alternative way to define the function `cat` is with `?`-->
関数`cat`を定義する別の方法は`?`
<!--notation:-->
表記法：

```rust,ignore
fn cat(path: &Path) -> io::Result<String> {
    let mut f = File::open(path)?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}
```

### <!--See also:--> 参照：

[`cfg!`][cfg]
[cfg]: attribute/cfg.html
