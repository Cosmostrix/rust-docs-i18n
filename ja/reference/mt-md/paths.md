# <!--Paths--> パス

<!--A *path* is a sequence of one or more path components  _logically_  separated by a namespace <span class="parenthetical">qualifier ( <code>::</code> )</span>.-->
*パス*は、名前空間<span class="parenthetical">修飾子（ <code>::</code></span> _:）で論理的に_ 区切られた1つ以上のパスコンポーネントのシーケンスです。
<!--If a path consists of only one component, it refers to either an [item] or a [variable] in a local control scope.-->
パスが1つのコンポーネントのみで構成される場合、パスはローカルコントロールスコープ内の[item]または[variable]いずれかを参照します。
<!--If a path has multiple components, it always refers to an item.-->
パスに複数のコンポーネントがある場合は、常に項目を参照します。

<!--Two examples of simple paths consisting of only identifier components:-->
識別子コンポーネントのみで構成される単純なパスの2つの例：

```rust,ignore
x;
x::y::z;
```

<!--Path components are usually [identifiers], but they may also include angle-bracket-enclosed lists of type arguments.-->
パスコンポーネントは通常[identifiers]であるが、angle-bracketで囲まれた型引数のリストも含めることができる。
<!--In [expression] context, the type argument list is given after a `::` namespace qualifier in order to disambiguate it from a relational expression involving the less-than <span class="parenthetical">symbol ( <code>&lt;</code> )</span>.-->
[expression]文脈では、型引数リストは、より小さい<span class="parenthetical">記号（ <code>&lt;</code> ）を</span>含む関係式から曖昧さを取り除くために、`::` namespace修飾子の後に与えられます。
<!--In type expression context, the final namespace qualifier is omitted.-->
型式コンテキストでは、最終的な名前空間修飾子は省略されています。

<!--Two examples of paths with type arguments:-->
型引数を持つパスの2つの例：

```rust
# struct HashMap<K, V>(K,V);
# fn f() {
# fn id<T>(t: T) -> T { t }
#//type T = HashMap<i32,String>; // Type arguments used in a type expression
type T = HashMap<i32,String>; // 型式で使用される型引数
#//let x  = id::<i32>(10);       // Type arguments used in a call expression
let x  = id::<i32>(10);       // 呼び出し式で使用される型引数
# }
```

<!--Paths can be denoted with various leading qualifiers to change the meaning of how it is resolved:-->
パスは、どのように解決されたかの意味を変えるために、さまざまな先行の修飾子で指定できます。

* <!--Paths starting with `::` are considered to be global paths where the components of the path start being resolved from the crate root.-->
   `::`始まるパスは、パスのコンポーネントがクレートルートから解決されるグローバルパスとみなされます。
<!--Each identifier in the path must resolve to an item.-->
   パス内の各識別子は項目に解決されなければなりません。

```rust
mod a {
    pub fn foo() {}
}
mod b {
    pub fn foo() {
#//        ::a::foo(); // call a's foo function
        ::a::foo(); //  aの関数fooを呼び出す
    }
}
# fn main() {}
```

* <!--Paths starting with the keyword `super` begin resolution relative to the parent module.-->
   キーワード`super`始まるパスは、親モジュールに対する相対的な解像度を開始します。
<!--Each further identifier must resolve to an item.-->
   それぞれのさらなる識別子は、項目に解決されなければならない。

```rust
mod a {
    pub fn foo() {}
}
mod b {
    pub fn foo() {
#//        super::a::foo(); // call a's foo function
        super::a::foo(); //  aの関数fooを呼び出す
    }
}
# fn main() {}
```

* <!--Paths starting with the keyword `self` begin resolution relative to the current module.-->
   `self`というキーワードで始まるパスは、現在のモジュールを基準にして解決されます。
<!--Each further identifier must resolve to an item.-->
   それぞれのさらなる識別子は、項目に解決されなければならない。

```rust
fn foo() {}
fn bar() {
    self::foo();
}
# fn main() {}
```

<!--Additionally keyword `super` may be repeated several times after the first `super` or `self` to refer to ancestor modules.-->
さらに、キーワード`super`は、最初の`super`または`self`が祖先モジュールを参照した後に複数回繰り返されることがあります。

```rust
mod a {
    fn foo() {}

    mod b {
        mod c {
            fn foo() {
#//                super::super::foo(); // call a's foo function
                super::super::foo(); //  aの関数fooを呼び出す
#//                self::super::super::foo(); // call a's foo function
                self::super::super::foo(); //  aの関数fooを呼び出す
            }
        }
    }
}
# fn main() {}
```

## <!--Canonical paths--> 正則なパス

