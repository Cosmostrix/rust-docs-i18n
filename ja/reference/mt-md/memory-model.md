# <!--Memory model--> メモリモデル

<!--A Rust program's memory consists of a static set of *items* and a *heap*.-->
Rustプログラムのメモリは、静的な*項目*セットと*ヒープ*で構成されてい*ます*。
<!--Immutable portions of the heap may be safely shared between threads, mutable portions may not be safely shared, but several mechanisms for effectively-safe sharing of mutable values, built on unsafe code but enforcing a safe locking discipline, exist in the standard library.-->
ヒープの不変部分はスレッド間で安全に共有できますが、可変部分は安全に共有されない可能性がありますが、安全でないコードで構築された安全なロック規律を適用する可変値の効果的な共有のためのいくつかのメカニズムが標準ライブラリにあります。

<!--Allocations in the stack consist of *variables*, and allocations in the heap consist of *boxes*.-->
スタック内の割り当ては*変数*で構成され、ヒープ内の割り当ては*ボックスで*構成されます。
