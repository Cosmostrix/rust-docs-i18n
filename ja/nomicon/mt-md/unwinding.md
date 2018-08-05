# <!--Unwinding--> 巻き戻す

<!--Rust has a *tiered* error-handling scheme:-->
Rustには*段階的な*エラー処理スキームがあります。

* <!--If something might reasonably be absent, Option is used.-->
   合理的に何かが存在しない場合は、Optionが使用されます。
* <!--If something goes wrong and can reasonably be handled, Result is used.-->
   何かがうまくいかず合理的に処理できる場合は、Resultが使用されます。
* <!--If something goes wrong and cannot reasonably be handled, the thread panics.-->
   何かがうまくいかず、合理的に処理できない場合、スレッドはパニックに陥ります。
* <!--If something catastrophic happens, the program aborts.-->
   何か致命的な事態が発生した場合、プログラムは打ち切られます。

<!--Option and Result are overwhelmingly preferred in most situations, especially since they can be promoted into a panic or abort at the API user's discretion.-->
オプションと結果は、ほとんどの状況で圧倒的に好まれます。特に、APIユーザーの裁量でパニックまたはアボートに昇格する可能性があるためです。
<!--Panics cause the thread to halt normal execution and unwind its stack, calling destructors as if every function instantly returned.-->
パニックにより、スレッドは通常の実行を停止し、スタックを巻き戻し、すべての関数が即座に返されたかのようにデストラクタを呼び出します。

<!--As of 1.0, Rust is of two minds when it comes to panics.-->
1.0の時点で、パニックになるとRustは2つの心のものです。
<!--In the long-long-ago, Rust was much more like Erlang.-->
長い間、RustはErlangによく似ていました。
<!--Like Erlang, Rust had lightweight tasks, and tasks were intended to kill themselves with a panic when they reached an untenable state.-->
Erlangのように、Rustは軽量のタスクを持っていました。タスクは、容赦のない状態になったときにパニックで自分自身を殺すことを意図していました。
<!--Unlike an exception in Java or C++, a panic could not be caught at any time.-->
JavaやC ++の例外とは異なり、いつでもパニックをキャッチすることはできませんでした。
<!--Panics could only be caught by the owner of the task, at which point they had to be handled or *that* task would itself panic.-->
パニックは、タスクの所有者だけが捕まえることができ、その時点でそれらを処理しなければならない、または*その*タスク自体がパニックになる可能性があります。

<!--Unwinding was important to this story because if a task's destructors weren't called, it would cause memory and other system resources to leak.-->
タスクのデストラクタが呼び出されなかった場合、メモリやその他のシステムリソースがリークする可能性があるため、巻き戻しはこのストーリーにとって重要でした。
<!--Since tasks were expected to die during normal execution, this would make Rust very poor for long-running systems!-->
タスクは通常の実行中に消滅することが予想されていたため、これは長時間実行されるシステムではRustを非常に悪くします。

<!--As the Rust we know today came to be, this style of programming grew out of fashion in the push for less-and-less abstraction.-->
今日知られている錆が現れたので、このスタイルのプログラミングは、抽象的でない抽象化のためにファッションから成長しました。
<!--Light-weight tasks were killed in the name of heavy-weight OS threads.-->
軽量のタスクは、重量のあるOSスレッドの名前で殺されました。
<!--Still, on stable Rust as of 1.0 panics can only be caught by the parent thread.-->
それでも、1.0パニックの安定したRustでは、親スレッドだけが捕まえることができます。
<!--This means catching a panic requires spinning up an entire OS thread!-->
つまり、パニックを起こすには、OSスレッド全体を回転させる必要があります。
<!--This unfortunately stands in conflict to Rust's philosophy of zero-cost abstractions.-->
これは残念なことに、Rustのゼロコスト抽象化の哲学と矛盾している。

<!--There is an unstable API called `catch_panic` that enables catching a panic without spawning a thread.-->
スレッドを生成せずにパニックをキャッチできる`catch_panic`という不安定なAPIがあります。
<!--Still, we would encourage you to only do this sparingly.-->
それでも、私たちはこれを慎重に行うことをお勧めします。
<!--In particular, Rust's current unwinding implementation is heavily optimized for the "doesn't unwind"case.-->
特に、Rustの現在の巻き戻しの実装は、"unwind unwind"の場合に大きく最適化されています。
<!--If a program doesn't unwind, there should be no runtime cost for the program being *ready* to unwind.-->
プログラムが巻き戻されない場合、プログラムが巻き戻す*準備*が*でき*ているランタイム・コストはないはずです。
<!--As a consequence, actually unwinding will be more expensive than in eg Java.-->
結果として、実際に巻き戻すことは、たとえばJavaの場合よりも高価になります。
<!--Don't build your programs to unwind under normal circumstances.-->
通常の状況下では、プログラムを作成しないでください。
<!--Ideally, you should only panic for programming errors or *extreme* problems.-->
理想的には、プログラミングエラーや*極端な*問題のみを慌てるべきです。

<!--Rust's unwinding strategy is not specified to be fundamentally compatible with any other language's unwinding.-->
Rustの解き放つ戦略は、他の言語の解きほぐしと基本的に互換性があるとは指定されていません。
<!--As such, unwinding into Rust from another language, or unwinding into another language from Rust is Undefined Behavior.-->
したがって、別の言語からRustに巻き戻したり、Rustから別の言語に戻したりすることは未定義の動作です。
<!--You must *absolutely* catch any panics at the FFI boundary!-->
あなたは*絶対に* FFI境界でパニックをキャッチする必要があります！
<!--What you do at that point is up to you, but *something* must be done.-->
その時点であなたがすることはあなた次第ですが、*何かをする*必要があります。
<!--If you fail to do this, at best, your application will crash and burn.-->
これをしないと、せいぜいアプリケーションがクラッシュして焼いてしまうだけです。
<!--At worst, your application *won't* crash and burn, and will proceed with completely clobbered state.-->
最悪の場合、アプリケーション*は*クラッシュ*せず*、焼き付かず、完全に閉塞状態になります。
