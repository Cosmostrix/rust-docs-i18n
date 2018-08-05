# <!--Raw identifiers--> 生識別子

<!--Rust, like many programming languages, has the concept of "keywords".-->
Rustは、多くのプログラミング言語と同様、「キーワード」という概念を持っています。
<!--These identifiers mean something to the language, and so you cannot use them in places like variable names, function names, and other places.-->
これらの識別子は言語に対して何かを意味するため、変数名、関数名などの場所では使用できません。
<!--Raw identifiers let you use keywords where they would not normally be allowed.-->
生識別子は通常許可されていないキーワードを使用します。

<!--For example, `match` is a keyword.-->
たとえば、`match`はキーワードです。
<!--If you try to compile this function:-->
この関数をコンパイルしようとすると：

```rust,ignore
fn match(needle: &str, haystack: &str) -> bool {
    haystack.contains(needle)
}
```

<!--You'll get this error:-->
このエラーが発生します：

```text
error: expected identifier, found keyword `match`
 --> src/main.rs:4:4
  |
4 | fn match(needle: &str, haystack: &str) -> bool {
  |    ^^^^^ expected identifier, found keyword
```

<!--You can write this with a raw identifier:-->
生識別子でこれを書くことができます：

```rust
#![feature(rust_2018_preview)]
#![feature(raw_identifiers)]

fn r#match(needle: &str, haystack: &str) -> bool {
    haystack.contains(needle)
}

fn main() {
    assert!(r#match("foo", "foobar"));
}
```

<!--Note the `r#` prefix on both the function name, as well as the call.-->
関数名と呼び出しの両方の`r#`接頭辞に注意してください。

## <!--More details--> 詳細

<!--This feature is useful for a few reasons, but the primary motivation was inter-edition situations.-->
この機能はいくつかの理由で便利ですが、主な動機はエディション間の状況です。
<!--For example, `try` is not a keyword in the 2015 edition, but is in the 2018 edition.-->
たとえば、`try`は2015年版のキーワードではありませんが、2018年版です。
<!--So if you have a library that is written in Rust 2015 and has a `try` function, to call it in Rust 2018, you'll need to use the raw identifier.-->
したがって、Rust 2015で書かれた`try`関数があるライブラリをRust 2018で呼び出すには、生の識別子を使用する必要があります。

## <!--New keywords--> 新しいキーワード

<!--The new confirmed keywords in edition 2018 are:-->
エディション2018の新たに確認されたキーワードは次のとおりです。

### <!--`async` and `await`--> `async`と`await`

[RFC 2394]: https://github.com/rust-lang/rfcs/blob/master/text/2394-async_await.md#final-syntax-for-the-await-expression

<!--Here, `async` is reserved for use in `async fn` as well as in `async ||`-->
ここで、`async`は、`async fn`と`async ||`で使用するために予約されています。
<!--closures and `async { .. }` blocks.-->
クロージャと`async { .. }`ブロック。
<!--Meanwhile, `await` is reserved to keep our options open with respect to `await!(expr)` syntax.-->
一方、`await`に関してオープンたちの選択肢を維持するために予約されている`await!(expr)`構文を。
<!--See [RFC 2394] for more details.-->
詳細は[RFC 2394]を参照してください。

### `try`
[RFC 2388]: https://github.com/rust-lang/rfcs/pull/2388

<!--The `do catch { .. }` blocks have been renamed to `try { .. }` and to support that, the keyword `try` is reserved in edition 2018. See [RFC 2388] for more details.-->
`do catch { .. }`ブロックの名前が`try { .. }`変更され、それをサポートするために、`try`キーワードは2018年に予約されてい[RFC 2388]。詳細は[RFC 2388]を参照してください。
