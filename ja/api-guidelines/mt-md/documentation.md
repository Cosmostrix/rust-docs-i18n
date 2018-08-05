# <!--Documentation--> ドキュメンテーション


<span id="c-crate-doc"></span><!--## Crate level docs are thorough and include examples (C-CRATE-DOC)-->
##クレートレベルのドキュメントは徹底しており、例（C-CRATE-DOC）

<!--See [RFC 1687].-->
[RFC 1687]参照してください。

[RFC 1687]: https://github.com/rust-lang/rfcs/pull/1687


<span id="c-example"></span><!--## All items have a rustdoc example (C-EXAMPLE)-->
すべての項目にrustdocの例があります（C-EXAMPLE）

<!--Every public module, trait, struct, enum, function, method, macro, and type definition should have an example that exercises the functionality.-->
すべてのパブリックモジュール、特性、構造体、列挙型、関数、メソッド、マクロ、型定義には、その機能を実行する例が必要です。

<!--This guideline should be applied within reason.-->
このガイドラインは理由の中で適用されるべきである。

<!--A link to an applicable example on another item may be sufficient.-->
他の項目に適用可能な例へのリンクで十分かもしれません。
<!--For example if exactly one function uses a particular type, it may be appropriate to write a single example on either the function or the type and link to it from the other.-->
たとえば、正確に1つの関数が特定の型を使用している場合は、関数または型のいずれかに1つの例を記述し、その型から別の型にリンクするのが適切な場合があります。

<!--The purpose of an example is not always to show *how to use* the item.-->
例の目的は、アイテムの*使用方法を*必ずしも示すものではありません。
<!--Readers can be expected to understand how to invoke functions, match on enums, and other fundamental tasks.-->
読者は、関数を呼び出す方法、列挙型にマッチさせる方法、およびその他の基本的なタスクを理解することが求められます。
<!--Rather, an example is often intended to show *why someone would want to use* the item.-->
むしろ、例はしばしば*誰かが*そのアイテム*を使用*し*たい理由*を示すことを意図しています。

```rust
#// This would be a poor example of using clone(). It mechanically shows *how* to
#// call clone(), but does nothing to show *why* somebody would want this.
// これは、clone（）を使用するという貧弱な例になります。機械的にclone（）を呼び出す*方法*を示し*ます*が*、*誰かがこれを望む*理由*を示す*こと*は何もしません。
fn main() {
    let hello = "hello";

    hello.clone();
}
```


<span id="c-question-mark"></span><!--## Examples use `?`-->
##使用例は`?`
<!--, not `try!`, not `unwrap` (C-QUESTION-MARK)-->
、ではない`try!`、ない`unwrap`（C-QUESTION-MARK）

<!--Like it or not, example code is often copied verbatim by users.-->
それと同じように、サンプルコードはしばしばユーザによってそのままコピーされます。
<!--Unwrapping an error should be a conscious decision that the user needs to make.-->
エラーを解くことは、ユーザーが行う必要がある意識的な決定でなければなりません。

<!--A common way of structuring fallible example code is the following.-->
フォールバック可能なサンプルコードを構成する一般的な方法は次のとおりです。
<!--The lines beginning with `#` are compiled by `cargo test` when building the example but will not appear in user-visible rustdoc.-->
`#`始まる行は、サンプルをビルドするときに`cargo test`によってコンパイルされますが、ユーザーが表示できるrustdocでは表示されません。

