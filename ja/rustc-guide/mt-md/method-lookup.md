# <!--Method lookup--> メソッドルックアップ

<!--Method lookup can be rather complex due to the interaction of a number of factors, such as self types, autoderef, trait lookup, etc. This file provides an overview of the process.-->
メソッドのルックアップは、自己タイプ、自動修正、特性検索など、いくつかの要因の相互作用のためにかなり複雑になる可能性があります。このファイルはプロセスの概要を提供します。
<!--More detailed notes are in the code itself, naturally.-->
より詳細なノートは、コード自体に自然にあります。

<!--One way to think of method lookup is that we convert an expression of the form:-->
メソッドルックアップを考える方法の1つは、フォームの式を変換することです。

```rust,ignore
receiver.method(...)
```

<!--into a more explicit [UFCS] form:-->
より明示的な[UFCS]形式に変換します。

```rust,ignore
#//Trait::method(ADJ(receiver), ...) // for a trait call
Trait::method(ADJ(receiver), ...) // 形質呼び出しのために
#//ReceiverType::method(ADJ(receiver), ...) // for an inherent method call
ReceiverType::method(ADJ(receiver), ...) // 固有のメソッド呼び出し
```

<!--Here `ADJ` is some kind of adjustment, which is typically a series of autoderefs and then possibly an autoref (eg, `&**receiver`).-->
ここで、`ADJ`はある種の調整ですが、これは一般的には一連のautoderefsであり、おそらくautoref（例： `&**receiver`）です。
<!--However we sometimes do other adjustments and coercions along the way, in particular unsizing (eg, converting from `[T; n]` to `[T]`).-->
しかし、途中で他の調整や強制を行う場合があります（特に`[T; n]`から`[T]`への変換）。

<!--Method lookup is divided into two major phases:-->
メソッドルックアップは2つの主要な段階に分かれています。

1. <!--Probing ([`probe.rs`][probe]).-->
    プローブ（プローブ[`probe.rs`][probe]）。
<!--The probe phase is when we decide what method to call and how to adjust the receiver.-->
    プローブフェーズは、どのメソッドを呼び出すか、受信側の調整方法を決定するときです。
2. <!--Confirmation ([`confirm.rs`][confirm]).-->
    確認（[`confirm.rs`][confirm]）。
<!--The confirmation phase "applies"this selection, updating the side-tables, unifying type variables, and otherwise doing side-effectful things.-->
    確認フェーズは、この選択を「適用」し、サイドテーブルを更新し、型変数を統一し、そうでなければ副作用を実行します。

<!--One reason for this division is to be more amenable to caching.-->
この部門の1つの理由は、キャッシングにもっと順応することです。
<!--The probe phase produces a "pick"(`probe::Pick`), which is designed to be cacheable across method-call sites.-->
プローブフェーズでは、"pick"（`probe::Pick`）が生成されます。これは、メソッド呼び出しサイト間でキャッシュ可能に設計されています。
<!--Therefore, it does not include inference variables or other information.-->
したがって、推論変数やその他の情報は含まれません。

<!--[UFCS]: https://github.com/rust-lang/rfcs/blob/master/text/0132-ufcs.md
 [probe]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_typeck/check/method/probe/
 [confirm]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_typeck/check/method/confirm/
-->
[UFCS]: https://github.com/rust-lang/rfcs/blob/master/text/0132-ufcs.md
 [probe]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_typeck/check/method/probe/
 [confirm]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc_typeck/check/method/confirm/


## <!--The Probe phase--> プローブフェーズ

### <!--Steps--> ステップ

