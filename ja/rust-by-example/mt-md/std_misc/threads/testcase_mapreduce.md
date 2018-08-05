# <!--Testcase: map-reduce--> テストケース：map-reduce

<!--Rust makes it very easy to parallelise data processing, without many of the headaches traditionally associated with such an attempt.-->
錆は、伝統的にそのような試みに関連した頭痛の多くを伴わずに、データ処理を並列化することを非常に容易にする。

<!--The standard library provides great threading primitives out of the box.-->
標準ライブラリは、すぐに使える素晴らしいスレッドプリミティブを提供します。
<!--These, combined with Rust's concept of Ownership and aliasing rules, automatically prevent data races.-->
これらはRustの所有権とエイリアスルールのコンセプトと組み合わせて、データ競合を自動的に防止します。

<!--The aliasing rules (one writable reference XOR many readable references) automatically prevent you from manipulating state that is visible to other threads.-->
エイリアスのルール（1つの書き込み可能な参照XOR多くの読み取り可能な参照）は自動的に、他のスレッドから見える状態を操作できなくなります。
<!--(Where synchronisation is needed, there are synchronisation primitives like `Mutex` es or `Channel` s.)-->
（同期が必要な場合は、`Mutex` esや`Channel` sなどの同期プリミティブがあります。）

<!--In this example, we will calculate the sum of all digits in a block of numbers.-->
この例では、数値のブロック内のすべての桁の合計を計算します。
<!--We will do this by parcelling out chunks of the block into different threads.-->
ブロックのチャンクを別のスレッドに分割することでこれを行います。
<!--Each thread will sum its tiny block of digits, and subsequently we will sum the intermediate sums produced by each thread.-->
各スレッドは、その小さな桁のブロックを合計し、その後、各スレッドによって生成された中間合計を合計します。

<!--Note that, although we're passing references across thread boundaries, Rust understands that we're only passing read-only references, and that thus no unsafety or data races can occur.-->
スレッド境界を越えて参照を渡していますが、Rustは読み取り専用の参照のみを渡していることを理解しているため、安全でないかデータ競合が発生する可能性はありません。
<!--Because we're `move` -ing the data segments into the thread, Rust will also ensure the data is kept alive until the threads exit, so no dangling pointers occur.-->
データセグメントをスレッドに`move`ため、Rustはスレッドが終了するまでデータが確実に保持されるようにして、ぶら下がりポインタが発生しないようにします。

```rust,editable
use std::thread;

#// This is the `main` thread
// これが`main`スレッドです
fn main() {

#    // This is our data to process.
#    // We will calculate the sum of all digits via a threaded  map-reduce algorithm.
#    // Each whitespace separated chunk will be handled in a different thread.
    // これが処理するデータです。私たちはスレッドマップ削減アルゴリズムを使ってすべての数字の合計を計算します。各空白で区切られたチャンクは、別のスレッドで処理されます。
    //
#    // TODO: see what happens to the output if you insert spaces!
    //  TODO：スペースを挿入すると、出力に何が起こるかを確認してください！
    let data = "86967897737416471853297327050364959
11861322575564723963297542624962850
70856234701860851907960690014725639
38397966707106094172783238747669219
52380795257888236525459303330302837
58495327135744041048897885734297812
69920216438980873548808413720956532
16278424637452589860345374828574668";

#    // Make a vector to hold the child-threads which we will spawn.
    // 生成する子スレッドを保持するベクトルを作成します。
    let mut children = vec![];

    /*************************************************************************
     * "Map" phase
     *
     * Divide our data into segments, and apply initial processing
     ************************************************************************/

#    // split our data into segments for individual calculation
#    // each chunk will be a reference (&str) into the actual data
    // 個々の計算のために私たちのデータをセグメントに分割します。各チャンクは実際のデータへの参照（＆str）になります
    let chunked_data = data.split_whitespace();

#    // Iterate over the data segments.
#    // .enumerate() adds the current loop index to whatever is iterated
#    // the resulting tuple "(index, element)" is then immediately
#    // "destructured" into two variables, "i" and "data_segment" with a
#    // "destructuring assignment"
    // データセグメントを反復処理します。.enumerate（）は、現在のループインデックスを、結果のタプル "（index、element）"が反復されるものに追加します。"destructuring assignment"を伴う "i"と "data_segment"
    for (i, data_segment) in chunked_data.enumerate() {
        println!("data segment {} is \"{}\"", i, data_segment);

#        // Process each data segment in a separate thread
        // 別のスレッドで各データセグメントを処理する
        //
#        // spawn() returns a handle to the new thread,
#        // which we MUST keep to access the returned value
        //  spawn（）は新しいスレッドへのハンドルを返します。返された値にアクセスするためにはそれを保持しなければなりません
        //
#        // 'move || -> u32' is syntax for a closure that:
#        // * takes no arguments ('||')
#        // * takes ownership of its captured variables ('move') and
#        // * returns an unsigned 32-bit integer ('-> u32')
        //  '移動|| -> u32 'は、引数を取らない（' || '）*はキャプチャされた変数（' move '）の所有権を持ち、*は符号なし32ビット整数（' -> u32 '）を返すクロージャの構文です
        //
#        // Rust is smart enough to infer the '-> u32' from
#        // the closure itself so we could have left that out.
        // 錆は、クロージャ自身から ' -> u32'を推論するのに十分なほどスマートです。
        //
#        // TODO: try removing the 'move' and see what happens
        //  TODO： '移動'を削除して何が起こるかを確認してください
        children.push(thread::spawn(move || -> u32 {
#            // Calculate the intermediate sum of this segment:
            // このセグメントの中間合計を計算します。
            let result = data_segment
#                        // iterate over the characters of our segment..
                        // 私たちのセグメントの文字を繰り返します。
                        .chars()
#                        // .. convert text-characters to their number value..
                        // ..テキスト文字を数値に変換する..
                        .map(|c| c.to_digit(10).expect("should be a digit"))
#                        // .. and sum the resulting iterator of numbers
                        // ..そして得られた数の反復子
                        .sum();

#            // println! locks stdout, so no text-interleaving occurs
            //  println！ stdoutをロックするので、テキストインターリーブは起こりません
            println!("processed segment {}, result={}", i, result);

#            // "return" not needed, because Rust is an "expression language", the
#            // last evaluated expression in each block is automatically its value.
            //  Rustは "式言語"なので、"return"は必要ありません。各ブロックの最後に評価された式は自動的にその値になります。
            result

        }));
    }


    /*************************************************************************
     * "Reduce" phase
     *
     * Collect our intermediate results, and combine them into a final result
     ************************************************************************/

#    // collect each thread's intermediate results into a new Vec
    // 各スレッドの中間結果を新しいVecに集める
    let mut intermediate_sums = vec![];
    for child in children {
#        // collect each child thread's return-value
        // 各子スレッドの戻り値を収集する
        let intermediate_sum = child.join().unwrap();
        intermediate_sums.push(intermediate_sum);
    }

#    // combine all intermediate sums into a single final sum.
    // すべての中間合計を1つの最終的な合計にまとめます。
    //
#    // we use the "turbofish" ::<> to provide sum() with a type hint.
    // 私たちは "turbofish":: <>を使用して、sum（）に型ヒントを提供します。
    //
#    // TODO: try without the turbofish, by instead explicitly
#    // specifying the type of final_result
    //  TODO：turbofishを使わずに、代わりにfinal_resultの型を明示的に指定する
    let final_result = intermediate_sums.iter().sum::<u32>();

    println!("Final sum result: {}", final_result);
}


```

