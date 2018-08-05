# <!--Interoperability--> 相互運用性


<span id="c-common-traits"></span><!--## Types eagerly implement common traits (C-COMMON-TRAITS)-->
##タイプは熱心に共通の特性を実装する（C-COMMON-TRAITS）

<!--Rust's trait system does not allow  _orphans_ : roughly, every `impl` must live either in the crate that defines the trait or the implementing type.-->
Rustの形質システムは _孤児を_ 許可していません。おおまかに言えば、すべての`impl`は、その形質を定義する枠内に存在していなければなりません。
<!--Consequently, crates that define new types should eagerly implement all applicable, common traits.-->
したがって、新しいタイプを定義する木枠は、適用可能な共通の特性すべてを熱心に実装する必要があります。

<!--To see why, consider the following situation:-->
理由を調べるには、次のような状況を考慮してください。

* <!--Crate `std` defines trait `Display`.-->
   クレート`std`は形質`Display`定義します。
* <!--Crate `url` defines type `Url`, without implementing `Display`.-->
   Crate `url`は、`Display`を実装せずに、タイプ`Url`定義します。
* <!--Crate `webapp` imports from both `std` and `url`,-->
   `std`と`url`両方から`webapp`インポートを作成し、

<!--There is no way for `webapp` to add `Display` to `url`, since it defines neither.-->
`webapp`が`url`に`Display`を追加する方法はありません。どちらも定義されていないためです。
<!--(Note: the newtype pattern can provide an efficient, but inconvenient workaround.)-->
（注：newtypeパターンは、効率的だが不便な回避策を提供することができます。）

<!--The most important common traits to implement from `std` are:-->
`std`から実装する最も重要な共通の特性は次のとおりです。

