# <!--Alternative representations--> 代替表現

<!--Rust allows you to specify alternative data layout strategies from the default.-->
Rustでは、デフォルトから代替データレイアウト戦略を指定できます。




# <!--repr(C)--> repr（C）

<!--This is the most important `repr`.-->
これが最も重要である`repr`。
<!--It has fairly simple intent: do what C does.-->
それはかなり単純な意図を持っています：Cがすることをします。
<!--The order, size, and alignment of fields is exactly what you would expect from C or C++.-->
フィールドの順序、サイズ、および配置は、CまたはC ++から期待されるものとまったく同じです。
<!--Any type you expect to pass through an FFI boundary should have `repr(C)`, as C is the lingua-franca of the programming world.-->
FFI境界を通過すると予想されるすべてのタイプは、Cがプログラミング世界の言語独語であるため、`repr(C)`持つ必要があります。
<!--This is also necessary to soundly do more elaborate tricks with data layout such as reinterpreting values as a different type.-->
これは、値を別のタイプとして再解釈するなど、データレイアウトでもっと精巧なやり方をするためにも必要です。

<!--However, the interaction with Rust's more exotic data layout features must be kept in mind.-->
しかし、Rustのよりエキゾチックなデータレイアウト機能との相互作用を念頭に置く必要があります。
<!--Due to its dual purpose as "for FFI"and "for layout control", `repr(C)` can be applied to types that will be nonsensical or problematic if passed through the FFI boundary.-->
"FFI"と "レイアウト制御"の2つの目的のために、`repr(C)`は、FFI境界を通過すると無意味な、または問題のある型に適用できます。

* <!--ZSTs are still zero-sized, even though this is not a standard behavior in-->
   これは標準的な動作ではありませんが、ZSTはまだゼロサイズです。
<!--C, and is explicitly contrary to the behavior of an empty type in C++, which still consumes a byte of space.-->
Cであり、C ++の空の型の動作に明示的に反しています。これはまだ1バイトの空き領域を消費します。

* <!--DST pointers (fat pointers), tuples, and enums with fields are not a concept in C, and as such are never FFI-safe.-->
   フィールドを持つDSTポインタ（タイルポインタ）、タプル、および列挙型はCの概念ではないため、決してFFIセーフではありません。

