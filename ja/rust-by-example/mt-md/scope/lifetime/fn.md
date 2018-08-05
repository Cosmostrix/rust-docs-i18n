# <!--Functions--> 機能

<!--Ignoring [elision], function signatures with lifetimes have a few constraints:-->
[elision]無視すると、生存期間を伴う関数シグネチャにはいくつかの制約があります。

* <!--any reference *must* have an annotated lifetime.-->
   参照に*は*注釈付きの存続期間が*必要*です。
* <!--any reference being returned *must* have the same lifetime as an input or-->
   返される参照は、入力と同じ存続時間を持つ*必要*があります。
<!--be `static`.-->
`static`。

<!--Additionally, note that returning references without input is banned if it would result in returning references to invalid data.-->
さらに、無効なデータへの参照が返された場合、入力なしで参照を返すことは禁止されています。
<!--The following example shows off some valid forms of functions with lifetimes:-->
次の例は、有効期限のある関数の有効な形式を示しています。

```rust,editable
#// One input reference with lifetime `'a` which must live
#// at least as long as the function.
// 機能と同じくらい長く存続しなければならない寿命`'a`入力リファレンス。
fn print_one<'a>(x: &'a i32) {
    println!("`print_one`: x is {}", x);
}

#// Mutable references are possible with lifetimes as well.
// 変更可能な参照は寿命とともに可能です。
fn add_one<'a>(x: &'a mut i32) {
    *x += 1;
}

#// Multiple elements with different lifetimes. In this case, it
#// would be fine for both to have the same lifetime `'a`, but
#// in more complex cases, different lifetimes may be required.
// 生涯の異なる複数の要素。この場合、両者が同じ生存期間`'a`を持つことは良いでしょうが、より複雑な場合には、異なる生存期間が必要となることがあります。
fn print_multi<'a, 'b>(x: &'a i32, y: &'b i32) {
    println!("`print_multi`: x is {}, y is {}", x, y);
}

#// Returning references that have been passed in is acceptable.
#// However, the correct lifetime must be returned.
// 渡された参照を返すことは許容されます。ただし、正しい生涯を返す必要があります。
fn pass_x<'a, 'b>(x: &'a i32, _: &'b i32) -> &'a i32 { x }

//fn invalid_output<'a>() -> &'a String { &String::from("foo") }
#// The above is invalid: `'a` must live longer than the function.
#// Here, `&String::from("foo")` would create a `String`, followed by a
#// reference. Then the data is dropped upon exiting the scope, leaving
#// a reference to invalid data to be returned.
// 上記は無効です： `'a`は関数よりも長く生きなければなりません。ここで、`&String::from("foo")`は`String`を作成し、その後に参照をつけます。その後、スコープを終了するとデータが破棄され、無効なデータへの参照が返されます。

fn main() {
    let x = 7;
    let y = 9;
    
    print_one(&x);
    print_multi(&x, &y);
    
    let z = pass_x(&x, &y);
    print_one(z);

    let mut t = 3;
    add_one(&mut t);
    print_one(&t);
}
```

### <!--See also:--> 参照：

[functions][fn]
<!--[elision]: scope/lifetime/elision.html
 [fn]: fn.html
-->
[elision]: scope/lifetime/elision.html
 [fn]: fn.html

