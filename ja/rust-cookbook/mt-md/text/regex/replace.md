## <!--Replace all occurrences of one text pattern with another pattern.--> 1つのテキストパターンのすべての出現を別のパターンに置き換えます。

<!--[!][regex]-->
[！][regex]
<!--[regex-badge] [!][lazy_static]-->
[regex-badge] [！][lazy_static]
<!--[lazy_static-badge] [!][cat-text-processing]-->
[lazy_static-badge] [！][cat-text-processing]
[cat-text-processing-badge]
<!--Replaces all occurrences of the standard ISO 8601 *YYYY-MM-DD* date pattern with the equivalent American English date with slashes.-->
標準のISO 8601 *YYYY-MM-DD*日付パターンのすべての出現を、対応するアメリカ英語の日付とスラッシュで置き換えます。
<!--For example `2013-01-15` becomes `01/15/2013`.-->
たとえば、`2013-01-15`は、`01/15/2013` `2013-01-15`なり`01/15/2013`。

<!--The method [`Regex::replace_all`] replaces all occurrences of the whole regex.-->
[`Regex::replace_all`]メソッドは、正規表現全体のすべてのオカレンスを置き換えます。
<!--`&str` implements the `Replacer` trait which allows variables like `$abcde` to refer to corresponding named capture groups `(?P<abcde>REGEX)` from the search regex.-->
`&str`は`Replacer`特性を実装しています。`$abcde`ような変数は、検索正規表現から対応する名前付きキャプチャグループ`(?P<abcde>REGEX)`を参照できます。
<!--See the [replacement string syntax] for examples and escaping detail.-->
例とエスケープの詳細については、[replacement string syntax]を参照してください。

```rust
extern crate regex;
#[macro_use]
extern crate lazy_static;

use std::borrow::Cow;
use regex::Regex;

fn reformat_dates(before: &str) -> Cow<str> {
    lazy_static! {
        static ref ISO8601_DATE_REGEX : Regex = Regex::new(
            r"(?P<y>\d{4})-(?P<m>\d{2})-(?P<d>\d{2})"
            ).unwrap();
    }
    ISO8601_DATE_REGEX.replace_all(before, "$m/$d/$y")
}

fn main() {
    let before = "2012-03-14, 2013-01-15 and 2014-07-05";
    let after = reformat_dates(before);
    assert_eq!(after, "03/14/2012, 01/15/2013 and 07/05/2014");
}
```

[`Regex::replace_all`]: https://docs.rs/regex/*/regex/struct.Regex.html#method.replace_all

[replacement string syntax]: https://docs.rs/regex/*/regex/struct.Regex.html#replacement-string-syntax
