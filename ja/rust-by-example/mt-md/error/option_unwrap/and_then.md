# <!--Combinators: `and_then`--> `and_then`： `and_then`

<!--`map()` was described as a chainable way to simplify `match` statements.-->
`map()`は、`match`ステートメントを単純化する連鎖可能な方法として記述されていました。
<!--However, using `map()` on a function that returns an `Option<T>` results in the nested `Option<Option<T>>`.-->
ただし、`Option<T>`を返す関数で`map()`を使用すると、ネストされた`Option<Option<T>>`ます。
<!--Chaining multiple calls together can then become confusing.-->
複数の通話を連鎖させると混乱することがあります。
<!--That's where another combinator called `and_then()`, known in some languages as flatmap, comes in.-->
そこには、flatmapとして知られている`and_then()`という別のコンビネータがあります。

<!--`and_then()` calls its function input with the wrapped value and returns the result.-->
`and_then()`は、関数の入力をラップされた値で呼び出し、その結果を返します。
<!--If the `Option` is `None`, then it returns `None` instead.-->
`Option`が`None`場合、代わりに`None`が返されます。

<!--In the following example, `cookable_v2()` results in an `Option<Food>`.-->
次の例では、`cookable_v2()`は`Option<Food>`ます。
<!--Using `map()` instead of `and_then()` would have given an `Option<Option<Food>>`, which is an invalid type for `eat()`.-->
`and_then()` `map()`代わりに`map()`使うと、`Option<Option<Food>>`が与えられました。これは、`eat()`にとって無効な型です。

```rust,editable
#![allow(dead_code)]

#[derive(Debug)] enum Food { CordonBleu, Steak, Sushi }
#[derive(Debug)] enum Day { Monday, Tuesday, Wednesday }

#// We don't have the ingredients to make Sushi.
// 寿司を作る材料はありません。
fn have_ingredients(food: Food) -> Option<Food> {
    match food {
        Food::Sushi => None,
        _           => Some(food),
    }
}

#// We have the recipe for everything except Cordon Bleu.
// コルドンブルー以外のすべてのレシピがあります。
fn have_recipe(food: Food) -> Option<Food> {
    match food {
        Food::CordonBleu => None,
        _                => Some(food),
    }
}

#// To make a dish, we need both the ingredients and the recipe.
#// We can represent the logic with a chain of `match`es:
// 料理を作るには、材料とレシピの両方が必要です。我々は、`match`鎖でロジックを表現することができます：
fn cookable_v1(food: Food) -> Option<Food> {
    match have_ingredients(food) {
        None       => None,
        Some(food) => match have_recipe(food) {
            None       => None,
            Some(food) => Some(food),
        },
    }
}

#// This can conveniently be rewritten more compactly with `and_then()`:
// これは、`and_then()`と、よりコンパクトに簡単に書き直すことができます。
fn cookable_v2(food: Food) -> Option<Food> {
    have_ingredients(food).and_then(have_recipe)
}

fn eat(food: Food, day: Day) {
    match cookable_v2(food) {
        Some(food) => println!("Yay! On {:?} we get to eat {:?}.", day, food),
        None       => println!("Oh no. We don't get to eat on {:?}?", day),
    }
}

fn main() {
    let (cordon_bleu, steak, sushi) = (Food::CordonBleu, Food::Steak, Food::Sushi);

    eat(cordon_bleu, Day::Monday);
    eat(steak, Day::Tuesday);
    eat(sushi, Day::Wednesday);
}
```

### <!--See also:--> 参照：

<!--[closures][closures], [`Option`][option], and [`Option::and_then()`][and_then]-->
[closures][closures]、 [`Option`][option]、 [`Option::and_then()`][and_then]

<!--[closures]: fn/closures.html
 [option]: https://doc.rust-lang.org/std/option/enum.Option.html
 [and_then]: https://doc.rust-lang.org/std/option/enum.Option.html#method.and_then
-->
[closures]: fn/closures.html
 [option]: https://doc.rust-lang.org/std/option/enum.Option.html
 [and_then]: https://doc.rust-lang.org/std/option/enum.Option.html#method.and_then

