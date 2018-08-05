# <!--dyn Trait--> dyn特性

<!--The `dyn Trait` feature is the new syntax for using trait objects.-->
`dyn Trait`機能は、traitオブジェクトを使用するための新しい構文です。
<!--In short:-->
要するに：

* <!--`Box<Trait>` becomes `Box<dyn Trait>`-->
   `Box<Trait>`は`Box<dyn Trait>`なります`Box<dyn Trait>`
* <!--`&Trait` and `&mut Trait` become `&dyn Trait` and `&mut dyn Trait`-->
   `&Trait`と`&mut Trait`になる`&dyn Trait`と`&mut dyn Trait`

<!--And so on.-->
等々。
<!--In code:-->
コード内：

```rust
trait Trait {}

impl Trait for i32 {}

#// old
// 古い
fn function1() -> Box<Trait> {
# unimplemented!()
}

#// new
// 新しい
fn function2() -> Box<dyn Trait> {
# unimplemented!()
}
```

<!--That's it!-->
それでおしまい！

## <!--More details--> 詳細

<!--Using just the trait name for trait objects turned out to be a bad decision.-->
形質オブジェクトの形質の名前だけを使用することは、悪い決定であることが判明しました。
<!--The current syntax is often ambiguous and confusing, even to veterans, and favors a feature that is not more frequently used than its alternatives, is sometimes slower, and often cannot be used at all when its alternatives can.-->
現在の構文では、退役軍人にさえもしばしばあいまいで混乱しがちですが、代替案よりも頻繁に使用されない機能を好む場合があり、時には遅くなることがあります。

<!--Furthermore, with `impl Trait` arriving, "`impl Trait` vs `dyn Trait` "is much more symmetric, and therefore a bit nicer, than "`impl Trait` vs `Trait` ".-->
また、と`impl Trait`、「到着`impl Trait` VS `dyn Trait` 」はるかに対称であり、そして「より、したがってビットよりよい`impl Trait` VS `Trait` 」。
<!--`impl Trait` is explained further in the next section.-->
`impl Trait`については、次のセクションでさらに説明します。

<!--In the new edition, you should therefore prefer `dyn Trait` to just `Trait` where you need a trait object.-->
新版では、したがって、選ぶべき`dyn Trait`ちょうどに`Trait`あなたは形質オブジェクトが必要です。
