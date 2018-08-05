# <!--Combinators: `map`--> Combinators： `map`

<!--`match` is a valid method for handling `Option` s.-->
`match`は、`Option`を処理するための有効なメソッドです。
<!--However, you may eventually find heavy usage tedious, especially with operations only valid with an input.-->
しかし、最終的には、重い使い方が面倒なことがあります。
<!--In these cases, [combinators][combinators] can be used to manage control flow in a modular fashion.-->
このような場合、[combinators][combinators]を使用してモジュラー方式で制御フローを管理できます。

<!--`Option` has a built in method called `map()`, a combinator for the simple mapping of `Some -> Some` and `None -> None`.-->
`Option`は、`map()`というメソッドが組み込まれています。これは、`Some -> Some`および`None -> None`の単純なマッピングのためのコンビネータです。
<!--Multiple `map()` calls can be chained together for even more flexibility.-->
複数の`map()`呼び出しを連鎖させて、さらに柔軟にすることができます。

<!--In the following example, `process()` replaces all functions previous to it while staying compact.-->
次の例では、`process()`はコンパクトなままで、それ以前のすべての関数を置き換えます。

```rust,editable
#![allow(dead_code)]

#[derive(Debug)] enum Food { Apple, Carrot, Potato }

#[derive(Debug)] struct Peeled(Food);
#[derive(Debug)] struct Chopped(Food);
#[derive(Debug)] struct Cooked(Food);

#// Peeling food. If there isn't any, then return `None`.
#// Otherwise, return the peeled food.
// 食品をはがす。何もない場合は、`None`を返します。それ以外の場合は、剥がした食品を戻してください。
fn peel(food: Option<Food>) -> Option<Peeled> {
    match food {
        Some(food) => Some(Peeled(food)),
        None       => None,
    }
}

#// Chopping food. If there isn't any, then return `None`.
#// Otherwise, return the chopped food.
// 食べ物を食べる。何もない場合は、`None`を返します。そうでなければ、チョップドフードを返す。
fn chop(peeled: Option<Peeled>) -> Option<Chopped> {
    match peeled {
        Some(Peeled(food)) => Some(Chopped(food)),
        None               => None,
    }
}

#// Cooking food. Here, we showcase `map()` instead of `match` for case handling.
// 料理する。ここでは、ショーケース`map()`の代わりに、`match`ケース処理のために。
fn cook(chopped: Option<Chopped>) -> Option<Cooked> {
    chopped.map(|Chopped(food)| Cooked(food))
}

#// A function to peel, chop, and cook food all in sequence.
#// We chain multiple uses of `map()` to simplify the code.
// 食べ物を引き剥がし、チョップし、料理をする機能。コードを単純化するために、`map()`複数の使用を連鎖させます。
fn process(food: Option<Food>) -> Option<Cooked> {
    food.map(|f| Peeled(f))
        .map(|Peeled(f)| Chopped(f))
        .map(|Chopped(f)| Cooked(f))
}

#// Check whether there's food or not before trying to eat it!
// それを食べようとする前に食べ物があるかどうかを確認してください！
fn eat(food: Option<Cooked>) {
    match food {
        Some(food) => println!("Mmm. I love {:?}", food),
        None       => println!("Oh no! It wasn't edible."),
    }
}

fn main() {
    let apple = Some(Food::Apple);
    let carrot = Some(Food::Carrot);
    let potato = None;

    let cooked_apple = cook(chop(peel(apple)));
    let cooked_carrot = cook(chop(peel(carrot)));
#    // Let's try the simpler looking `process()` now.
    // もっと簡単な`process()`を試してみましょう。
    let cooked_potato = process(potato);

    eat(cooked_apple);
    eat(cooked_carrot);
    eat(cooked_potato);
}
```

### <!--See also:--> 参照：

<!--[closures][closures], [`Option`][option], [`Option::map()`][map]-->
[closures][closures]、 [`Option`][option]、 [`Option::map()`][map]

<!--[combinators]: https://doc.rust-lang.org/book/glossary.html#combinators
 [closures]: fn/closures.html
 [option]: https://doc.rust-lang.org/std/option/enum.Option.html
 [map]: https://doc.rust-lang.org/std/option/enum.Option.html#method.map
-->
[combinators]: https://doc.rust-lang.org/book/glossary.html#combinators
 [closures]: fn/closures.html
 [option]: https://doc.rust-lang.org/std/option/enum.Option.html
 [map]: https://doc.rust-lang.org/std/option/enum.Option.html#method.map

