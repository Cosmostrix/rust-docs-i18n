# <!--Derive--> 派生する

<!--The compiler is capable of providing basic implementations for some traits via the `#[derive]` [attribute][attribute].-->
コンパイラは、`#[derive]` [attribute][attribute]介していくつかの特性の基本的な実装を提供することができ[attribute][attribute]。
<!--These traits can still be manually implemented if a more complex behavior is required.-->
より複雑な振る舞いが必要な場合、これらの特性は手動で実装することができます。

<!--The following is a list of derivable traits: * Comparison traits: [`Eq`][eq], [`PartialEq`][partial-eq], [`Ord`][ord], [`PartialOrd`][partial-ord] * [`Clone`][clone], to create `T` from `&T` via a copy.-->
以下は、特性誘導のリストです：*比較特徴： [`Eq`][eq]、 [`PartialEq`][partial-eq]、 [`Ord`][ord]、 [`PartialOrd`][partial-ord] * [`Clone`][clone]、作成するために、 `T`から`&T`コピーを経由して。
<!--* [`Copy`][copy], to give a type 'copy semantics' instead of 'move semantics' * [`Hash`][hash], to compute a hash from `&T`.-->
* [`Copy`][copy]、 'move semantics'の代わりに 'copy semantics'型を与える* [`Hash`][hash]、 `&T`からハッシュを計算する。
<!--* [`Default`][default], to create an empty instance of a data type.-->
* [`Default`][default]は、データ型の空のインスタンスを作成します。
<!--* [`Debug`][debug], to format a value using the `{:?}` formatter.-->
* [`Debug`][debug] `{:?}`：？ `{:?}`フォーマッタを使用して値をフォーマットします。
<!--` ``rust,example // `Centimeters`, a tuple struct that can be compared #[derive(PartialEq, PartialOrd)] struct Centimeters(f64); // `Inches`, a tuple struct that can be printed #[derive(Debug)] struct Inches(i32); impl Inches { fn to_centimeters(&self) -> Centimeters { let &Inches(inches) = self; Centimeters(inches as f64 * 2.54) } } // `Seconds`, a tuple struct no additional attributes struct Seconds(i32); fn main() { let _one_second = Seconds(1); // Error: `Seconds` can't be printed; it doesn't implement the `Debug` trait //println!("One second looks like: {:?}", _one_second); // TODO ^ Try uncommenting this line // Error: `Seconds` can't be compared; it doesn't implement the `PartialEq` trait //let _this_is_true = (_one_second == _one_second); // TODO ^ Try uncommenting this line let foot = Inches(12); println!("One foot equals {:?}", foot); let meter = Centimeters(100.0); let cmp = if foot.to_centimeters() < meter { "smaller" } else { "bigger" }; println!("One foot is {} than one meter.", cmp); }``-->
` ``rust,example // `Centimeters`, a tuple struct that can be compared #[derive(PartialEq, PartialOrd)] struct Centimeters(f64); // `Inches`, a tuple struct that can be printed #[derive(Debug)] struct Inches(i32); impl Inches { fn to_centimeters(&self) -> Centimeters { let &Inches(inches) = self; Centimeters(inches as f64 * 2.54) } } // `Seconds`, a tuple struct no additional attributes struct Seconds(i32); fn main() { let _one_second = Seconds(1); // Error: `Seconds` can't be printed; it doesn't implement the `Debug` trait //println!("One second looks like: {:?}", _one_second); // TODO ^ Try uncommenting this line // Error: `Seconds` can't be compared; it doesn't implement the `PartialEq` trait //let _this_is_true = (_one_second == _one_second); // TODO ^ Try uncommenting this line let foot = Inches(12); println!("One foot equals {:?}", foot); let meter = Centimeters(100.0); let cmp = if foot.to_centimeters() < meter { "smaller" } else { "bigger" }; println!("One foot is {} than one meter.", cmp); }``
``rust,example // `Centimeters`, a tuple struct that can be compared #[derive(PartialEq, PartialOrd)] struct Centimeters(f64); // `Inches`, a tuple struct that can be printed #[derive(Debug)] struct Inches(i32); impl Inches { fn to_centimeters(&self) -> Centimeters { let &Inches(inches) = self; Centimeters(inches as f64 * 2.54) } } // `Seconds`, a tuple struct no additional attributes struct Seconds(i32); fn main() { let _one_second = Seconds(1); // Error: `Seconds` can't be printed; it doesn't implement the `Debug` trait //println!("One second looks like: {:?}", _one_second); // TODO ^ Try uncommenting this line // Error: `Seconds` can't be compared; it doesn't implement the `PartialEq` trait //let _this_is_true = (_one_second == _one_second); // TODO ^ Try uncommenting this line let foot = Inches(12); println!("One foot equals {:?}", foot); let meter = Centimeters(100.0); let cmp = if foot.to_centimeters() < meter { "smaller" } else { "bigger" }; println!("One foot is {} than one meter.", cmp); }`` <!--``rust,example // `Centimeters`, a tuple struct that can be compared #[derive(PartialEq, PartialOrd)] struct Centimeters(f64); // `Inches`, a tuple struct that can be printed #[derive(Debug)] struct Inches(i32); impl Inches { fn to_centimeters(&self) -> Centimeters { let &Inches(inches) = self; Centimeters(inches as f64 * 2.54) } } // `Seconds`, a tuple struct no additional attributes struct Seconds(i32); fn main() { let _one_second = Seconds(1); // Error: `Seconds` can't be printed; it doesn't implement the `Debug` trait //println!("One second looks like: {:?}", _one_second); // TODO ^ Try uncommenting this line // Error: `Seconds` can't be compared; it doesn't implement the `PartialEq` trait //let _this_is_true = (_one_second == _one_second); // TODO ^ Try uncommenting this line let foot = Inches(12); println!("One foot equals {:?}", foot); let meter = Centimeters(100.0); let cmp = if foot.to_centimeters() < meter { "smaller" } else { "bigger" }; println!("One foot is {} than one meter.", cmp); }`` `-->
``rust,example // `Centimeters`, a tuple struct that can be compared #[derive(PartialEq, PartialOrd)] struct Centimeters(f64); // `Inches`, a tuple struct that can be printed #[derive(Debug)] struct Inches(i32); impl Inches { fn to_centimeters(&self) -> Centimeters { let &Inches(inches) = self; Centimeters(inches as f64 * 2.54) } } // `Seconds`, a tuple struct no additional attributes struct Seconds(i32); fn main() { let _one_second = Seconds(1); // Error: `Seconds` can't be printed; it doesn't implement the `Debug` trait //println!("One second looks like: {:?}", _one_second); // TODO ^ Try uncommenting this line // Error: `Seconds` can't be compared; it doesn't implement the `PartialEq` trait //let _this_is_true = (_one_second == _one_second); // TODO ^ Try uncommenting this line let foot = Inches(12); println!("One foot equals {:?}", foot); let meter = Centimeters(100.0); let cmp = if foot.to_centimeters() < meter { "smaller" } else { "bigger" }; println!("One foot is {} than one meter.", cmp); }`` `

