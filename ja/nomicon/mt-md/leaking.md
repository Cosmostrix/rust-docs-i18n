# <!--Leaking--> 漏れ

<!--Ownership-based resource management is intended to simplify composition.-->
所有権ベースのリソース管理は、構成を簡素化することを目的としています。
<!--You acquire resources when you create the object, and you release the resources when it gets destroyed.-->
オブジェクトを作成するときにリソースを取得し、リソースが破棄されるとリソースを解放します。
<!--Since destruction is handled for you, it means you can't forget to release the resources, and it happens as soon as possible!-->
破壊はあなたのために処理されるので、リソースを解放するのを忘れることができないことを意味し、できるだけ早くそれが起こります！
<!--Surely this is perfect and all of our problems are solved.-->
確かにこれは完璧で、すべての問題は解決されています。

<!--Everything is terrible and we have new and exotic problems to try to solve.-->
すべてがひどく、解決しようとする新しくて異国的な問題があります。

<!--Many people like to believe that Rust eliminates resource leaks.-->
多くの人々は、Rustがリソースリークを排除すると信じています。
<!--In practice, this is basically true.-->
実際には、これは基本的に真です。
<!--You would be surprised to see a Safe Rust program leak resources in an uncontrolled way.-->
あなたは、制御されない方法でSafe Rustプログラムのリークリソースを見ることに驚くでしょう。

<!--However from a theoretical perspective this is absolutely not the case, no matter how you look at it.-->
しかし、理論的な観点からは、あなたがそれをどのように見ても、これは絶対に当てはまりません。
<!--In the strictest sense, "leaking"is so abstract as to be unpreventable.-->
厳密な意味では、「漏れ」は不可避であるほど抽象的です。
<!--It's quite trivial to initialize a collection at the start of a program, fill it with tons of objects with destructors, and then enter an infinite event loop that never refers to it.-->
プログラムの開始時にコレクションを初期化し、デストラクタでたくさんのオブジェクトを埋め込み、決してそれを参照しない無限のイベントループに入るのは簡単です。
<!--The collection will sit around uselessly, holding on to its precious resources until the program terminates (at which point all those resources would have been reclaimed by the OS anyway).-->
コレクションは無駄になり、プログラムが終了するまでその貴重なリソースを保持します（その時点で、すべてのリソースがOSによって回収されます）。

<!--We may consider a more restricted form of leak: failing to drop a value that is unreachable.-->
もっと制限された形のリークが考えられるかもしれません：到達できない値を落とさないこと。
<!--Rust also doesn't prevent this.-->
錆もこれを防ぐものではありません。
<!--In fact Rust *has a function for doing this*: `mem::forget`.-->
実際に*は、* Rust *はこれを行うための関数を持っています*： `mem::forget`。
<!--This function consumes the value it is passed *and then doesn't run its destructor*.-->
この関数は渡された値を消費し、*そのデストラクタを実行しません*。

<!--In the past `mem::forget` was marked as unsafe as a sort of lint against using it, since failing to call a destructor is generally not a well-behaved thing to do (though useful for some special unsafe code).-->
過去の`mem::forget`は、デストラクタを呼び出さなかったことは一般的にうまく行かなかったため（ある特別な安全ではないコードでは便利ですが）、それを使用していることに対して、一種の糸くずとして安全でないとマークされていました。
<!--However this was generally determined to be an untenable stance to take: there are many ways to fail to call a destructor in safe code.-->
しかし、これは一般的には取るに足りない姿勢であると判断されました。安全なコードでデストラクタを呼び出すことができない多くの方法があります。
<!--The most famous example is creating a cycle of reference-counted pointers using interior mutability.-->
最も有名な例は、内部の変更を使用して参照カウントポインタのサイクルを作成することです。

<!--It is reasonable for safe code to assume that destructor leaks do not happen, as any program that leaks destructors is probably wrong.-->
デストラクタをリークするプログラムは間違っている可能性があるので、安全なコードではデストラクタのリークは起こらないと想定することは合理的です。
<!--However *unsafe* code cannot rely on destructors to be run in order to be safe.-->
しかし、*安全でない*コードは、安全のために実行されるデストラクタに依存することはできません。
<!--For most types this doesn't matter: if you leak the destructor then the type is by definition inaccessible, so it doesn't matter, right?-->
ほとんどの型ではこれは問題ではありません。デストラクタがリークした場合、型は定義上アクセスできないので、重要ではありません。
<!--For instance, if you leak a `Box<u8>` then you waste some memory but that's hardly going to violate memory-safety.-->
たとえば、`Box<u8>`をリークした場合、メモリが無駄になりますが、メモリの安全性にはほとんど`Box<u8>`ません。

