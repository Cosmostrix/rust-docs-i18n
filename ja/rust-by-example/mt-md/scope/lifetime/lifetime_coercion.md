# <!--Coercion--> 強制

<!--A longer lifetime can be coerced into a shorter one so that it works inside a scope it normally wouldn't work in. This comes in the form of inferred coercion by the Rust compiler, and also in the form of declaring a lifetime difference:-->
より長い生存時間はより短いものに強制されるので、正常に動作しないスコープの内部で動作します。これは、Rustコンパイラによる推論の形で生涯の違いを宣言する形式で提供されます。

```rust,editable
#// Here, Rust infers a lifetime that is as short as possible.
#// The two references are then coerced to that lifetime.
// ここで、Rustは生涯を可能な限り短く推定する。2つの参照は、その生涯に強制されます。
fn multiply<'a>(first: &'a i32, second: &'a i32) -> i32 {
    first * second
}

#// `<'a: 'b, 'b>` reads as lifetime `'a` is at least as long as `'b`.
#// Here, we take in an `&'a i32` and return a `&'b i32` as a result of coercion.
//  `<'a: 'b, 'b>`は生涯として`'a`は少なくとも`'b`同じ長さです。ここでは、強制的に`&'b i32` `&'a i32`; `&'b i32` `&'a i32`; `&'b i32` `&'a i32`を返します。
fn choose_first<'a: 'b, 'b>(first: &'a i32, _: &'b i32) -> &'b i32 {
    first
}

fn main() {
#//    let first = 2; // Longer lifetime
    let first = 2; // より長い寿命
    
    {
#//        let second = 3; // Shorter lifetime
        let second = 3; // より短い寿命
        
        println!("The product is {}", multiply(&first, &second));
        println!("{} is the first", choose_first(&first, &second));
    };
}
```
