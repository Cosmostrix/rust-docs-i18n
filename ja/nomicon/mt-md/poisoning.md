# <!--Poisoning--> 中毒

<!--Although all unsafe code *must* ensure it has minimal exception safety, not all types ensure *maximal* exception safety.-->
すべての安全でないコードは最小限の例外安全性を保証する*必要があり*ます*が*、すべてのタイプが*最大限の*例外安全性を保証するわけではありません。
<!--Even if the type does, your code may ascribe additional meaning to it.-->
たとえ型があったとしても、あなたのコードはそれに付加的な意味があると考えるかもしれません。
<!--For instance, an integer is certainly exception-safe, but has no semantics on its own.-->
たとえば、整数は確かに例外セーフですが、それ自体は意味を持ちません。
<!--It's possible that code that panics could fail to correctly update the integer, producing an inconsistent program state.-->
パニックが発生した場合、整数を正しく更新できず、一貫性のないプログラム状態になる可能性があります。

<!--This is *usually* fine, because anything that witnesses an exception is about to get destroyed.-->
例外を目撃するものは破壊しようとしているので、これは*通常は*問題ありません。
<!--For instance, if you send a Vec to another thread and that thread panics, it doesn't matter if the Vec is in a weird state.-->
たとえば、Vecを別のスレッドに送信してそのスレッドがパニックする場合、Vecが奇妙な状態にあるかどうかは関係ありません。
<!--It will be dropped and go away forever.-->
それは捨てられ、永遠に消え去るでしょう。
<!--However some types are especially good at smuggling values across the panic boundary.-->
しかし、いくつかのタイプは、パニック境界を越えて値を密輸することに特に優れています。

<!--These types may choose to explicitly *poison* themselves if they witness a panic.-->
これらのタイプは、彼らがパニックを目撃場合は、明示的に自分自身を*毒殺*することもできます。
<!--Poisoning doesn't entail anything in particular.-->
中毒は特に何も伴わない。
<!--Generally it just means preventing normal usage from proceeding.-->
一般的には、通常の使用が進行しないようにするだけです。
<!--The most notable example of this is the standard library's Mutex type.-->
これの最も顕著な例は、標準ライブラリのMutexタイプです。
<!--A Mutex will poison itself if one of its MutexGuards (the thing it returns when a lock is obtained) is dropped during a panic.-->
ミューテックスは、パニック時にMutexGuard（ロックが取得されたときに返されるもの）の1つが破棄されると、自身を害します。
<!--Any future attempts to lock the Mutex will return an `Err` or panic.-->
Mutexをロックしようとすると、`Err`またはパニックが返されます。

<!--Mutex poisons not for true safety in the sense that Rust normally cares about.-->
Rutが通常気にかけている意味での真の安全性のためのものではない。
<!--It poisons as a safety-guard against blindly using the data that comes out of a Mutex that has witnessed a panic while locked.-->
それはロックされている間にパニックを目撃したミューテックスから出てくるデータを盲目的に使用することに対する安全保護の役目を果たします。
<!--The data in such a Mutex was likely in the middle of being modified, and as such may be in an inconsistent or incomplete state.-->
このようなミューテックスのデータは、変更の途中である可能性が高いため、不整合または不完全な状態になる可能性があります。
<!--It is important to note that one cannot violate memory safety with such a type if it is correctly written.-->
このようなタイプのメモリが正しく書かれていれば、メモリの安全性に違反することはできないことに注意することが重要です。
<!--After all, it must be minimally exception-safe!-->
結局のところ、最小限の例外セーフでなければなりません！

<!--However if the Mutex contained, say, a BinaryHeap that does not actually have the heap property, it's unlikely that any code that uses it will do what the author intended.-->
しかし、実際にヒーププロパティを持たないBinaryHeapがミューテックスに含まれていた場合、それを使用するコードでは意図したとおりのことは起こりそうにありません。
<!--As such, the program should not proceed normally.-->
したがって、プログラムは正常に進まないはずです。
<!--Still, if you're double-plus-sure that you can do *something* with the value, the Mutex exposes a method to get the lock anyway.-->
それでも、値を使って*何か*できることを二重に確信している場合、Mutexはロックを取得する方法を公開します。
<!--It *is* safe, after all.-->
結局*は*安全です。
<!--Just maybe nonsense.-->
ちょうどナンセンスかもしれない。
