# <!--Path--> パス

<!--The `Path` struct represents file paths in the underlying filesystem.-->
`Path`構造体は、基礎となるファイルシステム内のファイルパスを表します。
<!--There are two flavors of `Path`: `posix::Path`, for UNIX-like systems, and `windows::Path`, for Windows.-->
2つの味があります`Path`： `posix::Path` UNIXライクなシステムのため、そして`windows::Path` Windows用には、。
<!--The prelude exports the appropriate platform-specific `Path` variant.-->
プレリュードは、適切なプラットフォーム固有の`Path`バリアントをエクスポートします。

<!--A `Path` can be created from an `OsStr`, and provides several methods to get information from the file/directory the path points to.-->
`Path`は`OsStr`から作成することができ、パスが指すファイル/ディレクトリから情報を取得するいくつかのメソッドを提供します。

<!--Note that a `Path` is *not* internally represented as an UTF-8 string, but instead is stored as a vector of bytes (`Vec<u8>`).-->
ことに留意されたい`Path`内部的にUTF-8文字列として表現され*ていない*が、代わりにバイトのベクトルとして格納される（`Vec<u8>`
<!--Therefore, converting a `Path` to a `&str` is *not* free and may fail (an `Option` is returned).-->
したがって、`Path`を`&str`に変換すること*は*自由では*なく*、失敗する可能性があります（ `Option`が返されます）。

```rust,editable
use std::path::Path;

fn main() {
#    // Create a `Path` from an `&'static str`
    //  `&'static str`から`Path`を作成する
    let path = Path::new(".");

#    // The `display` method returns a `Show`able structure
    //  `display`メソッドは、`Show` able構造体を返します。
    let _display = path.display();

#    // `join` merges a path with a byte container using the OS specific
#    // separator, and returns the new path
    //  `join`は、OS固有の区切り文字を使用してパスをバイトコンテナとマージし、新しいパスを返します
    let new_path = path.join("a").join("b");

#    // Convert the path into a string slice
    // パスを文字列スライスに変換する
    match new_path.to_str() {
        None => panic!("new path is not a valid UTF-8 sequence"),
        Some(s) => println!("new path is {}", s),
    }
}

```

<!--Be sure to check at other `Path` methods (`posix::Path` or `windows::Path`) and the `Metadata` struct.-->
他の`Path`メソッド（`posix::Path`または`windows::Path`）と`Metadata`構造体を確認してください。

### <!--See also--> も参照してください

<!--[OsStr][1] and [Metadata][2].-->
[OsStr][1]と[Metadata][2]。

<!--[1]: https://doc.rust-lang.org/std/ffi/struct.OsStr.html
 [2]: https://doc.rust-lang.org/std/fs/struct.Metadata.html
-->
[1]: https://doc.rust-lang.org/std/ffi/struct.OsStr.html
 [2]: https://doc.rust-lang.org/std/fs/struct.Metadata.html