<!--The first thing that the probe phase does is to create a series of *steps*.-->
プローブフェーズが最初に行うことは、一連の*ステップ*を作成すること*です*。
<!--This is done by progressively dereferencing the receiver type until it cannot be deref'd anymore, as well as applying an optional "unsize"step.-->
これは、受信機のタイプを、それがもはやderef'dできなくなるまで漸進的に逆参照し、オプションの「サイズ決め」ステップを適用することによって行われる。
<!--So if the receiver has type `Rc<Box<[T; 3]>>`-->
したがって、受信機がタイプ`Rc<Box<[T; 3]>>`
<!--`Rc<Box<[T; 3]>>`, this might yield:-->
`Rc<Box<[T; 3]>>`、次のようになります。

```rust,ignore
Rc<Box<[T; 3]>>
Box<[T; 3]>
[T; 3]
[T]
```

### <!--Candidate assembly--> 候補組立

<!--We then search along those steps to create a list of *candidates*.-->
それらのステップに沿って検索し、*候補*リストを作成します。
<!--A `Candidate` is a method item that might plausibly be the method being invoked.-->
`Candidate`は、呼び出されるメソッドである可能性が高いメソッド項目です。
<!--For each candidate, we'll derive a "transformed self type"that takes into account explicit self.-->
それぞれの候補について、明示的な自己を考慮に入れた「変形された自己タイプ」を導き出します。

<!--Candidates are grouped into two kinds, inherent and extension.-->
候補者は、内在と拡張の2種類に分類されます。

<!--**Inherent candidates** are those that are derived from the type of the receiver itself.-->
**固有の候補**は、受信機自体のタイプから導出されるものである。
<!--So, if you have a receiver of some nominal type `Foo` (eg, a struct), any methods defined within an impl like `impl Foo` are inherent methods.-->
だから、公称型の`Foo`（例えばstruct）のレシーバを持っていれば、 `impl Foo`ような`impl Foo`内に定義されたメソッドはすべて固有のメソッドです。
<!--Nothing needs to be imported to use an inherent method, they are associated with the type itself (note that inherent impls can only be defined in the same module as the type itself).-->
固有のメソッドを使用するためにインポートする必要はありません。型自体に関連付けられています（固有のimplsは型自体と同じモジュール内でのみ定義できます）。

<!--FIXME: Inherent candidates are not always derived from impls.-->
FIXME：内在する候補は、常にインプルメントから派生しているとは限りません。
<!--If you have a trait object, such as a value of type `Box<ToString>`, then the trait methods (`to_string()`, in this case) are inherently associated with it.-->
タイプ`Box<ToString>`値などの特性オブジェクトがある場合、特性メソッド（この場合は`to_string()`）が本来それに関連付けられます。
<!--Another case is type parameters, in which case the methods of their bounds are inherent.-->
もう1つのケースは型パラメータです。その場合、その境界のメソッドは固有のものです。
<!--However, this part of the rules is subject to change: when DST's "impl Trait for Trait"is complete, trait object dispatch could be subsumed into trait matching, and the type parameter behavior should be reconsidered in light of where clauses.-->
ただし、ルールのこの部分は変更される可能性があります。DSTの「インプライの特性」が完了したとき、特性オブジェクトのディスパッチが特性マッチングに組み込まれる可能性があり、タイプパラメータの動作はwhere句に照らして再考する必要があります。

<!--TODO: Is this FIXME still accurate?-->
TODO：このFIXMEはまだ正確ですか？

<!--**Extension candidates** are derived from imported traits.-->
**延長候補**は、輸入された形質から得られる。
<!--If I have the trait `ToString` imported, and I call `to_string()` on a value of type `T`, then we will go off to find out whether there is an impl of `ToString` for `T`.-->
私は形質を持っている場合`ToString`輸入、と私は呼ん`to_string()`タイプの値に`T`、そして我々は独自の実装があるかどうかを調べるために消灯します`ToString`のための`T`。
<!--These kinds of method calls are called "extension methods".-->
このようなメソッド呼び出しを「拡張メソッド」と呼びます。
<!--They can be defined in any module, not only the one that defined `T`.-->
それらは、`T`を定義したモジュールだけでなく、どのモジュールでも定義できます。
<!--Furthermore, you must import the trait to call such a method.-->
さらに、このようなメソッドを呼び出すためには、特性をインポートする必要があります。

