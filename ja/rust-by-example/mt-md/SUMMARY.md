# <!--Summary--> 概要

[Introduction](index.md)
- <!--[Hello World](hello.md)-->
   [こんにちは世界](hello.md)
    - [Comments](hello/comment.md)
    - <!--[Formatted print](hello/print.md)-->
       [書式付き印刷](hello/print.md)
        - [Debug](hello/print/print_debug.md)
        - [Display](hello/print/print_display.md)
            - <!--[Testcase: List](hello/print/print_display/testcase_list.md)-->
               [テストケース：リスト](hello/print/print_display/testcase_list.md)
        - [Formatting](hello/print/fmt.md)

- [Primitives](primitives.md)
    - <!--[Literals and operators](primitives/literals.md)-->
       [リテラルと演算子](primitives/literals.md)
    - [Tuples](primitives/tuples.md)
    - <!--[Arrays and Slices](primitives/array.md)-->
       [配列とスライス](primitives/array.md)

- <!--[Custom Types](custom_types.md)-->
   [カスタムタイプ](custom_types.md)
    - [Structures](custom_types/structs.md)
    - [Enums](custom_types/enum.md)
        - [use](custom_types/enum/enum_use.md)
        - [C-like](custom_types/enum/c_like.md)
        - <!--[Testcase: linked-list](custom_types/enum/testcase_linked_list.md)-->
           [テストケース：リンクリスト](custom_types/enum/testcase_linked_list.md)
    - [constants](custom_types/constants.md)

- <!--[Variable Bindings](variable_bindings.md)-->
   [変数バインディング](variable_bindings.md)
    - [Mutability](variable_bindings/mut.md)
    - <!--[Scope and Shadowing](variable_bindings/scope.md)-->
       [スコープとシャドウイング](variable_bindings/scope.md)
    - <!--[Declare first](variable_bindings/declare.md)-->
       [最初に宣言する](variable_bindings/declare.md)

- [Types](types.md)
    - [Casting](types/cast.md)
    - [Literals](types/literals.md)
    - [Inference](types/inference.md)
    - [Aliasing](types/alias.md)

- [Conversion](conversion.md)
    - <!--[`From` and `Into`](conversion/from_into.md)-->
       [`From` `中へInto`](conversion/from_into.md)
    - <!--[To and from `String` s](conversion/string.md)-->
       [`String`のやりとり](conversion/string.md)

- [Expressions](expression.md)

- <!--[Flow Control](flow_control.md)-->
   [フロー制御](flow_control.md)
    - [if/else](flow_control/if_else.md)
    - [loop](flow_control/loop.md)
        - <!--[Nesting and labels](flow_control/loop/nested.md)-->
           [ネスティングとラベル](flow_control/loop/nested.md)
        - <!--[Returning from loops](flow_control/loop/return.md)-->
           [ループからの戻り](flow_control/loop/return.md)
    - [while](flow_control/while.md)
    - <!--[for and range](flow_control/for.md)-->
       [と範囲](flow_control/for.md)
    - [match](flow_control/match.md)
        - [Destructuring](flow_control/match/destructuring.md)
            - [tuples](flow_control/match/destructuring/destructure_tuple.md)
            - [enums](flow_control/match/destructuring/destructure_enum.md)
            - [pointers/ref](flow_control/match/destructuring/destructure_pointers.md)
            - [structs](flow_control/match/destructuring/destructure_structures.md)
        - [Guards](flow_control/match/guard.md)
        - [Binding](flow_control/match/binding.md)
    - <!--[if let](flow_control/if_let.md)-->
       [もしlet](flow_control/if_let.md)
    - <!--[while let](flow_control/while_let.md)-->
       [しながら](flow_control/while_let.md)

- [Functions](fn.md)
    - [Methods](fn/methods.md)
    - [Closures](fn/closures.md)
        - [Capturing](fn/closures/capture.md)
        - <!--[As input parameters](fn/closures/input_parameters.md)-->
           [入力パラメータとして](fn/closures/input_parameters.md)
        - <!--[Type anonymity](fn/closures/anonymity.md)-->
           [タイプ匿名性](fn/closures/anonymity.md)
        - <!--[Input functions](fn/closures/input_functions.md)-->
           [入力機能](fn/closures/input_functions.md)
        - <!--[As output parameters](fn/closures/output_parameters.md)-->
           [出力パラメータとして](fn/closures/output_parameters.md)
        - <!--[Examples in `std`](fn/closures/closure_examples.md)-->
           [`std`例](fn/closures/closure_examples.md)
            - [Iterator::any](fn/closures/closure_examples/iter_any.md)
            - [Iterator::find](fn/closures/closure_examples/iter_find.md)
    - <!--[Higher Order Functions](fn/hof.md)-->
       [高次関数](fn/hof.md)
    - <!--[Diverging functions](fn/diverging.md)-->
       [機能の分散](fn/diverging.md)