```
#///// ```rust
///  ``錆
#///// # use std::error::Error;
///  ＃std:: error:: Errorを使用します。
#///// #
///  ＃
#///// # fn try_main() -> Result<(), Box<Error>> {
///  ＃fn try_main（）->結果<（）、ボックス > {
#///// your;
/// きみの;
#///// example?;
/// 例？
#///// code;
/// コード;
#///// #
///  ＃
#///// #     Ok(())
///  ＃ OK（（））
#///// # }
///  ＃}
#///// #
///  ＃
#///// # fn main() {
///  ＃fn main（）{
#///// #     try_main().unwrap();
///  ＃try_main（）。unwrap（）;
#///// # }
///  ＃}
#///// ```
///  `` ``
```


<span id="c-failure"></span><!--## Function docs include error, panic, and safety considerations (C-FAILURE)-->
##機能文書には、エラー、パニック、安全性に関する考慮事項（C-FAILURE）

<!--Error conditions should be documented in an "Errors"section.-->
エラー条件は、「エラー」セクションに文書化する必要があります。
<!--This applies to trait methods as well --trait methods for which the implementation is allowed or expected to return an error should be documented with an "Errors"section.-->
これは、実装が許可されているか、またはエラーを返すと予想されるwell-traitメソッドが "Errors"セクションで文書化されるべきであるように、traitメソッドに適用されます。

<!--For example in the standard library, Some implementations of the [`std::io::Read::read`] trait method may return an error.-->
たとえば、標準ライブラリでは、[`std::io::Read::read`] traitメソッドのいくつかの実装がエラーを返すことがあります。

[`std::io::Read::read`]: https://doc.rust-lang.org/std/io/trait.Read.html#tymethod.read

```
#///// Pull some bytes from this source into the specified buffer, returning
/// このソースから指定されたバッファにいくつかのバイトを引き出し、
#///// how many bytes were read.
/// 読み込まれたバイト数。
///
#///// ... lots more info ...
/// ...もっとたくさんの情報...
///
#///// # Errors
///  ＃エラー
///
#///// If this function encounters any form of I/O or other error, an error
/// この関数がI / Oまたはその他のエラーの形式を検出した場合、エラー
#///// variant will be returned. If an error is returned then it must be
/// バリアントが返されます。エラーが返された場合は、エラーが返されます。
#///// guaranteed that no bytes were read.
/// バイトが読み取られないことが保証されています。
```

<!--Panic conditions should be documented in a "Panics"section.-->
パニック状態は「パニック」セクションに文書化する必要があります。
<!--This applies to trait methods as well --traits methods for which the implementation is allowed or expected to panic should be documented with a "Panics"section.-->
これは、"パニック"セクションで文書化されなければならないインプリメンテーションが許される、またはパニックになる可能性のある有名なメソッドとして、形質メソッドに適用されます。

<!--In the standard library the [`Vec::insert`] method may panic.-->
標準ライブラリでは[`Vec::insert`]メソッドがパニックに陥ります。

[`Vec::insert`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.insert

```
#///// Inserts an element at position `index` within the vector, shifting all
/// ベクトル内の位置`index`要素を挿入し、すべてをシフトします。
#///// elements after it to the right.
/// 後ろの要素は右に移動します。
///
#///// # Panics
///  ＃パニック
///
#///// Panics if `index` is out of bounds.
///  `index`が範囲外の場合はパニックになります。
```

<!--It is not necessary to document all conceivable panic cases, especially if the panic occurs in logic provided by the caller.-->
考えられるすべてのパニック事件を文書化する必要はありません。特に、パニックが発信者によって提供されたロジックで発生している場合は、そうしてください。
<!--For example documenting the `Display` panic in the following code seems excessive.-->
たとえば、次のコードで`Display`パニックを文書化すると、過度のように見えます。
<!--But when in doubt, err on the side of documenting more panic cases.-->
しかし、疑わしい時には、より多くのパニック症例を文書化する側で誤っている。

```rust
#///// # Panics
///  ＃パニック
///
#///// This function panics if `T`'s implementation of `Display` panics.
/// この機能は、`T`が`Display`パニックを実装している場合にパニックになります。
pub fn print<T: Display>(t: T) {
    println!("{}", t.to_string());
}
```

<!--Unsafe functions should be documented with a "Safety"section that explains all invariants that the caller is responsible for upholding to use the function correctly.-->
安全でない関数は、関数を正しく使用するために呼び出し元が責任を負うすべての不変量を説明する「安全」セクションで文書化する必要があります。

<!--The unsafe [`std::ptr::read`] requires the following of the caller.-->
安全でない[`std::ptr::read`]は、呼び出し元の次のものを必要とします。

[`std::ptr::read`]: https://doc.rust-lang.org/std/ptr/fn.read.html

```
#///// Reads the value from `src` without moving it. This leaves the
/// 移動せずに`src`から値を読み込みます。これにより、
#///// memory in `src` unchanged.
///  `src`メモリは変更されません。
///
#///// # Safety
///  ＃ 安全性
///
#///// Beyond accepting a raw pointer, this is unsafe because it semantically
/// 未処理のポインタを受け入れる以外に、意味的であるため安全ではありません
#///// moves the value out of `src` without preventing further usage of `src`.
/// それ以上の`src`使用を妨げることなく`src`から値を移動します。
#///// If `T` is not `Copy`, then care must be taken to ensure that the value at
///  `T`が`Copy`でない場合は、
#///// `src` is not used before the data is overwritten again (e.g. with `write`,
/// データが再び上書きされる前に`src`は使用されません（たとえば、`write`、
#///// `zero_memory`, or `copy_memory`). Note that `*src = foo` counts as a use
///  `zero_memory`、または`copy_memory`）。 `*src = foo`は使用としてカウントされることに注意してください
#///// because it will attempt to drop the value previously at `*src`.
/// 以前は`*src`値を落とそうとするためです。
///
#///// The pointer must be aligned; use `read_unaligned` if that is not the case.
/// ポインタは一列に並ばなければなりません。そうでない場合は`read_unaligned`使用して`read_unaligned`。
```


<span id="c-link"></span><!--## Prose contains hyperlinks to relevant things (C-LINK)-->
##散文には関連するものへのハイパーリンクが含まれています（C-LINK）

<!--Links to methods within the same type usually look like this:-->
同じタイプのメソッドへのリンクは、通常次のようになります。

```md
[`serialize_struct`]: #method.serialize_struct
```

<!--Links to other types usually look like this:-->
他のタイプへのリンクは、通常次のようになります。

```md
[`Deserialize`]: trait.Deserialize.html
```

<!--Links may also point to a parent or child module:-->
リンクは、親モジュールまたは子モジュールを指す場合もあります。

```md
[`Value`]: ../enum.Value.html
[`DeserializeOwned`]: de/trait.DeserializeOwned.html
```

<!--This guideline is officially recommended by RFC 1574 under the heading ["Link all the things"].-->
このガイドラインは、RFC 1574で["Link all the things"]の見出しの下で公式に推奨されています。

["Link all the things"]: https://github.com/rust-lang/rfcs/blob/master/text/1574-more-api-documentation-conventions.md#link-all-the-things


<span id="c-metadata"></span><!--## Cargo.toml includes all common metadata (C-METADATA)-->
## Cargo.tomlにはすべての共通メタデータ（C-METADATA）

<!--The `[package]` section of `Cargo.toml` should include the following values:-->
`Cargo.toml`の`[package]`セクションには、次の値を含める必要があります。

- `authors`
- `description`
- `license`
- `repository`
- `readme`
- `keywords`
- `categories`

<!--In addition, there are two optional metadata fields:-->
さらに、2つのオプションのメタデータフィールドがあります。

- `documentation`
- `homepage`

<!--By default, *crates.io* links to documentation for the crate on [*docs.rs*].-->
デフォルトでは、*crates.io*は[*docs.rs*]クレートのドキュメントにリンクしています。
<!--The `documentation` metadata only needs to be set if the documentation is hosted somewhere other than *docs.rs*, for example because the crate links against a shared library that is not available in the build environment of *docs.rs*.-->
`documentation`メタデータは、唯一のドキュメントが*docs.rs*以外の場所にホストされている場合たとえば、設定する必要があるため*docs.rs*のビルド環境では使用できません共有ライブラリに対するクレートリンク。

[*docs.rs*]: https://docs.rs

<!--The `homepage` metadata should only be set if there is a unique website for the crate other than the source repository or API documentation.-->
`homepage`メタデータは、ソースリポジトリまたはAPIドキュメント以外のクレート用の固有のWebサイトがある場合にのみ設定する必要があります。
<!--Do not make `homepage` redundant with either the `documentation` or `repository` values.-->
`documentation`または`repository`いずれかの値で`homepage`冗長化しないでください。
<!--For example, serde sets `homepage` to *https://serde.rs*, a dedicated website.-->
たとえば、serdeは`homepage`を専用のWebサイト*https://serde.rs*に設定し*ます*。

[C-HTML-ROOT]: #c-html-root
<span id="c-html-root"></span><!--### Crate sets html_root_url attribute (C-HTML-ROOT)-->
###クレートはhtml_root_url属性（C-HTML-ROOT）を設定します。

<!--
Remove this guideline once rustdoc links no-deps documentation with no
html_root_url to docs.rs by default.
https://github.com/rust-lang/rust/issues/42301
-->

<!--It should point to `"https://docs.rs/CRATE/MAJOR.MINOR.PATCH"`, assuming the crate uses docs.rs for its primary API documentation.-->
cateがプライマリAPIドキュメントにdocs.rsを使用していると仮定して、`"https://docs.rs/CRATE/MAJOR.MINOR.PATCH"`を指す必要があります。

<!--The `html_root_url` attribute tells rustdoc how to create URLs to items in the crate when compiling downstream crates.-->
`html_root_url`属性は、下流のクレートをコンパイルするときにクレート内のアイテムへのURLを作成する方法を`html_root_url`に指示します。
<!--Without it, links in the documentation of crates that depend on your crate will be incorrect.-->
それがなければ、あなたの箱に依存する箱の文書のリンクが間違っています。

```rust
#![doc(html_root_url = "https://docs.rs/log/0.3.8")]
```

<!--Because this URL contains an exact version number, it must be kept in sync with the version number in `Cargo.toml`.-->
このURLには正確なバージョン番号が含まれているため、`Cargo.toml`バージョン番号と同期させておく必要があります。
<!--The [`version-sync`] crate can help with this by letting you add an integration test that fails if the `html_root_url` version number is out of sync with the crate version.-->
[`version-sync`]は、`html_root_url`バージョン番号がクレートバージョンと同期していない場合に失敗する統合テストを追加することで、これを助けることができます。

[`version-sync`]: https://crates.io/crates/version-sync

<!--If you do not like that mechanism, it is recommended to add a comment to the `Cargo.toml` version key reminding yourself to keep the two updated together, like:-->
そのような仕組みが気に入らない場合は、`Cargo.toml`バージョンキーにコメントを追加して、2つを一緒に更新するようにしておくことをお勧めします。

```toml
version = "0.3.8" # remember to update html_root_url
```

<!--For documentation hosted outside of docs.rs, the value for `html_root_url` is correct if appending the crate name + index.html takes you to the documentation of the crate's root module.-->
docs.rsの外部でホストされているドキュメントの場合、`html_root_url`名前を追加すると、`html_root_url`の値は正しくなります。+ index.htmlは、`html_root_url`のルートモジュールのドキュメントに移動します。
<!--For example if the documentation of the root module is located at `"https://api.rocket.rs/rocket/index.html"` then the `html_root_url` would be `"https://api.rocket.rs"`.-->
たとえば、ルートモジュールのドキュメントが`"https://api.rocket.rs/rocket/index.html"`場合、`html_root_url`は`"https://api.rocket.rs"`ます。


<span id="c-relnotes"></span><!--## Release notes document all significant changes (C-RELNOTES)-->
##リリースノートにはすべての重要な変更が記載されています（C-RELNOTES）

<!--Users of the crate can read the release notes to find a summary of what changed in each published release of the crate.-->
クレートのユーザーは、リリースノートを読んで、クレートの公開された各リリースで変更された内容を要約することができます。
<!--A link to the release notes, or the notes themselves, should be included in the crate-level documentation and/or the repository linked in Cargo.toml.-->
リリースノートへのリンクまたはノートそのものは、クレートレベルのドキュメントおよび/またはCargo.tomlにリンクされているリポジトリに含める必要があります。

<!--Breaking changes (as defined in [RFC 1105]) should be clearly identified in the release notes.-->
リリースノートでは、変更点（[RFC 1105]定義され[RFC 1105]）を明確に特定する必要があります。

<!--If using Git to track the source of a crate, every release published to *crates.io* should have a corresponding tag identifying the commit that was published.-->
Gitを使用してクレートのソースを追跡する場合、*crates.ioに*公開されたすべてのリリースには、発行されたコミットを識別する対応するタグが必要です。
<!--A similar process should be used for non-Git VCS tools as well.-->
非Git VCSツールでも同様のプロセスを使用する必要があります。

```bash
# Tag the current commit
GIT_COMMITTER_DATE=$(git log -n1 --pretty=%aD) git tag -a -m "Release 0.3.0" 0.3.0
git push --tags
```

<!--Annotated tags are preferred because some Git commands ignore unannotated tags if any annotated tags exist.-->
アノテートされたタグが存在する場合、アノテーションなしのタグを無視するGitコマンドがあるので、アノテートされたタグが優先されます。

[RFC 1105]: https://github.com/rust-lang/rfcs/blob/master/text/1105-api-evolution.md

### <!--Examples--> 例

- <!--[Serde 1.0.0 release notes](https://github.com/serde-rs/serde/releases/tag/v1.0.0)-->
   [Serde 1.0.0リリースノート](https://github.com/serde-rs/serde/releases/tag/v1.0.0)
- <!--[Serde 0.9.8 release notes](https://github.com/serde-rs/serde/releases/tag/v0.9.8)-->
   [Serde 0.9.8リリースノート](https://github.com/serde-rs/serde/releases/tag/v0.9.8)
- <!--[Serde 0.9.0 release notes](https://github.com/serde-rs/serde/releases/tag/v0.9.0)-->
   [Serde 0.9.0リリースノート](https://github.com/serde-rs/serde/releases/tag/v0.9.0)
- <!--[Diesel change log](https://github.com/diesel-rs/diesel/blob/master/CHANGELOG.md)-->
   [ディーゼルチェンジログ](https://github.com/diesel-rs/diesel/blob/master/CHANGELOG.md)


<span id="c-hidden"></span><!--## Rustdoc does not show unhelpful implementation details (C-HIDDEN)-->
## Rustdocは役に立たない実装の詳細を表示しません（C-HIDDEN）

<!--Rustdoc is supposed to include everything users need to use the crate fully and nothing more.-->
Rustdocは、ユーザーがクレートを完全に使用するために必要なものすべてを含むものとします。
<!--It is fine to explain relevant implementation details in prose but they should not be real entries in the documentation.-->
関連する実装の詳細を散文で説明するのは問題ありませんが、ドキュメンテーションの実際の項目であってはなりません。

<!--Especially be selective about which impls are visible in rustdoc --all the ones that users would need for using the crate fully, but no others.-->
特にrustdocでどのようなインプラントが目に見えるのかを選択すること -ユーザーがクレートを完全に使用するために必要なすべてのもの、他のものは必要ありません。
<!--In the following code the rustdoc of `PublicError` by default would show the `From<PrivateError>` impl.-->
次のコードでは、デフォルトでPublicErrorの`PublicError`に`From<PrivateError>` implが表示されます。
<!--We choose to hide it with `#[doc(hidden)]` because users can never have a `PrivateError` in their code so this impl would never be relevant to them.-->
私たちは`#[doc(hidden)]`それを隠すことを選択します`#[doc(hidden)]`なぜなら、ユーザーはコード内に`PrivateError`を持つことはできないからです。

```rust
#// This error type is returned to users.
// このエラータイプはユーザーに返されます。
pub struct PublicError { /* ... */ }

#// This error type is returned by some private helper functions.
// このエラータイプは、いくつかのプライベートヘルパー関数によって返されます。
struct PrivateError { /* ... */ }

#// Enable use of `?` operator.
// の使用を有効にする`?`オペレーター。
#[doc(hidden)]
impl From<PrivateError> for PublicError {
    fn from(err: PrivateError) -> PublicError {
        /* ... */
    }
}
```

<!--[`pub(crate)`] is another great tool for removing implementation details from the public API.-->
[`pub(crate)`]は、公開APIから実装の詳細を削除するためのもう1つの素晴らしいツールです。
<!--It allows items to be used from outside of their own module but not outside of the same crate.-->
これは、アイテムを自分のモジュールの外部から使用することができますが、同じクレートの外部では使用できません。

[`pub(crate)`]: https://github.com/rust-lang/rfcs/blob/master/text/1422-pub-restricted.md
