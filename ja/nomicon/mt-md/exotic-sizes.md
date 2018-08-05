# <!--Exotically Sized Types--> 外来サイズのタイプ

<!--Most of the time, we think in terms of types with a fixed, positive size.-->
ほとんどの場合、固定サイズの正のサイズの型の点で考えています。
<!--This is not always the case, however.-->
しかし、必ずしもそうではありません。





# <!--Dynamically Sized Types (DSTs)--> 動的にサイズ設定された型（DST）

<!--Rust in fact supports Dynamically Sized Types (DSTs): types without a statically known size or alignment.-->
実際には、Rustは、動的にサイズが指定された型（DST）をサポートしています。
<!--On the surface, this is a bit nonsensical: Rust *must* know the size and alignment of something in order to correctly work with it!-->
表面では、これはちょっと無意味です：錆*は*、正しく動作するために、何かのサイズと位置合わせを知ってい*なければなりません*！
<!--In this regard, DSTs are not normal types.-->
これに関して、DSTは通常のタイプではありません。
<!--Due to their lack of a statically known size, these types can only exist behind some kind of pointer.-->
静的に既知のサイズがないため、これらの型はある種のポインタの後ろにしか存在できません。
<!--Any pointer to a DST consequently becomes a *fat* pointer consisting of the pointer and the information that "completes"them (more on this below).-->
その結果、DSTへのポインターは、ポインターとそれらを「完了する」情報からなる*太い*ポインターになります（詳細は後述）。

<!--There are two major DSTs exposed by the language: trait objects, and slices.-->
言語によって公開される主要なDSTには、特性オブジェクトとスライスの2つがあります。

<!--A trait object represents some type that implements the traits it specifies.-->
特性オブジェクトは、それが指定する特性を実装するいくつかのタイプを表します。
<!--The exact original type is *erased* in favor of runtime reflection with a vtable containing all the information necessary to use the type.-->
正確なオリジナルタイプは、タイプを使用するのに必要なすべての情報を含むvtableを使用して、実行時リフレクションのために*消去さ*れます。
<!--This is the information that completes a trait object: a pointer to its vtable.-->
これは、traitオブジェクトを完成させる情報です：vtableへのポインタ。

<!--A slice is simply a view into some contiguous storage --typically an array or `Vec`.-->
スライスは、連続したいくつかのストレージ（通常はアレイまたは`Vec`への単純なビューです。
<!--The information that completes a slice is just the number of elements it points to.-->
スライスを完成させる情報は、それが指す要素の数だけです。

<!--Structs can actually store a single DST directly as their last field, but this makes them a DST as well:-->
構造体は実際には単一のDSTを最後のフィールドとして直接格納することができますが、これによってDSTにもなります。

```rust
#// Can't be stored on the stack directly
// スタックに直接格納することはできません
struct Foo {
    info: u32,
    data: [u8],
}
```


# <!--Zero Sized Types (ZSTs)--> ゼロサイズタイプ（ZST）

<!--Rust actually allows types to be specified that occupy no space:-->
Rustは実際にはスペースを使わない型を指定することを可能にします：

```rust
#//struct Foo; // No fields = no size
struct Foo; // フィールドなし=サイズなし

#// All fields have no size = no size
// すべてのフィールドにサイズはありません=サイズはありません
struct Baz {
    foo: Foo,
#//    qux: (),      // empty tuple has no size
    qux: (),      // 空のタプルにサイズがありません
#//    baz: [u8; 0], // empty array has no size
    baz: [u8; 0], // 空の配列にはサイズがありません
}
```

<!--On their own, Zero Sized Types (ZSTs) are, for obvious reasons, pretty useless.-->
明らかに、Zero Sized Types（ZST）は無意味です。
<!--However as with many curious layout choices in Rust, their potential is realized in a generic context: Rust largely understands that any operation that produces or stores a ZST can be reduced to a no-op.-->
しかし、Rustの多くの興味深いレイアウトの選択肢と同様に、それらの可能性は一般的なコンテキストで実現されます.Rustは、ZSTを生成または格納する操作をノーオペレーションに減らすことができます。
<!--First off, storing it doesn't even make sense --it doesn't occupy any space.-->
最初に、それを格納することは意味をなさない -それはスペースを占有しません。
<!--Also there's only one value of that type, so anything that loads it can just produce it from the aether --which is also a no-op since it doesn't occupy any space.-->
また、そのタイプの値は1つだけなので、ロードするものはどれもaetherから生成できます。これはスペースを占有しないため、ノーオペレーションでもあります。

<!--One of the most extreme example's of this is Sets and Maps.-->
これの最も極端な例の1つは、セットとマップです。
<!--Given a `Map<Key, Value>`, it is common to implement a `Set<Key>` as just a thin wrapper around `Map<Key, UselessJunk>`.-->
`Map<Key, Value>`を指定すると、`Map<Key, UselessJunk>`周りに薄いラッパーとして`Set<Key>`を実装するのが一般的です。
<!--In many languages, this would necessitate allocating space for UselessJunk and doing work to store and load UselessJunk only to discard it.-->
多くの言語では、これは、UselessJunkにスペースを割り当て、それを破棄するためにUselessJunkを保存しロードする作業を必要とします。
<!--Proving this unnecessary would be a difficult analysis for the compiler.-->
これが不必要であることを証明することは、コンパイラにとって難しい分析です。

