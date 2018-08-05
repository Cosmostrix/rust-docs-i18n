# <!--Send and Sync--> 送信と同期

<!--Not everything obeys inherited mutability, though.-->
しかし、すべてが継承された変異性に従うわけではありません。
<!--Some types allow you to have multiple aliases of a location in memory while mutating it.-->
いくつかの型では、場所を変更しながらメモリ内の複数のエイリアスを持つことができます。
<!--Unless these types use synchronization to manage this access, they are absolutely not thread-safe.-->
これらのタイプがこのアクセスを管理するために同期を使用しない限り、スレッドセーフではありません。
<!--Rust captures this through the `Send` and `Sync` traits.-->
錆は、`Send`と`Sync`特性によってこれを捕捉します。

* <!--A type is Send if it is safe to send it to another thread.-->
   他のスレッドに送信するのが安全な場合は、タイプは「送信」です。
* <!--A type is Sync if it is safe to share between threads (`&T` is Send).-->
   スレッド間で共有することが安全であれば、タイプは同期です（`&T`は送信）。

<!--Send and Sync are fundamental to Rust's concurrency story.-->
送信と同期はRustの並行処理の基本です。
<!--As such, a substantial amount of special tooling exists to make them work right.-->
そのようなものとして、それらを正しく機能させるための相当量の特殊工具が存在します。
<!--First and foremost, they're [unsafe traits].-->
まず第一に、彼らは[unsafe traits]です。
<!--This means that they are unsafe to implement, and other unsafe code can assume that they are correctly implemented.-->
これは、実装が安全でないことを意味し、他の安全でないコードは、それらが正しく実装されていると見なすことができます。
<!--Since they're *marker traits* (they have no associated items like methods), correctly implemented simply means that they have the intrinsic properties an implementor should have.-->
それらは*マーカーの特性*（メソッドのような関連項目はありません）であるため、正しく実装されているということは、単に実装者が持つべき固有のプロパティを持つことを意味します。
<!--Incorrectly implementing Send or Sync can cause Undefined Behavior.-->
送信または同期を誤って実装すると、未定義の動作が発生する可能性があります。

<!--Send and Sync are also automatically derived traits.-->
送信と同期も自動的に導出された特性です。
<!--This means that, unlike every other trait, if a type is composed entirely of Send or Sync types, then it is Send or Sync.-->
これは、他のすべての特性とは異なり、タイプが送信または同期のタイプで完全に構成されている場合は、送信または同期であることを意味します。
<!--Almost all primitives are Send and Sync, and as a consequence pretty much all types you'll ever interact with are Send and Sync.-->
ほとんどのプリミティブはSendとSyncです。その結果、あなたがやりとりするすべてのタイプは、SendとSyncです。

<!--Major exceptions include:-->
主な例外は次のとおりです。

* <!--raw pointers are neither Send nor Sync (because they have no safety guards).-->
   生ポインタは、送信ガードも同期もしません（セーフガードがないため）。
* <!--`UnsafeCell` isn't Sync (and therefore `Cell` and `RefCell` aren't).-->
   `UnsafeCell`は同期ではありません（したがって、`Cell`と`RefCell`は同期していません）。
* <!--`Rc` isn't Send or Sync (because the refcount is shared and unsynchronized).-->
   `Rc`はSendまたはSyncではありません（refcountが共有され、同期していないため）。

<!--`Rc` and `UnsafeCell` are very fundamentally not thread-safe: they enable unsynchronized shared mutable state.-->
`Rc`と`UnsafeCell`は、基本的にスレッドセーフではありません。これらは、非同期の共有可能な可変状態を有効にします。
<!--However raw pointers are, strictly speaking, marked as thread-unsafe as more of a *lint*.-->
しかし、生のポインタは、厳密に言えば、スレッドセーフでない*糸くず*のよりなどとしてマークされています。
<!--Doing anything useful with a raw pointer requires dereferencing it, which is already unsafe.-->
未処理のポインタで役に立つものを実行するには、それを逆参照する必要があります。これはすでに安全ではありません。
<!--In that sense, one could argue that it would be "fine"for them to be marked as thread safe.-->
その意味では、スレッドセーフとしてマークするのは「罰金」であると主張することができます。

<!--However it's important that they aren't thread-safe to prevent types that contain them from being automatically marked as thread-safe.-->
ただし、スレッドセーフではないことが重要です。スレッドセーフでないと、自動的にスレッドセーフとしてマークされません。
<!--These types have non-trivial untracked ownership, and it's unlikely that their author was necessarily thinking hard about thread safety.-->
これらのタイプは、非自明なトラッキングされていない所有権を持ちます。スレッドの安全性について、作者が必然的に考えているとは考えにくいです。
<!--In the case of `Rc`, we have a nice example of a type that contains a `*mut` that is definitely not thread-safe.-->
`Rc`の場合、確実にスレッドセーフではない`*mut`を含む型の良い例があります。

<!--Types that aren't automatically derived can simply implement them if desired:-->
自動的に導出されないタイプは、必要に応じて簡単に実装できます。

```rust
struct MyBox(*mut u8);

unsafe impl Send for MyBox {}
unsafe impl Sync for MyBox {}
```

<!--In the *incredibly rare* case that a type is inappropriately automatically derived to be Send or Sync, then one can also unimplement Send and Sync:-->
*非常にまれな*ケースでは、タイプがSendまたはSyncに自動的に不適切に誘導された場合、SendおよびSyncも実装できません。

```rust
#![feature(optin_builtin_traits)]

#// I have some magic semantics for some synchronization primitive!
// 私はいくつかの同期プリミティブのいくつかの魔法のセマンティクスを持っています！
struct SpecialThreadToken(u8);

impl !Send for SpecialThreadToken {}
impl !Sync for SpecialThreadToken {}
```

<!--Note that *in and of itself* it is impossible to incorrectly derive Send and Sync.-->
送信と同期を間違って派生させることは不可能*である*ことに注意してください。
<!--Only types that are ascribed special meaning by other unsafe code can possible cause trouble by being incorrectly Send or Sync.-->
他の安全でないコードによって特別な意味が与えられているタイプだけが、間違って送信または同期することによって問題を引き起こす可能性があります。

<!--Most uses of raw pointers should be encapsulated behind a sufficient abstraction that Send and Sync can be derived.-->
生ポインタのほとんどの使用法は、SendとSyncを導出するのに十分な抽象化の背後にカプセル化する必要があります。
<!--For instance all of Rust's standard collections are Send and Sync (when they contain Send and Sync types) in spite of their pervasive use of raw pointers to manage allocations and complex ownership.-->
たとえば、Rustの標準コレクションのすべては、割り当てや複雑な所有権を管理するために生ポインタを広範囲に使用しているにもかかわらず、SendとSync（SendタイプとSyncタイプが含まれている場合）です。
<!--Similarly, most iterators into these collections are Send and Sync because they largely behave like an `&` or `&mut` into the collection.-->
同様に、これらのコレクションのほとんどのイテレータは、SendおよびSyncです。これは、大部分がコレクションの`&`または`&mut`ように動作するためです。

<!--TODO: better explain what can or can't be Send or Sync.-->
TODO：送信または同期ができるかどうかを詳しく説明します。
<!--Sufficient to appeal only to data races?-->
データレースだけにアピールするには十分ですか？

[unsafe traits]: safe-unsafe-meaning.html
