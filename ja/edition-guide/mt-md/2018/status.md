# <!--Rust 2018 Feature Status--> Rust 2018機能のステータス

## <!--Language--> 言語

<!--[Shipped, 1.26]: https://blog.rust-lang.org/2018/05/10/Rust-1.26.html
 [Shipped, 1.27]: https://blog.rust-lang.org/2018/06/21/Rust-1.27.html
-->
[Shipped, 1.26]: https://blog.rust-lang.org/2018/05/10/Rust-1.26.html
 [Shipped, 1.27]: https://blog.rust-lang.org/2018/06/21/Rust-1.27.html


<!--[`impl Trait`]: 2018/transitioning/traits/impl-trait.html
 [Basic slice patterns]: 2018/transitioning/slice-patterns.html
 [Default match bindings]: 2018/transitioning/ownership-and-lifetimes/default-match-bindings.html
 [Anonymous lifetimes]: 2018/transitioning/ownership-and-lifetimes/anonymous-lifetime.html
 [relnotes_1.26]: https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1260-2018-05-10
 [`dyn Trait`]: 2018/transitioning/traits/dyn-trait.html
 [`?` in `main`/tests]: 2018/transitioning/errors/question-mark.html
 [Module system path changes]: 2018/transitioning/modules/path-clarity.html
 [issue#44660]: https://github.com/rust-lang/rust/issues/44660
 [Import macros via `use`]: 2018/transitioning/modules/macros.html
 [issue#35896]: https://github.com/rust-lang/rust/issues/35896
 [In-band lifetimes]: 2018/transitioning/ownership-and-lifetimes/in-band-lifetimes.html
 [issue#44524]: https://github.com/rust-lang/rust/issues/44524
 [Lifetime elision in `impl`s]: 2018/transitioning/ownership-and-lifetimes/lifetime-elision-in-impl.html
 [Raw identifiers]: 2018/transitioning/raw-identifiers.html
 [issue#48589]: https://github.com/rust-lang/rust/issues/48589
 [nll_status]: http://smallcultfollowing.com/babysteps/blog/2018/06/15/mir-based-borrow-check-nll-status-update/
 [`T: 'a` inference in `struct`s]: 2018/transitioning/ownership-and-lifetimes/struct-inference.html
 [issue#44493]: https://github.com/rust-lang/rust/issues/44493
 [`async`/`await`]: 2018/transitioning/concurrency/async-await.html
 [issue#50547]: https://github.com/rust-lang/rust/issues/50547
-->
[`impl Trait`]: 2018/transitioning/traits/impl-trait.html
 [Basic slice patterns]: 2018/transitioning/slice-patterns.html
 [Default match bindings]: 2018/transitioning/ownership-and-lifetimes/default-match-bindings.html
 [Anonymous lifetimes]: 2018/transitioning/ownership-and-lifetimes/anonymous-lifetime.html
 [relnotes_1.26]: https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1260-2018-05-10
 [`dyn Trait`]: 2018/transitioning/traits/dyn-trait.html
 [`?` in `main`/tests]: 2018/transitioning/errors/question-mark.html
 [Module system path changes]: 2018/transitioning/modules/path-clarity.html
 [issue#44660]: https://github.com/rust-lang/rust/issues/44660
 [Import macros via `use`]: 2018/transitioning/modules/macros.html
 [issue#35896]: https://github.com/rust-lang/rust/issues/35896
 [In-band lifetimes]: 2018/transitioning/ownership-and-lifetimes/in-band-lifetimes.html
 [issue#44524]: https://github.com/rust-lang/rust/issues/44524
 [Lifetime elision in `impl`s]: 2018/transitioning/ownership-and-lifetimes/lifetime-elision-in-impl.html
 [issue#44524]: https://github.com/rust-lang/rust/issues/44524
 [Lifetime elision in `impl`s]: 2018/transitioning/ownership-and-lifetimes/lifetime-elision-in-impl.html
 [Raw identifiers]: 2018/transitioning/raw-identifiers.html
 [issue#48589]: https://github.com/rust-lang/rust/issues/48589
 [nll_status]: http://smallcultfollowing.com/babysteps/blog/2018/06/15/mir-based-borrow-check-nll-status-update/
 [`T: 'a` inference in `struct`s]: 2018/transitioning/ownership-and-lifetimes/struct-inference.html
 [issue#48589]: https://github.com/rust-lang/rust/issues/48589
 [nll_status]: http://smallcultfollowing.com/babysteps/blog/2018/06/15/mir-based-borrow-check-nll-status-update/
 [issue#48589]: https://github.com/rust-lang/rust/issues/48589
 [`T: 'a` inference in `struct`s]: 2018/transitioning/ownership-and-lifetimes/struct-inference.html
 [issue#44493]: https://github.com/rust-lang/rust/issues/44493
 [`async`/`await`]: 2018/transitioning/concurrency/async-await.html
 [issue#50547]: https://github.com/rust-lang/rust/issues/50547


|<!--**Feature**-->**特徴**|<!--**Status**-->**状態**|<!--**Minimum Edition**-->**ミニマムエディション**|
|<!--------------->-----------|<!-------------->----------|<!------------------------------>--------------------------|
|[`impl Trait`]|[Shipped, 1.26]|<!--2015-->2015年|
|[Basic slice patterns]|[Shipped, 1.26]|<!--2015-->2015年|
|[Default match bindings]|[Shipped, 1.26]|<!--2015-->2015年|
|[Anonymous lifetimes]|<!--[Shipped, 1.26][relnotes_1.26]-->[出荷、1.26][relnotes_1.26]|<!--2015-->2015年|
|[`dyn Trait`]|[Shipped, 1.27]|<!--2015-->2015年|
|<!--SIMD support-->SIMDサポート|[Shipped, 1.27]|<!--2015-->2015年|
|[`?` in `main`/tests]|<!--[Shipping, 1.26][Shipped,%201.26] and 1.28-->[出荷、1.26][Shipped,%201.26]および1.28|<!--2015-->2015年|
|[In-band lifetimes]|<!--Unstable;-->不安定な;<!--[tracking issue][issue#44524]-->[追跡の問題][issue#44524]|<!--2015-->2015年|
|[Lifetime elision in `impl`s]|<!--Unstable;-->不安定な;<!--[tracking issue][issue#44524]-->[追跡の問題][issue#44524]|<!--2015-->2015年|
|<!--Non-lexical lifetimes-->非語彙的な生涯|<!--[Implemented but not ready for preview][nll_status]-->[プレビュー用に実装されています][nll_status]|<!--2015-->2015年|
|[`T: 'a` inference in `struct`s]|<!--Unstable;-->不安定な;<!--[tracking issue][issue#44493]-->[追跡の問題][issue#44493]|<!--2015-->2015年|
|[Raw identifiers]|<!--Unstable;-->不安定な;<!--[tracking issue][issue#48589]-->[追跡の問題][issue#48589]|<!--?-->？|
|[Import macros via `use`]|<!--Unstable;-->不安定な;<!--[tracking issue][issue#35896]-->[追跡の問題][issue#35896]|<!--?-->？|
|[Module system path changes]|<!--Unstable;-->不安定な;<!--[tracking issue][issue#44660]-->[追跡の問題][issue#44660]|<!--2018-->2018年|
|[`async`/`await`]|<!--[Not fully implemented][issue#50547]-->[完全に実装されていない][issue#50547]|<!--2018-->2018年|

<!--While some of these features are already available in Rust 2015, they are tracked here because they are being promoted as part of the Rust 2018 edition.-->
これらの機能の一部はすでにRust 2015で利用可能ですが、Rust 2018エディションの一部としてプロモートされているため、ここで追跡しています。
<!--Accordingly, they will be discussed in subsequent sections of this guide book.-->
したがって、このガイドブックの次のセクションで説明します。
<!--The features marked as "Shipped"are all available today in stable Rust, so you can start using them right now!-->
「発送済み」とマークされた機能は、今日はすべて安定した錆で利用できるため、今すぐ使用することができます！

## <!--Standard library--> 標準ライブラリ

[issue#49668]: https://github.com/rust-lang/rust/issues/49668

|<!--**Feature**-->**特徴**|<!--**Status**-->**状態**|
|<!--------------->-----------|<!-------------->----------|
|<!--[Custom global allocators][issue#49668]-->[カスタムグローバルアロケータ][issue#49668]|<!--Will ship in 1.28-->1.28で出荷予定|

## <!--Tooling--> ツーリング

<!--[RLS]: https://github.com/rust-lang-nursery/rls
 [1.0 milestone]: https://github.com/rust-lang-nursery/rls/milestone/7
 [rustfmt]: https://github.com/rust-lang-nursery/rustfmt
 [style guide RFC]: https://github.com/rust-lang/rfcs/pull/2436
 [stability RFC]: https://github.com/rust-lang/rfcs/pull/2437
 [Clippy]: https://github.com/rust-lang-nursery/rust-clippy
 [RFC#2476]: https://github.com/rust-lang/rfcs/pull/2476
-->
[RLS]: https://github.com/rust-lang-nursery/rls
 [1.0 milestone]: https://github.com/rust-lang-nursery/rls/milestone/7
 [rustfmt]: https://github.com/rust-lang-nursery/rustfmt
 [style guide RFC]: https://github.com/rust-lang/rfcs/pull/2436
 [stability RFC]: https://github.com/rust-lang/rfcs/pull/2437
 [Clippy]: https://github.com/rust-lang-nursery/rust-clippy
 [RFC#2476]: https://github.com/rust-lang/rfcs/pull/2476


|<!--**Tool**-->**ツール**|<!--**Status**-->**状態**|
|<!--------------->-----------|<!-------------->----------|
|<!--[RLS] 1.0-->[RLS] 1.0|<!--Feature-complete;-->フィーチャーコンプリート;<!--see [1.0 milestone]-->[1.0 milestone]参照|
|<!--[rustfmt] 1.0-->[rustfmt] 1.0|<!--Finalizing spec;-->仕様を完成させる。<!--[1.0 milestone](https://github.com/rust-lang-nursery/rustfmt/milestone/2), [style guide RFC], [stability RFC]-->[1.0マイルストーン](https://github.com/rust-lang-nursery/rustfmt/milestone/2)、 [style guide RFC]、 [stability RFC]|
|<!--[Clippy] 1.0-->[Clippy] 1.0|[RFC][RFC#2476]|

## <!--Documentation--> ドキュメンテーション

<!--[Edition Guide]: https://rust-lang-nursery.github.io/edition-guide/
 [TRPL]: https://github.com/rust-lang/book/
-->
[Edition Guide]: https://rust-lang-nursery.github.io/edition-guide/
 [TRPL]: https://github.com/rust-lang/book/


|<!--**Tool**-->**ツール**|<!--**Status**-->**状態**|
|<!--------------->-----------|<!-------------->----------|
|[Edition Guide]|<!--Initial draft complete-->初期ドラフト完了|
|[TRPL]|<!--Updated as features stabilize-->機能が安定して更新されました|

## <!--Web site--> ウェブサイト

<!--The visual design is being finalized, and early rounds of content brainstorming are complete.-->
ビジュアルデザインが完成し、初期のコンテンツブレインストーミングが完了しました。
