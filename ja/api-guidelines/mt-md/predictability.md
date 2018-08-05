# <!--Predictability--> 予測可能性


<span id="c-smart-ptr"></span><!--## Smart pointers do not add inherent methods (C-SMART-PTR)-->
##スマートポインタは、固有のメソッド（C-SMART-PTR）を追加しません。

<!--For example, this is why the [`Box::into_raw`] function is defined the way it is.-->
例えば、これは[`Box::into_raw`]関数が定義されている理由です。

[`Box::into_raw`]: https://doc.rust-lang.org/std/boxed/struct.Box.html#method.into_raw

```rust
impl<T> Box<T> where T: ?Sized {
    fn into_raw(b: Box<T>) -> *mut T { /* ... */ }
}

let boxed_str: Box<str> = /* ... */;
let ptr = Box::into_raw(boxed_str);
```

<!--If this were defined as an inherent method instead, it would be confusing at the call site whether the method being called is a method on `Box<T>` or a method on `T`.-->
これは代わりに固有のメソッドとして定義されている場合、それが呼び出されるメソッドが上のメソッドであるかどうかを呼び出しサイトで混乱するでしょう`Box<T>`または上のメソッド`T`。

```rust
impl<T> Box<T> where T: ?Sized {
#    // Do not do this.
    // こんなことしないで。
    fn into_raw(self) -> *mut T { /* ... */ }
}

let boxed_str: Box<str> = /* ... */;

#// This is a method on str accessed through the smart pointer Deref impl.
// これはスマートポインタDeref implを通してアクセスされるstrのメソッドです。
boxed_str.chars()

#// This is a method on Box<str>...?
// これはBoxのメソッドです...？
boxed_str.into_raw()
```


<span id="c-conv-specific"></span><!--## Conversions live on the most specific type involved (C-CONV-SPECIFIC)-->
##コンバージョンは、関与する最も特定のタイプに存在します（C-CONV-SPECIFIC）

<!--When in doubt, prefer `to_` / `as_` / `into_` to `from_`, because they are more ergonomic to use (and can be chained with other methods).-->
`to_`場合は、使用する人間工学的であり（他の方法と連鎖することもできる）、`to_` / `as_` / `into_`から`into_`を`from_`。

<!--For many conversions between two types, one of the types is clearly more "specific": it provides some additional invariant or interpretation that is not present in the other type.-->
2つのタイプ間の多くの変換では、タイプの1つが明らかに「特定」であり、他のタイプには存在しないいくつかの追加の不変または解釈を提供します。
<!--For example, [`str`] is more specific than `&[u8]`, since it is a UTF-8 encoded sequence of bytes.-->
たとえば、[`str`]はUTF-8でエンコードされた一連のバイトであるため、`&[u8]`よりも具体的です。

[`str`]: https://doc.rust-lang.org/std/primitive.str.html

<!--Conversions should live with the more specific of the involved types.-->
コンバージョンは関連するタイプのより具体的なもので生きていなければなりません。
<!--Thus, `str` provides both the [`as_bytes`] method and the [`from_utf8`] constructor for converting to and from `&[u8]` values.-->
したがって、`str`は、`&[u8]`値との変換のための[`as_bytes`]メソッドと[`from_utf8`]コンストラクタの両方を提供します。
<!--Besides being intuitive, this convention avoids polluting concrete types like `&[u8]` with endless conversion methods.-->
直観的であるだけでなく、このコンベンションでは、無限の変換方法で`&[u8]`ような具体的な型を汚染するのを`&[u8]`ます。

<!--[`as_bytes`]: https://doc.rust-lang.org/std/primitive.str.html#method.as_bytes
 [`from_utf8`]: https://doc.rust-lang.org/std/str/fn.from_utf8.html
-->
[`as_bytes`]: https://doc.rust-lang.org/std/primitive.str.html#method.as_bytes
 [`from_utf8`]: https://doc.rust-lang.org/std/str/fn.from_utf8.html



<span id="c-method"></span><!--## Functions with a clear receiver are methods (C-METHOD)-->
##明確なレシーバを持つ関数はメソッド（C-METHOD）です。

<!--Prefer-->
好む

```rust
impl Foo {
    pub fn frob(&self, w: widget) { /* ... */ }
}
```

<!--over-->
以上

```rust
pub fn frob(foo: &Foo, w: widget) { /* ... */ }
```

<!--for any operation that is clearly associated with a particular type.-->
特定のタイプに明確に関連付けられている操作については、

<!--Methods have numerous advantages over functions:-->
メソッドには、関数に比べて多くの利点があります。

