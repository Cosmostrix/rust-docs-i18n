# <!--structs--> 構造体

<!--Similarly, a `struct` can be destructured as shown:-->
同様に、`struct`は次のように`struct`が破壊されます。

```rust,editable
fn main() {
    struct Foo { x: (u32, u32), y: u32 }

#    // destructure members of the struct
    // 構造体のメンバーを破棄する
    let foo = Foo { x: (1, 2), y: 3 };
    let Foo { x: (a, b), y } = foo;

    println!("a = {}, b = {},  y = {} ", a, b, y);

#    // you can destructure structs and rename the variables,
#    // the order is not important
    // 構造体を破棄して変数の名前を変更することができます。順序は重要ではありません

    let Foo { y: i, x: j } = foo;
    println!("i = {:?}, j = {:?}", i, j);

#    // and you can also ignore some variables:
    // いくつかの変数を無視することもできます：
    let Foo { y, .. } = foo;
    println!("y = {}", y);

#    // this will give an error: pattern does not mention field `x`
#    // let Foo { y } = foo;
    // これはエラーを起こします：patternはフィールド`x`言及しません。Foo {y} = foo;
}
```

### <!--See also:--> 参照：

<!--[Structs](custom_types/structs.html), [The ref pattern](scope/borrow/ref.html)-->
[Structs](custom_types/structs.html)、 [refパターン](scope/borrow/ref.html)
