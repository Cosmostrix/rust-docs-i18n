# <!--Returning from loops--> ループからの戻り

<!--One of the uses of a `loop` is to retry an operation until it succeeds.-->
`loop`の使用法の1つは、成功するまで操作を再試行することです。
<!--If the operation returns a value though, you might need to pass it to the rest of the code: put it after the `break`, and it will be returned by the `loop` expression.-->
演算が値を返す場合、残りのコードに渡す必要があります： `break`後に置くと、`loop`式によって返され`loop`。

```rust,editable
fn main() {
    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    assert_eq!(result, 20);
}
```
