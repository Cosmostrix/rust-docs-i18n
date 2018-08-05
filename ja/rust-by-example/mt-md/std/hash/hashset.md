# <!--HashSet--> HashSet

<!--Consider a `HashSet` as a `HashMap` where we just care about the keys (`HashSet<T>` is, in actuality, just a wrapper around `HashMap<T, ()>`).-->
`HashSet`を`HashMap`として考えると、`HashSet` `HashSet<T>`は実際には`HashMap<T, ()>`ラッパーだけです。

<!--"What's the point of that?"-->
"それのポイントは何ですか？"
<!--you ask.-->
あなたが尋ねる。
<!--"I could just store the keys in a `Vec`."-->
「私は鍵を`Vec`保存するだけです」

<!--A `HashSet` 's unique feature is that it is guaranteed to not have duplicate elements.-->
`HashSet`のユニークな特徴は、重複する要素がないことが保証されていることです。
<!--That's the contract that any set collection fulfills.-->
これは、集合コレクションが満たす契約です。
<!--`HashSet` is just one implementation.-->
`HashSet`は単なる実装です。
<!--(see also: [`BTreeSet`][treeset])-->
（[`BTreeSet`][treeset]も参照してください）

<!--If you insert a value that is already present in the `HashSet`, (ie the new value is equal to the existing and they both have the same hash), then the new value will replace the old.-->
すでに`HashSet`に存在する値を挿入すると（つまり、新しい値が既存のものと等しく、両方が同じハッシュを持つ場合）、新しい値が古い値を置き換えます。

<!--This is great for when you never want more than one of something, or when you want to know if you've already got something.-->
これは、あなたが何かを何も望んでいないときや、すでに何かがあるかどうかを知りたいときに最適です。

<!--But sets can do more than that.-->
しかしセットはそれ以上のことができます。

<!--Sets have 4 primary operations (all of the following calls return an iterator):-->
セットには4つの基本操作があります（次のすべての呼び出しでイテレータが返されます）。

* <!--`union`: get all the unique elements in both sets.-->
   `union`：両方のセットのすべてのユニークな要素を取得します。

* <!--`difference`: get all the elements that are in the first set but not the second.-->
   `difference`：最初のセットにあるが2番目のセットにないすべての要素を取得します。

* <!--`intersection`: get all the elements that are only in *both* sets.-->
   `intersection`： *両方の*セットだけにあるすべての要素を取得します。

* <!--`symmetric_difference`:-->
   `symmetric_difference`：
<!--get all the elements that are in one set or the other, but *not* both.-->
1つのセットまたは他のセットにあるすべての要素を取得しますが、両方を取得することは*できません*。

<!--Try all of these in the following example:-->
次の例でこれらのすべてを試してください：

```rust,editable,ignore,mdbook-runnable
use std::collections::HashSet;

fn main() {
    let mut a: HashSet<i32> = vec!(1i32, 2, 3).into_iter().collect();
    let mut b: HashSet<i32> = vec!(2i32, 3, 4).into_iter().collect();

    assert!(a.insert(4));
    assert!(a.contains(&4));

#    // `HashSet::insert()` returns false if
#    // there was a value already present.
    //  `HashSet::insert()`は、値がすでに存在する場合はfalseを返します。
    assert!(b.insert(4), "Value 4 is already in set B!");
#    // FIXME ^ Comment out this line
    //  FIXME ^この行をコメントアウトする

    b.insert(5);

#    // If a collection's element type implements `Debug`,
#    // then the collection implements `Debug`.
#    // It usually prints its elements in the format `[elem1, elem2, ...]`
    // コレクションの要素の型が実装されている場合`Debug`、そのコレクションは実装`Debug`。通常は、要素を`[elem1, elem2, ...]`形式で出力し`[elem1, elem2, ...]`
    println!("A: {:?}", a);
    println!("B: {:?}", b);

#    // Print [1, 2, 3, 4, 5] in arbitrary order
    // プリント[1, 2, 3, 4, 5]、任意の順序で
    println!("Union: {:?}", a.union(&b).collect::<Vec<&i32>>());

#    // This should print [1]
    // これは、[1]
    println!("Difference: {:?}", a.difference(&b).collect::<Vec<&i32>>());

#    // Print [2, 3, 4] in arbitrary order.
    //  [2, 3, 4]を任意の順序[2, 3, 4]印刷します。
    println!("Intersection: {:?}", a.intersection(&b).collect::<Vec<&i32>>());

#    // Print [1, 5]
    // 印刷[1, 5]
    println!("Symmetric Difference: {:?}",
             a.symmetric_difference(&b).collect::<Vec<&i32>>());
}
```

<!--(Examples are adapted from the [documentation.][hash-set])-->
（例は[documentation.][hash-set]から適応されてい[documentation.][hash-set]）

<!--[treeset]: https://doc.rust-lang.org/std/collections/struct.BTreeSet.html
 [hash-set]: https://doc.rust-lang.org/std/collections/struct.HashSet.html#method.difference
-->
[treeset]: https://doc.rust-lang.org/std/collections/struct.BTreeSet.html
 [hash-set]: https://doc.rust-lang.org/std/collections/struct.HashSet.html#method.difference

