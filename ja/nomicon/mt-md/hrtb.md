# <!--Higher-Rank Trait Bounds (HRTBs)--> HRTB（Higher-Rank Trait Bounds）

<!--Rust's `Fn` traits are a little bit magic.-->
Rustの`Fn`特性は少し魔法です。
<!--For instance, we can write the following code:-->
例えば、次のコードを書くことができます：

```rust
struct Closure<F> {
    data: (u8, u16),
    func: F,
}

impl<F> Closure<F>
    where F: Fn(&(u8, u16)) -> &u8,
{
    fn call(&self) -> &u8 {
        (self.func)(&self.data)
    }
}

fn do_it(data: &(u8, u16)) -> &u8 { &data.0 }

fn main() {
    let clo = Closure { data: (0, 1), func: do_it };
    println!("{}", clo.call());
}
```

<!--If we try to naively desugar this code in the same way that we did in the lifetimes section, we run into some trouble:-->
私たちが生涯のセクションで行ったのと同じ方法でこのコードをnauchous desugarしようとすると、いくつかの問題に遭遇します：

```rust,ignore
struct Closure<F> {
    data: (u8, u16),
    func: F,
}

impl<F> Closure<F>
#    // where F: Fn(&'??? (u8, u16)) -> &'??? u8,
    // ここで、F：Fn（＆ '（u8、u16））→' u8、
{
    fn call<'a>(&'a self) -> &'a u8 {
        (self.func)(&self.data)
    }
}

fn do_it<'b>(data: &'b (u8, u16)) -> &'b u8 { &'b data.0 }

fn main() {
    'x: {
        let clo = Closure { data: (0, 1), func: do_it };
        println!("{}", clo.call());
    }
}
```

<!--How on earth are we supposed to express the lifetimes on `F` 's trait bound?-->
私たちは、`F`の特質の長さをどのように地球上で表現することになっていますか？
<!--We need to provide some lifetime there, but the lifetime we care about can't be named until we enter the body of `call`!-->
私たちはそこで生涯を提供する必要がありますが、私たちが関心を持つ生涯は、`call`を入力するまで名前を付けることはできません！
<!--Also, that isn't some fixed lifetime;-->
また、それは一定の生涯ではありません。
<!--`call` works with *any* lifetime `&self` happens to have at that point.-->
`call`は*どの*生涯とも動作し*、* `&self`はその時点で発生します。

<!--This job requires The Magic of Higher-Rank Trait Bounds (HRTBs).-->
この仕事には、より高いランクの特性の魔法（HRTB）が必要です。
<!--The way we desugar this is as follows:-->
私たちがこれをdesugarする方法は次のとおりです：

```rust,ignore
where for<'a> F: Fn(&'a (u8, u16)) -> &'a u8,
```

<!--(Where `Fn(a, b, c) -> d` is itself just sugar for the unstable *real* `Fn` trait)-->
（`Fn(a, b, c) -> d`はそれ自体が不安定な*実際の* `Fn`特性の砂糖である）

<!--`for<'a>` can be read as "for all choices of `'a` ", and basically produces an *infinite list* of trait bounds that F must satisfy.-->
`for<'a>` 「のすべての選択のためとして読み取ることができる`'a` 」、および基本的形質の*無限のリストを*生成Fが満たさなければならない境界です。
<!--Intense.-->
激しい
<!--There aren't many places outside of the `Fn` traits where we encounter HRTBs, and even for those we have a nice magic sugar for the common cases.-->
HRTBに遭遇する`Fn`特性の外には多くの場所がありませんし、一般的な場合には素晴らしい魔法の砂糖があります。
