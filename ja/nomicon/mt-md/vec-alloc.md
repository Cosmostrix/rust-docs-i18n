# <!--Allocating Memory--> メモリの割り当て

<!--Using Unique throws a wrench in an important feature of Vec (and indeed all of the std collections): an empty Vec doesn't actually allocate at all.-->
ユニークを使用すると、Vecの重要な機能（そして実際にはすべてのstdコレクション）にレンチがスローされます。空のVecは実際にはまったく割り当てません。
<!--So if we can't allocate, but also can't put a null pointer in `ptr`, what do we do in `Vec::new`?-->
だから私たちが割り当てることはできませんが、`ptr`にnullポインタを置くことができない場合、`Vec::new`何をしますか？
<!--Well, we just put some other garbage in there!-->
さて、そこに他のゴミを置くだけです！

<!--This is perfectly fine because we already have `cap == 0` as our sentinel for no allocation.-->
これは完全にうまくいきます。なぜなら、割り振られていないとしても、私たちの目標は`cap == 0`からです。
<!--We don't even need to handle it specially in almost any code because we usually need to check if `cap > len` or `len > 0` anyway.-->
とにかく`cap > len`か`len > 0`かどうかを確認する必要があるので、ほとんどすべてのコードで特別に扱う必要はあり`len > 0`ん。
<!--The recommended Rust value to put here is `mem::align_of::<T>()`.-->
ここに入れる推奨Rust値は`mem::align_of::<T>()`です。
<!--Unique provides a convenience for this: `Unique::empty()`.-->
Uniqueはこれに便利です： `Unique::empty()`。
<!--There are quite a few places where we'll want to use `empty` because there's no real allocation to talk about but `null` would make the compiler do bad things.-->
私たちが`empty`を使用したい場所はかなりあります。なぜなら、実際の割り当ては話せませんが、`null`はコンパイラに悪いことをさせるからです。

<!--So:-->
そう：

```rust,ignore
#![feature(alloc, heap_api)]

use std::mem;

impl<T> Vec<T> {
    fn new() -> Self {
        assert!(mem::size_of::<T>() != 0, "We're not ready to handle ZSTs");
        Vec { ptr: Unique::empty(), len: 0, cap: 0 }
    }
}
```

<!--I slipped in that assert there because zero-sized types will require some special handling throughout our code, and I want to defer the issue for now.-->
ゼロサイズの型はコード全体で特別な処理を必要とするので、私はそこで主張していますが、今はその問題を延期したいと思います。
<!--Without this assert, some of our early drafts will do some Very Bad Things.-->
この主張がなければ、私たちの初期ドラフトのいくつかは非常に悪いことをするでしょう。

<!--Next we need to figure out what to actually do when we *do* want space.-->
次に私たちは宇宙をしたい*ん*ときに実際に何をすべきかを把握する必要があります。
<!--For that, we'll need to use the rest of the heap APIs.-->
そのためには、残りのヒープAPIを使用する必要があります。
<!--These basically allow us to talk directly to Rust's allocator (jemalloc by default).-->
これらは、基本的に私たちがRustのアロケータ（デフォルトではjemalloc）と直接話すことを可能にします。

<!--We'll also need a way to handle out-of-memory (OOM) conditions.-->
また、メモリ不足（OOM）条件を処理する方法も必要です。
<!--The standard library calls `std::alloc::oom()`, which in turn calls the the `oom` langitem.-->
標準ライブラリは`std::alloc::oom()`を呼び出し、`oom` langitemを呼び出します。
<!--By default this just aborts the program by executing an illegal cpu instruction.-->
デフォルトでは、これは不正なcpu命令を実行することによってプログラムを中止します。
<!--The reason we abort and don't panic is because unwinding can cause allocations to happen, and that seems like a bad thing to do when your allocator just came back with "hey I don't have any more memory".-->
私たちが中止して慌てない理由は、巻き戻しが割り振りを引き起こす可能性があるからです。アロケータがちょうど「これ以上の記憶を持っていません」と戻ってきたとき、それは悪いことです。