- [`Copy`](https://doc.rust-lang.org/std/marker/trait.Copy.html)
- [`Clone`](https://doc.rust-lang.org/std/clone/trait.Clone.html)
- [`Eq`](https://doc.rust-lang.org/std/cmp/trait.Eq.html)
- [`PartialEq`](https://doc.rust-lang.org/std/cmp/trait.PartialEq.html)
- [`Ord`](https://doc.rust-lang.org/std/cmp/trait.Ord.html)
- [`PartialOrd`](https://doc.rust-lang.org/std/cmp/trait.PartialOrd.html)
- [`Hash`](https://doc.rust-lang.org/std/hash/trait.Hash.html)
- [`Debug`](https://doc.rust-lang.org/std/fmt/trait.Debug.html)
- [`Display`](https://doc.rust-lang.org/std/fmt/trait.Display.html)
- [`Default`](https://doc.rust-lang.org/std/default/trait.Default.html)

<!--Note that it is common and expected for types to implement both `Default` and an empty `new` constructor.-->
型は`Default`と空の`new`コンストラクタの両方を実装するのが一般的であり、期待されていることに注意してください。
<!--`new` is the constructor convention in Rust, and users expect it to exist, so if it is reasonable for the basic constructor to take no arguments, then it should, even if it is functionally identical to `default`.-->
`new`はRustのコンストラクタコンベンションであり、ユーザはそれが存在することを期待しているので、基本コンストラクタが引数を取らないことが合理的であれば、たとえそれが機能的に`default`と同じであってもすべき`default`。


<span id="c-conv-traits"></span><!--## Conversions use the standard traits `From`, `AsRef`, `AsMut` (C-CONV-TRAITS)-->
##変換は、標準的な形質使用`From`、 `AsRef`、 `AsMut`（C-CONV-形質）

<!--The following conversion traits should be implemented where it makes sense:-->
次の変換特性は、意味があるところで実装する必要があります。

- [`From`](https://doc.rust-lang.org/std/convert/trait.From.html)
- [`TryFrom`](https://doc.rust-lang.org/std/convert/trait.TryFrom.html)
- [`AsRef`](https://doc.rust-lang.org/std/convert/trait.AsRef.html)
- [`AsMut`](https://doc.rust-lang.org/std/convert/trait.AsMut.html)

<!--The following conversion traits should never be implemented:-->
次の変換特性は決して実装しないでください。

- [`Into`](https://doc.rust-lang.org/std/convert/trait.Into.html)
- [`TryInto`](https://doc.rust-lang.org/std/convert/trait.TryInto.html)

<!--These traits have a blanket impl based on `From` and `TryFrom`.-->
これらの形質は、`From`および`TryFrom`基づくブランケット`TryFrom`。
<!--Implement those instead.-->
それらを代わりに実装します。

### <!--Examples from the standard library--> 標準ライブラリの例

- <!--`From<u16>` is implemented for `u32` because a smaller integer can always be converted to a bigger integer.-->
   `From<u16>`は`u32`に対して実装され`u32`なぜなら、より小さい整数は常により大きな整数に変換できるからです。
- <!--`From<u32>` is *not* implemented for `u16` because the conversion may not be possible if the integer is too big.-->
   `From<u32>`は、整数が大きすぎると変換が不可能な場合があるため、`u16` *では*実装されていません。
- <!--`TryFrom<u32>` is implemented for `u16` and returns an error if the integer is too big to fit in `u16`.-->
   `TryFrom<u32>`は`u16`に対して実装されており、整数が大きすぎて`u16`に収まらない場合はエラーを返します。
- [`From `] RawInline (Format "html") "<ipv6addr>" <!--[`From `] is implemented for [`IpAddr`], which is a type that can represent both v4 and v6 IP addresses.-->
   [`From `]は、v4とv6の両方のIPアドレスを表すことができるタイプである[`IpAddr`]に対して実装されています。

<!--[`From<Ipv6Addr>`]: https://doc.rust-lang.org/std/net/struct.Ipv6Addr.html
 [`IpAddr`]: https://doc.rust-lang.org/std/net/enum.IpAddr.html
-->
[`From<Ipv6Addr>`]: https://doc.rust-lang.org/std/net/struct.Ipv6Addr.html
 [`IpAddr`]: https://doc.rust-lang.org/std/net/enum.IpAddr.html



<span id="c-collect"></span><!--## Collections implement `FromIterator` and `Extend` (C-COLLECT)-->
コレクションは`FromIterator`と`Extend`（C-COLLECT）を実装してい`FromIterator`

<!--[`FromIterator`] and [`Extend`] enable collections to be used conveniently with the following iterator methods:-->
[`FromIterator`]と[`Extend`]は、次のイテレータメソッドで便利にコレクションを使用できるようにします：

<!--[`FromIterator`]: https://doc.rust-lang.org/std/iter/trait.FromIterator.html
 [`Extend`]: https://doc.rust-lang.org/std/iter/trait.Extend.html
-->
[`FromIterator`]: https://doc.rust-lang.org/std/iter/trait.FromIterator.html
 [`Extend`]: https://doc.rust-lang.org/std/iter/trait.Extend.html


- [`Iterator::collect`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.collect)
- [`Iterator::partition`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.partition)
- [`Iterator::unzip`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.unzip)

<!--`FromIterator` is for creating a new collection containing items from an iterator, and `Extend` is for adding items from an iterator onto an existing collection.-->
`FromIterator`はイテレータからアイテムを含む新しいコレクションを作成するためのもので、`Extend`はイテレータからアイテムを既存のコレクションに追加`Extend`ためのものです。

### <!--Examples from the standard library--> 標準ライブラリの例

- [`Vec `] RawInline (Format "html") "<t>" <!--[`Vec `] implements both `FromIterator<T>` and `Extend<T>`.-->
   [`Vec `] `FromIterator<T>`と`Extend<T>`両方を実装します。

[`Vec<T>`]: https://doc.rust-lang.org/std/vec/struct.Vec.html


<span id="c-serde"></span><!--## Data structures implement Serde's `Serialize`, `Deserialize` (C-SERDE)-->
##データ構造は、Serdeの`Serialize`、 `Deserialize`（C-SERDE）

<!--Types that play the role of a data structure should implement [`Serialize`] and [`Deserialize`].-->
データ構造の役割を果たす型は、[`Serialize`]と[`Deserialize`]実装する必要があります。

<!--[`Serialize`]: https://docs.serde.rs/serde/trait.Serialize.html
 [`Deserialize`]: https://docs.serde.rs/serde/trait.Deserialize.html
-->
[`Serialize`]: https://docs.serde.rs/serde/trait.Serialize.html
 [`Deserialize`]: https://docs.serde.rs/serde/trait.Deserialize.html
 [`Serialize`]: https://docs.serde.rs/serde/trait.Serialize.html
 [`Deserialize`]: https://docs.serde.rs/serde/trait.Deserialize.html


<!--There is a continuum of types between things that are clearly a data structure and things that are clearly not, with gray area in between.-->
はっきりとデータ構造であるものと明らかにそうでないものとの間には連続した種類があり、その間には灰色の領域があります。
<!--[`LinkedHashMap`] and [`IpAddr`] are data structures.-->
[`LinkedHashMap`]と[`IpAddr`]はデータ構造です。
<!--It would be completely reasonable for somebody to want to read in a `LinkedHashMap` or `IpAddr` from a JSON file, or send one over IPC to another process.-->
誰かがJSONファイルから`LinkedHashMap`または`IpAddr`を読み込んだり、IPC経由で別のプロセスに送信したりすることは、まったく合理的です。
<!--[`LittleEndian`] is not a data structure.-->
[`LittleEndian`]はデータ構造体ではありません。
<!--It is a marker used by the `byteorder` crate to optimize at compile time for bytes in a particular order, and in fact an instance of `LittleEndian` can never exist at runtime.-->
特定の順序でバイトのコンパイル時に最適化するために`byteorder`によって使用されるマーカーであり、実際には実行時に`LittleEndian`インスタンスが存在することはありません。
<!--So these are clear-cut examples;-->
したがって、これらは明確な例です。
<!--the #rust or #serde IRC channels can help assess more ambiguous cases if necessary.-->
#rustまたは#serde IRCチャネルは、必要に応じて、あいまいなケースを評価するのに役立ちます。

<!--[`LinkedHashMap`]: https://docs.rs/linked-hash-map/0.4.2/linked_hash_map/struct.LinkedHashMap.html
 [`IpAddr`]: https://doc.rust-lang.org/std/net/enum.IpAddr.html
 [`LittleEndian`]: https://docs.rs/byteorder/1.0.0/byteorder/enum.LittleEndian.html
-->
[`LinkedHashMap`]: https://docs.rs/linked-hash-map/0.4.2/linked_hash_map/struct.LinkedHashMap.html
 [`IpAddr`]: https://doc.rust-lang.org/std/net/enum.IpAddr.html
 [`LittleEndian`]: https://docs.rs/byteorder/1.0.0/byteorder/enum.LittleEndian.html


<!--If a crate does not already depend on Serde for other reasons, it may wish to gate Serde impls behind a Cargo cfg.-->
クレートが他の理由でSerdeに依存していない場合は、Serdeが貨物cfgの背後にあることを念頭に置いてください。
<!--This way downstream libraries only need to pay the cost of compiling Serde if they need those impls to exist.-->
このように、下流のライブラリは、それらのimplsが存在する必要がある場合、Serdeをコンパイルするコストを支払うだけでよい。

<!--For consistency with other Serde-based libraries, the name of the Cargo cfg should be simply `"serde"`.-->
他のSerdeベースのライブラリとの一貫性のために、Cargo cfgの名前は単に`"serde"`なければなりません。
<!--Do not use a different name for the cfg like `"serde_impls"` or `"serde_serialization"`.-->
`"serde_impls"`や`"serde_serialization"`ようにcfgに別の名前を使用しないでください。

<!--The canonical implementation looks like this when not using derive:-->
標準的な実装は、deriveを使用しない場合、次のようになります。

```toml
[dependencies]
serde = { version = "1.0", optional = true }
```

```rust
#[cfg(feature = "serde")]
extern crate serde;

struct T { /* ... */ }

#[cfg(feature = "serde")]
impl Serialize for T { /* ... */ }

#[cfg(feature = "serde")]
impl<'de> Deserialize<'de> for T { /* ... */ }
```

<!--And when using derive:-->
また、

```toml
[dependencies]
serde = { version = "1.0", optional = true, features = ["derive"] }
```

```rust
#[cfg(feature = "serde")]
#[macro_use]
extern crate serde;

#[cfg_attr(feature = "serde", derive(Serialize, Deserialize))]
struct T { /* ... */ }
```


<span id="c-send-sync"></span><!--## Types are `Send` and `Sync` where possible (C-SEND-SYNC)-->
##可能な場合は`Send`と`Sync`があります（C-SEND-SYNC）

<!--[`Send`] and [`Sync`] are automatically implemented when the compiler determines it is appropriate.-->
[`Send`]と[`Sync`]は、コンパイラが適切であると判断したときに自動的に実装されます。

<!--[`Send`]: https://doc.rust-lang.org/std/marker/trait.Send.html
 [`Sync`]: https://doc.rust-lang.org/std/marker/trait.Sync.html
-->
[`Send`]: https://doc.rust-lang.org/std/marker/trait.Send.html
 [`Sync`]: https://doc.rust-lang.org/std/marker/trait.Sync.html
 [`Send`]: https://doc.rust-lang.org/std/marker/trait.Send.html
 [`Sync`]: https://doc.rust-lang.org/std/marker/trait.Sync.html


<!--In types that manipulate raw pointers, be vigilant that the `Send` and `Sync` status of your type accurately reflects its thread safety characteristics.-->
生ポインタを操作する型では、型の`Send`および`Sync`ステータスがスレッドの安全性を正確に反映していることを注意して`Send`。
<!--Tests like the following can help catch unintentional regressions in whether the type implements `Send` or `Sync`.-->
以下のようなテストは、型が`Send`または`Sync`実装するかどうかの意図しない回帰をキャッチするのに役立ちます。

```rust
#[test]
fn test_send() {
    fn assert_send<T: Send>() {}
    assert_send::<MyStrangeType>();
}

#[test]
fn test_sync() {
    fn assert_sync<T: Sync>() {}
    assert_sync::<MyStrangeType>();
}
```


<span id="c-good-err"></span><!--## Error types are meaningful and well-behaved (C-GOOD-ERR)-->
##エラータイプは意味があり、よく振る舞います（C-GOOD-ERR）

<!--An error type is any type `E` used in a `Result<T, E>` returned by any public function of your crate.-->
エラータイプは、あなたのクレートの任意のパブリック関数によって返された`Result<T, E>`使用される任意のタイプ`E`です。
<!--Error types should always implement the [`std::error::Error`] trait which is the mechanism by which error handling libraries like [`error-chain`] abstract over different types of errors, and which allows the error to be used as the [`cause()`] of another error.-->
エラーの種類は、常に実装する必要があります[`std::error::Error`]ようにライブラリを処理しているエラーのメカニズムですトレイト[`error-chain`]エラーの異なる種類以上の抽象的、およびエラーとして使用することができます[`cause()`]を実行します。

<!--[`std::error::Error`]: https://doc.rust-lang.org/std/error/trait.Error.html
 [`error-chain`]: https://docs.rs/error-chain
 [`cause()`]: https://doc.rust-lang.org/std/error/trait.Error.html#method.cause
-->
[`std::error::Error`]: https://doc.rust-lang.org/std/error/trait.Error.html
 [`error-chain`]: https://docs.rs/error-chain
 [`cause()`]: https://doc.rust-lang.org/std/error/trait.Error.html#method.cause


<!--Additionally, error types should implement the [`Send`] and [`Sync`] traits.-->
さらに、エラータイプは[`Send`]と[`Sync`]特性を実装するべきです。
<!--An error that is not `Send` cannot be returned by a thread run with [`thread::spawn`].-->
`Send`ではないエラーは[`thread::spawn`]実行されるスレッドによって返されません。
<!--An error that is not `Sync` cannot be passed across threads using an [`Arc`].-->
`Sync`でないエラーは[`Arc`]を使ってスレッド間を渡すことはできません。
<!--These are common requirements for basic error handling in a multithreaded application.-->
これらは、マルチスレッドアプリケーションにおける基本的なエラー処理の一般的な要件です。

<!--[`Send`]: https://doc.rust-lang.org/std/marker/trait.Send.html
 [`Sync`]: https://doc.rust-lang.org/std/marker/trait.Sync.html
 [`thread::spawn`]: https://doc.rust-lang.org/std/thread/fn.spawn.html
 [`Arc`]: https://doc.rust-lang.org/std/sync/struct.Arc.html
-->
[`Send`]: https://doc.rust-lang.org/std/marker/trait.Send.html
 [`Sync`]: https://doc.rust-lang.org/std/marker/trait.Sync.html
 [`thread::spawn`]: https://doc.rust-lang.org/std/thread/fn.spawn.html
 [`Arc`]: https://doc.rust-lang.org/std/sync/struct.Arc.html


<!--`Send` and `Sync` are also important for being able to package a custom error into an IO error using [`std::io::Error::new`], which requires a trait bound of `Error + Send + Sync`.-->
`Send`と`Sync`は、[`std::io::Error::new`]を使ってカスタムエラーをIOエラーにパッケージ化するためにも重要です。これには、`Error + Send + Sync`特性境界が必要です。

[`std::io::Error::new`]: https://doc.rust-lang.org/std/io/struct.Error.html#method.new

<!--One place to be vigilant about this guideline is in functions that return Error trait objects, for example [`reqwest::Error::get_ref`].-->
このガイドラインを[`reqwest::Error::get_ref`]べき1つの場所は、例えば[`reqwest::Error::get_ref`]ようなError traitオブジェクトを返す関数です。
<!--Typically `Error + Send + Sync + 'static` will be the most useful for callers.-->
通常、`Error + Send + Sync + 'static`は、発信者にとって最も便利です。
<!--The addition of `'static` allows the trait object to be used with [`Error::downcast_ref`].-->
`'static`追加すると、特性オブジェクトは[`Error::downcast_ref`]使用できます。

<!--[`reqwest::Error::get_ref`]: https://docs.rs/reqwest/0.7.2/reqwest/struct.Error.html#method.get_ref
 [`Error::downcast_ref`]: https://doc.rust-lang.org/std/error/trait.Error.html#method.downcast_ref-2
-->
[`reqwest::Error::get_ref`]: https://docs.rs/reqwest/0.7.2/reqwest/struct.Error.html#method.get_ref
 [`Error::downcast_ref`]: https://doc.rust-lang.org/std/error/trait.Error.html#method.downcast_ref-2


<!--Never use `()` as an error type, even where there is no useful additional information for the error to carry.-->
エラーを実行するための有用な追加情報がない場合でも、エラータイプとしてuse `()`を使用しないでください。

- <!--`()` does not implement `Error` so it cannot be used with error handling libraries like `error-chain`.-->
   `()`は`Error`実装していないので、エラー`error-chain`ような`error-chain`処理ライブラリでは使用できません。
- <!--`()` does not implement `Display` so a user would need to write an error message of their own if they want to fail because of the error.-->
   `()`は`Display`実装していないので、エラーのために失敗したければ、ユーザー自身がエラーメッセージを書く必要があります。
- <!--`()` has an unhelpful `Debug` representation for users that decide to `unwrap()` the error.-->
   `()`は、エラーを`unwrap()`することを決定したユーザのために、`Debug`表現を助けません。
- <!--It would not be semantically meaningful for a downstream library to implement `From<()>` for their error type, so `()` as an error type cannot be used with the `?`-->
   これは、下流のライブラリが実装するのは意味的に意味がないでしょう`From<()>`そのエラーの種類、そのために`()`エラータイプなどで使用することはできませんか`?`
<!--operator.-->
   オペレーター。

<!--Instead, define a meaningful error type specific to your crate or to the individual function.-->
代わりに、あなたのクレートまたは個々の機能に固有の意味のあるエラータイプを定義してください。
<!--Provide appropriate `Error` and `Display` impls.-->
適切な`Error`と`Display`インプリケーションを提供する。
<!--If there is no useful information for the error to carry, it can be implemented as a unit struct.-->
エラーを運ぶための有益な情報がない場合は、ユニット構造体として実装できます。

```rust
use std::error::Error;
use std::fmt::Display;

#// Instead of this...
// これの代わりに...
fn do_the_thing() -> Result<Wow, ()>

#// Prefer this...
// これを好む...
fn do_the_thing() -> Result<Wow, DoError>

#[derive(Debug)]
struct DoError;

impl Display for DoError { /* ... */ }
impl Error for DoError { /* ... */ }
```

<!--The error message given by the `Display` representation of an error type should be lowercase without trailing punctuation, and typically concise.-->
`Display`形式のエラー・タイプによって示されるエラー・メッセージは、末尾に句読点がない場合は小文字にする必要があります。通常は簡潔です。

<!--The message given by [`Error::description()`] does not matter.-->
[`Error::description()`]によって与えられたメッセージは重要ではありません。
<!--Users should always use `Display` instead of `description()` to print the error.-->
エラーを出力するには、`description()`代わりに`Display`を常に使用する必要があります。
<!--A low-effort description like `"JSON error"` is sufficient.-->
`"JSON error"`ような低労力の記述で十分です。

[`Error::description()`]: https://doc.rust-lang.org/std/error/trait.Error.html#tymethod.description

### <!--Examples from the standard library--> 標準ライブラリの例

- <!--[`ParseBoolError`] is returned when failing to parse a bool from a string.-->
   文字列からboolを解析するのに失敗すると、[`ParseBoolError`]が返されます。

[`ParseBoolError`]: https://doc.rust-lang.org/std/str/struct.ParseBoolError.html

### <!--Examples of error messages--> エラーメッセージの例

- <!--"unexpected end of file"-->
   "予期しないファイルの終わり"
- <!--"provided string was not \ `true\` or \ `false\` "-->
   "提供された文字列は\ `true\`または\ `false\` "ではありません
- <!--"invalid IP address syntax"-->
   「無効なIPアドレス構文」
- <!--"second time provided was later than self"-->
   "二度目は自己よりも後になった"
- <!--"invalid UTF-8 sequence of {} bytes from index {}"-->
   "インデックス{}からの{}バイトの無効なUTF-8シーケンス"
- <!--"environment variable was not valid unicode: {:?}"-->
   "環境変数が有効ではありませんunicode：{：？}"


<span id="c-num-fmt"></span><!--## Binary number types provide `Hex`, `Octal`, `Binary` formatting (C-NUM-FMT)-->
##バイナリ形式は、`Hex`、 `Octal` `Binary`、 `Binary`（C-NUM-FMT）

- [`std::fmt::UpperHex`](https://doc.rust-lang.org/std/fmt/trait.UpperHex.html)
- [`std::fmt::LowerHex`](https://doc.rust-lang.org/std/fmt/trait.LowerHex.html)
- [`std::fmt::Octal`](https://doc.rust-lang.org/std/fmt/trait.Octal.html)
- [`std::fmt::Binary`](https://doc.rust-lang.org/std/fmt/trait.Binary.html)

<!--These traits control the representation of a type under the `{:X}`, `{:x}`, `{:o}`, and `{:b}` format specifiers.-->
これらの特性は、`{:X}`、 `{:x}`、 `{:o}`、および`{:b}`形式指定子の下での型の表現を制御します。

<!--Implement these traits for any number type on which you would consider doing bitwise manipulations like `|`-->
これらの特性は、`|`ようなビット操作を行うと考えられる任意の数値型に対して実装します`|`
<!--or `&`.-->
または`&`。
<!--This is especially appropriate for bitflag types.-->
これは特にビットフラグ型に適しています。
<!--Numeric quantity types like `struct Nanoseconds(u64)` probably do not need these.-->
`struct Nanoseconds(u64)`ような数値型の型はおそらくこれらを必要としません。

<span id="c-rw-value"></span><!--## Generic reader/writer functions take `R: Read` and `W: Write` by value (C-RW-VALUE)-->
##一般的なリーダ/ライタ関数は`R: Read`取る`R: Read`と`W: Write`値で`W: Write`（C-RW-VALUE）

<!--The standard library contains these two impls:-->
標準ライブラリには、次の2つの意味があります。

```rust
impl<'a, R: Read + ?Sized> Read for &'a mut R { /* ... */ }

impl<'a, W: Write + ?Sized> Write for &'a mut W { /* ... */ }
```

<!--That means any function that accepts `R: Read` or `W: Write` generic parameters by value can be called with a mut reference if necessary.-->
つまり、`R: Read`または`W: Write`汎用パラメータを値で受け付ける関数は、必要に応じてmutリファレンスで呼び出すことができます。

<!--In the documentation of such functions, briefly remind users that a mut reference can be passed.-->
このような関数のドキュメントでは、mutリファレンスを渡すことができることをユーザーに簡単に思い出させます。
<!--New Rust users often struggle with this.-->
新しいRustのユーザーはこれで苦労することがよくあります。
<!--They may have opened a file and want to read multiple pieces of data out of it, but the function to read one piece consumes the reader by value, so they are stuck.-->
彼らはファイルを開いて、複数のデータを読みたいかもしれませんが、1つの部分を読み取る機能は値で読み取り器を消費するため、スタックされています。
<!--The solution would be to leverage one of the above impls and pass `&mut f` instead of `f` as the reader parameter.-->
溶液は、上記implsのいずれかを利用し、通過することで`&mut f`代わりに`f`リーダパラメータとして。

### <!--Examples--> 例

- [`flate2::read::GzDecoder::new`]
- [`flate2::write::GzEncoder::new`]
- [`serde_json::from_reader`]
- [`serde_json::to_writer`]

<!--[`flate2::read::GzDecoder::new`]: https://docs.rs/flate2/0.2/flate2/read/struct.GzDecoder.html#method.new
 [`flate2::write::GzEncoder::new`]: https://docs.rs/flate2/0.2/flate2/write/struct.GzEncoder.html#method.new
 [`serde_json::from_reader`]: https://docs.serde.rs/serde_json/fn.from_reader.html
 [`serde_json::to_writer`]: https://docs.serde.rs/serde_json/fn.to_writer.html
-->
[`flate2::read::GzDecoder::new`]: https://docs.rs/flate2/0.2/flate2/read/struct.GzDecoder.html#method.new
 [`flate2::write::GzEncoder::new`]: https://docs.rs/flate2/0.2/flate2/write/struct.GzEncoder.html#method.new
 [`serde_json::from_reader`]: https://docs.serde.rs/serde_json/fn.from_reader.html
 [`serde_json::to_writer`]: https://docs.serde.rs/serde_json/fn.to_writer.html

