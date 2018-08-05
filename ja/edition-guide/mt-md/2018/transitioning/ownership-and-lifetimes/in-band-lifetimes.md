# <!--In-band lifetimes--> インバンドの寿命

<!--When writing an `fn` declaration, if a lifetime appears that is not already in scope, it is taken to be a new binding, ie treated as a parameter to the function.-->
`fn`宣言を書くときに、スコープ内にまだ存在していない生存時間が現れた場合、それは新しい束縛とみなされます。つまり、関数のパラメータとして扱われます。

<!--So, in Rust 2015, you'd write:-->
ですから、2015年のRustでは次のように書いています：

```rust,ignore
fn two_args<'bar>(foo: &Foo, bar: &'bar Bar) -> &'bar Baz
```

<!--In Rust 2018, you'd write:-->
Rust 2018では次のように書いています。

```rust,ignore
fn two_args(foo: &Foo, bar: &'bar Bar) -> &'bar Baz
```

<!--In other words, you can drop the explicit lifetime parameter declaration, and instead simply start using a new lifetime name to connect lifetimes together.-->
つまり、明示的な存続時間パラメータ宣言を削除して、代わりに新しい生涯名前を使用して生涯を一緒に接続することができます。