* <!--If `T` is an [FFI-safe non-nullable pointer type](ffi.html#the-nullable-pointer-optimization), `Option<T>` is guaranteed to have the same layout and ABI as `T` and is therefore also FFI-safe.-->
   `T`が[FFIで安全な非null型ポインタ型である](ffi.html#the-nullable-pointer-optimization)場合、`Option<T>`は`T`と同じレイアウトとABIを持つことが保証され、したがってFFIセーフでもあります。
<!--As of this writing, this covers `&`, `&mut`, and function pointers, all of which can never be null.-->
   この記事の執筆時点では、これは`&`、 `&mut`、および関数ポインタを対象としています。

* <!--Tuple structs are like structs with regards to `repr(C)`, as the only difference from a struct is that the fields aren't named.-->
   構造体との唯一の違いは、フィールドの名前が付けられていないということであるから、Tuple構造体は`repr(C)`に関するstructと似ています。

* <!--This is equivalent to one of `repr(u*)` (see the next section) for enums.-->
   これはenumの`repr(u*)`（次のセクションを参照`repr(u*)` 1つに相当します。
<!--The-->
   ザ
<!--chosen size is the default enum size for the target platform's C application binary interface (ABI).-->
選択されたサイズは、ターゲットプラットフォームのCアプリケーションバイナリインタフェース（ABI）のデフォルトの列挙型サイズです。
<!--Note that enum representation in C is implementation defined, so this is really a "best guess".-->
Cの列挙表現は実装定義であることに注意してください。これは実際には「最良の推測」です。
<!--In particular, this may be incorrect when the C code of interest is compiled with certain flags.-->
特に、関心のあるCコードが特定のフラグでコンパイルされていると、これは正しくない可能性があります。

* <!--Field-less enums with `repr(C)` or `repr(u*)` still may not be set to an-->
   `repr(C)`または`repr(u*)`持つフィールドレスのenumは、まだ
<!--integer value without a corresponding variant, even though this is permitted behavior in C or C++.-->
たとえこれがCまたはC ++で許可された動作であっても、対応するバリアントのない整数値です。
<!--It is undefined behavior to (unsafely) construct an instance of an enum that does not match one of its variants.-->
そのバリエーションの1つと一致しないenumのインスタンスを（不安全に）構築するのは未定義の動作です。
<!--(This allows exhaustive matches to continue to be written and compiled as normal.)-->
（これにより、徹底的なマッチが引き続き作成され、通常通りコンパイルされます。）



# <!--repr(u *), repr(i*)--> repr（u *）、repr（i*）

<!--These specify the size to make a field-less enum.-->
これらは、フィールドレスの列挙型を作成するためのサイズを指定します。
<!--If the discriminant overflows the integer it has to fit in, it will produce a compile-time error.-->
判別式が整数にオーバーフローした場合、それは適合する必要があります。コンパイル時にエラーが発生します。
<!--You can manually ask Rust to allow this by setting the overflowing element to explicitly be 0. However Rust will not allow you to create an enum where two variants have the same discriminant.-->
オーバーフローする要素を明示的に0に設定することで、Rustに手動で問い合わせることができます。ただし、Rustでは、2つのバリアントが同じ判別式を持つ列挙型を作成することはできません。

<!--The term "field-less enum"only means that the enum doesn't have data in any of its variants.-->
「フィールドレスの列挙型」という用語は、その列挙型がそのバリ​​アントのいずれにもデータを持たないことを意味します。
<!--A field-less enum without a `repr(u*)` or `repr(C)` is still a Rust native type, and does not have a stable ABI representation.-->
`repr(u*)`または`repr(C)`ないフィールドレスの列挙型は、まだRustのネイティブ型であり、安定したABI表現を持っていません。
<!--Adding a `repr` causes it to be treated exactly like the specified integer size for ABI purposes.-->
`repr`を追加すると、ABIの目的で指定された整数サイズとまったく同じように扱われます。

<!--Any enum with fields is a Rust type with no guaranteed ABI (even if the only data is `PhantomData` or something else with zero size).-->
フィールドを持つ列挙型は、（たとえ唯一のデータが`PhantomData`か、サイズがゼロのものであっても）ABIを保証しないRust型です。

<!--Adding an explicit `repr` to an enum suppresses the null-pointer optimization.-->
enumに明示的な`repr`を追加すると、NULLポインタの最適化が抑制されます。

<!--These reprs have no effect on a struct.-->
これらのreprsは構造体に影響を与えません。




# <!--repr(packed)--> repr（パック）

<!--`repr(packed)` forces Rust to strip any padding, and only align the type to a byte.-->
`repr(packed)`は、Rustにパディングを取り除き、その型を1バイトに整列させるだけです。
<!--This may improve the memory footprint, but will likely have other negative side-effects.-->
これは、メモリフットプリントを改善する可能性がありますが、おそらく他の負の副作用があります。

<!--In particular, most architectures *strongly* prefer values to be aligned.-->
特に、ほとんどのアーキテクチャで*は*、値を並べることを*強く*推奨しています。
<!--This may mean the unaligned loads are penalized (x86), or even fault (some ARM chips).-->
これは、アライメントされていない負荷がペナルティ（x86）、または障害（ARMチップの一部）さえある可能性があります。
<!--For simple cases like directly loading or storing a packed field, the compiler might be able to paper over alignment issues with shifts and masks.-->
パックされたフィールドを直接ロードまたは格納するような単純なケースでは、コンパイラはシフトとマスクのアライメントの問題を記録できます。
<!--However if you take a reference to a packed field, it's unlikely that the compiler will be able to emit code to avoid an unaligned load.-->
しかし、パックされたフィールドへの参照を取ると、コンパイル時に非境界整列のロードを回避するためのコードを生成することはできません。

<!--**[As of Rust 1.0 this can cause undefined behavior.][ub loads]**-->
**[Rust 1.0以降、これは未定義の動作を引き起こす可能性があります。] [ub loads]**

<!--`repr(packed)` is not to be used lightly.-->
`repr(packed)`は軽く使用しないでください。
<!--Unless you have extreme requirements, this should not be used.-->
極端な要件がない限り、これは使用すべきではありません。

<!--This repr is a modifier on `repr(C)` and `repr(rust)`.-->
このreprは`repr(C)`と`repr(rust)`修飾語です。

<!--[drop flags]: drop-flags.html
 [ub loads]: https://github.com/rust-lang/rust/issues/27060
-->
[drop flags]: drop-flags.html
 [ub loads]: https://github.com/rust-lang/rust/issues/27060

