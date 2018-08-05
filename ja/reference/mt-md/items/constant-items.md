# <!--Constant items--> 定数項目

> <!--**<sup>Syntax</sup>**  _ConstantItem_ : &nbsp;&nbsp;-->
> **<sup>構文</ sup>**  _ConstantItem_ ：＆nbsp;＆nbsp;
> <!--`const` [IDENTIFIER] `:` [_Type_] `=` [_Expression_] `;`-->
> `const` [IDENTIFIER] `:` [_Type_] `=` [_Expression_] `;`

<!--A *constant item* is a named  _[constant value]_  which is not associated with a specific memory location in the program.-->
*定数項目*は、プログラム内の特定のメモリ位置に関連付けられていない名前付き _[定数値]_ です。
<!--Constants are essentially inlined wherever they are used, meaning that they are copied directly into the relevant context when used.-->
定数は、どこで使用されていても基本的にインライン展開されています。つまり、使用すると関連するコンテキストに直接コピーされます。
<!--References to the same constant are not necessarily guaranteed to refer to the same memory address.-->
同じ定数への参照は、必ずしも同じメモリアドレスを参照するとは限りません。

<!--Constants must be explicitly typed.-->
定数は明示的に型指定する必要があります。
<!--The type must have a `'static` lifetime: any references it contains must have `'static` lifetimes.-->
タイプには`'static`寿命が必要です。それに含まれる参照には`'static`寿命が必要です。

<!--Constants may refer to the address of other constants, in which case the address will have elided lifetimes where applicable, otherwise – in most cases – defaulting to the `static` lifetime.-->
定数は、他の定数のアドレスを参照することができます。この場合、アドレスは適用可能な場合は寿命を失います。そうでない場合は、ほとんどの場合、`static`存続期間が省略されます。
<!--(See [static lifetime elision].) The compiler is, however, still at liberty to translate the constant many times, so the address referred to may not be stable.-->
（参照[static lifetime elision]。）コンパイラがある、しかし、まだ自由に定数を何度も変換するために、アドレスが安定しないことが言及するようにします。

```rust
const BIT1: u32 = 1 << 0;
const BIT2: u32 = 1 << 1;

const BITS: [u32; 2] = [BIT1, BIT2];
const STRING: &'static str = "bitstring";

struct BitsNStrings<'a> {
    mybits: [u32; 2],
    mystring: &'a str,
}

const BITS_N_STRINGS: BitsNStrings<'static> = BitsNStrings {
    mybits: BITS,
    mystring: STRING,
};
```

## <!--Constants with Destructors--> デストラクタを持つ定数

<!--Constants can contain destructors.-->
定数にはデストラクタを含めることができます。
<!--Destructors are run when the value goes out of scope.-->
デストラクタは、値が範囲外になると実行されます。

```rust
struct TypeWithDestructor(i32);

impl Drop for TypeWithDestructor {
    fn drop(&mut self) {
        println!("Dropped. Held {}.", self.0);
    }
}

const ZERO_WITH_DESTRUCTOR: TypeWithDestructor = TypeWithDestructor(0);

fn create_and_drop_zero_with_destructor() {
    let x = ZERO_WITH_DESTRUCTOR;
#    // x gets dropped at end of function, calling drop.
#    // prints "Dropped. Held 0.".
    //  xは関数の終わりにドロップされ、dropを呼び出します。「Dropped。Held 0.」を印刷します。
}
```

<!--[constant value]: expressions.html#constant-expressions
 [static lifetime elision]: lifetime-elision.html#static-lifetime-elision
 [`Drop`]: special-types-and-traits.html#drop
 [IDENTIFIER]: identifiers.html
 [_Type_]: types.html
 [_Expression_]: expressions.html
-->
[constant value]: expressions.html#constant-expressions
 [static lifetime elision]: lifetime-elision.html#static-lifetime-elision
 [`Drop`]: special-types-and-traits.html#drop
 [IDENTIFIER]: identifiers.html
 [_Type_]: types.html
 [_Expression_]: expressions.html

