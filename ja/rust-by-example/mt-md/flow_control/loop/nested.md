# <!--Nesting and labels--> ネスティングとラベル

<!--It's possible to `break` or `continue` outer loops when dealing with nested loops.-->
ネストされたループを処理するときに、外部ループを`break`または`continue`ことは可能です。
<!--In these cases, the loops must be annotated with some `'label`, and the label must be passed to the `break` / `continue` statement.-->
これらの場合、ループにはいくつか`'label`が付いていなければならず、ラベルは`break` / `continue`ステートメントに渡されなければなりません。

```rust,editable
#![allow(unreachable_code)]

fn main() {
    'outer: loop {
        println!("Entered the outer loop");

        'inner: loop {
            println!("Entered the inner loop");

#            // This would break only the inner loop
            // これは内側のループだけを破るでしょう
            //break;

#            // This breaks the outer loop
            // これは外側ループを壊す
            break 'outer;
        }

        println!("This point will never be reached");
    }

    println!("Exited the outer loop");
}
```