### <!--See also:--> 参照：
[`derive`][derive]
<!--[attribute]: attribute.html
 [eq]: https://doc.rust-lang.org/std/cmp/trait.Eq.html
 [partial-eq]: https://doc.rust-lang.org/std/cmp/trait.PartialEq.html
 [ord]: https://doc.rust-lang.org/std/cmp/trait.Ord.html
 [partial-ord]: https://doc.rust-lang.org/std/cmp/trait.PartialOrd.html
 [clone]: https://doc.rust-lang.org/std/clone/trait.Clone.html
 [copy]: https://doc.rust-lang.org/core/marker/trait.Copy.html
 [hash]: https://doc.rust-lang.org/std/hash/trait.Hash.html
 [default]: https://doc.rust-lang.org/std/default/trait.Default.html
 [debug]: https://doc.rust-lang.org/std/fmt/trait.Debug.html
 [derive]: https://doc.rust-lang.org/reference/attributes.html#derive
-->
[attribute]: attribute.html
 [eq]: https://doc.rust-lang.org/std/cmp/trait.Eq.html
 [partial-eq]: https://doc.rust-lang.org/std/cmp/trait.PartialEq.html
 [ord]: https://doc.rust-lang.org/std/cmp/trait.Ord.html
 [partial-ord]: https://doc.rust-lang.org/std/cmp/trait.PartialOrd.html
 [clone]: https://doc.rust-lang.org/std/clone/trait.Clone.html
 [copy]: https://doc.rust-lang.org/core/marker/trait.Copy.html
 [hash]: https://doc.rust-lang.org/std/hash/trait.Hash.html
 [default]: https://doc.rust-lang.org/std/default/trait.Default.html
 [debug]: https://doc.rust-lang.org/std/fmt/trait.Debug.html
 [derive]: https://doc.rust-lang.org/reference/attributes.html#derive

