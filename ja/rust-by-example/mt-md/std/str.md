# <!--Strings--> 文字列

<!--There are two types of strings in Rust: `String` and `&str`.-->
Rustには`String`と`&str` 2種類の文字列があり`&str`。

<!--A `String` is stored as a vector of bytes (`Vec<u8>`), but guaranteed to always be a valid UTF-8 sequence.-->
`String`はバイトのベクトル（`Vec<u8>`）として格納されますが、常に有効なUTF-8シーケンスであることが保証されています。
<!--`String` is heap allocated, growable and not null terminated.-->
`String`は割り当てられたヒープであり、拡張可能であり、nullで終わらない。

<!--`&str` is a slice (`&[u8]`) that always points to a valid UTF-8 sequence, and can be used to view into a `String`, just like `&[T]` is a view into `Vec<T>`.-->
`&str`は、常に有効なUTF-8シーケンスを`&[u8]`スライス（`&[u8]`）で、 `&[T]`が`Vec<T>`ビューと同じように、`String`を表示するために使用できます。

```rust,editable
fn main() {
#    // (all the type annotations are superfluous)
#    // A reference to a string allocated in read only memory
    // （すべての型の注釈は余分です）読み取り専用メモリに割り当てられた文字列への参照
    let pangram: &'static str = "the quick brown fox jumps over the lazy dog";
    println!("Pangram: {}", pangram);

#    // Iterate over words in reverse, no new string is allocated
    // 逆順に単語を繰り返し、新しい文字列は割り当てられません
    println!("Words in reverse");
    for word in pangram.split_whitespace().rev() {
        println!("> {}", word);
    }

#    // Copy chars into a vector, sort and remove duplicates
    // 文字をベクトルにコピーし、重複をソートして削除する
    let mut chars: Vec<char> = pangram.chars().collect();
    chars.sort();
    chars.dedup();

#    // Create an empty and growable `String`
    // 空の拡張可能な`String`作成する
    let mut string = String::new();
    for c in chars {
#        // Insert a char at the end of string
        // 文字列の最後にcharを挿入する
        string.push(c);
#        // Insert a string at the end of string
        // 文字列の最後に文字列を挿入する
        string.push_str(", ");
    }

#    // The trimmed string is a slice to the original string, hence no new
#    // allocation is performed
    // トリムされた文字列は元の文字列のスライスなので、新しい割り当ては行われません
    let chars_to_trim: &[char] = &[' ', ','];
    let trimmed_str: &str = string.trim_matches(chars_to_trim);
    println!("Used characters: {}", trimmed_str);

#    // Heap allocate a string
    // ヒープが文字列を割り当てる
    let alice = String::from("I like dogs");
#    // Allocate new memory and store the modified string there
    // 新しいメモリを割り当て、そこに変更された文字列を格納する
    let bob: String = alice.replace("dog", "cat");

    println!("Alice says: {}", alice);
    println!("Bob says: {}", bob);
}
```

<!--More `str` / `String` methods can be found under the [std::str][str] and [std::string][string] modules-->
より多くの`str` / `String`メソッドは[std::str][str]と[std::string][string]モジュールの下にあります

## <!--Literals and escapes--> リテラルとエスケープ

<!--There are multiple ways to write string literals with special characters in them.-->
特殊文字を含む文字列リテラルを書くには、複数の方法があります。
<!--All result in a similar `&str` so it's best to use the form that is the most convenient to write.-->
すべての結果が似たような`&str`なるので、最も便利な書式を使用するのが最善です。
<!--Similarly there are multiple ways to write byte string literals, which all result in `&[u8; N]`-->
同様に、バイト文字列リテラルを書く方法はいくつかありますが、そのすべてが`&[u8; N]`
<!--`&[u8; N]`.-->
`&[u8; N]`。

