# <!--Channels--> チャンネル

<!--Rust provides asynchronous `channels` for communication between threads.-->
Rustはスレッド間の通信に非同期`channels`を提供します。
<!--Channels allow a unidirectional flow of information between two end-points: the `Sender` and the `Receiver`.-->
チャネルは、`Sender`と`Receiver` `Sender` 2つのエンドポイント間で一方向の情報フローを可能にします。

```rust,editable
use std::sync::mpsc::{Sender, Receiver};
use std::sync::mpsc;
use std::thread;

static NTHREADS: i32 = 3;

fn main() {
#    // Channels have two endpoints: the `Sender<T>` and the `Receiver<T>`,
#    // where `T` is the type of the message to be transferred
#    // (type annotation is superfluous)
    // チャネルには、`Sender<T>`と`Receiver<T>` `Sender<T>` 2つのエンドポイントがあります。ここで、`T`は転送されるメッセージのタイプです（タイプ注釈は余分です）
    let (tx, rx): (Sender<i32>, Receiver<i32>) = mpsc::channel();

    for id in 0..NTHREADS {
#        // The sender endpoint can be copied
        // 送信側エンドポイントはコピーできます
        let thread_tx = tx.clone();

#        // Each thread will send its id via the channel
        // 各スレッドは、そのIDをチャネル経由で送信します
        thread::spawn(move || {
#            // The thread takes ownership over `thread_tx`
#            // Each thread queues a message in the channel
            // スレッドは`thread_tx`超えて所有権を`thread_tx`各スレッドはメッセージをチャネルにキューイングする
            thread_tx.send(id).unwrap();

#            // Sending is a non-blocking operation, the thread will continue
#            // immediately after sending its message
            // 送信は非ブロッキング操作です。スレッドはメッセージを送信した直後に処理を続行します
            println!("thread {} finished", id);
        });
    }

#    // Here, all the messages are collected
    // ここでは、すべてのメッセージが収集されます
    let mut ids = Vec::with_capacity(NTHREADS as usize);
    for _ in 0..NTHREADS {
#        // The `recv` method picks a message from the channel
#        // `recv` will block the current thread if there are no messages available
        //  `recv`メソッドはチャネルからメッセージを`recv`ます`recv`は利用可能なメッセージがない場合は現在のスレッドをブロックします
        ids.push(rx.recv());
    }

#    // Show the order in which the messages were sent
    // メッセージが送信された順序を表示する
    println!("{:?}", ids);
}
```
