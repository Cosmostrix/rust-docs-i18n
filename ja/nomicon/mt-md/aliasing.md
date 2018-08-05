# <!--Aliasing--> エイリアス

<!--First off, let's get some important caveats out of this way:-->
まず、このようにいくつかの重要な警告を出しましょう：

* <!--We will be using the broadest possible definition of aliasing for the sake-->
   私たちは、できるだけ広い範囲でエイリアシングの定義を使用します
<!--of discussion.-->
議論の
<!--Rust's definition will probably be more restricted to factor in mutations and liveness.-->
Rustの定義はおそらく、突然変異と生存率の因子に限定されるだろう。

* <!--We will be assuming a single-threaded, interrupt-free, execution.-->
   私たちは、シングルスレッド、割り込みのない実行を想定しています。
<!--We will also-->
   我々はまた、
<!--be ignoring things like memory-mapped hardware.-->
メモリマップされたハードウェアのようなものは無視してください。
<!--Rust assumes these things don't happen unless you tell it otherwise.-->
Rustは、あなたがそうでないと言っていない限り、これらのことは起こらないと仮定します。
<!--For more details, see the [Concurrency Chapter](concurrency.html).-->
詳細については、「 [同時実行性」の章を](concurrency.html)参照してください。

<!--With that said, here's our working definition: variables and pointers *alias* if they refer to overlapping regions of memory.-->
それで、ここでは私たちの働く定義です：変数とポインタはメモリの重複領域を参照する場合は*別名*です。




# <!--Why Aliasing Matters--> なぜエイリアスが重要なのか

<!--So why should we care about aliasing?-->
だから、なぜエイリアスを気にする必要がありますか？

<!--Consider this simple function:-->
この単純な関数を考えてみましょう：

```rust
fn compute(input: &u32, output: &mut u32) {
    if *input > 10 {
        *output = 1;
    }
    if *input > 5 {
        *output *= 2;
    }
}
```

<!--We would *like* to be able to optimize it to the following function:-->
私たちは、次の関数にそれを最適化できるようにし*たい*と思います。

```rust
fn compute(input: &u32, output: &mut u32) {
#//    let cached_input = *input; // keep *input in a register
    let cached_input = *input; //  *入力をレジスタに保持する
    if cached_input > 10 {
#//        *output = 2;  // x > 10 implies x > 5, so double and exit immediately
        *output = 2;  //  x> 10はx> 5を意味するので、二重にして直ちに終了する
    } else if cached_input > 5 {
        *output *= 2;
    }
}
```

<!--In Rust, this optimization should be sound.-->
Rustでは、この最適化は健全でなければなりません。
<!--For almost any other language, it wouldn't be (barring global analysis).-->
他のほとんどの言語については、（グローバルな分析を除いて）そうではありません。
<!--This is because the optimization relies on knowing that aliasing doesn't occur, which most languages are fairly liberal with.-->
これは、最適化がエイリアシングが発生しないことを知ることに依存しているためです。ほとんどの言語はかなり自由です。
<!--Specifically, we need to worry about function arguments that make `input` and `output` overlap, such as `compute(&x, &mut x)`.-->
具体的には、`compute(&x, &mut x)`ように、`input`と`output`オーバーラップを行う関数の引数について心配する必要があります。

<!--With that input, we could get this execution:-->
その入力で、この実行を得ることができます：

```rust,ignore
#                    //  input ==  output == 0xabad1dea
#                    // *input == *output == 20
                    // 入力==出力== 0xabad1の*入力==*出力== 20
#//if *input > 10 {    // true  (*input == 20)
if *input > 10 {    //  true（* input == 20）
#//    *output = 1;    // also overwrites *input, because they are the same
    *output = 1;    //  *入力も上書きされます
}
#//if *input > 5 {     // false (*input == 1)
if *input > 5 {     //  false（* input == 1）
    *output *= 2;
}
#                    // *input == *output == 1
                    //  *入力==*出力== 1
```

<!--Our optimized function would produce `*output == 2` for this input, so the correctness of our optimization relies on this input being impossible.-->
最適化された関数はこの入力に対して`*output == 2`を生成するので、最適化の正確さはこの入力が不可能であることに依存します。

<!--In Rust we know this input should be impossible because `&mut` isn't allowed to be aliased.-->
Rustでは、`&mut`がエイリアス化されていないため、この入力は不可能であることがわかります。
<!--So we can safely reject its possibility and perform this optimization.-->
したがって、その可能性を拒否し、この最適化を実行することができます。
<!--In most other languages, this input would be entirely possible, and must be considered.-->
ほとんどの言語では、この入力は完全に可能であり、考慮する必要があります。

