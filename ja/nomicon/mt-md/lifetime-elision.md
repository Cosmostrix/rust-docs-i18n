# <!--Lifetime Elision--> ライフタイムエリート

<!--In order to make common patterns more ergonomic, Rust allows lifetimes to be *elided* in function signatures.-->
一般的なパターンをより人間工学的にするために、Rustは機能シグニチャで寿命を*省略*することができます。

<!--A *lifetime position* is anywhere you can write a lifetime in a type:-->
*生涯のポジション*はどこにでも書くことができます。

```rust,ignore
&'a T
&'a mut T
T<'a>
```

<!--Lifetime positions can appear as either "input"or "output":-->
生涯のポジションは、「入力」または「出力」のいずれかで表示されます。

* <!--For `fn` definitions, input refers to the types of the formal arguments in the `fn` definition, while output refers to result types.-->
   ため`fn`定義、入力における仮引数の型を指す`fn`出力は、タイプ結果を参照しながら、定義。
<!--So `fn foo(s: &str) -> (&str, &str)` has elided one lifetime in input position and two lifetimes in output position.-->
   したがって、`fn foo(s: &str) -> (&str, &str)`は、入力位置で1つの存続期間、出力位置で2つの存続期間を省略しました。
<!--Note that the input positions of a `fn` method definition do not include the lifetimes that occur in the method's `impl` header (nor lifetimes that occur in the trait header, for a default method).-->
   `fn`メソッド定義の入力位置には、メソッドの`impl`ヘッダー（デフォルトメソッドの場合、`impl`ヘッダー内に生存していない）で発生するライフタイムは含まれないことに注意してください。

* <!--In the future, it should be possible to elide `impl` headers in the same manner.-->
   将来、同じ方法で`impl`ヘッダを削除することが可能でなければなりません。

<!--Elision rules are as follows:-->
Elisionルールは次のとおりです。

* <!--Each elided lifetime in input position becomes a distinct lifetime parameter.-->
   入力位置の各寿命は、別個の寿命パラメータになります。

* <!--If there is exactly one input lifetime position (elided or not), that lifetime is assigned to *all* elided output lifetimes.-->
   厳密に1つの入力ライフタイム位置が存在する場合（省略されている場合とされていない場合）、そのライフタイムは省略された*すべての*出力ライフタイムに割り当てられます。

* <!--If there are multiple input lifetime positions, but one of them is `&self` or `&mut self`, the lifetime of `self` is assigned to *all* elided output lifetimes.-->
   そこに複数の入力生涯の位置であるが、そのうちの一つがある場合は`&self`または`&mut self`、寿命の`self` *すべて*省略さ出力寿命に割り当てられています。

* <!--Otherwise, it is an error to elide an output lifetime.-->
   それ以外の場合は、出力ライフタイムを削除するのはエラーです。

<!--Examples:-->
例：

```rust,ignore
#//fn print(s: &str);                                      // elided
fn print(s: &str);                                      // 逃げた
#//fn print<'a>(s: &'a str);                               // expanded
fn print<'a>(s: &'a str);                               // 拡張された

#//fn debug(lvl: usize, s: &str);                          // elided
fn debug(lvl: usize, s: &str);                          // 逃げた
#//fn debug<'a>(lvl: usize, s: &'a str);                   // expanded
fn debug<'a>(lvl: usize, s: &'a str);                   // 拡張された

#//fn substr(s: &str, until: usize) -> &str;               // elided
fn substr(s: &str, until: usize) -> &str;               // 逃げた
#//fn substr<'a>(s: &'a str, until: usize) -> &'a str;     // expanded
fn substr<'a>(s: &'a str, until: usize) -> &'a str;     // 拡張された

#//fn get_str() -> &str;                                   // ILLEGAL
fn get_str() -> &str;                                   // 不当

#//fn frob(s: &str, t: &str) -> &str;                      // ILLEGAL
fn frob(s: &str, t: &str) -> &str;                      // 不当

#//fn get_mut(&mut self) -> &mut T;                        // elided
fn get_mut(&mut self) -> &mut T;                        // 逃げた
#//fn get_mut<'a>(&'a mut self) -> &'a mut T;              // expanded
fn get_mut<'a>(&'a mut self) -> &'a mut T;              // 拡張された

#//fn args<T: ToCStr>(&mut self, args: &[T]) -> &mut Command                  // elided
fn args<T: ToCStr>(&mut self, args: &[T]) -> &mut Command                  // 逃げた
#//fn args<'a, 'b, T: ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command // expanded
fn args<'a, 'b, T: ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command // 拡張された

#//fn new(buf: &mut [u8]) -> BufWriter;                    // elided
fn new(buf: &mut [u8]) -> BufWriter;                    // 逃げた
#//fn new<'a>(buf: &'a mut [u8]) -> BufWriter<'a>          // expanded
fn new<'a>(buf: &'a mut [u8]) -> BufWriter<'a>          // 拡張された

```
