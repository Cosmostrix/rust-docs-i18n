# <!--Concurrency and Parallelism--> 並行性と並列性

<!--Rust as a language doesn't *really* have an opinion on how to do concurrency or parallelism.-->
言語としての錆は、並行性や並列性の方法に関する意見はありませ*ん*。
<!--The standard library exposes OS threads and blocking sys-calls because everyone has those, and they're uniform enough that you can provide an abstraction over them in a relatively uncontroversial way.-->
標準ライブラリは、OSスレッドとブロッキングsys呼び出しを公開しています。なぜなら、誰もそれらを持っており、比較的議論の余地のない方法でそれらの抽象化を提供できるほど十分に統一されているからです。
<!--Message passing, green threads, and async APIs are all diverse enough that any abstraction over them tends to involve trade-offs that we weren't willing to commit to for 1.0.-->
メッセージパッシング、グリーンスレッド、および非同期APIはすべて、多様性があり、それらの抽象化は我々が1.0のためにコミットしたくないトレードオフを伴う傾向があります。

<!--However the way Rust models concurrency makes it relatively easy to design your own concurrency paradigm as a library and have everyone else's code Just Work with yours.-->
しかし、Rustは並行性をモデル化するため、ライブラリとして独自の並行性パラダイムを設計することは比較的容易であり、ほかの人のコードもあなたのものと一緒に作業することができます。
<!--Just require the right lifetimes and Send and Sync where appropriate and you're off to the races.-->
適切なライフタイムと送信と同期を必要とするだけで、あなたはレースに出ます。
<!--Or rather, off to the... not... having... races.-->
またはむしろ、オフに...ない...レースを持っている。