<!--Items defined in a module or implementation have a *canonical path* that corresponds to where within its crate it is defined.-->
モジュールまたは実装で定義された項目は、その枠内で定義されている場所に対応する*正規のパス*を持ちます。
<!--All other paths to these items are aliases.-->
これらの項目への他のすべてのパスはエイリアスです。
<!--The canonical path is defined as a *path prefix* appended by the path component the item itself defines.-->
カノニカルパスは、アイテム自体が定義するパスコンポーネントによって追加される*パスプレフィックス*として定義されます。

<!--[Implementations] and [use declarations] do not have canonical paths, although the items that implementations define do have them.-->
[Implementations]と[use declarations]は標準的なパスはありませんが、実装で定義されている項目には標準のパスがあります。
<!--Items defined in block expressions do not have canonical paths.-->
ブロック式で定義された項目には、正規パスがありません。
<!--Items defined in a module that does not have a canonical path do not have a canonical path.-->
標準パスを持たないモジュールで定義された項目には、標準パスがありません。
<!--Associated items defined in an implementation that refers to an item without a canonical path, eg as the implementing type, the trait being implemented, a type parameter or bound on a type parameter, do not have canonical paths.-->
正規化されたパスを持たない項目を参照する実装で定義されている関連項目は、実装タイプ、実装されている特性、タイプパラメータまたはタイプパラメータのバインドなどの標準的なパスはありません。

<!--The path prefix for modules is the canonical path to that module.-->
モジュールのパス接頭辞は、そのモジュールへの正規のパスです。
<!--For bare implementations, it is the canonical path of the item being implemented surrounded by <span class="parenthetical">angle ( <code>&lt;&gt;</code> )</span>brackets.-->
裸の実装では、実装されている項目の標準パスが<span class="parenthetical">角（ <code>&lt;&gt;</code> ）で</span>囲まれています。
<!--For trait implementations, it is the canonical path of the item being implemented followed by `as` followed by the canonical path to the trait all surrounded in <span class="parenthetical">angle ( <code>&lt;&gt;</code> )</span>brackets.-->
形質の実装では、実装さ`as`ているアイテムの標準的なパスに続いて、<span class="parenthetical">角（ <code>&lt;&gt;</code> ）で</span>囲まれたすべての特性の標準パスが続きます。

<!--The canonical path is only meaningful within a given crate.-->
標準的なパスは、指定されたクレート内でのみ意味があります。
<!--There is no global namespace across crates;-->
クレート間にはグローバルな名前空間はありません。
<!--an item's canonical path merely identifies it within the crate.-->
アイテムの標準的なパスは、単にそれをクレート内で識別するだけです。

```rust
#// Comments show the canonical path of the item.
// コメントはアイテムの標準的なパスを示します。

#//mod a { // ::a
mod a { // :: a
#//    pub struct Struct; // ::a::Struct
    pub struct Struct; // :: a::構造体

#//    pub trait Trait { // ::a::Trait
    pub trait Trait { // :: a::特性
#//        fn f(&self); // a::Trait::f
        fn f(&self); //  a::形質:: f
    }

    impl Trait for Struct {
#//        fn f(&self) {} // <::a::Struct as ::a::Trait>::f
        fn f(&self) {} //  <:: a:: Struct:: as:: Trait>:: f
    }

    impl Struct {
#//        fn g(&self) {} // <::a::Struct>::g
        fn g(&self) {} //  <:: a:: Struct>:: g
    }
}

#//mod without { // ::without
mod without { // ::なし
#//    fn canonicals() { // ::without::canonicals
    fn canonicals() { // ::なし:: canonicals
#//        struct OtherStruct; // None
        struct OtherStruct; // なし

#//        trait OtherTrait { // None
        trait OtherTrait { // なし
#//            fn g(&self); // None
            fn g(&self); // なし
        }

        impl OtherTrait for OtherStruct {
#//            fn g(&self) {} // None
            fn g(&self) {} // なし
        }

        impl OtherTrait for ::a::Struct {
#//            fn g(&self) {} // None
            fn g(&self) {} // なし
        }

        impl ::a::Trait for OtherStruct {
#//            fn f(&self) {} // None
            fn f(&self) {} // なし
        }
    }
}

# fn main() {}
```
<!--[item]: items.html
 [variable]: variables.html
 [identifiers]: identifiers.html
 [expression]: expressions.html
 [implementations]: items/implementations.html
 [modules]: items/modules.html
 [use declarations]: items/use-declarations.html
-->
[item]: items.html
 [variable]: variables.html
 [identifiers]: identifiers.html
 [expression]: expressions.html
 [implementations]: items/implementations.html
 [modules]: items/modules.html
 [use declarations]: items/use-declarations.html

