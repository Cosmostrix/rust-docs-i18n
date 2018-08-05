# <!--DRY (Don't Repeat Yourself)--> ドライ（あなた自身を繰り返さないでください）

<!--Macros allow writing DRY code by factoring out the common parts of functions and/or test suites.-->
マクロでは、関数やテストスイートの共通部分を抽出してDRYコードを書くことができます。
<!--Here is an example that implements and tests the `+=`, `*=` and `-=` operators on `Vec<T>`:-->
`Vec<T>`の`+=`、 `*=`および`-=`演算子を実装してテストする例を次に示します。

```rust,editable
use std::ops::{Add, Mul, Sub};

macro_rules! assert_equal_len {
#    // The `tt` (token tree) designator is used for
#    // operators and tokens.
    //  `tt`（トークンツリー）指定子は、演算子とトークンに使用されます。
    ($a:ident, $b: ident, $func:ident, $op:tt) => (
        assert!($a.len() == $b.len(),
                "{:?}: dimension mismatch: {:?} {:?} {:?}",
                stringify!($func),
                ($a.len(),),
                stringify!($op),
                ($b.len(),));
    )
}

macro_rules! op {
    ($func:ident, $bound:ident, $op:tt, $method:ident) => (
        fn $func<T: $bound<T, Output=T> + Copy>(xs: &mut Vec<T>, ys: &Vec<T>) {
            assert_equal_len!(xs, ys, $func, $op);

            for (x, y) in xs.iter_mut().zip(ys.iter()) {
                *x = $bound::$method(*x, *y);
#                // *x = x.$method(*y);
                //  *x = x。$メソッド（* y）;
            }
        }
    )
}

#// Implement `add_assign`, `mul_assign`, and `sub_assign` functions.
//  `add_assign`、 `mul_assign`、および`sub_assign`関数を`sub_assign`ます。
op!(add_assign, Add, +=, add);
op!(mul_assign, Mul, *=, mul);
op!(sub_assign, Sub, -=, sub);

mod test {
    use std::iter;
    macro_rules! test {
        ($func: ident, $x:expr, $y:expr, $z:expr) => {
            #[test]
            fn $func() {
                for size in 0usize..10 {
                    let mut x: Vec<_> = iter::repeat($x).take(size).collect();
                    let y: Vec<_> = iter::repeat($y).take(size).collect();
                    let z: Vec<_> = iter::repeat($z).take(size).collect();

                    super::$func(&mut x, &y);

                    assert_eq!(x, z);
                }
            }
        }
    }

#    // Test `add_assign`, `mul_assign` and `sub_assign`
    // テスト`add_assign`、 `mul_assign`、および`sub_assign`
    test!(add_assign, 1u32, 2u32, 3u32);
    test!(mul_assign, 2u32, 3u32, 6u32);
    test!(sub_assign, 3u32, 2u32, 1u32);
}
```

```bash
$ rustc --test dry.rs && ./dry
running 3 tests
test test::mul_assign ... ok
test test::add_assign ... ok
test test::sub_assign ... ok

test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured
```
