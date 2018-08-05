# <!--Build Time Tooling--> ビルド時間ツール

<!--This section covers "build-time"tooling, or code that is run prior to compiling a crate's source code.-->
このセクションでは、"ビルドタイム"ツール、またはクレートのソースコードをコンパイルする前に実行されるコードについて説明します。
<!--Conventionally, build-time code lives in a **build.rs** file and is commonly referred to as a "build script".-->
従来、ビルドタイムコードは**build.rs**ファイルにあり、一般に「ビルドスクリプト」と呼ばれていました。
<!--Common use cases include rust code generation and compilation of bundled C/C++/asm code.-->
一般的な使用例には、錆コード生成とバンドルされたC / C ++ / asmコードのコンパイルが含まれます。
<!--See crates.io's [documentation on the matter][build-script-docs] for more information.-->
詳細について[は、この問題に関する][build-script-docs] crates.ioの[ドキュメントを][build-script-docs]参照してください。

<!--{{#include build_tools/cc-bundled-static.md}}-->
{{#include build_tools / cc-bundled-static.md}}

<!--{{#include build_tools/cc-bundled-cpp.md}}-->
{{#include build_tools / cc-bundled-cpp.md}}

<!--{{#include build_tools/cc-defines.md}}-->
{{#include build_tools / cc-defines.md}}

<!--{{#include../links.md}}-->
{{#include../links.md}}

[build-script-docs]: http://doc.crates.io/build-script.html
