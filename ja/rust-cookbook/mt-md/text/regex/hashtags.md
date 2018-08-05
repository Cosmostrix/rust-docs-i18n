## <!--Extract a list of unique #Hashtags from a text--> テキストから一意の#Hashtagsのリストを抽出する

<!--[!][regex]-->
[！][regex]
<!--[regex-badge] [!][lazy_static]-->
[regex-badge] [！][lazy_static]
<!--[lazy_static-badge] [!][cat-text-processing]-->
[lazy_static-badge] [！][cat-text-processing]
[cat-text-processing-badge]
<!--Extracts, sorts, and deduplicates list of hashtags from text.-->
テキストからハッシュタグのリストを抽出、並べ替え、重複排除します。

<!--The hashtag regex given here only catches Latin hashtags that start with a letter.-->
ここで与えられたハッシュタグ正規表現は、文字で始まるラテンハッシュタグのみを捕捉します。
<!--The complete [twitter hashtag regex] is much more complicated.-->
完全な[twitter hashtag regex]ははるかに複雑です。

```rust
extern crate regex;
#[macro_use]
extern crate lazy_static;

use regex::Regex;
use std::collections::HashSet;

fn extract_hashtags(text: &str) -> HashSet<&str> {
    lazy_static! {
        static ref HASHTAG_REGEX : Regex = Regex::new(
                r"\#[a-zA-Z][0-9a-zA-Z_]*"
            ).unwrap();
    }
    HASHTAG_REGEX.find_iter(text).map(|mat| mat.as_str()).collect()
}

fn main() {
    let tweet = "Hey #world, I just got my new #dog, say hello to Till. #dog #forever #2 #_ ";
    let tags = extract_hashtags(tweet);
    assert!(tags.contains("#dog") && tags.contains("#forever") && tags.contains("#world"));
    assert_eq!(tags.len(), 3);
}
```

[twitter hashtag regex]: https://github.com/twitter/twitter-text/blob/c9fc09782efe59af4ee82855768cfaf36273e170/java/src/com/twitter/Regex.java#L255
