# <!--Documentation testing--> ドキュメンテーションのテスト

<!--The primary way of documenting a Rust project is through annotating the source code.-->
Rustプロジェクトを文書化する主な方法は、ソースコードに注釈を付けることです。
<!--Documentation comments are written in [markdown] and support code blocks in them.-->
ドキュメンテーションのコメントは[markdown]とその中のサポートコードブロックで書かれています。
<!--Rust takes care about correctness, so these code blocks are compiled and used as tests.-->
Rustは正当性を考慮しているため、これらのコードブロックはコンパイルされ、テストとして使用されます。

```rust,ignore
#///// First line is a short summary describing function.
/// 最初の行は機能を説明する短い要約です。
///
#///// The next lines present detailed documentation. Code blocks start with
/// 次の行には詳細なドキュメントがあります。コードブロックは
#///// triple backquotes and have implicit `fn main()` inside
/// 三重バッククォートと暗黙の`fn main()`内部に持つ
#///// and `extern crate <cratename>`. Assume we're testing `doccomments` crate:
///  `extern crate <cratename>`ます。`doccomments`をテストしているとします。
///
#///// ```
///  `` ``
#///// let result = doccomments::add(2, 3);
///  let = doccomments:: add（2,3）;
#///// assert_eq!(result, 5);
///  assert_eq！（結果、5）;
#///// ```
///  `` ``
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#///// Usually doc comments may include sections "Examples", "Panics" and "Failures".
/// 通常、文書のコメントには、「例」、「パニック」、および「失敗」のセクションが含まれます。
///
#///// The next function divides two numbers.
/// 次の関数は2つの数を分割します。
///
#///// # Examples
///  ＃例
///
#///// ```
///  `` ``
#///// let result = doccomments::div(10, 2);
///  let = doccomments:: div（10、2）;
#///// assert_eq!(result, 5);
///  assert_eq！（結果、5）;
#///// ```
///  `` ``
///
#///// # Panics
///  ＃パニック
///
#///// The function panics if the second argument is zero.
///  2番目の引数がゼロの場合、関数はパニックになります。
///
#///// ```rust,should_panic
///  `` `錆、should_panic
#///// // panics on division by zero
///  //ゼロ除算のパニック
#///// doccomments::div(10, 0);
///  doccomments:: div（10、0）;
#///// ```
///  `` ``
pub fn div(a: i32, b: i32) -> i32 {
    if b == 0 {
        panic!("Divide-by-zero error");
    }

    a / b
}
```

<!--Tests can be run with `cargo test`:-->
テストは`cargo test`で実行できます：

```bash
$ cargo test
running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

   Doc-tests doccomments

running 3 tests
test src/lib.rs - add (line 7) ... ok
test src/lib.rs - div (line 21) ... ok
test src/lib.rs - div (line 31) ... ok

test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

## <!--Motivation behind documentation tests--> ドキュメンテーションテストの背後にある動機

<!--The main purpose of documentation tests is to serve as an examples that exercise the functionality, which is one of the most important [guidelines][question-instead-of-unwrap].-->
ドキュメンテーションテストの主な目的は、最も重要な[guidelines][question-instead-of-unwrap] 1つである機能を実行する例として役立つことです。
<!--It allows using examples from docs as complete code snippets.-->
完全なコードスニペットとしてdocsの例を使用することができます。
<!--But using `?`-->
しかし、`?`
<!--makes compilation fail since `main` returns `unit`.-->
コンパイルが失敗しますので、`main`返し`unit`。
<!--The ability to hide some source lines from documentation comes to the rescue: one may write `fn try_main() -> Result<(), ErrorType>`, hide it and `unwrap` it in hidden `main`.-->
ドキュメントからいくつかのソース行を非表示にする機能は、救助に来る：1に書くことが`fn try_main() -> Result<(), ErrorType>`それを隠し、`unwrap`隠された中で、それを`main`。
<!--Sounds complicated?-->
複雑に聞こえる？
<!--Here's an example:-->
ここに例があります：

```rust,ignore
#///// Using hidden `try_main` in doc tests.
///  docテストで隠された`try_main`を使う
///
#///// ```
///  `` ``
#///// # // hidden lines start with `#` symbol, but they're still compileable!
///  ＃//隠線は`#`記号で始まりますが、まだコンパイルできます！
#///// # fn try_main() -> Result<(), String> { // line that wraps the body shown in doc
///  ＃fn try_main（）->結果<（）、String> {// docに表示されている本文をラップする行
#///// let res = try::try_div(10, 2)?;
///  res = try:: try_div（10、2）？
#///// # Ok(()) // returning from try_main
///  ＃Ok（（））// try_mainから戻る
#///// # }
///  ＃}
#///// # fn main() { // starting main that'll unwrap()
///  ＃fn main（）{//アンラップするメインを開始（）
#///// #    try_main().unwrap(); // calling try_main and unwrapping
///  ＃try_main（）。unwrap（）; // try_mainを呼び出してアンラッピングする
#///// #                         // so that test will panic in case of error
///  ＃//エラーの場合にテストがパニックになる
#///// # }
///  ＃}
pub fn try_div(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err(String::from("Divide-by-zero"))
    } else {
        Ok(a / b)
    }
}
```

## <!--See Also--> 関連項目

* <!--[RFC505][RFC505] on documentation style-->
   ドキュメントスタイルに関する[RFC505][RFC505]
* <!--[API Guidelines][doc-nursery] on documentation guidelines-->
   ドキュメントガイドラインに関する[APIガイドライン][doc-nursery]

<!--[doc-nursery]: https://rust-lang-nursery.github.io/api-guidelines/documentation.html
 [markdown]: https://daringfireball.net/projects/markdown/
 [RFC505]: https://github.com/rust-lang/rfcs/blob/master/text/0505-api-comment-conventions.md
 [question-instead-of-unwrap]: https://rust-lang-nursery.github.io/api-guidelines/documentation.html#examples-use--not-try-not-unwrap-c-question-mark
-->
[doc-nursery]: https://rust-lang-nursery.github.io/api-guidelines/documentation.html
 [markdown]: https://daringfireball.net/projects/markdown/
 [RFC505]: https://github.com/rust-lang/rfcs/blob/master/text/0505-api-comment-conventions.md
 [question-instead-of-unwrap]: https://rust-lang-nursery.github.io/api-guidelines/documentation.html#examples-use--not-try-not-unwrap-c-question-mark

