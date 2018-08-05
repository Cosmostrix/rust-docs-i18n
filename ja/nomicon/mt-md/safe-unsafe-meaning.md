# <!--How Safe and Unsafe Interact--> どのように安全で安全でないかインタラクト

<!--What's the relationship between Safe Rust and Unsafe Rust?-->
安全な錆と安全でない錆の関係は何ですか？
<!--How do they interact?-->
彼らはどのように相互作用しますか？

<!--The separation between Safe Rust and Unsafe Rust is controlled with the `unsafe` keyword, which acts as an interface from one to the other.-->
安全な錆と安全でない錆の分離は、`unsafe`キーワードを使用して制御されます。`unsafe`キーワードは、相互にインターフェースとして機能します。
<!--This is why we can say Safe Rust is a safe language: all the unsafe parts are kept exclusively behind the `unsafe` boundary.-->
これはSafe Rustが安全な言語であると言うことができる理由です。すべての安全でない部分は、`unsafe`境界の背後に排他的に保持されます。
<!--If you wish, you can even toss `#![forbid(unsafe_code)]` into your code base to statically guarantee that you're only writing Safe Rust.-->
あなたが望むのであれば、コードベースに`#![forbid(unsafe_code)]`ないコード`#![forbid(unsafe_code)]`を投げて、あなたがSafe Rustだけを書いていることを静的に保証することさえできます。

<!--The `unsafe` keyword has two uses: to declare the existence of contracts the compiler can't check, and to declare that a programmer has checked that these contracts have been upheld.-->
`unsafe`キーワードには、コンパイラーがチェックできないコントラクトの存在を宣言し、プログラマーがこれらのコントラクトが維持されていることを確認したことを宣言するという2つの用途があります。

<!--You can use `unsafe` to indicate the existence of unchecked contracts on  _functions_  and  _trait declarations_ .-->
`unsafe`を使用すると、 _関数_ と _特性宣言の_ チェックされていない契約の存在を示すことができます。
<!--On functions, `unsafe` means that users of the function must check that function's documentation to ensure they are using it in a way that maintains the contracts the function requires.-->
関数上、`unsafe`とは、関数のユーザーが、関数が必要とするコントラクトを維持する方法で関数のドキュメンテーションを使用していることを確認する必要があることを意味します。
<!--On trait declarations, `unsafe` means that implementors of the trait must check the trait documentation to ensure their implementation maintains the contracts the trait requires.-->
形質の宣言では、`unsafe`は、形質の作成者が形質の文書化をチェックして、その実施が形質が必要とする契約を維持することを保証することを意味する。

<!--You can use `unsafe` on a block to declare that all unsafe actions performed within are verified to uphold the contracts of those operations.-->
ブロック上で`unsafe`を使用すると、その中で実行されるすべての安全でないアクションが検証され、それらの操作のコントラクトを維持することが宣言されます。
<!--For instance, the index passed to `slice::get_unchecked` is in-bounds.-->
例えば、`slice::get_unchecked`渡されたインデックスはin-`slice::get_unchecked`です。

<!--You can use `unsafe` on a trait implementation to declare that the implementation upholds the trait's contract.-->
特性実装で`unsafe`を使用して、実装が特性の契約を維持することを宣言することができます。
<!--For instance, that a type implementing `Send` is really safe to move to another thread.-->
たとえば、`Send`実装している型は本当に別のスレッドに移動することが安全です。

<!--The standard library has a number of unsafe functions, including:-->
標準ライブラリには、以下を含む多くの安全でない関数があります。

* <!--`slice::get_unchecked`, which performs unchecked indexing, allowing memory safety to be freely violated.-->
   `slice::get_unchecked`、チェックされていないインデックス作成を実行し、メモリの安全性を自由に侵害することを可能にします。