* <!--They do not need to be imported or qualified to be used: all you need is a value of the appropriate type.-->
   インポートする必要はなく、使用する資格があります。必要なのは適切なタイプの値だけです。
* <!--Their invocation performs autoborrowing (including mutable borrows).-->
   彼らの呼び出しは自動練習（変更可能な借用を含む）を実行します。
* <!--They make it easy to answer the question "what can I do with a value of type `T` "(especially when using rustdoc).-->
   彼らは "`T`型の値で何ができるか"という質問に簡単に答えることができます（特にrustdocを使用する場合）。
* <!--They provide `self` notation, which is more concise and often more clearly conveys ownership distinctions.-->
   彼らは`self`表記法を提供しており、これはより簡潔であり、所有権の区別をより明確に伝えることが多い。


<span id="c-no-out"></span><!--## Functions do not take out-parameters (C-NO-OUT)-->
##機能はパラメータを取り出さない（C-NO-OUT）

<!--Prefer-->
好む

```rust
fn foo() -> (Bar, Bar)
```

<!--over-->
以上

```rust
fn foo(output: &mut Bar) -> Bar
```

<!--for returning multiple `Bar` values.-->
複数の`Bar`値を返す

<!--Compound return types like tuples and structs are efficiently compiled and do not require heap allocation.-->
タプルや構造体などの複合戻り値の型は効率的にコンパイルされ、ヒープ割り当ては不要です。
<!--If a function needs to return multiple values, it should do so via one of these types.-->
関数が複数の値を返す必要がある場合は、これらの型のいずれかを使用して値を返す必要があります。

<!--The primary exception: sometimes a function is meant to modify data that the caller already owns, for example to re-use a buffer:-->
主な例外：関数は、バッファを再利用するなど、呼び出し元がすでに所有しているデータを変更することがあります。

```rust
fn read(&mut self, buf: &mut [u8]) -> io::Result<usize>
```


<span id="c-overload"></span><!--## Operator overloads are unsurprising (C-OVERLOAD)-->
##演算子のオーバーロードは驚くべきものではありません（C-OVERLOAD）

<!--Operators with built in syntax (`*`, `|`, and so on) can be provided for a type by implementing the traits in [`std::ops`].-->
[`std::ops`]特性を実装することで、構文に組み込みの演算子（`*`、 `|`など）を型に対して提供することができます。
<!--These operators come with strong expectations: implement `Mul` only for an operation that bears some resemblance to multiplication (and shares the expected properties, eg associativity), and so on for the other traits.-->
これらの演算子は、強い期待が付属しています：実装`Mul`乗算のみ（および株式期待される特性、例えば結合性）にいくつか似ている操作のために、というように、他の形質について。

[`std::ops`]: https://doc.rust-lang.org/std/ops/index.html#traits


<span id="c-deref"></span><!--## Only smart pointers implement `Deref` and `DerefMut` (C-DEREF)-->
##だけがスマートポインタ実装`Deref`と`DerefMut`（C-DEREF）

<!--The `Deref` traits are used implicitly by the compiler in many circumstances, and interact with method resolution.-->
`Deref`特性は、多くの状況でコンパイラによって暗黙的に使用され、メソッド解決と相互作用します。
<!--The relevant rules are designed specifically to accommodate smart pointers, and so the traits should be used only for that purpose.-->
関連するルールは、スマートポインタに対応するように特別に設計されているため、その目的のためにのみ特性を使用する必要があります。

### <!--Examples from the standard library--> 標準ライブラリの例

