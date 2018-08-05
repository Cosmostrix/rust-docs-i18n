# <!--Unsafety--> 不安定

<!--Unsafe operations are those that potentially violate the memory-safety guarantees of Rust's static semantics.-->
安全でない操作とは、Rustの静的セマンティクスのメモリ安全の保証に違反する可能性のある操作です。

<!--The following language level features cannot be used in the safe subset of Rust:-->
以下の言語レベルの機能は、Rustの安全なサブセットでは使用できません。

- <!--Dereferencing a [raw pointer](types.html#pointer-types).-->
   [未処理のポインタを](types.html#pointer-types)参照解除し[ます](types.html#pointer-types)。
- <!--Reading or writing a [mutable static variable](items/static-items.html#mutable-statics).-->
   [可変静的変数を](items/static-items.html#mutable-statics)読み書きする。
- <!--Reading a field of a [`union`](items/unions.html), or writing to a field of a union that isn't [`Copy`](special-types-and-traits.html#copy).-->
   [`union`](items/unions.html)フィールドを[`union`](items/unions.html)、または[`Copy`](special-types-and-traits.html#copy)ではないユニオンのフィールドに書き込む。
- <!--Calling an unsafe function (including an intrinsic or foreign function).-->
   安全でない関数（固有関数または外部関数を含む）を呼び出します。
- <!--Implementing an unsafe trait.-->
   安全でない特性を実装する。
