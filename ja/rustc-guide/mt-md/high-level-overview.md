# <!--High-level overview of the compiler source--> コンパイラソースの概要

## <!--Crate structure--> クレート構造

<!--The main Rust repository consists of a `src` directory, under which there live many crates.-->
主なRustリポジトリは`src`ディレクトリで構成されていて、そこには多数の木箱があります。
<!--These crates contain the sources for the standard library and the compiler.-->
これらのクレートには、標準ライブラリとコンパイラのソースが含まれています。
<!--This document, of course, focuses on the latter.-->
この文書はもちろん、後者に焦点を当てています。

<!--Rustc consists of a number of crates, including `syntax`, `rustc`, `rustc_back`, `rustc_codegen`, `rustc_driver`, and many more.-->
Rustcは`syntax`、 `rustc`、 `rustc_back`、 `rustc_codegen`、 `rustc_driver`などを含むいくつかの箱から構成されてい`syntax`。
<!--The source for each crate can be found in a directory like `src/libXXX`, where `XXX` is the crate name.-->
各`src/libXXX`、 `src/libXXX`ようなディレクトリにあります。ここで、`XXX`はクレート名です。

<!--(NB The names and divisions of these crates are not set in stone and may change over time. For the time being, we tend towards a finer-grained division to help with compilation time, though as incremental compilation improves, that may change.)-->
（これらの木箱の名前と部門は石で設定されておらず、時間の経過とともに変更される可能性がありますが、当分の間、コンパイル時間が短縮されるにつれてコンパイル時間を短縮する傾向があります。

<!--The dependency structure of these crates is roughly a diamond:-->
これらの木箱の依存構造はおおよそダイヤモンドです：

```text
                  rustc_driver
                /      |       \
              /        |         \
            /          |           \
          /            v             \
rustc_codegen  rustc_borrowck   ...  rustc_metadata
          \            |            /
            \          |          /
              \        |        /
                \      v      /
                    rustc
                       |
                       v
                    syntax
                    /    \
                  /       \
           syntax_pos  syntax_ext
```

<!--The `rustc_driver` crate, at the top of this lattice, is effectively the "main"function for the rust compiler.-->
この格子の最上部にある`rustc_driver`クレートは、事実上、錆のコンパイラにとっての主な機能です。
<!--It doesn't have much "real code", but instead ties together all of the code defined in the other crates and defines the overall flow of execution.-->
「実際のコード」はあまりありませんが、代わりに他のクレートに定義されているすべてのコードを結びつけ、実行の全体的な流れを定義します。
<!--(As we transition more and more to the [query model], however, the "flow"of compilation is becoming less centrally defined.)-->
（ただし、[query model]に移行するにつれて、コンパイルの「フロー」はより集中的に定義されなくなりました）。

<!--At the other extreme, the `rustc` crate defines the common and pervasive data structures that all the rest of the compiler uses (eg how to represent types, traits, and the program itself).-->
他の極端な場合、`rustc`箱は、コンパイラが使用する他のすべてのデータ構造（型、特性、およびプログラム自体を表現する方法など）の共通および普及したデータ構造を定義します。
<!--It also contains some amount of the compiler itself, although that is relatively limited.-->
比較的限られていますが、コンパイラ自体にもいくらかの量が含まれています。

<!--Finally, all the crates in the bulge in the middle define the bulk of the compiler – they all depend on `rustc`, so that they can make use of the various types defined there, and they export public routines that `rustc_driver` will invoke as needed (more and more, what these crates export are "query definitions", but those are covered later on).-->
最後に、中央の膨らみのすべての箱がコンパイラの大部分を定義します -それらはすべて`rustc`に依存し、そこで定義されたさまざまな型を利用できるようになり、必要に応じて`rustc_driver`が呼び出すpublicルーチンをエクスポートしますこれらのクレートのエクスポートは「クエリ定義」ですが、後で説明します）。