<!--Of course, this is a bit silly since most platforms don't actually run out of memory in a conventional way.-->
もちろん、これはちょっとばかげています。これは、ほとんどのプラットフォームでは、従来の方法で実際にメモリが使い果たされていないからです。
<!--Your operating system will probably kill the application by another means if you legitimately start using up all the memory.-->
合法的にすべてのメモリを使い切ってしまうと、あなたのオペレーティングシステムはおそらく別の手段でアプリケーションを強制終了します。
<!--The most likely way we'll trigger OOM is by just asking for ludicrous quantities of memory at once (eg half the theoretical address space).-->
私たちがOOMを起動させる最も可能性のある方法は、一度に奇妙な量のメモリ（例えば、理論上のアドレス空間の半分）を求めることだけです。
<!--As such it's *probably* fine to panic and nothing bad will happen.-->
このように恐慌するの*は*大丈夫ですが、悪いことは起こりません。
<!--Still, we're trying to be like the standard library as much as possible, so we'll just kill the whole program.-->
それでも、私たちはできるだけ標準ライブラリのようにしようとしているので、プログラム全体を殺すだけです。

<!--Okay, now we can write growing.-->
さて、今私たちは成長を書くことができます。
<!--Roughly, we want to have this logic:-->
おおよそ、私たちはこの論理を持ちたいと思っています：

```text
if cap == 0:
    allocate()
    cap = 1
else:
    reallocate()
    cap *= 2
```

<!--But Rust's only supported allocator API is so low level that we'll need to do a fair bit of extra work.-->
しかし、RustのサポートされているアロケータAPIは低レベルなので、かなりの余分な作業をする必要があります。
<!--We also need to guard against some special conditions that can occur with really large allocations or empty allocations.-->
また、本当に大量の割り当てや空の割り当てで発生する可能性のある特殊な条件に対しても警戒する必要があります。

<!--In particular, `ptr::offset` will cause us a lot of trouble, because it has the semantics of LLVM's GEP inbounds instruction.-->
特に、`ptr::offset`は、LLVMのGEPインバウンド命令のセマンティクスを持っているため、私たちに多くの問題を引き起こします。
<!--If you're fortunate enough to not have dealt with this instruction, here's the basic story with GEP: alias analysis, alias analysis, alias analysis.-->
あなたがこの命令を扱っていないほど幸運であれば、GEPの基本的な話はエイリアス分析、エイリアス分析、エイリアス分析です。
<!--It's super important to an optimizing compiler to be able to reason about data dependencies and aliasing.-->
データの依存関係やエイリアシングを推論できるように最適化コンパイラにとって非常に重要です。

<!--As a simple example, consider the following fragment of code:-->
簡単な例として、次のコードを考えてみましょう。

```rust
# let x = &mut 0;
# let y = &mut 0;
*x *= 7;
*y *= 3;
```

<!--If the compiler can prove that `x` and `y` point to different locations in memory, the two operations can in theory be executed in parallel (by eg loading them into different registers and working on them independently).-->
コンパイラが`x`と`y`がメモリ内の別の場所を指していることを証明できれば、理論的には2つの演算を並列に実行することができます（別々のレジスタにロードして独立に処理するなど）。
<!--However the compiler can't do this in general because if x and y point to the same location in memory, the operations need to be done to the same value, and they can't just be merged afterwards.-->
しかし、コンパイラは一般にこれを行うことはできません。なぜなら、xとyがメモリ内の同じ場所を指す場合、操作は同じ値にする必要があり、後でマージすることはできないからです。