<!--So, let's continue our example.-->
だから、私たちの例を続けましょう。
<!--Imagine that we were calling a method `foo` with the receiver `Rc<Box<[T; 3]>>`-->
私たちは、メソッド呼び出したことを想像し`foo`受信機で`Rc<Box<[T; 3]>>`
<!--`Rc<Box<[T; 3]>>` and there is a trait `Foo` that defines it with `&self` for the type `Rc<U>` as well as a method on the type `Box` that defines `Foo` but with `&mut self`.-->
`Rc<Box<[T; 3]>>`及び形質ある`Foo`とそれを定義する`&self`タイプの`Rc<U>`と同様型のメソッド`Box`定義`Foo`けれども有する`&mut self`。
<!--Then we might have two candidates: ` ``text &Rc<Box<[T; 3]>> from the impl of `Foo` for `Rc<U>` where `U=Box<T; 3]> &mut Box<[T; 3]>> from the inherent impl on `Box<U>` where `U=[T; 3]```-->
それでは、2つの候補があり``text &Rc<Box<[T; 3]>> from the impl of `Foo` for `Rc<U>` where `U=Box<T; 3]> &mut Box<[T; 3]>> from the inherent impl on `Box<U>` where `U=[T; 3]```： ` ``text &Rc<Box<[T; 3]>> from the impl of `Foo` for `Rc<U>` where `U=Box<T; 3]> &mut Box<[T; 3]>> from the inherent impl on `Box<U>` where `U=[T; 3]```
``text &Rc<Box<[T; 3]>> from the impl of `Foo` for `Rc<U>` where `U=Box<T; 3]> &mut Box<[T; 3]>> from the inherent impl on `Box<U>` where `U=[T; 3]``` <!--``text &Rc<Box<[T; 3]>> from the impl of `Foo` for `Rc<U>` where `U=Box<T; 3]> &mut Box<[T; 3]>> from the inherent impl on `Box<U>` where `U=[T; 3]``` `-->
``text &Rc<Box<[T; 3]>> from the impl of `Foo` for `Rc<U>` where `U=Box<T; 3]> &mut Box<[T; 3]>> from the inherent impl on `Box<U>` where `U=[T; 3]``` `

### <!--Candidate search--> 候補検索

<!--Finally, to actually pick the method, we will search down the steps, trying to match the receiver type against the candidate types.-->
最後に、実際にメソッドを選択するために、レシーバータイプと候補タイプを一致させようと、ステップを検索します。
<!--At each step, we also consider an auto-ref and auto-mut-ref to see whether that makes any of the candidates match.-->
各ステップでは、auto-refおよびauto-mut-refも考慮して候補のいずれかが一致するかどうかを確認します。
<!--We pick the first step where we find a match.-->
私たちはマッチを見つける最初のステップを選びます。

<!--In the case of our example, the first step is `Rc<Box<[T; 3]>>`-->
この例の場合、最初のステップは`Rc<Box<[T; 3]>>`
<!--`Rc<Box<[T; 3]>>`, which does not itself match any candidate.-->
`Rc<Box<[T; 3]>>`と一致しません。
<!--But when we autoref it, we get the type `&Rc<Box<[T; 3]>>`-->
しかし、それを自動化すると、`&Rc<Box<[T; 3]>>`
<!--`&Rc<Box<[T; 3]>>` which does match.-->
`&Rc<Box<[T; 3]>>`と一致します。
<!--We would then recursively consider all where-clauses that appear on the impl: if those match (or we cannot rule out that they do), then this is the method we would pick.-->
次に、implに現れるすべてのwhere節を再帰的に検討します。もし一致すれば（または、それが排除できない場合）、これが私たちが選ぶ方法です。
<!--Otherwise, we would continue down the series of steps.-->
それ以外の場合は、一連の手順を続行します。
