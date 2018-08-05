# <!--Exception Safety--> 例外の安全性

<!--Although programs should use unwinding sparingly, there's a lot of code that *can* panic.-->
プログラムでは巻き戻しを控えめに使用する必要があります*が、*パニックになるコードがたくさんあります。
<!--If you unwrap a None, index out of bounds, or divide by 0, your program will panic.-->
None、unwindを範囲外にするか、0で割ると、プログラムはパニックに陥ります。
<!--On debug builds, every arithmetic operation can panic if it overflows.-->
デバッグビルドでは、すべての算術演算がオーバーフローするとパニックに陥ることがあります。
<!--Unless you are very careful and tightly control what code runs, pretty much everything can unwind, and you need to be ready for it.-->
コードが実行されていることを非常に慎重に厳密に制御している場合を除き、ほとんどすべてが元に戻ることができ、準備が必要です。

<!--Being ready for unwinding is often referred to as *exception safety* in the broader programming world.-->
巻き戻しの準備が整っていることは、広範なプログラミングの世界で*例外安全性*と呼ばれることがよくあります。
<!--In Rust, there are two levels of exception safety that one may concern themselves with:-->
Rustには、次の2つのレベルの例外安全性があります。

* <!--In unsafe code, we *must* be exception safe to the point of not violating memory safety.-->
   安全でないコードでは、メモリの安全性に違反しない点で例外セーフで*なければ*なりません。
<!--We'll call this *minimal* exception safety.-->
   この*最小の*例外安全性と呼ぶことにします。

* <!--In safe code, it is *good* to be exception safe to the point of your program doing the right thing.-->
   安全なコードでは、あなたのプログラムが正しいことを行う点で例外的な安全性があることは*良い*ことです。
<!--We'll call this *maximal* exception safety.-->
   この*最大の*例外安全性と呼ぶことにします。

<!--As is the case in many places in Rust, Unsafe code must be ready to deal with bad Safe code when it comes to unwinding.-->
Rustの多くの場所でそうであるように、安全でないコードは、巻き戻しに関して悪いセーフコードを処理する準備ができている必要があります。
<!--Code that transiently creates unsound states must be careful that a panic does not cause that state to be used.-->
一時的に不健全な状態を生成するコードは、パニックによってその状態が使用されないように注意する必要があります。
<!--Generally this means ensuring that only non-panicking code is run while these states exist, or making a guard that cleans up the state in the case of a panic.-->
一般的に、これは、これらの状態が存在する間、パニックでないコードだけが実行されることを保証すること、またはパニックの場合に状態をクリーンアップするガードを行うことを意味する。
<!--This does not necessarily mean that the state a panic witnesses is a fully coherent state.-->
これは必ずしもパニックの証人が完全に一貫した状態であることを意味するものではありません。
<!--We need only guarantee that it's a *safe* state.-->
*安全な*状態であることを保証する必要があります。

<!--Most Unsafe code is leaf-like, and therefore fairly easy to make exception-safe.-->
ほとんどの安全でないコードは葉のようなものなので、例外的に安全にするのはかなり簡単です。
<!--It controls all the code that runs, and most of that code can't panic.-->
実行されるすべてのコードを制御し、そのコードのほとんどはパニックに陥ることはありません。
<!--However it is not uncommon for Unsafe code to work with arrays of temporarily uninitialized data while repeatedly invoking caller-provided code.-->
しかし、Unsafeコードが一時的に初期化されていないデータの配列で動作し、呼び出し元提供のコードを繰り返し呼び出すことは珍しいことではありません。
<!--Such code needs to be careful and consider exception safety.-->
そのようなコードは注意深く、例外安全性を考慮する必要があります。





## <!--Vec::push_all--> Vec:: push_all

<!--`Vec::push_all` is a temporary hack to get extending a Vec by a slice reliably efficient without specialization.-->
`Vec::push_all`は、専門化せずにVecを確実に効率的に拡張するための一時的なハックです。
<!--Here's a simple implementation:-->
ここに簡単な実装があります：

```rust,ignore
impl<T: Clone> Vec<T> {
    fn push_all(&mut self, to_push: &[T]) {
        self.reserve(to_push.len());
        unsafe {
#            // can't overflow because we just reserved this
            // 我々はこれを予約しているのでオーバーフローすることはできません
            self.set_len(self.len() + to_push.len());

            for (i, x) in to_push.iter().enumerate() {
                self.ptr().offset(i as isize).write(x.clone());
            }
        }
    }
}
```

