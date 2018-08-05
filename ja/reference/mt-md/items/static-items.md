# <!--Static items--> 静的アイテム

> <!--**<sup>Syntax</sup>** \  _StaticItem_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _StaticItem_ ：\＆nbsp;＆nbsp;
> <!--`static` `mut`  __?__ -->
> `static` `mut`  __？__ 
> <!--[IDENTIFIER] `:` [_Type_] `=` [_Expression_] `;`-->
> [IDENTIFIER] `:` [_Type_] `=` [_Expression_] `;`

<!--A *static item* is similar to a [constant], except that it represents a precise memory location in the program.-->
*静的項目*は、プログラム内の正確なメモリ位置を表すことを除けば、[constant]に似ています。
<!--All references to the static refer to the same memory location.-->
スタティックへのすべての参照は、同じメモリ位置を参照します。
<!--Static items have the `static` lifetime, which outlives all other lifetimes in a Rust program.-->
静的アイテムには`static`ライフタイムがあり、これはRustプログラムの他のすべてのライフタイムよりも長くなります。
<!--Non-`mut` static items that contain a type that is not [interior mutable] may be placed in read-only memory.-->
[interior mutable]でない型を含む非`mut` static項目は、読み取り専用メモリに置くことができます。
<!--Static items do not call [`drop`] at the end of the program.-->
静的項目は、プログラムの最後に[`drop`]を呼び出さない。

<!--All access to a static is safe, but there are a number of restrictions on statics:-->
スタティックへのアクセスはすべて安全ですが、スタティックにはいくつかの制限があります：

* <!--The type must have the `Sync` trait bound to allow thread-safe access.-->
   スレッドセーフなアクセスを可能にするには、型に`Sync`特性が必要です。
* <!--Statics allow using paths to statics in the [constant-expression] used to initialize them, but statics may not refer to other statics by value, only through a reference.-->
   Staticsでは、初期化に使用される[constant-expression]中の静的変数へのパスを使用することができますが、静的な参照では値を基準にして他の静的型を参照することはできません。
* <!--Constants cannot refer to statics.-->
   定数は静的を参照することはできません。

## <!--Mutable statics--> 変更可能な静的

<!--If a static item is declared with the `mut` keyword, then it is allowed to be modified by the program.-->
静的項目が`mut`キーワードで宣言されている場合は、プログラムによって変更が許可されます。
<!--One of Rust's goals is to make concurrency bugs hard to run into, and this is obviously a very large source of race conditions or other bugs.-->
Rustの目標の1つは、並行処理のバグを実行しにくくすることです。これは明らかに競合状態やその他のバグの原因となります。
<!--For this reason, an `unsafe` block is required when either reading or writing a mutable static variable.-->
このため、可変静的変数を読み書きする場合、`unsafe`ブロックが必要です。
<!--Care should be taken to ensure that modifications to a mutable static are safe with respect to other threads running in the same process.-->
同じプロセスで実行されている他のスレッドに対して、変更可能な静的な変更が確実に行われるように注意する必要があります。

<!--Mutable statics are still very useful, however.-->
しかし、変更可能な静的変数は非常に便利です。
<!--They can be used with C libraries and can also be bound from C libraries in an `extern` block.-->
それらはCライブラリと共に使用することができ、`extern`ブロック内のCライブラリからバインドすることもできます。

```rust
# fn atomic_add(_: &mut u32, _: u32) -> u32 { 2 }

static mut LEVELS: u32 = 0;

#// This violates the idea of no shared state, and this doesn't internally
#// protect against races, so this function is `unsafe`
// これは、共有状態がないという考え方に違反し、これは内部的にレースに対して保護しないので、この関数は`unsafe`はあり`unsafe`
unsafe fn bump_levels_unsafe1() -> u32 {
    let ret = LEVELS;
    LEVELS += 1;
    return ret;
}

#// Assuming that we have an atomic_add function which returns the old value,
#// this function is "safe" but the meaning of the return value may not be what
#// callers expect, so it's still marked as `unsafe`
// 我々は以前の値を返しますatomic_add機能を持っていると仮定すると、この機能は「安全」であるが、戻り値の意味は、発信者が期待するものではないかもしれないので、それはまだとしてマークされています`unsafe`
unsafe fn bump_levels_unsafe2() -> u32 {
    return atomic_add(&mut LEVELS, 1);
}
```

<!--Mutable statics have the same restrictions as normal statics, except that the type does not have to implement the `Sync` trait.-->
変更可能な静的型には、通常の静的型と同じ制限がありますが、型が`Sync`特性を実装する必要はありません。

## <!--Using Statics or Consts--> StaticsまたはConstsの使用

<!--It can be confusing whether or not you should use a constant item or a static item.-->
定数項目または静的項目を使用する必要があるかどうかを混乱させる可能性があります。
<!--Constants should, in general, be preferred over statics unless one of the following are true:-->
一般に、定数は以下のいずれかが当てはまる場合を除いて静的よりも優先されるべきです：

* <!--Large amounts of data are being stored-->
   大量のデータが保存されています
* <!--The single-address property of statics is required.-->
   静的な単一アドレスプロパティが必要です。
* <!--Interior mutability is required.-->
   インテリアの変更が必要です。

<!--[constant]: items/constant-items.html
 [`drop`]: destructors.html
 [constant expression]: expressions.html#constant-expressions
 [interior mutable]: interior-mutability.html
 [IDENTIFIER]: identifiers.html
 [_Type_]: types.html
 [_Expression_]: expressions.html
-->
[constant]: items/constant-items.html
 [`drop`]: destructors.html
 [constant expression]: expressions.html#constant-expressions
 [interior mutable]: interior-mutability.html
 [_Expression_]: expressions.html
 [IDENTIFIER]: identifiers.html
 [_Type_]: types.html
 [_Expression_]: expressions.html