<!--When you use GEP inbounds, you are specifically telling LLVM that the offsets you're about to do are within the bounds of a single "allocated"entity.-->
GEPインバウンドを使用するときは、あなたがしようとしているオフセットが単一の「割り当て済み」エンティティの範囲内にあることをLLVMに具体的に伝えています。
<!--The ultimate payoff being that LLVM can assume that if two pointers are known to point to two disjoint objects, all the offsets of those pointers are *also* known to not alias (because you won't just end up in some random place in memory).-->
LLVMは、2つのポインタが2つのディスジョイントオブジェクトを指すことがわかっている場合、それらのポインタのすべてのオフセット*も*エイリアスではないことがわかっているということができます（メモリのランダムな場所で終わるわけではないため）。
<!--LLVM is heavily optimized to work with GEP offsets, and inbounds offsets are the best of all, so it's important that we use them as much as possible.-->
LLVMはGEPオフセットを扱うために大きく最適化されており、インバウンドオフセットが最善であるため、可能な限り使用することが重要です。

<!--So that's what GEP's about, how can it cause us trouble?-->
そういうわけで、GEPはどういう意味ですか、それがどうやって私たちのトラブルを引き起こすのですか？

<!--The first problem is that we index into arrays with unsigned integers, but GEP (and as a consequence `ptr::offset`) takes a signed integer.-->
最初の問題は、符号なし整数で配列にインデックスを付けることですが、GEP（および結果として`ptr::offset`）は符号付き整数をとります。
<!--This means that half of the seemingly valid indices into an array will overflow GEP and actually go in the wrong direction!-->
これは、一見アレイの有効なインデックスの半分がGEPをオーバーフローし、実際に間違った方向に向かうことを意味します。
<!--As such we must limit all allocations to `isize::MAX` elements.-->
したがって、すべての割り当てを`isize::MAX`要素に限定する必要があります。
<!--This actually means we only need to worry about byte-sized objects, because eg `> isize::MAX` `u16` s will truly exhaust all of the system's memory.-->
実際には、`> isize::MAX` `u16` sは本当にシステムのすべてのメモリを`> isize::MAX`ため、バイトサイズのオブジェクトについて心配する必要があるだけです。
<!--However in order to avoid subtle corner cases where someone reinterprets some array of `< isize::MAX` objects as bytes, std limits all allocations to `isize::MAX` bytes.-->
しかし、`< isize::MAX`オブジェクトのある配列をバイトとして再解釈する微妙なコーナーケースを避けるために、stdはすべての割り当てを`isize::MAX`バイトに制限します。

<!--On all 64-bit targets that Rust currently supports we're artificially limited to significantly less than all 64 bits of the address space (modern x64 platforms only expose 48-bit addressing), so we can rely on just running out of memory first.-->
Rustが現在サポートしているすべての64ビットターゲットでは、人為的にアドレス空間の64ビットすべてよりも大幅に制限されています（最新のx64プラットフォームでは48ビットのアドレス指定のみが公開されています）。
<!--However on 32-bit targets, particularly those with extensions to use more of the address space (PAE x86 or x32), it's theoretically possible to successfully allocate more than `isize::MAX` bytes of memory.-->
しかし、32ビットターゲット、特にアドレス空間（PAE x86またはx32）の多くを使用する拡張機能を持つターゲットでは、`isize::MAX`バイト以上のメモリを正常に割り当てることは理論的に可能です。

<!--However since this is a tutorial, we're not going to be particularly optimal here, and just unconditionally check, rather than use clever platform-specific `cfg` s.-->
しかし、これはチュートリアルなので、プラットフォーム固有の巧妙な`cfg`使用するのではなく、ここでは特に最適化するつもりはなく、無条件にチェックするだけです。

<!--The other corner-case we need to worry about is empty allocations.-->
私たちが心配する必要があるもう一つのケースは空の割り当てです。
<!--There will be two kinds of empty allocations we need to worry about: `cap = 0` for all T, and `cap > 0` for zero-sized types.-->
私たちが心配する必要がある2種類の空割当てがあります。すべてのTに対して`cap = 0` `cap > 0`、ゼロサイズのタイプに対して`cap > 0`です。

<!--These cases are tricky because they come down to what LLVM means by "allocated".-->
これらのケースは、LLVMが意味するものが「割り当てられた」ものであるため、扱いにくいものです。
<!--LLVM's notion of an allocation is significantly more abstract than how we usually use it.-->
LLVMの配分という概念は、我々が通常それを使用する方法よりもはるかに抽象的です。
<!--Because LLVM needs to work with different languages' semantics and custom allocators, it can't really intimately understand allocation.-->
LLVMは異なる言語のセマンティクスとカスタムアロケータで動作する必要があるため、割り当てを本当に親密に理解することはできません。
<!--Instead, the main idea behind allocation is "doesn't overlap with other stuff".-->
代わりに、割り当ての背後にある主なアイデアは「他のものと重複しない」ことです。
<!--That is, heap allocations, stack allocations, and globals don't randomly overlap.-->
つまり、ヒープ割り当て、スタック割り当て、およびグローバルはランダムに重複しません。
<!--Yep, it's about alias analysis.-->
はい、エイリアス分析についてです。
<!--As such, Rust can technically play a bit fast and loose with the notion of an allocation as long as it's *consistent*.-->
このように、Rustは、*一貫し*ている限り、割当の概念を用いて技術的には少し速くて緩やかに演奏することができます。

<!--Getting back to the empty allocation case, there are a couple of places where we want to offset by 0 as a consequence of generic code.-->
空の割り当てケースに戻って、ジェネリックコードの結果として0でオフセットしたい場所がいくつかあります。
<!--The question is then: is it consistent to do so?-->
問題は次のようなものです。
<!--For zero-sized types, we have concluded that it is indeed consistent to do a GEP inbounds offset by an arbitrary number of elements.-->
ゼロサイズの型については、任意の数の要素によってGEPのインバウンドオフセットが実際に一貫していると結論付けました。
<!--This is a runtime no-op because every element takes up no space, and it's fine to pretend that there's infinite zero-sized types allocated at `0x01`.-->
これは実行時の操作ではありません。なぜなら、すべての要素がスペースを取らず、無限のゼロサイズの型が`0x01`割り当てられているように`0x01`ません。
<!--No allocator will ever allocate that address, because they won't allocate `0x00` and they generally allocate to some minimal alignment higher than a byte.-->
アロケータは`0x00`を割り振らず、一般に1バイト以上の最小アラインメントに割り当てるため、アロケータはそのアドレスを割り当てません。
<!--Also generally the whole first page of memory is protected from being allocated anyway (a whole 4k, on many platforms).-->
また、メモリの最初のページ全体は、とにかく割り当てられないように保護されています（多くのプラットフォームで4k全体）。

<!--However what about for positive-sized types?-->
しかし、正のサイズのタイプはどうですか？
<!--That one's a bit trickier.-->
それは少しトリッキーです。
<!--In principle, you can argue that offsetting by 0 gives LLVM no information: either there's an element before the address or after it, but it can't know which.-->
原則として、0でオフセットするとLLVMに情報が与えられないと主張することができます。住所の前または後に要素がありますが、どちらがどちらかを知ることはできません。
<!--However we've chosen to conservatively assume that it may do bad things.-->
しかし、私たちは、それが悪いことをするかもしれないと控えめに仮定しました。
<!--As such we will guard against this case explicitly.-->
このように、我々はこの事件に対して明白に警戒する。

<!--*Phew*-->
*Phew*

<!--Ok with all the nonsense out of the way, let's actually allocate some memory:-->
さて、すべてのナンセンスで、実際にいくつかのメモリを割り当てましょう：

```rust,ignore
use std::alloc::oom;

fn grow(&mut self) {
#    // this is all pretty delicate, so let's say it's all unsafe
    // これはすべてかなり繊細なので、すべて安全ではないと言いましょう
    unsafe {
#        // current API requires us to specify size and alignment manually.
        // 現在のAPIでは、手動でサイズと配置を指定する必要があります。
        let align = mem::align_of::<T>();
        let elem_size = mem::size_of::<T>();

        let (new_cap, ptr) = if self.cap == 0 {
            let ptr = heap::allocate(elem_size, align);
            (1, ptr)
        } else {
#            // as an invariant, we can assume that `self.cap < isize::MAX`,
#            // so this doesn't need to be checked.
            //  invariantとして、`self.cap < isize::MAX`と仮定できるので、これはチェックする必要はありません。
            let new_cap = self.cap * 2;
#            // Similarly this can't overflow due to previously allocating this
            // 同様に、これを以前に割り当てたためにオーバーフローすることはありません
            let old_num_bytes = self.cap * elem_size;

#            // check that the new allocation doesn't exceed `isize::MAX` at all
#            // regardless of the actual size of the capacity. This combines the
#            // `new_cap <= isize::MAX` and `new_num_bytes <= usize::MAX` checks
#            // we need to make. We lose the ability to allocate e.g. 2/3rds of
#            // the address space with a single Vec of i16's on 32-bit though.
#            // Alas, poor Yorick -- I knew him, Horatio.
            // 容量の実際のサイズに関係なく、新しい割り当てが`isize::MAX`を超えないことを確認してください。これは、`new_cap <= isize::MAX`と`new_num_bytes <= usize::MAX`チェックを`new_num_bytes <= usize::MAX`て行います。私たちは32ビットでi16の1つのVecで例えばアドレス空間の2/3を割り当てる能力を失う。ああ、貧しいヨリック -私は彼を知っていた、ホラティオ。
            assert!(old_num_bytes <= (::std::isize::MAX as usize) / 2,
                    "capacity overflow");

            let new_num_bytes = old_num_bytes * 2;
            let ptr = heap::reallocate(self.ptr.as_ptr() as *mut _,
                                        old_num_bytes,
                                        new_num_bytes,
                                        align);
            (new_cap, ptr)
        };

#        // If allocate or reallocate fail, we'll get `null` back
        //  allocateまたはreallocateが失敗すると、`null`戻されます。
        if ptr.is_null() { oom(); }

        self.ptr = Unique::new(ptr as *mut _);
        self.cap = new_cap;
    }
}
```

<!--Nothing particularly tricky here.-->
ここで特に難しいものはありません。
<!--Just computing sizes and alignments and doing some careful multiplication checks.-->
ちょうどサイズとアラインメントを計算し、慎重な乗算チェックを行います。

