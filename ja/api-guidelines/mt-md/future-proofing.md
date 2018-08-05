# <!--Future proofing--> 将来の校正


<span id="c-sealed"></span><!--## Sealed traits protect against downstream implementations (C-SEALED)-->
##封鎖された形質は下流の実装から保護します（C-SEALED）

<!--Some traits are only meant to be implemented within the crate that defines them.-->
いくつかの形質は、それを定義する枠内でのみ実施されることを意図している。
<!--In such cases, we can retain the ability to make changes to the trait in a non-breaking way by using the sealed trait pattern.-->
そのような場合、我々は、密閉された形質パターンを使用することにより、形質を改変する能力を保持することができる。

```rust
#///// This trait is sealed and cannot be implemented for types outside this crate.
/// この形質は封印されており、この枠の外にある型に対しては実装できません。
pub trait TheTrait: private::Sealed {
#    // Zero or more methods that the user is allowed to call.
    // ユーザーが呼び出すことができる0個以上のメソッド。
    fn ...();

#    // Zero or more private methods, not allowed for user to call.
    // ゼロ個以上のプライベートメソッド。ユーザーがコールすることはできません。
    #[doc(hidden)]
    fn ...();
}

#// Implement for some types.
// いくつかの型のために実装してください。
impl TheTrait for usize {
    /* ... */
}

mod private {
    pub trait Sealed {}

#    // Implement for those same types, but no others.
    // 同じ種類のものを実装しますが、他のものは実装しません。
    impl Sealed for usize {}
}
```

<!--The empty private `Sealed` supertrait cannot be named by downstream crates, so we are guaranteed that implementations of `Sealed` (and therefore `TheTrait`) only exist in the current crate.-->
空のプライベート`Sealed` supertraitにはダウンストリームのクレートで名前を付けることができないため、`Sealed`（したがって`TheTrait`）の実装は現在のクレートにのみ存在することが保証`Sealed`ます。
<!--We are free to add methods to `TheTrait` in a non-breaking release even though that would ordinarily be a breaking change for traits that are not sealed.-->
`TheTrait`は、たとえ封印されていない形質の通常の変更であっても、`TheTrait`的な方法でメソッドを追加することは自由です。
<!--Also we are free to change the signature of methods that are not publicly documented.-->
また、公開されていない方法の署名も自由に変更できます。

<!--Note that removing a public method or changing the signature of a public method in a sealed trait are still breaking changes.-->
密封された特性でパブリックメソッドを削除するか、パブリックメソッドのシグネチャを変更することは、依然として大きな変化であることに注意してください。

<!--To avoid frustrated users trying to implement the trait, it should be documented in rustdoc that the trait is sealed and not meant to be implemented outside of the current crate.-->
欲求不満のユーザがその形質を実装しようとするのを避けるために、形質は封印されており、現在の木枠の外では実装されないことをrustdocで文書化する必要があります。

### <!--Examples--> 例