### <!--Assignments--> 割り当て
<!--It is not wise to let our number of threads depend on user inputted data.-->
私たちのスレッド数をユーザーが入力したデータに依存させるのは賢明ではありません。
<!--What if the user decides to insert a lot of spaces?-->
ユーザーが多くのスペースを挿入することを決定したらどうなりますか？
<!--Do we  _really_  want to spawn 2,000 threads?-->
私たちは _本当に_  2,000スレッドを生成したいのですか？
<!--Modify the program so that the data is always chunked into a limited number of chunks, defined by a static constant at the beginning of the program.-->
プログラムの始めに静的な定数で定義された限られた数のチャンクにデータが常にチャンクされるように、プログラムを修正します。

### <!--See also:--> 参照：
* [Threads][thread]
* <!--[vectors][vectors] and [iterators][iterators]-->
   [vectors][vectors]と[iterators][iterators]
* <!--[closures][closures], [move][move] semantics and [`move` closures][move_closure]-->
   [closures][closures]、 [move][move]セマンティクスと[`move`クロージャ][move_closure]
* <!--[destructuring][destructuring] assignments-->
   [destructuring][destructuring]割り当て
* <!--[turbofish notation][turbofish] to help type inference-->
   型推論を支援する[ターボフィッシュ表記法][turbofish]
* <!--[unwrap vs. expect][unwrap]-->
   [アンラップ対期待][unwrap]
* [enumerate][enumerate]

<!--[thread]: std_misc/threads.html
 [vectors]: std/vec.html
 [iterators]: trait/iter.html
 [destructuring]: https://doc.rust-lang.org/book/second-edition/ch18-03-pattern-syntax.html#destructuring-to-break-apart-values
 [closures]: fn/closures.html
 [move]: scope/move.html
 [move_closure]: https://doc.rust-lang.org/book/second-edition/ch13-01-closures.html#closures-can-capture-their-environment
 [turbofish]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.collect
 [unwrap]: error/option_unwrap.html
 [enumerate]: https://doc.rust-lang.org/book/loops.html#enumerate
-->
[thread]: std_misc/threads.html
 [vectors]: std/vec.html
 [iterators]: trait/iter.html
 [destructuring]: https://doc.rust-lang.org/book/second-edition/ch18-03-pattern-syntax.html#destructuring-to-break-apart-values
 [closures]: fn/closures.html
 [move]: scope/move.html
 [move_closure]: https://doc.rust-lang.org/book/second-edition/ch13-01-closures.html#closures-can-capture-their-environment
 [turbofish]: https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.collect
 [unwrap]: error/option_unwrap.html
 [enumerate]: https://doc.rust-lang.org/book/loops.html#enumerate

