# <!--PhantomData--> PhantomData

<!--When working with unsafe code, we can often end up in a situation where types or lifetimes are logically associated with a struct, but not actually part of a field.-->
安全でないコードを扱う場合、型や寿命が構造体に論理的に関連付けられているが、実際にはフィールドの一部ではないという状況に終わることがよくあります。
<!--This most commonly occurs with lifetimes.-->
これは生涯に最も一般的に起こります。
<!--For instance, the `Iter` for `&'a [T]` is (approximately) defined as follows:-->
例えば、`&'a [T]`の`Iter`は、（ほぼ）以下のように定義されます。

```rust,ignore
struct Iter<'a, T: 'a> {
    ptr: *const T,
    end: *const T,
}
```

<!--However because `'a` is unused within the struct's body, it's *unbounded*.-->
しかし、`'a`は構造体内では使用されていないため、*無制限*です。
<!--Because of the troubles this has historically caused, unbounded lifetimes and types are *forbidden* in struct definitions.-->
これは歴史的に起こったトラブルのため、無制限の生存期間と型は構造体定義では*禁止さ*れています。
<!--Therefore we must somehow refer to these types in the body.-->
したがって、私たちは何とか身体の中のこれらのタイプを参照する必要があります。
<!--Correctly doing this is necessary to have correct variance and drop checking.-->
正しい分散とドロップチェックを行うには、これを正しく行う必要があります。

<!--We do this using `PhantomData`, which is a special marker type.-->
特別なマーカータイプである`PhantomData`を使用してこれを`PhantomData`ます。
<!--`PhantomData` consumes no space, but simulates a field of the given type for the purpose of static analysis.-->
`PhantomData`はスペースを消費しませんが、静的解析の目的で特定のタイプのフィールドをシミュレートします。
<!--This was deemed to be less error-prone than explicitly telling the type-system the kind of variance that you want, while also providing other useful such as the information needed by drop check.-->
これは、タイプ・システムに明示的に分散の種類を伝えるのではなく、ドロップ・チェックによって必要とされる情報などの他の有用な情報を提供することより、エラーが起こりにくいと考えられました。

<!--Iter logically contains a bunch of `&'a T` s, so this is exactly what we tell the PhantomData to simulate:-->
論理的には`&'a T`の束が含まれているので、これはまさにPhantomDataにシミュレートするものです。

```
use std::marker;

struct Iter<'a, T: 'a> {
    ptr: *const T,
    end: *const T,
    _marker: marker::PhantomData<&'a T>,
}
```

<!--and that's it.-->
以上です。
<!--The lifetime will be bounded, and your iterator will be variant over `'a` and `T`.-->
生涯は拘束され、イテレータは`'a`と`T` `'a`変形です。
<!--Everything Just Works.-->
すべてがちょうど動作します。

<!--Another important example is Vec, which is (approximately) defined as follows:-->
もう1つの重要な例はVecであり、これは（ほぼ）次のように定義されています。

```
struct Vec<T> {
#//    data: *const T, // *const for variance!
    data: *const T, //  *分散のためのconst！
    len: usize,
    cap: usize,
}
```

<!--Unlike the previous example, it *appears* that everything is exactly as we want.-->
前の例とは異なり、すべてが正確に私たちが望むように*見えます*。
<!--Every generic argument to Vec shows up in at least one field.-->
Vecの一般的な引数はすべて、少なくとも1つのフィールドに表示されます。
<!--Good to go!-->
行ってもいい！

<!--Nope.-->
いいえ。

<!--The drop checker will generously determine that `Vec<T>` does not own any values of type T. This will in turn make it conclude that it doesn't need to worry about Vec dropping any T's in its destructor for determining drop check soundness.-->
ドロップチェッカーは、`Vec<T>`がタイプTの値を所有していないことを寛大に判断します。これは、ドロップチェックの健全性を判断するためにVecがそのデストラクタにドロップすることを心配する必要がないと結論づけます。
<!--This will in turn allow people to create unsoundness using Vec's destructor.-->
これにより、人々はVecのデストラクタを使って無気力を作り出すことができます。

<!--In order to tell dropck that we *do* own values of type T, and therefore may drop some T's when *we* drop, we must add an extra PhantomData saying exactly that:-->
私たちは、型Tの独自の値を*行い*、それゆえ*我々は*ドロップしたときに、いくつかのTさんは、私たちはまさにそれを言って、余分なPhantomDataを追加する必要がありますドロップすることがdropck伝えるために：

```
use std::marker;

struct Vec<T> {
#//    data: *const T, // *const for variance!
    data: *const T, //  *分散のためのconst！
    len: usize,
    cap: usize,
    _marker: marker::PhantomData<T>,
}
```

<!--Raw pointers that own an allocation is such a pervasive pattern that the standard library made a utility for itself called `Unique<T>` which:-->
割り当てを所有する生ポインタは、標準ライブラリが`Unique<T>`という`Unique<T>`ユーティリティを作成したような普遍的なパターンです。

* <!--wraps a `*const T` for variance-->
   分散のために`*const T`をラップする
* <!--includes a `PhantomData<T>`-->
   `PhantomData<T>`
* <!--auto-derives `Send` / `Sync` as if T was contained-->
   Tが含まれているかのように`Send` / `Sync`を自動派生させる
* <!--marks the pointer as `NonZero` for the null-pointer optimization-->
   ヌルポインタ最適化のためにポインタを`NonZero`としてマークします。

## <!--Table of `PhantomData` patterns--> `PhantomData`パターンの表

<!--Here's a table of all the wonderful ways `PhantomData` could be used:-->
`PhantomData`を使用することができるすばらしい方法の`PhantomData`は次のとおりです。

|<!--Phantom type-->ファントムタイプ|`'a`|`T`|
|<!--------------------------------->-----------------------------|<!--------------->-----------|<!------------------------------->---------------------------|
|`PhantomData<T>`|<!----->-|<!--variant (with drop check)-->バリアント（ドロップチェック付き）|
|`PhantomData<&'a T>`|<!--variant-->バリアント|<!--variant-->バリアント|
|`PhantomData<&'a mut T>`|<!--variant-->バリアント|<!--invariant-->不変の|
|`PhantomData<*const T>`|<!----->-|<!--variant-->バリアント|
|`PhantomData<*mut T>`|<!----->-|<!--invariant-->不変の|
|`PhantomData<fn(T)>`|<!----->-|<!--contravariant (*)-->反禁則（*）|
|`PhantomData<fn() -> T>`|<!----->-|<!--variant-->バリアント|
|`PhantomData<fn(T) -> T>`|<!----->-|<!--invariant-->不変の|
|`PhantomData<Cell<&'a ()>>`|<!--invariant-->不変の|<!----->-|

<!--(*) If contravariance gets scrapped, this would be invariant.-->
（*）反共分散が廃止された場合、これは不変である。