- [`serde_json::value::Index`](https://docs.serde.rs/serde_json/value/trait.Index.html)
- [`byteorder::ByteOrder`](https://docs.rs/byteorder/1.1.0/byteorder/trait.ByteOrder.html)


<span id="c-struct-private"></span><!--## Structs have private fields (C-STRUCT-PRIVATE)-->
##構造体にはプライベートフィールドがあります（C-STRUCT-PRIVATE）

<!--Making a field public is a strong commitment: it pins down a representation choice,  _and_  prevents the type from providing any validation or maintaining any invariants on the contents of the field, since clients can mutate it arbitrarily.-->
フィールドをパブリックにすることは、表現の選択肢を限定し、クライアントが任意にバリデーションを行うことができるため、タイプがフィールドの内容に対して任意の検証を提供したり、不変条件を維持するの _を_ 妨げます。

<!--Public fields are most appropriate for `struct` types in the C spirit: compound, passive data structures.-->
パブリックフィールドは、Cの精神の中の`struct`体型に最も適しています：複合パッシブデータ構造。
<!--Otherwise, consider providing getter/setter methods and hiding fields instead.-->
それ以外の場合は、getter / setterメソッドの提供とフィールドの非表示を検討してください。


<span id="c-newtype-hide"></span><!--## Newtypes encapsulate implementation details (C-NEWTYPE-HIDE)-->
## Newtypesは実装の詳細をカプセル化します（C-NEWTYPE-HIDE）

<!--A newtype can be used to hide representation details while making precise promises to the client.-->
newtypeを使用すると、クライアントに正確な約束をしながら表現の詳細を隠すことができます。

<!--For example, consider a function `my_transform` that returns a compound iterator type.-->
たとえば、複合イテレータ型を返す関数`my_transform`を考えてみ`my_transform`う。

```rust
use std::iter::{Enumerate, Skip};

pub fn my_transform<I: Iterator>(input: I) -> Enumerate<Skip<I>> {
    input.skip(3).enumerate()
}
```

<!--We wish to hide this type from the client, so that the client's view of the return type is roughly `Iterator<Item = (usize, T)>`.-->
このタイプをクライアントから隠して、クライアントの戻り値の型が概ね`Iterator<Item = (usize, T)>`ます。
<!--We can do so using the newtype pattern:-->
newtypeパターンを使用してこれを行うことができます：

```rust
use std::iter::{Enumerate, Skip};

pub struct MyTransformResult<I>(Enumerate<Skip<I>>);

impl<I: Iterator> Iterator for MyTransformResult<I> {
    type Item = (usize, I::Item);

    fn next(&mut self) -> Option<Self::Item> {
        self.0.next()
    }
}

pub fn my_transform<I: Iterator>(input: I) -> MyTransformResult<I> {
    MyTransformResult(input.skip(3).enumerate())
}
```

<!--Aside from simplifying the signature, this use of newtypes allows us to promise less to the client.-->
シグネチャを単純化する以外にも、この新しいタイプの使用により、クライアントにはあまりお約束することができません。
<!--The client does not know  _how_  the result iterator is constructed or represented, which means the representation can change in the future without breaking client code.-->
クライアントは、結果イテレータが _どのよう_ に構築または表現されている _かを_ 知らないため、クライアントコードを破ることなく表現が将来変更される可能性があります。

<!--In the future the same thing can be accomplished more concisely with the [`impl Trait`] feature but this is currently unstable.-->
将来、同じことを[`impl Trait`]機能によってより簡潔に達成することができますが、これは現在不安定です。

[`impl Trait`]: https://github.com/rust-lang/rfcs/blob/master/text/1522-conservative-impl-trait.md

```rust
#![feature(conservative_impl_trait)]

pub fn my_transform<I: Iterator>(input: I) -> impl Iterator<Item = (usize, I::Item)> {
    input.skip(3).enumerate()
}
```


<span id="c-struct-bounds"></span><!--## Data structures do not duplicate derived trait bounds (C-STRUCT-BOUNDS)-->
##データ構造は派生した特性境界を複製しません（C-STRUCT-BOUNDS）

<!--Generic data structures should not use trait bounds that can be derived or do not otherwise add semantic value.-->
一般的なデータ構造は、導出可能な形質境界を使用してはならない、または意味値を追加しないでください。
<!--Each trait in the `derive` attribute will be expanded into a separate `impl` block that only applies to generic arguments that implement that trait.-->
`derive`属性の各特性は、その特性を実装する汎用引数にのみ適用される別個の`impl`ブロックに展開されます。

```rust
#// Prefer this:
// これを好む：
#[derive(Clone, Debug, PartialEq)]
struct Good<T> { /* ... */ }

#// Over this:
// これ以上：
#[derive(Clone, Debug, PartialEq)]
struct Bad<T: Clone + Debug + PartialEq> { /* ... */ }
```

<!--Duplicating derived traits as bounds on `Bad` is unnecessary and a backwards-compatibiliity hazard.-->
`Bad`境界として派生した特性を複製することは不要であり、後方互換性の危険もあります。
<!--To illustrate this point, consider deriving `PartialOrd` on the structures in the previous example:-->
この点を説明するには、前の例の構造`PartialOrd`を導出することを`PartialOrd`してください。

```rust
#// Non-breaking change:
// ノン・ブレイク・チェンジ：
#[derive(Clone, Debug, PartialEq, PartialOrd)]
struct Good<T> { /* ... */ }

#// Breaking change:
// 変更を破る：
#[derive(Clone, Debug, PartialEq, PartialOrd)]
struct Bad<T: Clone + Debug + PartialEq + PartialOrd> { /* ... */ }
```

<!--Generally speaking, adding a trait bound to a data structure is a breaking change because every consumer of that structure will need to start satisfying the additional bound.-->
一般に、データ構造にバインドされた特性を追加することは、その構造のすべてのコンシューマが追加バインディングを満たす必要があるため、大きな変更です。
<!--Deriving more traits from the standard library using the `derive` attribute is not a breaking change.-->
derive属性を使用して標準ライブラリからより多くの形質を`derive`ことは、大きな変化ではありません。

<!--The following traits should never be used in bounds on data structures:-->
以下の特性は、データ構造の境界で決して使用しないでください。

- `Clone`
- `PartialEq`
- `PartialOrd`
- `Debug`
- `Display`
- `Default`
- `Serialize`
- `Deserialize`
- `DeserializeOwned`

<!--There is a grey area around other non-derivable trait bounds that are not strictly required by the structure definition, like `Read` or `Write`.-->
構造体定義によって厳密には要求されていない、`Read`または`Write`などの他の非導出可能な特性境界の周囲には、灰色の領域があります。
<!--They may communicate the intended behavior of the type better in its definition but also limits future extensibility.-->
彼らはそのタイプの意図された振る舞いをその定義においてより良く伝えるかもしれないが、将来の拡張性も制限する。
<!--Including semantically useful trait bounds on data structures is still less problematic than including derivable traits as bounds.-->
意味的に有用な形質境界をデータ構造に含めることは、誘導可能な形質を境界として含めることよりも問題が少ない。

### <!--Exceptions--> 例外

<!--There are three exceptions where trait bounds on structures are required:-->
構造上の特性境界が必要な場合は3つの例外があります。

1. <!--The data structure refers to an associated type on the trait.-->
    データ構造は、形質上の関連する型を指す。
1. <!--The bound is `?Sized`.-->
    束縛は「 `?Sized`です。
1. <!--The data structure has a `Drop` impl that requires trait bounds.-->
    データ構造には、特性境界を必要とする`Drop` implがあります。
<!--Rust currently requires all trait bounds on the `Drop` impl are also present on the data structure.-->
Rustは現在、`Drop` implのすべての特性境界もデータ構造上に存在する必要があります。

### <!--Examples from the standard library--> 標準ライブラリの例

- <!--[`std::borrow::Cow`] refers to an associated type on the `Borrow` trait.-->
   [`std::borrow::Cow`]は、`Borrow`特性の関連タイプを指します。
- <!--[`std::boxed::Box`] opts out of the implicit `Sized` bound.-->
   [`std::boxed::Box`]は、暗黙の`Sized` boundからオプトアウトします。
- <!--[`std::io::BufWriter`] requires a trait bound in its `Drop` impl.-->
   [`std::io::BufWriter`]は、その`Drop` [`std::io::BufWriter`]、特性バウンドを必要とします。

<!--[`std::borrow::Cow`]: https://doc.rust-lang.org/std/borrow/enum.Cow.html
 [`std::boxed::Box`]: https://doc.rust-lang.org/std/boxed/struct.Box.html
 [`std::io::BufWriter`]: https://doc.rust-lang.org/std/io/struct.BufWriter.html
-->
[`std::borrow::Cow`]: https://doc.rust-lang.org/std/borrow/enum.Cow.html
 [`std::boxed::Box`]: https://doc.rust-lang.org/std/boxed/struct.Box.html
 [`std::io::BufWriter`]: https://doc.rust-lang.org/std/io/struct.BufWriter.html

