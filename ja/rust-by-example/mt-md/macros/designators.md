# <!--Designators--> 指定子

<!--The arguments of a macro are prefixed by a dollar sign `$` and type annotated with a *designator*:-->
マクロの引数にはドル記号`$`と接頭辞が付いていて、*指定子で*注釈が付けられます。

```rust,editable
macro_rules! create_function {
#    // This macro takes an argument of designator `ident` and
#    // creates a function named `$func_name`.
#    // The `ident` designator is used for variable/function names.
    // このマクロは、指定子`ident`引数をとり、`$func_name`という名前の関数を作成します。`ident`指定子は、変数/関数名に使用されます。
    ($func_name:ident) => (
        fn $func_name() {
#            // The `stringify!` macro converts an `ident` into a string.
            //  `stringify!`マクロは、`ident`を文字列に変換します。
            println!("You called {:?}()",
                     stringify!($func_name));
        }
    )
}

#// Create functions named `foo` and `bar` with the above macro.
// 上記のマクロを使って`foo`と`bar`という名前の関数を作成します。
create_function!(foo);
create_function!(bar);

macro_rules! print_result {
#    // This macro takes an expression of type `expr` and prints
#    // it as a string along with its result.
#    // The `expr` designator is used for expressions.
    // このマクロは`expr`型の式をとり、その結果とともに文字列として出力します。`expr`指定子は式に使用されます。
    ($expression:expr) => (
#        // `stringify!` will convert the expression *as it is* into a string.
        //  `stringify!`はそのまま式*を*文字列に変換します。
        println!("{:?} = {:?}",
                 stringify!($expression),
                 $expression);
    )
}

fn main() {
    foo();
    bar();

    print_result!(1u32 + 1);

#    // Recall that blocks are expressions too!
    // ブロックも式であることを思い出してください！
    print_result!({
        let x = 1u32;

        x * x + 2 * x - 1
    });
}
```

<!--This is a list of all the designators:-->
これはすべての指定子のリストです：

* `block`
* <!--`expr` is used for expressions-->
   `expr`は式に使用されます
* <!--`ident` is used for variable/function names-->
   `ident`は変数/関数名に使用されます
* `item`
* <!--`pat` (*pattern*)-->
   `pat`（ *パターン*）
* `path`
* <!--`stmt` (*statement*)-->
   `stmt`（ *ステートメント*）
* <!--`tt` (*token tree*)-->
   `tt`（ *トークンツリー*）
* <!--`ty` (*type*)-->
   `ty`（ *タイプ*）
