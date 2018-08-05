# `?`
<!--Chaining results using match can get pretty untidy;-->
マッチを使用して結果を連鎖させると、
<!--luckily, the `?`-->
幸運にも、`?`
<!--operator can be used to make things pretty again.-->
演算子を使用して、再び物事をきれいにすることができます。
`?` <!--is used at the end of an expression returning a `Result`, and is equivalent to a match expression, where the `Err(err)` branch expands to an early `Err(From::from(err))`, and the `Ok(ok)` branch expands to an `ok` expression.-->
`Result`返す式の終わりで使用され、`Err(err)`ブランチが初期の`Err(From::from(err))`に展開され、`Ok(ok)`ブランチが展開する一致式と等価です`ok`表現に`ok`する。

```rust,editable,ignore,mdbook-runnable
mod checked {
    #[derive(Debug)]
    enum MathError {
        DivisionByZero,
        NonPositiveLogarithm,
        NegativeSquareRoot,
    }

    type MathResult = Result<f64, MathError>;

    fn div(x: f64, y: f64) -> MathResult {
        if y == 0.0 {
            Err(MathError::DivisionByZero)
        } else {
            Ok(x / y)
        }
    }

    fn sqrt(x: f64) -> MathResult {
        if x < 0.0 {
            Err(MathError::NegativeSquareRoot)
        } else {
            Ok(x.sqrt())
        }
    }

    fn ln(x: f64) -> MathResult {
        if x <= 0.0 {
            Err(MathError::NonPositiveLogarithm)
        } else {
            Ok(x.ln())
        }
    }

#    // Intermediate function
    // 中間機能
    fn op_(x: f64, y: f64) -> MathResult {
#        // if `div` "fails", then `DivisionByZero` will be `return`ed
        //  `div` "失敗"すると、`DivisionByZero`が`return`ます
        let ratio = div(x, y)?;

#        // if `ln` "fails", then `NonPositiveLogarithm` will be `return`ed
        //  `ln` "失敗"すると、`NonPositiveLogarithm`が`return`ます
        let ln = ln(ratio)?;

        sqrt(ln)
    }

    pub fn op(x: f64, y: f64) {
        match op_(x, y) {
            Err(why) => panic!(match why {
                MathError::NonPositiveLogarithm
                    => "logarithm of non-positive number",
                MathError::DivisionByZero
                    => "division by zero",
                MathError::NegativeSquareRoot
                    => "square root of negative number",
            }),
            Ok(value) => println!("{}", value),
        }
    }
}

fn main() {
    checked::op(1.0, 10.0);
}
```

<!--Be sure to check the [documentation][docs], as there are many methods to map/compose `Result`.-->
`Result`をマップ/作成する方法はたくさんあるので、必ず[documentation][docs]確認してください。

[docs]: https://doc.rust-lang.org/std/result/index.html