<!--However where we must be careful with destructor leaks are *proxy* types.-->
しかし、デストラクタのリークに注意する必要があるところは、*プロキシ*タイプです。
<!--These are types which manage access to a distinct object, but don't actually own it.-->
これらは、別個のオブジェクトへのアクセスを管理するタイプですが、実際にはそれを所有しません。
<!--Proxy objects are quite rare.-->
プロキシオブジェクトは非常にまれです。
<!--Proxy objects you'll need to care about are even rarer.-->
気にする必要があるプロキシオブジェクトはさらに稀です。
<!--However we'll focus on three interesting examples in the standard library:-->
しかし、標準ライブラリの3つの興味深い例に焦点を当てます。

* `vec::Drain`
* `Rc`
* `thread::scoped::JoinGuard`



## <!--Drain--> ドレイン

<!--`drain` is a collections API that moves data out of the container without consuming the container.-->
`drain`は、コンテナを消費せずにコンテナからデータを移動するコレクションAPIです。
<!--This enables us to reuse the allocation of a `Vec` after claiming ownership over all of its contents.-->
これにより、`Vec`すべてのコンテンツに対する所有権を主張した後、`Vec`の割り当てを再利用することができます。
<!--It produces an iterator (Drain) that returns the contents of the Vec by-value.-->
Vecの値を返すイテレータ（Drain）を生成します。

<!--Now, consider Drain in the middle of iteration: some values have been moved out, and others haven't.-->
今度は、繰り返しの途中でDrainを検討してください：いくつかの値は移動されていますが、他の値は移動していません。
<!--This means that part of the Vec is now full of logically uninitialized data!-->
これは、Vecの一部が論理的に初期化されていないデータでいっぱいになったことを意味します。
<!--We could backshift all the elements in the Vec every time we remove a value, but this would have pretty catastrophic performance consequences.-->
値を取り除くたびにVecのすべての要素をバックシフトすることができますが、これはかなりの致命的なパフォーマンス結果を招きます。

<!--Instead, we would like Drain to fix the Vec's backing storage when it is dropped.-->
代わりに、Vecのバッキングストレージを落としたときにDrainに修正を依頼します。
<!--It should run itself to completion, backshift any elements that weren't removed (drain supports subranges), and then fix Vec's `len`.-->
完了するまで実行され、除去されなかった要素はすべてバックシフトされ（排水支配下位領域）、Vecの`len`修正する必要があります。
<!--It's even unwinding-safe!-->
それは巻き戻しにも安全です！
<!--Easy!-->
簡単！

<!--Now consider the following:-->
次に、以下を考慮してください。

```rust,ignore
let mut vec = vec![Box::new(0); 4];

{
#    // start draining, vec can no longer be accessed
    // 排水を開始すると、vecにアクセスできなくなります
    let mut drainer = vec.drain(..);

#    // pull out two elements and immediately drop them
    //  2つの要素を取り出してすぐに削除します
    drainer.next();
    drainer.next();

#    // get rid of drainer, but don't call its destructor
    // 排水器を取り除くが、そのデストラクタを呼び出さない
    mem::forget(drainer);
}

#// Oops, vec[0] was dropped, we're reading a pointer into free'd memory!
//  oops、vec [0]は落とした、私たちは自由なメモリへのポインタを読んでいる！
println!("{}", vec[0]);
```

<!--This is pretty clearly Not Good.-->
これはかなり明確にNot Goodです。
<!--Unfortunately, we're kind of stuck between a rock and a hard place: maintaining consistent state at every step has an enormous cost (and would negate any benefits of the API).-->
残念ながら、私たちは岩石と硬い場所の間にこだわっています。すべてのステップで一貫した状態を維持するには膨大なコストがかかります（また、APIのメリットも否定的です）。
<!--Failing to maintain consistent state gives us Undefined Behavior in safe code (making the API unsound).-->
一貫性のある状態を維持できないと、安全なコードでUndefined Behaviorが発生し、APIが不安定になります。

