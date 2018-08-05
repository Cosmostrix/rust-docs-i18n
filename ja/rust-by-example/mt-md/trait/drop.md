# <!--Drop--> ドロップ

<!--The [`Drop`][Drop] trait only has one method: `drop`, which is called automatically when an object goes out of scope.-->
[`Drop`][Drop]特性には、オブジェクトが有効範囲外になると自動的に呼び出される`drop` 1つのメソッドしかありません。
<!--The main use of the `Drop` trait is to free the resources that the implementor instance owns.-->
`Drop`特性の主な用途は、実装者インスタンスが所有するリソースを解放することです。

<!--`Box`, `Vec`, `String`, `File`, and `Process` are some examples of types that implement the `Drop` trait to free resources.-->
`Box`、 `Vec`、 `String`、 `File`、および`Process`は、リソースを解放するための`Drop`特性を実装するタイプのいくつかの例です。
<!--The `Drop` trait can also be manually implemented for any custom data type.-->
`Drop`特性は、任意のカスタムデータタイプに対して手動で実装することもできます。

<!--The following example adds a print to console to the `drop` function to announce when it is called.-->
次の例では、`drop`関数にコンソールへの印刷を追加し、呼び出されたときに通知します。

```rust,editable
struct Droppable {
    name: &'static str,
}

#// This trivial implementation of `drop` adds a print to console.
// この簡単な`drop`実装は、印刷物をコンソールに追加します。
impl Drop for Droppable {
    fn drop(&mut self) {
        println!("> Dropping {}", self.name);
    }
}

fn main() {
    let _a = Droppable { name: "a" };

#    // block A
    // ブロックA
    {
        let _b = Droppable { name: "b" };

#        // block B
        // ブロックB
        {
            let _c = Droppable { name: "c" };
            let _d = Droppable { name: "d" };

            println!("Exiting block B");
        }
        println!("Just exited block B");

        println!("Exiting block A");
    }
    println!("Just exited block A");

#    // Variable can be manually dropped using the `drop` function
    //  `drop`機能を使用して変数を手動でドロップすることができます
    drop(_a);
#    // TODO ^ Try commenting this line
    //  TODO ^この行をコメントしよう

    println!("end of the main function");

#    // `_a` *won't* be `drop`ed again here, because it already has been
#    // (manually) `drop`ed
    // すでに（手動で）`drop`されているため、`_a` *は*ここで再び`drop` *されません*
}
```

[Drop]: https://doc.rust-lang.org/std/ops/trait.Drop.html
