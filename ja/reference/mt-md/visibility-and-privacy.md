# <!--Visibility and Privacy--> 可視性とプライバシー

> <!--**<sup>Syntax<sup>** \  _Visibility_ :\ &nbsp;&nbsp;-->
> **<sup>構文<sup>** \  _Visibility_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--EMPTY\ &nbsp;&nbsp;-->
> EMPTY \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`pub` \ &nbsp;&nbsp;-->
> `pub` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`pub` `(` `crate` `)` \ &nbsp;&nbsp;-->
> `pub` `(` `crate` `)` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`pub` `(` `in`  _ModulePath_  `)` \ &nbsp;&nbsp;-->
> `pub` `(` `in`  _のModulePath_  `)` \＆NBSP;＆NBSP;
> <!--|-->
> |
> <!--`pub` `(` `in`  __?__  `self` `)` \ &nbsp;&nbsp;-->
> `pub` `(` `in`  __？__  `self` `)` \＆NBSP;＆NBSP;
> <!--|-->
> |
> <!--`pub` `(` `in`  __?__  `super` `)`-->
> `pub` `(` `in`  __？__  `super` `)`

<!--These two terms are often used interchangeably, and what they are attempting to convey is the answer to the question "Can this item be used at this location?"-->
これらの2つの用語は、しばしば互換的に使用されています。彼らが伝えようとしていることは、「このアイテムをこの場所で使用できますか？

<!--Rust's name resolution operates on a global hierarchy of namespaces.-->
Rustの名前解決は、名前空間のグローバル階層で動作します。
<!--Each level in the hierarchy can be thought of as some item.-->
階層内の各レベルは、いくつかのアイテムと考えることができます。
<!--The items are one of those mentioned above, but also include external crates.-->
アイテムは上記のものの1つですが、外部クレートも含まれています。
<!--Declaring or defining a new module can be thought of as inserting a new tree into the hierarchy at the location of the definition.-->
新しいモジュールを宣言または定義することは、階層の中に定義の場所に新しいツリーを挿入することと考えることができる。

<!--To control whether interfaces can be used across modules, Rust checks each use of an item to see whether it should be allowed or not.-->
インターフェイスがモジュール間で使用できるかどうかを制御するために、Rustはアイテムの各使用をチェックして、許可するかどうかを確認します。
<!--This is where privacy warnings are generated, or otherwise "you used a private item of another module and weren't allowed to."-->
これは、プライバシーの警告が生成される場所です。そうでない場合、「別のモジュールのプライベートアイテムを使用したため、許可されていませんでした。

<!--By default, everything in Rust is *private*, with two exceptions: Associated items in a `pub` Trait are public by default;-->
デフォルトでは、Rustのすべてが*プライベートですが*、2つの例外があります。 `pub`内の関連項目デフォルトはパブリックです。
<!--Enum variants in a `pub` enum are also public by default.-->
`pub`列挙型のEnumバリアントもデフォルトで公開されています。
<!--When an item is declared as `pub`, it can be thought of as being accessible to the outside world.-->
`pub`として宣言されたアイテムは、外部からアクセス可能であると考えることができます。
<!--For example:-->
例えば：

```rust
# fn main() {}
#// Declare a private struct
//  private構造体を宣言する
struct Foo;

#// Declare a public struct with a private field
// プライベートフィールドを持つpublic構造体を宣言する
pub struct Bar {
    field: i32,
}

#// Declare a public enum with two public variants
//  2つのパブリックバリアントで公開列挙型を宣言する
pub enum State {
    PubliclyAccessibleState,
    PubliclyAccessibleState2,
}
```

<!--With the notion of an item being either public or private, Rust allows item accesses in two cases:-->
アイテムがパブリックまたはプライベートのいずれかの概念を持つ場合、Rustはアイテムアクセスを2つのケースで許可します。

