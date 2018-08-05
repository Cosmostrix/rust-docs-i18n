# <!--Error handling--> エラー処理

<!--Error handling is the process of handling the possibility of failure.-->
エラー処理は、障害の可能性を処理するプロセスです。
<!--For example, failing to read a file and then continuing to use that *bad* input would clearly be problematic.-->
例えば、ファイルの読み込みに失敗し、その*悪い*入力を引き続き使用することは明らかに問題になります。
<!--Noticing and explicitly managing those errors saves the rest of the program from various pitfalls.-->
これらのエラーに気づいて明示的に管理することは、残りのプログラムをさまざまな落とし穴から救うことになります。

<!--There are various ways to deal with errors in Rust, which are described in the following subchapters.-->
Rustのエラー処理にはさまざまな方法があります。これらについては、次のサブセクションで説明します。
<!--They all have more or less subtle differences and different use cases.-->
それらはすべて、多かれ少なかれ微妙な違いとさまざまなユースケースを持っています。
<!--As a rule of thumb:-->
経験則として、

<!--An explicit `panic` is mainly useful for tests and dealing with unrecoverable errors.-->
明示的な`panic`は、主にテストや回復不能なエラーの処理に役立ちます。
<!--For prototyping it can be useful, for example when dealing with functions that haven't been implemented yet, but in those cases the more descriptive `unimplemented` is better.-->
プロトタイピングのためには、まだ実装されていない機能を扱うときなどに便利することができますが、これらの例により記述`unimplemented`良いです。
<!--In tests `panic` is a reasonable way to explicitly fail.-->
テストでは、`panic`は明示的に失敗する合理的な方法です。

<!--The `Option` type is for when a value is optional or when the lack of a value is not an error condition.-->
`Option`タイプは、値がオプションの場合、または値の欠如がエラー条件でない場合に使用します。
<!--For example the parent of a directory -`/` and `C:` don't have one.-->
たとえば、ディレクトリの親-`/`及び`C:` 1を持っていません。
<!--When dealing with `Option` s, `unwrap` is fine for prototyping and cases where it's absolutely certain that there is guaranteed to be a value.-->
`Option`を扱う`unwrap`は、プロトタイプ化や、値が保証されていることが絶対に確かな場合には`unwrap`が問題ありません。
<!--However `expect` is more useful since it lets you specify an error message in case something goes wrong anyway.-->
しかし`expect`とにかく何かがうまくいかない場合に備えて、エラーメッセージを指定できるので、`expect`はより便利です。

<!--When there is a chance that things do go wrong and the caller has to deal with the problem, use `Result`.-->
物事がうまくいかず、呼び出し側が問題に対処しなければならない場合は、`Result`使用します。
<!--You can `unwrap` and `expect` them as well (please don't do that unless it's a test or quick prototype).-->
それらを`unwrap`して`expect`することもできます（テストやクイックプロトタイプでないとしないでください）。

<!--For a more rigorous discussion of error handling, refer to the error handling section in the [official book][book].-->
エラー処理のより厳密な議論については、[公式書籍の][book]エラー処理のセクションを参照してください。

[book]: https://doc.rust-lang.org/book/second-edition/ch09-00-error-handling.html
