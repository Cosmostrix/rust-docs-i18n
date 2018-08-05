# <!--Type and Lifetime Parameters--> タイプと寿命パラメータ

> <!--**<sup>Syntax</sup>** \  _Generics_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _ジェネリックス_ ：\＆nbsp;＆nbsp;
> <!--`<`  _GenericParams_  `>`-->
> `<`  _GenericParams_  `>`
> 
> <!-- _GenericParams_ :\ &nbsp;&nbsp;-->
>  _GenericParams_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!-- _LifetimeParams_  \ &nbsp;&nbsp;-->
>  _LifetimeParams_  \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--( _LifetimeParam_  `,`)  __\ *</sup> _TypeParams_ _LifetimeParams_:\ &nbsp;&nbsp;*__ -->
> （ _LifetimeParam_  `,`）  __\ *</ sup> _TypeParams_ _LifetimeParams_：\＆nbsp;＆nbsp;*__ 
> <!-- __*(_LifetimeParam_ `,`)<sup>\*__   _LifetimeParam_   __?__ -->
>  __*（_LifetimeParam_ `、`）<sup> \*__   _LifetimeParam_   __？__ 
> 
> <!-- _LifetimeParam_ :\ &nbsp;&nbsp;-->
>  _LifetimeParam_ ：\＆nbsp;＆nbsp;
> <!--[_OuterAttribute_]  __?__ -->
> [_OuterAttribute_]  __？__ 
> <!--[LIFETIME_OR_LABEL] `:` [_LifetimeBounds_]  __?__ -->
> [LIFETIME_OR_LABEL] `:` [_LifetimeBounds_]  __？__ 
> 
> <!-- _TypeParams_ :\ &nbsp;&nbsp;-->
>  _TypeParams_ ：\＆nbsp;＆nbsp;
> <!--( _TypeParam_  `,`)  __\*__   _TypeParam_   __?__ -->
> （ _TypeParam_  `,`）  __\ *__   _TypeParam_   __？__ 
> 
> <!-- _TypeParam_ :\ &nbsp;&nbsp;-->
>  _TypeParam_ ：\＆nbsp;＆nbsp;
> <!--[_OuterAttribute_]  __?__ -->
> [_OuterAttribute_]  __？__ 
> <!--[IDENTIFIER] (`:` [_TypeParamBounds_])  __?__ -->
> [IDENTIFIER]（ `:` [_TypeParamBounds_]）  __？__ 
> <!--(`=` [_Type_])  __?__ -->
> （`=` [_Type_]）  __？__ 

<!--Functions, type aliases, structs, enumerations, unions, traits and implementations may be *parameterized* by types and lifetimes.-->
関数、型エイリアス、構造体、列挙型、共用体、特性および実装は、型と存続期間によって*パラメータ化できます*。
<!--These parameters are listed in angle <span class="parenthetical">brackets ( <code>&lt;...&gt;</code> )</span>, usually immediately after and before its definition the name of the item.-->
これらのパラメータは、山<span class="parenthetical">括弧（ <code>&lt;...&gt;</code> ）</span>でリストされます。通常、定義の直前および直前にアイテムの名前が付けられます。
<!--For implementations, which don't have a name, they come directly after `impl`.-->
名前を持たない実装では、`impl`直後に来ます。
<!--Lifetime parameters must be declared before type parameters.-->
寿命パラメータは、型パラメータの前に宣言する必要があります。
<!--Some examples of items with type and lifetime parameters:-->
タイプパラメータと有効期間パラメータを持つアイテムの例をいくつか示します。

```rust
fn foo<'a, T>() {}
trait A<U> {}
struct Ref<'a, T> where T: 'a { r: &'a T }
```

<!--[References], [raw pointers], [arrays], [slices][arrays], [tuples] and [function pointers] have lifetime or type parameters as well, but are not referred to with path syntax.-->
[References]、 [raw pointers]、 [arrays]、 [slices][arrays]、 [tuples]、 [function pointers]は、生涯や型パラメータもありますが、パス構文では参照されません。

## <!--Where clauses--> Where節