- [Modules](mod.md)
    - [Visibility](mod/visibility.md)
    - <!--[Struct visibility](mod/struct_visibility.md)-->
       [構造体の可視性](mod/struct_visibility.md)
    - <!--[The `use` declaration](mod/use.md)-->
       [`use`宣言](mod/use.md)
    - <!--[`super` and `self`](mod/super.md)-->
       [`super`と`self`](mod/super.md)
    - <!--[File hierarchy](mod/split.md)-->
       [ファイル階層](mod/split.md)

- [Crates](crates.md)
    - [Library](crates/lib.md)
    - [`extern crate`](crates/link.md)

- [Cargo](cargo.md)
    - [Dependencies](cargo/deps.md)
    - [Conventions](cargo/conventions.md)
    - [Tests](cargo/test.md)

- [Attributes](attribute.md)
    - [`dead_code`](attribute/unused.md)
    - [Crates](attribute/crate.md)
    - [`cfg`](attribute/cfg.md)
        - [Custom](attribute/cfg/custom.md)

- [Generics](generics.md)
    - [Functions](generics/gen_fn.md)
    - [Implementation](generics/impl.md)
    - [Traits](generics/gen_trait.md)
    - [Bounds](generics/bounds.md)
        - <!--[Testcase: empty bounds](generics/bounds/testcase_empty.md)-->
           [テストケース：空の境界](generics/bounds/testcase_empty.md)
    - <!--[Multiple bounds](generics/multi_bounds.md)-->
       [複数の境界](generics/multi_bounds.md)
    - <!--[Where clauses](generics/where.md)-->
       [Where節](generics/where.md)
    - <!--[New Type Idiom](generics/new_types.md)-->
       [新しいタイプのイディオム](generics/new_types.md)
    - <!--[Associated items](generics/assoc_items.md)-->
       [関連商品](generics/assoc_items.md)
        - <!--[The Problem](generics/assoc_items/the_problem.md)-->
           [問題](generics/assoc_items/the_problem.md)
        - <!--[Associated types](generics/assoc_items/types.md)-->
           [関連タイプ](generics/assoc_items/types.md)
    - <!--[Phantom type parameters](generics/phantom.md)-->
       [ファントムタイプのパラメータ](generics/phantom.md)
        - <!--[Testcase: unit clarification](generics/phantom/testcase_units.md)-->
           [テストケース：ユニットの明確化](generics/phantom/testcase_units.md)

- <!--[Scoping rules](scope.md)-->
   [スコープ規則](scope.md)
    - [RAII](scope/raii.md)
    - <!--[Ownership and moves](scope/move.md)-->
       [所有権と移動](scope/move.md)
        - [Mutability](scope/move/mut.md)
    - [Borrowing](scope/borrow.md)
        - [Mutability](scope/borrow/mut.md)
        - [Freezing](scope/borrow/freeze.md)
        - [Aliasing](scope/borrow/alias.md)
        - <!--[The ref pattern](scope/borrow/ref.md)-->
           [refパターン](scope/borrow/ref.md)
    - [Lifetimes](scope/lifetime.md)
        - <!--[Explicit annotation](scope/lifetime/explicit.md)-->
           [明示的な注釈](scope/lifetime/explicit.md)
        - [Functions](scope/lifetime/fn.md)
        - [Methods](scope/lifetime/methods.md)
        - [Structs](scope/lifetime/struct.md)
        - [Bounds](scope/lifetime/lifetime_bounds.md)
        - [Coercion](scope/lifetime/lifetime_coercion.md)
        - [Static](scope/lifetime/static_lifetime.md)
        - [Elision](scope/lifetime/elision.md)

- [Traits](trait.md)
    - [Derive](trait/derive.md)
    - <!--[Operator Overloading](trait/ops.md)-->
       [演算子のオーバーロード](trait/ops.md)
    - [Drop](trait/drop.md)
    - [Iterators](trait/iter.md)
    - [Clone](trait/clone.md)

