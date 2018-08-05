# <!--Diverging functions--> 機能の分散

<!--Diverging functions never return.-->
発散機能は決して戻ってこない。
<!--They are marked using `!`, which is an empty type.-->
それらは空のタイプである`!`を使用してマークされます。

```rust
fn foo() -> ! {
    panic!("This call never returns.");
}
```

<!--As opposed to all the other types, this one cannot be instantiated, because the set of all possible values this type can have is empty.-->
他のすべてのタイプとは対照的に、このタイプの可能なすべての値のセットは空であるため、このタイプはインスタンス化できません。
<!--Note, that it is different from the `()` type, which has exactly one possible value.-->
可能な値がちょうど1つある`()`型とは異なることに注意してください。

<!--For example, this functions returns as usual, although there is no information in the return value.-->
たとえば、戻り値に情報はありませんが、この関数は通常通り返します。

```rust
fn some_fn() {
    ()
}

fn main() {
    let a: () = some_fn();
    println!("This functions returns and you can see this line.")
}
```

<!--As opposed to this function, which will never return the control back to the caller.-->
この関数は、コントロールを呼び出し元に返すことはありません。

```rust,ignore
#![feature(never_type)]

fn main() {
    let x: ! = panic!("This call never returns.");
    println!("You will never see this line!");
}
```

<!--Although this might seem like an abstract concept, it is in fact very useful and often handy.-->
これは抽象的な概念のように見えるかもしれませんが、実際には非常に便利で、しばしば便利です。
<!--The main advantage of this type is that it can be cast to any other one and therefore used at places where an exact type is required, for instance in `match` branches.-->
このタイプの主な利点は、他のタイプにキャストすることができるため、たとえば`match`ブランチなど、正確なタイプが必要な場所で使用できることです。
<!--This allows us to write code like this:-->
これにより、次のようなコードを書くことができます：

```rust
fn main() {
    fn sum_odd_numbers(up_to: u32) -> u32 {
        let mut acc = 0;
        for i in 0..up_to {
#            // Notice that the return type of this match expression must be u32
#            // because of the type of the "addition" variable.
            // この一致式の戻り値の型は、「追加」変数の型のためにu32でなければならないことに注意してください。
            let addition: u32 = match i%2 == 1 {
#                // The "i" variable is of type u32, which is perfectly fine.
                //  "i"変数の型はu32型ですが、これはまったく問題ありません。
                true => i,
#                // On the other hand, the "continue" expression does not return
#                // u32, but it is still fine, because it never returns and therefore
#                // does not violate the type requirements of the match expression.
                // 一方、「続行」式はu32を返しませんが、それは決して返されず、したがって一致式の型要件に違反しないため、まだ問題ありません。
                false => continue,
            };
            acc += addition;
        }
        acc
    }
    println!("Sum of odd numbers up to 9 (excluding): {}", sum_odd_numbers(9));
}
```

<!--It is also the return type of functions that loop forever (eg `loop {}`) like network servers or functions that terminates the process (eg `exit()`).-->
また、ネットワークサーバやプロセスを終了させる関数（`exit()`など）のように永遠にループする関数の戻り型です（`loop {}`など）。