<!--We bypass `push` in order to avoid redundant capacity and `len` checks on the Vec that we definitely know has capacity.-->
冗長容量を避けるために`push`をバイパスし、容量があることがわかっているVecの`len`チェックを行います。
<!--The logic is totally correct, except there's a subtle problem with our code: it's not exception-safe!-->
ロジックは完全に正しいですが、例外的に安全ではありません。
<!--`set_len`, `offset`, and `write` are all fine;-->
`set_len`、 `offset`、 `write`はすべて問題ありません。
<!--`clone` is the panic bomb we over-looked.-->
`clone`は私たちが見たパニック爆弾です。

<!--Clone is completely out of our control, and is totally free to panic.-->
クローンは完全に私たちのコントロールから外れており、完全にパニックになることはありません。
<!--If it does, our function will exit early with the length of the Vec set too large.-->
そうであれば、Vecの長さを長くしすぎると機能が早期に終了します。
<!--If the Vec is looked at or dropped, uninitialized memory will be read!-->
Vecを見たりドロップしたりすると、初期化されていないメモリが読み込まれます。

<!--The fix in this case is fairly simple.-->
この場合の修正はかなり簡単です。
<!--If we want to guarantee that the values we *did* clone are dropped, we can set the `len` every loop iteration.-->
我々はクローンをし*た*値がドロップされることを保証したい場合、我々は設定でき`len`すべてのループの繰り返しを。
<!--If we just want to guarantee that uninitialized memory can't be observed, we can set the `len` after the loop.-->
初期化されていないメモリを確認できないようにしたい場合は、ループの後に`len`を設定することができます。





## <!--BinaryHeap::sift_up--> BinaryHeap:: sift_up

<!--Bubbling an element up a heap is a bit more complicated than extending a Vec.-->
ヒープの要素をバブリングするのは、Vecを拡張するよりも少し複雑です。
<!--The pseudocode is as follows:-->
擬似コードは次のとおりです。

```text
bubble_up(heap, index):
    while index != 0 && heap[index] < heap[parent(index)]:
        heap.swap(index, parent(index))
        index = parent(index)

```

<!--A literal transcription of this code to Rust is totally fine, but has an annoying performance characteristic: the `self` element is swapped over and over again uselessly.-->
Rustへのこのコードの文字通りの転写はまったく問題ありませんが、厄介なパフォーマンス特性があります。`self`要素は無駄に何度も何度も入れ替えられています。
<!--We would rather have the following:-->
私たちはむしろ以下を持っています：

```text
bubble_up(heap, index):
    let elem = heap[index]
    while index != 0 && elem < heap[parent(index)]:
        heap[index] = heap[parent(index)]
        index = parent(index)
    heap[index] = elem
```

<!--This code ensures that each element is copied as little as possible (it is in fact necessary that elem be copied twice in general).-->
このコードは、各要素ができるだけコピーされないようにします（実際には、elemを一般に2回コピーする必要があります）。
<!--However it now exposes some exception safety trouble!-->
しかし、今ではいくつかの例外的な安全上の問題があります。
<!--At all times, there exists two copies of one value.-->
いつでも、1つの価値の2つのコピーが存在します。
<!--If we panic in this function something will be double-dropped.-->
この関数でパニックになると、何かが二重に落とされます。
<!--Unfortunately, we also don't have full control of the code: that comparison is user-defined!-->
残念ながら、コードの完全な制御権もありません。その比較はユーザー定義です！

<!--Unlike Vec, the fix isn't as easy here.-->
Vecとは異なり、ここでの修正は簡単ではありません。
<!--One option is to break the user-defined code and the unsafe code into two separate phases:-->
1つのオプションは、ユーザー定義コードと安全でないコードを2つの別々のフェーズに分割することです。

```text
bubble_up(heap, index):
    let end_index = index;
    while end_index != 0 && heap[end_index] < heap[parent(end_index)]:
        end_index = parent(end_index)

    let elem = heap[index]
    while index != end_index:
        heap[index] = heap[parent(index)]
        index = parent(index)
    heap[index] = elem
```

<!--If the user-defined code blows up, that's no problem anymore, because we haven't actually touched the state of the heap yet.-->
ユーザー定義コードが爆発した場合、実際にヒープの状態にまだ触れていないので、これはもう問題ありません。
<!--Once we do start messing with the heap, we're working with only data and functions that we trust, so there's no concern of panics.-->
ヒープを使い始めると、私たちが信頼するデータと関数だけで作業しているので、パニックが起こる心配はありません。

