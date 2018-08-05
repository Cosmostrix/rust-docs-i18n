# <!--Threads--> スレッド

<!--Rust provides a mechanism for spawning native OS threads via the `spawn` function, the argument of this function is a moving closure.-->
Rustは、`spawn`関数を介してネイティブOSスレッドを`spawn`ためのメカニズムを提供します。この関数の引数は、動くクロージャです。

```rust,editable
use std::thread;

static NTHREADS: i32 = 10;

#// This is the `main` thread
// これが`main`スレッドです
fn main() {
#    // Make a vector to hold the children which are spawned.
    // 産んだ子を保持するベクトルを作成します。
    let mut children = vec![];

    for i in 0..NTHREADS {
#        // Spin up another thread
        // 別のスレッドをスピンアップ
        children.push(thread::spawn(move || {
            println!("this is thread number {}", i);
        }));
    }

    for child in children {
#        // Wait for the thread to finish. Returns a result.
        // スレッドが終了するのを待ちます。結果を返します。
        let _ = child.join();
    }
}
```

<!--These threads will be scheduled by the OS.-->
これらのスレッドは、OSによってスケジュールされます。
