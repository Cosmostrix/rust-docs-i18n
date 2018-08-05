# <!--Where clauses--> Where節

<!--A bound can also be expressed using a `where` clause immediately before the opening `{`, rather than at the type's first mention.-->
境界は、型の最初の言及ではなく、開かれた`{`直前の`where`句を使用して表すこともできます。
<!--Additionally, `where` clauses can apply bounds to arbitrary types, rather than just to type parameters.-->
さらに、`where`句は、パラメータを入力するだけでなく、任意の型に境界を適用できます。

<!--Some cases that a `where` clause is useful:-->
`where`節が便利な場合もあります。

* <!--When specifying generic types and bounds separately is clearer:-->
   ジェネリック型と境界を別々に指定すると、より明確になります。

```rust,ignore
impl <A: TraitB + TraitC, D: TraitE + TraitF> MyTrait<A, D> for YourType {}

#// Expressing bounds with a `where` clause
//  `where`句で境界を表現する
impl <A, D> MyTrait<A, D> for YourType where
    A: TraitB + TraitC,
    D: TraitE + TraitF {}
```

* <!--When using a `where` clause is more expressive than using normal syntax.-->
   `where`節を使用する`where`は、通常の構文を使用するよりも表現力があります。
<!--The `impl` in this example cannot be directly expressed without a `where` clause:-->
この例の`impl`は、`where`句なしで直接表現することはできません。

```rust,editable
use std::fmt::Debug;

trait PrintInOption {
    fn print_in_option(self);
}

#// Because we would otherwise have to express this as `T: Debug` or 
#// use another method of indirect approach, this requires a `where` clause:
// そうでなければ、これを`T: Debug`として表現しなければならないか、間接的アプローチの別の方法を使用する必要があるため、これには`where`句が必要です。
impl<T> PrintInOption for T where
    Option<T>: Debug {
#    // We want `Option<T>: Debug` as our bound because that is what's
#    // being printed. Doing otherwise would be using the wrong bound.
    // 私たちは`Option<T>: Debug`を望んでいます`Option<T>: Debug`それは印刷されているものなので、バウンドとして`Option<T>: Debug`てください。そうしないと、間違った境界が使用されます。
    fn print_in_option(self) {
        println!("{:?}", Some(self));
    }
}

fn main() {
    let vec = vec![1, 2, 3];

    vec.print_in_option();
}
```

### <!--See also:--> 参照：

<!--[RFC][where], [`struct`][struct], and [`trait`][trait]-->
[RFC][where]、 [`struct`][struct]、および[`trait`][trait]

<!--[struct]: custom_types/structs.html
 [trait]: trait.html
 [where]: https://github.com/rust-lang/rfcs/blob/master/text/0135-where.md
-->
[struct]: custom_types/structs.html
 [trait]: trait.html
 [where]: https://github.com/rust-lang/rfcs/blob/master/text/0135-where.md

