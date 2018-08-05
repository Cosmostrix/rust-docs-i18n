# <!--Use declarations--> 宣言を使用する

> <!--**<sup>Syntax:</sup>** \  _UseDeclaration_ :\ &nbsp;&nbsp;-->
> **<sup>構文：</ sup>** \  _UseDeclaration_ ：\＆nbsp;＆nbsp;
> <!--([_Visibility_])  __?__ -->
> （[_Visibility_]）  __？__ 
> <!--`use`  _UseTree_  `;`-->
>  _UseTreeを_  `use`  _ます_  `;`
> 
> <!-- _UseTree_ :\ &nbsp;&nbsp;-->
>  _UseTree_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--([_SimplePath_]  __?__  `::`)  __?__ -->
> （[_SimplePath_]  __？__  `::`  __）？__ 
> <!--`*` \ &nbsp;&nbsp;-->
> `*` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--([_SimplePath_]  __?__  `::`)  __?__ -->
> （[_SimplePath_]  __？__  `::`  __）？__ 
> <!--`{` ( _UseTree_  (`,`  _UseTree_ )  __\*__  `,`  __?__ )  __?__ -->
> `{`  _（UseTree（_  `,`  __ _UseTree）\_  *__  `,`  __ __？）？__ __ 
> <!--`}` \ &nbsp;&nbsp;-->
> `}` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_SimplePath_] `as` [IDENTIFIER]-->
> [IDENTIFIER] `as` [_SimplePath_]

<!--A  _use declaration_  creates one or more local name bindings synonymous with some other [path].-->
 _使用宣言_ は、他の[path]と同義の1つ以上のローカル名バインディングを作成し[path]。
<!--Usually a `use` declaration is used to shorten the path required to refer to a module item.-->
通常、モジュール項目を参照するために必要なパスを短縮するために、`use`宣言が使用されます。
<!--These declarations may appear in [modules] and [blocks], usually at the top.-->
これらの宣言は[modules]と[blocks]で表示され、通常は先頭に表示され[modules]。

<!--[path]: paths.html
 [modules]: items/modules.html
 [blocks]: expressions/block-expr.html
-->
[path]: paths.html
 [modules]: items/modules.html
 [blocks]: expressions/block-expr.html


> <!--**Note**: Unlike in many languages, `use` declarations in Rust do *not* declare linkage dependency with external crates.-->
> **注**：多くの言語とは異なり、 `use`ルスト宣言は、外部の木箱と連鎖依存関係を宣言しません。
> <!--Rather, [`extern crate` declarations](items/extern-crates.html) declare linkage dependencies.-->
> むしろ、[`extern crate`宣言は](items/extern-crates.html)リンケージの依存関係を[宣言](items/extern-crates.html)します。

<!--Use declarations support a number of convenient shortcuts:-->
宣言は便利なショートカットをいくつかサポートしています：

* <!--Simultaneously binding a list of paths with a common prefix, using the glob-like brace syntax `use a::b::{c, d, e::f, g::h::i};`-->
   globのような括弧構文を`use a::b::{c, d, e::f, g::h::i};`して、共通の接頭辞を持つパスのリストを同時にバインドするに`use a::b::{c, d, e::f, g::h::i};`
* <!--Simultaneously binding a list of paths with a common prefix and their common parent module, using the `self` keyword, such as `use a::b::{self, c, d::e};`-->
   `use a::b::{self, c, d::e};`ように、`self`キーワードを使用して共通の接頭辞と共通の親モジュールを持つパスのリストを同時にバインドし`use a::b::{self, c, d::e};`
* <!--Rebinding the target name as a new local name, using the syntax `use p::q::r as x;`-->
   構文を`use p::q::r as x;`てターゲット名を新しいローカル名としてリバインド`use p::q::r as x;`
<!--.-->
   。
<!--This can also be used with the last two features: `use a::b::{self as ab, c as abc}`.-->
   最後の2つの機能でも使用できます`use a::b::{self as ab, c as abc}`ます。
* <!--Binding all paths matching a given prefix, using the asterisk wildcard syntax `use a::b::*;`-->
   アスタリスクワイルドカード構文を`use a::b::*;`して、与えられた接頭辞に一致するすべてのパスをバインド`use a::b::*;`
<!--.-->
   。
* <!--Nesting groups of the previous features multiple times, such as `use a::b::{self as ab, c, d::{*, e::f}};`-->
   `use a::b::{self as ab, c, d::{*, e::f}};`ように、前の機能のグループを複数回ネストする`use a::b::{self as ab, c, d::{*, e::f}};`

<!--An example of `use` declarations:-->
`use`宣言の例：