<!--Below `rustc` lie various crates that make up the parser and error reporting mechanism.-->
`rustc`下には、パーサとエラー報告メカニズムを構成するさまざまなクレートがあります。
<!--For historical reasons, these crates do not have the `rustc_` prefix, but they are really just as much an internal part of the compiler and not intended to be stable (though they do wind up getting used by some crates in the wild; a practice we hope to gradually phase out).-->
歴史的な理由から、これらの箱には`rustc_`接頭語はありませんが、実際にはコンパイラの内部部分と同様に安定していません（ただし、野生の木枠で使用されていますが、徐々に段階的に廃止することを望みます）。

<!--Each crate has a `README.md` file that describes, at a high-level, what it contains, and tries to give some kind of explanation (some better than others).-->
各クレートには、`README.md`ファイルがあります。このファイルには、高レベルに含まれている`README.md`を記述し、何らかの説明をします（他のものよりも優れています）。

## <!--The main stages of compilation--> 編集の主な段階

<!--The Rust compiler is in a bit of transition right now.-->
Rustコンパイラは今や少し変わっています。
<!--It used to be a purely "pass-based"compiler, where we ran a number of passes over the entire program, and each did a particular check of transformation.-->
以前は完全にパスベースのコンパイラでしたが、プログラム全体に渡っていくつかのパスを実行し、それぞれが特定の変換チェックを行いました。
<!--We are gradually replacing this pass-based code with an alternative setup based on on-demand **queries**.-->
このパスベースのコードをオンデマンド**クエリに**基づく代替設定に徐々に置き換えています。
<!--In the query-model, we work backwards, executing a *query* that expresses our ultimate goal (eg "compile this crate").-->
クエリモデルでは、私たちは最終的な目標を表す*クエリ*を実行して後方に向かって作業し*ます*（たとえば、 "このクレートのコンパイル"）。
<!--This query in turn may make other queries (eg "get me a list of all modules in the crate").-->
このクエリは、次に、他のクエリを作成することができます（たとえば、「クレートのすべてのモジュールのリストを取得する」など）。
<!--Those queries make other queries that ultimately bottom out in the base operations, like parsing the input, running the type-checker, and so forth.-->
これらのクエリは、入力の解析、型チェッカーの実行などの基本操作の最終的に底を成す他のクエリを作成します。
<!--This on-demand model permits us to do exciting things like only do the minimal amount of work needed to type-check a single function.-->
このオンデマンドモデルにより、単一の機能のタイプチェックに必要な作業量を最小限に抑えられるようなエキサイティングな作業を行うことができます。
<!--It also helps with incremental compilation.-->
インクリメンタルコンパイルにも役立ちます。
<!--(For details on defining queries, check out the [query model].)-->
（クエリの定義の詳細については、[query model]チェックしてください）。

<!--Regardless of the general setup, the basic operations that the compiler must perform are the same.-->
一般的なセットアップに関係なく、コンパイラが実行する必要がある基本的な操作は同じです。
<!--The only thing that changes is whether these operations are invoked front-to-back, or on demand.-->
変化する唯一のことは、これらの操作がフロント・ツー・バックかオンデマンドのどちらで呼び出されるかです。
<!--In order to compile a Rust crate, these are the general steps that we take:-->
Rustの箱をコンパイルするには、これが一般的な手順です：

1. <!--**Parsing input**-->
    **入力の解析**
    - <!--this processes the `.rs` files and produces the AST ("abstract syntax tree")-->
       `.rs`ファイルを処理し、AST（抽象構文ツリー）を生成します
    - <!--the AST is defined in `syntax/ast.rs`.-->
       ASTは`syntax/ast.rs`定義されてい`syntax/ast.rs`。
<!--It is intended to match the lexical syntax of the Rust language quite closely.-->
       これは、Rust言語の字句構文と非常によく一致するように意図されています。
2. <!--**Name resolution, macro expansion, and configuration**-->
    **名前解決、マクロ展開、および構成**
    - <!--once parsing is complete, we process the AST recursively, resolving paths and expanding macros.-->
       解析が完了すると、ASTを再帰的に処理し、パスを解決してマクロを展開します。
<!--This same process also processes `#[cfg]` nodes, and hence may strip things out of the AST as well.-->
       この同じプロセスでも`#[cfg]`ノードが処理されるため、ASTからも削除される可能性があります。