- [macro_rules!](macros.md)
    - [Syntax](macros/syntax.md)
        - [Designators](macros/designators.md)
        - [Overload](macros/overload.md)
        - [Repeat](macros/repeat.md)
    - <!--[DRY (Don't Repeat Yourself)](macros/dry.md)-->
       [ドライ（あなた自身を繰り返さないでください）](macros/dry.md)
    - <!--[DSL (Domain Specific Languages)](macros/dsl.md)-->
       [DSL（ドメイン固有言語）](macros/dsl.md)
    - [Variadics](macros/variadics.md)

- <!--[Error handling](error.md)-->
   [エラー処理](error.md)
    - [`panic`](error/panic.md)
    - <!--[`Option` & `unwrap`](error/option_unwrap.md)-->
       [`Option` ＆ `unwrap`](error/option_unwrap.md)
        - <!--[Combinators: `map`](error/option_unwrap/map.md)-->
           [Combinators： `map`](error/option_unwrap/map.md)
        - <!--[Combinators: `and_then`](error/option_unwrap/and_then.md)-->
           [`and_then`： `and_then`](error/option_unwrap/and_then.md)
    - [`Result`](error/result.md)
        - <!--[`map` for `Result`](error/result/result_map.md)-->
           [`Result` `map`](error/result/result_map.md)
        - <!--[aliases for `Result`](error/result/result_alias.md)-->
           [`Result`エイリアス](error/result/result_alias.md)
        - <!--[Early returns](error/result/early_returns.md)-->
           [早期返品](error/result/early_returns.md)
        - <!--[Introducing `?`](error/result/enter_question_mark.md)-->
           [ご紹介`?`](error/result/enter_question_mark.md)
    - <!--[Multiple error types](error/multiple_error_types.md)-->
       [複数のエラータイプ](error/multiple_error_types.md)
        - <!--[Pulling `Result` s out of `Option` s](error/multiple_error_types/option_result.md)-->
           [`Option` sから`Result` sを引き出す](error/multiple_error_types/option_result.md)
        - <!--[Defining an error type](error/multiple_error_types/define_error_type.md)-->
           [エラータイプの定義](error/multiple_error_types/define_error_type.md)
        - <!--[`Box` ing errors](error/multiple_error_types/boxing_errors.md)-->
           [`Box`エラー](error/multiple_error_types/boxing_errors.md)
        - <!--[Other uses of `?`](error/multiple_error_types/reenter_question_mark.md)-->
           [その他の用途は`?`](error/multiple_error_types/reenter_question_mark.md)
        - <!--[Wrapping errors](error/multiple_error_types/wrap_error.md)-->
           [折り返しエラー](error/multiple_error_types/wrap_error.md)
    - <!--[Iterating over `Result` s](error/iter_result.md)-->
       [`Result`反復する](error/iter_result.md)

- <!--[Std library types](std.md)-->
   [Stdライブラリタイプ](std.md)
    - <!--[Box, stack and heap](std/box.md)-->
       [ボックス、スタック、ヒープ](std/box.md)
    - [Vectors](std/vec.md)
    - [Strings](std/str.md)
    - [`Option`](std/option.md)
    - [`Result`](std/result.md)
        - [`?`](std/result/question_mark.md)
    - [`panic!`](std/panic.md)
    - [HashMap](std/hash.md)
        - <!--[Alternate/custom key types](std/hash/alt_key_types.md)-->
           [代替/カスタムキータイプ](std/hash/alt_key_types.md)
        - [HashSet](std/hash/hashset.md)

- <!--[Std misc](std_misc.md)-->
   [Std misc](std_misc.md)
    - [Threads](std_misc/threads.md)
        - <!--[Testcase: map-reduce](std_misc/threads/testcase_mapreduce.md)-->
           [テストケース：map-reduce](std_misc/threads/testcase_mapreduce.md)
    - [Channels](std_misc/channels.md)
    - [Path](std_misc/path.md)
    - <!--[File I/O](std_misc/file.md)-->
       [ファイルI / O](std_misc/file.md)
        - [`open`](std_misc/file/open.md)
        - [`create`](std_misc/file/create.md)
    - <!--[Child processes](std_misc/process.md)-->
       [子プロセス](std_misc/process.md)
        - [Pipes](std_misc/process/pipe.md)
        - [Wait](std_misc/process/wait.md)
    - <!--[Filesystem Operations](std_misc/fs.md)-->
       [ファイルシステム操作](std_misc/fs.md)
    - <!--[Program arguments](std_misc/arg.md)-->
       [プログラムの議論](std_misc/arg.md)
        - <!--[Argument parsing](std_misc/arg/matching.md)-->
           [引数の解析](std_misc/arg/matching.md)
    - <!--[Foreign Function Interface](std_misc/ffi.md)-->
       [外部関数インタフェース](std_misc/ffi.md)

- [Testing](testing.md)
    - <!--[Unit testing](testing/unit_testing.md)-->
       [単体テスト](testing/unit_testing.md)
    - <!--[Documentation testing](testing/doc_testing.md)-->
       [ドキュメンテーションのテスト](testing/doc_testing.md)
    - <!--[Integration testing](testing/integration_testing.md)-->
       [統合テスト](testing/integration_testing.md)
    - [Dev-dependencies](testing/dev_dependencies.md)

- [Meta](meta.md)
    - [Documentation](meta/doc.md)

- <!--[Unsafe Operations](unsafe.md)-->
   [安全でない操作](unsafe.md)
