# <!--Destructors--> デストラクタ

<!--When an [initialized] &#32;-->
[initialized] ＆＃32;
<!--[variable] in Rust goes out of scope or a [temporary] is no longer needed its  _destructor_  is run.-->
Rustの[variable]が有効範囲外になるか、[temporary]が不要になり、その _デストラクタ_ が実行されます。
<!--[Assignment] also runs the destructor of its left-hand operand, unless it's an uninitialized variable.-->
[Assignment]は、未初期化変数でない限り、左辺オペランドのデストラクタも実行します。
<!--If a [struct] variable has been partially initialized, only its initialized fields are dropped.-->
[struct]変数が部分的に初期化されている場合、初期化されたフィールドのみが削除されます。

<!--The destructor of a type consists of-->
型のデストラクタは

1. <!--Calling its [`std::ops::Drop::drop`] method, if it has one.-->
    [`std::ops::Drop::drop`]メソッドがあればそれを[`std::ops::Drop::drop`]ます。
2. <!--Recursively running the destructor of all of its fields.-->
    すべてのフィールドのデストラクタを再帰的に実行します。
    * <!--The fields of a [struct], [tuple] or [enum variant] are dropped in declaration order.-->
       [struct]、 [tuple]または[enum variant]のフィールドは、宣言の順番で削除されます。
<!--\-->
       \
SoftBreak**SoftBreak<!--The elements of an [array] or owned [slice][array] are dropped from the first element to the last.-->
       [array]または所有[slice][array]の要素は、最初の要素から最後の要素にドロップされます。
<!--\-->
       \
SoftBreak**SoftBreak<!--The captured values of a [closure] are dropped in an unspecified order.-->
       [closure]のキャプチャされた値は、不特定の順序で削除されます。
    * <!--[Trait objects] run the destructor of the underlying type.-->
       [Trait objects]は、基になる型のデストラクタを実行し[Trait objects]。
    * <!--Other types don't result in any further drops.-->
       他のタイプはそれ以上の低下をもたらさない。

<!--\* This order was stabilized in [RFC 1857].-->
\ *この順序は[RFC 1857]安定してい[RFC 1857]。

<!--Variables are dropped in reverse order of declaration.-->
変数は宣言の逆の順序で削除されます。
<!--Variables declared in the same pattern drop in an unspecified ordered.-->
同じパターンで宣言された変数は、不特定の順序で削除されます。

<!--If a destructor must be run manually, such as when implementing your own smart pointer, [`std::ptr::drop_in_place`] can be used.-->
独自のスマートポインタを実装する場合など、デストラクターを手動で実行する必要がある場合は、[`std::ptr::drop_in_place`]を使用できます。

<!--Some examples:-->
いくつかの例：

```rust
struct ShowOnDrop(&'static str);

impl Drop for ShowOnDrop {
    fn drop(&mut self) {
        println!("{}", self.0);
    }
}

{
    let mut overwritten = ShowOnDrop("Drops when overwritten");
    overwritten = ShowOnDrop("drops when scope ends");
}
# println!("");
{
    let declared_first = ShowOnDrop("Dropped last");
    let declared_last = ShowOnDrop("Dropped first");
}
# println!("");
{
#    // Tuple elements drop in forwards order
    // タプル要素が転送順に削除される
    let tuple = (ShowOnDrop("Tuple first"), ShowOnDrop("Tuple second"));
}
# println!("");
loop {
#    // Tuple expression doesn't finish evaluating so temporaries drop in reverse order:
    // タプルの式が評価を終了しないため、一時的な逆順でドロップする：
    let partial_tuple = (ShowOnDrop("Temp first"), ShowOnDrop("Temp second"), break);
}
# println!("");
{
    let moved;
#    // No destructor run on assignment.
    // 割り当て時にデストラクタを実行しません。
    moved = ShowOnDrop("Drops when moved");
#    // drops now, but is then uninitialized
    // 今すぐ落ちますが、初期化されません
    moved;
    let uninitialized: ShowOnDrop;
#    // Only first element drops
    // 最初の要素のみが落ちる
    let mut partially_initialized: (ShowOnDrop, ShowOnDrop);
    partially_initialized.0 = ShowOnDrop("Partial tuple first");
}
```

## <!--Not running destructors--> デストラクタを実行していない

<!--Not running destructors in Rust is safe even if it has a type that isn't `'static`.-->
Rustでデストラクタを実行していない`'static`は、たとえ型が`'static`でなくても安全です。
<!--[`std::mem::ManuallyDrop`] provides a wrapper to prevent a variable or field from being dropped automatically.-->
[`std::mem::ManuallyDrop`]は、変数やフィールドが自動的に削除されないようにするためのラッパーを提供します。

<!--[initialized]: glossary.html#initialized
 [variable]: variables.html
 [temporary]: expressions.html#temporary-lifetimes
 [Assignment]: expressions/operator-expr.html#assignment-expressions
 [`std::ops::Drop::drop`]: ../std/ops/trait.Drop.html
 [RFC 1857]: https://github.com/rust-lang/rfcs/blob/master/text/1857-stabilize-drop-order.md
 [struct]: types.html#struct-types
 [tuple]: types.html#tuple-types
 [enum variant]: types.html#enumerated-types
 [array]: types.html#array-and-slice-types
 [closure]: types.html#closure-types
 [Trait objects]: types.html#trait-objects
 [`std::ptr::drop_in_place`]: ../std/ptr/fn.drop_in_place.html
 [`std::mem::forget`]: ../std/mem/fn.forget.html
 [`std::mem::ManuallyDrop`]: ../std/mem/struct.ManuallyDrop.html
-->
[initialized]: glossary.html#initialized
 [variable]: variables.html
 [temporary]: expressions.html#temporary-lifetimes
 [Assignment]: expressions/operator-expr.html#assignment-expressions
 [`std::ops::Drop::drop`]: ../std/ops/trait.Drop.html
 [RFC 1857]: https://github.com/rust-lang/rfcs/blob/master/text/1857-stabilize-drop-order.md
 [struct]: types.html#struct-types
 [tuple]: types.html#tuple-types
 [enum variant]: types.html#enumerated-types
 [array]: types.html#array-and-slice-types
 [closure]: types.html#closure-types
 [Trait objects]: types.html#trait-objects
 [`std::ptr::drop_in_place`]: ../std/ptr/fn.drop_in_place.html
 [`std::mem::forget`]: ../std/mem/fn.forget.html
 [`std::mem::ManuallyDrop`]: ../std/mem/struct.ManuallyDrop.html

