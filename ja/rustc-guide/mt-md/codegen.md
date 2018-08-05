# <!--Code generation--> コード生成

<!--Code generation or "codegen"is the part of the compiler that actually generates an executable binary.-->
コード生成または "codegen"は、実際に実行可能なバイナリを生成するコンパイラの一部です。
<!--rustc uses LLVM for code generation.-->
rustcはコード生成にLLVMを使用します。

> <!--NOTE: If you are looking for hints on how to debug code generation bugs, please see [this section of the debugging chapter][debug].-->
> 注：コード生成のバグをデバッグする方法のヒントを探している場合[は、デバッグの章のこのセクション][debug]を参照し[て][debug]ください。

[debug]: compiler-debugging.html#debugging-llvm

## <!--What is LLVM?--> LLVMとは何ですか？

<!--All of the preceeding chapters of this guide have one thing in common: we never generated any executable machine code at all!-->
このガイドの前の章では、共通して1つのことがあります。実行可能なマシンコードはまったく生成されませんでした。
<!--With this chapter, all of that changes.-->
この章では、そのすべてが変更されています。

<!--Like most compilers, rustc is composed of a "frontend"and a "backend".-->
ほとんどのコンパイラと同様、rustcは「フロントエンド」と「バックエンド」で構成されています。
<!--The "frontend"is responsible for taking raw source code, checking it for correctness, and getting it into a format `X` from which we can generate executable machine code.-->
「フロントエンド」は、未処理のソースコードを取り出し、正確性をチェックし、実行可能なマシンコードを生成できる形式`X`に変換する責任があります。
<!--The "backend"then takes that format `X` and produces (possibly optimized) executable machine code for some platform.-->
"バックエンド"はそのフォーマット`X`をとり、プラットフォームによっては実行可能なマシンコードを生成します。
<!--All of the previous chapters deal with rustc's frontend.-->
これまでの章では、すべてrustcのフロントエンドを扱っています。

<!--rustc's backend is [LLVM](https://llvm.org), "a collection of modular and reusable compiler and toolchain technologies".-->
rustcのバックエンドは[LLVM](https://llvm.org)。「モジュール化された再利用可能なコンパイラとツールチェーン技術の集まり」です。
<!--In particular, the LLVM project contains a pluggable compiler backend (also called "LLVM"), which is used by many compiler projects, including the `clang` C compiler and our beloved `rustc`.-->
特に、LLVMプロジェクトには、プラグイン可能なコンパイラバックエンド（「LLVM」とも呼ばれます）が含まれています。これは、`clang` Cコンパイラや`rustc`を含む多くのコンパイラプロジェクトで使用されています。

<!--LLVM's "format `X` "is called LLVM IR.-->
LLVMの「フォーマット`X` 」はLLVM IRと呼ばれます。
<!--It is basically assembly code with additional low-level types and annotations added.-->
基本的には、追加の低レベル型と注釈が追加されたアセンブリコードです。
<!--These annotations are helpful for doing optimizations on the LLVM IR and outputed machine code.-->
これらの注釈は、LLVM IRと出力されたマシンコードの最適化に役立ちます。
<!--The end result of all this is (at long last) something executable (eg an ELF object or wasm).-->
このすべての最終結果は、（最後に）実行可能なもの（ELFオブジェクトやwasmなど）です。

<!--There are a few benefits to using LLVM:-->
LLVMの使用にはいくつかの利点があります。

- <!--We don't have to write a whole compiler backend.-->
   コンパイラのバックエンド全体を書く必要はありません。
<!--This reduces implementation and maintainance burden.-->
   これにより、実装とメンテナンスの負担が軽減されます。
- <!--We benefit from the large suite of advanced optimizations that the LLVM project has been collecting.-->
   LLVMプロジェクトが収集してきた高度な最適化スイートの恩恵を受けています。
- <!--We automatically can compile Rust to any of the platforms for which LLVM has support.-->
   LLVMがサポートしているプラ​​ットフォームに自動的にRustをコンパイルできます。
<!--For example, as soon as LLVM added support for wasm, voila!-->
   たとえば、LLVMがwasmのサポートを追加するとすぐに、voila！
<!--rustc, clang, and a bunch of other languages were able to compile to wasm!-->
   rustc、clang、そして他の言語の束がwasmにコンパイルできました！
<!--(Well, there was some extra stuff to be done, but we were 90% there anyway).-->
   （さて、やるべきことがいくつかありましたが、とにかくそこに90％ありました）。
- <!--We and other compiler projects benefit from each other.-->
   私たちと他のコンパイラプロジェクトは互いに利益を得ています。
<!--For example, when the [Spectre and Meltdown security vulnerabilities][spectre] were discovered, only LLVM needed to be patched.-->
   たとえば、[Spectre and Meltdownのセキュリティ上の脆弱性][spectre]が発見されたときには、LLVMだけを修正する必要がありました。

[spectre]: https://meltdownattack.com/

## <!--Generating LLVM IR--> LLVM IRの生成

<!--TODO-->
TODO
