# <!--Associated types--> 関連タイプ

<!--The use of "Associated types"improves the overall readability of code by moving inner types locally into a trait as *output* types.-->
"Associated types"を使用すると、内部型をローカルに*出力*型として特性に移動することにより、コードの全体的な可読性が向上します。
<!--Syntax for the `trait` definition is as follows:-->
`trait`定義の構文は次のとおりです。

```rust
#// `A` and `B` are defined in the trait via the `type` keyword.
#// (Note: `type` in this context is different from `type` when used for
#// aliases).
//  `A`および`B`は、`type`キーワードを使用してtraitで定義されます。（注： `type`この文脈では、異なる`type`別名に使用される場合）。
trait Contains {
    type A;
    type B;

#    // Updated syntax to refer to these new types generically.
    // これらの新しいタイプを一般的に参照するように構文が更新されました。
    fn contains(&self, &Self::A, &Self::B) -> bool;
}
```

<!--Note that functions that use the `trait` `Contains` are no longer required to express `A` or `B` at all:-->
`trait` `Contains`を使用する関数は、もはや`A`または`B`を表現`A`必要はないことに注意してください。

```rust,ignore
#// Without using associated types
// 関連タイプを使用しない
fn difference<A, B, C>(container: &C) -> i32 where
    C: Contains<A, B> { ... }

#// Using associated types
// 関連タイプの使用
fn difference<C: Contains>(container: &C) -> i32 { ... }
```

<!--Let's rewrite the example from the previous section using associated types:-->
関連する型を使って前のセクションの例を書き直しましょう：

```rust,editable
struct Container(i32, i32);

#// A trait which checks if 2 items are stored inside of container.
#// Also retrieves first or last value.
// コンテナの内部に2つのアイテムが格納されているかどうかを調べる特性。また、最初または最後の値を取得します。
trait Contains {
#    // Define generic types here which methods will be able to utilize.
    // メソッドが利用できるジェネリック型をここで定義します。
    type A;
    type B;

    fn contains(&self, &Self::A, &Self::B) -> bool;
    fn first(&self) -> i32;
    fn last(&self) -> i32;
}

impl Contains for Container {
#    // Specify what types `A` and `B` are. If the `input` type
#    // is `Container(i32, i32)`, the `output` types are determined
#    // as `i32` and `i32`.
    // タイプ`A`とタイプ`B`指定します。`input`タイプが`Container(i32, i32)`場合、`output`タイプは`i32`と`i32`と決定されます。
    type A = i32;
    type B = i32;

#    // `&Self::A` and `&Self::B` are also valid here.
    //  `&Self::A`と`&Self::B`も有効です。
    fn contains(&self, number_1: &i32, number_2: &i32) -> bool {
        (&self.0 == number_1) && (&self.1 == number_2)
    }
#    // Grab the first number.
    // 最初の番号をつかみなさい。
    fn first(&self) -> i32 { self.0 }

#    // Grab the last number.
    // 最後の数字をつかむ。
    fn last(&self) -> i32 { self.1 }
}

fn difference<C: Contains>(container: &C) -> i32 {
    container.last() - container.first()
}

fn main() {
    let number_1 = 3;
    let number_2 = 10;

    let container = Container(number_1, number_2);

    println!("Does container contain {} and {}: {}",
        &number_1, &number_2,
        container.contains(&number_1, &number_2));
    println!("First number: {}", container.first());
    println!("Last number: {}", container.last());
    
    println!("The difference is: {}", difference(&container));
}
```
