# <!--`'_`, the anonymous lifetime--> `'_`、匿名の生涯

<!--Rust 2018 allows you to explicitly mark where a lifetime is elided, for types where this elision might otherwise be unclear.-->
Rust 2018では、このエリジョンが不明瞭になる可能性があるタイプの場合、寿命が省略された場所を明示的にマークすることができます。
<!--To do this, you can use the special lifetime `'_` much like you can explicitly mark that a type is inferred with the syntax `let x: _ = ..;`-->
これを行うには、特別な生涯を使用することができます`'_`あなたが明示的に型が構文と推察されていることをマークすることができます多くのように`let x: _ = ..;`
<!--.-->
。

<!--Let's say, for whatever reason, that we have a simple wrapper around `&'a str`:-->
何らかの理由で`&'a str`周りに簡単なラッパーがあるとしましょう：

```rust
struct StrWrap<'a>(&'a str);
```

<!--In Rust 2015, you might have written:-->
2015年の錆では、あなたは次のように書いたかもしれません。

```rust
#// Rust 2015
//  2015年の錆

use std::fmt;

# struct StrWrap<'a>(&'a str);

fn make_wrapper(string: &str) -> StrWrap {
    StrWrap(string)
}

impl<'a> fmt::Debug for StrWrap<'a> {
    fn fmt(&self, fmt: &mut fmt::Formatter) -> fmt::Result {
        fmt.write_str(self.0)
    }
}
```

<!--In Rust 2018, you can instead write:-->
Rust 2018では、代わりに次のように書くことができます。

```rust
#![feature(rust_2018_preview)]

# use std::fmt;
# struct StrWrap<'a>(&'a str);

#// Rust 2018
// 錆2018

fn make_wrapper(string: &str) -> StrWrap<'_> {
    StrWrap(string)
}

impl fmt::Debug for StrWrap<'_> {
    fn fmt(&self, fmt: &mut fmt::Formatter) -> fmt::Result {
        fmt.write_str(self.0)
    }
}
```

## <!--More details--> 詳細

<!--In the Rust 2015 snippet above, we've used `-> StrWrap`.-->
上のRust 2015スニペットでは、`-> StrWrap`を使用しました。
<!--However, unless you take a look at the definition of `StrWrap`, it is not clear that the returned value is actually borrowing something.-->
しかし、`StrWrap`の定義を見ていない限り、戻り値が実際に何かを借りていることは明らかではありません。
<!--Therefore, starting with Rust 2018, it is deprecated to leave off the lifetime parameters for non-reference-types (types other than `&` and `&mut`).-->
したがって、Rust 2018から始まって、非参照型（`&`と`&mut`以外の型）の有効期間パラメータを残すことは推奨されていません。
<!--Instead, where you previously wrote `-> StrWrap`, you should now write `-> StrWrap<'_>`, making clear that borrowing is occurring.-->
代わりに、以前に`-> StrWrap`と書いたところで、`-> StrWrap<'_>`書いて、借用が行われていることを明確にします。

<!--What exactly does `'_` mean?-->
何が正確に`'_`意味ですか？
<!--It depends on the context!-->
それは文脈に依存します！
<!--In output contexts, as in the return type of `make_wrapper`, it refers to a single lifetime for all "output"locations.-->
出力コンテキストでは、`make_wrapper`の戻り値の型と`make_wrapper`、すべての "出力"位置で1つの有効期間が参照されます。
<!--In input contexts, a fresh lifetime is generated for each "input location".-->
入力コンテキストでは、各「入力場所」に対して新しい生存期間が生成されます。
<!--More concretely, to understand input contexts, consider the following example:-->
より具体的には、入力コンテキストを理解するには、次の例を考えてください。

```rust
#// Rust 2015
//  2015年の錆

struct Foo<'a, 'b: 'a> {
    field: &'a &'b str,
}

impl<'a, 'b: 'a> Foo<'a, 'b> {
#    // some methods...
    // いくつかの方法...
}
```

<!--We can rewrite this as:-->
これを次のように書き直すことができます：

```rust
#![feature(rust_2018_preview)]

# struct Foo<'a, 'b: 'a> {
#     field: &'a &'b str,
# }

#// Rust 2018
// 錆2018

impl Foo<'_, '_> {
#    // some methods...
    // いくつかの方法...
}
```

<!--This is the same, because for each `'_`, a fresh lifetime is generated.-->
これは同じです。なぜなら、それぞれの`'_`に対して、新しい生涯が生成されるからです。
<!--Finally, the relationship `'a: 'b` which the struct requires must be upheld.-->
最後に、構造体が要求する関係`'a: 'b`を維持する必要があります。

<!--For more details, see the [tracking issue on In-band lifetime bindings](https://github.com/rust-lang/rust/issues/44524).-->
詳細については、[帯域内ライフタイムバインディングのトラッキングの問題を](https://github.com/rust-lang/rust/issues/44524)参照してください。
