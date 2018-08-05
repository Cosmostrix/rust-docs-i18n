# <!--HashMap--> ハッシュマップ

<!--Where vectors store values by an integer index, `HashMap` s store values by key.-->
ベクトルが整数インデックスで値を格納する場合、`HashMap`値をキーで格納します。
<!--`HashMap` keys can be booleans, integers, strings, or any other type that implements the `Eq` and `Hash` traits.-->
`HashMap`キーは、ブール値、整数、文字列、または`Eq`および`Hash`特性を実装するその他の型にすることができます。
<!--More on this in the next section.-->
これについては、次のセクションで詳しく説明します。

<!--Like vectors, `HashMap` s are growable, but HashMaps can also shrink themselves when they have excess space.-->
ベクトルのように、`HashMap`は拡張可能ですが、余分なスペースがあるときにはHashMapsも縮小できます。
<!--You can create a HashMap with a certain starting capacity using `HashMap::with_capacity(uint)`, or use `HashMap::new()` to get a HashMap with a default initial capacity (recommended).-->
`HashMap::with_capacity(uint)`を使用して特定の開始容量を持つHas​​hMapを作成するか、`HashMap::new()`を使用してデフォルトの初期容量（推奨）のHashMapを取得できます。

```rust,editable
use std::collections::HashMap;

fn call(number: &str) -> &str {
    match number {
        "798-1364" => "We're sorry, the call cannot be completed as dialed. 
            Please hang up and try again.",
        "645-7689" => "Hello, this is Mr. Awesome's Pizza. My name is Fred.
            What can I get for you today?",
        _ => "Hi! Who is this again?"
    }
}

fn main() { 
    let mut contacts = HashMap::new();

    contacts.insert("Daniel", "798-1364");
    contacts.insert("Ashley", "645-7689");
    contacts.insert("Katie", "435-8291");
    contacts.insert("Robert", "956-1745");

#    // Takes a reference and returns Option<&V>
    // 参照を取得し、Option <＆V>を返します。
    match contacts.get(&"Daniel") {
        Some(&number) => println!("Calling Daniel: {}", call(number)),
        _ => println!("Don't have Daniel's number."),
    }

#    // `HashMap::insert()` returns `None`
#    // if the inserted value is new, `Some(value)` otherwise
    //  `HashMap::insert()`は、挿入された値が新しい場合は`None`返し、そうでない場合は`Some(value)`返します。
    contacts.insert("Daniel", "164-6743");

    match contacts.get(&"Ashley") {
        Some(&number) => println!("Calling Ashley: {}", call(number)),
        _ => println!("Don't have Ashley's number."),
    }

    contacts.remove(&"Ashley"); 

#    // `HashMap::iter()` returns an iterator that yields 
#    // (&'a key, &'a value) pairs in arbitrary order.
    //  `HashMap::iter()`は、任意の順序でペア（＆aキー、＆a値）を生成するイテレータを返します。
    for (contact, &number) in contacts.iter() {
        println!("Calling {}: {}", contact, call(number)); 
    }
}
```

<!--For more information on how hashing and hash maps (sometimes called hash tables) work, have a look at [Hash Table Wikipedia][wiki-hash]-->
ハッシュテーブルとハッシュマップ（ハッシュテーブルとも呼ばれる）の仕組みの詳細については、[ハッシュテーブルWikipedia][wiki-hash]

[wiki-hash]: https://en.wikipedia.org/wiki/Hash_table
