# <!--Coercions--> 強制

<!--Types can implicitly be coerced to change in certain contexts.-->
型は、暗黙のうちに特定のコンテキストで変更するように強制できます。
<!--These changes are generally just *weakening* of types, largely focused around pointers and lifetimes.-->
これらの変更は、一般的にポインタの種類やライフタイムに焦点を当てたタイプの*弱さ*です。
<!--They mostly exist to make Rust "just work"in more cases, and are largely harmless.-->
彼らはほとんどの場合、Rustを "ちょうど仕事"にするために存在し、ほとんど無害です。

<!--Here's all the kinds of coercion:-->
ここにはすべての種類の強制があります：

<!--Coercion is allowed between the following types:-->
以下のタイプの間で強制が許されます：

* <!--Transitivity: `T_1` to `T_3` where `T_1` coerces to `T_2` and `T_2` coerces to `T_3`-->
   推移性： `T_1`へ`T_3` `T_1`に強制変換`T_2`と`T_2`に強制し`T_3`
* <!--Pointer Weakening:-->
   ポインタの弱化：
    * <!--`&mut T` to `&T`-->
       `&mut T`から`&T`への`&mut T`
    * <!--`*mut T` to `*const T`-->
       `*mut T`から`*const T`
    * <!--`&T` to `*const T`-->
       `&T`から`*const T`
    * <!--`&mut T` to `*mut T`-->
       `&mut T`から`*mut T`
* <!--Unsizing: `T` to `U` if `T` implements `CoerceUnsized<U>`-->
   Unsizing： `T`へ`U`あれば`T`実装`CoerceUnsized<U>`
* <!--Deref coercion: Expression `&x` of type `&T` to `&*x` of type `&U` if `T` derefs to `U` (ie `T: Deref<Target=U>`)-->
   DEREF強制：式`&x`タイプの`&T`する`&*x`タイプの`&U`の場合`T`へderefs `U`（すなわち`T: Deref<Target=U>`

<!--`CoerceUnsized<Pointer<U>> for Pointer<T> where T: Unsize<U>` is implemented for all pointer types (including smart pointers like Box and Rc).-->
`CoerceUnsized<Pointer<U>> for Pointer<T> where T: Unsize<U>`は、すべてのポインタ型（BoxやRcのようなスマートポインタを含む）に対して実装されています。
<!--Unsize is only implemented automatically, and enables the following transformations:-->
サイズの変更は自動的にのみ実装され、次の変換が有効になります。

* `[T; n]` <!--`[T; n]` => `[T]`-->
   `[T; n]` => `[T]`
* <!--`T` => `Trait` where `T: Trait`-->
   `T` => `Trait`ここで、`T: Trait`
* <!--`Foo<..., T, ...>` => `Foo<..., U, ...>` where:-->
   `Foo<..., T, ...>` => `Foo<..., U, ...>`ここで、
    * `T: Unsize<U>`
    * <!--`Foo` is a struct-->
       `Foo`は構造体です
    * <!--Only the last field of `Foo` has type involving `T`-->
       `Foo`の最後のフィールドだけが`T`
    * <!--`T` is not part of the type of any other fields-->
       `T`は他のフィールドの型の一部ではありません
    * <!--`Bar<T>: Unsize<Bar<U>>`, if the last field of `Foo` has type `Bar<T>`-->
       `Bar<T>: Unsize<Bar<U>>` `Foo`の最後のフィールドが`Bar<T>`型の場合、

<!--Coercions occur at a *coercion site*.-->
強制は*強要現場で行われる*。
<!--Any location that is explicitly typed will cause a coercion to its type.-->
明示的に型指定された場所は、その型へ強制変換されます。
<!--If inference is necessary, the coercion will not be performed.-->
推論が必要な場合、強制は実行されません。
<!--Exhaustively, the coercion sites for an expression `e` to type `U` are:-->
徹底的に言えば、式`e`が`U`型に変換された強制変換サイトは次のとおりです。

* <!--let statements, statics, and consts: `let x: U = e`-->
   let文、statics、constを`let x: U = e`
* <!--Arguments to functions: `takes_a_U(e)`-->
   関数への引数： `takes_a_U(e)`
* <!--Any expression that will be returned: `fn foo() -> U { e }`-->
   返される式： `fn foo() -> U { e }`
* <!--Struct literals: `Foo { some_u: e }`-->
   構造体リテラル： `Foo { some_u: e }`
* <!--Array literals: `let x: [U; 10] = [e, ..]`-->
   配列リテラル： `let x: [U; 10] = [e, ..]`
`let x: [U; 10] = [e, ..]`
* <!--Tuple literals: `let x: (U, ..) = (e, ..)`-->
   タプルリテラル： `let x: (U, ..) = (e, ..)`
* <!--The last expression in a block: `let x: U = { ..; e }`-->
   ブロック内の最後の式： `let x: U = { ..; e }`
`let x: U = { ..; e }`

<!--Note that we do not perform coercions when matching traits (except for receivers, see below).-->
特性をマッチングするときに強制的に変換を実行しないことに注意してください（レシーバを除く、以下を参照）。
<!--If there is an impl for some type `U` and `T` coerces to `U`, that does not constitute an implementation for `T`.-->
いくつかのタイプのIMPLがある場合に`U`及び`T`に強制変換`U`、それがの実装構成しない`T`。
<!--For example, the following will not type check, even though it is OK to coerce `t` to `&T` and there is an impl for `&T`:-->
たとえば、次の例は、強制するOKであっても、型チェックはありません`t`に`&T`とのための独自の実装があり`&T`：

```rust,ignore
trait Trait {}

fn foo<X: Trait>(t: X) {}

impl<'a> Trait for &'a i32 {}


fn main() {
    let t: &mut i32 = &mut 0;
    foo(t);
}
```

```text
<anon>:10:5: 10:8 error: the trait bound `&mut i32 : Trait` is not satisfied [E0277]
<anon>:10     foo(t);
              ^~~
```
