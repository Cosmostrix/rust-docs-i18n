# <!--Memory allocation and lifetime--> メモリの割り当てと有効期間

<!--The  _items_  of a program are those functions, modules and types that have their value calculated at compile-time and stored uniquely in the memory image of the rust process.-->
プログラムの _項目_ は、コンパイル時に計算され、錆プロセスのメモリイメージに一意に格納された値を持つ関数、モジュール、およびタイプです。
<!--Items are neither dynamically allocated nor freed.-->
項目が動的に割り当てられたり解放されたりすることはありません。

<!--The  _heap_  is a general term that describes boxes.-->
 _ヒープ_ はボックスを表す一般的な用語です。
<!--The lifetime of an allocation in the heap depends on the lifetime of the box values pointing to it.-->
ヒープ内の割り当ての存続期間は、それを指しているボックス値の存続期間に依存します。
<!--Since box values may themselves be passed in and out of frames, or stored in the heap, heap allocations may outlive the frame they are allocated within.-->
ボックスの値自体がフレームに渡されるか、またはヒープに格納される可能性があるため、ヒープ割り当ては、割り当てられたフレームよりも長くなる可能性があります。
<!--An allocation in the heap is guaranteed to reside at a single location in the heap for the whole lifetime of the allocation -it will never be relocated as a result of moving a box value.-->
ヒープ内の割り当ては、割り当ての全ライフタイムの間、ヒープ内の単一の場所に存在することが保証されています。ボックス値を移動した結果、それが再配置されることはありません。