```rust
use std::option::Option::{Some, None};
use std::collections::hash_map::{self, HashMap};

fn foo<T>(_: T){}
fn bar(map1: HashMap<String, usize>, map2: hash_map::HashMap<String, usize>){}

fn main() {
#    // Equivalent to 'foo(vec![std::option::Option::Some(1.0f64),
#    // std::option::Option::None]);'
    //  'foo（vec！ [std::option::Option::Some(1.0f64), std::option::Option::None]）;'と[std::option::Option::Some(1.0f64), std::option::Option::None]です。
    foo(vec![Some(1.0f64), None]);

#    // Both `hash_map` and `HashMap` are in scope.
    //  `hash_map`と`HashMap`両方が有効範囲にあります。
    let map1 = HashMap::new();
    let map2 = hash_map::HashMap::new();
    bar(map1, map2);
}
```

<!--Like items, `use` declarations are private to the containing module, by default.-->
項目と同様に、`use`宣言は、デフォルトでは、含むモジュールのprivate宣言です。
<!--Also like items, a `use` declaration can be public, if qualified by the `pub` keyword.-->
アイテムと同様に、`pub`キーワードで修飾されていれば、`use`宣言をパブリックにすることができます。
<!--Such a `use` declaration serves to  _re-export_  a name.-->
そのような`use`宣言は、名前を _再エクスポート_ するのに役立ちます。
<!--A public `use` declaration can therefore  _redirect_  some public name to a different target definition: even a definition with a private canonical path, inside a different module.-->
したがって、パブリック`use`宣言は、一部のパブリック名を別のターゲット定義に _リダイレクト_ することができます。別のモジュール内のプライベートな正規パスを持つ定義さえできます。
<!--If a sequence of such redirections form a cycle or cannot be resolved unambiguously, they represent a compile-time error.-->
このようなリダイレクションのシーケンスがサイクルを形成するか、または明白に解決できない場合、それらはコンパイル時エラーを表します。

<!--An example of re-exporting:-->
再輸出の例：

```rust
# fn main() { }
mod quux {
    pub use quux::foo::{bar, baz};

    pub mod foo {
        pub fn bar() { }
        pub fn baz() { }
    }
}
```

<!--In this example, the module `quux` re-exports two public names defined in `foo`.-->
この例では、モジュール`quux`は、`foo`定義された2つのパブリック名を再エクスポートします。

<!--Also note that the paths contained in `use` items are relative to the crate root.-->
また、`use`アイテムに含まれるパスはクレートルートに関連していることにも注意してください。
<!--So, in the previous example, the `use` refers to `quux::foo::{bar, baz}`, and not simply to `foo::{bar, baz}`.-->
したがって、前述の例では、`use`指す`quux::foo::{bar, baz}`、はなく単に`foo::{bar, baz}`。
<!--This also means that top-level module declarations should be at the crate root if direct usage of the declared modules within `use` items is desired.-->
これは、`use`項目内で宣言されたモジュールを直接使用`use`が望ましい場合には、最上位のモジュール宣言がクレートルートにあることを意味します。
<!--It is also possible to use `self` and `super` at the beginning of a `use` item to refer to the current and direct parent modules respectively.-->
`use`項目の冒頭で`self`と`super`を`use`して、それぞれ現在の親モジュールと直接の親モジュールを参照することもできます。
<!--All rules regarding accessing declared modules in `use` declarations apply to both module declarations and `extern crate` declarations.-->
`use`宣言で宣言モジュールにアクセスする際のすべての規則は、モジュール宣言と`extern crate`宣言の両方に適用されます。

<!--An example of what will and will not work for `use` items:-->
アイテムを`use`ない場合の例は次のとおりです。

```rust
# #![allow(unused_imports)]
#//use foo::baz::foobaz;    // good: foo is at the root of the crate
use foo::baz::foobaz;    // 良い：fooはクレートの根元にある

mod foo {

    mod example {
        pub mod iter {}
    }

#//    use foo::example::iter; // good: foo is at crate root
    use foo::example::iter; // 良い：fooはクレートルートにあります
#//  use example::iter;      // bad:  example is not at the crate root
//  example:: iterを使用します。//悪い：例はクレートルートにありません
#//    use self::baz::foobaz;  // good: self refers to module 'foo'
    use self::baz::foobaz;  // 良い：自己はモジュール 'foo'を指します
#//    use foo::bar::foobar;   // good: foo is at crate root
    use foo::bar::foobar;   // 良い：fooはクレートルートにあります

    pub mod bar {
        pub fn foobar() { }
    }

    pub mod baz {
#//        use super::bar::foobar; // good: super refers to module 'foo'
        use super::bar::foobar; // 良い：superはモジュール 'foo'を参照しています
        pub fn foobaz() { }
    }
}

fn main() {}
```

<!--[IDENTIFIER]: identifiers.html
 [_SimplePath_]: paths.html
 [_Visibility_]: visibility-and-privacy.html
-->
[IDENTIFIER]: identifiers.html
 [_SimplePath_]: paths.html
 [_Visibility_]: visibility-and-privacy.html

