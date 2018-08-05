# <!--Atomics--> アトミック

<!--Rust pretty blatantly just inherits C11's memory model for atomics.-->
錆はC11のアトミック用メモリモデルをちょうど継承しています。
<!--This is not due to this model being particularly excellent or easy to understand.-->
これは、このモデルが特に優れているか、または理解しやすいためではありません。
<!--Indeed, this model is quite complex and known to have [several flaws][C11-busted].-->
実際、このモデルは非常に複雑で、[いくつかの欠陥がある][C11-busted]ことが知られています。
<!--Rather, it is a pragmatic concession to the fact that *everyone* is pretty bad at modeling atomics.-->
むしろ、*誰も*がアトミックをモデリングするのがかなり悪いということは、実用的な譲歩です。
<!--At very least, we can benefit from existing tooling and research around C.-->
少なくとも、Cを中心とした既存のツーリングや研究の恩恵を受けることができます。

<!--Trying to fully explain the model in this book is fairly hopeless.-->
この本の中のモデルを完全に説明しようとするとかなり希望はありません。
<!--It's defined in terms of madness-inducing causality graphs that require a full book to properly understand in a practical way.-->
これは、実践的な方法で正しく理解するための完全な本を必要とする狂気誘発因果関係グラフの観点から定義されています。
<!--If you want all the nitty-gritty details, you should check out [C's specification (Section 7.17)][C11-model].-->
根深い詳細をすべて知りたい場合は、[Cの仕様（7.17節）][C11-model]をチェックしてください。
<!--Still, we'll try to cover the basics and some of the problems Rust developers face.-->
それでも、我々はRustの開発者が直面するいくつかの基本事項といくつかの問題をカバーしようとします。

<!--The C11 memory model is fundamentally about trying to bridge the gap between the semantics we want, the optimizations compilers want, and the inconsistent chaos our hardware wants.-->
C11メモリモデルは、基本的に、私たちが望むセマンティクス、最適化コンパイラが望むもの、そしてハードウェアが望む矛盾した混乱の間のギャップを埋めようとすることです。
<!--*We* would like to just write programs and have them do exactly what we said but, you know, fast.-->
*私たち*はプログラムを書いて、*私たち*が言ったこととまったく同じようにしたいと思いますが、あなたは知っています。
<!--Wouldn't that be great?-->
それは素晴らしいことではないでしょうか？




# <!--Compiler Reordering--> コンパイラの並べ替え

<!--Compilers fundamentally want to be able to do all sorts of complicated transformations to reduce data dependencies and eliminate dead code.-->
コンパイラは基本的に、あらゆる種類の複雑な変換を行い、データの依存関係を減らし、デッドコードを排除したいと考えています。
<!--In particular, they may radically change the actual order of events, or make events never occur!-->
特に、イベントの実際の順序を根本的に変更したり、イベントが発生しないようにすることができます。
<!--If we write something like-->
私たちが

```rust,ignore
x = 1;
y = 3;
x = 2;
```

<!--The compiler may conclude that it would be best if your program did-->
コンパイラは、あなたのプログラムが

```rust,ignore
x = 2;
y = 3;
```

<!--This has inverted the order of events and completely eliminated one event.-->
これはイベントの順序を逆転させ、1つのイベントを完全に排除しました。
<!--From a single-threaded perspective this is completely unobservable: after all the statements have executed we are in exactly the same state.-->
シングルスレッドの観点からは、これは完全に観測できません。すべてのステートメントが実行された後、まったく同じ状態になります。
<!--But if our program is multi-threaded, we may have been relying on `x` to actually be assigned to 1 before `y` was assigned.-->
しかし、私たちのプログラムがマルチスレッドの場合、`y`が割り当てられる前に実際に`x`に1を代入している可能性があります。
<!--We would like the compiler to be able to make these kinds of optimizations, because they can seriously improve performance.-->
パフォーマンスを大幅に向上させることができるので、これらの最適化を行うことができるようにしたいと考えています。
<!--On the other hand, we'd also like to be able to depend on our program *doing the thing we said*.-->
一方、私たちは、私たちが*言ったことを*してプログラムに頼ることもできるようにしたいと考え*てい*ます。




# <!--Hardware Reordering--> ハードウェア並べ替え

<!--On the other hand, even if the compiler totally understood what we wanted and respected our wishes, our hardware might instead get us in trouble.-->
一方、たとえコンパイラが私たちの望みを尊重し、尊重したものを完全に理解したとしても、私たちのハードウェアは代わりに困ってしまうかもしれません。
<!--Trouble comes from CPUs in the form of memory hierarchies.-->
メモリ階層の形でCPUから問題が発生します。
<!--There is indeed a global shared memory space somewhere in your hardware, but from the perspective of each CPU core it is *so very far away* and *so very slow*.-->
ハードウェアのどこかにグローバルな共有メモリ空間がありますが、各CPUコアの観点からは*非常に遠く* *、非常に遅い*です。
<!--Each CPU would rather work with its local cache of the data and only go through all the anguish of talking to shared memory only when it doesn't actually have that memory in cache.-->
各CPUはむしろデータのローカルキャッシュを扱い、実際にそのメモリをキャッシュに持っていないときにのみ共有メモリとの対話に苦労します。

<!--After all, that's the whole point of the cache, right?-->
結局のところ、それはキャッシュ全体のポイントなのですよね？
<!--If every read from the cache had to run back to shared memory to double check that it hadn't changed, what would the point be?-->
キャッシュからのすべての読み込みが変更されていないことを二重チェックするために共有メモリに戻さなければならない場合、何が重要なのでしょうか？
<!--The end result is that the hardware doesn't guarantee that events that occur in the same order on *one* thread, occur in the same order on *another* thread.-->
最終的な結果として、ハードウェアは、*ある*スレッドで同じ順序で発生するイベントが*別の*スレッドで同じ順序で発生することを保証しません。
<!--To guarantee this, we must issue special instructions to the CPU telling it to be a bit less smart.-->
これを保証するには、CPUに特別な指示を出して、少しスマートにするよう指示する必要があります。

<!--For instance, say we convince the compiler to emit this logic:-->
たとえば、このロジックを出すようにコンパイラに説得してみましょう。

```text
initial state: x = 0, y = 1

THREAD 1        THREAD2
y = 3;          if x == 1 {
x = 1;              y *= 2;
                }
```

<!--Ideally this program has 2 possible final states:-->
理想的には、このプログラムには2つの可能な最終状態があります。

* <!--`y = 3`: (thread 2 did the check before thread 1 completed)-->
   `y = 3`：（スレッド1が完了する前にスレッド2がチェックを行った）
* <!--`y = 6`: (thread 2 did the check after thread 1 completed)-->
   `y = 6`：（スレッド1が完了した後にスレッド2がチェックを行った）

<!--However there's a third potential state that the hardware enables:-->
しかし、ハードウェアが可能にする第3の潜在的な状態があります：

* <!--`y = 2`: (thread 2 saw `x = 1`, but not `y = 3`, and then overwrote `y = 3`)-->
   `y = 2`：（スレッド2鋸`x = 1`ではなく、`y = 3`、及びその後は上書き`y = 3`）

<!--It's worth noting that different kinds of CPU provide different guarantees.-->
異なる種類のCPUが異なる保証を提供することは注目に値する。
<!--It is common to separate hardware into two categories: strongly-ordered and weakly-ordered.-->
ハードウェアを2つのカテゴリに分類するのが一般的です。
<!--Most notably x86/64 provides strong ordering guarantees, while ARM provides weak ordering guarantees.-->
特に、x86 / 64は強力な発注保証を提供し、ARMは弱い発注保証を提供します。
<!--This has two consequences for concurrent programming:-->
これは並行プログラミングに2つの結果をもたらします。

* <!--Asking for stronger guarantees on strongly-ordered hardware may be cheap or even free because they already provide strong guarantees unconditionally.-->
   強く注文されたハードウェアに対するより強い保証を求めることは、既に無条件に強力な保証を提供しているので安価であるか、または無料でさえあり得る。
<!--Weaker guarantees may only yield performance wins on weakly-ordered hardware.-->
   弱い保証は、弱く注文されたハードウェアでのみパフォーマンスが向上する可能性があります。

* <!--Asking for guarantees that are too weak on strongly-ordered hardware is more likely to *happen* to work, even though your program is strictly incorrect.-->
   強く注文したハードウェア上では弱すぎるの保証のために頼むことはあなたのプログラムは、厳密に間違っているにもかかわらず、仕事に*起こる*可能性が高いです。
<!--If possible, concurrent algorithms should be tested on weakly-ordered hardware.-->
   可能であれば、並行アルゴリズムは弱く順序付けられたハードウェアでテストする必要があります。





# <!--Data Accesses--> データアクセス

<!--The C11 memory model attempts to bridge the gap by allowing us to talk about the *causality* of our program.-->
C11メモリモデルは、私たちのプログラムの*因果関係*について話すことを可能にすることによってギャップを埋めようとします。
<!--Generally, this is by establishing a *happens before* relationship between parts of the program and the threads that are running them.-->
一般的に、これは、プログラムの部分とそれを実行しているスレッドとの間の関係を確立する*こと*によって確立されます。
<!--This gives the hardware and compiler room to optimize the program more aggressively where a strict happens-before relationship isn't established, but forces them to be more careful where one is established.-->
これによりハードウェアとコンパイルルームは、厳密な先験的関係が確立されていない場合に、より積極的にプログラムを最適化することができます。
<!--The way we communicate these relationships are through *data accesses* and *atomic accesses*.-->
これらの関係を伝える方法は、*データアクセス*と*アトミックアクセスによるもの*です。

<!--Data accesses are the bread-and-butter of the programming world.-->
データへのアクセスは、プログラミング世界のパンとバターです。
<!--They are fundamentally unsynchronized and compilers are free to aggressively optimize them.-->
基本的に非同期であり、コンパイラは積極的にそれらを最適化することは自由です。
<!--In particular, data accesses are free to be reordered by the compiler on the assumption that the program is single-threaded.-->
特に、プログラムがシングルスレッドであると仮定して、コンパイラによってデータアクセスを自由に並べ替えることができます。
<!--The hardware is also free to propagate the changes made in data accesses to other threads as lazily and inconsistently as it wants.-->
また、ハードウェアは、データアクセスで行われた変更を他のスレッドにゆっくりと一貫して伝播させることができます。
<!--Most critically, data accesses are how data races happen.-->
最も重要なのは、データアクセスはデータ競合の発生方法です。
<!--Data accesses are very friendly to the hardware and compiler, but as we've seen they offer *awful* semantics to try to write synchronized code with.-->
データアクセスは、ハードウェアとコンパイラにとって非常に親切ですが、われわれが見てきたように、それらは同期コードを書くために*ひどい*意味を提供します。
<!--Actually, that's too weak.-->
実際、それは弱すぎます。

<!--**It is literally impossible to write correct synchronized code using only data accesses.**-->
**データアクセスのみを使用して正しい同期コードを書くことは文字通り不可能です。**

<!--Atomic accesses are how we tell the hardware and compiler that our program is multi-threaded.-->
アトミックアクセスは、プログラムがマルチスレッドであることをハードウェアとコンパイラに伝える方法です。
<!--Each atomic access can be marked with an *ordering* that specifies what kind of relationship it establishes with other accesses.-->
各アトミック・アクセスには、他のアクセスとどのような関係を確立するかを指定する*順序付け*を*付ける*ことができます。
<!--In practice, this boils down to telling the compiler and hardware certain things they *can't* do.-->
実際には、これは、コンパイラとハードウェアに何も*できない*ことを伝えることになります。
<!--For the compiler, this largely revolves around re-ordering of instructions.-->
コンパイラの場合、これは主に命令の並べ替えを中心に行われます。
<!--For the hardware, this largely revolves around how writes are propagated to other threads.-->
ハードウェアの場合、これは主に書き込みが他のスレッドに伝播する方法を中心に行われます。
<!--The set of orderings Rust exposes are:-->
Rustの注文のセットは次のとおりです。

* <!--Sequentially Consistent (SeqCst)-->
   順不同（SeqCst）
* <!--Release-->
   リリース
* <!--Acquire-->
   獲得する
* <!--Relaxed-->
   リラックス

<!--(Note: We explicitly do not expose the C11 *consume* ordering)-->
（注：明示的にC11の*消費*順序を公開していません）

<!--TODO: negative reasoning vs positive reasoning?-->
TODO：否定的推論対肯定的推論？
<!--TODO: "can't forget to synchronize"-->
TODO： "同期するのを忘れることはできない"



# <!--Sequentially Consistent--> 順不同

<!--Sequentially Consistent is the most powerful of all, implying the restrictions of all other orderings.-->
シーケンシャルに一貫性があり、他のすべての注文の制限を意味します。
<!--Intuitively, a sequentially consistent operation cannot be reordered: all accesses on one thread that happen before and after a SeqCst access stay before and after it.-->
直観的に、シーケンシャルに一貫性のある操作を並べ替えることはできません.SeqCstアクセスの前後に発生する1つのスレッド上のすべてのアクセスは、その前後にとどまります。
<!--A data-race-free program that uses only sequentially consistent atomics and data accesses has the very nice property that there is a single global execution of the program's instructions that all threads agree on.-->
逐次的に一貫性のあるアトミックおよびデータアクセスのみを使用するデータ競争のないプログラムは、すべてのスレッドが同意するプログラムの命令の単一のグローバル実行があるという非常に良い特性を持っています。
<!--This execution is also particularly nice to reason about: it's just an interleaving of each thread's individual executions.-->
この実行はまた、理由があるので特に好都合です。それは、各スレッドの個々の実行のインタリーブです。
<!--This does not hold if you start using the weaker atomic orderings.-->
より弱い原子の順序を使い始めると、これは成立しません。

<!--The relative developer-friendliness of sequential consistency doesn't come for free.-->
相対的な一貫性のある開発者の利便性は無料ではありません。
<!--Even on strongly-ordered platforms sequential consistency involves emitting memory fences.-->
強く秩序のあるプラットフォームでさえ、逐次整合性はメモリフェンスを放出することを含む。

<!--In practice, sequential consistency is rarely necessary for program correctness.-->
実際には、プログラムの正確さのために逐次整合性はほとんど必要ありません。
<!--However sequential consistency is definitely the right choice if you're not confident about the other memory orders.-->
しかし、他のメモリオーダーについて確信が持てない場合は、逐次整合性が正しい選択です。
<!--Having your program run a bit slower than it needs to is certainly better than it running incorrectly!-->
あなたのプログラムは、それが間違って実行されているよりも確かに優れている必要があるよりも少し遅く実行すること！
<!--It's also mechanically trivial to downgrade atomic operations to have a weaker consistency later on.-->
後で弱い整合性を持つように原子操作をダウングレードすることも機械的には些細なことです。
<!--Just change `SeqCst` to `Relaxed` and you're done!-->
`SeqCst`を`Relaxed`変更するだけで完了です！
<!--Of course, proving that this transformation is *correct* is a whole other matter.-->
もちろん、この変換が*正しい*ことを証明することは、まったく別の問題です。




# <!--Acquire-Release--> 取得 -リリース

<!--Acquire and Release are largely intended to be paired.-->
AcquireとReleaseは主にペアになるように意図されています。
<!--Their names hint at their use case: they're perfectly suited for acquiring and releasing locks, and ensuring that critical sections don't overlap.-->
彼らの名前はユースケースを暗示しています。ロックの取得と解放、クリティカルセクションの重複を避けることができます。

<!--Intuitively, an acquire access ensures that every access after it stays after it.-->
直感的には、アクセスアクセスは、それ以降のすべてのアクセスが確実に維持されます。
<!--However operations that occur before an acquire are free to be reordered to occur after it.-->
しかし、買収前に発生した事業は、買収後に再注文することが自由である。
<!--Similarly, a release access ensures that every access before it stays before it.-->
同様に、リリースアクセスは、それがその前に存在する前にすべてのアクセスが確実に行われるようにします。
<!--However operations that occur after a release are free to be reordered to occur before it.-->
しかし、リリース後に発生する操作は、その前に発生するように自由に並べ替えることができます。

<!--When thread A releases a location in memory and then thread B subsequently acquires *the same* location in memory, causality is established.-->
スレッドAがメモリ内の場所を解放し、次にスレッドBがメモリ内*の同じ*場所を取得*すると*、因果関係が確立されます。
<!--Every write that happened before A's release will be observed by B after its acquisition.-->
Aのリリース前に起こったすべての書き込みは、Bの取得後に観察されます。
<!--However no causality is established with any other threads.-->
しかし、他のスレッドとの因果関係は確立されていません。
<!--Similarly, no causality is established if A and B access *different* locations in memory.-->
同様に、AとBがメモリ内の*異なる*場所にアクセスすると、因果関係は確立されません。

<!--Basic use of release-acquire is therefore simple: you acquire a location of memory to begin the critical section, and then release that location to end it.-->
したがって、release-acquireの基本的な使用は簡単です。クリティカルセクションを開始するメモリの場所を取得し、その場所を解放して終了します。
<!--For instance, a simple spinlock might look like:-->
たとえば、単純なスピンロックは次のようになります。

```rust
use std::sync::Arc;
use std::sync::atomic::{AtomicBool, Ordering};
use std::thread;

fn main() {
#//    let lock = Arc::new(AtomicBool::new(false)); // value answers "am I locked?"
    let lock = Arc::new(AtomicBool::new(false)); // 価値のある答え "私はロックされていますか？"

#    // ... distribute lock to threads somehow ...
    // 何とかロックをスレッドに配布しています...

#    // Try to acquire the lock by setting it to true
    // それをtrueに設定してロックを獲得しようとする
    while lock.compare_and_swap(false, true, Ordering::Acquire) { }
#    // broke out of the loop, so we successfully acquired the lock!
    // ループから勃発したので、我々はロックを成功裏に獲得しました！

#    // ... scary data accesses ...
    // ...怖いデータへのアクセス...

#    // ok we're done, release the lock
    // 私たちはやったよ、ロックを解除する
    lock.store(false, Ordering::Release);
}
```

<!--On strongly-ordered platforms most accesses have release or acquire semantics, making release and acquire often totally free.-->
強く秩序立ったプラットフォームでは、ほとんどのアクセスが解放または獲得のセマンティクスを持ち、リリースと獲得を完全に無料にすることがあります。
<!--This is not the case on weakly-ordered platforms.-->
弱順のプラットフォームではそうではありません。




# <!--Relaxed--> リラックス

<!--Relaxed accesses are the absolute weakest.-->
リラックスしたアクセスは絶対的に弱いです。
<!--They can be freely re-ordered and provide no happens-before relationship.-->
彼らは自由に並べ替えることができ、起こることのない関係を提供することはできません。
<!--Still, relaxed operations are still atomic.-->
それでも、リラックスした操作はまだアトミックです。
<!--That is, they don't count as data accesses and any read-modify-write operations done to them occur atomically.-->
つまり、データアクセスとしてカウントされず、リード -モディファイ -ライト操作が原子的に発生します。
<!--Relaxed operations are appropriate for things that you definitely want to happen, but don't particularly otherwise care about.-->
リラックスした操作は、確実に起こりたいことに適していますが、特に気にすることはありません。
<!--For instance, incrementing a counter can be safely done by multiple threads using a relaxed `fetch_add` if you're not using the counter to synchronize any other accesses.-->
たとえば、他のアクセスを同期させるためにカウンタを使用していない場合は、緩やかな`fetch_add`を使用して複数のスレッドによってカウンタをインクリメントすることができます。

<!--There's rarely a benefit in making an operation relaxed on strongly-ordered platforms, since they usually provide release-acquire semantics anyway.-->
とにかくリリース取得のセマンティクスを提供するため、強く発注されたプラットフォームで操作を緩和することはめったにありません。
<!--However relaxed operations can be cheaper on weakly-ordered platforms.-->
しかし、リラックスした操作は弱い順序のプラットフォームでは安くなる可能性があります。





<!--[C11-busted]: http://plv.mpi-sws.org/c11comp/popl15.pdf
 [C11-model]: http://www.open-std.org/jtc1/sc22/wg14/www/standards.html#9899
-->
[C11-busted]: http://plv.mpi-sws.org/c11comp/popl15.pdf
 [C11-model]: http://www.open-std.org/jtc1/sc22/wg14/www/standards.html#9899

