# <!--Explicit annotation--> 明示的な注釈

<!--The borrow checker uses explicit lifetime annotations to determine how long references should be valid.-->
貸借チェッカーは、明示的な存続期間の注釈を使用して、参照の有効期間を判断します。
<!--In cases where lifetimes are not elided [^1], Rust requires explicit annotations to determine what the lifetime of a reference should be.-->
寿命が省略されていない場合には[^1]、錆は、参照の寿命がどうあるべきかを決定するために、明示的な注釈が必要です。
<!--The syntax for explicitly annotating a lifetime uses an apostrophe character as follows:-->
生涯に明示的に注釈を付けるための構文は、アポストロフィー文字を次のように使用します。

```rust,ignore
foo<'a>
#// `foo` has a lifetime parameter `'a`
//  `foo`には生涯パラメータ`'a`
```

<!--Similar to [closures][anonymity], using lifetimes requires generics.-->
[closures][anonymity]と同様に、生涯を使用するにはジェネリック医薬品が必要です。
<!--Additionally, this lifetime syntax indicates that the lifetime of `foo` may not exceed that of `'a`.-->
さらに、このライフタイム構文は、`foo`の存続期間が`'a`の存続期間を超えないことを示します。
<!--Explicit annotation of a type has the form `&'a T` where `'a` has already been introduced.-->
タイプの明示的な注釈の形式は`&'a T` `'a`既に導入されているが。

<!--In cases with multiple lifetimes, the syntax is similar:-->
複数の生存期間がある場合、構文は似ています。

```rust,ignore
foo<'a, 'b>
#// `foo` has lifetime parameters `'a` and `'b`
//  `foo`は生涯のパラメータ`'a`と`'b`持っています
```

<!--In this case, the lifetime of `foo` cannot exceed that of either `'a` *or* `'b`.-->
この場合、`foo`の存続期間は`'b` *または* `'b` `'a`の存続期間を超えることはできません。

<!--See the following example for explicit lifetime annotation in use:-->
使用中の明示的な存続時間注釈については、次の例を参照してください。

```rust,editable,ignore,mdbook-runnable
#// `print_refs` takes two references to `i32` which have different
#// lifetimes `'a` and `'b`. These two lifetimes must both be at
#// least as long as the function `print_refs`.
//  `print_refs`は`'a`異なる生存時間`'a`と`'b`を持つ`i32`への参照を2つ取ります。これらの2つの存続期間は、少なくとも関数`print_refs`同じ長さでなければなりません。
fn print_refs<'a, 'b>(x: &'a i32, y: &'b i32) {
    println!("x is {} and y is {}", x, y);
}

#// A function which takes no arguments, but has a lifetime parameter `'a`.
// 引数をとりませんが、存続時間パラメータ`'a`持つ関数です。
fn failed_borrow<'a>() {
    let _x = 12;

#    // ERROR: `_x` does not live long enough
    // エラー： `_x`は十分に長くは生きていません
    //let y: &'a i32 = &_x;
#    // Attempting to use the lifetime `'a` as an explicit type annotation 
#    // inside the function will fail because the lifetime of `&_x` is shorter
#    // than that of `y`. A short lifetime cannot be coerced into a longer one.
    //  `&_x`の寿命が`y`寿命より短いため、関数内で明示的な型の注釈として生涯`'a`を使用しようとすると失敗します。短い生存期間はより長い期間に強制されることはできません。
}

fn main() {
#    // Create variables to be borrowed below.
    // 下に借りる変数を作成します。
    let (four, nine) = (4, 9);
    
#    // Borrows (`&`) of both variables are passed into the function.
    // 両方の変数の借用（`&`）が関数に渡されます。
    print_refs(&four, &nine);
#    // Any input which is borrowed must outlive the borrower. 
#    // In other words, the lifetime of `four` and `nine` must 
#    // be longer than that of `print_refs`.
    // 借り入れたすべての入力は、借り手よりも長く存続する必要があります。言い換えれば、`four`と`nine`寿命は`print_refs`寿命よりも長くなければなりません。
    
    failed_borrow();
#    // `failed_borrow` contains no references to force `'a` to be 
#    // longer than the lifetime of the function, but `'a` is longer.
#    // Because the lifetime is never constrained, it defaults to `'static`.
    //  `failed_borrow`は`'a` `'a`が関数の存続期間より長くなるように強制するための参照は含まれていませんが、`'a`はより長くなります。寿命は決して拘束されないので、デフォルトは`'static`です。
}
```

[^1]: %5Belision%5D%20implicitly%20annotates%20lifetimes%20and%20so%20is%20different.

### <!--See also:--> 参照：

<!--[generics][generics] and [closures][closures]-->
[generics][generics]および[closures][closures]

<!--[anonymity]: fn/closures/anonymity.html
 [closures]: fn/closures.html
 [elision]: scope/lifetime/elision.html
 [generics]: generics.html
-->
[anonymity]: fn/closures/anonymity.html
 [closures]: fn/closures.html
 [elision]: scope/lifetime/elision.html
 [generics]: generics.html