3. <!--**Lowering to HIR**-->
    **HIRに下げる**
    - <!--Once name resolution completes, we convert the AST into the HIR, or "[high-level intermediate representation] ".-->
       名前解決が完了すると、ASTをHIR、つまり「 [high-level intermediate representation] 」に変換します。
<!--The HIR is defined in `src/librustc/hir/`;-->
       HIRは`src/librustc/hir/`定義されています。
<!--that module also includes the [lowering] code.-->
       そのモジュールには[lowering]コードも含まれています。
    - <!--The HIR is a lightly desugared variant of the AST.-->
       HIRはASTの軽くdesugared変形です。
<!--It is more processed than the AST and more suitable for the analyses that follow.-->
       それはASTよりも処理され、以下の分析に適しています。
<!--It is **not** required to match the syntax of the Rust language.-->
       Rust言語の構文と一致する必要はあり**ません**。
    - <!--As a simple example, in the **AST**, we preserve the parentheses that the user wrote, so `((1 + 2) + 3)` and `1 + 2 + 3` parse into distinct trees, even though they are equivalent.-->
       簡単な例として、**AST**では、ユーザが書き込んだかっこを保存しているので、`((1 + 2) + 3)`と`1 + 2 + 3`は、同等のものであっても別々のツリーを解析します。
<!--In the HIR, however, parentheses nodes are removed, and those two expressions are represented in the same way.-->
       しかし、HIRでは、括弧のノードが削除され、その2つの式は同じ方法で表されます。
3. <!--**Type-checking and subsequent analyses**-->
    **型チェックとその後の分析**
    - <!--An important step in processing the HIR is to perform type checking.-->
       HIRを処理する重要なステップは、タイプチェックを実行することです。
<!--This process assigns types to every HIR expression, for example, and also is responsible for resolving some "type-dependent"paths, such as field accesses (`xf` – we can't know what field `f` is being accessed until we know the type of `x`) and associated type references (`T::Item` – we can't know what type `Item` is until we know what `T` is).-->
       このプロセスでは、たとえばHIRの式すべてに型を割り当て、フィールドアクセスなどの「型依存型」パスを解決する責任も負います（`xf` -どの型のフィールド`f`がアクセスされているのかわかりません`x`）とそれに関連する型参照（ `T::Item` -`T`が何であるかを知るまで、どの型`Item`がわかるか）
    - <!--Type checking creates "side-tables"(`TypeckTables`) that include the types of expressions, the way to resolve methods, and so forth.-->
       型チェックは、式の型、メソッドを解決する方法などを含む "`TypeckTables` "（`TypeckTables`）を作成します。
    - <!--After type-checking, we can do other analyses, such as privacy checking.-->
       型チェックの後、私たちはプライバシーチェックのような他の分析を行うことができます。
4. <!--**Lowering to MIR and post-processing**-->
    **MIRと後処理に下げる**
    - <!--Once type-checking is done, we can lower the HIR into MIR ("middle IR"), which is a **very** desugared version of Rust, well suited to borrowck but also to certain high-level optimizations.-->
       タイプチェックが完了すると、HIRをMIR（「中間IR」）に下げることができます。これは、Rustの**非常に**放棄されたバージョンであり、借り入れに適していますが、特定の高度な最適化にも適しています。
5. <!--**Translation to LLVM and LLVM optimizations**-->
    **LLVMとLLVMの最適化への変換**
    - <!--From MIR, we can produce LLVM IR.-->
       MIRからLLVM IRを生成することができます。
    - <!--LLVM then runs its various optimizations, which produces a number of `.o` files (one for each "codegen unit").-->
       LLVMはさまざまな最適化を実行し、いくつかの`.o`ファイル（各 "codegen unit"に1つずつ）を生成します。
6. <!--**Linking**-->
    **リンクする**
    - <!--Finally, those `.o` files are linked together.-->
       最後に、これらの`.o`ファイルはリンクされています。


<!--[query model]: query.html
 [high-level intermediate representation]: hir.html
 [lowering]: lowering.html
-->
[query model]: query.html
 [high-level intermediate representation]: hir.html
 [lowering]: lowering.html

