# <!--The lowering module in rustc--> rustcの降下モジュール

<!--The program clauses described in the [lowering rules](./traits/lowering-rules.html) section are actually created in the [`rustc_traits::lowering`][lowering] module.-->
[下げる規則の](./traits/lowering-rules.html)セクションで説明したプログラム節は、実際には[`rustc_traits::lowering`][lowering]モジュールで作成されます。

[lowering]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_traits/lowering/

## <!--The `program_clauses_for` query--> `program_clauses_for`クエリ

<!--The main entry point is the `program_clauses_for` [query], which – given a def-id – produces a set of Chalk program clauses.-->
主なエントリポイントは`program_clauses_for` [query]であり、def-idが指定されていれば、一連のChalkプログラム節が生成されます。
<!--These queries are tested using a [dedicated unit-testing mechanism, described below](#unit-tests).-->
これらのクエリは[、以下で説明する専用のユニットテストメカニズム](#unit-tests)を使用して[テストされます](#unit-tests)。
<!--The query is invoked on a `DefId` that identifies something like a trait, an impl, or an associated item definition.-->
このクエリは、`DefId`、impl、または関連する項目定義のようなものを識別する`DefId`で呼び出されます。
<!--It then produces and returns a vector of program clauses.-->
次に、プログラム句のベクトルを生成して返します。

[query]: ./query.html

<span id="unit-tests"></span>
## <!--Unit tests--> 単体テスト

<!--Unit tests are located in [`src/test/ui/chalkify`][chalkify].-->
ユニットテストは[`src/test/ui/chalkify`][chalkify]ます。
<!--A good example test is [the `lower_impl` test][lower_impl].-->
良い例のテストは[`lower_impl`テスト][lower_impl]です。
<!--At the time of this writing, it looked like this:-->
この執筆時点では、次のようになっていました。

```rust,ignore
#![feature(rustc_attrs)]

trait Foo { }

#[rustc_dump_program_clauses] //~ ERROR Implemented(T: Foo) :-
impl<T: 'static> Foo for T where T: Iterator<Item = i32> { }

fn main() {
    println!("hello");
}
```

<!--The `#[rustc_dump_program_clauses]` annotation can be attached to anything with a def-id.-->
`#[rustc_dump_program_clauses]`アノテーションは、def-idを持つものにアタッチすることができます。
<!--(It requires the `rustc_attrs` feature.) The compiler will then invoke the `program_clauses_for` query on that item, and emit compiler errors that dump the clauses produced.-->
（`rustc_attrs`機能が必要です）。コンパイラはその項目の`program_clauses_for`クエリを呼び出し、生成された句をダンプするコンパイラエラーを`rustc_attrs`ます。
<!--These errors just exist for unit-testing, as we can then leverage the standard [ui test] mechanisms to check them.-->
これらのエラーは単体テストのためだけに存在し、標準の[ui test]メカニズムを活用してチェックすることができます。
<!--In this case, there is a `//~ ERROR Implemented` annotation which is intentionally minimal (it need only be a prefix of the error), but [the stderr file] contains the full details:-->
この場合、`//~ ERROR Implemented`アノテーションは意図的に最小です（エラーの接頭部である必要があります）が[the stderr file]には完全な詳細が含まれてい[the stderr file]。

```text
error: Implemented(T: Foo) :- ProjectionEq(<T as std::iter::Iterator>::Item == i32), TypeOutlives(T \
: 'static), Implemented(T: std::iter::Iterator), Implemented(T: std::marker::Sized).
  --> $DIR/lower_impl.rs:15:1
   |
LL | #[rustc_dump_program_clauses] //~ ERROR Implemented(T: Foo) :-
   | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

error: aborting due to previous error
```

<!--[chalkify]: https://github.com/rust-lang/rust/tree/master/src/test/ui/chalkify
 [lower_impl]: https://github.com/rust-lang/rust/tree/master/src/test/ui/chalkify/lower_impl.rs
 [the stderr file]: https://github.com/rust-lang/rust/tree/master/src/test/ui/chalkify/lower_impl.stderr
 [ui test]: https://rust-lang-nursery.github.io/rustc-guide/tests/adding.html#guide-to-the-ui-tests
-->
[chalkify]: https://github.com/rust-lang/rust/tree/master/src/test/ui/chalkify
 [lower_impl]: https://github.com/rust-lang/rust/tree/master/src/test/ui/chalkify/lower_impl.rs
 [the stderr file]: https://github.com/rust-lang/rust/tree/master/src/test/ui/chalkify/lower_impl.stderr
 [ui test]: https://rust-lang-nursery.github.io/rustc-guide/tests/adding.html#guide-to-the-ui-tests