<!--However in Rust, we can just say that `Set<Key> = Map<Key, ()>`.-->
しかし、Rustでは`Set<Key> = Map<Key, ()>`としか言いようがありません。
<!--Now Rust statically knows that every load and store is useless, and no allocation has any size.-->
現在、Rustはすべての負荷とストアが役に立たず、割り当てにサイズがないことを静的に知っています。
<!--The result is that the monomorphized code is basically a custom implementation of a HashSet with none of the overhead that HashMap would have to support values.-->
その結果、単体化されたコードは基本的に、HashMapが値をサポートしなければならないオーバーヘッドのないHashSetのカスタム実装です。

<!--Safe code need not worry about ZSTs, but *unsafe* code must be careful about the consequence of types with no size.-->
安全なコードはZSTについて心配する必要はありませんが、*安全でない*コードはサイズのない型の結果に注意する必要があります。
<!--In particular, pointer offsets are no-ops, and standard allocators (including jemalloc, the one used by default in Rust) may return `nullptr` when a zero-sized allocation is requested, which is indistinguishable from out of memory.-->
特に、ポインタオフセットはno-opsであり、標準アロケータ（rustでデフォルトで使用されるjemallocを含む）は、サイズがゼロの割り当てが要求されたときに`nullptr`返すことがあります。これはメモリ不足と区別できません。





# <!--Empty Types--> 空のタイプ

<!--Rust also enables types to be declared that *cannot even be instantiated*.-->
錆はまた、*インスタンス化さえできない*型を宣言する*こと*を*可能にします*。
<!--These types can only be talked about at the type level, and never at the value level.-->
これらのタイプは、タイプレベルでのみ話すことができ、決して値レベルでは話せません。
<!--Empty types can be declared by specifying an enum with no variants:-->
空の型は、バリアントのないenumを指定することで宣言できます：

```rust
#//enum Void {} // No variants = EMPTY
enum Void {} // バリエーションはありません= EMPTY
```

<!--Empty types are even more marginal than ZSTs.-->
空のタイプはZSTよりもはるかに限界です。
<!--The primary motivating example for Void types is type-level unreachability.-->
Void型の主要な動機付けの例は、型レベルの到達不能性です。
<!--For instance, suppose an API needs to return a Result in general, but a specific case actually is infallible.-->
たとえば、APIが一般的にResultを返す必要があるとしますが、具体的なケースは実際には間違いありません。
<!--It's actually possible to communicate this at the type level by returning a `Result<T, Void>`.-->
`Result<T, Void>`返すことで、これを型レベルで通信することは実際可能です。
<!--Consumers of the API can confidently unwrap such a Result knowing that it's *statically impossible* for this value to be an `Err`, as this would require providing a value of type `Void`.-->
APIの消費者は、この値が`Err`であることが*静的に不可能*であることを知って、このような結果を確実にアンラップできます。これは、`Void`型の値を提供する必要があるためです。

<!--In principle, Rust can do some interesting analyses and optimizations based on this fact.-->
原則として、Rustはこの事実に基づいていくつかの興味深い分析と最適化を行うことができます。
<!--For instance, `Result<T, Void>` could be represented as just `T`, because the `Err` case doesn't actually exist.-->
たとえば、`Err`場合は実際には存在しないため、`Result<T, Void>`は`T`として表すことができます。
<!--The following *could* also compile:-->
次もコンパイル*でき*ます：

```rust,ignore
enum Void {}

let res: Result<u32, Void> = Ok(0);

#// Err doesn't exist anymore, so Ok is actually irrefutable.
//  Errはもう存在しないので、Okは実際には反駁できません。
let Ok(num) = res;
```

<!--But neither of these tricks work today, so all Void types get you is the ability to be confident that certain situations are statically impossible.-->
しかし、これらの仕掛けは今日でも機能しないので、すべてのVoidタイプは、特定の状況が静的に不可能であることを確信する能力です。

<!--One final subtle detail about empty types is that raw pointers to them are actually valid to construct, but dereferencing them is Undefined Behavior because that doesn't actually make sense.-->
空の型に関する最後の微妙な詳細の1つは、それらの生ポインタが実際に構築するのに有効ですが、それらを逆参照することは、実際には意味がないため、未定義の動作です。
<!--That is, you could model C's `void *` type with `*const Void`, but this doesn't necessarily gain anything over using eg `*const ()`, which *is* safe to randomly dereference.-->
それはあなたがCのモデル化ができ、ある`void *`とタイプ`*const Void`、これは必ずしもなどを使用しての上に何かを得ることはありません`*const ()`ランダムに間接参照に安全*です*、。


[dst-issue]: https://github.com/rust-lang/rust/issues/26403
