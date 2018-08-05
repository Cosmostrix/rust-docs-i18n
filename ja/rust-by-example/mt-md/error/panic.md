# `panic`
<!--The simplest error handling mechanism we will see is `panic`.-->
私たちが見る最も簡単なエラー処理の仕組みは`panic`です。
<!--It prints an error message, starts unwinding the task, and usually exits the program.-->
エラーメッセージを表示し、タスクの巻き戻しを開始し、通常はプログラムを終了します。
<!--Here, we explicitly call `panic` on our error condition:-->
ここでは、明示的に私たちのエラー状態を`panic`と呼びます：

```rust,editable,ignore,mdbook-runnable
fn give_princess(gift: &str) {
#    // Princesses hate snakes, so we need to stop if she disapproves!
    // プリンセスはヘビを憎むので、もし彼女が不名誉なら止める必要がある！
    if gift == "snake" { panic!("AAAaaaaa!!!!"); }

    println!("I love {}s!!!!!", gift);
}

fn main() {
    give_princess("teddy bear");
    give_princess("snake");
}
```
