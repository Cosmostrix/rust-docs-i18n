# <!--Variadic Interfaces--> 可変インターフェース

<!--A  _variadic_  interface takes an arbitrary number of arguments.-->
 _可変的な_ インタフェースは任意の数の引数をとります。
<!--For example, `println!` can take an arbitrary number of arguments, as determined by the format string.-->
たとえば、`println!`は、書式文字列によって決定される任意の数の引数を取ることができます。

<!--We can extend our `calculate!` macro from the previous section to be variadic:-->
前のセクションの`calculate!`マクロをバリデーションに拡張することができます：

```rust,editable
macro_rules! calculate {
#    // The pattern for a single `eval`
    // 単一の`eval`ためのパターン
    (eval $e:expr) => {{
        {
#//            let val: usize = $e; // Force types to be integers
            let val: usize = $e; // 型を強制的に整数にする
            println!("{} = {}", stringify!{$e}, val);
        }
    }};

#    // Decompose multiple `eval`s recursively
    // 複数の`eval`再帰的に分解する
    (eval $e:expr, $(eval $es:expr),+) => {{
        calculate! { eval $e }
        calculate! { $(eval $es),+ }
    }};
}

fn main() {
#//    calculate! { // Look ma! Variadic `calculate!`!
    calculate! { // ママ！ Variadic `calculate!`ます！
        eval 1 + 2,
        eval 3 + 4,
        eval (2 * 3) + 1
    }
}
```

<!--Output:-->
出力：

```txt
1 + 2 = 3
3 + 4 = 7
(2 * 3) + 1 = 7
```
