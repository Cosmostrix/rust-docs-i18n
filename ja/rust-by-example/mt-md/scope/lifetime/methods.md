# <!--Methods--> メソッド

<!--Methods are annotated similarly to functions:-->
メソッドには、関数と同様に注釈が付けられます。

```rust,editable
struct Owner(i32);

impl Owner {
#    // Annotate lifetimes as in a standalone function.
    // スタンドアロン機能のように寿命に注釈を付ける。
    fn add_one<'a>(&'a mut self) { self.0 += 1; }
    fn print<'a>(&'a self) {
        println!("`print`: {}", self.0);
    }
}

fn main() {
    let mut owner  = Owner(18);

    owner.add_one();
    owner.print();
}
```

### <!--See also:--> 参照：

[methods]
[methods]: fn/methods.html
