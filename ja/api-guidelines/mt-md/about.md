# <!--Rust API Guidelines--> 錆APIガイドライン

<!--This is a set of recommendations on how to design and present APIs for the Rust programming language.-->
これは、Rustプログラミング言語用のAPIを設計して提示する方法に関する推奨事項です。
<!--They are authored largely by the Rust library team, based on experiences building the Rust standard library and other crates in the Rust ecosystem.-->
彼らは、Rust標準ライブラリとRustエコシステムの他の箱を構築した経験に基づいて、Rustライブラリチームによって主に執筆されています。

<!--These are only guidelines, some more firm than others.-->
これらはガイドラインに過ぎず、他のものよりも堅牢です。
<!--In some cases they are vague and still in development.-->
場合によっては、それらはあいまいであり、まだ開発中です。
<!--Rust crate authors should consider them as a set of important considerations in the development of idiomatic and interoperable Rust libraries, to use as they see fit.-->
Rust crateの作者は、慣用的で相互運用性のあるRustライブラリの開発における重要な考慮事項の1つとして、適切と思われるものを使用するよう考慮する必要があります。
<!--These guidelines should not in any way be considered a mandate that crate authors must follow, though they may find that crates that conform well to these guidelines integrate better with the existing crate ecosystem than those that do not.-->
これらのガイドラインは、クレート作者が従わなければならない命令とはみなされるべきではありませんが、これらのガイドラインに適合するクレートは既存のクレート生態系とうまく統合されません。

<!--This book is organized in two parts: the concise [checklist] of all individual guidelines, suitable for quick scanning during crate reviews;-->
この本は、2つの部分で構成されています。個々のガイドラインの簡潔な[checklist]で、クレートレビュー中のクイックスキャンに適しています。
<!--and topical chapters containing explanations of the guidelines in detail.-->
ガイドラインの説明が詳細に記載されたトピック別の章があります。

<!--If you are interested in contributing to the API guidelines, check out [contributing.md] and join our [Gitter channel].-->
あなたはAPIのガイドラインへの貢献に興味がある場合は、チェックアウト[contributing.md]、私たちの参加[Gitter channel]。

<!--[checklist]: checklist.html
 [contributing.md]: https://github.com/rust-lang-nursery/api-guidelines/blob/master/CONTRIBUTING.md
 [Gitter channel]: https://gitter.im/rust-impl-period/WG-libs-guidelines
-->
[checklist]: checklist.html
 [contributing.md]: https://github.com/rust-lang-nursery/api-guidelines/blob/master/CONTRIBUTING.md
 [Gitter channel]: https://gitter.im/rust-impl-period/WG-libs-guidelines