<!--So what can we do?-->
だから私たちは何をすることができますか？
<!--Well, we can pick a trivially consistent state: set the Vec's len to be 0 when we start the iteration, and fix it up if necessary in the destructor.-->
さて、一貫して一貫性のある状態を選ぶことができます。反復を開始するときにVecのlenを0に設定し、必要に応じてデストラクタで修正します。
<!--That way, if everything executes like normal we get the desired behavior with minimal overhead.-->
そうすれば、すべてが正常に実行されれば最小限のオーバーヘッドで望ましい動作が得られます。
<!--But if someone has the *audacity* to mem::forget us in the middle of the iteration, all that does is *leak even more* (and possibly leave the Vec in an unexpected but otherwise consistent state).-->
しかし、もし誰かがmemの*大胆さ*を持っているなら、繰り返しの途中で私たちを忘れてしまって*も、それ以上のリーク*が起こります。
<!--Since we've accepted that mem::forget is safe, this is definitely safe.-->
mem:: forgetが安全であることを受け入れているので、これは間違いなく安全です。
<!--We call leaks causing more leaks a *leak amplification*.-->
私たちは、より多くのリークを引き起こすリークを*リーク増幅*と呼びます。




## <!--Rc--> Rc

<!--Rc is an interesting case because at first glance it doesn't appear to be a proxy value at all.-->
一見したところ、プロキシの価値にはならないと思われるので、Rcは興味深いケースです。
<!--After all, it manages the data it points to, and dropping all the Rcs for a value will drop that value.-->
結局のところ、それはそれが指しているデータを管理し、値のためにすべてのRcsを落とすことはその値を落とします。
<!--Leaking an Rc doesn't seem like it would be particularly dangerous.-->
Rcを漏らすことは、特に危険であるようには思われません。
<!--It will leave the refcount permanently incremented and prevent the data from being freed or dropped, but that seems just like Box, right?-->
それはrefcountを恒久的にインクリメントしたままにして、データが解放されたり落ちたりするのを防ぎますが、それはBoxのようですね。

<!--Nope.-->
いいえ。

<!--Let's consider a simplified implementation of Rc:-->
Rcの単純化された実装を考えてみましょう：

```rust,ignore
struct Rc<T> {
    ptr: *mut RcBox<T>,
}

struct RcBox<T> {
    data: T,
    ref_count: usize,
}

impl<T> Rc<T> {
    fn new(data: T) -> Self {
        unsafe {
#            // Wouldn't it be nice if heap::allocate worked like this?
            // もしheap:: allocateがこのように働くといいのではないでしょうか？
            let ptr = heap::allocate::<RcBox<T>>();
            ptr::write(ptr, RcBox {
                data: data,
                ref_count: 1,
            });
            Rc { ptr: ptr }
        }
    }

    fn clone(&self) -> Self {
        unsafe {
            (*self.ptr).ref_count += 1;
        }
        Rc { ptr: self.ptr }
    }
}

impl<T> Drop for Rc<T> {
    fn drop(&mut self) {
        unsafe {
            (*self.ptr).ref_count -= 1;
            if (*self.ptr).ref_count == 0 {
#                // drop the data and then free it
                // データをドロップしてから解放する
                ptr::read(self.ptr);
                heap::deallocate(self.ptr);
            }
        }
    }
}
```

<!--This code contains an implicit and subtle assumption: `ref_count` can fit in a `usize`, because there can't be more than `usize::MAX` Rcs in memory.-->
このコードは、暗黙の微妙な仮定が含まれています`ref_count`に収まる`usize`よりも存在できないため、`usize::MAX` Rcsのメモリに。
<!--However this itself assumes that the `ref_count` accurately reflects the number of Rcs in memory, which we know is false with `mem::forget`.-->
しかし、これ自体はことを前提としてい`ref_count`正確に我々が偽である知っているメモリ内のRCの数、反映`mem::forget`。
<!--Using `mem::forget` we can overflow the `ref_count`, and then get it down to 0 with outstanding Rcs.-->
`mem::forget`を使うと、`ref_count`をオーバーフローさせて、未処理のRcsで0にすることができます。
<!--Then we can happily use-after-free the inner data.-->
それで、私たちは幸せに内部のデータを自由に使用することができます。
<!--Bad Bad Not Good.-->
悪い悪い良いではありません。

<!--This can be solved by just checking the `ref_count` and doing *something*.-->
これは、`ref_count`を確認して*何かを*するだけで解決できます。
<!--The standard library's stance is to just abort, because your program has become horribly degenerate.-->
標準的な図書館の立場は、あなたのプログラムがひどく堕落してしまったためです。
<!--Also *oh my gosh* it's such a ridiculous corner case.-->
また、*ああ私*のようにそれ*はそんなに*馬鹿なコーナーケースです。




## <!--thread::scoped::JoinGuard--> thread:: scoped:: JoinGuard

