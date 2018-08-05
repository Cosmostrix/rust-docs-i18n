# <!--Modules--> モジュール

> <!--**<sup>Syntax:<sup>** \  _Module_ :\ &nbsp;&nbsp;-->
> **<sup>構文：<sup>** \  _Module_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`mod` [IDENTIFIER] `;`-->
> `mod` [IDENTIFIER] `;`
> <!--\ &nbsp;&nbsp;-->
> \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`mod` [IDENTIFIER] `{` \ &nbsp;&nbsp;-->
> `mod` [IDENTIFIER] `{` \＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;＆nbsp;＆nbsp;
> <!--[_InnerAttribute_]  __\ *</sup>\ &nbsp;&nbsp;*__ -->
> [_InnerAttribute_]  __\ *</ sup> \＆nbsp;＆nbsp;*__ 
> <!-- __*&nbsp;&nbsp;&nbsp;&nbsp;*__ -->
>  __*＆nbsp;＆nbsp;＆nbsp;＆nbsp;*__ 
> <!-- __*[_Item_]<sup>\*__  \ &nbsp;&nbsp;-->
>  __*[_Item _] <sup> \*__  \＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> `}`

<!--A module is a container for zero or more [items].-->
モジュールは、0個以上の[items]コンテナです。

<!--A  _module item_  is a module, surrounded in braces, named, and prefixed with the keyword `mod`.-->
 _モジュール項目_ は、中括弧で囲まれたモジュールで、名前は`mod`で、接頭辞は`mod`です。
<!--A module item introduces a new, named module into the tree of modules making up a crate.-->
モジュール項目は、新しい名前付きモジュールをクレートを構成するモジュールツリーに導入します。
<!--Modules can nest arbitrarily.-->
モジュールは任意にネストすることができます。

<!--An example of a module:-->
モジュールの例：

```rust
mod math {
    type Complex = (f64, f64);
    fn sin(f: f64) -> f64 {
        /* ... */
# panic!();
    }
    fn cos(f: f64) -> f64 {
        /* ... */
# panic!();
    }
    fn tan(f: f64) -> f64 {
        /* ... */
# panic!();
    }
}
```

<!--Modules and types share the same namespace.-->
モジュールと型は同じ名前空間を共有します。
<!--Declaring a named type with the same name as a module in scope is forbidden: that is, a type definition, trait, struct, enumeration, union, type parameter or crate can't shadow the name of a module in scope, or vice versa.-->
スコープ内のモジュールと同じ名前の名前付き型の宣言は禁止されています。型定義、型、構造体、列挙型、共用体、型パラメータまたは枠はスコープ内のモジュールの名前をシャドーできません。。
<!--Items brought into scope with `use` also have this restriction.-->
スコープに持ち込まアイテム`use`また、この制限を持っています。

<!--A module without a body is loaded from an external file, by default with the same name as the module, plus the `.rs` extension.-->
本体を持たないモジュールは、外部ファイルから、デフォルトでモジュールと同じ名前で、`.rs`拡張子を加えてロードされます。
<!--When a nested submodule is loaded from an external file, it is loaded from a subdirectory path that mirrors the module hierarchy.-->
ネストされたサブモジュールが外部ファイルからロードされると、モジュール階層を反映するサブディレクトリパスからロードされます。

```rust,ignore
#// Load the `vec` module from `vec.rs`
//  `vec.rs`から`vec`モジュールをロードする
mod vec;

mod thread {
#    // Load the `local_data` module from `thread/local_data.rs`
#    // or `thread/local_data/mod.rs`.
    //  `local_data`モジュールを`thread/local_data.rs`または`thread/local_data/mod.rs`からロードします。
    mod local_data;
}
```

<!--The directories and files used for loading external file modules can be influenced with the `path` attribute.-->
外部ファイルモジュールのロードに使用されるディレクトリとファイルは、`path`属性の影響を受ける可能性があります。

```rust,ignore
#[path = "thread_files"]
mod thread {
#    // Load the `local_data` module from `thread_files/tls.rs`
    //  `thread_files/tls.rs`から`local_data`モジュールをロードする
    #[path = "tls.rs"]
    mod local_data;
}
```

[IDENTIFIER]: identifiers.html

<!--[_InnerAttribute_]: attributes.html
 [_OuterAttribute_]: attributes.html
-->
[_InnerAttribute_]: attributes.html
 [_OuterAttribute_]: attributes.html


<!--[_Item_]: items.html
 [items]: items.html
-->
[_Item_]: items.html
 [items]: items.html

