# <!--Special types and traits--> 特殊なタイプと特性

<!--Certain types and traits that exist in [the standard library] are known to the Rust compiler.-->
[the standard library]存在する特定の型および特性は、Rustコンパイラに知られています。
<!--This chapter documents the special features of these types and traits.-->
この章では、これらのタイプと特性の特殊な機能について説明します。

## `Box<T>`
[`Box `] RawInline (Format "html") "<t>" <!--[`Box `] has a few special features that Rust doesn't currently allow for user defined types.-->
[`Box `]は、Rustが現在ユーザー定義型を許可していないいくつかの特別な機能があります。

* <!--The [dereference operator] for `Box<T>` produces a place which can be moved from.-->
   `Box<T>`の[dereference operator]は、移動可能な場所を生成します。
<!--This means that the `*` operator and the destructor of `Box<T>` are built-in to the language.-->
   つまり、`*`演算子と`Box<T>`デストラクタは言語に組み込まれています。
* <!--[Methods] can take `Box<Self>` as a receiver.-->
   [Methods]は`Box<Self>`を受信者として受け取ることができます。
* <!--A trait may be implemented for `Box<T>` in the same crate as `T`, which the [orphan rules] prevent for other generic types.-->
   [orphan rules]が他の一般的な型を妨げる`T`と同じ箱内で`Box<T>`に対して形質を実装することができる。

## `UnsafeCell<T>`
[`std::cell::UnsafeCell `] RawInline (Format "html") "<t>" <!--[`std::cell::UnsafeCell `] is used for [interior mutability].-->
[`std::cell::UnsafeCell `]は[interior mutability]ために使われます。
<!--It ensures that the compiler doesn't perform optimisations that are incorrect for such types.-->
コンパイラは、そのような型に対して正しくない最適化を実行しないようにします。
<!--It also ensures that [`static` items] which have a type with interior mutability aren't placed in memory marked as read only.-->
また、内部の変更可能な型を持つ[`static` items]は、読み取り専用としてマークされたメモリに置かれないようにします。

