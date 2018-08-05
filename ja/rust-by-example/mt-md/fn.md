# <!--Functions--> 機能

<!--Functions are declared using the `fn` keyword.-->
関数は`fn`キーワードを使用して宣言されます。
<!--Its arguments are type annotated, just like variables, and, if the function returns a value, the return type must be specified after an arrow `->`.-->
その引数は、関数が値を返す場合、戻り値の型は矢印の後に指定する必要があり、ちょうど変数のように、タイプ注釈付きで、`->`。

<!--The final expression in the function will be used as return value.-->
関数の最後の式は戻り値として使用されます。
<!--Alternatively, the `return` statement can be used to return a value earlier from within the function, even from inside loops or `if` s.-->
代わりに、`return`ステートメントを使用して、ループ内またはsの`if`でも、関数内から早く値を返すことができます。

<!--Let's rewrite FizzBuzz using functions!-->
関数を使ってFizzBu​​zzを書き直しましょう！

```rust,editable
#// Unlike C/C++, there's no restriction on the order of function definitions
//  C / C ++とは異なり、関数定義の順序に制限はありません
fn main() {
#    // We can use this function here, and define it somewhere later
    // この関数をここで使用し、後でどこかで定義することができます
    fizzbuzz_to(100);
}

#// Function that returns a boolean value
// ブール値を返す関数
fn is_divisible_by(lhs: u32, rhs: u32) -> bool {
#    // Corner case, early return
    // コーナーケース、早期復帰
    if rhs == 0 {
        return false;
    }

#    // This is an expression, the `return` keyword is not necessary here
    // これは式ですが、`return`キーワードはここでは必要ありません
    lhs % rhs == 0
}

#// Functions that "don't" return a value, actually return the unit type `()`
// 値を返さない関数は、実際にユニットの型を返します`()`
fn fizzbuzz(n: u32) -> () {
    if is_divisible_by(n, 15) {
        println!("fizzbuzz");
    } else if is_divisible_by(n, 3) {
        println!("fizz");
    } else if is_divisible_by(n, 5) {
        println!("buzz");
    } else {
        println!("{}", n);
    }
}

#// When a function returns `()`, the return type can be omitted from the
#// signature
// 関数がreturn `()`すると、戻り値の型を署名から省略することができます
fn fizzbuzz_to(n: u32) {
    for n in 1..n + 1 {
        fizzbuzz(n);
    }
}
```
