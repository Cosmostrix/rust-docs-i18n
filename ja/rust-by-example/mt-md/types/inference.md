# <!--Inference--> 推論

<!--The type inference engine is pretty smart.-->
型推論エンジンはかなりスマートです。
<!--It does more than looking at the type of the [r-value][rvalue] during an initialization.-->
初期化中に[r-value][rvalue]型を調べる以上のことをします。
<!--It also looks at how the variable is used afterwards to infer its type.-->
また、変数が後でその型を推論するためにどのように使われるかを調べます。
<!--Here's an advanced example of type inference:-->
タイプ推論の高度な例を次に示します。

```rust,editable
fn main() {
#    // Because of the annotation, the compiler knows that `elem` has type u8.
    // 注釈のために、コンパイラは`elem`が型u8を持つことを知ってい`elem`。
    let elem = 5u8;

#    // Create an empty vector (a growable array).
    // 空のベクトル（拡張可能な配列）を作成します。
    let mut vec = Vec::new();
#    // At this point the compiler doesn't know the exact type of `vec`, it
#    // just knows that it's a vector of something (`Vec<_>`).
    // この時点で、コンパイラは`vec`の正確な型を知らず、何かのベクトル（`Vec<_>`）を知っているだけです。

#    // Insert `elem` in the vector.
    //  `elem`をベクトルに挿入し`elem`。
    vec.push(elem);
#    // Aha! Now the compiler knows that `vec` is a vector of `u8`s (`Vec<u8>`)
#    // TODO ^ Try commenting out the `vec.push(elem)` line
    // ああ！コンパイラは、`vec`が`u8`（ `Vec<u8>`）のベクトルであることを知っています`Vec<u8>` ^ `vec.push(elem)`行を`vec.push(elem)`してみてください

    println!("{:?}", vec);
}
```

<!--No type annotation of variables was needed, the compiler is happy and so is the programmer!-->
変数のタイプ注釈は必要ありませんでした。コンパイラは満足していますし、プログラマもそうです！

[rvalue]: https://en.wikipedia.org/wiki/Value_%28computer_science%29#lrvalue