* <!--`mem::transmute` reinterprets some value as having a given type, bypassing type safety in arbitrary ways (see [conversions] for details).-->
   `mem::transmute`は、型の安全性を任意の方法でバイパスして、ある型を持つものとして`mem::transmute`解釈します（詳細は[conversions]を参照してください）。
* <!--Every raw pointer to a sized type has an `offset` method that invokes Undefined Behavior if the passed offset is not ["in bounds"][ptr_offset].-->
   大きさのある型へのすべての生ポインタには、渡されたオフセットが["in bounds"で][ptr_offset]ない場合、Undefined Behaviorを呼び出す`offset`メソッドがあります。
* <!--All FFI (Foreign Function Interface) functions are `unsafe` to call because the other language can do arbitrary operations that the Rust compiler can't check.-->
   Rustコンパイラがチェックできない任意の操作を他の言語でも実行できるため、すべてのFFI（Foreign Function Interface）関数は呼び出すのが`unsafe`はありません。

<!--As of Rust 1.0 there are exactly two unsafe traits:-->
Rust 1.0の時点では、まったく2つの危険な特性があります。

* <!--`Send` is a marker trait (a trait with no API) that promises implementors are safe to send (move) to another thread.-->
   `Send`は、実装者が別のスレッドに送信（移動）することを約束するマーカー特性（APIを持たない特性）です。
* <!--`Sync` is a marker trait that promises threads can safely share implementors through a shared reference.-->
   `Sync`は、スレッドが共有参照を通じて実装者を安全に共有できることを保証するマーカー特性です。

<!--Much of the Rust standard library also uses Unsafe Rust internally.-->
Rust標準ライブラリの多くは、Unsafe Rustも内部的に使用しています。
<!--These implementations have generally been rigorously manually checked, so the Safe Rust interfaces built on top of these implementations can be assumed to be safe.-->
これらの実装は一般的に厳密に手動でチェックされているため、これらの実装の上に構築されたSafe Rustインタフェースは安全であると見なすことができます。

<!--The need for all of this separation boils down a single fundamental property of Safe Rust:-->
この分離のすべての必要性は、Safe Rustの単一の基本的な特性をもたらします。

<!--**No matter what, Safe Rust can't cause Undefined Behavior.**-->
**何があっても、Safe Rustは未定義の動作を引き起こすことはできません。**

<!--The design of the safe/unsafe split means that there is an asymmetric trust relationship between Safe and Unsafe Rust.-->
安全/安全でない分割の設計は、安全と安全でない錆の間に非対称の信頼関係が存在することを意味します。
<!--Safe Rust inherently has to trust that any Unsafe Rust it touches has been written correctly.-->
Safe Rust本質的に、それが触れる安全でない錆が正しく書かれていることを信頼しなければならない。
<!--On the other hand, Unsafe Rust has to be very careful about trusting Safe Rust.-->
一方、Unsafe RustはSafe Rustを信頼することに非常に注意する必要があります。

<!--As an example, Rust has the `PartialOrd` and `Ord` traits to differentiate between types which can "just"be compared, and those that provide a "total"ordering (which basically means that comparison behaves reasonably).-->
例として、Rustは`PartialOrd`と`Ord`特性を持っていて、"ちょうど"比較できる型と "合計"の順序付けを提供する型（基本的に比較が合理的に動作することを意味します）を区別します。

<!--`BTreeMap` doesn't really make sense for partially-ordered types, and so it requires that its keys implement `Ord`.-->
`BTreeMap`は、部分的に順序付けされた型に対して実際には意味をなさないので、そのキーが`Ord`実装する必要があります。
<!--However, `BTreeMap` has Unsafe Rust code inside of its implementation.-->
しかし、`BTreeMap`はその実装の中でUnsafe Rustコードを持っています。
<!--Because it would be unacceptable for a sloppy `Ord` implementation (which is Safe to write) to cause Undefined Behavior, the Unsafe code in BTreeMap must be written to be robust against `Ord` implementations which aren't actually total — even though that's the whole point of requiring `Ord`.-->
不確定な振る舞いを引き起こすために、厄介な`Ord`実装（これは書くことは安全です）では受け入れられないので、BTreeMapの安全でないコードは、実際には合計ではない`Ord`実装に対して堅牢であるように書かれなければなりません。`Ord`必要とする。