- [`Box<T>`](https://doc.rust-lang.org/std/boxed/struct.Box.html)
- <!--[`String`](https://doc.rust-lang.org/std/string/struct.String.html) is a smart pointer to [`str`](https://doc.rust-lang.org/std/primitive.str.html)-->
   [`String`](https://doc.rust-lang.org/std/string/struct.String.html)は[`str`](https://doc.rust-lang.org/std/primitive.str.html)へのスマートポインタです
- [`Rc<T>`](https://doc.rust-lang.org/std/rc/struct.Rc.html)
- [`Arc<T>`](https://doc.rust-lang.org/std/sync/struct.Arc.html)
- [`Cow<'a, T>`](https://doc.rust-lang.org/std/borrow/enum.Cow.html)


<span id="c-ctor"></span><!--## Constructors are static, inherent methods (C-CTOR)-->
##コンストラクタはスタティックで固有のメソッド（C-CTOR）です。

<!--In Rust, "constructors"are just a convention.-->
Rustでは、"コンストラクタ"は単なるコンベンションです。
<!--There are a variety of conventions around constructor naming, and the distinctions are often subtle.-->
コンストラクターの名前にはさまざまな慣習があり、その区別はしばしば微妙です。

<!--A constructor in its most basic form is a `new` method with no arguments.-->
最も基本的な形式のコンストラクタは、引数のない`new`メソッドです。

```rust
impl<T> Example<T> {
    pub fn new() -> Example<T> { /* ... */ }
}
```

<!--Constructors are static (no `self`) inherent methods for the type that they construct.-->
コンストラクターは、構成する型の静的な（`self`はない）固有のメソッドです。
<!--Combined with the practice of fully importing type names, this convention leads to informative but concise construction:-->
型名を完全にインポートするという習慣と組み合わせることで、このコンベンションは有益ではあるが簡潔な構成につながります。

```rust
use example::Example;

#// Construct a new Example.
// 新しい例を作成します。
let ex = Example::new();
```

<!--The name `new` should generally be used for the primary method of instantiating a type.-->
`new`という名前は、通常、型をインスタンス化する主なメソッドに使用されるべきです。
<!--Sometimes it takes no arguments, as in the examples above.-->
上記の例のように、引数を取らないこともあります。
<!--Sometimes it does take arguments, like [`Box::new`] which is passed the value to place in the `Box`.-->
時にはそれは次のように、引数を取らない[`Box::new`]に配置する値渡された`Box`。

<!--Some types' constructors, most notably I/O resource types, use distinct naming conventions for their constructors, as in [`File::open`], [`Mmap::open`], [`TcpStream::connect`], and [`UpdSocket::bind`].-->
[`File::open`]、 [`Mmap::open`]、 [`TcpStream::connect`]、 [`UpdSocket::bind`]ように、いくつかの型のコンストラクタ、特にI / Oリソース型は、それらのコンストラクタに異なる命名規則を使用します[`UpdSocket::bind`]。
<!--In these cases names are chosen as appropriate for the domain.-->
これらの場合、ドメインに応じて名前が選択されます。

<!--Often there are multiple ways to construct a type.-->
多くの場合、型を構築する方法は複数あります。
<!--It's common in these cases for secondary constructors to be suffixed `_with_foo`, as in [`Mmap::open_with_offset`].-->
[`Mmap::open_with_offset`]ように、二次コンストラクタに接尾辞`_with_foo`のが一般的[`Mmap::open_with_offset`]。
<!--If your type has a multiplicity of construction options though, consider the builder pattern ([C-BUILDER]) instead.-->
あなたのタイプに複数の構築オプションがある場合は、代わりにビルダーパターン（[C-BUILDER]）を考慮してください。

<!--Some constructors are "conversion constructors", methods that create a new type from an existing value of a different type.-->
いくつかのコンストラクタは、"コンバージョンコンストラクタ"です。これは、別の型の既存の値から新しい型を作成するメソッドです。
<!--These typically have names begining with `from_` as in [`std::io::Error::from_raw_os_error`].-->
これらは通常で初めの名前持っている`from_`のように[`std::io::Error::from_raw_os_error`]。
<!--Note also though the `From` trait ([C-CONV-TRAITS]), which is quite similar.-->
`From`特性（[C-CONV-TRAITS]）も同様であることに注意してください。
<!--There are three distinctions between a `from_` -prefixed conversion constructor and a `From<T>` impl.-->
間に3つの区別があります`from_` -prefixed変換コンストラクタとA `From<T>`独自の実装が。

- <!--A `from_` constructor can be unsafe;-->
   `from_`コンストラクタは安全ではありません。
<!--a `From` impl cannot.-->
   `From`のimplはできません。
<!--One example of this is [`Box::from_raw`].-->
   これの一例は[`Box::from_raw`]です。
- <!--A `from_` constructor can accept additional arguments to disambiguate the meaning of the source data, as in [`u64::from_str_radix`].-->
   `from_`コンストラクタは、[`u64::from_str_radix`]ように、ソースデータの意味を明確にする追加の引数を受け入れることができます。
- <!--A `From` impl is only appropriate when the source data type is sufficient to determine the encoding of the output data type.-->
   `From`インプットは、ソースデータ型が出力データ型のエンコーディングを決定するのに十分である場合にのみ適切です。
<!--When the input is just a bag of bits like in [`u64::from_be`] or [`String::from_utf8`], the conversion constructor name is able to identify their meaning.-->
   入力が[`u64::from_be`]や[`String::from_utf8`]ようなビットの[`String::from_utf8`]場合、変換コンストラクタ名はその意味を識別できます。

<!--[`Box::from_raw`]: https://doc.rust-lang.org/std/boxed/struct.Box.html#method.from_raw
 [`u64::from_str_radix`]: https://doc.rust-lang.org/std/primitive.u64.html#method.from_str_radix
 [`u64::from_be`]: https://doc.rust-lang.org/std/primitive.u64.html#method.from_be
 [`String::from_utf8`]: https://doc.rust-lang.org/std/string/struct.String.html#method.from_utf8
-->
[`Box::from_raw`]: https://doc.rust-lang.org/std/boxed/struct.Box.html#method.from_raw
 [`u64::from_str_radix`]: https://doc.rust-lang.org/std/primitive.u64.html#method.from_str_radix
 [`u64::from_be`]: https://doc.rust-lang.org/std/primitive.u64.html#method.from_be
 [`String::from_utf8`]: https://doc.rust-lang.org/std/string/struct.String.html#method.from_utf8


<!--Note that it is common and expected for types to implement both `Default` and a `new` constructor.-->
型が`Default`と`new`コンストラクタの両方を実装することは一般的であり、期待されていることに注意してください。
<!--For types that have both, they should have the same behavior.-->
両方を持つタイプの場合、同じ動作をする必要があります。
<!--Either one may be implemented in terms of the other.-->
いずれか一方を他方の観点から実装することができる。

<!--[C-BUILDER]: type-safety.html#c-builder
 [C-CONV-TRAITS]: interoperability.html#c-conv-traits
-->
[C-BUILDER]: type-safety.html#c-builder
 [C-CONV-TRAITS]: interoperability.html#c-conv-traits


### <!--Examples from the standard library--> 標準ライブラリの例

- <!--[`std::io::Error::new`] is the commonly used constructor for an IO error.-->
   [`std::io::Error::new`]はIOエラーのためによく使われるコンストラクタです。
- <!--[`std::io::Error::from_raw_os_error`] is a conversion constructor based on an error code received from the operating system.-->
   [`std::io::Error::from_raw_os_error`]は、オペレーティングシステムから受け取ったエラーコードに基づく変換コンストラクタです。
- <!--[`Box::new`] creates a new container type, taking a single argument.-->
   [`Box::new`]は単一の引数を取って新しいコンテナ型を作成します。
- <!--[`File::open`] opens a file resource.-->
   [`File::open`]はファイルリソースを開きます。
- <!--[`Mmap::open_with_offset`] opens a memory-mapped file, with additional options.-->
   [`Mmap::open_with_offset`]はメモリマップされたファイルをオープンします。

<!--[`File::open`]: https://doc.rust-lang.org/stable/std/fs/struct.File.html#method.open
 [`Mmap::open`]: https://docs.rs/memmap/0.5.2/memmap/struct.Mmap.html#method.open
 [`Mmap::open_with_offset`]: https://docs.rs/memmap/0.5.2/memmap/struct.Mmap.html#method.open_with_offset
 [`TcpStream::connect`]: https://doc.rust-lang.org/stable/std/net/struct.TcpStream.html#method.connect
 [`UpdSocket::bind`]: https://doc.rust-lang.org/stable/std/net/struct.UdpSocket.html#method.bind
 [`std::io::Error::new`]: https://doc.rust-lang.org/std/io/struct.Error.html#method.new
 [`std::io::Error::from_raw_os_error`]: https://doc.rust-lang.org/std/io/struct.Error.html#method.from_raw_os_error
 [`Box::new`]: https://doc.rust-lang.org/stable/std/boxed/struct.Box.html#method.new
-->
[`File::open`]: https://doc.rust-lang.org/stable/std/fs/struct.File.html#method.open
 [`Mmap::open`]: https://docs.rs/memmap/0.5.2/memmap/struct.Mmap.html#method.open
 [`Mmap::open_with_offset`]: https://docs.rs/memmap/0.5.2/memmap/struct.Mmap.html#method.open_with_offset
 [`TcpStream::connect`]: https://doc.rust-lang.org/stable/std/net/struct.TcpStream.html#method.connect
 [`UpdSocket::bind`]: https://doc.rust-lang.org/stable/std/net/struct.UdpSocket.html#method.bind
 [`std::io::Error::new`]: https://doc.rust-lang.org/std/io/struct.Error.html#method.new
 [`std::io::Error::from_raw_os_error`]: https://doc.rust-lang.org/std/io/struct.Error.html#method.from_raw_os_error
 [`Box::new`]: https://doc.rust-lang.org/stable/std/boxed/struct.Box.html#method.new