1. <!--If an item is public, then it can be accessed externally from some module `m` if you can access all the item's parent modules from `m`.-->
    アイテムが公開されている場合、それはいくつかのモジュールから外部にアクセスすることができます`m`あなたがからすべてのアイテムの親モジュールにアクセスできるかどう`m`。
<!--You can also potentially be able to name the item through re-exports.-->
    再輸出によってアイテムに名前を付けることもできます。
<!--See below.-->
    下記参照。
2. <!--If an item is private, it may be accessed by the current module and its descendants.-->
    アイテムがプライベートである場合、それは現在のモジュールおよびその子孫によってアクセスされ得る。

<!--These two cases are surprisingly powerful for creating module hierarchies exposing public APIs while hiding internal implementation details.-->
これらの2つのケースは、パブリックAPIを公開しながら内部実装の詳細を隠すモジュール階層を作成するために驚くほど強力です。
<!--To help explain, here's a few use cases and what they would entail:-->
説明するのを助けるために、いくつかのユースケースとそれに伴うものを挙げます：

* <!--A library developer needs to expose functionality to crates which link against their library.-->
   図書館の開発者は、その図書館とリンクしているクレートに機能を公開する必要があります。
<!--As a consequence of the first case, this means that anything which is usable externally must be `pub` from the root down to the destination item.-->
   最初のケースの結果として、これは、外部から使用可能なものは、ルートからデスティネーションアイテムまで`pub`する必要があることを意味します。
<!--Any private item in the chain will disallow external accesses.-->
   チェーン内のプライベートアイテムは外部アクセスを許可しません。

* <!--A crate needs a global available "helper module"to itself, but it doesn't want to expose the helper module as a public API.-->
   クレートには、グローバルに利用可能な "ヘルパーモジュール"が必要ですが、ヘルパーモジュールを公開APIとして公開したくありません。
<!--To accomplish this, the root of the crate's hierarchy would have a private module which then internally has a "public API".-->
   これを達成するために、木枠の階層のルートにはプライベートモジュールがあり、それは内部的に「パブリックAPI」を持っています。
<!--Because the entire crate is a descendant of the root, then the entire local crate can access this private module through the second case.-->
   木枠全体がルートの子孫であるため、ローカルクレート全体が第2のケースを通してこのプライベートモジュールにアクセスできます。

* <!--When writing unit tests for a module, it's often a common idiom to have an immediate child of the module to-be-tested named `mod test`.-->
   モジュールの単体テストを記述するときには、テスト対象のモジュールの直下に`mod test`という名前を`mod test`のが普通の方法です。
<!--This module could access any items of the parent module through the second case, meaning that internal implementation details could also be seamlessly tested from the child module.-->
   このモジュールは、2番目のケースを通して親モジュールのすべての項目にアクセスできます。つまり、内部実装の詳細も子モジュールからシームレスにテストできます。

<!--In the second case, it mentions that a private item "can be accessed"by the current module and its descendants, but the exact meaning of accessing an item depends on what the item is.-->
2番目のケースでは、プライベートアイテムが現在のモジュールとその子孫によって「アクセス可能」であると述べていますが、アイテムにアクセスする正確な意味はアイテムの内容によって異なります。
<!--Accessing a module, for example, would mean looking inside of it (to import more items).-->
たとえば、モジュールにアクセスすると、その中を見ること（より多くのアイテムをインポートすること）を意味します。
<!--On the other hand, accessing a function would mean that it is invoked.-->
一方、関数にアクセスすると、その関数が呼び出されることを意味します。
<!--Additionally, path expressions and import statements are considered to access an item in the sense that the import/expression is only valid if the destination is in the current visibility scope.-->
さらに、パス式とインポートステートメントは、インポート先が現在の可視範囲にある場合にのみインポート/式が有効であるという意味でアイテムにアクセスするとみなされます。

<!--Here's an example of a program which exemplifies the three cases outlined above:-->
上記の3つのケースを例示するプログラムの例を次に示します。