<!--Perhaps you're not happy with this design.-->
おそらくあなたはこのデザインに満足していないでしょう。
<!--Surely it's cheating!-->
確かにそれは浮気です！
<!--And we have to do the complex heap traversal *twice*!-->
複雑なヒープトラバーサルを*2回*実行する必要があります。
<!--Alright, let's bite the bullet.-->
さて、弾を噛んでみましょう。
<!--Let's intermix untrusted and unsafe code *for reals*.-->
*本当のために*信頼できないコードと安全でないコード*を*混ぜ合わせてみましょう。

<!--If Rust had `try` and `finally` like in Java, we could do the following:-->
錆があったら`try`と`finally`、Javaのように、私たちは次のことを行うことができます：

```text
bubble_up(heap, index):
    let elem = heap[index]
    try:
        while index != 0 && elem < heap[parent(index)]:
            heap[index] = heap[parent(index)]
            index = parent(index)
    finally:
        heap[index] = elem
```

<!--The basic idea is simple: if the comparison panics, we just toss the loose element in the logically uninitialized index and bail out.-->
基本的な考え方は単純です：比較がパニックの場合、論理的に初期化されていないインデックスに緩い要素を投げつけて救済します。
<!--Anyone who observes the heap will see a potentially *inconsistent* heap, but at least it won't cause any double-drops!-->
ヒープを観察する人は、ヒープが*矛盾*する可能*性があり*ますが、少なくともダブルドロップは発生しません。
<!--If the algorithm terminates normally, then this operation happens to coincide precisely with the how we finish up regardless.-->
アルゴリズムが正常に終了した場合、この操作は、関係なく終了する方法と正確に一致します。

<!--Sadly, Rust has no such construct, so we're going to need to roll our own!-->
悲しいことに、Rustはそのような構造を持っていないので、我々は自分自身をロールバックする必要があるでしょう！
<!--The way to do this is to store the algorithm's state in a separate struct with a destructor for the "finally"logic.-->
これを行う方法は、"finally"ロジックのデストラクタを使用してアルゴリズムの状態を別の構造体に格納することです。
<!--Whether we panic or not, that destructor will run and clean up after us.-->
私たちがパニックであろうとなかろうと、そのデストラクタは私たちの後を走り、きれいになるでしょう。

```rust,ignore
struct Hole<'a, T: 'a> {
    data: &'a mut [T],
#//    /// `elt` is always `Some` from new until drop.
    ///  `elt`は常に新しい`Some`から落とす`Some`まであります。
    elt: Option<T>,
    pos: usize,
}

impl<'a, T> Hole<'a, T> {
    fn new(data: &'a mut [T], pos: usize) -> Self {
        unsafe {
            let elt = ptr::read(&data[pos]);
            Hole {
                data: data,
                elt: Some(elt),
                pos: pos,
            }
        }
    }

    fn pos(&self) -> usize { self.pos }

    fn removed(&self) -> &T { self.elt.as_ref().unwrap() }

    unsafe fn get(&self, index: usize) -> &T { &self.data[index] }

    unsafe fn move_to(&mut self, index: usize) {
        let index_ptr: *const _ = &self.data[index];
        let hole_ptr = &mut self.data[self.pos];
        ptr::copy_nonoverlapping(index_ptr, hole_ptr, 1);
        self.pos = index;
    }
}

impl<'a, T> Drop for Hole<'a, T> {
    fn drop(&mut self) {
#        // fill the hole again
        // もう一度穴を埋める
        unsafe {
            let pos = self.pos;
            ptr::write(&mut self.data[pos], self.elt.take().unwrap());
        }
    }
}

impl<T: Ord> BinaryHeap<T> {
    fn sift_up(&mut self, pos: usize) {
        unsafe {
#            // Take out the value at `pos` and create a hole.
            //  `pos`の値を取り出して穴を作ります。
            let mut hole = Hole::new(&mut self.data, pos);

            while hole.pos() != 0 {
                let parent = parent(hole.pos());
                if hole.removed() <= hole.get(parent) { break }
                hole.move_to(parent);
            }
#            // Hole will be unconditionally filled here; panic or not!
            // 穴はここで無条件に塗りつぶされます。パニックかどうか！
        }
    }
}
```
