# <!--Naming--> ネーミング


<span id="c-case"></span><!--## Casing conforms to RFC 430 (C-CASE)-->
## CasingはRFC 430（C-CASE）に準拠しています。

<!--Basic Rust naming conventions are described in [RFC 430].-->
基本的な錆命名規則は[RFC 430]説明されてい[RFC 430]。

<!--In general, Rust tends to use `UpperCamelCase` for "type-level"constructs (types and traits) and `snake_case` for "value-level"constructs.-->
一般的に、Rustは`UpperCamelCase`を "タイプレベル"の構造（型と特性）に使用し、`snake_case`は "レベルレベル"の構造に使用する傾向があります。
<!--More precisely:-->
より正確に：

|<!--Item-->項目|<!--Convention-->コンベンション|
|<!-------->----|<!-------------->----------|
|<!--Crates-->クレート|[unclear](https://github.com/rust-lang-nursery/api-guidelines/issues/29)|
|<!--Modules-->モジュール|`snake_case`|
|<!--Types-->タイプ|`UpperCamelCase`|
|<!--Traits-->形質|`UpperCamelCase`|
|<!--Enum variants-->列挙型|`UpperCamelCase`|
|<!--Functions-->機能|`snake_case`|
|<!--Methods-->メソッド|`snake_case`|
|<!--General constructors-->一般的なコンストラクタ|<!--`new` or `with_more_details`-->`new`または`with_more_details`|
|<!--Conversion constructors-->変換コンストラクタ|`from_some_other_type`|
|<!--Macros-->マクロ|`snake_case!`|
|<!--Local variables-->ローカル変数|`snake_case`|
|<!--Statics-->統計|`SCREAMING_SNAKE_CASE`|
|<!--Constants-->定数|`SCREAMING_SNAKE_CASE`|
|<!--Type parameters-->タイプパラメータ|<!--concise `UpperCamelCase`, usually single uppercase letter: `T`-->簡潔な`UpperCamelCase`、通常は大文字の単一文字： `T`|
|<!--Lifetimes-->生涯|<!--short `lowercase`, usually a single letter: `'a`, `'de`, `'src`-->短い`lowercase`、通常は1文字： `'a`、 `'de`、 `'src`|
|<!--Features-->特徴|<!--[unclear](https://github.com/rust-lang-nursery/api-guidelines/issues/101) but see [C-FEATURE]-->[unclear](https://github.com/rust-lang-nursery/api-guidelines/issues/101)だが、[C-FEATURE]参照|

<!--In `UpperCamelCase`, acronyms and contractions of compound words count as one word: use `Uuid` rather than `UUID`, `Usize` rather than `USize` or `Stdin` rather than `StdIn`.-->
で`UpperCamelCase`、頭字語や複合語の収縮は一つの単語としてカウント：使用`Uuid`ではなく、`UUID`、 `Usize`よりもむしろ`USize`または`Stdin`ではなく、`StdIn`。
<!--In `snake_case`, acronyms and contractions are lower-cased: `is_xid_start`.-->
`snake_case`では、略語と`snake_case`は小文字で`is_xid_start`ます： `is_xid_start`。

<!--In `snake_case` or `SCREAMING_SNAKE_CASE`, a "word"should never consist of a single letter unless it is the last "word".-->
`snake_case`または`SCREAMING_SNAKE_CASE`では、最後の「単語」でない限り、「単語」は1文字で構成されるべきではありません。
<!--So, we have `btree_map` rather than `b_tree_map`, but `PI_2` rather than `PI2`.-->
したがって、`btree_map`ではなく`b_tree_map`ありますが、`PI2`ではなく`PI_2` `PI2`。

<!--Crate names should not use `-rs` or `-rust` as a suffix or prefix.-->
クレート名は、`-rs`または`-rust`を接尾辞または接頭辞として使用しないでください。
<!--Every crate is Rust!-->
すべての箱は錆です！
<!--It serves no purpose to remind users of this constantly.-->
このことをユーザーに常に思い出させる目的はありません。

<!--[RFC 430]: https://github.com/rust-lang/rfcs/blob/master/text/0430-finalizing-naming-conventions.md
 [C-FEATURE]: #c-feature
-->
[RFC 430]: https://github.com/rust-lang/rfcs/blob/master/text/0430-finalizing-naming-conventions.md
 [C-FEATURE]: #c-feature


### <!--Examples from the standard library--> 標準ライブラリの例

<!--The whole standard library.-->
標準ライブラリ全体。
<!--This guideline should be easy!-->
このガイドラインは簡単でなければなりません！


<span id="c-conv"></span><!--## Ad-hoc conversions follow `as_`, `to_`, `into_` conventions (C-CONV)-->
##アドホック変換は、`as_`、 `to_`、 `into_`慣習に従います（C-CONV）

<!--Conversions should be provided as methods, with names prefixed as follows:-->
変換はメソッドとして提供する必要があります。名前は次のようになります。

|<!--Prefix-->接頭辞|<!--Cost-->コスト|<!--Ownership-->所有|
|<!---------->------|<!-------->----|<!------------->---------|
|`as_`|<!--Free-->無料|<!--borrowed -\> borrowed-->借りた -\>借りた|
|`to_`|<!--Expensive-->高価な|<!--borrowed -\> borrowed-->借りた -\>借りた<!--borrowed -\> owned (non-Copy types)-->借用 -\>所有（非コピータイプ）<!--owned -\> owned (Copy types)-->所有 -\>所有（コピータイプ）|
|`into_`|<!--Variable-->変数|<!--owned -\> owned (non-Copy types)-->所有 -\>所有（非コピータイプ）|

<!--For example:-->
例えば：

- <!--[`str::as_bytes()`] gives a view of a `str` as a slice of UTF-8 bytes, which is free.-->
   [`str::as_bytes()`]は、フリーであるUTF-8バイトのスライスとしての`str`ビューを[`str::as_bytes()`]。
<!--The input is a borrowed `&str` and the output is a borrowed `&[u8]`.-->
   入力は借用された`&str`で、出力は借用された`&[u8]`です。
- <!--[`Path::to_str`] performs an expensive UTF-8 check on the bytes of an operating system path.-->
   [`Path::to_str`]は、オペレーティングシステムのパスのバイトに対して高価なUTF-8チェックを実行します。
<!--The input and output are both borrowed.-->
   入力と出力の両方が借用されています。
<!--It would not be correct to call this `as_str` because this method has nontrivial cost at runtime.-->
   このメソッドは実行時にコストがかからないため、この`as_str`を呼び出すことは正しくありません。
- <!--[`str::to_lowercase()`] produces the Unicode-correct lowercase equivalent of a `str`, which involves iterating through characters of the string and may require memory allocation.-->
   [`str::to_lowercase()`]は、文字列の文字を繰り返し処理し、メモリの割り当てが必要な場合に、`str`と同等のUnicode対応の小文字を生成します。
<!--The input is a borrowed `&str` and the output is an owned `String`.-->
   入力は借用された`&str`あり、出力は所有された`String`です。
- <!--[`f64::to_radians()`] converts a floating point quantity from degrees to radians.-->
   [`f64::to_radians()`]は浮動小数点数を度からラジアンに変換します。
<!--The input is `f64`.-->
   入力は`f64`です。
<!--Passing a reference `&f64` is not warranted because `f64` is cheap to copy.-->
   `f64`は安価にコピーできるので、リファレンス`&f64`合格は保証されません。
<!--Calling the function `into_radians` would be misleading because the input is not consumed.-->
   入力が消費されないため、関数`into_radians`を呼び出すと誤解を招きます。
- <!--[`String::into_bytes()`] extracts the underlying `Vec<u8>` of a `String`, which is free.-->
   [`String::into_bytes()`]は、空いている`String`基礎となる`Vec<u8>`を抽出します。
<!--It takes ownership of a `String` and returns an owned `Vec<u8>`.-->
   これは`String`所有権を取り、所有`Vec<u8>`を返します。
- <!--[`BufReader::into_inner()`] takes ownership of a buffered reader and extracts out the underlying reader, which is free.-->
   [`BufReader::into_inner()`]は、バッファリングされたリーダーの所有権を取り、基本となるリーダーを抽出します。
<!--Data in the buffer is discarded.-->
   バッファ内のデータは破棄されます。
- <!--[`BufWriter::into_inner()`] takes ownership of a buffered writer and extracts out the underlying writer, which requires a potentially expensive flush of any buffered data.-->
   [`BufWriter::into_inner()`]は、バッファされたライターの所有権をとり、バッファされたデータの潜在的に高価なフラッシュを必要とする基礎となるライターを抽出します。

<!--[`str::as_bytes()`]: https://doc.rust-lang.org/std/primitive.str.html#method.as_bytes
 [`Path::to_str`]: https://doc.rust-lang.org/std/path/struct.Path.html#method.to_str
 [`str::to_lowercase()`]: https://doc.rust-lang.org/std/primitive.str.html#method.to_lowercase
 [`f64::to_radians()`]: https://doc.rust-lang.org/std/primitive.f64.html#method.to_radians
 [`String::into_bytes()`]: https://doc.rust-lang.org/std/string/struct.String.html#method.into_bytes
 [`BufReader::into_inner()`]: https://doc.rust-lang.org/std/io/struct.BufReader.html#method.into_inner
 [`BufWriter::into_inner()`]: https://doc.rust-lang.org/std/io/struct.BufWriter.html#method.into_inner
-->
[`str::as_bytes()`]: https://doc.rust-lang.org/std/primitive.str.html#method.as_bytes
 [`Path::to_str`]: https://doc.rust-lang.org/std/path/struct.Path.html#method.to_str
 [`str::to_lowercase()`]: https://doc.rust-lang.org/std/primitive.str.html#method.to_lowercase
 [`f64::to_radians()`]: https://doc.rust-lang.org/std/primitive.f64.html#method.to_radians
 [`String::into_bytes()`]: https://doc.rust-lang.org/std/string/struct.String.html#method.into_bytes
 [`BufReader::into_inner()`]: https://doc.rust-lang.org/std/io/struct.BufReader.html#method.into_inner
 [`BufWriter::into_inner()`]: https://doc.rust-lang.org/std/io/struct.BufWriter.html#method.into_inner


<!--Conversions prefixed `as_` and `into_` typically  _decrease abstraction_ , either exposing a view into the underlying representation (`as`) or deconstructing data into its underlying representation (`into`).-->
接頭辞`as_`と`into_`接頭辞は、通常、ビューを基礎となる表現（`as`）に公開するか、データを基になる表現（ `into`）に`into_`  _抽象度を低下_ させます。
<!--Conversions prefixed `to_`, on the other hand, typically stay at the same level of abstraction but do some work to change one representation into another.-->
一方、`to_`という接頭辞は通常は同じ抽象レベルにとどまりますが、一方の表現を別の表現に変更する作業もあります。

<!--When a type wraps a single value to associate it with higher-level semantics, access to the wrapped value should be provided by an `into_inner()` method.-->
型が上位のセマンティクスに関連付けるために単一の値をラップする場合、ラップされた値へのアクセスは`into_inner()`メソッドによって提供される必要があります。
<!--This applies to wrappers that provide buffering like [`BufReader`], encoding or decoding like [`GzDecoder`], atomic access like [`AtomicBool`], or any similar semantics.-->
これは、のようなバッファリングを提供ラッパーに適用[`BufReader`]など、符号化または復号[`GzDecoder`]、等原子アクセス[`AtomicBool`]、または任意の同様のセマンティクスを。

<!--[`BufReader`]: https://doc.rust-lang.org/std/io/struct.BufReader.html#method.into_inner
 [`GzDecoder`]: https://docs.rs/flate2/0.2.19/flate2/read/struct.GzDecoder.html#method.into_inner
 [`AtomicBool`]: https://doc.rust-lang.org/std/sync/atomic/struct.AtomicBool.html#method.into_inner
-->
[`BufReader`]: https://doc.rust-lang.org/std/io/struct.BufReader.html#method.into_inner
 [`GzDecoder`]: https://docs.rs/flate2/0.2.19/flate2/read/struct.GzDecoder.html#method.into_inner
 [`AtomicBool`]: https://doc.rust-lang.org/std/sync/atomic/struct.AtomicBool.html#method.into_inner


<!--If the `mut` qualifier in the name of a conversion method constitutes part of the return type, it should appear as it would appear in the type.-->
変換メソッドの名前にある`mut`修飾子が戻り値の型の一部を構成する場合は、型に現れるように表示されます。
<!--For example [`Vec::as_mut_slice`] returns a mut slice;-->
たとえば、[`Vec::as_mut_slice`]はmutスライスを返します。
<!--it does what it says.-->
それはそれが言うことを行います。
<!--This name is preferred over `as_slice_mut`.-->
この名前は、`as_slice_mut`も優先され`as_slice_mut`。

[`Vec::as_mut_slice`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.as_mut_slice

```rust
#// Return type is a mut slice.
// 戻り値の型はmutスライスです。
fn as_mut_slice(&mut self) -> &mut [T];
```

##### <!--More examples from the standard library--> 標準ライブラリの例

- [`Result::as_ref`](https://doc.rust-lang.org/std/result/enum.Result.html#method.as_ref)
- [`RefCell::as_ptr`](https://doc.rust-lang.org/std/cell/struct.RefCell.html#method.as_ptr)
- [`slice::to_vec`](https://doc.rust-lang.org/std/primitive.slice.html#method.to_vec)
- [`Option::into_iter`](https://doc.rust-lang.org/std/option/enum.Option.html#method.into_iter)


<span id="c-getter"></span><!--## Getter names follow Rust convention (C-GETTER)-->
##ゲッター名はRust convention（C-GETTER）に従います。

<!--With a few exceptions, the `get_` prefix is not used for getters in Rust code.-->
いくつかの例外を除いて、`get_`接頭辞はRustコードのゲッターには使用されません。

```rust
pub struct S {
    first: First,
    second: Second,
}

impl S {
#    // Not get_first.
    //  Not get_first。
    pub fn first(&self) -> &First {
        &self.first
    }

#    // Not get_first_mut, get_mut_first, or mut_first.
    //  get_first_mut、get_mut_first、またはmut_firstではありません。
    pub fn first_mut(&mut self) -> &mut First {
        &mut self.first
    }
}
```

<!--The `get` naming is used only when there is a single and obvious thing that could reasonably be gotten by a getter.-->
`get`ネーミングは、ゲッターが合理的に得ることができる単一の明白なものがある場合にのみ使用されます。
<!--For example [`Cell::get`] accesses the content of a `Cell`.-->
例えば[`Cell::get`]のコンテンツにアクセス`Cell`。

[`Cell::get`]: https://doc.rust-lang.org/std/cell/struct.Cell.html#method.get

<!--For getters that do runtime validation such as bounds checking, consider adding unsafe `_unchecked` variants.-->
境界チェックなどの実行時検証を行うゲッターの場合、安全でない`_unchecked`バリアントを追加することを検討して`_unchecked`。
<!--Typically those will have the following signatures.-->
通常、これらのシグネチャは次のようになります。

```rust
fn get(&self, index: K) -> Option<&V>;
fn get_mut(&mut self, index: K) -> Option<&mut V>;
unsafe fn get_unchecked(&self, index: K) -> &V;
unsafe fn get_unchecked_mut(&mut self, index: K) -> &mut V;
```

<!--The difference between getters and conversions ([C-CONV](#c-conv)) can be subtle and is not always clear-cut.-->
ゲッターとコンバージョン（[C-CONV](#c-conv)）の違いは微妙であり、必ずしも明確ではない。
<!--For example [`TempDir::path`] can be understood as a getter for the filesystem path of the temporary directory, while [`TempDir::into_path`] is a conversion that transfers responsibility for deleting the temporary directory to the caller.-->
例えば、[`TempDir::path`]は一時ディレクトリのファイルシステムパスのゲッターとして理解できますが、[`TempDir::into_path`]は一時ディレクトリを削除する責任を呼び出し側に移す変換です。
<!--Since `path` is a getter, it would not be correct to call it `get_path` or `as_path`.-->
`path`はgetter `get_path`、 `as_path`または`as_path`と呼ぶのは正しいとは言えません。

<!--[`TempDir::path`]: https://docs.rs/tempdir/0.3.5/tempdir/struct.TempDir.html#method.path
 [`TempDir::into_path`]: https://docs.rs/tempdir/0.3.5/tempdir/struct.TempDir.html#method.into_path
-->
[`TempDir::path`]: https://docs.rs/tempdir/0.3.5/tempdir/struct.TempDir.html#method.path
 [`TempDir::into_path`]: https://docs.rs/tempdir/0.3.5/tempdir/struct.TempDir.html#method.into_path


### <!--Examples from the standard library--> 標準ライブラリの例

- [`std::io::Cursor::get_mut`](https://doc.rust-lang.org/std/io/struct.Cursor.html#method.get_mut)
- [`std::ptr::Unique::get_mut`](https://doc.rust-lang.org/std/ptr/struct.Unique.html#method.get_mut)
- [`std::sync::PoisonError::get_mut`](https://doc.rust-lang.org/std/sync/struct.PoisonError.html#method.get_mut)
- [`std::sync::atomic::AtomicBool::get_mut`](https://doc.rust-lang.org/std/sync/atomic/struct.AtomicBool.html#method.get_mut)
- [`std::collections::hash_map::OccupiedEntry::get_mut`](https://doc.rust-lang.org/std/collections/hash_map/struct.OccupiedEntry.html#method.get_mut)
- [`<[T]>::get_unchecked`](https://doc.rust-lang.org/std/primitive.slice.html#method.get_unchecked)


<span id="c-iter"></span><!--## Methods on collections that produce iterators follow `iter`, `iter_mut`, `into_iter` (C-ITER)-->
`iter`、 `iter_mut`、 `into_iter`続くイテレータを生成するコレクションのメソッド（C-ITER）

<!--Per [RFC 199].-->
[RFC 199]。

<!--For a container with elements of type `U`, iterator methods should be named:-->
`U`型の要素を持つコンテナの場合は、イテレータメソッドの名前を指定する必要があります。

```rust
#//fn iter(&self) -> Iter             // Iter implements Iterator<Item = &U>
fn iter(&self) -> Iter             //  IterはIteratorを実装しています
#//fn iter_mut(&mut self) -> IterMut  // IterMut implements Iterator<Item = &mut U>
fn iter_mut(&mut self) -> IterMut  //  IterMutはIteratorを実装しています
#//fn into_iter(self) -> IntoIter     // IntoIter implements Iterator<Item = U>
fn into_iter(self) -> IntoIter     //  IntoIterはIteratorを実装しています
```

<!--This guideline applies to data structures that are conceptually homogeneous collections.-->
このガイドラインは、概念的に同種のコレクションであるデータ構造に適用されます。
<!--As a counterexample, the `str` type is slice of bytes that are guaranteed to be valid UTF-8.-->
反例として、`str`型は、有効なUTF-8であることが保証されているスライスです。
<!--This is conceptually more nuanced than a homogeneous collection so rather than providing the `iter` / `iter_mut` / `into_iter` group of iterator methods, it provides [`str::bytes`] to iterate as bytes and [`str::chars`] to iterate as chars.-->
これは概念的には同種のコレクションよりも微妙なので、`iter_mut`の`iter` / `iter_mut` / `into_iter`グループを提供するのではなく、バイトとして反復する[`str::bytes`]と[`str::chars`]として反復する[`str::bytes`]を提供し[`str::bytes`]。

<!--[`str::bytes`]: https://doc.rust-lang.org/std/primitive.str.html#method.bytes
 [`str::chars`]: https://doc.rust-lang.org/std/primitive.str.html#method.chars
-->
[`str::bytes`]: https://doc.rust-lang.org/std/primitive.str.html#method.bytes
 [`str::chars`]: https://doc.rust-lang.org/std/primitive.str.html#method.chars


<!--This guideline applies to methods only, not functions.-->
このガイドラインはメソッドにのみ適用され、関数には適用されません。
<!--For example [`percent_encode`] from the `url` crate returns an iterator over percent-encoded string fragments.-->
例えば、`url` [`percent_encode`]からの[`percent_encode`]は、％でエンコードされた文字列フラグメントに対するイテレータを返します。
<!--There would be no clarity to be had by using an `iter` / `iter_mut` / `into_iter` convention.-->
`iter` / `iter_mut` / `into_iter`コンベンションを使用することによって明瞭さが`iter_mut`れることはありません。

<!--[`percent_encode`]: https://docs.rs/url/1.4.0/url/percent_encoding/fn.percent_encode.html
 [RFC 199]: https://github.com/rust-lang/rfcs/blob/master/text/0199-ownership-variants.md
-->
[`percent_encode`]: https://docs.rs/url/1.4.0/url/percent_encoding/fn.percent_encode.html
 [RFC 199]: https://github.com/rust-lang/rfcs/blob/master/text/0199-ownership-variants.md


### <!--Examples from the standard library--> 標準ライブラリの例

- [`Vec::iter`](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.iter)
- [`Vec::iter_mut`](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.iter_mut)
- [`Vec::into_iter`](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.into_iter)
- [`BTreeMap::iter`](https://doc.rust-lang.org/std/collections/struct.BTreeMap.html#method.iter)
- [`BTreeMap::iter_mut`](https://doc.rust-lang.org/std/collections/struct.BTreeMap.html#method.iter_mut)


<span id="c-iter-ty"></span><!--## Iterator type names match the methods that produce them (C-ITER-TY)-->
## Iteratorの型名は、それらを生成するメソッドと一致します（C-ITER-TY）

<!--A method called `into_iter()` should return a type called `IntoIter` and similarly for all other methods that return iterators.-->
呼ばれる方法`into_iter()`と呼ばれるタイプを返すべき`IntoIter`イテレータを返し、他のすべてのメソッドに対して、同様に。

<!--This guideline applies chiefly to methods, but often makes sense for functions as well.-->
このガイドラインは主にメソッドに適用されますが、関数についてもしばしば意味があります。
<!--For example the [`percent_encode`] function from the `url` crate returns an iterator type called [`PercentEncode`][PercentEncode-type].-->
たとえば、`url` [`PercentEncode`][PercentEncode-type]の[`percent_encode`]関数は、[`PercentEncode`][PercentEncode-type]というイテレータ型を返します。

[PercentEncode-type]: https://docs.rs/url/1.4.0/url/percent_encoding/struct.PercentEncode.html

<!--These type names make the most sense when prefixed with their owning module, for example [`vec::IntoIter`].-->
これらの型名は、[`vec::IntoIter`]ように、所有モジュールが接頭辞となっているときに最も意味を持ちます。

[`vec::IntoIter`]: https://doc.rust-lang.org/std/vec/struct.IntoIter.html

### <!--Examples from the standard library--> 標準ライブラリの例

* <!--[`Vec::iter`] returns [`Iter`][slice::Iter]-->
   [`Vec::iter`]返し[`Iter`][slice::Iter]
* <!--[`Vec::iter_mut`] returns [`IterMut`][slice::IterMut]-->
   [`Vec::iter_mut`]は[`IterMut`][slice::IterMut]返します
* <!--[`Vec::into_iter`] returns [`IntoIter`][vec::IntoIter]-->
   [`Vec::into_iter`]は[`IntoIter`][vec::IntoIter]返します[`IntoIter`][vec::IntoIter]
* <!--[`BTreeMap::keys`] returns [`Keys`][btree_map::Keys]-->
   [`BTreeMap::keys`]は[`Keys`][btree_map::Keys]返します
* <!--[`BTreeMap::values`] returns [`Values`][btree_map::Values]-->
   [`BTreeMap::values`]は[`Values`][btree_map::Values]返し[`Values`][btree_map::Values]

<!--[`Vec::iter`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.iter
 [slice::Iter]: https://doc.rust-lang.org/std/slice/struct.Iter.html
 [`Vec::iter_mut`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.iter_mut
 [slice::IterMut]: https://doc.rust-lang.org/std/slice/struct.IterMut.html
 [`Vec::into_iter`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.into_iter
 [vec::IntoIter]: https://doc.rust-lang.org/std/vec/struct.IntoIter.html
 [`BTreeMap::keys`]: https://doc.rust-lang.org/std/collections/struct.BTreeMap.html#method.keys
 [btree_map::Keys]: https://doc.rust-lang.org/std/collections/btree_map/struct.Keys.html
 [`BTreeMap::values`]: https://doc.rust-lang.org/std/collections/struct.BTreeMap.html#method.values
 [btree_map::Values]: https://doc.rust-lang.org/std/collections/btree_map/struct.Values.html
-->
[`Vec::iter`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.iter
 [slice::Iter]: https://doc.rust-lang.org/std/slice/struct.Iter.html
 [`Vec::iter`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.iter
 [`Vec::iter_mut`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.iter_mut
 [slice::IterMut]: https://doc.rust-lang.org/std/slice/struct.IterMut.html
 [`Vec::into_iter`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.into_iter
 [vec::IntoIter]: https://doc.rust-lang.org/std/vec/struct.IntoIter.html
 [`BTreeMap::keys`]: https://doc.rust-lang.org/std/collections/struct.BTreeMap.html#method.keys
 [btree_map::Keys]: https://doc.rust-lang.org/std/collections/btree_map/struct.Keys.html
 [`BTreeMap::keys`]: https://doc.rust-lang.org/std/collections/struct.BTreeMap.html#method.keys
 [btree_map::Keys]: https://doc.rust-lang.org/std/collections/btree_map/struct.Keys.html
 [`BTreeMap::values`]: https://doc.rust-lang.org/std/collections/struct.BTreeMap.html#method.values
 [btree_map::Values]: https://doc.rust-lang.org/std/collections/btree_map/struct.Values.html



<span id="c-feature"></span><!--## Feature names are free of placeholder words (C-FEATURE)-->
##機能名にはプレースホルダ語はありません（C-FEATURE）

<!--Do not include words in the name of a [Cargo feature] that convey zero meaning, as in `use-abc` or `with-abc`.-->
名前の単語含めないでください[Cargo feature]のように、ゼロ意味を伝える`use-abc`か`with-abc`。
<!--Name the feature `abc` directly.-->
この機能には`abc`直接指定します。

[Cargo feature]: http://doc.crates.io/manifest.html#the-features-section

<!--This arises most commonly for crates that have an optional dependency on the Rust standard library.-->
これは、Rust標準ライブラリに依存しているオプションのクレートに最もよく発生します。
<!--The canonical way to do this correctly is:-->
これを正しく行う標準的な方法は次のとおりです。

```toml
# In Cargo.toml

[features]
default = ["std"]
std = []
```

```rust
#// In lib.rs
//  lib.rsで

#![cfg_attr(not(feature = "std"), no_std)]
```

<!--Do not call the feature `use-std` or `with-std` or any creative name that is not `std`.-->
機能を呼び出すしないでください`use-std`または`with-std`かではありません任意のクリエイティブ名`std`。
<!--This naming convention aligns with the naming of implicit features inferred by Cargo for optional dependencies.-->
この命名規則は、オプションの依存関係のためにCargoによって推論された暗黙的な特徴の命名に沿っています。
<!--Consider crate `x` with optional dependencies on Serde and on the Rust standard library:-->
SerdeとRust標準ライブラリにオプションの依存関係を持つcrate `x`を考えてみましょう：

```toml
[package]
name = "x"
version = "0.1.0"

[features]
std = ["serde/std"]

[dependencies]
serde = { version = "1.0", optional = true }
```

<!--When we depend on `x`, we can enable the optional Serde dependency with `features = ["serde"]`.-->
`x`に依存する`x`、 `features = ["serde"]`オプションのSerde依存関係を有効にすることができます。
<!--Similarly we can enable the optional standard library dependency with `features = ["std"]`.-->
同様に、`features = ["std"]`オプションの標準ライブラリ依存関係を有効にすることもできます。
<!--The implicit feature inferred by Cargo for the optional dependency is called `serde`, not `use-serde` or `with-serde`, so we like for explicit features to behave the same way.-->
オプションの依存関係のためにCargoによって推論された暗黙的な特徴は、`serde`と呼ばれ、`use-serde`や`use-serde`ではなく`serde`と呼ばれる`serde`、明示的な機能が同じように動作することが`with-serde`。

<!--As a related note, Cargo requires that features are additive so a feature named negatively like `no-abc` is practically never correct.-->
関連する注記として、Cargoは機能が追加的であることを要求しているため、`no-abc`ような否定的な機能は実際には決して正確ではありません。


<span id="c-word-order"></span><!--## Names use a consistent word order (C-WORD-ORDER)-->
##名前は一貫した語順を使用します（C-WORD-ORDER）

<!--Here are some error types from the standard library:-->
標準ライブラリのエラータイプを次に示します。

- [`JoinPathsError`](https://doc.rust-lang.org/std/env/struct.JoinPathsError.html)
- [`ParseBoolError`](https://doc.rust-lang.org/std/str/struct.ParseBoolError.html)
- [`ParseCharError`](https://doc.rust-lang.org/std/char/struct.ParseCharError.html)
- [`ParseFloatError`](https://doc.rust-lang.org/std/num/struct.ParseFloatError.html)
- [`ParseIntError`](https://doc.rust-lang.org/std/num/struct.ParseIntError.html)
- [`RecvTimeoutError`](https://doc.rust-lang.org/std/sync/mpsc/enum.RecvTimeoutError.html)
- [`StripPrefixError`](https://doc.rust-lang.org/std/path/struct.StripPrefixError.html)

<!--All of these use verb-object-error word order.-->
これらのすべては、動詞 -目的語エラー語順を使用します。
<!--If we were adding an error to represent an address failing to parse, for consistency we would want to name it in verb-object-error order like `ParseAddrError` rather than `AddrParseError`.-->
解析に失敗したアドレスを表すエラーを追加した場合、一貫性のために`ParseAddrError`ではなく`AddrParseError`ような動詞 -オブジェクトエラー順に名前を付けることにします。

<!--The particular choice of word order is not important, but pay attention to consistency within the crate and consistency with similar functionality in the standard library.-->
単語順序の特定の選択は重要ではありませんが、標準ライブラリ内の同様の機能を使用して、枠内の一貫性と一貫性に注意してください。
