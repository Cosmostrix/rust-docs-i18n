# <!--Attributes--> 属性

> <!--**<sup>Syntax</sup>** \  _Attribute_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _属性_ ：\＆nbsp;＆nbsp;
> <!-- _InnerAttribute_  |-->
>  _InnerAttribute_  |
> <!-- _OuterAttribute_ -->
>  _OuterAttribute_ 
> 
> <!-- _InnerAttribute_ :\ &nbsp;&nbsp;-->
>  _InnerAttribute_ ：\＆nbsp;＆nbsp;
> <!--`#![` MetaItem `]`-->
> `#![` MetaItem `]`
> 
> <!-- _OuterAttribute_ :\ &nbsp;&nbsp;-->
>  _OuterAttribute_ ：\＆nbsp;＆nbsp;
> <!--`#[` MetaItem `]`-->
> `#[` MetaItem `]`
> 
> <!-- _MetaItem_ :\ &nbsp;&nbsp;-->
>  _MetaItem_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--IDENTIFIER\ &nbsp;&nbsp;-->
> ID＆amp;＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--IDENTIFIER `=` LITERAL\ &nbsp;&nbsp;-->
> IDENTIFIER `=` LITERAL \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--IDENTIFIER `(` LITERAL `)` \ &nbsp;&nbsp;-->
> ID `(`識字`)` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--IDENTIFIER `(`  _MetaSeq_  `)`-->
> 識別子`(`  _MetaSeq_  `)`
> 
> <!-- _MetaSeq_ :\ &nbsp;&nbsp;-->
>  _MetaSeq_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--EMPTY\ &nbsp;&nbsp;-->
> EMPTY \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!-- _MetaItem_  \ &nbsp;&nbsp;-->
>  _MetaItem_  \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!-- _MetaItem_  `,`  _MetaSeq_ -->
>  _MetaItem_  `,`  _MetaSeq_ 

<!--An  _attribute_  is a general, free-form metadatum that is interpreted according to name, convention, and language and compiler version.-->
 _属性_ は、一般的な自由形式のメタデータで、名前、規則、言語、およびコンパイラのバージョンに従って解釈されます。
