# <!--Summary--> 概要

- <!--[About this guide](./about-this-guide.md)-->
   [このガイドについて](./about-this-guide.md)
- <!--[How to build the compiler and run what you built](./how-to-build-and-run.md)-->
   [コンパイラをビルドし、ビルドしたものを実行する方法](./how-to-build-and-run.md)
- <!--[Coding conventions](./conventions.md)-->
   [コーディング規則](./conventions.md)
- <!--[The compiler testing framework](./tests/intro.md)-->
   [コンパイラテストフレームワーク](./tests/intro.md)
    - <!--[Running tests](./tests/running.md)-->
       [テストの実行](./tests/running.md)
    - <!--[Adding new tests](./tests/adding.md)-->
       [新しいテストの追加](./tests/adding.md)
    - <!--[Using `compiletest` + commands to control test execution](./compiletest.md)-->
       [`compiletest` +コマンドを使用してテスト実行を制御する](./compiletest.md)
- <!--[Debugging the Compiler](./compiler-debugging.md)-->
   [コンパイラのデバッグ](./compiler-debugging.md)
- <!--[Walkthrough: a typical contribution](./walkthrough.md)-->
   [ウォークスルー：典型的な貢献](./walkthrough.md)
- <!--[High-level overview of the compiler source](./high-level-overview.md)-->
   [コンパイラソースの概要](./high-level-overview.md)
- <!--[The Rustc Driver](./rustc-driver.md)-->
   [Rustcドライバー](./rustc-driver.md)
    - [Rustdoc](./rustdoc.md)
- <!--[Queries: demand-driven compilation](./query.md)-->
   [クエリ：需要主導のコンパイル](./query.md)
    - <!--[Incremental compilation](./incremental-compilation.md)-->
       [インクリメンタルコンパイル](./incremental-compilation.md)
    - <!--[Debugging and Testing](./incrcomp-debugging.md)-->
       [デバッグとテスト](./incrcomp-debugging.md)
- <!--[The parser](./the-parser.md)-->
   [パーサー](./the-parser.md)
- <!--[Macro expansion](./macro-expansion.md)-->
   [マクロ展開](./macro-expansion.md)
- <!--[Name resolution](./name-resolution.md)-->
   [名前解決](./name-resolution.md)
- <!--[The HIR (High-level IR)](./hir.md)-->
   [HIR（ハイレベルIR）](./hir.md)
    - <!--[Lowering AST to HIR](./lowering.md)-->
       [ASTをHIRに下げる](./lowering.md)
- <!--[The `ty` module: representing types](./ty.md)-->
   [`ty`モジュール：型の表現](./ty.md)
- <!--[Type inference](./type-inference.md)-->
   [型推論](./type-inference.md)
- <!--[Trait solving (old-style)](./traits/resolution.md)-->
   [特性解法（旧式）](./traits/resolution.md)
    - <!--[Higher-ranked trait bounds](./traits/hrtb.md)-->
       [高ランクの形質境界](./traits/hrtb.md)
    - <!--[Caching subtleties](./traits/caching.md)-->
       [微妙なキャッシング](./traits/caching.md)
    - [Specialization](./traits/specialization.md)
- <!--[Trait solving (new-style)](./traits/index.md)-->
   [特性解法（新スタイル）](./traits/index.md)
    - <!--[Lowering to logic](./traits/lowering-to-logic.md)-->
       [ロジックに下げる](./traits/lowering-to-logic.md)
      - <!--[Goals and clauses](./traits/goals-and-clauses.md)-->
         [目標と句](./traits/goals-and-clauses.md)
      - <!--[Equality and associated types](./traits/associated-types.md)-->
         [等価および関連タイプ](./traits/associated-types.md)
      - <!--[Implied bounds](./traits/implied-bounds.md)-->
         [暗黙の境界](./traits/implied-bounds.md)
      - <!--[Region constraints](./traits/regions.md)-->
         [地域の制約](./traits/regions.md)
    - <!--[Canonical queries](./traits/canonical-queries.md)-->
       [標準クエリ](./traits/canonical-queries.md)
      - [Canonicalization](./traits/canonicalization.md)
    - <!--[Lowering rules](./traits/lowering-rules.md)-->
       [規則を下げる](./traits/lowering-rules.md)
      - <!--[The lowering module in rustc](./traits/lowering-module.md)-->
         [rustcの降下モジュール](./traits/lowering-module.md)
    - <!--[Well-formedness checking](./traits/wf.md)-->
       [整形式チェック](./traits/wf.md)
    - <!--[The SLG solver](./traits/slg.md)-->
       [SLGソルバー](./traits/slg.md)
    - <!--[An Overview of Chalk](./traits/chalk-overview.md)-->
       [チョークの概要](./traits/chalk-overview.md)
    - [Bibliography](./traits/bibliography.md)
- <!--[Type checking](./type-checking.md)-->
   [型チェック](./type-checking.md)
    - <!--[Method Lookup](./method-lookup.md)-->
       [メソッドルックアップ](./method-lookup.md)
    - [Variance](./variance.md)
- <!--[The MIR (Mid-level IR)](./mir/index.md)-->
   [MIR（ミッドレベルIR）は、](./mir/index.md)
    - <!--[MIR construction](./mir/construction.md)-->
       [MIR建設](./mir/construction.md)
    - <!--[MIR visitor and traversal](./mir/visitor.md)-->
       [MIR訪問者およびトラバーサル](./mir/visitor.md)
    - <!--[MIR passes: getting the MIR for a function](./mir/passes.md)-->
       [MIRが渡す：関数のMIRを取得する](./mir/passes.md)
    - <!--[MIR borrowck](./mir/borrowck.md)-->
       [MIR借り入れ](./mir/borrowck.md)
      - <!--[MIR-based region checking (NLL)](./mir/regionck.md)-->
         [MIRベースの領域チェック（NLL）](./mir/regionck.md)
    - <!--[MIR optimizations](./mir/optimizations.md)-->
       [MIRの最適化](./mir/optimizations.md)
- <!--[Constant evaluation](./const-eval.md)-->
   [一定の評価](./const-eval.md)
    - <!--[miri const evaluator](./miri.md)-->
       [ミラー定数評価器](./miri.md)
- <!--[Parameter Environments](./param_env.md)-->
   [パラメータ環境](./param_env.md)
- <!--[Code Generation](./codegen.md)-->
   [コード生成](./codegen.md)
- <!--[Emitting Diagnostics](./diag.md)-->
   [エミッション診断](./diag.md)

<!------->
---

- <!--[Appendix A: Stupid Stats](./appendix/stupid-stats.md)-->
   [付録A：愚かな統計](./appendix/stupid-stats.md)
- <!--[Appendix B: Background material](./appendix/background.md)-->
   [付録B：背景資料](./appendix/background.md)
- <!--[Appendix C: Glossary](./appendix/glossary.md)-->
   [付録C：用語集](./appendix/glossary.md)
- <!--[Appendix D: Code Index](./appendix/code-index.md)-->
   [付録D：コードインデックス](./appendix/code-index.md)
