# `create`
<!--The `create` static method opens a file in write-only mode.-->
`create` staticメソッドは、書き込み専用モードでファイルを開きます。
<!--If the file already existed, the old content is destroyed.-->
ファイルが既に存在する場合、古いコンテンツは破棄されます。
<!--Otherwise, a new file is created.-->
それ以外の場合は、新しいファイルが作成されます。

```rust,ignore
static LOREM_IPSUM: &'static str =
"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
";

use std::error::Error;
use std::io::prelude::*;
use std::fs::File;
use std::path::Path;

fn main() {
    let path = Path::new("out/lorem_ipsum.txt");
    let display = path.display();

#    // Open a file in write-only mode, returns `io::Result<File>`
    // 書き込み専用モードでファイルを開き、`io::Result<File>`返します。
    let mut file = match File::create(&path) {
        Err(why) => panic!("couldn't create {}: {}",
                           display,
                           why.description()),
        Ok(file) => file,
    };

#    // Write the `LOREM_IPSUM` string to `file`, returns `io::Result<()>`
    //  `LOREM_IPSUM`文字列を`file`書き込み、`io::Result<()>`返します。
    match file.write_all(LOREM_IPSUM.as_bytes()) {
        Err(why) => {
            panic!("couldn't write to {}: {}", display,
                                               why.description())
        },
        Ok(_) => println!("successfully wrote to {}", display),
    }
}
```

<!--Here's the expected successful output:-->
予想される成果は次のとおりです。

```bash
$ mkdir out
$ rustc create.rs && ./create
successfully wrote to out/lorem_ipsum.txt
$ cat out/lorem_ipsum.txt
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
```

<!--(As in the previous example, you are encouraged to test this example under failure conditions.)-->
（前の例と同様に、この例を失敗条件でテストすることをお勧めします）。

<!--There is also a more generic `open_mode` method that can open files in other modes like: read+write, append, etc.-->
より一般的な`open_mode`メソッドもあります。これは、read + write、appendなどのような他のモードでファイルを開くことができます。
