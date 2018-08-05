# <!--Transmutes--> トランスミュート

<!--Get out of our way type system!-->
私たちの道のタイプのシステムから抜け出す！
<!--We're going to reinterpret these bits or die trying!-->
我々はこれらのビットを再解釈するか、試して死ぬつもりです！
<!--Even though this book is all about doing things that are unsafe, I really can't emphasize that you should deeply think about finding Another Way than the operations covered in this section.-->
この本は安全ではないことを行うことに関するものですが、このセクションで説明する操作以外の方法を見つけることについて深く考えなければならないということを強調することはできません。
<!--This is really, truly, the most horribly unsafe thing you can do in Rust.-->
これは本当に、真に、あなたがRustで行うことができる最も恐ろしく危険なことです。
<!--The railguards here are dental floss.-->
ここのレールガードはデンタルフロスです。

<!--`mem::transmute<T, U>` takes a value of type `T` and reinterprets it to have type `U`.-->
`mem::transmute<T, U>`は`T`型の値をとり、型`U`を持つように再解釈します。
<!--The only restriction is that the `T` and `U` are verified to have the same size.-->
唯一の制約は、`T`と`U`が同じサイズを持つことが確認されていることです。
<!--The ways to cause Undefined Behavior with this are mind boggling.-->
これで未定義の振る舞いを引き起こす方法は頭がおかしい。

* <!--First and foremost, creating an instance of *any* type with an invalid state is going to cause arbitrary chaos that can't really be predicted.-->
   まず第一に、無効な状態の*任意の*型のインスタンスを作成することは、実際には予測できない任意の混乱を引き起こすことになります。
* <!--Transmute has an overloaded return type.-->
   Transmuteには、オーバーロードされた戻り型があります。
<!--If you do not specify the return type it may produce a surprising type to satisfy inference.-->
   戻り値の型を指定しないと、推論を満たすために驚くべき型が生成される可能性があります。
* <!--Making a primitive with an invalid value is UB-->
   無効な値を持つプリミティブをUBにする
* <!--Transmuting between non-repr(C) types is UB-->
   非repr（C）型間の変換はUBです
* <!--Transmuting an & to &mut is UB-->
   ＆to＆mutをUBに変換する
    * <!--Transmuting an & to &mut is *always* UB-->
       ＆への＆mutのトランスミットは*常に* UBです
    * <!--No you can't do it-->
       いいえ、あなたはそれをすることはできません
    * <!--No you're not special-->
       いいえ、あなたは特別ではありません
* <!--Transmuting to a reference without an explicitly provided lifetime produces an [unbounded lifetime]-->
   明示的に提供されたライフタイムを使用せずにリファレンスにトランスミューティングすると、[unbounded lifetime]タイムが生成されます

<!--`mem::transmute_copy<T, U>` somehow manages to be *even more* wildly unsafe than this.-->
`mem::transmute_copy<T, U>`はこれより*もさらに*危険な*ほど*危険な状態を管理します。
<!--It copies `size_of<U>` bytes out of an `&T` and interprets them as a `U`.-->
`&T`から`size_of<U>`バイトをコピーし、それらを`U`と解釈します。
<!--The size check that `mem::transmute` has is gone (as it may be valid to copy out a prefix), though it is Undefined Behavior for `U` to be larger than `T`.-->
サイズチェック`mem::transmute`ために未定義の動作ですが、持っているが、（接頭辞をコピーするために有効であることなど）なくなって`U`よりも大きくなるように`T`。

<!--Also of course you can get most of the functionality of these functions using pointer casts.-->
もちろん、これらの関数のほとんどの機能をポインタキャストを使って取得することもできます。


[unbounded lifetime]: unbounded-lifetimes.html
