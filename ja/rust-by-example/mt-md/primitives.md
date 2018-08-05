# <!--Primitives--> プリミティブ

<!--Rust provides access to a wide variety of `primitives`.-->
Rustは、さまざまな`primitives`へのアクセスを提供します。
<!--A sample includes:-->
サンプルに含まれるもの：


### <!--Scalar Types--> スカラ型

* <!--signed integers: `i8`, `i16`, `i32`, `i64`, `i128` and `isize` (pointer size)-->
   符号付き整数： `i8`、 `i16`、 `i32`、 `i64`、 `i128`、 `isize`（ポインタサイズ）
* <!--unsigned integers: `u8`, `u16`, `u32`, `u64`, `u128` and `usize` (pointer size)-->
   符号なし整数： `u8`、 `u16`、 `u32`、 `u64`、 `u128`および`usize`（ポインタサイズ）
* <!--floating point: `f32`, `f64`-->
   浮動小数点： `f32`、 `f64`
* <!--`char` Unicode scalar values like `'a'`, `'α'` and `'∞'` (4 bytes each)-->
   `char` `'a'`、 `'α'`、 `'∞'`など`'a'` Unicodeスカラー値（それぞれ4バイト）
* <!--`bool` either `true` or `false`-->
   `true`または`false`いずれかの`bool`
* <!--and the unit type `()`, whose only possible value is an empty tuple: `()`-->
   可能な値が空のタプルであるユニットタイプ`()`：（ `()`

<!--Despite the value of a unit type being a tuple, it is not considered a compound type because it does not contain multiple values.-->
タプルであるユニットタイプの値にもかかわらず、複数の値を含まないため、複合タイプとはみなされません。

### <!--Compound Types--> 化合物タイプ

* <!--arrays like `[1, 2, 3]`-->
   `[1, 2, 3]`ような配列は`[1, 2, 3]`
* <!--tuples like `(1, true)`-->
   タプルは`(1, true)`

<!--Variables can always be *type annotated*.-->
変数には常に*注釈を付ける*ことができます。
<!--Numbers may additionally be annotated via a *suffix* or *by default*.-->
数字には、さらに*接尾辞*または*デフォルト*で注釈を付けることができ*ます*。
<!--Integers default to `i32` and floats to `f64`.-->
整数のデフォルトは`i32`、浮動小数点数は`f64`ます。
<!--Note that Rust can also infer types from context.-->
Rustはコンテキストから型を推論することもできることに注意してください。

```rust,editable,ignore,mdbook-runnable
fn main() {
#    // Variables can be type annotated.
    // 変数に注釈を付けることができます。
    let logical: bool = true;

#//    let a_float: f64 = 1.0;  // Regular annotation
    let a_float: f64 = 1.0;  // 通常のアノテーション
#//    let an_integer   = 5i32; // Suffix annotation
    let an_integer   = 5i32; // 接尾辞注釈

#    // Or a default will be used.
    // または、デフォルトが使用されます。
#//    let default_float   = 3.0; // `f64`
    let default_float   = 3.0; // 
#//    let default_integer = 7;   // `i32`
    let default_integer = 7;   // 
    
#    // A type can also be inferred from context 
    // タイプは、文脈から推測することもできます
#//    let mut inferred_type = 12; // Type i64 is inferred from another line
    let mut inferred_type = 12; // タイプi64は別の行から推定されます
    inferred_type = 4294967296i64;
    
#    // A mutable variable's value can be changed.
    // 可変変数の値を変更することができます。
#//    let mut mutable = 12; // Mutable `i32`
    let mut mutable = 12; // 変更可能な`i32`
    mutable = 21;
    
#    // Error! The type of a variable can't be changed.
    // エラー！変数の型は変更できません。
    mutable = true;
    
#    // Variables can be overwritten with shadowing.
    // 変数はシャドーイングで上書きできます。
    let mutable = true;
}
```

### <!--See also:--> 参照：

<!--[the `std` library][std], [`mut`][mut], [inference], and [shadowing]-->
[`std`ライブラリ][std]、 [`mut`][mut]、 [inference]、 [shadowing]

<!--[std]: https://doc.rust-lang.org/std/
 [mut]: variable_bindings/mut.html
 [inference]: types/inference.html
 [shadowing]: variable_bindings/scope.html
-->
[std]: https://doc.rust-lang.org/std/
 [mut]: variable_bindings/mut.html
 [inference]: types/inference.html
 [shadowing]: variable_bindings/scope.html

