# <!--Extern crate declarations--> Extern crate宣言

> <!--**<sup>Syntax:<sup>** \  _ExternCrate_ :\ &nbsp;&nbsp;-->
> **<sup>構文：<sup>** \  _ExternCrate_ ：\＆nbsp;＆nbsp;
> <!--`extern` `crate` [IDENTIFIER] &nbsp;(`as` [IDENTIFIER])  __?__ -->
> `extern` `crate` [IDENTIFIER] ＆nbsp;（[IDENTIFIER] `as`）  __？__ 
> `;`

<!--An  _`extern crate` declaration_  specifies a dependency on an external crate.-->
 _`extern crate`宣言_ は、外部クレートへの依存を指定します。
<!--The external crate is then bound into the declaring scope as the `ident` provided in the `extern_crate_decl`.-->
次に、外部クレートは、`extern_crate_decl`された`ident`として宣言スコープにバインドされます。

<!--The external crate is resolved to a specific `soname` at compile time, and a runtime linkage requirement to that `soname` is passed to the linker for loading at runtime.-->
コンパイル時に外部クレートが特定の`soname`解決され、実行時にロードするために、その`soname`に対する実行時リンケージ要件がリンカーに渡されます。
<!--The `soname` is resolved at compile time by scanning the compiler's library path and matching the optional `crateid` provided against the `crateid` attributes that were declared on the external crate when it was compiled.-->
`soname`、コンパイラのライブラリパスをスキャンし、オプションのマッチングによって、コンパイル時に解決される`crateid`に対して提供`crateid`それがコンパイルされたとき、外部クレートに宣言された属性を。
<!--If no `crateid` is provided, a default `name` attribute is assumed, equal to the `ident` given in the `extern_crate_decl`.-->
`crateid`が指定されていない場合は、`extern_crate_decl`指定された`ident`に等しいデフォルトの`name`属性が仮定されます。

<!--Three examples of `extern crate` declarations:-->
`extern crate`宣言の3つの例：

```rust,ignore
extern crate pcre;

#//extern crate std; // equivalent to: extern crate std as std;
extern crate std; // 次のものと同等です：extern crate std as std;

#//extern crate std as ruststd; // linking to 'std' under another name
extern crate std as ruststd; // 別の名前で 'std'にリンクする
```

<!--When naming Rust crates, hyphens are disallowed.-->
Rustの名前を付けるとき、ハイフンは許可されません。
<!--However, Cargo packages may make use of them.-->
しかし、貨物パッケージはそれらを利用することがあります。
<!--In such case, when `Cargo.toml` doesn't specify a crate name, Cargo will transparently replace `-` with `_` (Refer to [RFC 940] for more details).-->
ときそのような場合には、`Cargo.toml`クレート名を指定していない、貨物は透過的に置き換えられます`-`と`_`（を参照してください[RFC 940]詳細）。

<!--Here is an example:-->
次に例を示します。

```rust,ignore
#// Importing the Cargo package hello-world
// 貨物パッケージhello-worldのインポート
#//extern crate hello_world; // hyphen replaced with an underscore
extern crate hello_world; // ハイフンはアンダースコアで置き換えられました
```

[RFC 940]: https://github.com/rust-lang/rfcs/blob/master/text/0940-hyphens-considered-harmful.md

[IDENTIFIER]: identifiers.html
