# <!--New Type Idiom--> 新しいタイプのイディオム

<!--The `newtype` idiom gives compile time guarantees that the right type of value is supplied to a program.-->
`newtype`イディオムはコンパイル時に正しいタイプの値がプログラムに供給されることを保証します。

<!--For example, an age verification function that checks age in years, *must* be given a value of type `Years`.-->
例えば、年間で年齢をチェックする年齢認証機能は、型の値が与えられ*なければならない* `Years`。

```rust, editable
struct Years(i64);

struct Days(i64);

impl Years {
    pub fn to_days(&self) -> Days {
        Days(self.0 * 365)
    }
}


impl Days {
#//    /// truncates partial years
    /// 部分年を切り捨てる
    pub fn to_years(&self) -> Years {
        Years(self.0 / 365)
    }
}

fn old_enough(age: &Years) -> bool {
    age.0 >= 18
}

fn main() {
    let age = Years(5);
    let age_days = age.to_days();
    println!("Old enough {}", old_enough(&age));
    println!("Old enough {}", old_enough(&age_days.to_years()));
#    // println!("Old enough {}", old_enough(&age_days));
    //  println！（"Old enough {}"、old_enough（＆age_days））;
}
```

<!--Uncomment the last print statement to observe that the type supplied must be `Years`.-->
最後のprintステートメントのコメントを外し、指定された型が`Years`なければならないことを確認します。

### <!--See also:--> 参照：

[`structs`][struct]
[struct]: custom_types/structs.html