```rust
#// This module is private, meaning that no external crate can access this
#// module. Because it is private at the root of this current crate, however, any
#// module in the crate may access any publicly visible item in this module.
// このモジュールはプライベートであり、外部モジュールがこのモジュールにアクセスすることはできません。ただし、現在のクレートのルートにはプライベートなので、クレートのどのモジュールもこのモジュールの公開アイテムにアクセスできます。
mod crate_helper_module {

#    // This function can be used by anything in the current crate
    // この機能は、現在のクレート内の何でも使用できます
    pub fn crate_helper() {}

#    // This function *cannot* be used by anything else in the crate. It is not
#    // publicly visible outside of the `crate_helper_module`, so only this
#    // current module and its descendants may access it.
    // この機能*は*、クレート内の他のものでは使用*できません*。 `crate_helper_module`外部には公開されていないため、この現在のモジュールとその子孫のみがアクセスできます。
    fn implementation_detail() {}
}

#// This function is "public to the root" meaning that it's available to external
#// crates linking against this one.
// この機能は、"rootに公開"されています。これは、これとリンクしている外部の箱に利用可能です。
pub fn public_api() {}

#// Similarly to 'public_api', this module is public so external crates may look
#// inside of it.
//  'public_api'と同様に、このモジュールは公開されているので、外部の箱が内部に見える場合があります。
pub mod submodule {
    use crate_helper_module;

    pub fn my_method() {
#        // Any item in the local crate may invoke the helper module's public
#        // interface through a combination of the two rules above.
        // ローカルクレート内のアイテムは、上記の2つのルールの組み合わせによって、ヘルパーモジュールのパブリックインターフェイスを呼び出すことができます。
        crate_helper_module::crate_helper();
    }

#    // This function is hidden to any module which is not a descendant of
#    // `submodule`
    // この関数は、`submodule`子孫でないモジュールには表示されません
    fn my_implementation() {}

    #[cfg(test)]
    mod test {

        #[test]
        fn test_my_implementation() {
#            // Because this module is a descendant of `submodule`, it's allowed
#            // to access private items inside of `submodule` without a privacy
#            // violation.
            // このモジュールは`submodule`子孫であるため、プライバシー違反なしに`submodule`内のプライベートアイテムにアクセスすることができます。
            super::my_implementation();
        }
    }
}

# fn main() {}
```

<!--For a Rust program to pass the privacy checking pass, all paths must be valid accesses given the two rules above.-->
Rustプログラムがプライバシーチェックパスを通過するためには、上記の2つのルールですべてのパスが有効なアクセスでなければなりません。
<!--This includes all use statements, expressions, types, etc.-->
これには、すべてのuse文、式、型などが含まれます。

## <!--`pub(in path)`, `pub(crate)`, `pub(super)`, and `pub(self)`--> `pub(in path)`、 `pub(crate)`、 `pub(super)`、 `pub(self)`

<!--In addition to public and private, Rust allows users to declare an item as visible within a given scope.-->
パブリックとプライベートに加えて、Rustでは、ユーザーはアイテムを指定されたスコープ内で可視として宣言することができます。
<!--The rules for `pub` restrictions are as follows: -`pub(in path)` makes an item visible within the provided `path`.-->
`pub`制限の規則は次のとおりです。-`pub(in path)`は、指定された`path`内でアイテムを表示し`path`。
<!--`path` must be a parent module of the item whose visibility is being declared.-->
`path`は、可視性が宣言されている項目の親モジュールでなければなりません。
<!---`pub(crate)` makes an item visible within the current crate.-->
-`pub(crate)`アイテムを現在のクレート内で表示します。
<!---`pub(super)` makes an item visible to the parent module.-->
-`pub(super)`は、アイテムを親モジュールに見えるようにします。
<!--This is equivalent to `pub(in super)`.-->
これは`pub(in super)`と同じです。
<!---`pub(self)` makes an item visible to the current module.-->
-`pub(self)`は、現在のモジュールでアイテムを見えるようにします。
<!--This is equivalent to `pub(in self)`.-->
これは`pub(in self)`と同じです。