<!--Generally special characters are escaped with a backslash character: `\`.-->
通常、特殊文字は`\`エスケープされます。
<!--This way you can add any character to your string, even unprintable ones and ones that you don't know how to type.-->
こうすることで、文字列に文字を追加することができます。印刷できない文字や、入力方法がわからない文字も追加できます。
<!--If you want a literal backslash, escape it with another one: `\\`-->
リテラルのバックスラッシュが必要な場合は、別のものでエスケープしてください： `\\`

<!--String or character literal delimiters occuring within a literal must be escaped: `"\""`, `'\''`.-->
リテラル内で発生する文字列または文字リテラルの区切り文字は、`"\""`、 `'\''`エスケープする必要があります。

```rust,editable
fn main() {
#    // You can use escapes to write bytes by their hexadecimal values...
    // エスケープを使って16進値でバイトを書くことができます...
    let byte_escape = "I'm writing \x52\x75\x73\x74!";
    println!("What are you doing\x3F (\\x3F means ?) {}", byte_escape);

#    // ...or Unicode code points.
    // ...またはUnicodeコードポイント。
    let unicode_codepoint = "\u{211D}";
    let character_name = "\"DOUBLE-STRUCK CAPITAL R\"";

    println!("Unicode character {} (U+211D) is called {}",
                unicode_codepoint, character_name );


    let long_string = "String literals
                        can span multiple lines.
                        The linebreak and indentation here ->\
                        <- can be escaped too!";
    println!("{}", long_string);
}
```

<!--Sometimes there are just too many characters that need to be escaped or it's just much more convenient to write a string out as-is.-->
時には、エスケープする必要がある文字が多すぎる場合や、現状のまま文字列を書き出す方がはるかに便利です。
<!--This is where raw string literals come into play.-->
これは生の文字列リテラルが動作する場所です。

```rust, editable
fn main() {
    let raw_str = r"Escapes don't work here: \x3F \u{211D}";
    println!("{}", raw_str);

#    // If you need quotes in a raw string, add a pair of #s
    // 生の文字列に引用符が必要な場合は、＃のペア
    let quotes = r#"And then I said: "There is no escape!""#;
    println!("{}", quotes);

#    // If you need "# in your string, just use more #s in the delimiter.
#    // There is no limit for the number of #s you can use.
    // あなたの文字列に "＃"が必要な場合は、デリミタで＃をさらに使用してください。使用できる＃の数に制限はありません。
    let longer_delimiter = r###"A string with "# in it. And even "##!"###;
    println!("{}", longer_delimiter);
}
```

<!--Want a string that's not UTF-8?-->
UTF-8ではない文字列が必要ですか？
<!--(Remember, `str` and `String` must be valid UTF-8) Or maybe you want an array of bytes that's mostly text?-->
（覚えておいて、`str`と`String`は有効なUTF-8でなければなりません）あるいは大部分はテキストの大部分の配列を必要としますか？
<!--Byte strings to the rescue!-->
救助へのバイト文字列！

```rust, editable
use std::str;

fn main() {
#    // Note that this is not actually a &str
    // これは実際には＆strではないことに注意してください
    let bytestring: &[u8; 20] = b"this is a bytestring";

#    // Byte arrays don't have Display so printing them is a bit limited
    // バイト配列にはDisplayがありませんので、印刷するには少し制限があります
    println!("A bytestring: {:?}", bytestring);

#    // Bytestrings can have byte escapes...
    // バイトストリングはバイトエスケープを持つことができます...
    let escaped = b"\x52\x75\x73\x74 as bytes";
#    // ...but no unicode escapes
#    // let escaped = b"\u{211D} is not allowed";
    // ...ユニコードのエスケープはエスケープできません。= b "\ u {211D}は許可されていません";
    println!("Some escaped bytes: {:?}", escaped);


#    // Raw bytestrings work just like raw strings
    // 生の文字列のように生のテクスチャリングが機能する
    let raw_bytestring = br"\u{211D} is not escaped here";
    println!("{:?}", raw_bytestring);

#    // Converting a byte array to str can fail
    // バイト配列をstrに変換すると失敗することがある
    if let Ok(my_str) = str::from_utf8(raw_bytestring) {
        println!("And the same as text: '{}'", my_str);
    }

    let quotes = br#"You can also use "fancier" formatting, \
                    like with normal raw strings"#;

#    // Bytestrings don't have to be UTF-8
    // バイトストリングはUTF-8である必要はありません
#//    let shift_jis = b"\x82\xe6\x82\xa8\x82\xb1\x82"; // "ようこそ" in SHIFT-JIS
    let shift_jis = b"\x82\xe6\x82\xa8\x82\xb1\x82"; //  SHIFT-JISの「ようこそ」

#    // But then they can't always be converted to str
    // しかし、それらは常にstrに変換することはできません
    match str::from_utf8(shift_jis) {
        Ok(my_str) => println!("Conversion successful: '{}'", my_str),
        Err(e) => println!("Conversion failed: {:?}", e),
    };
}
```

<!--For conversions between character encodings check out the [encoding][encoding-crate] crate.-->
文字エンコード間の変換では、[encoding][encoding-crate]クレートをチェックアウトし[encoding][encoding-crate]。

<!--A more detailed listing of the ways to write string literals and escape characters is given in the ['Tokens' chapter][tokens] of the Rust Reference.-->
文字列リテラルとエスケープ文字を書く方法の詳細なリストは、Rust Referenceの['Tokens'の章][tokens]にあります。

<!--[str]: https://doc.rust-lang.org/std/str/
 [string]: https://doc.rust-lang.org/std/string/
 [tokens]: https://doc.rust-lang.org/reference/tokens.html
 [encoding-crate]: https://crates.io/crates/encoding
-->
[str]: https://doc.rust-lang.org/std/str/
 [string]: https://doc.rust-lang.org/std/string/
 [tokens]: https://doc.rust-lang.org/reference/tokens.html
 [encoding-crate]: https://crates.io/crates/encoding

