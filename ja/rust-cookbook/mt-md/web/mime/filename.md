## <!--Get MIME type from filename--> ファイル名からMIMEタイプを取得する

<!--[!][mime]-->
[！][mime]
<!--[mime-badge] [!][cat-encoding]-->
[mime-badge] [！][cat-encoding]
[cat-encoding-badge]
<!--The following example shows how to return the correct MIME type from a given filename using the [mime] crate.-->
次の例は、[mime]ファイルを使用して、特定のファイル名から正しいMIMEタイプを返す方法を示しています。
<!--The program will check for file extensions and match against a known list.-->
プログラムは、ファイルの拡張子を確認し、既知のリストと照合します。
<!--The return value is [`mime:Mime`].-->
戻り値は[`mime:Mime`]です。

```rust
extern crate mime;
use mime::Mime;

fn find_mimetype (filename : &String) -> Mime{

    let parts : Vec<&str> = filename.split('.').collect();

    let res = match parts.last() {
            Some(v) =>
                match *v {
                    "png" => mime::IMAGE_PNG,
                    "jpg" => mime::IMAGE_JPEG,
                    "json" => mime::APPLICATION_JSON,
                    &_ => mime::TEXT_PLAIN,
                },
            None => mime::TEXT_PLAIN,
        };
    return res;
}

fn main() {
    let filenames = vec!("foobar.jpg", "foo.bar", "foobar.png");
    for file in filenames {
	    let mime = find_mimetype(&file.to_owned());
	 	println!("MIME for {}: {}", file, mime);
	 }

}
```

[`mime:Mime`]: https://docs.rs/mime/*/mime/struct.Mime.html
