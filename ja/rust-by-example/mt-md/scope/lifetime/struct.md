# <!--Structs--> 構造

<!--Annotation of lifetimes in structures are also similar to functions:-->
構造内の生存時間の注釈も関数に似ています。

```rust,editable
#// A type `Borrowed` which houses a reference to an
#// `i32`. The reference to `i32` must outlive `Borrowed`.
//  `i32`への参照を格納するタイプ`Borrowed`。 `i32`への参照は`Borrowed`なければなりません。
#[derive(Debug)]
struct Borrowed<'a>(&'a i32);

#// Similarly, both references here must outlive this structure.
// 同様に、ここでの両方の参照は、この構造より長く存続しなければならない。
#[derive(Debug)]
struct NamedBorrowed<'a> {
    x: &'a i32,
    y: &'a i32,
}

#// An enum which is either an `i32` or a reference to one.
//  `i32`または1への参照のいずれかである列挙型。
#[derive(Debug)]
enum Either<'a> {
    Num(i32),
    Ref(&'a i32),
}

fn main() {
    let x = 18;
    let y = 15;

    let single = Borrowed(&x);
    let double = NamedBorrowed { x: &x, y: &y };
    let reference = Either::Ref(&x);
    let number    = Either::Num(y);

    println!("x is borrowed in {:?}", single);
    println!("x and y are borrowed in {:?}", double);
    println!("x is borrowed in {:?}", reference);
    println!("y is *not* borrowed in {:?}", number);
}
```

### <!--See also:--> 参照：

[`struct` s][structs]

[structs]: custom_types/structs.html