<!--The thread::scoped API intends to allow threads to be spawned that reference data on their parent's stack without any synchronization over that data by ensuring the parent joins the thread before any of the shared data goes out of scope.-->
thread:: scoped APIは、共有データがスコープ外に出る前に、親がスレッドに参加することを保証することによって、データを同期させることなく親スレッドのデータを参照するスレッドを生成できるようにします。

```rust,ignore
pub fn scoped<'a, F>(f: F) -> JoinGuard<'a>
    where F: FnOnce() + Send + 'a
```

<!--Here `f` is some closure for the other thread to execute.-->
ここで、`f`は他のスレッドが実行するためのクロージャです。
<!--Saying that `F: Send +'a` is saying that it closes over data that lives for `'a`, and it either owns that data or the data was Sync (implying `&data` is Send).-->
`F: Send +'a`それがために住んでいるデータの上に閉じていることを言っている`'a`、そしてそれは（暗示データまたはデータが同期されたことを所有しているいずれか`&data`送信です）。

<!--Because JoinGuard has a lifetime, it keeps all the data it closes over borrowed in the parent thread.-->
JoinGuardは存続期間があるため、親スレッドで借用して閉じるすべてのデータを保持します。
<!--This means the JoinGuard can't outlive the data that the other thread is working on.-->
つまり、JoinGuardは、他のスレッドが処理しているデータを残存させることはできません。
<!--When the JoinGuard *does* get dropped it blocks the parent thread, ensuring the child terminates before any of the closed-over data goes out of scope in the parent.-->
JoinGuard *が*ドロップされると、親スレッドをブロックし、クローズオーバーされたデータが親のスコープから外れる前に子プロセスが終了するようにします。

<!--Usage looked like:-->
使用状況は次のようになります。

```rust,ignore
let mut data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
{
    let guards = vec![];
    for x in &mut data {
#        // Move the mutable reference into the closure, and execute
#        // it on a different thread. The closure has a lifetime bound
#        // by the lifetime of the mutable reference `x` we store in it.
#        // The guard that is returned is in turn assigned the lifetime
#        // of the closure, so it also mutably borrows `data` as `x` did.
#        // This means we cannot access `data` until the guard goes away.
        // 変更可能な参照をクロージャに移動し、別のスレッドで実行します。クロージャの寿命は、変更可能な参照`x`ライフタイムによって制限されます。返されるガードは、クロージャーの存続期間に割り当てられます。したがって、`x`ように`data`を変更することもできます。つまり、ガードがなくなるまで`data`アクセスすることはできません。
        let guard = thread::scoped(move || {
            *x *= 2;
        });
#        // store the thread's guard for later
        // スレッドのガードを後で保存する
        guards.push(guard);
    }
#    // All guards are dropped here, forcing the threads to join
#    // (this thread blocks here until the others terminate).
#    // Once the threads join, the borrow expires and the data becomes
#    // accessible again in this thread.
    // すべてのガードがここにドロップされ、スレッドは強制的に結合されます（このスレッドは他のスレッドが終了するまでブロックされます）。スレッドが結合すると、借用は失効し、このスレッドで再びデータにアクセスできるようになります。
}
#// data is definitely mutated here.
// データは間違いなくここで突然変異しています。
```

<!--In principle, this totally works!-->
原則として、これは完全に機能します！
<!--Rust's ownership system perfectly ensures it!-->
Rustの所有システムは完全にそれを保証します！
<!--...except it relies on a destructor being called to be safe.-->
...それは安全であるように呼び出されているデストラクタに依存している点を除いて。

```rust,ignore
let mut data = Box::new(0);
{
    let guard = thread::scoped(|| {
#        // This is at best a data race. At worst, it's also a use-after-free.
        // これは最高でデータ競争です。最悪の場合、それはまたアフター・アフター・フリーです。
        *data += 1;
    });
#    // Because the guard is forgotten, expiring the loan without blocking this
#    // thread.
    // ガードは忘れられているので、このスレッドをブロックすることなくローンを終了します。
    mem::forget(guard);
}
#// So the Box is dropped here while the scoped thread may or may not be trying
#// to access it.
// それで、スコープされたスレッドがアクセスしようとしている間にボックスがドロップされます。
```

<!--Dang.-->
Dang。
<!--Here the destructor running was pretty fundamental to the API, and it had to be scrapped in favor of a completely different design.-->
ここでは、デストラクタの実行はAPIにとって基本的なものであり、完全に異なる設計に賛成して廃止されなければなりませんでした。
