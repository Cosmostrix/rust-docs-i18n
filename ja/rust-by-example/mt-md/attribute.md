# <!--Attributes--> 属性

<!--An attribute is metadata applied to some module, crate or item.-->
属性は、一部のモジュール、クレート、またはアイテムに適用されるメタデータです。
<!--This metadata can be used to/for:-->
このメタデータは、次の目的で/使用できます。

<!-- TODO: Link these to their respective examples -->

* <!--[conditional compilation of code][cfg]-->
   [コードの条件付きコンパイル][cfg]
* <!--[set crate name, version and type (binary or library)][crate]-->
   [バージョンとタイプ（バイナリまたはライブラリ）を設定する][crate]
* <!--disable [lints][lint] (warnings)-->
   [lints][lint]無効にする（警告）
* <!--enable compiler features (macros, glob imports, etc.)-->
   コンパイラ機能を有効にする（マクロ、globインポートなど）
* <!--link to a foreign library-->
   外国図書館へのリンク
* <!--mark functions as unit tests-->
   ユニットテストとしてのマーク機能
* <!--mark functions that will be part of a benchmark-->
   ベンチマークの一部となる機能をマークする

<!--When attributes apply to a whole crate, their syntax is `#![crate_attribute]`, and when they apply to a module or item, the syntax is `#[item_attribute]` (notice the missing bang `!`).-->
属性は全体のクレートに適用された場合、その構文は次のとおりです。`#![crate_attribute]`、そして、彼らはモジュールまたはアイテムに適用する場合、構文は次のとおりです。 `#[item_attribute]`欠落しているビッグバン気づく`!`）。

<!--Attributes can take arguments with different syntaxes:-->
属性は異なる構文で引数を取ることができます：

* `#[attribute = "value"]`
* `#[attribute(key = "value")]`
* `#[attribute(value)]`

<!--Attributes can have multiple values and can be separated over multiple lines, too:-->
属性は複数の値を持つことができ、複数の行に分けることもできます。

```rust,ignore
#[attribute(value, value2)]


#[attribute(value, value2, value3,
            value4, value5)]
```

<!--[cfg]: attribute/cfg.html
 [crate]: attribute/crate.html
 [lint]: https://en.wikipedia.org/wiki/Lint_%28software%29
-->
[cfg]: attribute/cfg.html
 [crate]: attribute/crate.html
 [lint]: https://en.wikipedia.org/wiki/Lint_%28software%29

