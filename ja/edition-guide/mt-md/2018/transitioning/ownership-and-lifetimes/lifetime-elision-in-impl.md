# <!--Lifetime elision in `impl`--> ライフタイムエリシ`impl`

<!--When writing an `impl`, you can mention lifetimes without them being bound in the argument list.-->
`impl`書くとき、引数リストにバインドされていない生存時間を記述することができます。
<!--This is similar to [in-band-lifetimes](2018/transitioning/ownership-and-lifetimes/in-band-lifetimes.html) but for `impl` s.-->
これは[in-band-lifetimes](2018/transitioning/ownership-and-lifetimes/in-band-lifetimes.html)似ていますが、`impl`の場合に似ています。

<!--In Rust 2015:-->
錆2015年：

```rust,ignore
impl<'a> Iterator for MyIter<'a> { ... }
impl<'a, 'b> SomeTrait<'a> for SomeType<'a, 'b> { ... }
```

<!--In Rust 2018:-->
錆2018年：

```rust,ignore
impl Iterator for MyIter<'iter> { ... }
impl SomeTrait<'tcx> for SomeType<'tcx, 'gcx> { ... }
```

## <!--More details--> 詳細

<!--To show off how this combines with in-band lifetimes in methods/functions, in Rust 2015:-->
Rust 2015では、これが方法/機能における帯域内の有効期間とどのように結びついているかを示すために：

```rust,ignore
#// Rust 2015
//  2015年の錆

impl<'a> MyStruct<'a> {
    fn foo(&self) -> &'a str

#    // we have to use 'b here because it conflicts with the 'a above.
#    // If this weren't part of an `impl`, we'd be using `'a`.
    // 私たちは 'aと矛盾するので'ここで 'b'を使う必要があります。これが`impl`れていない場合は、`'a`を使用`'a`ます。
    fn bar<'b>(&self, arg: &'b str) -> &'b str
}
```

<!--in Rust 2018:-->
2018年の錆：

```rust,ignore
#// Rust 2018
// 錆2018

#// no need for the repetition of 'a
//  'aの繰り返しは必要ありません
impl MyStruct<'a> {

#    // this works just like before
    // 前と同じように動作します
    fn foo(&self) -> &'a str

#    // we can declare 'b inline here
    // 私たちはここでインラインでbを宣言できます
    fn bar(&self, arg: &'b str) -> &'b str
}
```
