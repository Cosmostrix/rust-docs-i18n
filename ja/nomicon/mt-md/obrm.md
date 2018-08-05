# <!--The Perils Of Ownership Based Resource Management (OBRM)--> 所有権ベースの資源管理（OBRM）の危機

<!--OBRM (AKA RAII: Resource Acquisition Is Initialization) is something you'll interact with a lot in Rust.-->
OBRM（AKA RAII：Resource Acquisition Is Initialization）は、あなたがRustで多くのことをやりとりするものです。
<!--Especially if you use the standard library.-->
特に標準ライブラリを使用している場合。

<!--Roughly speaking the pattern is as follows: to acquire a resource, you create an object that manages it.-->
おおまかに言えば、パターンは次のとおりです。リソースを取得するには、リソースを管理するオブジェクトを作成します。
<!--To release the resource, you simply destroy the object, and it cleans up the resource for you.-->
リソースを解放するには、単にオブジェクトを破棄し、リソースをクリーンアップします。
<!--The most common "resource"this pattern manages is simply *memory*.-->
このパターンが管理する最も一般的な「リソース」は、単に*メモリ*です。
<!--`Box`, `Rc`, and basically everything in `std::collections` is a convenience to enable correctly managing memory.-->
`Box`、 `Rc`、そして基本的には`std::collections`すべてが、メモリを正しく管理できるように便利です。
<!--This is particularly important in Rust because we have no pervasive GC to rely on for memory management.-->
これはメモリ管理に頼るべき普及したGCがないため、Rustでは特に重要です。
<!--Which is the point, really: Rust is about control.-->
それは本当にポイントです：錆は制御についてです。
<!--However we are not limited to just memory.-->
しかし、私たちは記憶に限られていません。
<!--Pretty much every other system resource like a thread, file, or socket is exposed through this kind of API.-->
スレッド、ファイル、またはソケットのような他のシステムリソースは、この種のAPIを通じて公開されています。
