# `Result`
<!--We've seen that the `Option` enum can be used as a return value from functions that may fail, where `None` can be returned to indicate failure.-->
`Option` enumは失敗する可能性のある関数からの戻り値として使用できることがわかりました。ここでは、失敗を示すために`None`を返すことができます。
<!--However, sometimes it is important to express *why* an operation failed.-->
ただし、操作が失敗した*理由*を表現することが重要な場合もあります。
<!--To do this we have the `Result` enum.-->
これを行うために、`Result` enumがあります。

<!--The `Result<T, E>` enum has two variants:-->
`Result<T, E>` enumには2つのバリエーションがあります。

* <!--`Ok(value)` which indicates that the operation succeeded, and wraps the `value` returned by the operation.-->
   操作が成功したことを示す`Ok(value)`。操作によって戻された`value`をラップし`value`。
<!--(`value` has type `T`)-->
   （`value`にタイプ`T`）
* <!--`Err(why)`, which indicates that the operation failed, and wraps `why`, which (hopefully) explains the cause of the failure.-->
   操作が失敗したことを示す`Err(why)`は、失敗の原因を説明する（うまくいけば）`why`をラップします。
<!--(`why` has type `E`)-->
   （`why` `E`型があるの`why`）

```rust,editable,ignore,mdbook-runnable
mod checked {
#    // Mathematical "errors" we want to catch
    // 私たちが捉えたい数学的な「誤り」
    #[derive(Debug)]
    pub enum MathError {
        DivisionByZero,
        NonPositiveLogarithm,
        NegativeSquareRoot,
    }

    pub type MathResult = Result<f64, MathError>;

    pub fn div(x: f64, y: f64) -> MathResult {
        if y == 0.0 {
#            // This operation would `fail`, instead let's return the reason of
#            // the failure wrapped in `Err`
            // この操作は`fail`、代わりに`Err`ラップされた`Err`理由を返します
            Err(MathError::DivisionByZero)
        } else {
#            // This operation is valid, return the result wrapped in `Ok`
            // この操作は有効で、`Ok`ラップされた結果を返します
            Ok(x / y)
        }
    }

    pub fn sqrt(x: f64) -> MathResult {
        if x < 0.0 {
            Err(MathError::NegativeSquareRoot)
        } else {
            Ok(x.sqrt())
        }
    }

    pub fn ln(x: f64) -> MathResult {
        if x <= 0.0 {
            Err(MathError::NonPositiveLogarithm)
        } else {
            Ok(x.ln())
        }
    }
}

#// `op(x, y)` === `sqrt(ln(x / y))`
//  `op(x, y)` === `sqrt(ln(x / y))`
fn op(x: f64, y: f64) -> f64 {
#    // This is a three level match pyramid!
    // これは3つのレベルのマッチピラミッドです！
    match checked::div(x, y) {
        Err(why) => panic!("{:?}", why),
        Ok(ratio) => match checked::ln(ratio) {
            Err(why) => panic!("{:?}", why),
            Ok(ln) => match checked::sqrt(ln) {
                Err(why) => panic!("{:?}", why),
                Ok(sqrt) => sqrt,
            },
        },
    }
}

fn main() {
#    // Will this fail?
    // これは失敗するでしょうか？
    println!("{}", op(1.0, 10.0));
}
```
