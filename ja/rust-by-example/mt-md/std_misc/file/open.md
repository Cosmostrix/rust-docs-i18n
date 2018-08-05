# `open`
<!--The `open` static method can be used to open a file in read-only mode.-->
`open`スタティックメソッドを使用して、読み取り専用モードでファイルを開くことができます。

<!--A `File` owns a resource, the file descriptor and takes care of closing the file when it is `drop` ed.-->
`File`は、ファイル記述子であるリソースを所有し、ファイルが`drop`ときにそのファイルを閉じる処理を行います。

```rust,editable,ignore
use std::error::Error;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

fn main() {
#    // Create a path to the desired file
    // 目的のファイルへのパスを作成する
    let path = Path::new("hello.txt");
    let display = path.display();

#    // Open the path in read-only mode, returns `io::Result<File>`
    // 読み取り専用モードでパスを開き、`io::Result<File>`
    let mut file = match File::open(&path) {
#        // The `description` method of `io::Error` returns a string that
#        // describes the error
        //  `io::Error`の`description`メソッドは、エラーを記述する文字列を返します
        Err(why) => panic!("couldn't open {}: {}", display,
                                                   why.description()),
        Ok(file) => file,
    };

#    // Read the file contents into a string, returns `io::Result<usize>`
    // ファイルの内容を文字列に読み込み、`io::Result<usize>`返します。
    let mut s = String::new();
    match file.read_to_string(&mut s) {
        Err(why) => panic!("couldn't read {}: {}", display,
                                                   why.description()),
        Ok(_) => print!("{} contains:\n{}", display, s),
    }

#    // `file` goes out of scope, and the "hello.txt" file gets closed
    //  `file`が有効範囲外になり、「hello.txt」ファイルがクローズする
}

```

<!--Here's the expected successful output:-->
予想される成果は次のとおりです。

```bash
$ echo "Hello World!" > hello.txt
$ rustc open.rs && ./open
hello.txt contains:
Hello World!
```

<!--(You are encouraged to test the previous example under different failure conditions: `hello.txt` doesn't exist, or `hello.txt` is not readable, etc.)-->
（`hello.txt`が存在しないか、`hello.txt`が読み込めないなどのさまざまな障害条件で前の例をテストすることをお勧めします）
