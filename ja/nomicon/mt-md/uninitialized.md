# <!--Working With Uninitialized Memory--> 初期化されていないメモリの操作

<!--All runtime-allocated memory in a Rust program begins its life as *uninitialized*.-->
Rustプログラム内の実行時に割り当てられたすべてのメモリは、*初期化さ*れて*いない状態で*寿命を開始します。
<!--In this state the value of the memory is an indeterminate pile of bits that may or may not even reflect a valid state for the type that is supposed to inhabit that location of memory.-->
この状態では、メモリの値は、メモリのその場所に存在すると思われるタイプの有効な状態を反映していてもいなくてもよい不確定なビットである。
<!--Attempting to interpret this memory as a value of *any* type will cause Undefined Behavior.-->
このメモリを*任意の*型の値として解釈しようとすると、未定義の動作が発生します。
<!--Do Not Do This.-->
こんなことしないで。

<!--Rust provides mechanisms to work with uninitialized memory in checked (safe) and unchecked (unsafe) ways.-->
Rustは、チェックされた（安全な）方法とチェックされていない（危険な）方法で初期化されていないメモリを処理するメカニズムを提供します。
