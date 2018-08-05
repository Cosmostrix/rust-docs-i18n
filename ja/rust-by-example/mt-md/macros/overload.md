# <!--Overload--> 過負荷

<!--Macros can be overloaded to accept different combinations of arguments.-->
さまざまな引数の組み合わせを受け入れるようにマクロをオーバーロードすることができます。
<!--In that regard, `macro_rules!` can work similarly to a match block:-->
これに関して、`macro_rules!`はマッチブロックと同様に動作します：

```rust,editable
#// `test!` will compare `$left` and `$right`
#// in different ways depending on how you invoke it:
//  `test!`は`$left`と`$right`をどのように呼び出すかによって異なる方法で比較します：
macro_rules! test {
#    // Arguments don't need to be separated by a comma.
#    // Any template can be used!
    // 引数はコンマで区切る必要はありません。どんなテンプレートでも使用できます！
    ($left:expr; and $right:expr) => (
        println!("{:?} and {:?} is {:?}",
                 stringify!($left),
                 stringify!($right),
                 $left && $right)
    );
#    // ^ each arm must end with a semicolon.
    //  ^各腕はセミコロンで終わらなければならない。
    ($left:expr; or $right:expr) => (
        println!("{:?} or {:?} is {:?}",
                 stringify!($left),
                 stringify!($right),
                 $left || $right)
    );
}

fn main() {
    test!(1i32 + 1 == 2i32; and 2i32 * 2 == 4i32);
    test!(true; or false);
}
```
