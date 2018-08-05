# <!--Subtyping and Variance--> サブタイプと差異

<!--Subtyping is implicit and can occur at any stage in type checking or inference.-->
サブタイプは暗黙的であり、型検査または推論のどの段階でも発生する可能性があります。
<!--Subtyping in Rust is very restricted and occurs only due to variance with respect to lifetimes and between types with higher ranked lifetimes.-->
錆におけるサブタイプ化は非常に制限されており、生涯に関するばらつきおよびより高いランク付けされた寿命を有するタイプ間でのみ生じる。
<!--If we were to erase lifetimes from types, then the only subtyping would be due to type equality.-->
タイプから生存期間を消去する場合、唯一のサブタイプは型の平等によるものです。

<!--Consider the following example: string literals always have `'static` lifetime.-->
次の例を考えてみましょう。文字列リテラルは常に`'static`有効期間を持ち`'static`。
<!--Nevertheless, we can assign `s` to `t`:-->
それにもかかわらず、`s`を`t`代入することができます。

```rust
fn bar<'a>() {
    let s: &'static str = "hi";
    let t: &'a str = s;
}
```

<!--Since `'static` outlives the lifetime parameter `'a`, `&'static str` is a subtype of `&'a str`.-->
以来`'static`寿命パラメータをoutlives `'a` `&'static str`のサブタイプである`&'a str`。

<!--[Higher-ranked] &#32;-->
[Higher-ranked] ＆＃32;
<!--[function pointers] and [trait objects] have another subtype relation.-->
[function pointers]と[trait objects]は別のサブタイプの関係があります。
<!--They are subtypes of types that are given by substitutions of the higher-ranked lifetimes.-->
それらは、より高いランクの生涯の置換によって与えられるタイプのサブタイプである。
<!--Some examples:-->
いくつかの例：

```rust
#// Here 'a is substituted for 'static
// ここで 'aは' static
let subtype: &(for<'a> fn(&'a i32) -> &'a i32) = &((|x| x) as fn(&_) -> &_);
let supertype: &(fn(&'static i32) -> &'static i32) = subtype;

#// This works similarly for trait objects
// これは、特性オブジェクト
let subtype: &(for<'a> Fn(&'a i32) -> &'a i32) = &|x| x;
let supertype: &(Fn(&'static i32) -> &'static i32) = subtype;

#// We can also substitute one higher-ranked lifetime for another
// 私たちはまた、より高いランクの生涯を別の生涯に置き換えることもできます
let subtype: &(for<'a, 'b> fn(&'a i32, &'b i32))= &((|x, y| {}) as fn(&_, &_));
let supertype: &for<'c> fn(&'c i32, &'c i32) = subtype;
```

## <!--Variance--> 分散

<!--Variance is a property that generic types have with respect to their arguments.-->
分散は、ジェネリック型が引数に対して持つ性質です。
<!--A generic type's *variance* in a parameter is how the subtyping of the parameter affects the subtyping of the type.-->
パラメーターの汎用タイプの*分散*は、パラメーターのサブタイプがそのタイプのサブタイプにどのように影響するかです。

* <!--`F<T>` is *covariant* over `T` if `T` being a subtype of `U` implies that `F<T>` is a subtype of `F<U>` (subtyping "passes through")-->
   `F<T>`上に*共変*された`T`場合`T`のサブタイプである`U`ことを意味`F<T>`のサブタイプである`F<U>`（サブタイプ「通過」）
* <!--`F<T>` is *contravariant* over `T` if `T` being a subtype of `U` implies that `F<U>` is a subtype of `F<T>`-->
   `F<T>` IS *反変*オーバー`T`場合`T`のサブタイプである`U`あることを意味`F<U>`のサブタイプである`F<T>`
* <!--`F<T>` is *invariant* over `T` otherwise (no subtyping relation can be derived)-->
   `F<T>`は`T`以外では*不変*である（サブタイプの関係は導かれない）

<!--Variance of types is automatically determined as follows-->
タイプの差異は、以下のように自動的に決定されます

|<!--Type-->タイプ|<!--Variance in `'a`-->`'a`差異|<!--Variance in `T`-->`T`における分散|
|<!----------------------------------->-------------------------------|<!----------------------->-------------------|<!----------------------->-------------------|
|`&'a T`|<!--covariant-->共変量|<!--covariant-->共変量|
|`&'a mut T`|<!--covariant-->共変量|<!--invariant-->不変の|
|`*const T`| |<!--covariant-->共変量|
|`*mut T`| |<!--invariant-->不変の|
|<!--`[T]` and `[T; n]`-->`[T]`および`[T; n]``[T; n]`| |<!--covariant-->共変量|
|`fn() -> T`| |<!--covariant-->共変量|
|`fn(T) -> ()`| |<!--contravariant-->対立形質|
|`std::cell::UnsafeCell<T>`| |<!--invariant-->不変の|
|`std::marker::PhantomData<T>`| |<!--covariant-->共変量|
|`Trait<T> + 'a`|<!--covariant-->共変量|<!--invariant-->不変の|

<!--The variance of other `struct`, `enum`, `union` and tuple types is decided by looking at the variance of the types of their fields.-->
他の`struct`、 `enum`、 `union`およびtuple型の分散は、フィールドの型の分散を調べることによって決定されます。
<!--If the parameter is used in positions with different variances then the parameter is invariant.-->
パラメータが異なる分散を有する位置で使用される場合、パラメータは不変である。
<!--For example the following struct is covariant in `'a` and `T` and invariant in `'b` and `U`.-->
例えば、以下の構造体は`'a`と`T` `'a`共変で、`'b`と`U` `'b`不変である。

```rust
use std::cell::UnsafeCell;
struct Variance<'a, 'b, T, U: 'a> {
#//    x: &'a U,               // This makes `Variance` covariant in 'a, and would
#                            // make it covariant in U, but U is used later
    x: &'a U,               // これは、`Variance` aをaで共変させ、Uで共変にしますが、Uは後で使用されます
#//    y: *const T,            // Covariant in T
    y: *const T,            //  Tの共変量
#//    z: UnsafeCell<&'b f64>, // Invariant in 'b
    z: UnsafeCell<&'b f64>, // 不変の 'b
#//    w: *mut U,              // Invariant in U, makes the whole struct invariant
    w: *mut U,              //  Uの不変式は、構造体全体を不変にする
}
```

<!--[coercions]: type-coercions.html
 [function pointers]: types.html#function-pointer-types
 [Higher-ranked]: ../nomicon/hrtb.html
 [lifetime bound]: types.html#trait-object-lifetime-bounds
 [trait objects]: types.html#trait-objects
-->
[function pointers]: types.html#function-pointer-types
 [coercions]: type-coercions.html
 [function pointers]: types.html#function-pointer-types
 [Higher-ranked]: ../nomicon/hrtb.html
 [lifetime bound]: types.html#trait-object-lifetime-bounds
 [trait objects]: types.html#trait-objects

