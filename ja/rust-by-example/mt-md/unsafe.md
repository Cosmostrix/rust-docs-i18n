# <!--Unsafe Operations--> 安全でない操作

<!--As an introduction to this section, to borrow from [the official docs][unsafe], "one should try to minimize the amount of unsafe code in a code base."-->
このセクションの紹介として、[公式ドキュメント][unsafe]から借用するに[は][unsafe]、「コードベースで安全でないコードの量を最小限に抑えるようにしなければなりません」。
<!--With that in mind, let's get started!-->
そのことを念頭に置いて、始めましょう！
<!--Unsafe blocks in Rust are used to bypass protections put in place by the compiler;-->
Rustの安全でないブロックは、コンパイラによって保護された保護をバイパスするために使用されます。
<!--specifically, there are four primary things that unsafe blocks are used for:-->
具体的には、安全でないブロックが使用される主なものは4つあります。

* <!--dereferencing raw pointers-->
   デリバリーローポインタ
* <!--calling a function over FFI (but this is covered in [a previous chapter](std_misc/ffi.html) of the book)-->
   FFIを介して関数を呼び出す（ただしこれは[前の章](std_misc/ffi.html)で説明している）
* <!--calling functions which are `unsafe`-->
   `unsafe`関数を呼び出す
* <!--inline assembly-->
   インラインアセンブリ

### <!--Raw Pointers--> 生ポインタ
<!--Raw pointers `*` and references `&T` function similarly, but references are always safe because they are guaranteed to point to valid data due to the borrow checker.-->
生ポインタ`*`と参照`&T`も同様に機能しますが、参照はボローチェッカーのために有効なデータを指すことが保証されているため、常に安全です。
<!--Dereferencing a raw pointer can only be done through an unsafe block.-->
未処理のポインタを参照解除することは、安全でないブロックを介してのみ行うことができます。

```rust,editable
fn main() {
    let raw_p: *const u32 = &10;

    unsafe {
        assert!(*raw_p == 10);
    }
}
```

### <!--Calling Unsafe Functions--> 安全でない関数の呼び出し
<!--Some functions can be declared as `unsafe`, meaning it is the programmer's responsibility to ensure correctness instead of the compiler's.-->
一部の関数は`unsafe`と宣言することができます。つまり、コンパイラの代わりに正しいことを保証するのはプログラマの責任です。
<!--One example of this is [`std::slice::from_raw_parts`] which will create a slice given a pointer to the first element and a length.-->
これの一例は[`std::slice::from_raw_parts`]あり、最初の要素へのポインタと長さを与えられたスライスが作成されます。

```rust,editable
use std::slice;

fn main() {
    let some_vector = vec![1, 2, 3, 4];

    let pointer = some_vector.as_ptr();
    let length = some_vector.len();

    unsafe {
        let my_slice: &[u32] = slice::from_raw_parts(pointer, length);
        
        assert_eq!(some_vector.as_slice(), my_slice);
    }
}
```

<!--For `slice::from_raw_parts`, one of the assumptions which *must* be upheld is that the pointer passed in points to valid memory and that the memory pointed to is of the correct type.-->
`slice::from_raw_parts`については、仮定し*なければならない*仮定の1つは、ポインタが有効なメモリをポイントし、指し示されたメモリが正しいタイプであるということです。
<!--If these invariants aren't upheld then the program's behaviour is undefined and there is no knowing what will happen.-->
これらのインバリアントが維持されない場合、プログラムの動作は未定義であり、何が起こるかを知ることはできません。


<!--[unsafe]: https://doc.rust-lang.org/book/second-edition/ch19-01-unsafe-rust.html
 [`std::slice::from_raw_parts`]: https://doc.rust-lang.org/std/slice/fn.from_raw_parts.html
-->
[unsafe]: https://doc.rust-lang.org/book/second-edition/ch19-01-unsafe-rust.html
 [`std::slice::from_raw_parts`]: https://doc.rust-lang.org/std/slice/fn.from_raw_parts.html

