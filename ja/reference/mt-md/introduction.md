# <!--Introduction--> 前書き

<!--This document is the primary reference for the Rust programming language.-->
このドキュメントはRustプログラミング言語の主要なリファレンスです。
<!--It provides three kinds of material:-->
それは3種類の素材を提供します：

  - <!--Chapters that informally describe each language construct and their use.-->
     各言語の構成とその使用法を非公式に記述する章。
  - <!--Chapters that informally describe the memory model, concurrency model, runtime services, linkage model and debugging facilities.-->
     メモリモデル、同時実行モデル、ランタイムサービス、リンケージモデル、デバッグ機能を非形式的に説明する章。
  - <!--Appendix chapters providing rationale and references to languages that influenced the design.-->
     付録の章では、設計に影響を与えた言語の根拠と参照を提供しています。

<!--This document does not serve as an introduction to the language.-->
このドキュメントは、言語の紹介としては機能しません。
<!--Background familiarity with the language is assumed.-->
言語の背景知識があると仮定します。
<!--A separate [book] is available to help acquire such background familiarity.-->
このような背景知識を得るために、別冊の[book]が用意されています。

<!--This document also does not serve as a reference to the [standard] library included in the language distribution.-->
また、このドキュメントは、言語の配布に含まれる[standard]ライブラリへの参照としても機能しません。
<!--Those libraries are documented separately by extracting documentation attributes from their source code.-->
これらのライブラリは、ソースコードからドキュメンテーション属性を抽出することによって個別に文書化されています。
<!--Many of the features that one might expect to be language features are library features in Rust, so what you're looking for may be there, not here.-->
言語機能と期待される機能の多くは、Rustのライブラリ機能であるため、探しているものがそこにあるかもしれません。

<!--This document also only serves as a reference to what is available in stable Rust.-->
この文書はまた、安定した錆で利用できるものへの参照としてのみ役立ちます。
<!--For unstable features being worked on, see the [Unstable Book].-->
不安定な機能については、[Unstable Book]参照してください。
<!--This was a recent change in scope, so unstable features are still documented, but are in the process of being removed.-->
これは最近の範囲の変更であり、不安定な機能はまだ文書化されていますが、削除されつつあります。

<!--Finally, this document is not normative.-->
最後に、この文書は規範的ではありません。
<!--It may include details that are specific to `rustc` itself, and should not be taken as a specification for the Rust language.-->
それには`rustc`固有の詳細が含まれている可能性があり、Rust言語の仕様として取り上げるべきではありません。
<!--We intend to produce such a document someday, but this is what we have for now.-->
私たちはいつかそのような文書を作りたいと思っていますが、これは私たちが現在持っているものです。

<!--You may also be interested in the [grammar].-->
また、[grammar]興味があるかもしれません。

<!--You can contribute to this document by opening an issue or sending a pull request to [the Rust Reference repository].-->
問題を開いたり[the Rust Reference repository]プルリクエストを送信して、このドキュメントに貢献することができ[the Rust Reference repository]。

<!--NB This document may be incomplete.-->
注意この文書は不完全である可能性があります。
<!--Documenting everything might take a while.-->
すべてを文書化するのに時間がかかることがあります。
<!--We have a [big issue] to track documentation for every Rust feature, so check that out if you can't find something here.-->
すべてのRust機能のドキュメントを追跡する[big issue]がありますので、ここで何かを見つけることができない場合は、それを確認してください。

<!--[book]: ../book/index.html
 [standard]: ../std/index.html
 [grammar]: ../grammar.html
 [the Rust Reference repository]: https://github.com/rust-lang-nursery/reference/
 [big issue]: https://github.com/rust-lang-nursery/reference/issues/9
 [Unstable Book]: https://doc.rust-lang.org/nightly/unstable-book/
-->
[book]: ../book/index.html
 [standard]: ../std/index.html
 [grammar]: ../grammar.html
 [the Rust Reference repository]: https://github.com/rust-lang-nursery/reference/
 [big issue]: https://github.com/rust-lang-nursery/reference/issues/9
 [Unstable Book]: https://doc.rust-lang.org/nightly/unstable-book/