<!--Attributes are modeled on Attributes in [ECMA-335], with the syntax coming from [ECMA-334] \(C#).-->
属性は[ECMA-335]属性でモデル化され、構文は[ECMA-334] \（C＃）から得られます。

<!--Attributes may appear as any of:-->
属性は、次のいずれかとして表示されることがあります。

* <!--A single identifier, the  _attribute name_ -->
   単一の識別子、 _属性名_ 
* <!--An identifier followed by the equals sign '=' and a literal, providing a key/value pair-->
   識別子の後に等号 '='とリテラルが続き、キーと値のペアを提供します
* <!--An identifier followed by a parenthesized literal, providing a key/value pair-->
   識別子の後にカッコで囲まれたリテラルが続き、キーと値のペアを提供します
* <!--An identifier followed by a parenthesized list of sub-attribute arguments-->
   識別子の後ろにサブ属性引数のカッコで囲まれたリスト

<!-- _Inner attributes_ , written with a bang ("!") after the hash ("#"), apply to the item that the attribute is declared within.-->
バタンと書かれた _インナー属性_ （「！」）ハッシュ（「＃」）の後には、属性が内で宣言されていることをアイテムに適用されます。
<!-- _Outer attributes_ , written without the bang after the hash, apply to the item or generic parameter that follow the attribute.-->
ハッシュの後にbangなしで書かれた _外側の属性_ は、属性に続く項目または汎用パラメータに適用されます。

<!--Attributes may be applied to many things in the language:-->
属性は言語の多くのものに適用されます：

* <!--All [item declarations] accept outer attributes while [external blocks], [functions], [implementations], and [modules] accept inner attributes.-->
   すべての[item declarations]は外部属性を受け付け、[external blocks]、 [functions]、 [implementations]、および[modules]は内部属性を受け入れます。
* <!--[Statements] accept outer attributes.-->
   [Statements]は外部属性を受け入れます。
* <!--[Block expressions] accept outer and inner attributes, but only when they are the outer expression of an [expression statement] or the final expression of another block expression.-->
   [Block expressions]、外部および内部属性を受け入れますが、それらが[expression statement]外側の式または別のブロック式の最終式であ​​る場合のみです。
* <!--[Enum] variants and [struct] and [union] fields accept outer attributes.-->
   [Enum]バリアント、[struct]および[union] [struct]フィールドは外部属性を受け入れます。
* <!--[Match expression arms][match%20expressions] accept outer attributes.-->
   [マッチ式アーム][match%20expressions]は外部属性を受け入れます。
* <!--[Generic lifetime or type parameter][generics] accept outer attributes.-->
   [一般的な有効期間またはタイプパラメータ][generics]は外部属性を受け入れます。

<!--Some examples of attributes:-->
属性の例：

```rust
#// General metadata applied to the enclosing module or crate.
// 囲い込みモジュールまたはクレートに適用される一般的なメタデータ
#![crate_type = "lib"]

#// A function marked as a unit test
// ユニットテストとしてマークされた関数
#[test]
fn test_foo() {
    /* ... */
}

#// A conditionally-compiled module
// 条件付きでコンパイルされたモジュール
#[cfg(target_os = "linux")]
mod bar {
    /* ... */
}

#// A lint attribute used to suppress a warning/error
// 警告/エラーを抑制するために使用されるlint属性
#[allow(non_camel_case_types)]
type int8_t = i8;

#// Outer attribute applies to the entire function.
// 外部属性は関数全体に適用されます。
fn some_unused_variables() {
  #![allow(unused_variables)]
  
  let x = ();
  let y = ();
  let z = ();
}
```

<!--The rest of this page describes or links to descriptions of which attribute names have meaning.-->
このページの残りの部分では、どの属性名が意味を持つかについての説明が記載されています。

## <!--Crate-only attributes--> クレートのみの属性

- <!--`crate_name` -specify the crate's crate name.-->
   `crate_name` -クレートのクレート名を指定します。
- <!--`crate_type` -see [linkage](linkage.html).-->
   `crate_type` -[linkage](linkage.html)参照してください。
- <!--`no_builtins` -disable optimizing certain code patterns to invocations of library functions that are assumed to exist-->
   `no_builtins` -存在すると思われるライブラリ関数の呼び出しに特定のコードパターンを最適化することを無効にする
- <!--`no_main` -disable emitting the `main` symbol.-->
   `no_main` -`main`シンボルを表示しないようにします。
<!--Useful when some other object being linked to defines `main`.-->
   リンクされている他のオブジェクトが`main`を定義している場合に便利です。
- <!--`no_start` -disable linking to the `native` crate, which specifies the "start"language item.-->
   `no_start` -"開始"言語項目を指定する`native`クレートへのリンクを無効にします。
- <!--`no_std` -disable linking to the `std` crate.-->
   `no_std` -へのリンクを無効`std`クレート。
- <!--`recursion_limit` -Sets the maximum depth for potentially infinitely-recursive compile-time operations like auto-dereference or macro expansion.-->
   `recursion_limit` -自動逆参照やマクロ展開のような、無限に再帰的なコンパイル時の操作の最大深度を設定します。
<!--The default is `#![recursion_limit="64"]`.-->
   デフォルトは`#![recursion_limit="64"]`です。
- <!--`windows_subsystem` -Indicates that when this crate is linked for a Windows target it will configure the resulting binary's [subsystem] via the linker.-->
   `windows_subsystem` -このクレートがWindowsターゲットのためにリンクされている場合、結果のバイナリの[subsystem]をリンカを介して設定することを示します。
<!--Valid values for this attribute are `console` and `windows`, corresponding to those two respective subsystems.-->
   この属性の有効な値は、`console`と`windows`、それぞれのサブシステムに対応しています。
<!--More subsystems may be allowed in the future, and this attribute is ignored on non-Windows targets.-->
   将来、より多くのサブシステムが許可され、この属性はWindows以外のターゲットでは無視されます。

[subsystem]: https://msdn.microsoft.com/en-us/library/fcc1zstk.aspx

## <!--Module-only attributes--> モジュールのみの属性

- <!--`no_implicit_prelude` -disable injecting `use std::prelude::*` in this module.-->
   `no_implicit_prelude` -注入を無効にするに`use std::prelude::*`、このモジュールで`use std::prelude::*`を使用します。
- <!--`path` -specifies the file to load the module from.-->
   `path` -モジュールをロードするファイルを指定します。
`#[path="foo.rs"] mod bar;` <!--is equivalent to `mod bar { /* contents of foo.rs */ }`.-->
   `mod bar { /* contents of foo.rs */ }`です。
<!--The path is taken relative to the directory that the current module is in.-->
   パスは、現在のモジュールが入っているディレクトリを基準にして取られます。

## <!--Function-only attributes--> 関数のみの属性

- <!--`test` -indicates that this function is a test function, to only be compiled in case of `--test`.-->
   `test` -だけの場合にコンパイルする、この関数はテスト関数であることを示している`--test`。
  - <!--`ignore` -indicates that this test function is disabled.-->
     `ignore` -このテスト機能が無効であることを示します。
- <!--`should_panic` -indicates that this test function should panic, inverting the success condition.-->
   `should_panic` -このテスト関数がパニックすることを示し、成功条件を反転します。
- <!--`cold` -The function is unlikely to be executed, so optimize it (and calls to it) differently.-->
   `cold` -関数が実行される可能性は低いので、関数を最適化（および呼び出し）する方法が異なります。

## <!--FFI attributes--> FFI属性

<!--On an `extern` block, the following attributes are interpreted:-->
`extern`ブロックでは、次の属性が解釈されます。

- <!--`link_args` -specify arguments to the linker, rather than just the library name and type.-->
   `link_args` -ライブラリ名と型だけでなく、リンカーへの引数を指定します。
<!--This is feature gated and the exact behavior is implementation-defined (due to variety of linker invocation syntax).-->
   これはフィーチャーゲーテッドであり、正確な動作は（リンカー呼び出し構文の多様性のために）実装定義です。
- <!--`link` -indicate that a native library should be linked to for the declarations in this block to be linked correctly.-->
   `link` -このブロック内の宣言が正しくリンクされるためにネイティブライブラリをリンクする必要があることを示します。
<!--`link` supports an optional `kind` key with three possible values: `dylib`, `static`, and `framework`.-->
   `link`は、`dylib`、 `static`、 `framework` 3つの値を持つオプションの`kind`キーをサポートしています。
<!--See [external blocks](items/external-blocks.html) for more about external blocks.-->
   [外部ブロックの](items/external-blocks.html)詳細については、[外部ブロック](items/external-blocks.html)を参照してください。
<!--Two examples: `#[link(name = "readline")]` and `#[link(name = "CoreFoundation", kind = "framework")]`.-->
   2つの例： `#[link(name = "readline")]`と`#[link(name = "CoreFoundation", kind = "framework")]`
- <!--`linked_from` -indicates what native library this block of FFI items is coming from.-->
   `linked_from` -FFI項目のこのブロックがどのネイティブライブラリから来ているかを示します。
<!--This attribute is of the form `#[linked_from = "foo"]` where `foo` is the name of a library in either `#[link]` or a `-l` flag.-->
   この属性の形式は`#[linked_from = "foo"]`ここで、`foo`は`#[link]`または`-l`フラグのライブラリ名です。
<!--This attribute is currently required to export symbols from a Rust dynamic library on Windows, and it is feature gated behind the `linked_from` feature.-->
   この属性は、Windows上のRustダイナミックライブラリからシンボルをエクスポートするために現在必要とされており、`linked_from`機能の後ろに機能ゲートが`linked_from`ます。

<!--On declarations inside an `extern` block, the following attributes are interpreted:-->
`extern`ブロック内の宣言では、次の属性が解釈されます。

- <!--`link_name` -the name of the symbol that this function or static should be imported as.-->
   `link_name` -この関数またはstaticをインポートするシンボルの名前。
- <!--`linkage` -on a static, this specifies the [linkage type](http://llvm.org/docs/LangRef.html#linkage-types).-->
   `linkage` -スタティックでは、[リンケージタイプを](http://llvm.org/docs/LangRef.html#linkage-types)指定します。

<!--See [type layout](type-layout.html) for documentation on the `repr` attribute which can be used to control type layout.-->
[型レイアウト](type-layout.html)を制御するために使用できる`repr`属性のドキュメントについては、[型レイアウト](type-layout.html)を参照してください。

## <!--Macro-related attributes--> マクロ関連の属性

- <!--`macro_use` on a `mod` — macros defined in this module will be visible in the module's parent, after this module has been included.-->
   このモジュールが定義されて`macro_use`、このモジュールで定義された`mod`マクロの`macro_use`がモジュールの親モジュールに表示されます。

- <!--`macro_use` on an `extern crate` — load macros from this crate.-->
   `extern crate` `macro_use`上の`macro_use` -このクレートからマクロを読み込みます。
<!--An optional list of names `#[macro_use(foo, bar)]` restricts the import to just those macros named.-->
   オプションの`#[macro_use(foo, bar)]`リストは、名前が指定されたマクロだけにインポートを制限します。
<!--The `extern crate` must appear at the crate root, not inside `mod`, which ensures proper function of the [`$crate` macro variable](../book/first-edition/macros.html#the-variable-crate).-->
   `extern crate`は`mod`中ではなくクレートルートに現れなければなりません。これは[`$crate`マクロ変数の](../book/first-edition/macros.html#the-variable-crate)適切な機能を保証し[ます](../book/first-edition/macros.html#the-variable-crate)。

- <!--`macro_reexport` on an `extern crate` — re-export the named macros.-->
   `extern crate` `macro_reexport` -指定されたマクロを再エクスポートします。

- <!--`macro_export` -export a macro for cross-crate usage.-->
   `macro_export` -クロスクレート使用のためにマクロをエクスポートします。

- <!--`no_link` on an `extern crate` — even if we load this crate for macros, don't link it into the output.-->
   `extern crate` `no_link` -このクレートをマクロ用に読み込んでも、出力にリンクしないでください。

<!--See the [macros section of the first edition of the book](../book/first-edition/macros.html#scoping-and-macro-importexport) for more information on macro scope.-->
マクロスコープの詳細について[は、第1版](../book/first-edition/macros.html#scoping-and-macro-importexport)の[マクロセクションを](../book/first-edition/macros.html#scoping-and-macro-importexport)参照してください。

## <!--Miscellaneous attributes--> その他の属性

- <!--`export_name` -on statics and functions, this determines the name of the exported symbol.-->
   `export_name` -統計と関数で、これはエクスポートされたシンボルの名前を決定します。
- <!--`link_section` -on statics and functions, this specifies the section of the object file that this item's contents will be placed into.-->
   `link_section` -静的および機能上、このアイテムの内容が配置されるオブジェクトファイルのセクションを指定します。
- <!--`no_mangle` -on any item, do not apply the standard name mangling.-->
   `no_mangle` -どの項目でも、標準的な名前のmanglingを適用しないでください。
<!--Set the symbol for this item to its identifier.-->
   この項目のシンボルを識別子に設定します。

### <!--Deprecation--> 推奨されない

<!--The `deprecated` attribute marks an item as deprecated.-->
`deprecated`属性は、項目を非推奨としてマークします。
<!--It has two optional fields, `since` and `note`.-->
これは、2つの任意のフィールドを持っている`since`と`note`。

- <!--`since` expects a version number, as in `#[deprecated(since = "1.4.1")]`-->
   `#[deprecated(since = "1.4.1")]`ように、バージョン番号を期待する`since`、
    - <!--`rustc` doesn't know anything about versions, but external tools like `clippy` may check the validity of this field.-->
       `rustc`はバージョンについて何も知らないが、`clippy`ような外部ツールはこのフィールドの有効性をチェックするかもしれない。
- <!--`note` is a free text field, allowing you to provide an explanation about the deprecation and preferred alternatives.-->
   `note`はフリーテキストフィールドで、非推奨と推奨の選択肢について説明することができます。

<!--Only [public items](visibility-and-privacy.html) can be given the `#[deprecated]` attribute.-->
`#[deprecated]`属性は[公開アイテム](visibility-and-privacy.html)だけに指定できます。
<!--`#[deprecated]` on a module is inherited by all child items of that module.-->
`#[deprecated]`はそのモジュールのすべての子アイテムに継承されます。

<!--`rustc` will issue warnings on usage of `#[deprecated]` items.-->
`rustc`は`#[deprecated]`アイテムの使用に関する警告を出します。
<!--`rustdoc` will show item deprecation, including the `since` version and `note`, if available.-->
`rustdoc`は、使用可能な場合は、`since`バージョンと`note`を含む、アイテムの非推奨を表示します。

<!--Here's an example.-->
ここに例があります。

```rust
#[deprecated(since = "5.2", note = "foo was rarely used. Users should instead use bar")]
pub fn foo() {}

pub fn bar() {}
```

<!--The [RFC][1270-deprecation.md] contains motivations and more details.-->
[RFC][1270-deprecation.md]は動機と詳細が含まれています。

[1270-deprecation.md]: https://github.com/rust-lang/rfcs/blob/master/text/1270-deprecation.md

### <!--Documentation--> ドキュメンテーション

<!--The `doc` attribute is used to document items and fields.-->
`doc`属性は、項目と項目の文書化に使用されます。
<!--[Doc comments] are transformed into `doc` attributes.-->
[Doc comments]は、`doc`属性に変換されます。

<!--See [The Rustdoc Book] for reference material on this attribute.-->
この属性に関する参考資料については、[The Rustdoc Book]を参照してください。

### <!--Conditional compilation--> 条件付きコンパイル

<!--Sometimes one wants to have different compiler outputs from the same code, depending on build target, such as targeted operating system, or to enable release builds.-->
時には、対象のオペレーティングシステムなどのビルドターゲットに応じて、またはリリースビルドを有効にするために、同じコードから異なるコンパイラ出力を得たい場合があります。

<!--Configuration options are boolean (on or off) and are named either with a single identifier (eg `foo`) or an identifier and a string (eg `foo = "bar"`; the quotes are required and spaces around the `=` are unimportant).-->
設定オプションはブール値（onまたはoff）で、単一の識別子（例えば`foo`）または識別子と文字列（ `foo = "bar"`;引用符は必須で、 `=`周りのスペースは重要ではない）で指定されます。
<!--Note that similarly-named options, such as `foo`, `foo="bar"` and `foo="baz"` may each be set or unset independently.-->
`foo`、 `foo="bar"`、 `foo="baz"`などの同様の名前のオプションは、それぞれ独立して設定または設定解除できることに注意してください。

<!--Configuration options are either provided by the compiler or passed in on the command line using `--cfg` (eg `rustc main.rs --cfg foo --cfg 'bar="baz"'`).-->
設定オプションは、コンパイラによって提供されるか、コマンドラインで`--cfg`を使って`--cfg`（例えば、 `rustc main.rs --cfg foo --cfg 'bar="baz"'`）。
<!--Rust code then checks for their presence using the `#[cfg(...)]` attribute:-->
錆コードは`#[cfg(...)]`属性を使って存在をチェックします：

```rust
#// The function is only included in the build when compiling for macOS
// この関数は、macOS用にコンパイルするときにのみビルドに含まれます
#[cfg(target_os = "macos")]
fn macos_only() {
#  // ...
  // ...
}

#// This function is only included when either foo or bar is defined
// この関数は、fooまたはbarが定義されている場合にのみ含まれます
#[cfg(any(foo, bar))]
fn needs_foo_or_bar() {
#  // ...
  // ...
}

#// This function is only included when compiling for a unixish OS with a 32-bit
#// architecture
// この関数は、32ビットアーキテクチャのunixish OS用にコンパイルする場合にのみ含まれています
#[cfg(all(unix, target_pointer_width = "32"))]
fn on_32bit_unix() {
#  // ...
  // ...
}

#// This function is only included when foo is not defined
// この関数は、fooが定義されていない場合にのみインクルードされます
#[cfg(not(foo))]
fn needs_not_foo() {
#  // ...
  // ...
}
```

<!--This illustrates some conditional compilation can be achieved using the `#[cfg(...)]` attribute.-->
これは、`#[cfg(...)]`属性を使用して条件付きコンパイルを実現できることを示しています。
<!--`any`, `all` and `not` can be used to assemble arbitrarily complex configurations through nesting.-->
`any`、 `all`および`not`は、任意の複雑な構成を入れ子にして組み立てるために使用できます。

<!--The following configurations must be defined by the implementation:-->
実装では、次の設定を定義する必要があります。

* <!--`target_arch = "..."` -Target CPU architecture, such as `"x86"`, `"x86_64"` `"mips"`, `"powerpc"`, `"powerpc64"`, `"arm"`, or `"aarch64"`.-->
   `target_arch = "..."` -`"x86"`、 `"x86_64"` `"mips"`、 `"powerpc"`、 `"powerpc64"`、 `"arm"`、または`"aarch64"`などのターゲットCPUアーキテクチャ。
<!--This value is closely related to the first element of the platform target triple, though it is not identical.-->
   この値は、プラットフォームターゲットのトリプルの最初の要素と密接に関連していますが、同一ではありません。
* <!--`target_os = "..."` -Operating system of the target, examples include `"windows"`, `"macos"`, `"ios"`, `"linux"`, `"android"`, `"freebsd"`, `"dragonfly"`, `"bitrig"`, `"openbsd"` or `"netbsd"`.-->
   `target_os = "..."` -ターゲットのオペレーティングシステムの例は、`"windows"`、 `"macos"`、 `"ios"`、 `"linux"`、 `"android"`、 `"freebsd"`、 `"dragonfly"`、 `"bitrig"`、 `"openbsd"`または`"netbsd"`。
<!--This value is closely related to the second and third element of the platform target triple, though it is not identical.-->
   この値はプラットフォームターゲットのトリプルの2番目と3番目の要素と密接に関連していますが、同一ではありません。
* <!--`target_family = "..."` -Operating system family of the target, eg `"unix"` or `"windows"`.-->
   `target_family = "..."` -ターゲットのオペレーティングシステムファミリ。たとえば、`"unix"`または`"windows"`。
<!--The value of this configuration option is defined as a configuration itself, like `unix` or `windows`.-->
   この設定オプションの値は、`unix`や`windows`ような設定自体として定義され`windows`。
* <!--`unix` -See `target_family`.-->
   `unix` -`target_family`参照してください。
* <!--`windows` -See `target_family`.-->
   `windows` -`target_family`参照してください。
* <!--`target_env = ".."` -Further disambiguates the target platform with information about the ABI/libc.-->
   `target_env = ".."` -ターゲットプラットフォームのABI / libcに関する情報をさらに明確にします。
<!--Presently this value is either `"gnu"`, `"msvc"`, `"musl"`, or the empty string.-->
   現在のところ、この値は`"gnu"`、 `"msvc"`、 `"musl"`、または空文字列です。
<!--For historical reasons this value has only been defined as non-empty when needed for disambiguation.-->
   歴史的な理由から、この値は、曖昧さ回避のために必要な場合にのみ空でないと定義されています。
<!--Thus on many GNU platforms this value will be empty.-->
   したがって、多くのGNUプラットフォームでは、この値は空になります。
<!--This value is closely related to the fourth element of the platform target triple, though it is not identical.-->
   この値はプラットフォームターゲットのトリプルの4番目の要素と密接に関連していますが、同一ではありません。
<!--For example, embedded ABIs such as `gnueabihf` will simply define `target_env` as `"gnu"`.-->
   例えば、`gnueabihf`ような組み込みABIは単に`target_env`を`"gnu"`として定義します。
* <!--`target_endian = "..."` -Endianness of the target CPU, either `"little"` or `"big"`.-->
   `target_endian = "..."` -ターゲットCPUのエンディアン（`"little"`または`"big"`。
* <!--`target_pointer_width = "..."` -Target pointer width in bits.-->
   `target_pointer_width = "..."` -ターゲットポインタの幅（ビット単位）。
<!--This is set to `"32"` for targets with 32-bit pointers, and likewise set to `"64"` for 64-bit pointers.-->
   これは、32ビットポインタを持つターゲットでは`"32"`に設定され、同様に64ビットポインタでは`"64"`設定されます。
* <!--`target_has_atomic = "..."` -Set of integer sizes on which the target can perform atomic operations.-->
   `target_has_atomic = "..."` -ターゲットがアトミック操作を実行できる整数サイズのセット。
<!--Values are `"8"`, `"16"`, `"32"`, `"64"` and `"ptr"`.-->
   値は`"8"`、 `"16"`、 `"32"`、 `"64"`、 `"ptr"`です。
* <!--`target_vendor = "..."` -Vendor of the target, for example `apple`, `pc`, or simply `"unknown"`.-->
   `target_vendor = "..."` -ターゲットのベンダ`target_vendor = "..."`たとえば、`apple`、 `pc`、または単に`"unknown"`です。
* <!--`test` -Enabled when compiling the test harness (using the `--test` flag).-->
   `test` -テスト・ハーネスをコンパイルするときに有効になります（`--test`フラグを使用）。
* <!--`debug_assertions` -Enabled by default when compiling without optimizations.-->
   `debug_assertions` -最適化なしでコンパイルすると、デフォルトで有効になります。
<!--This can be used to enable extra debugging code in development but not in production.-->
   これを使用して、開発時に追加のデバッグコードを有効にできますが、本番環境では使用できません。
<!--For example, it controls the behavior of the standard library's `debug_assert!` macro.-->
   たとえば、標準ライブラリの`debug_assert!`マクロの動作を制御します。

<!--You can also set another attribute based on a `cfg` variable with `cfg_attr`:-->
`cfg_attr`を使用して`cfg`変数に基づいて別の属性を設定することもできます。

```rust,ignore
#[cfg_attr(a, b)]
```

<!--This is the same as `#[b]` if `a` is set by `cfg`, and nothing otherwise.-->
これは、`cfg`によって`a`が設定されている場合`a` `#[b]`と同じで、それ以外の場合は同じです。

<!--Lastly, configuration options can be used in expressions by invoking the `cfg!` macro: `cfg!(a)` evaluates to `true` if `a` is set, and `false` otherwise.-->
最後に、`cfg!`マクロを呼び出すことによって、式で設定オプションを使用できます`cfg!(a)`は、`a`が設定されて`true`場合は`true`、そうでない場合は`false`と評価され`true`。

### <!--Lint check attributes--> 糸くずチェック属性

<!--A lint check names a potentially undesirable coding pattern, such as unreachable code or omitted documentation, for the static entity to which the attribute applies.-->
糸くずチェックは、属性が適用される静的エンティティについて、潜在的に望ましくないコーディングパターン（到達不能コードまたは省略されたドキュメントなど）を指定します。

<!--For any lint check `C`:-->
任意の糸くんのチェック`C`：

* <!--`allow(C)` overrides the check for `C` so that violations will go unreported,-->
   `allow(C)`は`C`のチェックを無効にし、違反が報告されないようにします。
* <!--`deny(C)` signals an error after encountering a violation of `C`,-->
   `deny(C)`は`C`違反に遭遇した後にエラーを通知し、
* <!--`forbid(C)` is the same as `deny(C)`, but also forbids changing the lint level afterwards,-->
   `forbid(C)`は`deny(C)`と同じですが、後に糸くずのレベルを変更することも禁じます。
* <!--`warn(C)` warns about violations of `C` but continues compilation.-->
   `warn(C)`は`C`違反について警告しますが、コンパイルを続けます。

<!--The lint checks supported by the compiler can be found via `rustc -W help`, along with their default settings.-->
コンパイラがサポートしている糸くずチェックは、`rustc -W help`とそのデフォルト設定で見つけることができます。
<!--[Compiler plugins][unstable%20book%20plugin] can provide additional lint checks.-->
[Compiler plugins][unstable%20book%20plugin]は追加のlintチェックを提供できます。

```rust
pub mod m1 {
#    // Missing documentation is ignored here
    // 不足しているドキュメントはここでは無視されます
    #[allow(missing_docs)]
    pub fn undocumented_one() -> i32 { 1 }

#    // Missing documentation signals a warning here
    // 不足しているドキュメントはここに警告を出します
    #[warn(missing_docs)]
    pub fn undocumented_too() -> i32 { 2 }

#    // Missing documentation signals an error here
    // 不足しているドキュメントはここでエラーを通知します
    #[deny(missing_docs)]
    pub fn undocumented_end() -> i32 { 3 }
}
```

<!--This example shows how one can use `allow` and `warn` to toggle a particular check on and off:-->
この例では、`allow`と`warn`を使用して特定のチェックをオンとオフに切り替える方法を示します。

```rust
#[warn(missing_docs)]
pub mod m2{
    #[allow(missing_docs)]
    pub mod nested {
#        // Missing documentation is ignored here
        // 不足しているドキュメントはここでは無視されます
        pub fn undocumented_one() -> i32 { 1 }

#        // Missing documentation signals a warning here,
#        // despite the allow above.
        // 不足しているドキュメントは、上記の許可にもかかわらず、ここに警告を出します。
        #[warn(missing_docs)]
        pub fn undocumented_two() -> i32 { 2 }
    }

#    // Missing documentation signals a warning here
    // 不足しているドキュメントはここに警告を出します
    pub fn undocumented_too() -> i32 { 3 }
}
```

<!--This example shows how one can use `forbid` to disallow uses of `allow` for that lint check:-->
次の例は、forbidを使用してそのlintチェックに対して`allow`使用を`forbid`する方法を示しています。

```rust,compile_fail
#[forbid(missing_docs)]
pub mod m3 {
#    // Attempting to toggle warning signals an error here
    // 警告信号の切り替えをここで試みる
    #[allow(missing_docs)]
#//    /// Returns 2.
    ///  2を返します。
    pub fn undocumented_too() -> i32 { 2 }
}
```

#### <!--`must_use` Attribute--> `must_use`属性

<!--The `must_use` attribute can be used on user-defined composite types ([`struct` s][struct], [`enum` s][enum], and [`union` s][union]) and [functions].-->
`must_use`属性は、ユーザー定義コンポジット型（[`struct` s][struct]、 [`enum` s][enum]、および[`union` s][union]）および[functions]。

<!--When used on user-defined composite types, if the [expression] of an [expression statement] has that type, then the `unused_must_use` lint is violated.-->
ユーザー定義コンポジット型で使用する場合、[expression]の[expression statement]にその型がある場合、`unused_must_use` lintが違反されます。

```rust
#[must_use]
struct MustUse {
#  // some fields
  // いくつかのフィールド
}

# impl MustUse {
#   fn new() -> MustUse { MustUse {} }
# }
#
fn main() {
#  // Violates the `unused_must_use` lint.
  //  `unused_must_use` lintに違反します。
  MustUse::new();
}
```

<!--When used on a function, if the [expression] of an [expression statement] is a [call expression] to that function, then the `unused_must_use` lint is violated.-->
関数で使用[expression]と、[expression statement] [call expression]がその関数の[call expression]である場合、`unused_must_use` lintが違反されます。
<!--The exceptions to this is if the return type of the function is `()`, `!`, or a [zero-variant enum], in which case the attribute does nothing.-->
関数の戻り値の型がある場合は、この例外はある`()` `!`、または[zero-variant enum]属性は何もしません、その場合には、。

```rust
#[must_use]
fn five() -> i32 { 5i32 }

fn main() {
#  // Violates the unused_must_use lint.
  //  unused_must_use lintに違反します。
  five();
}
```

<!--When used on a function in a trait declaration, then the behavior also applies when the call expression is a function from an implementation of the trait.-->
特性宣言の関数で使用すると、呼び出し式が特性の実装からの関数である場合にも動作が適用されます。

```rust
trait Trait {
  #[must_use]
  fn use_me(&self) -> i32;
}

impl Trait for i32 {
  fn use_me(&self) -> i32 { 0i32 }
}

fn main() {
#  // Violates the `unused_must_use` lint.
  //  `unused_must_use` lintに違反します。
  5i32.use_me();
}
```

<!--When used on a function in an implementation, the attribute does nothing.-->
実装内の関数で使用すると、属性は何も行いません。

> <!--Note: Trivial no-op expressions containing the value will not violate the lint.-->
> 注意：値を含む簡単なノーオペレーション式はlintに違反しません。
> <!--Examples include wrapping the value in a type that does not implement [`Drop`] and then not using that type and being the final expression of a [block expression] that is not used.-->
> 例としては、[`Drop`]を実装していない型に値をラップし、その型を使用せず、使用されていない[block expression]最終式になり[block expression]。
> 
> ```rust
> #[must_use]
> fn five() -> i32 { 5i32 }
> 
> fn main() {
> #  // None of these violate the unused_must_use lint.
>   // いずれもunused_must_use lintに違反しません。
>   (five(),);
>   Some(five());
>   { five() };
>   if true { five() } else { 0i32 };
>   match true {
>     _ => five()
>   };
> }
> ```

> <!--Note: It is idiomatic to use a [let statement] with a pattern of `_` when a must-used value is purposely discarded.-->
> 注意：使用する必要のある値が意図的に破棄された場合は、`_`パターンを持つ[let statement]を使用するのは慣用的です。
> 
> ```rust
> #[must_use]
> fn five() -> i32 { 5i32 }
> 
> fn main() {
> #  // Does not violate the unused_must_use lint.
>   //  unused_must_use lintに違反しない。
>   let _ = five();
> }
> ```

<!--The `must_use` attribute may also include a message by using `#[must_use = "message"]`.-->
`must_use`属性には、`#[must_use = "message"]`を使用してメッセージを含めることも`must_use`ます。
<!--The message will be given alongside the warning.-->
メッセージは警告の横に表示されます。

### <!--Inline attribute--> インライン属性

<!--The inline attribute suggests that the compiler should place a copy of the function or static in the caller, rather than generating code to call the function or access the static where it is defined.-->
インラインアトリビュートは、関数を呼び出すコードを生成するのではなく、定義されている静的にアクセスするコードを生成するのではなく、コンパイラがファンクションまたは静的なコピーを呼び出し側に配置する必要があることを示します。

<!--The compiler automatically inlines functions based on internal heuristics.-->
コンパイラは、内部ヒューリスティックに基づいて関数を自動的にインライン化します。
<!--Incorrectly inlining functions can actually make the program slower, so it should be used with care.-->
誤ってインライン関数をインライン化すると、実際にはプログラムが遅くなる可能性があるため、注意して使用する必要があります。

<!--`#[inline]` and `#[inline(always)]` always cause the function to be serialized into the crate metadata to allow cross-crate inlining.-->
`#[inline]`と`#[inline(always)]`常に関数をクロスレットメタデータにシリアル化してクロスクレーンインライン化を可能にします。

<!--There are three different types of inline attributes:-->
インライン属性には3つの異なるタイプがあります。

* <!--`#[inline]` hints the compiler to perform an inline expansion.-->
   `#[inline]`はインライン展開を行うためのコンパイラを示します。
* <!--`#[inline(always)]` asks the compiler to always perform an inline expansion.-->
   `#[inline(always)]`は、常にインライン展開を実行するようコンパイラーに指示します。
* <!--`#[inline(never)]` asks the compiler to never perform an inline expansion.-->
   `#[inline(never)]`は、コンパイラに対してインライン展開を行わないように要求します。

### `derive`
<!--The `derive` attribute allows certain traits to be automatically implemented for data structures.-->
`derive`属性により、データ構造に対して特定の特性を自動的に実装することができます。
<!--For example, the following will create an `impl` for the `PartialEq` and `Clone` traits for `Foo`, the type parameter `T` will be given the `PartialEq` or `Clone` constraints for the appropriate `impl`:-->
たとえば、次の例では、`Foo` `PartialEq`および`Clone`特性の`impl`を作成します。型パラメータ`T`は、適切な`impl` `PartialEq`または`Clone`制約が与えられます。

```rust
#[derive(PartialEq, Clone)]
struct Foo<T> {
    a: i32,
    b: T,
}
```

<!--The generated `impl` for `PartialEq` is equivalent to-->
`PartialEq`の生成された`impl`は、

```rust
# struct Foo<T> { a: i32, b: T }
impl<T: PartialEq> PartialEq for Foo<T> {
    fn eq(&self, other: &Foo<T>) -> bool {
        self.a == other.a && self.b == other.b
    }

    fn ne(&self, other: &Foo<T>) -> bool {
        self.a != other.a || self.b != other.b
    }
}
```

<!--You can implement `derive` for your own type through [procedural macros].-->
[procedural macros]型[procedural macros]して、独自の型を`derive`さ`derive`ことができ[procedural macros]。

<!--[Doc comments]: comments.html#doc-comments
 [The Rustdoc Book]: ../rustdoc/the-doc-attribute.html
 [procedural macros]: procedural-macros.html
 [struct]: items/structs.html
 [enum]: items/enumerations.html
 [union]: items/unions.html
 [functions]: items/functions.html
 [expression]: expressions.html
 [expression statement]: statements.html#expression-statements
 [call expression]: expressions/call-expr.html
 [block expression]: expressions/block-expr.html
 [block expressions]: expressions/block-expr.html
 [`Drop`]: special-types-and-traits.html#drop
 [let statement]: statements.html#let-statements
 [unstable book plugin]: ../unstable-book/language-features/plugin.html#lint-plugins
 [zero-variant enum]: items/enumerations.html#zero-variant-enums
 [ECMA-334]: https://www.ecma-international.org/publications/standards/Ecma-334.htm
 [ECMA-335]: https://www.ecma-international.org/publications/standards/Ecma-335.htm
 [item declarations]: items.html
 [generics]: items/generics.html
 [implementations]: items/implementations.html
 [modules]: items/modules.html
 [statements]: statements.html
 [match expressions]: expressions/match-expr.html
 [external blocks]: items/external-blocks.html
-->
[Doc comments]: comments.html#doc-comments
 [The Rustdoc Book]: ../rustdoc/the-doc-attribute.html
 [procedural macros]: procedural-macros.html
 [struct]: items/structs.html
 [enum]: items/enumerations.html
 [union]: items/unions.html
 [functions]: items/functions.html
 [expression]: expressions.html
 [expression statement]: statements.html#expression-statements
 [call expression]: expressions/call-expr.html
 [block expression]: expressions/block-expr.html
 [block expressions]: expressions/block-expr.html
 [`Drop`]: special-types-and-traits.html#drop
 [let statement]: statements.html#let-statements
 [unstable book plugin]: ../unstable-book/language-features/plugin.html#lint-plugins
 [zero-variant enum]: items/enumerations.html#zero-variant-enums
 [ECMA-334]: https://www.ecma-international.org/publications/standards/Ecma-334.htm
 [ECMA-335]: https://www.ecma-international.org/publications/standards/Ecma-335.htm
 [item declarations]: items.html
 [generics]: items/generics.html
 [implementations]: items/implementations.html
 [modules]: items/modules.html
 [statements]: statements.html
 [match expressions]: expressions/match-expr.html
 [external blocks]: items/external-blocks.html