<!--The Unsafe Rust code just can't trust the Safe Rust code to be written correctly.-->
安全でない錆のコードは、安全な錆のコードが正しく書き込まれることを信用できません。
<!--That said, `BTreeMap` will still behave completely erratically if you feed in values that don't have a total ordering.-->
つまり、`BTreeMap`は、完全な順序付けをしていない値を`BTreeMap`すると、完全に不規則に振る舞います。
<!--It just won't ever cause Undefined Behavior.-->
未定義の振る舞いを引き起こすことはありません。

<!--One may wonder, if `BTreeMap` cannot trust `Ord` because it's Safe, why can it trust *any* Safe code?-->
場合は、1つは、不思議に思うかもしれ`BTreeMap`信頼することはできません`Ord`、それは安全だから、なぜそれが*どんな*安全なコードを信頼することができ、？
<!--For instance `BTreeMap` relies on integers and slices to be implemented correctly.-->
例えば、`BTreeMap`は、整数とスライスを正しく実装する必要があります。
<!--Those are safe too, right?-->
それらも安全です、そうですか？

<!--The difference is one of scope.-->
違いはスコープの1つです。
<!--When `BTreeMap` relies on integers and slices, it's relying on one very specific implementation.-->
`BTreeMap`が整数とスライスに頼っている場合、非常に具体的な実装に依存しています。
<!--This is a measured risk that can be weighed against the benefit.-->
これは、利益に対して計量化できる測定されたリスクです。
<!--In this case there's basically zero risk;-->
この場合、基本的にリスクはゼロです。
<!--if integers and slices are broken, *everyone* is broken.-->
整数やスライスが壊れると、*誰も*が壊れてしまいます。
<!--Also, they're maintained by the same people who maintain `BTreeMap`, so it's easy to keep tabs on them.-->
また、`BTreeMap`を維持しているのと同じ人たちによって管理されているので、それらを監視するのは簡単です。

<!--On the other hand, `BTreeMap` 's key type is generic.-->
一方、`BTreeMap`のキータイプは汎用です。
<!--Trusting its `Ord` implementation means trusting every `Ord` implementation in the past, present, and future.-->
`Ord`実装を信頼するということは、過去、現在、そして将来のすべての`Ord`実装を信頼することを意味します。
<!--Here the risk is high: someone somewhere is going to make a mistake and mess up their `Ord` implementation, or even just straight up lie about providing a total ordering because "it seems to work".-->
ここではリスクが高い：誰かがどこかで間違いを犯して`Ord`実装を混乱させるか、まったくまっすぐ上になると、"それはうまくいく"ため、全体的な注文を提供することになります。
<!--When that happens, `BTreeMap` needs to be prepared.-->
それが起こると、`BTreeMap`を準備する必要があります。

<!--The same logic applies to trusting a closure that's passed to you to behave correctly.-->
同じロジックが、正しく動作するように渡されたクロージャを信頼することにも適用されます。

<!--This problem of unbounded generic trust is the problem that `unsafe` traits exist to resolve.-->
無制限の一般的な信頼のこの問題は、`unsafe`特性が解決する問題があります。
<!--The `BTreeMap` type could theoretically require that keys implement a new trait called `UnsafeOrd`, rather than `Ord`, that might look like this:-->
`BTreeMap`型では理論的には、`Ord`ではなく`UnsafeOrd`という新しい特性をキーに実装する必要があります。これは次のようになります。

```rust
use std::cmp::Ordering;

unsafe trait UnsafeOrd {
    fn cmp(&self, other: &Self) -> Ordering;
}
```