<!--This is why alias analysis is important: it lets the compiler perform useful optimizations!-->
これがエイリアス解析が重要な理由です。コンパイラは有用な最適化を実行できます。
<!--Some examples:-->
いくつかの例：

* <!--keeping values in registers by proving no pointers access the value's memory-->
   ポインタが値のメモリにアクセスしていないことを証明してレジスタに値を保持する
* <!--eliminating reads by proving some memory hasn't been written to since last we read it-->
   私たちが最後に読んで以来、いくつかのメモリが書かれていないことを証明することによって、読取りを排除する
* <!--eliminating writes by proving some memory is never read before the next write to it-->
   いくつかのメモリを証明することによって書き込みを消去することは、次の書き込みの前には決して読み込まれません
* <!--moving or reordering reads and writes by proving they don't depend on each other-->
   お互いに依存しないことを証明することによって読み書きを移動または並べ替える

<!--These optimizations also tend to prove the soundness of bigger optimizations such as loop vectorization, constant propagation, and dead code elimination.-->
これらの最適化はまた、ループベクトル化、定数伝搬、およびデッドコード除去などのより大きな最適化の健全性を証明する傾向があります。

<!--In the previous example, we used the fact that `&mut u32` can't be aliased to prove that writes to `*output` can't possibly affect `*input`.-->
前の例では、`&mut u32`は、`*output`への書き込みが`*input`影響する可能性があることを証明するために別名指定することはできません。
<!--This let us cache `*input` in a register, eliminating a read.-->
これは、`*input`をレジスタにキャッシュさせ、読み込みを排除します。

<!--By caching this read, we knew that the the write in the `> 10` branch couldn't affect whether we take the `> 5` branch, allowing us to also eliminate a read-modify-write (doubling `*output`) when `*input > 10`.-->
この読み込みをキャッシュすることで、`> 10`ブランチの書き込みが`> 5`ブランチを取るかどうかに影響を及ぼさず、`*input > 10`ときにリード・モディファイ・ライト（ダブリング`*output`）を排除できることが分かりました。

<!--The key thing to remember about alias analysis is that writes are the primary hazard for optimizations.-->
エイリアス分析について覚えておくべき重要なことは、書き込みが最適化の主要な危険であることです。
<!--That is, the only thing that prevents us from moving a read to any other part of the program is the possibility of us re-ordering it with a write to the same location.-->
つまり、プログラムの他の部分に読み込みを移動させないようにする唯一の方法は、同じ場所への書き込みでプログラムを並べ替えることです。

<!--For instance, we have no concern for aliasing in the following modified version of our function, because we've moved the only write to `*output` to the very end of our function.-->
例えば、次の関数の修正版ではエイリアシングに関心がありません。なぜなら、`*output`だけを関数の最後に移動したからです。
<!--This allows us to freely reorder the reads of `*input` that occur before it:-->
これにより、前に出現した`*input`の読みを自由に並べ替えることができます：

```rust
fn compute(input: &u32, output: &mut u32) {
    let mut temp = *output;
    if *input > 10 {
        temp = 1;
    }
    if *input > 5 {
        temp *= 2;
    }
    *output = temp;
}
```

<!--We're still relying on alias analysis to assume that `temp` doesn't alias `input`, but the proof is much simpler: the value of a local variable can't be aliased by things that existed before it was declared.-->
`temp`は`input`エイリアスではないと仮定してエイリアス解析を`temp`してい`input`が、証明ははるかに簡単です。ローカル変数の値は、宣言される前に存在していたものによってエイリアス化することはできません。
<!--This is an assumption every language freely makes, and so this version of the function could be optimized the way we want in any language.-->
これはすべての言語が自由に作れることを前提としているので、このバージョンの関数はどの言語でも最適な方法で最適化できます。

<!--This is why the definition of "alias"that Rust will use likely involves some notion of liveness and mutation: we don't actually care if aliasing occurs if there aren't any actual writes to memory happening.-->
これは、Rustが使用する「エイリアス」の定義が、生存性や変異の概念を含む可能性があるためです。メモリへの実際の書き込みがない場合、エイリアシングが発生するかどうかは実際には気にしません。

<!--Of course, a full aliasing model for Rust must also take into consideration things like function calls (which may mutate things we don't see), raw pointers (which have no aliasing requirements on their own), and UnsafeCell (which lets the referent of an `&` be mutated).-->
もちろん、Rustの完全なエイリアシングモデルでは、関数呼び出し（わからないものを変更する可能性があります）、生ポインタ（独自のエイリアシング要件はありません）、UnsafeCellの`&`変異されます）。



