# <!--Type coercions--> 型変換

<!--Coercions are defined in [RFC 401].-->
強制は[RFC 401]定義されてい[RFC 401]。
<!--[RFC 1558] then expanded on that.-->
[RFC 1558]、それを拡張しました。
<!--A coercion is implicit and has no syntax.-->
強制は暗黙であり、構文はありません。

<!--[RFC 401]: https://github.com/rust-lang/rfcs/blob/master/text/0401-coercions.md
 [RFC 1558]: https://github.com/rust-lang/rfcs/blob/master/text/1558-closure-to-fn-coercion.md
-->
[RFC 401]: https://github.com/rust-lang/rfcs/blob/master/text/0401-coercions.md
 [RFC 1558]: https://github.com/rust-lang/rfcs/blob/master/text/1558-closure-to-fn-coercion.md


## <!--Coercion sites--> 強制的なサイト

<!--A coercion can only occur at certain coercion sites in a program;-->
強制は、プログラム内の特定の強制的なサイトでのみ発生する可能性があります。
<!--these are typically places where the desired type is explicit or can be derived by propagation from explicit types (without type inference).-->
これらは典型的には、所望の型が明示的であるか、明示型（型推論なし）からの伝播によって派生することができる場所である。
<!--Possible coercion sites are:-->
可能性のある強制的なサイトは次のとおりです。

* <!--`let` statements where an explicit type is given.-->
   明示的な型が与えられている文を`let`ます。

<!--For example, `42` is coerced to have type `i8` in the following:-->
たとえば、`42`は次のようにタイプ`i8`を持つように強制されます。

<!--` ``rust let _: i8 = 42;``-->
` ``rust let _: i8 = 42;``
<!--`-->
`

* <!--`static` and `const` statements (similar to `let` statements).-->
   `static`文と`const`文（`let`文に似ています）。

* <!--Arguments for function calls-->
   関数呼び出しの引数

<!--The value being coerced is the actual parameter, and it is coerced to the type of the formal parameter.-->
強制される値は実際のパラメータであり、仮パラメータの型に変換されます。

<!--For example, `42` is coerced to have type `i8` in the following:-->
たとえば、`42`は次のようにタイプ`i8`を持つように強制されます。

<!--` ``rust fn bar(_: i8) { } fn main() { bar(42); }``-->
` ``rust fn bar(_: i8) { } fn main() { bar(42); }``
<!--``rust fn bar(_: i8) { } fn main() { bar(42); }`` `-->
``rust fn bar(_: i8) { } fn main() { bar(42); }`` `