## `PhantomData<T>`
[`std::marker::PhantomData `] RawInline (Format "html") "<t>" <!--[`std::marker::PhantomData `] is a zero-sized, minimum alignment, type that is considered to own a `T` for the purposes of [variance], [drop check] and [auto traits](#auto-traits).-->
[`std::marker::PhantomData `]は、ゼロサイズの最小整列型で、[variance]、 [drop check]、 [自動特性の](#auto-traits)ために`T`を所有するとみなされます。

## <!--Operator Traits--> オペレータの特性

<!--The traits in [`std::ops`] and [`std::cmp`] are used to overload [operators], [indexing expressions] and [call expressions].-->
[`std::ops`]と[`std::cmp`]は、[operators]オーバーロード、[indexing expressions]、および[call expressions]使用され[call expressions]。

## <!--`Deref` and `DerefMut`--> `Deref`と`DerefMut`

<!--As well as overloading the unary `*` operator, [`Deref`] and [`DerefMut`] are also used in [method resolution] and [deref coercions].-->
同様に単項オーバーロード`*`演算子を、[`Deref`]と[`DerefMut`]またで使用されている[method resolution]及び[deref coercions]。

## `Drop`
<!--The [`Drop`] trait provides a [destructor], to be run whenever a value of this type is to be destroyed.-->
[`Drop`]特性は、このタイプの値が[destructor]されるときはいつでも実行される[destructor]提供します。

## `Copy`
<!--The [`Copy`] trait changes the semantics of a type implementing it.-->
[`Copy`]特性は、それを実装する型のセマンティクスを変更します。
<!--Values whose type implements `Copy` are copied rather than moved upon assignment.-->
代入時に移動するのではなく、`Copy`を実装する型の値がコピーされます。
<!--`Copy` cannot be implemented for types which implement `Drop`, or which have fields that are not `Copy`.-->
`Drop`を実装する型、または`Copy`ではないフィールドを持つ型の`Copy`は実装できません。
<!--`Copy` is implemented by the compiler for-->
`Copy`はコンパイラによって実装されています

* [Numeric types]
* <!--`char`, `bool` and [`!`]-->
   `char`、 `bool`、 [`!`]
* <!--[Tuples] of `Copy` types-->
   `Copy`タイプの[Tuples]
* <!--[Arrays] of `Copy` types-->
   `Copy`タイプの[Arrays]
* [Shared references]
* [Raw pointers]
* <!--[Function pointers] and [function item types]-->
   [Function pointers]と[function item types]

## `Clone`
<!--The [`Clone`] trait is a supertrait of `Copy`, so it also needs compiler generated implementations.-->
[`Clone`]特性は`Copy`スーパー[`Clone`]あるため、コンパイラ生成の実装も必要です。
<!--It is implemented by the compiler for the following types:-->
これは、次のタイプのコンパイラによって実装されます。

* <!--Types with a built-in `Copy` implementation (see above)-->
   組み込みの`Copy`実装を持つ型（上記参照）
* <!--[Tuples] of `Clone` types-->
   `Clone`タイプの[Tuples]
* <!--[Arrays] of `Clone` types-->
   `Clone`タイプの[Arrays]

## `Send`
<!--The [`Send`] trait indicates that a value of this type is safe to send from one thread to another.-->
[`Send`]特性は、この型の値があるスレッドから別のスレッドに送信するのが安全であることを示します。

## `Sync`
<!--The [`Sync`] trait indicates that a value of this type is safe to share between multiple threads.-->
[`Sync`]特性は、この型の値が複数のスレッド間で共有するのが安全であることを示します。
<!--This trait must be implemented for all types used in immutable [`static` items].-->
この特性は、不変の[`static` items]使われるすべての型に対して実装されなければなりません。

## <!--Auto traits--> 自動特性

<!--The [`Send`], [`Sync`], [`UnwindSafe`] and [`RefUnwindSafe`] traits are  _auto traits_ .-->
[`Send`]、 [`Sync`]、 [`UnwindSafe`]、 [`RefUnwindSafe`]特徴は _自動特徴_ です。
<!--Auto traits have special properties.-->
自動特性には特殊な特性があります。

<!--If no explicit implementation or negative implementation is written out for an auto trait for a given type, then the compiler implements it automatically according to the following rules:-->
特定の型の自動特性に対して明示的な実装または否定的な実装が書き出されない場合、コンパイラは次の規則に従って自動的に実装します。

* <!--`&T`, `&mut T`, `*const T`, `*mut T`, `[T; n]`-->
   `&T`、 `&mut T`、 `*const T`、 `*mut T`、 `[T; n]`
<!--`[T; n]` and `[T]` implement the trait if `T` does.-->
   `[T; n]`と`[T]`は`T`がそうであればその特性を実装する。
* <!--Function item types and function pointers automatically implement the trait.-->
   機能項目タイプと機能ポインタは自動的に特性を実装します。
* <!--Structs, enums, unions and tuples implement the trait if all of their fields do.-->
   構造体、enum、union、およびtuplesは、すべてのフィールドがそうであれば、その特性を実装します。
* <!--Closures implement the trait if the types of all of their captures do.-->
   クロージャは、すべてのキャプチャのタイプがその特性を実装しています。
<!--A closure that captures a `T` by shared reference and a `U` by value implements any auto traits that both `&T` and `U` do.-->
   キャプチャ閉鎖`T`共有参照により`U`値では、両方の任意の自動形質実装`&T`と`U`行うが。

<!--For generic types (counting the built-in types above as generic over `T`), if an generic implementation is available, then the compiler does not automatically implement it for types that could use the implementation except that they do not meet the requisite trait bounds.-->
ジェネリック型（上記の組み込み型を`T`以上のジェネリックとして数える）では、ジェネリック実装が利用可能な場合、必要な特性境界を満たしていないことを除いて、実装を使用できる型に対して自動的に実装しません。
<!--For instance, the standard library implements `Send` for all `&T` where `T` is `Sync`;-->
例えば、標準ライブラリは`T`が`Sync`であるall `&T`ために`Send`を実装します;
<!--this means that the compiler will not implement `Send` for `&T` if `T` is `Send` but not `Sync`.-->
これは、`T`が`Send`、 `Sync`はない場合、コンパイラは`Send` for `&T`実装しないことを意味します。

<!--Auto traits can also have negative implementations, shown as `impl !AutoTrait for T` in the standard library documentation, that override the automatic implementations.-->
自動特性には、自動実装をオーバーライドする、標準ライブラリのドキュメントに`impl !AutoTrait for T`として示された負の実装もあります。
<!--For example `*mut T` has a negative implementation of `Send`, and so `*mut T` is not `Send`, even if `T` is.-->
例えば`*mut T`負の実装がある`Send`、そのため`*mut T`されていない`Send`場合でも、`T`あります。
<!--There is currently no stable way to specify additional negative implementations;-->
現在、追加のネガティブな実装を指定する安定した方法はありません。
<!--they exist only in the standard library.-->
標準ライブラリにのみ存在します。

<!--Auto traits may be added as an additional bound to any [trait object], even though normally only one trait is allowed.-->
通常は1つの形質のみが許可されているにもかかわらず、自動形質は、任意の[trait object]追加の結合として追加され得る。
<!--For instance, `Box<dyn Debug + Send + UnwindSafe>` is a valid type.-->
たとえば、`Box<dyn Debug + Send + UnwindSafe>`は有効な型です。

## `Sized`
<!--The [`Sized`] trait indicates that the size of this type is known at compile-time;-->
[`Sized`]特性は、コンパイル時にこの型のサイズが分かっていることを示します。
<!--that is, it's not a [dynamically sized type].-->
つまり、[dynamically sized type]はありません。
<!--[Type parameters] are `Sized` by default.-->
[Type parameters]はデフォルトで`Sized`が設定されます。
<!--`Sized` is always implemented automatically by the compiler, not by [implementation items].-->
`Sized`は、[implementation items]ではなくコンパイラによって常に自動的に[implementation items]さ[implementation items]。

<!--[`Box<T>`]: ../std/boxed/struct.Box.html
 [`Clone`]: ../std/clone/trait.Clone.html
 [`Copy`]: ../std/marker/trait.Copy.html
 [`Deref`]: ../std/ops/trait.Deref.html
 [`DerefMut`]: ../std/ops/trait.DerefMut.html
 [`Drop`]: ../std/ops/trait.Drop.html
 [`RefUnwindSafe`]: ../std/panic/trait.RefUnwindSafe.html
 [`Send`]: ../std/marker/trait.Send.html
 [`Sized`]: ../std/marker/trait.Sized.html
 [`std::cell::UnsafeCell<T>`]: ../std/cell/struct.UnsafeCell.html
 [`std::cmp`]: ../std/cmp/index.html
 [`std::marker::PhantomData<T>`]: ../std/marker/struct.PhantomData.html
 [`std::ops`]: ../std/ops/index.html
 [`UnwindSafe`]: ../std/panic/trait.UnwindSafe.html
 [`Sync`]: ../std/marker/trait.Sync.html
-->
[`Box<T>`]: ../std/boxed/struct.Box.html
 [`Clone`]: ../std/clone/trait.Clone.html
 [`Copy`]: ../std/marker/trait.Copy.html
 [`Deref`]: ../std/ops/trait.Deref.html
 [`DerefMut`]: ../std/ops/trait.DerefMut.html
 [`Drop`]: ../std/ops/trait.Drop.html
 [`RefUnwindSafe`]: ../std/panic/trait.RefUnwindSafe.html
 [`Send`]: ../std/marker/trait.Send.html
 [`Sized`]: ../std/marker/trait.Sized.html
 [`std::cell::UnsafeCell<T>`]: ../std/cell/struct.UnsafeCell.html
 [`std::cmp`]: ../std/cmp/index.html
 [`std::marker::PhantomData<T>`]: ../std/marker/struct.PhantomData.html
 [`std::ops`]: ../std/ops/index.html
 [`UnwindSafe`]: ../std/panic/trait.UnwindSafe.html
 [`Sync`]: ../std/marker/trait.Sync.html


<!--[Arrays]: types.html#array-and-slice-types
 [call expressions]: expressions/call-expr.html
 [deref coercions]: type-coercions.html#coercion-types
 [dereference operator]: expressions/operator-expr.html#the-dereference-operator
 [destructor]: destructors.html
 [drop check]: ../nomicon/dropck.html
 [dynamically sized type]: dynamically-sized-types.html
 [Function pointers]: types.html#function-pointer-types
 [function item types]: types.html#function-item-types
 [implementation items]: items/implementations.html
 [indexing expressions]: expressions/array-expr.html#array-and-slice-indexing-expressions
 [interior mutability]: interior-mutability.html
 [Numeric types]: types.html#numeric-types
 [Methods]: items/associated-items.html#associated-functions-and-methods
 [method resolution]: expressions/method-call-expr.html
 [operators]: expressions/operator-expr.html
 [orphan rules]: items/implementations.html#trait-implementation-coherence
 [Raw pointers]: types.html#raw-pointers-const-and-mut
 [`static` items]: items/static-items.html
 [Shared references]: types.html#shared-references-
 [the standard library]: ../std/index.html
 [trait object]: types.html#trait-objects
 [Tuples]: types.html#tuple-types
 [Type parameters]: types.html#type-parameters
 [variance]: subtyping.html#variance
 [`!`]: types.html#never-type
-->
[Arrays]: types.html#array-and-slice-types
 [call expressions]: expressions/call-expr.html
 [deref coercions]: type-coercions.html#coercion-types
 [dereference operator]: expressions/operator-expr.html#the-dereference-operator
 [destructor]: destructors.html
 [drop check]: ../nomicon/dropck.html
 [dynamically sized type]: dynamically-sized-types.html
 [Function pointers]: types.html#function-pointer-types
 [function item types]: types.html#function-item-types
 [implementation items]: items/implementations.html
 [indexing expressions]: expressions/array-expr.html#array-and-slice-indexing-expressions
 [interior mutability]: interior-mutability.html
 [Numeric types]: types.html#numeric-types
 [Methods]: items/associated-items.html#associated-functions-and-methods
 [method resolution]: expressions/method-call-expr.html
 [operators]: expressions/operator-expr.html
 [orphan rules]: items/implementations.html#trait-implementation-coherence
 [Raw pointers]: types.html#raw-pointers-const-and-mut
 [`static` items]: items/static-items.html
 [Shared references]: types.html#shared-references-
 [the standard library]: ../std/index.html
 [trait object]: types.html#trait-objects
 [Tuples]: types.html#tuple-types
 [Type parameters]: types.html#type-parameters
 [variance]: subtyping.html#variance
 [`!`]: types.html#never-type

