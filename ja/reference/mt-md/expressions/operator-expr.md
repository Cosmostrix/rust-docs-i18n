# <!--Operator expressions--> 演算子式

> <!--**<sup>Syntax</sup>** \  _OperatorExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _OperatorExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[_BorrowExpression_] \ &nbsp;&nbsp;-->
> [_BorrowExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_DereferenceExpression_] \ &nbsp;&nbsp;-->
> [_DereferenceExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_ErrorPropagationExpression_] \ &nbsp;&nbsp;-->
> [_ErrorPropagationExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_NegationExpression_] \ &nbsp;&nbsp;-->
> [_NegationExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_ArithmeticOrLogicalExpression_] \ &nbsp;&nbsp;-->
> [_ArithmeticOrLogicalExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_ComparisonExpression_] \ &nbsp;&nbsp;-->
> [_ComparisonExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_LazyBooleanExpression_] \ &nbsp;&nbsp;-->
> [_LazyBooleanExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_TypeCastExpression_] \ &nbsp;&nbsp;-->
> [_TypeCastExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_AssignmentExpression_] \ &nbsp;&nbsp;-->
> [_AssignmentExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> [_CompoundAssignmentExpression_]

<!--Operators are defined for built in types by the Rust language.-->
演算子は、Rust言語によって組み込み型に対して定義されています。
<!--Many of the following operators can also be overloaded using traits in `std::ops` or `std::cmp`.-->
次の演算子の多くは、`std::ops`または`std::cmp`特性を使用してオーバーロードすることもできます。

## <!--Overflow--> オーバーフロー

<!--Integer operators will panic when they overflow when compiled in debug mode.-->
整数演算子は、デバッグモードでコンパイルされたときにオーバーフローするとパニックに陥ります。
<!--The `-C debug-assertions` and `-C overflow-checks` compiler flags can be used to control this more directly.-->
`-C debug-assertions`と`-C overflow-checks`コンパイラフラグを使用すると、これをより直接的に制御することができます。
<!--The following things are considered to be overflow:-->
オーバーフローとみなされるものは次のとおりです。

* <!--When `+`, `*` or `-` create a value greater than the maximum value, or less than the minimum value that can be stored.-->
   `+`、 `*`または`-`が最大値より大きい値、または保存可能な最小値より小さい値を作成する場合。
<!--This includes unary `-` on the smallest value of any signed integer type.-->
   これは単項含ま`-`任意の符号付き整数型の最小値。
* <!--Using `/` or `%`, where the left-hand argument is the smallest integer of a signed integer type and the right-hand argument is `-1`.-->
   `/`または`%`を使用します。ここで、左辺の引数は符号付き整数型の最小の整数で、右辺の引数は`-1`です。
* <!--Using `<<` or `>>` where the right-hand argument is greater than or equal to the number of bits in the type of the left-hand argument, or is negative.-->
   右側の引数が左側の引数の型のビット数以上である場合は`<<`または`>>`を使用するか、または負の数です。

## <!--Borrow operators--> オペレータを借りる

> <!--**<sup>Syntax</sup>** \  _BorrowExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _BorrowExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--(`&` | `&&`) [_Expression_] \ &nbsp;&nbsp;-->
> （`&` | `&&`） [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--(`&` | `&&`) `mut` [_Expression_]-->
> （`&` | `&&`） `mut` [_Expression_]

<!--The `&` (shared borrow) and `&mut` (mutable borrow) operators are unary prefix operators.-->
`&`（共有ボロー）と`&mut`（可変ボロー）演算子は単項接頭演算子です。
<!--When applied to a [place expression], this expressions produces a reference (pointer) to the location that the value refers to.-->
[place expression]適用すると、この式は、値が参照する場所への参照（ポインター）を生成します。
<!--The memory location is also placed into a borrowed state for the duration of the reference.-->
メモリの場所は、参照の期間、借用された状態に置かれます。
<!--For a shared borrow (`&`), this implies that the place may not be mutated, but it may be read or shared again.-->
共有の借用（`&`）の場合、これは場所が変更されていない可能性があることを意味しますが、再度読み取るか共有することができます。
<!--For a mutable borrow (`&mut`), the place may not be accessed in any way until the borrow expires.-->
変更可能な借用（`&mut`）では、借用期限が切れるまでは、その場所にアクセスすることはできません。
<!--`&mut` evaluates its operand in a mutable place expression context.-->
`&mut`は、変更可能なプレースの式コンテキストでそのオペランドを評価します。
<!--If the `&` or `&mut` operators are applied to a [value expression], then a [temporary value] is created.-->
`&`および`&mut`演算子が[value expression]適用されると、[temporary value]が作成されます。

<!--These operators cannot be overloaded.-->
これらの演算子はオーバーロードできません。

```rust
{
#    // a temporary with value 7 is created that lasts for this scope.
    // このスコープのために持続する値7の一時的なものが作成されます。
    let shared_reference = &7;
}
let mut array = [-2, 3, 9];
{
#    // Mutably borrows `array` for this scope.
#    // `array` may only be used through `mutable_reference`.
    // このスコープのために`array`を借りる。`array`は`mutable_reference`によってのみ使用でき`mutable_reference`。
    let mutable_reference = &mut array;
}
```

<!--Even though `&&` is a single token ([the lazy 'and' operator](#lazy-boolean-operators)), when used in the context of borrow expressions it works as two borrows:-->
`&&`は単一のトークン（[怠惰な 'と'演算子](#lazy-boolean-operators)）ですが、借用式のコンテキストで使用すると、2つの借用として機能します。

```rust
#// same meanings:
// 同じ意味：
let a = &&  10;
let a = & & 10;

#// same meanings:
// 同じ意味：
let a = &&&&  mut 10;
let a = && && mut 10;
let a = & & & & mut 10;
```

## <!--The dereference operator--> 逆参照演算子

> <!--**<sup>Syntax</sup>** \  _DereferenceExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _DereferenceExpression_ ：\＆nbsp;＆nbsp;
> <!--`*` [_Expression_]-->
> `*` [_Expression_]

<!--The `*` (dereference) operator is also a unary prefix operator.-->
`*`（逆参照）演算子も単項接頭演算子です。
<!--When applied to a [pointer](types.html#pointer-types) it denotes the pointed-to location.-->
[pointer](types.html#pointer-types)に適用すると、[pointer](types.html#pointer-types)された位置を示します。
<!--If the expression is of type `&mut T` and `*mut T`, and is either a local variable, a (nested) field of a local variable or is a mutable [place expression], then the resulting memory location can be assigned to.-->
式が`&mut T`型および`*mut T`型で、ローカル変数、ローカル変数の（ネストされた）フィールド、または変更可能な[place expression]いずれかである場合、結果のメモリ位置を割り当てることができます。
<!--Dereferencing a raw pointer requires `unsafe`.-->
未処理のポインタを参照解除するには、`unsafe`が必要です。

<!--On non-pointer types `*x` is equivalent to `*std::ops::Deref::deref(&x)` in an [immutable place expression context](expressions.html#mutability) and `*std::ops::Deref::deref_mut(&mut x)` in a mutable place expression context.-->
非ポインタ型では、`*x`は[不変の場所の式コンテキスト](expressions.html#mutability)では`*std::ops::Deref::deref_mut(&mut x)` `*std::ops::Deref::deref(&x)`に相当し、可変の場所では`*std::ops::Deref::deref_mut(&mut x)`表現コンテキスト。

```rust
let x = &7;
assert_eq!(*x, 7);
let y = &mut 9;
*y = 11;
assert_eq!(*y, 11);
```

## <!--The question mark operator--> 疑問符演算子

> <!--**<sup>Syntax</sup>** \  _ErrorPropagationExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _ErrorPropagationExpression_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] `?`-->
> [_Expression_] `?`

<!--The question mark operator (`?`) unwraps valid values or returns erroneous values, propagating them to the calling function.-->
疑問符演算子（`?`）は、有効な値をアンラップしたり、誤った値を返して呼び出し元の関数に伝播します。
<!--It is a unary postfix operator that can only be applied to the types `Result<T, E>` and `Option<T>`.-->
`Result<T, E>`および`Option<T>`の型にしか適用できない単項の後置演算子です。

<!--When applied to values of the `Result<T, E>` type, it propagates errors.-->
`Result<T, E>`型の値に適用すると、エラーを伝播します。
<!--If the value is `Err(e)`, then it will return `Err(From::from(e))` from the enclosing function or closure.-->
値が`Err(e)`場合、囲み関数またはクロージャ`Err(From::from(e))`が返されます。
<!--If applied to `Ok(x)`, then it will unwrap the value to evaluate to `x`.-->
`Ok(x)`適用すると、`x`に評価する値をラップ解除します。

```rust
# use std::num::ParseIntError;
fn try_to_parse() -> Result<i32, ParseIntError> {
#//    let x: i32 = "123".parse()?; // x = 123
    let x: i32 = "123".parse()?; //  x = 123
#//    let y: i32 = "24a".parse()?; // returns an Err() immediately
    let y: i32 = "24a".parse()?; // すぐにErr（）を返します。
#//    Ok(x + y)                    // Doesn't run.
    Ok(x + y)                    // 実行されません。
}

let res = try_to_parse();
println!("{:?}", res);
# assert!(res.is_err())
```

<!--When applied to values of the `Option<T>` type, it propagates `Nones`.-->
`Option<T>`型の値に適用すると、`Nones`伝播します。
<!--If the value is `None`, then it will return `None`.-->
値がされていない場合は`None`、それは返されません`None`。
<!--If applied to `Some(x)`, then it will unwrap the value to evaluate to `x`.-->
`Some(x)`適用すると、`x`に評価する値をラップ解除します。

```rust
fn try_option_some() -> Option<u8> {
    let val = Some(1)?;
    Some(val)
}
assert_eq!(try_option_some(), Some(1));

fn try_option_none() -> Option<u8> {
    let val = None?;
    Some(val)
}
assert_eq!(try_option_none(), None);
```

`?` <!--cannot be overloaded.-->
過負荷にすることはできません。

## <!--Negation operators--> 否定演算子

> <!--**<sup>Syntax</sup>** \  _NegationExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _NegationExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`-` [_Expression_] \ &nbsp;&nbsp;-->
> `-` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`!` [_Expression_]-->
> `!` [_Expression_]

<!--These are the last two unary operators.-->
これらは最後の2つの単項演算子です。
<!--This table summarizes the behavior of them on primitive types and which traits are used to overload these operators for other types.-->
この表は、プリミティブ型に対するそれらの振る舞いと、これらの演算子を他の型にオーバーロードするために使用される特性をまとめたものです。
<!--Remember that signed integers are always represented using two's complement.-->
符号付き整数は常に2の補数を使用して表されることに注意してください。
<!--The operands of all of these operators are evaluated in [value expression context][value%20expression] so are moved or copied.-->
これらの演算子のオペランドはすべて[値式コンテキストで][value%20expression]評価され、移動またはコピーされます。

|<!--Symbol-->シンボル|<!--Integer-->整数|`bool`|<!--Floating Point-->浮動小数点|<!--Overloading Trait-->特性のオーバーロード|
|<!------------>--------|<!----------------->-------------|<!----------------->-------------|<!-------------------->----------------|<!------------------------>--------------------|
|`-`|<!--Negation*-->否定*| |<!--Negation-->否定|`std::ops::Neg`|
|`!`|<!--Bitwise NOT-->ビット単位NOT|<!--Logical NOT-->論理NOT| |`std::ops::Not`|

<!--\* Only for signed integer types.-->
\ *符号付き整数型のみです。

<!--Here are some example of these operators-->
これらの演算子の例をいくつか示します

```rust
let x = 6;
assert_eq!(-x, -6);
assert_eq!(!x, -7);
assert_eq!(true, !false);
```

## <!--Arithmetic and Logical Binary Operators--> 算術および論理2項演算子

> <!--**<sup>Syntax</sup>** \  _ArithmeticOrLogicalExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _ArithmeticOrLogicalExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[_Expression_] `+` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `+` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `-` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `-` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `*` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `*` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `/` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `/` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `%` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `%` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `&` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `&` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `|`-->
> [_Expression_] `|`
> <!--[_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `^` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `^` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `<<` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `<<` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `>>` [_Expression_]-->
> [_Expression_] `>>` [_Expression_]

<!--Binary operators expressions are all written with infix notation.-->
バイナリ演算子の式はすべて、中置記法で書かれています。
<!--This table summarizes the behavior of arithmetic and logical binary operators on primitive types and which traits are used to overload these operators for other types.-->
この表は、プリミティブ型の算術および論理2項演算子の動作と、これらの演算子を他の型にオーバーロードするために使用される特性をまとめたものです。
<!--Remember that signed integers are always represented using two's complement.-->
符号付き整数は常に2の補数を使用して表されることに注意してください。
<!--The operands of all of these operators are evaluated in [value expression context][value%20expression] so are moved or copied.-->
これらの演算子のオペランドはすべて[値式コンテキストで][value%20expression]評価され、移動またはコピーされます。

|<!--Symbol-->シンボル|<!--Integer-->整数|`bool`|<!--Floating Point-->浮動小数点|<!--Overloading Trait-->特性のオーバーロード|
|<!------------>--------|<!----------------------------->-------------------------|<!----------------->-------------|<!-------------------->----------------|<!------------------------>--------------------|
|`+`|<!--Addition-->添加| |<!--Addition-->添加|`std::ops::Add`|
|`-`|<!--Subtraction-->減算| |<!--Subtraction-->減算|`std::ops::Sub`|
|`*`|<!--Multiplication-->乗算| |<!--Multiplication-->乗算|`std::ops::Mul`|
|`/`|<!--Division*-->分割*| |<!--Division-->分割|`std::ops::Div`|
|`%`|<!--Remainder-->残り| |<!--Remainder-->残り|`std::ops::Rem`|
|`&`|<!--Bitwise AND-->ビット単位AND|<!--Logical AND-->論理AND| |`std::ops::BitAnd`|
|`&#124;`|<!--Bitwise OR-->ビット単位OR|<!--Logical OR-->論理OR| |`std::ops::BitOr`|
|`^`|<!--Bitwise XOR-->ビット単位XOR|<!--Logical XOR-->論理XOR| |`std::ops::BitXor`|
|`<<`|<!--Left Shift-->左方移動| | |`std::ops::Shl`|
|`>>`|<!--Right Shift**-->右シフト**| | |`std::ops::Shr`|

<!--\* Integer division rounds towards zero.-->
\ *整数除算は0に丸めます。

<!--\ *\* Arithmetic right shift on signed integer types, logical right shift on unsigned integer types.-->
\ *\*符号付き整数型の算術右シフト、符号なし整数型の論理右シフト。

<!--Here are examples of these operators being used.-->
使用されているこれらの演算子の例を次に示します。

```rust
assert_eq!(3 + 6, 9);
assert_eq!(5.5 - 1.25, 4.25);
assert_eq!(-5 * 14, -70);
assert_eq!(14 / 3, 4);
assert_eq!(100 % 7, 2);
assert_eq!(0b1010 & 0b1100, 0b1000);
assert_eq!(0b1010 | 0b1100, 0b1110);
assert_eq!(0b1010 ^ 0b1100, 0b110);
assert_eq!(13 << 3, 104);
assert_eq!(-10 >> 2, -3);
```

## <!--Comparison Operators--> 比較演算子

> <!--**<sup>Syntax</sup>** \  _ComparisonExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _ComparisonExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[_Expression_] `==` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `==` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `!=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `!=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `>` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `>` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `<` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `<` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `>=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `>=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `<=` [_Expression_]-->
> [_Expression_] `<=` [_Expression_]

<!--Comparison operators are also defined both for primitive types and many type in the standard library.-->
比較演算子は、プリミティブ型と標準ライブラリの多くの型の両方にも定義されています。
<!--Parentheses are required when chaining comparison operators.-->
比較演算子を連結するときにはかっこが必要です。
<!--For example, the expression `a == b == c` is invalid and may be written as `(a == b) == c`.-->
たとえば、`a == b == c`という式は無効で、`(a == b) == c`と書くことができます。

<!--Unlike arithmetic and logical operators, the traits for overloading the operators the traits for these operators are used more generally to show how a type may be compared and will likely be assumed to define actual comparisons by functions that use these traits as bounds.-->
算術演算子と論理演算子とは異なり、演算子にこれらの演算子の特性をオーバーロードする特性は、より一般的には型の比較方法を示すために使用され、これらの特性を境界として使用する関数による実際の比較を定義すると見なされます。
<!--Many functions and macros in the standard library can then use that assumption (although not to ensure safety).-->
標準ライブラリの多くの関数とマクロは、その前提を使用できます（ただし、安全性は保証されません）。
<!--Unlike the arithmetic and logical operators above, these operators implicitly take shared borrows of their operands, evaluating them in [place expression context][place%20expression]:-->
上記の算術演算子および論理演算子とは異なり、これらの演算子は、暗黙的に、オペランドの共有を取り、[場所式コンテキスト][place%20expression]で評価し[ます][place%20expression]。

```rust,ignore
a == b;
#// is equivalent to
// は
::std::cmp::PartialEq::eq(&a, &b);
```

<!--This means that the operands don't have to be moved out of.-->
これは、オペランドを移動させる必要がないことを意味します。

|<!--Symbol-->シンボル|<!--Meaning-->意味|<!--Overloading method-->オーバーロードメソッド|
|<!------------>--------|<!------------------------------>--------------------------|<!-------------------------------->----------------------------|
|`==`|<!--Equal-->等しい|`std::cmp::PartialEq::eq`|
|`!=`|<!--Not equal-->等しくない|`std::cmp::PartialEq::ne`|
|`>`|<!--Greater than-->より大きい|`std::cmp::PartialOrd::gt`|
|`<`|<!--Less than-->未満|`std::cmp::PartialOrd::lt`|
|`>=`|<!--Greater than or equal to-->以上|`std::cmp::PartialOrd::ge`|
|`<=`|<!--Less than or equal to-->以下|`std::cmp::PartialOrd::le`|

<!--Here are examples of the comparison operators being used.-->
使用されている比較演算子の例を次に示します。

```rust
assert!(123 == 123);
assert!(23 != -12);
assert!(12.5 > 12.2);
assert!([1, 2, 3] < [1, 3, 4]);
assert!('A' <= 'B');
assert!("World" >= "Hello");
```

## <!--Lazy boolean operators--> レイジーブール演算子

> <!--**<sup>Syntax</sup>** \  _LazyBooleanExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _LazyBooleanExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[_Expression_] `||`-->
> [_Expression_] `||`
> <!--[_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `&&` [_Expression_]-->
> [_Expression_] `&&` [_Expression_]

<!--The operators `||`-->
演算子`||`
<!--and `&&` may be applied to operands of boolean type.-->
`&&`はブール型のオペランドに適用できます。
<!--The `||`-->
`||`
<!--operator denotes logical 'or', and the `&&` operator denotes logical 'and'.-->
演算子は論理 'または'を示し、`&&`演算子は論理 'および'を示します。
<!--They differ from `|`-->
彼らは`|`
<!--and `&` in that the right-hand operand is only evaluated when the left-hand operand does not already determine the result of the expression.-->
そして`&`左側のオペランドがすでに式の結果を決定しないときに右側のオペランドは評価されます。
<!--That is, `||`-->
つまり、`||`
<!--only evaluates its right-hand operand when the left-hand operand evaluates to `false`, and `&&` only when it evaluates to `true`.-->
左辺オペランドが`false`と評価されたときは右オペランドのみを評価し、`true`と評価した場合は`&&`評価し`true`。

```rust
#//let x = false || true; // true
let x = false || true; // 真実
#//let y = false && panic!(); // false, doesn't evaluate `panic!()`
let y = false && panic!(); //  false、`panic!()`評価しない`panic!()`
```

## <!--Type cast expressions--> 型キャスト式

> <!--**<sup>Syntax</sup>** \  _TypeCastExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _TypeCastExpression_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] `as` [_PathInExpression_]-->
> [_Expression_] `as` [_PathInExpression_]

<!--A type cast expression is denoted with the binary operator `as`.-->
型キャスト式は、`as` 2項演算子で示さ`as`ます。

<!--Executing an `as` expression casts the value on the left-hand side to the type on the right-hand side.-->
`as`式を実行する`as`、左側の値が右側の型にキャストされます。

<!--An example of an `as` expression:-->
`as`式の例：

```rust
# fn sum(values: &[f64]) -> f64 { 0.0 }
# fn len(values: &[f64]) -> i32 { 0 }
fn average(values: &[f64]) -> f64 {
    let sum: f64 = sum(values);
    let size: f64 = len(values) as f64;
    sum / size
}
```

<!--`as` can be used to explicitly perform [coercions](type-coercions.html), as well as the following additional casts.-->
明示的に実行するために使用することができ[coercions](type-coercions.html)と同様に、次の追加キャストを。
<!--Here `*T` means either `*const T` or `*mut T`.-->
ここで、`*T`は`*const T`または`*mut T`いずれかを意味します。

|<!--Type of `e`-->`e`種類|`U`|<!--Cast performed by `e as U`-->`e as U`行われたキャスト|
|<!--------------------------->-----------------------|<!--------------------------->-----------------------|<!-------------------------------------->----------------------------------|
|<!--Integer or Float type-->整数型または浮動小数点型|<!--Integer or Float type-->整数型または浮動小数点型|<!--Numeric cast-->数値キャスト|
|<!--C-like enum-->Cのような列挙型|<!--Integer type-->整数型|<!--Enum cast-->列挙型キャスト|
|<!--`bool` or `char`-->`bool`または`char`|<!--Integer type-->整数型|<!--Primitive to integer cast-->整数型へのプリミティブ|
|`u8`|`char`|<!--`u8` to `char` cast-->`char`キャストに`u8`|
|`*T`|<!--`*V` where `V: Sized` \*-->`*V`ここで`V: Sized` \ *|<!--Pointer to pointer cast-->ポインタキャストへのポインタ|
|<!--`*T` where `T: Sized`-->`*T`ここで、`T: Sized`|<!--Numeric type-->数値型|<!--Pointer to address cast-->アドレスキャストへのポインタ|
|<!--Integer type-->整数型|<!--`*V` where `V: Sized`-->`*V`ここで、`V: Sized`|<!--Address to pointer cast-->ポインタキャストアドレス|
|`&[T; n]`|`*const T`|<!--Array to pointer cast-->ポインタをキャストする配列|
|<!--[Function pointer](types.html#function-pointer-types)-->[関数ポインタ](types.html#function-pointer-types)|<!--`*V` where `V: Sized`-->`*V`ここで、`V: Sized`|<!--Function pointer to pointer cast-->ポインターキャストへの関数ポインター|
|<!--Function pointer-->関数ポインタ|<!--Integer-->整数|<!--Function pointer to address cast-->アドレスキャストへの関数ポインタ|
|<!--Closure \ *\*-->Closure \ *\*|<!--Function pointer-->関数ポインタ|<!--Closure to function pointer cast-->関数のポインタキャストへのクロージャ|

<!--\* or `T` and `V` are compatible unsized types, eg, both slices, both the same trait object.-->
\ *または`T`と`V`は互換性のあるサイズ指定されていない型です。例えば両方のスライスが同じtraitオブジェクトです。

<!--\ *\* only for closures that do capture (close over) any local variables-->
ローカル変数をキャプチャする（クローズする）クロージャの場合にのみ\ *\*

### <!--Semantics--> セマンティクス

* <!--Numeric cast-->
   数値キャスト
    * <!--Casting between two integers of the same size (eg i32 -> u32) is a no-op-->
       同じサイズの2つの整数間のキャスト（例：i32 -> u32）はノーオペレーションです
    * <!--Casting from a larger integer to a smaller integer (eg u32 -> u8) will truncate-->
       大きな整数から小さな整数（例えば、u32 -> u8）へのキャスティングは、切り詰められます
    * <!--Casting from a smaller integer to a larger integer (eg u8 -> u32) will-->
       小さな整数から大きな整数へのキャスト（例：u8 -> u32）
        * <!--zero-extend if the source is unsigned-->
           ソースが符号なしの場合はゼロ拡張
        * <!--sign-extend if the source is signed-->
           ソースが署名されている場合は符号拡張する
    * <!--Casting from a float to an integer will round the float towards zero-->
       浮動小数点から整数へのキャストは浮動小数点をゼロに向かって丸めます
        * <!--**[NOTE: currently this will cause Undefined Behavior if the rounded value cannot be represented by the target integer type][float-int]**.-->
           **[注記：現在、丸められた値をターゲット整数型で表現できない場合、未定義の振る舞いが発生します] [float-int]**。
<!--This includes Inf and NaN.-->
           これには、InfとNaNが含まれます。
<!--This is a bug and will be fixed.-->
           これはバグであり修正される予定です。
    * <!--Casting from an integer to float will produce the floating point representation of the integer, rounded if necessary (rounding strategy unspecified)-->
       整数から浮動小数点へのキャストは、必要に応じて丸められた整数の浮動小数点表現を生成します（丸め戦略は指定されていません）
    * <!--Casting from an f32 to an f64 is perfect and lossless-->
       f32からf64へのキャストは完璧でロスレスです
    * <!--Casting from an f64 to an f32 will produce the closest possible value (rounding strategy unspecified)-->
       f64からf32へのキャストは、可能な限り近い値を生成します（丸め戦略は指定されていません）
        * <!--**[NOTE: currently this will cause Undefined Behavior if the value is finite but larger or smaller than the largest or smallest finite value representable by f32][float-float]**.-->
           **[注記：現在、値が有限であるが、f32で表現可能な最大または最小の有限値より大きいまたは小さい場合は、未定義動作が発生します**。 **[float-float]**
<!--This is a bug and will be fixed.-->
           これはバグであり修正される予定です。
* <!--Enum cast-->
   列挙型キャスト
    * <!--Casts an enum to its discriminant, then uses a numeric cast if needed.-->
       enumを判別式に変換し、必要に応じて数値キャストを使います。
* <!--Primitive to integer cast-->
   整数型へのプリミティブ
    * <!--`false` casts to `0`, `true` casts to `1`-->
       `false`キャストを`0`、 `true`キャストを`1`
    * <!--`char` casts to the value of the code point, then uses a numeric cast if needed.-->
       `char`はコードポイントの値にキャストし、必要に応じて数値キャストを使用します。
* <!--`u8` to `char` cast-->
   `char`キャストに`u8`
    * <!--Casts to the `char` with the corresponding code point.-->
       対応するコードポイントで`char`キャストします。

<!--[float-int]: https://github.com/rust-lang/rust/issues/10184
 [float-float]: https://github.com/rust-lang/rust/issues/15536
-->
[float-int]: https://github.com/rust-lang/rust/issues/10184
 [float-float]: https://github.com/rust-lang/rust/issues/15536


## <!--Assignment expressions--> 代入式

> <!--**<sup>Syntax</sup>** \  _AssignmentExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _AssignmentExpression_ ：\＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `=` [_Expression_]-->
> [_Expression_] `=` [_Expression_]

<!--An  _assignment expression_  consists of a [place expression] followed by an equals sign (`=`) and a [value expression].-->
 _代入式_ は、等号（`=`）と[value expression]あとに続く[place expression]  _式で_ 構成され[value expression]。
<!--Such an expression always has the [`unit` type].-->
このような式は常に[`unit` type]です。

<!--Evaluating an assignment expression [drops](destructors.html) the left-hand operand, unless it's an uninitialized local variable or field of a local variable, and [either copies or moves](expressions.html#moved-and-copied-types) its right-hand operand to its left-hand operand.-->
代入式を評価すると、未初期化のローカル変数またはローカル変数のフィールドでない限り、左側のオペランドが[drops](destructors.html)、右側のオペランドが[コピーされるか](expressions.html#moved-and-copied-types)、左側のオペランドに[移動され](expressions.html#moved-and-copied-types)ます。
<!--The left-hand operand must be a place expression: using a value expression results in a compiler error, rather than promoting it to a temporary.-->
左側のオペランドはプレース・エクスプレッションでなければなりません。値式を使用すると、一時的にプロモートするのではなく、コンパイラー・エラーが発生します。

```rust
# let mut x = 0;
# let y = 0;
x = y;
```

## <!--Compound assignment expressions--> 複合代入式

> <!--**<sup>Syntax</sup>** \  _CompoundAssignmentExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _CompoundAssignmentExpression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[_Expression_] `+=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `+=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `-=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `-=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `*=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `*=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `/=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `/=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `%=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `%=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `&=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `&=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `|=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `|=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `^=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `^=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `<<=` [_Expression_] \ &nbsp;&nbsp;-->
> [_Expression_] `<<=` [_Expression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_Expression_] `>>=` [_Expression_]-->
> [_Expression_] `>>=` [_Expression_]

<!--The `+`, `-`, `*`, `/`, `%`, `&`, `|`-->
`+`、 `-`、 `*`、 `/`、 `%`、 `&`、 `|`
<!--, `^`, `<<`, and `>>` operators may be composed with the `=` operator.-->
、`^`、 `<<`、および`>>`演算子は、`=`演算子で構成できます。
<!--The expression `place_exp OP= value` is equivalent to `place_expr = place_expr OP val`.-->
式`place_exp OP= value`は、`place_expr = place_expr OP val`と等価です。
<!--For example, `x = x + 1` may be written as `x += 1`.-->
例えば、`x = x + 1`は`x += 1`と書くことができる。
<!--Any such expression always has the [`unit` type].-->
そのような式は常に[`unit` type]持ちます。
<!--These operators can all be overloaded using the trait with the same name as for the normal operation followed by 'Assign', for example, `std::ops::AddAssign` is used to overload `+=`.-->
これらの演算子はすべて、通常の操作と同じ名前の特性を使用してオーバーロードすることができます。たとえば、`std::ops::AddAssign`は`+=`をオーバーロードするために使用されます。
<!--As with `=`, `place_expr` must be a [place expression].-->
同様に`=`、 `place_expr`でなければならない[place expression]。

```rust
let mut x = 10;
x += 4;
assert_eq!(x, 14);
```

<!--[place expression]: expressions.html#place-expressions-and-value-expressions
 [value expression]: expressions.html#place-expressions-and-value-expressions
 [temporary value]: expressions.html#temporary-lifetimes
 [float-int]: https://github.com/rust-lang/rust/issues/10184
 [float-float]: https://github.com/rust-lang/rust/issues/15536
 [`unit` type]: types.html#tuple-types
-->
[place expression]: expressions.html#place-expressions-and-value-expressions
 [value expression]: expressions.html#place-expressions-and-value-expressions
 [temporary value]: expressions.html#temporary-lifetimes
 [float-int]: https://github.com/rust-lang/rust/issues/10184
 [float-float]: https://github.com/rust-lang/rust/issues/15536
 [`unit` type]: types.html#tuple-types


<!--[_BorrowExpression_]: #borrow-operators
 [_DereferenceExpression_]: #the-dereference-operator
 [_ErrorPropagationExpression_]: #the-question-mark-operator
 [_NegationExpression_]: #negation-operators
 [_ArithmeticOrLogicalExpression_]: #arithmetic-and-logical-binary-operators
 [_ComparisonExpression_]: #comparison-operators
 [_LazyBooleanExpression_]: #lazy-boolean-operators
 [_TypeCastExpression_]: #type-cast-expressions
 [_AssignmentExpression_]: #assignment-expressions
 [_CompoundAssignmentExpression_]: #compound-assignment-expressions
-->
[_BorrowExpression_]: #borrow-operators
 [_DereferenceExpression_]: #the-dereference-operator
 [_ErrorPropagationExpression_]: #the-question-mark-operator
 [_NegationExpression_]: #negation-operators
 [_ArithmeticOrLogicalExpression_]: #arithmetic-and-logical-binary-operators
 [_ComparisonExpression_]: #comparison-operators
 [_LazyBooleanExpression_]: #lazy-boolean-operators
 [_TypeCastExpression_]: #type-cast-expressions
 [_AssignmentExpression_]: #assignment-expressions
 [_CompoundAssignmentExpression_]: #compound-assignment-expressions


<!--[_Expression_]: expressions.html
 [_PathInExpression_]: paths.html
-->
[_Expression_]: expressions.html
 [_PathInExpression_]: paths.html

