# <!--Iterators--> イテレータ

<!--The [`Iterator`][iter] trait is used to implement iterators over collections such as arrays.-->
[`Iterator`][iter]特性は、配列などのコレクションに対するイテレータを実装するために使用されます。

<!--The trait requires only a method to be defined for the `next` element, which may be manually defined in an `impl` block or automatically defined (as in arrays and ranges).-->
この特性は、`next`要素に対して定義されるメソッドのみを必要とします。これは、`impl`ブロックで手動で定義されるか、または自動的に定義されます（配列と範囲のように）。

<!--As a point of convenience for common situations, the `for` construct turns some collections into iterators using the [`.into_iterator()`][intoiter] method.-->
一般的な状況の便宜のために、`for`構文は、いくつかのコレクションを[`.into_iterator()`][intoiter]メソッドを使用してイテレータに変換します。

```rust,editable
struct Fibonacci {
    curr: u32,
    next: u32,
}

#// Implement `Iterator` for `Fibonacci`.
#// The `Iterator` trait only requires a method to be defined for the `next` element.
//  `Fibonacci` `Iterator`を実装する。`Iterator`特性では、`next`要素に対して定義されるメソッドのみが必要です。
impl Iterator for Fibonacci {
    type Item = u32;
    
#    // Here, we define the sequence using `.curr` and `.next`.
#    // The return type is `Option<T>`:
#    //     * When the `Iterator` is finished, `None` is returned.
#    //     * Otherwise, the next value is wrapped in `Some` and returned.
    // ここでは、`.curr`と`.next`を使ってシーケンスを定義します。戻り値の型は`Option<T>`です。* `Iterator`が終了すると、`None`が返されます。*それ以外の場合、次の値は`Some`でラップされて返されます。
    fn next(&mut self) -> Option<u32> {
        let new_next = self.curr + self.next;

        self.curr = self.next;
        self.next = new_next;

#        // Since there's no endpoint to a Fibonacci sequence, the `Iterator` 
#        // will never return `None`, and `Some` is always returned.
        // フィボナッチシーケンスの終点がないので、`Iterator`は決して`None`返さ`None`、ある`Some`は常に返されます。
        Some(self.curr)
    }
}

#// Returns a Fibonacci sequence generator
// フィボナッチシーケンスジェネレータを返します。
fn fibonacci() -> Fibonacci {
    Fibonacci { curr: 1, next: 1 }
}

fn main() {
#    // `0..3` is an `Iterator` that generates: 0, 1, and 2.
    //  `0..3`は、0,1、および2を生成する`Iterator`です。
    let mut sequence = 0..3;

    println!("Four consecutive `next` calls on 0..3");
    println!("> {:?}", sequence.next());
    println!("> {:?}", sequence.next());
    println!("> {:?}", sequence.next());
    println!("> {:?}", sequence.next());

#    // `for` works through an `Iterator` until it returns `None`.
#    // Each `Some` value is unwrapped and bound to a variable (here, `i`).
    //  `for`による作品`Iterator`それは返さないまで`None`。各`Some`値は展開されず、変数（ここでは`i`）にバインドされます。
    println!("Iterate through 0..3 using `for`");
    for i in 0..3 {
        println!("> {}", i);
    }

#    // The `take(n)` method reduces an `Iterator` to its first `n` terms.
    //  `take(n)`メソッドは、`Iterator`を最初の`n`項に減らします。
    println!("The first four terms of the Fibonacci sequence are: ");
    for i in fibonacci().take(4) {
        println!("> {}", i);
    }

#    // The `skip(n)` method shortens an `Iterator` by dropping its first `n` terms.
    //  `skip(n)`メソッドは、最初の`n`項を削除することによって`Iterator`短縮します。
    println!("The next four terms of the Fibonacci sequence are: ");
    for i in fibonacci().skip(4).take(4) {
        println!("> {}", i);
    }

    let array = [1u32, 3, 3, 7];

#    // The `iter` method produces an `Iterator` over an array/slice.
    //  `iter`メソッドは配列/スライス上の`Iterator`を生成します。
    println!("Iterate the following array {:?}", &array);
    for i in array.iter() {
        println!("> {}", i);
    }
}
```

<!--[intoiter]: https://doc.rust-lang.org/std/iter/trait.IntoIterator.html
 [iter]: https://doc.rust-lang.org/core/iter/trait.Iterator.html
-->
[intoiter]: https://doc.rust-lang.org/std/iter/trait.IntoIterator.html
 [iter]: https://doc.rust-lang.org/core/iter/trait.Iterator.html

