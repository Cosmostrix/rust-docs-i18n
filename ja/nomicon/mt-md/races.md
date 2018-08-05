# <!--Data Races and Race Conditions--> データレースと競争条件

<!--Safe Rust guarantees an absence of data races, which are defined as:-->
Safe Rustは、以下のように定義されるデータ競合がないことを保証します。

* <!--two or more threads concurrently accessing a location of memory-->
   メモリの場所に同時にアクセスする2つ以上のスレッド
* <!--one of them is a write-->
   それらの1つは書き込みです
* <!--one of them is unsynchronized-->
   そのうちの1つは非同期です

<!--A data race has Undefined Behavior, and is therefore impossible to perform in Safe Rust.-->
データレースには未定義の動作があるため、安全な錆では実行できません。
<!--Data races are *mostly* prevented through rust's ownership system: it's impossible to alias a mutable reference, so it's impossible to perform a data race.-->
データ競合は、*主に*錆の所有権システムによって防止されます。変更可能な参照をエイリアスすることは不可能なため、データ競争を行うことは不可能です。
<!--Interior mutability makes this more complicated, which is largely why we have the Send and Sync traits (see below).-->
インテリアの変更はこれをより複雑にします。そのため、主にSendとSyncの特性があります（下記参照）。

<!--**However Rust does not prevent general race conditions.**-->
**しかし、錆は一般的な競争条件を妨げるものではありません。**

<!--This is pretty fundamentally impossible, and probably honestly undesirable.-->
これは基本的に不可能で、おそらく正直に望ましくない。
<!--Your hardware is racy, your OS is racy, the other programs on your computer are racy, and the world this all runs in is racy.-->
あなたのハードウェアは手の込んだです、あなたのOSはレイシーです、あなたのコンピュータ上の他のプログラムは手の込んだです、そして、このすべてが実行されている世界はレイシーです。
<!--Any system that could genuinely claim to prevent *all* race conditions would be pretty awful to use, if not just incorrect.-->
本当に*すべての*競争条件を防止すると主張できるシステムならば、不正確ではないにせよ、使用するのはかなりひどいでしょう。

<!--So it's perfectly "fine"for a Safe Rust program to get deadlocked or do something nonsensical with incorrect synchronization.-->
したがって、Safe Rustプログラムがデッドロックを起こしたり、間違った同期で無意味なことが起こるのは完全に「罰金」です。
<!--Obviously such a program isn't very good, but Rust can only hold your hand so far.-->
明らかにそのようなプログラムはあまり良くありませんが、Rustはこれまでのところあなたの手しか保持できません。
<!--Still, a race condition can't violate memory safety in a Rust program on its own.-->
それでも、Rustプログラムでは競合状態がメモリの安全性に違反することはできません。
<!--Only in conjunction with some other unsafe code can a race condition actually violate memory safety.-->
他の安全でないコードとの組み合わせでのみ、競合状態が実際にメモリの安全性に違反する可能性があります。
<!--For instance:-->
例えば：

```rust,no_run
use std::thread;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;

let data = vec![1, 2, 3, 4];
#// Arc so that the memory the AtomicUsize is stored in still exists for
#// the other thread to increment, even if we completely finish executing
#// before it. Rust won't compile the program without it, because of the
#// lifetime requirements of thread::spawn!
//  AtomicUsizeが格納されているメモリは、他のスレッドがインクリメントするためにまだ存在しています。Rustはthread:: spawnの生涯要求のために、プログラムなしでプログラムをコンパイルしません！
let idx = Arc::new(AtomicUsize::new(0));
let other_idx = idx.clone();

#// `move` captures other_idx by-value, moving it into this thread
//  `move`このスレッドにそれを移動し、値によるother_idx取り込み
thread::spawn(move || {
#    // It's ok to mutate idx because this value
#    // is an atomic, so it can't cause a Data Race.
    // この値はアトミックなのでidxを変更するのは問題ありません。データレースを引き起こすことはできません。
    other_idx.fetch_add(10, Ordering::SeqCst);
});

#// Index with the value loaded from the atomic. This is safe because we
#// read the atomic memory only once, and then pass a copy of that value
#// to the Vec's indexing implementation. This indexing will be correctly
#// bounds checked, and there's no chance of the value getting changed
#// in the middle. However our program may panic if the thread we spawned
#// managed to increment before this ran. A race condition because correct
#// program execution (panicking is rarely correct) depends on order of
#// thread execution.
// アトミックからロードされた値を持つ索引。これは、アトミックメモリを1回だけ読み込み、その値のコピーをVecのインデックス実装に渡すので安全です。この索引付けは正しく境界がチェックされ、真ん中で値が変更される可能性はありません。しかし、私たちが作成したスレッドが、これが実行される前にインクリメントすることができれば、プログラムはパニックに陥ることがあります。正しいプログラムの実行（パニックはまれに正しい）が競合状態になるのは、スレッドの実行順序に依存します。
println!("{}", data[idx.load(Ordering::SeqCst)]);
```

```rust,no_run
use std::thread;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;

let data = vec![1, 2, 3, 4];

let idx = Arc::new(AtomicUsize::new(0));
let other_idx = idx.clone();

#// `move` captures other_idx by-value, moving it into this thread
//  `move`このスレッドにそれを移動し、値によるother_idx取り込み
thread::spawn(move || {
#    // It's ok to mutate idx because this value
#    // is an atomic, so it can't cause a Data Race.
    // この値はアトミックなのでidxを変更するのは問題ありません。データレースを引き起こすことはできません。
    other_idx.fetch_add(10, Ordering::SeqCst);
});

if idx.load(Ordering::SeqCst) < data.len() {
    unsafe {
#        // Incorrectly loading the idx after we did the bounds check.
#        // It could have changed. This is a race condition, *and dangerous*
#        // because we decided to do `get_unchecked`, which is `unsafe`.
        // 境界チェックを行った後、idxを間違って読み込んでいます。それは変わったかもしれない。これは競合状態で*あり*、 `unsafe`では`unsafe` `get_unchecked`を実行することに決めたので`unsafe`です。
        println!("{}", data.get_unchecked(idx.load(Ordering::SeqCst)));
    }
}
```
