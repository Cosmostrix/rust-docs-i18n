# <!--Static--> 静的

<!--A `'static` lifetime is the longest possible lifetime, and lasts for the lifetime of the running program.-->
`'static`寿命は、可能な最長寿命であり、実行中のプログラムの存続期間中存続する。
<!--A `'static` lifetime may also be coerced to a shorter lifetime.-->
`'static`寿命は、より短い寿命に強制されることもあります。
<!--There are two ways to make a variable with `'static` lifetime, and both are stored in the read-only memory of the binary:-->
`'static`寿命で変数を作成するには2通りの方法があり、どちらもバイナリの読み取り専用メモリに格納されています。

* <!--Make a constant with the `static` declaration.-->
   `static`宣言で定数を作る。
* <!--Make a `string` literal which has type: `&'static str`.-->
   `&'static str`。型を持つ`string`リテラルを作成し`&'static str`。

<!--See the following example for a display of each method:-->
各メソッドの表示については、次の例を参照してください。

```rust,editable
#// Make a constant with `'static` lifetime.
//  `'static`寿命で一定にする。
static NUM: i32 = 18;

#// Returns a reference to `NUM` where its `'static` 
#// lifetime is coerced to that of the input argument.
// その`'static`寿命が入力引数`'static`寿命に強制される`NUM`への参照を返します。
fn coerce_static<'a>(_: &'a i32) -> &'a i32 {
    &NUM
}

fn main() {
    {
#        // Make a `string` literal and print it:
        //  `string`リテラルを作り、それを印刷する：
        let static_string = "I'm in read-only memory";
        println!("static_string: {}", static_string);

#        // When `static_string` goes out of scope, the reference
#        // can no longer be used, but the data remains in the binary.
        //  `static_string`が有効範囲外になると、参照は使用できなくなりますが、データはバイナリに残ります。
    }
    
    {
#        // Make an integer to use for `coerce_static`:
        //  `coerce_static`に使う整数を作る：
        let lifetime_num = 9;

#        // Coerce `NUM` to lifetime of `lifetime_num`:
        //  `NUM`をlifetime_numの`lifetime_num`強制する：
        let coerced_static = coerce_static(&lifetime_num);

        println!("coerced_static: {}", coerced_static);
    }
    
    println!("NUM: {} stays accessible!", NUM);
}
```

### <!--See also:--> 参照：

<!--[`'static` constants][static_const]-->
[`'static`定数][static_const]

[static_const]: custom_types/constants.html