> <!--**<sup>Syntax</sup>** \  _WhereClause_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _WhereClause_ ：\＆nbsp;＆nbsp;
> <!--`where` ( _WhereClauseItem_  `,`)  __\*__   _WhereClauseItem_   __?__ -->
> `where`（  _WhereClauseItem_  `,`）  __\ *__   _WhereClauseItem_   __？__ 
> 
> <!-- _WhereClauseItem_ :\ &nbsp;&nbsp;-->
>  _WhereClauseItem_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!-- _LifetimeWhereClauseItem_  \ &nbsp;&nbsp;-->
>  _LifetimeWhereClauseItem_  \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!-- _TypeBoundWhereClauseItem_ -->
>  _TypeBoundWhereClauseItem_ 
> 
> <!-- _LifetimeWhereClauseItem_ :\ &nbsp;&nbsp;-->
>  _LifetimeWhereClauseItem_ ：\＆nbsp;＆nbsp;
> <!--[_Lifetime_] `:` [_LifetimeBounds_]-->
> [_Lifetime_] `:` [_LifetimeBounds_]
> 
> <!-- _TypeBoundWhereClauseItem_ :\ &nbsp;&nbsp;-->
>  _TypeBoundWhereClauseItem_ ：\＆nbsp;＆nbsp;
> <!-- _ForLifetimes_   __?__ -->
>  _ForLifetimes_   __？__ 
> <!--[_Type_] `:` [_TypeParamBounds_]  __?__ -->
> [_Type_] `:` [_TypeParamBounds_]  __？__ 
> 
> <!-- _ForLifetimes_ :\ &nbsp;&nbsp;-->
>  _ForLifetimes_ ：\＆nbsp;＆nbsp;
> <!--`for` `<` [ _LifetimeParams_ ](#type-and-lifetime-parameters) `>`-->
> `for` `<` [ _LifetimeParams_ ](#type-and-lifetime-parameters) `>`

<!--*Where clauses* provide an another way to specify bounds on type and lifetime parameters as well as a way to specify bounds on types that aren't type parameters.-->
*Where句*は、型パラメータと存続時間パラメータの境界を指定する別の方法と、型パラメータではない型の境界を指定する方法を提供します。

<!--Bounds that don't use the item's parameters or higher-ranked lifetimes are checked when the item is defined.-->
アイテムのパラメータを使用しない境界または上位ランクのライフタイムは、アイテムが定義されているときにチェックされます。
<!--It is an error for such a bound to be false.-->
そのような境界が偽であることは誤りである。

<!--[`Copy`], [`Clone`] and [`Sized`] bounds are also checked for certain generic types when defining the item.-->
[`Copy`]、 [`Clone`]、 [`Sized`]境界は、項目を定義する際に特定のジェネリック型についてもチェックされます。
<!--It is an error to have `Copy` or `Clone` as a bound on a mutable reference, [trait object] or [slice][arrays] or `Sized` as a bound on a trait object or slice.-->
変更可能な参照、[trait object]または[slice][arrays]境界として`Copy`または`Clone`を持つか、または[trait object]または[slice][arrays]の境界として`Sized`を指定するのはエラーです。

```rust,ignore
struct A<T>
where
#//    T: Iterator,            // Could use A<T: Iterator> instead
    T: Iterator,            //  Aを使用できました代わりに
    T::Item: Copy,
    String: PartialEq<T>,
#//    i32: Default,           // Allowed, but not useful
    i32: Default,           // 許可されていますが、役に立たない
#//    i32: Iterator,          // Error: the trait bound is not satisfied
    i32: Iterator,          // エラー：特性の境界が満たされていません
#//    [T]: Copy,              // Error: the trait bound is not satisfied
    [T]: Copy,              // エラー：特性の境界が満たされていません
{
    f: T,
}
```

## <!--Attributes--> 属性

<!--Generic lifetime and type parameters allow [attributes] on them.-->
一般的なライフタイムとタイプパラメータは、それらの[attributes]を許可します。
<!--There are no built-in attributes that do anything in this position, although custom derive attributes may give meaning to it.-->
この位置には何もしない組み込みの属性はありませんが、カスタムの属性は意味を与えます。

<!--This example shows using a custom derive attribute to modify the meaning of a generic parameter.-->
この例では、カスタム派生属性を使用して汎用パラメータの意味を変更する方法を示します。

```ignore
#// Assume that the derive for MyFlexibleClone declared `my_flexible_clone` as
#// an attribute it understands.
//  MyFlexibleCloneのための派生を宣言することを前提とし`my_flexible_clone`、それが理解属性として。
#[derive(MyFlexibleClone)] struct Foo<#[my_flexible_clone(unbounded)] H> {
    a: *const H
}
```

<!--[IDENTIFIER]: identifiers.html
 [LIFETIME_OR_LABEL]: tokens.html#lifetimes-and-loop-labels
-->
[IDENTIFIER]: identifiers.html
 [LIFETIME_OR_LABEL]: tokens.html#lifetimes-and-loop-labels


<!--[_LifetimeBounds_]: trait-bounds.html
 [_Lifetime_]: trait-bounds.html
 [_OuterAttribute_]: attributes.html
 [_Type_]: types.html
 [_TypeParamBounds_]: trait-bounds.html
-->
[_LifetimeBounds_]: trait-bounds.html
 [_Lifetime_]: trait-bounds.html
 [_OuterAttribute_]: attributes.html
 [_Type_]: types.html
 [_TypeParamBounds_]: trait-bounds.html


<!--[arrays]: types.html#array-and-slice-types
 [function pointers]: types.html#function-pointer-types
 [references]: types.html#shared-references-
 [raw pointers]: types.html#raw-pointers-const-and-mut
 [`Clone`]: special-types-and-traits.html#clone
 [`Copy`]: special-types-and-traits.html#copy
 [`Sized`]: special-types-and-traits.html#sized
 [tuples]: types.html#tuple-types
 [trait object]: types.html#trait-objects
 [attributes]: attributes.html
-->
[arrays]: types.html#array-and-slice-types
 [function pointers]: types.html#function-pointer-types
 [references]: types.html#shared-references-
 [raw pointers]: types.html#raw-pointers-const-and-mut
 [`Clone`]: special-types-and-traits.html#clone
 [`Copy`]: special-types-and-traits.html#copy
 [`Sized`]: special-types-and-traits.html#sized
 [tuples]: types.html#tuple-types
 [trait object]: types.html#trait-objects
 [attributes]: attributes.html


<!--[path]: ../paths.html
 [Trait]: traits.html#trait-bounds
 [_TypePath_]: paths.html
-->
[path]: ../paths.html
 [Trait]: traits.html#trait-bounds
 [_TypePath_]: paths.html

