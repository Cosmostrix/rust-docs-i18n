# <!--The Problem--> 問題

<!--A `trait` that is generic over its container type has type specification requirements -users of the `trait` *must* specify all of its generic types.-->
そのコンテナタイプに対して一般`trait`は、タイプ指定要件を有する。`trait`ユーザは、そのジェネリックタイプのすべてを指定し*なければならない*。

<!--In the example below, the `Contains` `trait` allows the use of the generic types `A` and `B`.-->
以下の例では、`Contains` `trait`により、ジェネリック型`A`と`B`使用することができ`Contains`。
<!--The trait is then implemented for the `Container` type, specifying `i32` for `A` and `B` so that it can be used with `fn difference()`.-->
その後、`A`と`B` `i32`を指定して`fn difference()`と一緒に使用できるように、`Container`種類に対して特性が実装されます。

<!--Because `Contains` is generic, we are forced to explicitly state *all* of the generic types for `fn difference()`.-->
`Contains`は総称であるため、`fn difference()` *すべて*のジェネリック型を明示的に指定する*必要*があります。
<!--In practice, we want a way to express that `A` and `B` are determined by the *input* `C`.-->
実際には、`A`と`B`は*入力* `C`によって決まると表現する方法が必要です。
<!--As you will see in the next section, associated types provide exactly that capability.-->
次のセクションで説明するように、関連タイプはその機能を正確に提供します。

```rust,editable
struct Container(i32, i32);

#// A trait which checks if 2 items are stored inside of container.
#// Also retrieves first or last value.
// コンテナの内部に2つのアイテムが格納されているかどうかを調べる特性。また、最初または最後の値を取得します。
trait Contains<A, B> {
#//    fn contains(&self, &A, &B) -> bool; // Explicitly requires `A` and `B`.
    fn contains(&self, &A, &B) -> bool; // 明示的に`A`と`B`が必要です。
#//    fn first(&self) -> i32; // Doesn't explicitly require `A` or `B`.
    fn first(&self) -> i32; // 明示的に`A`または`B`必要としません。
#//    fn last(&self) -> i32;  // Doesn't explicitly require `A` or `B`.
    fn last(&self) -> i32;  // 明示的に`A`または`B`必要としません。
}

impl Contains<i32, i32> for Container {
#    // True if the numbers stored are equal.
    // 格納されている数値が等しい場合はTrueです。
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

#// `C` contains `A` and `B`. In light of that, having to express `A` and
#// `B` again is a nuisance.
//  `C`は`A`と`B`含む。それに反して、`A`と`B`再度表現しなければならないのは迷惑です。
fn difference<A, B, C>(container: &C) -> i32 where
    C: Contains<A, B> {
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

### <!--See also:--> 参照：

<!--[`struct` s][structs], and [`trait` s][traits]-->
[`struct` s][structs]、および[`trait` s][traits]

<!--[structs]: custom_types/structs.html
 [traits]: trait.html
-->
[structs]: custom_types/structs.html
 [traits]: trait.html