<!--Then, a type would use `unsafe` to implement `UnsafeOrd`, indicating that they've ensured their implementation maintains whatever contracts the trait expects.-->
`UnsafeOrd`を実装するには`unsafe`を使用し、その実装が特性が期待するどんな契約も維持することを保証していることを示します。
<!--In this situation, the Unsafe Rust in the internals of `BTreeMap` would be justified in trusting that the key type's `UnsafeOrd` implementation is correct.-->
この状況では、`BTreeMap`の内部のUnsafe Rustは、キータイプの`UnsafeOrd`実装が正しいことを信頼することで正当化されます。
<!--If it isn't, it's the fault of the unsafe trait implementation, which is consistent with Rust's safety guarantees.-->
そうでない場合は、Rustの安全性の保証と合致する、安全でない特性の実装の誤りです。

<!--The decision of whether to mark a trait `unsafe` is an API design choice.-->
形質を`unsafe`ものにするかどうかの決定は、API設計の選択肢です。
<!--Rust has traditionally avoided doing this because it makes Unsafe Rust pervasive, which isn't desirable.-->
Rustは伝統的にこれを避けています。これはUnsafe Rustが普及しているため望ましくありません。
<!--`Send` and `Sync` are marked unsafe because thread safety is a *fundamental property* that unsafe code can't possibly hope to defend against in the way it could defend against a bad `Ord` implementation.-->
`Send`と`Sync`は安全ではないとマークされています。これは、安全でないコードが悪い`Ord`実装に対して防御できる方法で防御できないという*基本的なプロパティ*だからです。
<!--The decision of whether to mark your own traits `unsafe` depends on the same sort of consideration.-->
あなた自身の形質を`unsafe`するかどうかの決定は、同じような配慮に依存します。
<!--If `unsafe` code can't reasonably expect to defend against a bad implementation of the trait, then marking the trait `unsafe` is a reasonable choice.-->
`unsafe`コードが特性の悪い実装に対して防御することを合理的に期待できない場合、その特性を`unsafe`とマークすることは合理的な選択です。

<!--As an aside, while `Send` and `Sync` are `unsafe` traits, they are *also* automatically implemented for types when such derivations are provably safe to do.-->
さて、`Send`と`Sync`は`unsafe`は`unsafe`特性ですが、これらの派生が安全に実行されることが安全である場合、型に対して*も*自動的に実装されます。
<!--`Send` is automatically derived for all types composed only of values whose types also implement `Send`.-->
`Send`は、型が`Send`実装する値だけで構成されるすべての型に対して自動的に導出されます。
<!--`Sync` is automatically derived for all types composed only of values whose types also implement `Sync`.-->
`Sync`は、タイプが`Sync`実装する値だけで構成されるすべてのタイプに対して自動的に導出されます。
<!--This minimizes the pervasive unsafety of making these two traits `unsafe`.-->
これは、これらの2つの特性を`unsafe`することの普及した安全性を最小限にする。

<!--This is the balance between Safe and Unsafe Rust.-->
これは、セーフと安全でない錆のバランスです。
<!--The separation is designed to make using Safe Rust as ergonomic as possible, but requires extra effort and care when writing Unsafe Rust.-->
この分離は、できるだけ人間工学に基づいてSafe Rustを使用するように設計されていますが、Unsafe Rustを書くときには特別な努力と注意が必要です。
<!--The rest of this book is largely a discussion of the sort of care that must be taken, and what contracts Unsafe Rust must uphold.-->
この本の残りの部分は主に、取り組まなければならないケアの種類と、Unsafe Rustの契約が維持しなければならないものについての議論です。

<!--[conversions]: conversions.html
 [ptr_offset]: ../std/primitive.pointer.html#method.offset
-->
[conversions]: conversions.html
 [ptr_offset]: ../std/primitive.pointer.html#method.offset