<!--Here's an example:-->
ここに例があります：

```rust
pub mod outer_mod {
    pub mod inner_mod {
#        // This function is visible within `outer_mod`
        // この関数は`outer_mod`内に表示され`outer_mod`
        pub(in outer_mod) fn outer_mod_visible_fn() {}

#        // This function is visible to the entire crate
        // この機能はクレート全体に表示されます
        pub(crate) fn crate_visible_fn() {}

#        // This function is visible within `outer_mod`
        // この関数は`outer_mod`内に表示され`outer_mod`
        pub(super) fn super_mod_visible_fn() {
#            // This function is visible since we're in the same `mod`
            // この関数は、同じ`mod`いるので表示されます
            inner_mod_visible_fn();
        }

#        // This function is visible
        // この関数は可視です
        pub(self) fn inner_mod_visible_fn() {}
    }
    pub fn foo() {
        inner_mod::outer_mod_visible_fn();
        inner_mod::crate_visible_fn();
        inner_mod::super_mod_visible_fn();

#        // This function is no longer visible since we're outside of `inner_mod`
#        // Error! `inner_mod_visible_fn` is private
        // この関数は`inner_mod`外にあるので表示されなくなり`inner_mod` Error！ `inner_mod_visible_fn`はプライベートです
        //inner_mod::inner_mod_visible_fn();
    }
}

fn bar() {
#    // This function is still visible since we're in the same crate
    // この機能は、同じ箱に入っているので表示されます
    outer_mod::inner_mod::crate_visible_fn();

#    // This function is no longer visible since we're outside of `outer_mod`
#    // Error! `super_mod_visible_fn` is private
    //  `outer_mod`外にあるため、この関数は表示されなくなり`outer_mod` Error！ `super_mod_visible_fn`はプライベートです
    //outer_mod::inner_mod::super_mod_visible_fn();

#    // This function is no longer visible since we're outside of `outer_mod`
#    // Error! `outer_mod_visible_fn` is private
    //  `outer_mod`外にあるため、この関数は表示されなくなり`outer_mod` Error！ `outer_mod_visible_fn`はプライベートです
    //outer_mod::inner_mod::outer_mod_visible_fn();

    outer_mod::foo();
}

fn main() { bar() }
```

## <!--Re-exporting and Visibility--> 再輸出と視認性

<!--Rust allows publicly re-exporting items through a `pub use` directive.-->
錆は、`pub use`指示書を`pub use`商品を公に再輸出することができます。
<!--Because this is a public directive, this allows the item to be used in the current module through the rules above.-->
これはパブリック・ディレクティブなので、これにより、上記のルールを使用して現在のモジュールでアイテムを使用することができます。
<!--It essentially allows public access into the re-exported item.-->
これは本質的に、再輸出された品目に一般にアクセスすることを可能にする。
<!--For example, this program is valid:-->
たとえば、このプログラムは有効です。

```rust
pub use self::implementation::api;

mod implementation {
    pub mod api {
        pub fn f() {}
    }
}

# fn main() {}
```

<!--This means that any external crate referencing `implementation::api::f` would receive a privacy violation, while the path `api::f` would be allowed.-->
つまり、`implementation::api::f`を参照`implementation::api::f`外部クレートはプライバシー違反を受け取り、`api::f`は許可されます。

<!--When re-exporting a private item, it can be thought of as allowing the "privacy chain"being short-circuited through the reexport instead of passing through the namespace hierarchy as it normally would.-->
プライベートアイテムを再エクスポートするとき、「プライバシーチェーン」は、通常のように名前空間階層を通過するのではなく、再エクスポートによって短絡することを許可すると考えることができます。
