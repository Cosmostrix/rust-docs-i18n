# <!--Interior Mutability--> インテリアミュータビリティ

<!--Sometimes a type needs be mutated while having multiple aliases.-->
複数のエイリアスを持つ一方で、タイプを変更する必要がある場合もあります。
<!--In Rust this is achieved using a pattern called  _interior mutability_ .-->
Rustでは、これは _interior mutability_ と呼ばれるパターンを使用して実現されます。
<!--A type has interior mutability if its internal state can be changed through a [shared reference] to it.-->
型は、その内部状態がその内部状態を[shared reference]によって変更できる場合、内部の変更可能性を持ちます。
<!--This goes against the usual [requirement][ub] that the value pointed to by a shared reference is not mutated.-->
これは、共有参照によって指定された値が変更されていないという通常の[requirement][ub]に反し[requirement][ub]。

[`std::cell::UnsafeCell `] RawInline (Format "html") "<t>" <!--[`std::cell::UnsafeCell `] type is the only allowed way in Rust to disable this requirement.-->
[`std::cell::UnsafeCell `] typeは、この要件を無効にするためにRustで許される唯一の方法です。
<!--When `UnsafeCell<T>` is immutably aliased, it is still safe to mutate, or obtain a mutable reference to, the `T` it contains.-->
`UnsafeCell<T>`がエイリアス化されていない場合、それに含まれる`T`を突然変異させたり、変更可能な参照を得ることはまだ安全です。
<!--As with all other types, it is undefined behavior to have multiple `&mut UnsafeCell<T>` aliases.-->
他のすべての型と同様に、複数の`&mut UnsafeCell<T>`エイリアスを持つことは未定義の動作です。

<!--Other types with interior mutability can be created by using `UnsafeCell<T>` as a field.-->
`UnsafeCell<T>`をフィールドとして使用すると、内部の変更可能な他の型を作成できます。
<!--The standard library provides a variety of types that provide safe interior mutability APIs.-->
標準ライブラリは、安全なインテリア可変APIを提供するさまざまなタイプを提供します。
<!--For example, [`std::cell::RefCell `]-->
たとえば、[`std::cell::RefCell `]
RawInline (Format "html") "<t>" <!--[`std::cell::RefCell `] uses run-time borrow checks to ensure the usual rules around multiple references.-->
[`std::cell::RefCell `]は、実行時の借用チェックを使用して、複数の参照に関する通常の規則を保証します。
<!--The [`std::sync::atomic`] module contains types that wrap a value that is only accessed with atomic operations, allowing the value to be shared and mutated across threads.-->
[`std::sync::atomic`]モジュールには、アトミック操作でしかアクセスされない値をラップする型が含まれており、スレッド間で値を共有して変更することができます。

<!--[shared reference]: types.html#shared-references-
 [ub]: behavior-considered-undefined.html
 [`std::mem::transmute`]: ../std/mem/fn.transmute.html
 [`std::cell::UnsafeCell<T>`]: ../std/cell/struct.UnsafeCell.html
 [`std::cell::RefCell<T>`]: ../std/cell/struct.RefCell.html
 [`std::sync::atomic`]: ../std/sync/atomic/index.html
-->
[shared reference]: types.html#shared-references-
 [ub]: behavior-considered-undefined.html
 [`std::mem::transmute`]: ../std/mem/fn.transmute.html
 [`std::cell::UnsafeCell<T>`]: ../std/cell/struct.UnsafeCell.html
 [`std::cell::RefCell<T>`]: ../std/cell/struct.RefCell.html
 [`std::sync::atomic`]: ../std/sync/atomic/index.html



