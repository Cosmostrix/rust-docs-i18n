# <!--Casting--> 鋳造

<!--Rust provides no implicit type conversion (coercion) between primitive types.-->
Rustは、プリミティブ型間の暗黙の型変換（強制）を提供しません。
<!--But, explicit type conversion (casting) can be performed using the `as` keyword.-->
ただし、明示的な型変換（キャスト）は、`as`キーワードを使用し`as`実行できます。

<!--Rules for converting between integral types follow C conventions generally, except in cases where C has undefined behavior.-->
整数型間の変換の規則は、Cが未定義の振る舞いを持つ場合を除いて、一般的にはCの規則に従います。
<!--The behavior of all casts between integral types is well defined in Rust.-->
整数型間のすべてのキャストの動作は、Rustでよく定義されています。

```rust,editable,ignore,mdbook-runnable
#// Suppress all warnings from casts which overflow.
// オーバーフローするキャストからのすべての警告を抑制する。
#![allow(overflowing_literals)]

fn main() {
    let decimal = 65.4321_f32;

#    // Error! No implicit conversion
    // エラー！暗黙の変換なし
    let integer: u8 = decimal;
#    // FIXME ^ Comment out this line
    //  FIXME ^この行をコメントアウトする

#    // Explicit conversion
    // 明示的な変換
    let integer = decimal as u8;
    let character = integer as char;

    println!("Casting: {} -> {} -> {}", decimal, integer, character);

#    // when casting any value to an unsigned type, T,
#    // std::T::MAX + 1 is added or subtracted until the value
#    // fits into the new type
    // 任意の値を符号なしの型Tにキャストすると、その値が新しい型に収まるまでstd:: T:: MAX + 1が加算または減算されます

#    // 1000 already fits in a u16
    //  1000はすでにu16に収まっています
    println!("1000 as a u16 is: {}", 1000 as u16);

#    // 1000 - 256 - 256 - 256 = 232
#    // Under the hood, the first 8 least significant bits (LSB) are kept,
#    // while the rest towards the most significant bit (MSB) get truncated.
    // （LSB）は保持され、最上位ビット（MSB）に向かう残りの部分は切り捨てられます。1000〜256 -256 -256 = 232
    println!("1000 as a u8 is : {}", 1000 as u8);
#    // -1 + 256 = 255
    //  -1 + 256 = 255
    println!("  -1 as a u8 is : {}", (-1i8) as u8);

#    // For positive numbers, this is the same as the modulus
    // 正の数の場合、これはモジュラスと同じです
    println!("1000 mod 256 is : {}", 1000 % 256);

#    // When casting to a signed type, the (bitwise) result is the same as
#    // first casting to the corresponding unsigned type. If the most significant
#    // bit of that value is 1, then the value is negative.
    // 符号付きの型にキャストするとき、（ビット単位の）結果は、最初に対応する符号なし型にキャストするときと同じになります。その値の最上位ビットが1の場合、値は負の値になります。

#    // Unless it already fits, of course.
    // すでに当てはまる場合を除きます。
    println!(" 128 as a i16 is: {}", 128 as i16);
#    // 128 as u8 -> 128, whose two's complement in eight bits is:
    //  128をu8 -> 128とすると、8ビットの2の補数は次のようになります。
    println!(" 128 as a i8 is : {}", 128 as i8);

#    // repeating the example above
#    // 1000 as u8 -> 232
    //  u8 -> 232として1000以上の例を繰り返す
    println!("1000 as a u8 is : {}", 1000 as u8);
#    // and the two's complement of 232 is -24
    //  232の2の補数は-24です
    println!(" 232 as a i8 is : {}", 232 as i8);
}
```
