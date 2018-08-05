# <!--Ownership and moves--> 所有権と移動

<!--Because variables are in charge of freeing their own resources, **resources can only have one owner**.-->
変数は独自のリソースを解放する役割を果たすため、**リソースには1人の所有者しか持てません**。
<!--This also prevents resources from being freed more than once.-->
これにより、リソースが複数回解放されることも防止されます。
<!--Note that not all variables own resources (eg [references]).-->
すべての変数がリソース（例えば、[references]）を所有しているわけではないことに注意してください。

<!--When doing assignments (`let x = y`) or passing function arguments by value (`foo(x)`), the *ownership* of the resources is transferred.-->
代入（`let x = y`）または関数引数を値（ `foo(x)`）で渡す`foo(x)`、リソースの*所有権*が転送されます。
<!--In Rust-speak, this is known as a *move*.-->
Rust-speakでは、これは*動き*として知られています。

<!--After moving resources, the previous owner can no longer be used.-->
リソースを移動した後、前の所有者は使用できなくなります。
<!--This avoids creating dangling pointers.-->
これにより、ぶら下がっているポインタの作成を回避します。

```rust,editable
#// This function takes ownership of the heap allocated memory
// この関数は、割り当てられたヒープメモリの所有権を取得します。
fn destroy_box(c: Box<i32>) {
    println!("Destroying a box that contains {}", c);

#    // `c` is destroyed and the memory freed
    //  `c`が破壊され、メモリが解放される
}

fn main() {
#    // _Stack_ allocated integer
    //   _スタック_ 割り当て整数
    let x = 5u32;

#    // *Copy* `x` into `y` - no resources are moved
    //  `x`を`y` *コピー*する -リソースは移動されない
    let y = x;

#    // Both values can be independently used
    // 両方の値を個別に使用することができます
    println!("x is {}, and y is {}", x, y);

#    // `a` is a pointer to a _heap_ allocated integer
    //  `a`は _ヒープに_ 割り当てられた整数へのポインタです
    let a = Box::new(5i32);

    println!("a contains: {}", a);

#    // *Move* `a` into `b`
    //  `a`を`b` *移動* `a`
    let b = a;
#    // The pointer address of `a` is copied (not the data) into `b`.
#    // Both are now pointers to the same heap allocated data, but
#    // `b` now owns it.
    //  `a`のポインタアドレスが`b`（データではなく）コピーされます。どちらも現在、同じヒープ割り当てデータへのポインタですが、`b`現在それを所有しています。
    
#    // Error! `a` can no longer access the data, because it no longer owns the
#    // heap memory
    // エラー！ `a`はもはやヒープメモリを所有していないため、データにアクセスできなくなります
    //println!("a contains: {}", a);
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる

#    // This function takes ownership of the heap allocated memory from `b`
    // この関数は、割り当てられたヒープの所有権を`b`
    destroy_box(b);

#    // Since the heap memory has been freed at this point, this action would
#    // result in dereferencing freed memory, but it's forbidden by the compiler
#    // Error! Same reason as the previous Error
    // ヒープメモリはこの時点で解放されているので、このアクションは解放されたメモリを逆参照することになりますが、コンパイラエラーによって禁止されています！以前のエラーと同じ理由
    //println!("b contains: {}", b);
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる
}
```

[references]: flow_control/match/destructuring/destructure_pointers.html
