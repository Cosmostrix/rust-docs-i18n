## <!--Behavior considered undefined--> 定義されていない動作

<!--Rust code, including within `unsafe` blocks and `unsafe` functions is incorrect if it exhibits any of the behaviors in the following list.-->
`unsafe`で`unsafe`ブロックや`unsafe`関数を含む錆のコードは、以下のリストのいずれかの動作を示す場合は正しくあり`unsafe`。
<!--It is the programmer's responsibility when writing `unsafe` code that it is not possible to let `safe` code exhibit these behaviors.-->
`unsafe`コードを記述するときは、`safe`コードにこれらの動作を表示させることはできません。

* <!--Data races.-->
   データレース
* <!--Dereferencing a null or dangling raw pointer.-->
   NULLポインタまたは埋め込まれていない生ポインタを参照解除します。
* <!--Unaligned pointer reading and writing outside of [`read_unaligned`] and [`write_unaligned`].-->
   [`read_unaligned`]と[`write_unaligned`]外側でのポインタの並び替えと書き込みを[`write_unaligned`]ます。
* <!--Reads of [undef] \(uninitialized) memory.-->
   [undef] \（初期化されていない）メモリを読み込みます。
* <!--Breaking the [pointer aliasing rules] on accesses through raw pointers;-->
   ローポインタを使ったアクセスで[pointer aliasing rules]を破る。
<!--a subset of the rules used by C.-->
   C.によって使用されるルールのサブセット
* <!--`&mut T` and `&T` follow LLVM's scoped [noalias] model, except if the `&T` contains an [`UnsafeCell <span class="underline">`</span>].-->
   `&mut T`と`&T` LLVMのスコープ続く[noalias]場合を除いて、モデルを`&T`含まれている[`UnsafeCell <span class="underline">`</span>]。
* <!--Mutating non-mutable data &mdash;-->
   変更不可能なデータを突然変異させる
<!--that is, data reached through a shared reference or data owned by a `let` binding), unless that data is contained within an [`UnsafeCell <span class="underline">`</span>].-->
   つまり、データは、共有参照または所有するデータを介して到達`let`そのデータ内に含まれていない限り、結合）[`UnsafeCell <span class="underline">`</span>]。
* <!--Invoking undefined behavior via compiler intrinsics:-->
   コンパイラ組み込み関数を使用して未定義のビヘイビアを呼び出す：
  * <!--Indexing outside of the bounds of an object with [`offset`] with the exception of one byte past the end of the object.-->
     オブジェクトの終わりから1バイト先を除いて、オブジェクトの境界の外側で[`offset`]でインデックスを作成する。
  * <!--Using [`std::ptr::copy_nonoverlapping_memory`], aka the `memcpy32` and `memcpy64` intrinsics, on overlapping buffers.-->
     重複するバッファに[`std::ptr::copy_nonoverlapping_memory`]、別名`memcpy32`と`memcpy64`組み込み関数を使用します。
* <!--Invalid values in primitive types, even in private fields and locals:-->
   プライベートフィールドやローカルでもプリミティブ型の値が無効です：
  * <!--Dangling or null references and boxes.-->
     ダングリングまたはヌル参照とボックス。
  * <!--A value other than `false` (`0`) or `true` (`1`) in a `bool`.-->
     `bool` `false`（ `0`）または`true`（ `1`）以外の`bool`。
  * <!--A discriminant in an `enum` not included in the type definition.-->
     型定義に含まれていない`enum`型の判別式。
  * <!--A value in a `char` which is a surrogate or above `char::MAX`.-->
     値`char`サロゲート以上である`char::MAX`。
  * <!--Non-UTF-8 byte sequences in a `str`.-->
     `str`非UTF-8バイトシーケンス

<!--[noalias]: http://llvm.org/docs/LangRef.html#noalias
 [pointer aliasing rules]: http://llvm.org/docs/LangRef.html#pointer-aliasing-rules
 [undef]: http://llvm.org/docs/LangRef.html#undefined-values
 [`offset`]: https://doc.rust-lang.org/std/primitive.pointer.html#method.offset
 [`std::ptr::copy_nonoverlapping_memory`]: https://doc.rust-lang.org/std/ptr/fn.copy_nonoverlapping.html
 [`UnsafeCell<U>`]: https://doc.rust-lang.org/std/cell/struct.UnsafeCell.html
 [`read_unaligned`]: https://doc.rust-lang.org/std/ptr/fn.read_unaligned.html
 [`write_unaligned`]: https://doc.rust-lang.org/std/ptr/fn.write_unaligned.html
-->
[noalias]: http://llvm.org/docs/LangRef.html#noalias
 [pointer aliasing rules]: http://llvm.org/docs/LangRef.html#pointer-aliasing-rules
 [undef]: http://llvm.org/docs/LangRef.html#undefined-values
 [`offset`]: https://doc.rust-lang.org/std/primitive.pointer.html#method.offset
 [`std::ptr::copy_nonoverlapping_memory`]: https://doc.rust-lang.org/std/ptr/fn.copy_nonoverlapping.html
 [`UnsafeCell<U>`]: https://doc.rust-lang.org/std/cell/struct.UnsafeCell.html
 [`read_unaligned`]: https://doc.rust-lang.org/std/ptr/fn.read_unaligned.html
 [`write_unaligned`]: https://doc.rust-lang.org/std/ptr/fn.write_unaligned.html

