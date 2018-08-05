# <!--Unsafe blocks--> 安全でないブロック

<!--A block of code can be prefixed with the `unsafe` keyword, to permit calling `unsafe` functions or dereferencing raw pointers within a safe function.-->
コードのブロックに`unsafe`キーワードを接頭辞として付けると、`unsafe` `unsafe`関数を呼び出したり、安全な関数内で生ポインタを逆参照することができます。

<!--When a programmer has sufficient conviction that a sequence of potentially unsafe operations is actually safe, they can encapsulate that sequence (taken as a whole) within an `unsafe` block.-->
プログラマが安全でない可能性のある操作のシーケンスが実際に安全であるという十分な確信を持っている場合、安全で`unsafe`ブロック内にそのシーケンスを（全体として）カプセル化することができます。
<!--The compiler will consider uses of such code safe, in the surrounding context.-->
コンパイラは、そのようなコードを安全に使用することを周囲の状況で考慮します。

<!--Unsafe blocks are used to wrap foreign libraries, make direct use of hardware or implement features not directly present in the language.-->
安全でないブロックは、外部ライブラリをラップしたり、ハードウェアを直接使用したり、言語に直接存在しない機能を実装したりするために使用されます。
<!--For example, Rust provides the language features necessary to implement memory-safe concurrency in the language but the implementation of threads and message passing is in the standard library.-->
たとえば、Rustは言語でメモリ安全な並行処理を実装するために必要な言語機能を提供しますが、スレッドの実装やメッセージの受け渡しは標準ライブラリにあります。

<!--Rust's type system is a conservative approximation of the dynamic safety requirements, so in some cases there is a performance cost to using safe code.-->
Rustのタイプシステムは、動的安全要件の控えめな近似であるため、場合によっては安全コードを使用するためのパフォーマンスコストがあります。
<!--For example, a doubly-linked list is not a tree structure and can only be represented with reference-counted pointers in safe code.-->
例えば、二重リンクされたリストは木構造ではなく、安全なコードで参照カウントされたポインタでしか表現できません。
<!--By using `unsafe` blocks to represent the reverse links as raw pointers, it can be implemented with only boxes.-->
`unsafe`ブロックを使用して逆リンクを生ポインタとして表現することで、ボックスのみで実装できます。