<!--For method calls, the receiver (`self` parameter) can only take advantage of [unsized coercions](#unsized-coercions).-->
メソッド呼び出しの場合、受信側（`self`パラメータ）は[unsized型変換](#unsized-coercions)のみを利用できます。

* <!--Instantiations of struct or variant fields-->
   structまたはvariantフィールドのインスタンス化

<!--For example, `42` is coerced to have type `i8` in the following:-->
たとえば、`42`は次のようにタイプ`i8`を持つように強制されます。

<!--` ``rust struct Foo { x: i8 } fn main() { Foo { x: 42 }; }``-->
` ``rust struct Foo { x: i8 } fn main() { Foo { x: 42 }; }``
<!--``rust struct Foo { x: i8 } fn main() { Foo { x: 42 }; }`` `-->
``rust struct Foo { x: i8 } fn main() { Foo { x: 42 }; }`` `

* <!--Function results, either the final line of a block if it is not semicolon-terminated or any expression in a `return` statement-->
   関数の結果。セミコロンで終了していないブロックの最終行または`return`文の式のいずれか

<!--For example, `42` is coerced to have type `i8` in the following:-->
たとえば、`42`は次のようにタイプ`i8`を持つように強制されます。

<!--` ``rust fn foo() -> i8 { 42 }`` `-->
` ``rust fn foo() -> i8 { 42 }`` `

<!--If the expression in one of these coercion sites is a coercion-propagating expression, then the relevant sub-expressions in that expression are also coercion sites.-->
これらの強制変換サイトの1つの式が強制変換式である場合、その式の関連するサブ式も強制変換サイトです。
<!--Propagation recurses from these new coercion sites.-->
伝播は、これらの新しい強制的なサイトから繰り返されます。
<!--Propagating expressions and their relevant sub-expressions are:-->
式とその関連するサブ式の伝播は次のとおりです。

* <!--Array literals, where the array has type `[U; n]`-->
   配列リテラル`[U; n]`配列の型は`[U; n]`
<!--`[U; n]`.-->
   `[U; n]`。
<!--Each sub-expression in-->
   各サブ式は
<!--the array literal is a coercion site for coercion to type `U`.-->
配列リテラルは型`U`への強制変換の強制サイトです。

* <!--Array literals with repeating syntax, where the array has type `[U; n]`-->
   繰り返しの構文を持つ配列リテラル`[U; n]`配列の型は`[U; n]`
<!--`[U; n]`.-->
   `[U; n]`。
<!--The-->
   ザ
<!--repeated sub-expression is a coercion site for coercion to type `U`.-->
反復された部分式は、`U`型への強制変換のための強制変換サイトです。

* <!--Tuples, where a tuple is a coercion site to type `(U_0, U_1, ..., U_n)`.-->
   タプルは、タプルがタイプする強制サイトです`(U_0, U_1, ..., U_n)`。
<!--Each sub-expression is a coercion site to the respective type, eg the zeroth sub-expression is a coercion site to type `U_0`.-->
各部分式は、それぞれの型への強制的なサイトです。たとえば、0番目の部分式は、`U_0`と入力する強制サイト`U_0`。

* <!--Parenthesized sub-expressions (`(e)`): if the expression has type `U`, then-->
   括弧で囲まれた部分式（`(e)`）：式が`U`型の場合、
<!--the sub-expression is a coercion site to `U`.-->
サブ式は`U`への強制的なサイトです。

* <!--Blocks: if a block has type `U`, then the last expression in the block (if-->
   ブロック：ブロックにタイプ`U`がある場合、ブロックの最後の式（if
<!--it is not semicolon-terminated) is a coercion site to `U`.-->
それはセミコロンで終わらない）は`U`への強制的なサイトです。
<!--This includes blocks which are part of control flow statements, such as `if` / `else`, if the block has a known type.-->
これには、ブロックが既知の型を持つかどう`if`など、`if` / `else`などの制御フロー文の一部であるブロックが含まれます。

## <!--Coercion types--> 強制型

<!--Coercion is allowed between the following types:-->
以下のタイプの間で強制が許されます：

* <!--`T` to `U` if `T` is a subtype of `U` (*reflexive case*)-->
   `T`が`U`のサブタイプであれば`T`から`U`（ *反射的ケース*）

* <!--`T_1` to `T_3` where `T_1` coerces to `T_2` and `T_2` coerces to `T_3`-->
   `T_1`へ`T_3` `T_1`に強制変換`T_2`と`T_2`に強制し`T_3`
<!--(*transitive case*)-->
（*推移的なケース*）

<!--Note that this is not fully supported yet-->
これは完全にサポートされていないことに注意してください

* <!--`&mut T` to `&T`-->
   `&mut T`から`&T`への`&mut T`

* <!--`*mut T` to `*const T`-->
   `*mut T`から`*const T`

* <!--`&T` to `*const T`-->
   `&T`から`*const T`

* <!--`&mut T` to `*mut T`-->
   `&mut T`から`*mut T`

* <!--`&T` or `&mut T` to `&U` if `T` implements `Deref<Target = U>`.-->
   `&T`または`&mut T`に`&U`場合は`T`実装`Deref<Target = U>`。
<!--For example:-->
   例えば：

<!--` ``rust use std::ops::Deref; struct CharContainer { value: char, } impl Deref for CharContainer { type Target = char; fn deref<'a>(&'a self) -> &'a char { &self.value } } fn foo(arg: &char) {} fn main() { let x = &mut CharContainer { value: 'y' }; foo(x); //&mut CharContainer is coerced to &char. }``-->
` ``rust use std::ops::Deref; struct CharContainer { value: char, } impl Deref for CharContainer { type Target = char; fn deref<'a>(&'a self) -> &'a char { &self.value } } fn foo(arg: &char) {} fn main() { let x = &mut CharContainer { value: 'y' }; foo(x); //&mut CharContainer is coerced to &char. }``
``rust use std::ops::Deref; struct CharContainer { value: char, } impl Deref for CharContainer { type Target = char; fn deref<'a>(&'a self) -> &'a char { &self.value } } fn foo(arg: &char) {} fn main() { let x = &mut CharContainer { value: 'y' }; foo(x); //&mut CharContainer is coerced to &char. }`` <!--``rust use std::ops::Deref; struct CharContainer { value: char, } impl Deref for CharContainer { type Target = char; fn deref<'a>(&'a self) -> &'a char { &self.value } } fn foo(arg: &char) {} fn main() { let x = &mut CharContainer { value: 'y' }; foo(x); //&mut CharContainer is coerced to &char. }`` `-->
``rust use std::ops::Deref; struct CharContainer { value: char, } impl Deref for CharContainer { type Target = char; fn deref<'a>(&'a self) -> &'a char { &self.value } } fn foo(arg: &char) {} fn main() { let x = &mut CharContainer { value: 'y' }; foo(x); //&mut CharContainer is coerced to &char. }`` `

* <!--`&mut T` to `&mut U` if `T` implements `DerefMut<Target = U>`.-->
   `&mut T`する`&mut U`場合は`T`実装`DerefMut<Target = U>`。

* <!--TyCtor(`T`) to TyCtor(`U`), where TyCtor(`T`) is one of-->
   TyCtor（`T`）をTyCtor（ `U`）に変換する。ここで、TyCtor（ `T`）は
    - `&T`
    - `&mut T`
    - `*const T`
    - `*mut T`
    - `Box<T>`

<!--and where `T` can obtained from `U` by [unsized coercion](#unsized-coercions).-->
ここで、`T`は[小文字の強制](#unsized-coercions)によって`U`から得られる。

<!--In the future, coerce_inner will be recursively extended to tuples and
    structs. In addition, coercions from sub-traits to super-traits will be
    added. See [RFC 401] for more details.-->

* <!--Non capturing closures to `fn` pointers-->
   `fn`ポインタへの非キャプチャクロージャ

* <!--`!` to any `T`-->
   `!`から任意の`T`

### <!--Unsized Coercions--> サイズのない強制

<!--The following coercions are called `unsized coercions`, since they relate to converting sized types to unsized types, and are permitted in a few cases where other coercions are not, as described above.-->
以下の型変換が呼び出される`unsized coercions`それらは無サイズの型にサイズタイプの変換に関係するので、上述したように、他の強制はされないいくつかのケースで許可されています。
<!--They can still happen anywhere else a coercion can occur.-->
彼らは強制的に起こりうる他のどこでも起こり得る。

<!--Two traits, [`Unsize`] and [`CoerceUnsized`], are used to assist in this process and expose it for library use.-->
二つの特性、[`Unsize`]と[`CoerceUnsized`]、このプロセスを支援し、ライブラリを使用する際に、それを公開するために使用されています。
<!--The compiler following coercions are built-in and, if `T` can be coerced to `U` with one of the, then the compiler will provide an implementation of `Unsize<U>` for `T`:-->
変換後のコンパイラが組み込まれていて、`T`を`U` 1つで強制的に`U`変換できる場合、コンパイラは`Unsize<U>`の`T`実装を提供します。

* `[T; n]` <!--`[T; n]` to `[T]`.-->
   `[T; n]`を`[T]`。

* <!--`T` to `U`, when `U` is a trait object type and either `T` implements `U` or `T` is a trait object for a subtrait of `U`.-->
   `T`から`U`まで、`U`が形質オブジェクトタイプであり、`T`が`U`または`T`実装する場合は、`U`サブトラクトの形質オブジェクトである。

* <!--`Foo<..., T, ...>` to `Foo<..., U, ...>`, when:-->
   `Foo<..., T, ...>`を`Foo<..., U, ...>`、
    * <!--`Foo` is a struct.-->
       `Foo`は構造体です。
    * <!--`T` implements `Unsize<U>`.-->
       `T`は`Unsize<U>`実装します。
    * <!--The last field of `Foo` has a type involving `T`.-->
       `Foo`の最後のフィールドには`T`含む型があります。
    * <!--If that field has type `Bar<T>`, then `Bar<T>` implements `Unsized<Bar<U>>`.-->
       そのフィールドが`Bar<T>`型の場合、`Bar<T>`は`Unsized<Bar<U>>` `Bar<T>`実装し`Unsized<Bar<U>>`。
    * <!--T is not part of the type of any other fields.-->
       Tは、他のフィールドの型の一部ではありません。

<!--Additionally, a type `Foo<T>` can implement `CoerceUnsized<Foo<U>>` when `T` implements `Unsize<U>` or `CoerceUnsized<Foo<U>>`.-->
また、タイプ`Foo<T>`を実装することができる`CoerceUnsized<Foo<U>>`とき`T`実装`Unsize<U>`または`CoerceUnsized<Foo<U>>`。
<!--This allows it to provide a unsized coercion to `Foo<U>`.-->
これにより、`Foo<U>`サイズの小さい強制を提供することができます。

> <!--Note: While the definition of the unsized coercions and their implementation has been stabilized, the traits themselves are not yet stable and therefore can't be used directly in stable Rust.-->
> 注：サイズの定められていない強制とその実装の定義は安定しているが、特性自体はまだ安定していないため、安定したRustでは直接使用することはできない。

<!--[Unsize]: ../std/marker/trait.Unsize.html
 [CoerceUnsized]: ../std/ops/trait.CoerceUnsized.html
-->
[Unsize]: ../std/marker/trait.Unsize.html
 [CoerceUnsized]: ../std/ops/trait.CoerceUnsized.html

