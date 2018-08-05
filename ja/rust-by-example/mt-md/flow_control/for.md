# <!--for loops--> forループ

## <!--for and range--> と範囲

<!--The `for in` construct can be used to iterate through an `Iterator`.-->
For `for in`構文を使用して、`Iterator`を反復することができます。
<!--One of the easiest ways to create an iterator is to use the range notation `a..b`.-->
イテレータを作成する最も簡単な方法の1つは、範囲表記`a..b`を使用することです。
<!--This yields values from `a` (inclusive) to `b` (exclusive) in steps of one.-->
これは、から値を生成する（包括的）する`a` `b` 1のステップで（排他的）。

<!--Let's write FizzBuzz using `for` instead of `while`.-->
`while`代わりに`for`を使っ`for` FizzBu​​zzを書いてみましょう。

```rust,editable
fn main() {
#    // `n` will take the values: 1, 2, ..., 100 in each iteration
    //  `n`は各反復で1、2、...、100の値を取る
    for n in 1..101 {
        if n % 15 == 0 {
            println!("fizzbuzz");
        } else if n % 3 == 0 {
            println!("fizz");
        } else if n % 5 == 0 {
            println!("buzz");
        } else {
            println!("{}", n);
        }
    }
}
```

<!--Alternatively, `a..=b` can be used for a range that is inclusive on both ends.-->
あるいは、`a..=b`は、両端に含まれる範囲に使用できます。
<!--The above can be written as:-->
上記は次のように書くことができます：

```rust,editable
fn main() {
#    // `n` will take the values: 1, 2, ..., 100 in each iteration
    //  `n`は各反復で1、2、...、100の値を取る
    for n in 1..=100 {
        if n % 15 == 0 {
            println!("fizzbuzz");
        } else if n % 3 == 0 {
            println!("fizz");
        } else if n % 5 == 0 {
            println!("buzz");
        } else {
            println!("{}", n);
        }
    }
}
```

## <!--for and iterators--> forとiterators

<!--The `for in` construct is able to interact with an `Iterator` in several ways.-->
`for in`構文は、いくつかの方法で`Iterator`とやりとりすることができます。
<!--As discussed in with the [Iterator][iter] trait, if not specified, the `for` loop will apply the `into_iter` function on the collection provided to convert the collection into an iterator.-->
[Iterator][iter]特性で説明したように、指定されていない場合、`for`ループは、コレクションをイテレータに変換するために提供されたコレクション`into_iter`関数を適用します。
<!--This is not the only means to convert a collection into an iterator however, the other functions available include `iter` and `iter_mut`.-->
これはコレクションをイテレータに変換する唯一の手段ではありませんが、利用できる他の関数には`iter`と`iter_mut`ます。

<!--These 3 functions will return different views of the data within your collection.-->
これらの3つの関数は、コレクション内のデータのさまざまなビューを返します。

* <!--`iter` -This borrows each element of the collection through each iteration.-->
   `iter` -コレクションの各要素を各反復を通じて借用します。
<!--Thus leaving the collection untouched and available for reuse after the loop.-->
   したがって、ループの後でコレクションを変更せずに再利用できるようにします。

```rust, editable
fn main() {
    let names = vec!["Bob", "Frank", "Ferris"];

    for name in names.iter() {
        match name {
            &"Ferris" => println!("There is a rustacean among us!"),
            _ => println!("Hello {}", name),
        }
    }
}
```

* <!--`into_iter` -This consumes the collection so that on each iteration the exact data is provided.-->
   `into_iter` -これは、各繰り返しで正確なデータが提供されるように、コレクションを消費します。
<!--Once the collection has been consumed it is no longer available for reuse as it has been 'moved' within the loop.-->
   コレクションが消費されると、ループ内でコレクションが移動されたため、コレクションは再利用できなくなります。

```rust, editable
fn main() {
    let names = vec!["Bob", "Frank", "Ferris"];

    for name in names.into_iter() {
        match name {
            "Ferris" => println!("There is a rustacean among us!"),
            _ => println!("Hello {}", name),
        }
    }
}
```

* <!--`iter_mut` -This mutably borrows each element of the collection, allowing for the collection to be modified in place.-->
   `iter_mut` -これはコレクションの各要素を可変的に借用し、コレクションを適切に修正できるようにします。

```rust, editable
fn main() {
    let mut names = vec!["Bob", "Frank", "Ferris"];

    for name in names.iter_mut() {
        match name {
            &mut "Ferris" => println!("There is a rustacean among us!"),
            _ => println!("Hello {}", name),
        }
    }
}
```

<!--In the above snippets note the type of `match` branch, that is the key difference in the types or iteration.-->
上記のスニペットでは、タイプまたは反復の主要な違いである`match`ブランチのタイプに注目してください。
<!--The difference in type then of course implies differing actions that are able to be performed.-->
当然、タイプの違いは、実行可能な異なるアクションを意味します。

### <!--See also--> も参照してください

[Iterator][iter]
[iter]: trait/iter.html
