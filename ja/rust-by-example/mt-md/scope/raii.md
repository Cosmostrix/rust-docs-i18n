# <!--RAII--> RAII

<!--Variables in Rust do more than just hold data in the stack: they also *own* resources, eg `Box<T>` owns memory in the heap.-->
Rustの変数は、単にスタック内のデータを保持するだけでなく、リソースも*持っ*ています。例えば、`Box<T>`はヒープ内のメモリを所有しています。
<!--Rust enforces [RAII][raii] (Resource Acquisition Is Initialization), so whenever an object goes out of scope, its destructor is called and its owned resources are freed.-->
Rustは[RAII][raii]（Resource Acquisition Is Initialization）を適用しているため、オブジェクトが有効範囲外になると、デストラクタが呼び出され、所有リソースが解放されます。

<!--This behavior shields against *resource leak* bugs, so you'll never have to manually free memory or worry about memory leaks again!-->
この動作は*リソースリークの*バグを防ぎます。したがって、手動でメモリを解放したり、メモリリークを心配する必要はありません。
<!--Here's a quick showcase:-->
ここでは簡単なショーケースです：

```rust,editable
#// raii.rs
//  raii.rs
fn create_box() {
#    // Allocate an integer on the heap
    // ヒープ上に整数を割り当てる
    let _box1 = Box::new(3i32);

#    // `_box1` is destroyed here, and memory gets freed
    //  `_box1`はここで破棄され、メモリは解放されます
}

fn main() {
#    // Allocate an integer on the heap
    // ヒープ上に整数を割り当てる
    let _box2 = Box::new(5i32);

#    // A nested scope:
    // 入れ子スコープ：
    {
#        // Allocate an integer on the heap
        // ヒープ上に整数を割り当てる
        let _box3 = Box::new(4i32);

#        // `_box3` is destroyed here, and memory gets freed
        //  `_box3`はここで破壊され、メモリは解放されます
    }

#    // Creating lots of boxes just for fun
#    // There's no need to manually free memory!
    // ただ楽しいためにたくさんのボックスを作成する手動でメモリを解放する必要はありません！
    for _ in 0u32..1_000 {
        create_box();
    }

#    // `_box2` is destroyed here, and memory gets freed
    //  `_box2`はここで破棄され、メモリは解放されます
}
```

<!--Of course, we can double check for memory errors using [`valgrind`][valgrind]:-->
もちろん、[`valgrind`][valgrind]を使ってメモリエラーを再確認することもできます：

```bash
$ rustc raii.rs && valgrind ./raii
==26873== Memcheck, a memory error detector
==26873== Copyright (C) 2002-2013, and GNU GPL'd, by Julian Seward et al.
==26873== Using Valgrind-3.9.0 and LibVEX; rerun with -h for copyright info
==26873== Command: ./raii
==26873==
==26873==
==26873== HEAP SUMMARY:
==26873==     in use at exit: 0 bytes in 0 blocks
==26873==   total heap usage: 1,013 allocs, 1,013 frees, 8,696 bytes allocated
==26873==
==26873== All heap blocks were freed -- no leaks are possible
==26873==
==26873== For counts of detected and suppressed errors, rerun with: -v
==26873== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 2 from 2)
```

<!--No leaks here!-->
ここには漏れはありません！

## <!--Destructor--> デストラクタ

<!--The notion of a destructor in Rust is provided through the [`Drop`] trait.-->
Rustのデストラクタの概念は、[`Drop`]特性によって提供されます。
<!--The destructor is called when the resource goes out of scope.-->
デストラクタは、リソースが有効範囲外になると呼び出されます。
<!--This trait is not required to be implemented for every type, only implement it for your type if you require its own destructor logic.-->
この特性は、すべての型に対して実装する必要はなく、独自のデストラクタロジックが必要な場合にのみ、その型に対して実装する必要があります。

<!--Run the below example to see how the [`Drop`] trait works.-->
次の例を実行して、[`Drop`]特性がどのように働くかを見てください。
<!--When the variable in the `main` function goes out of scope the custom destructor will be invoked.-->
`main`関数の変数が有効範​​囲外になると、カスタムデストラクタが呼び出されます。

```rust,editable
struct ToDrop;

impl Drop for ToDrop {
    fn drop(&mut self) {
        println!("ToDrop is being dropped");
    }
}

fn main() {
    let x = ToDrop;
    println!("Made a ToDrop!");
}
```

### <!--See also:--> 参照：

[Box][box]
<!--[raii]: https://en.wikipedia.org/wiki/Resource_Acquisition_Is_Initialization
 [box]: std/box.html
 [valgrind]: http://valgrind.org/info/
 [`Drop`]: https://doc.rust-lang.org/std/ops/trait.Drop.html
-->
[raii]: https://en.wikipedia.org/wiki/Resource_Acquisition_Is_Initialization
 [box]: std/box.html
 [valgrind]: http://valgrind.org/info/
 [`Drop`]: https://doc.rust-lang.org/std/ops/trait.Drop.html

