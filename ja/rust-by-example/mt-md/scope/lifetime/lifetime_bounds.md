# <!--Bounds--> 境界

<!--Just like generic types can be bounded, lifetimes (themselves generic) use bounds as well.-->
ジェネリック型がバインドできるのと同じように、ライフタイム（それ自体汎用）は境界も使用します。
<!--The `:` character has a slightly different meaning here, but `+` is the same.-->
`:`文字はここでは若干意味が異なりますが、`+`は同じです。
<!--Note how the following read:-->
どのように次のように読んでください：

1. <!--`T: 'a`: *All* references in `T` must outlive lifetime `'a`.-->
    `T: 'a`： `T` *すべての*参照は寿命を超えていなければならない`'a`。
2. <!--`T: Trait + 'a`: Type `T` must implement trait `Trait` and *all* references-->
    `T: Trait + 'a`：型`T`は、`Trait`と*すべての*参照を実装しなければなりません
<!--in `T` must outlive `'a`.-->
`T`より長生きしなければなりません`'a`。

<!--The example below shows the above syntax in action:-->
下の例は、上の構文が実際に動作していることを示しています。

```rust,editable
#//use std::fmt::Debug; // Trait to bound with.
use std::fmt::Debug; // 縛られるべき形質。

#[derive(Debug)]
struct Ref<'a, T: 'a>(&'a T);
#// `Ref` contains a reference to a generic type `T` that has
#// an unknown lifetime `'a`. `T` is bounded such that any
#// *references* in `T` must outlive `'a`. Additionally, the lifetime
#// of `Ref` may not exceed `'a`.
//  `Ref`ジェネリック型への参照が含まれ`T`未知の寿命があります`'a`。 `T`は、`T`内の任意の*参照*が`'a`よりも長く存続するように限定さ`'a`。さらに、`Ref`の寿命は`'a`超えてはならない。

#// A generic function which prints using the `Debug` trait.
//  `Debug`特性を使用して印刷する汎用関数。
fn print<T>(t: T) where
    T: Debug {
    println!("`print`: t is {:?}", t);
}

#// Here a reference to `T` is taken where `T` implements
#// `Debug` and all *references* in `T` outlive `'a`. In
#// addition, `'a` must outlive the function.
// ここへの参照`T`どこ取られる`T`実装`Debug`や内*の*すべての*参照* `T`長生き`'a`。加えて、`'a`機能が失われて`'a`ならない。
fn print_ref<'a, T>(t: &'a T) where
    T: Debug + 'a {
    println!("`print_ref`: t is {:?}", t);
}

fn main() {
    let x = 7;
    let ref_x = Ref(&x);

    print_ref(&ref_x);
    print(ref_x);
}
```

### <!--See also:--> 参照：

<!--[generics][generics], [bounds in generics][bounds], and [multiple bounds in generics][multibounds]-->
[generics][generics]、 [generics][generics] [境界、ジェネリックの][bounds] [複数の境界][multibounds]

<!--[generics]: generics.html
 [bounds]: generics/bounds.html
 [multibounds]: generics/multi_bounds.html
-->
[generics]: generics.html
 [bounds]: generics/bounds.html
 [multibounds]: generics/multi_bounds.html

