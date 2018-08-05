# <!--Debuggability--> デバッグ可能性


<span id="c-debug"></span><!--## All public types implement `Debug` (C-DEBUG)-->
すべてのpublicタイプは`Debug`（C-DEBUG）を実装しています。

<!--If there are exceptions, they are rare.-->
例外がある場合、それらはまれです。


<span id="c-debug-nonempty"></span><!--## `Debug` representation is never empty (C-DEBUG-NONEMPTY)-->
## `Debug`表現は決して空ではありません（C-DEBUG-NONEMPTY）

<!--Even for conceptually empty values, the `Debug` representation should never be empty.-->
概念的に空の値であっても、`Debug`表現は決して空ではありません。

```rust
let empty_str = "";
assert_eq!(format!("{:?}", empty_str), "\"\"");

let empty_vec = Vec::<bool>::new();
assert_eq!(format!("{:?}", empty_vec), "[]");
```
