# <!--Trait and lifetime bounds--> 特性と生涯の境界

> <!--**<sup>Syntax</sup>** \  _TypeParamBounds_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _TypeParamBounds_ ：\＆nbsp;＆nbsp;
> <!-- _TypeParamBound_  (`+`  _TypeParamBound_ )  __\ *</sup> `+`<sup>?</sup> _TypeParamBound_:\ &nbsp;&nbsp;*__ -->
>  _TypeParamBound_ （ `+`  _TypeParamBound_ ）  __\ *</ sup> `+` <sup>？</ sup> _TypeParamBound_：\＆nbsp;＆nbsp;*__ 
> <!-- __*&nbsp;&nbsp;*__ -->
>  __*＆nbsp;＆nbsp;*__ 
> <!-- __*_Lifetime_ |*__ -->
>  __*_Lifetime_ |*__ 
> <!-- __*_TraitBound_ _TraitBound_:\ &nbsp;&nbsp;*__ -->
>  __*_TraitBound_ _TraitBound_：\＆nbsp;＆nbsp;*__ 
> <!-- __*&nbsp;&nbsp;*__ -->
>  __*＆nbsp;＆nbsp;*__ 
> <!-- __*`?`<sup>?</sup> [_ForLifetimes_](#higher-ranked-trait-bounds)<sup>?</sup> [_TraitPath_]\ &nbsp;&nbsp;*__ -->
>  __*`？<sup>？</ sup> [_ForLifetimes _]（上位ランクの境界）<sup>？</ sup> [_TraitPath _] \＆nbsp;＆nbsp;*__ 
> <!-- __*|*__ -->
>  __*|*__ 
> <!-- __*`(` `?`<sup>?</sup> [_ForLifetimes_](#higher-ranked-trait-bounds)<sup>?</sup> [_TraitPath_] `)` _LifetimeBounds_:\ &nbsp;&nbsp;*__ -->
>  __*'（？ `<sup>？</ sup> [_ForLifetimes _]（上位ランクの境界）<sup>？</ sup> [_TraitPath_]`）`_LifetimeBounds_：\＆nbsp;＆nbsp;*__ 
> <!-- __*(_Lifetime_ `+`)<sup>\*__   _Lifetime_   __?__ -->
>  __*（_Lifetime_ `+`）<sup> \*__   _Lifetime_   __？__ 
> 
> <!-- _Lifetime_ :\ &nbsp;&nbsp;-->
>  _生涯_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[LIFETIME_OR_LABEL] \ &nbsp;&nbsp;-->
> [LIFETIME_OR_LABEL] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`'static` \ &nbsp;&nbsp;-->
> `'static` \＆nbsp;＆nbsp;
> <!--|-->
> |
> `'_`

<!--[Trait] and lifetime bounds provide a way for [generic items][generic] to restrict which types and lifetimes are used as their parameters.-->
[Trait]と寿命の境界は、[汎用アイテム][generic]がどのタイプと寿命をパラメータとして使用するかを制限する方法を提供します。
<!--Bounds can be provided on any type in a [where clause].-->
境界は、[where clause]任意の型で指定できます。
<!--There are also shorter forms for certain common cases:-->
特定の一般的なケースでは、より短い形式もあります。

* <!--Bounds written after declaring a [generic parameter][generic]: `fn f<A: Copy>() {}` is the same as `fn f<A> where A: Copy () {}`.-->
   [一般的なパラメータを][generic]宣言した後に書かれた境界： `fn f<A: Copy>() {}`は`fn f<A> where A: Copy () {}`と同じです。
* <!--In trait declarations as [supertraits]: `trait Circle : Shape {}` is equivalent to `trait Circle where Self : Shape {}`.-->
   [supertraits]としての形質宣言： `trait Circle : Shape {}`は`trait Circle where Self : Shape {}`と同等です。
* <!--In trait declarations as bounds on [associated types]: `trait A { type B: Copy; }`-->
   [associated types]境界としての形質宣言では、`trait A { type B: Copy; }`
<!--`trait A { type B: Copy; }` is equivalent to `trait A where Self::B: Copy { type B; }`-->
   `trait A { type B: Copy; }`は、`trait A where Self::B: Copy { type B; }`と同等`trait A where Self::B: Copy { type B; }`
<!--`trait A where Self::B: Copy { type B; }`.-->
   `trait A where Self::B: Copy { type B; }`。

<!--Bounds on an item must be satisfied when using the item.-->
アイテムを使用するときは、アイテムの境界線を満たす必要があります。
<!--When type checking and borrow checking a generic item, the bounds can be used to determine that a trait is implemented for a type.-->
タイプチェックと汎用アイテムのチェックを借用する場合、その境界を使用して、あるタイプの特性が実装されているかどうかを判断できます。
<!--For example, given `Ty: Trait`-->
例えば、与えられた`Ty: Trait`

* <!--In the body of a generic function, methods from `Trait` can be called on `Ty` values.-->
   ジェネリック関数の本体では、`Trait`メソッドを`Ty`値で呼び出すことができます。
<!--Likewise associated constants on the `Trait` can be used.-->
   同様に、`Trait`関連する定数も使用できます。
* <!--Associated types from `Trait` can be used.-->
   `Trait`関連タイプを使用できます。
* <!--Generic functions and types with a `T: Trait` bounds can be used with `Ty` being used for `T`.-->
   `T: Trait` boundsを持つ一般的な関数と型は、`Ty`が`T`に使われているときに使うことができます。

```rust
# type Surface = i32;
trait Shape {
    fn draw(&self, Surface);
    fn name() -> &'static str;
}

fn draw_twice<T: Shape>(surface: Surface, sh: T) {
#//    sh.draw(surface);           // Can call method because T: Shape
    sh.draw(surface);           //  T：Shapeのためメソッドを呼び出すことができます
    sh.draw(surface);
}

fn copy_and_draw_twice<T: Copy>(surface: Surface, sh: T) where T: Shape {
#//    let shape_copy = sh;        // doesn't move sh because T: Copy
    let shape_copy = sh;        //  T：コピー
#//    draw_twice(surface, sh);    // Can use generic function because T: Shape
    draw_twice(surface, sh);    //  T：Shapeのため汎用関数を使用できます
}

struct Figure<S: Shape>(S, S);

fn name_figure<U: Shape>(
#//    figure: Figure<U>,          // Type Figure<U> is well-formed because U: Shape
    figure: Figure<U>,          //  Type Figure <span class="underline">は整形式です。U：Shape</span>
) {
    println!(
        "Figure of two {}",
#//        U::name(),              // Can use associated function
        U::name(),              // 関連する関数を使用できます
    );
}
```

<!--Trait and lifetime bounds are also used to name [trait objects].-->
特性および寿命の境界は、[trait objects]名前を付けるためにも使用され[trait objects]。

## `?Sized`
`?` <!--is only used to declare that the [`Sized`] trait may not be implemented for a type parameter or associated type.-->
型パラメータまたは関連する型のために[`Sized`]特性が実装されないかもしれないことを宣言するためだけに使われます。
<!--`?Sized` may not be used as a bound for other types.-->
`?Sized`は、他の型のバインドとして使用することはできません。

## <!--Lifetime bounds--> 生涯の範囲

<!--Lifetime bounds can be applied to types or other lifetimes.-->
生涯の境界は、型やその他の生涯に適用できます。
<!--The bound `'a: 'b` is usually read as `'a` *outlives* `'b`.-->
拘束された`'a: 'b`は、通常、`'a` *outlives* `'b`として読み込まれます。
<!--`'a: 'b` means that `'a` lasts longer than `'b`, so a reference `&'a ()` is valid whenever `&'b ()` is valid.-->
`'a: 'b`あることを意味`'a`よりも長く続く`'b`そう基準`&'a ()`ときはいつでも有効である`&'b ()`有効です。

```rust
fn f<'a, 'b>(x: &'a i32, mut y: &'b i32) where 'a: 'b {
#//    y = x;                      // &'a i32 is a subtype of &'b i32 because 'a: 'b
    y = x;                      //  ＆ 'a i32は＆b '32のサブタイプです。なぜなら' a： 'b
#//    let r: &'b &'a i32 = &&0;   // &'b &'a i32 is well formed because 'a: 'b
    let r: &'b &'a i32 = &&0;   //  ＆ 'b＆a' i32はうまく形成されています。なぜなら 'a：' b
}
```

<!--`T: 'a` means that all lifetime parameters of `T` outlive `'a`.-->
`T: 'a`すべての寿命パラメータ手段`T`長生き`'a`。
<!--For example if `'a` is an unconstrained lifetime parameter then `i32: 'static` and `&'static str: 'a` are satisfied but `Vec<&'a ()>: 'static` is not.-->
たとえば、`'a`が制約のない生涯パラメータである場合、`i32: 'static`および`&'static str: 'a`は満たされますが、`Vec<&'a ()>: 'static`はありません。

## <!--Higher-ranked trait bounds--> 高ランクの形質境界

<!--Type bounds may be *higher ranked* over lifetimes.-->
タイプ境界は、ライフタイム*より*も*高いランク*を持つかもしれません。
<!--These bounds specify a bound is true *for all* lifetimes.-->
これらの境界は*、すべての*存続期間に拘束されること*を*指定します。
<!--For example, a bound such as `for<'a> &'a T: PartialEq<i32>` would require an implementation like-->
例えば、`for<'a> &'a T: PartialEq<i32>`ような`for<'a> &'a T: PartialEq<i32>`は、次のような実装を必要とします。

```rust,ignore
impl<'a> PartialEq<i32> for &'a T {
#    // ...
    // ...
}
```

<!--and could then be used to compare a `&'a T` with any lifetime to an `i32`.-->
そして`&'a T`を任意の生涯と`i32`と比較するために使用することができる。

<!--Only a higher-ranked bound can be used here as the lifetime of the reference is shorter than a lifetime parameter on the function:-->
参照の有効期間が関数の存続時間パラメータよりも短いため、ここでは上位の境界のみを使用できます。

```rust
fn call_on_ref_zero<F>(f: F) where for<'a> F: Fn(&'a i32) {
    let zero = 0;
    f(&zero);
}
```

<!--Higher-ranked lifetimes may also be specified just before the trait, the only end of the following trait instead of the whole bound.-->
より高いランクの寿命も、形質の直前で指定することができ、拘束全体ではなく、次の形質の唯一の終わりです。
<!--This function is difference is the scope of the lifetime parameter, which extends only to the equivalent to the last one.-->
この関数は、lifetimeパラメータのスコープが異なります。これは、最後のパラメータに相当するものだけに拡張されます。

```rust
fn call_on_ref_zero<F>(f: F) where F: for<'a> Fn(&'a i32) {
    let zero = 0;
    f(&zero);
}
```

<!--[LIFETIME_OR_LABEL]: tokens.html#lifetimes-and-loop-labels
 [_TraitPath_]: paths.html
 [`Sized`]: special-types-and-traits.html#sized
-->
[LIFETIME_OR_LABEL]: tokens.html#lifetimes-and-loop-labels
 [_TraitPath_]: paths.html
 [`Sized`]: special-types-and-traits.html#sized


<!--[associated types]: items/associated-items.html#associated-types
 [supertraits]: items/traits.html#supertraits
 [generic]: items/generics.html
 [Trait]: items/traits.html#trait-bounds
 [trait objects]: types.html#trait-objects
 [where clause]: items/generics.html#where-clauses
-->
[associated types]: items/associated-items.html#associated-types
 [supertraits]: items/traits.html#supertraits
 [generic]: items/generics.html
 [Trait]: items/traits.html#trait-bounds
 [trait objects]: types.html#trait-objects
 [where clause]: items/generics.html#where-clauses

