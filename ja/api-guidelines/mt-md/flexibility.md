# <!--Flexibility--> 柔軟性


<span id="c-intermediate"></span><!--## Functions expose intermediate results to avoid duplicate work (C-INTERMEDIATE)-->
##重複作業を避けるために中間結果を公開する関数（C-INTERMEDIATE）

<!--Many functions that answer a question also compute interesting related data.-->
質問に答える多くの関数も興味深い関連データを計算します。
<!--If this data is potentially of interest to the client, consider exposing it in the API.-->
このデータがクライアントにとって興味深い可能性がある場合は、APIに公開することを検討してください。

### <!--Examples from the standard library--> 標準ライブラリの例

- <!--[`Vec::binary_search`] does not return a `bool` of whether the value was found, nor an `Option<usize>` of the index at which the value was maybe found.-->
   [`Vec::binary_search`]は、値が見つかったかどうか、値が見つかった可能性のあるインデックスの`Option<usize>`の`bool`を返しません。
<!--Instead it returns information about the index if found, and also the index at which the value would need to be inserted if not found.-->
   代わりに、見つかった場合はインデックスに関する情報を返し、見つからなければ値を挿入する必要のあるインデックスも返します。

- <!--[`String::from_utf8`] may fail if the input bytes are not UTF-8.-->
   入力バイトがUTF-8でない場合、[`String::from_utf8`]が失敗することがあります。
<!--In the error case it returns an intermediate result that exposes the byte offset up to which the input was valid UTF-8, as well as handing back ownership of the input bytes.-->
   エラーの場合、入力バイトの所有権を引き渡すだけでなく、入力が有効なUTF-8までのバイトオフセットを公開する中間結果を返します。

- <!--[`HashMap::insert`] returns an `Option<T>` that returns the preexisting value for a given key, if any.-->
   [`HashMap::insert`]は、指定されたキーがある場合には既存の値を返す`Option<T>`を返します。
<!--For cases where the user wants to recover this value having it returned by the insert operation avoids the user having to do a second hash table lookup.-->
   ユーザがこの値を回復したい場合、挿入操作によって返された値を使用して、ユーザが第2のハッシュテーブルルックアップを行う必要がなくなります。

<!--[`Vec::binary_search`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.binary_search
 [`String::from_utf8`]: https://doc.rust-lang.org/std/string/struct.String.html#method.from_utf8
 [`HashMap::insert`]: https://doc.rust-lang.org/stable/std/collections/struct.HashMap.html#method.insert
-->
[`Vec::binary_search`]: https://doc.rust-lang.org/std/vec/struct.Vec.html#method.binary_search
 [`String::from_utf8`]: https://doc.rust-lang.org/std/string/struct.String.html#method.from_utf8
 [`HashMap::insert`]: https://doc.rust-lang.org/stable/std/collections/struct.HashMap.html#method.insert



<span id="c-caller-control"></span><!--## Caller decides where to copy and place data (C-CALLER-CONTROL)-->
##発信者はデータをコピーして配置する場所を決定します（C-CALLER-CONTROL）

<!--If a function requires ownership of an argument, it should take ownership of the argument rather than borrowing and cloning the argument.-->
関数が引数の所有権を必要とする場合、引数を借用して複製するのではなく、引数の所有権を取得する必要があります。

```rust
#// Prefer this:
// これを好む：
fn foo(b: Bar) {
    /* use b as owned, directly */
}

#// Over this:
// これ以上：
fn foo(b: &Bar) {
    let b = b.clone();
    /* use b as owned after cloning */
}
```

<!--If a function *does not* require ownership of an argument, it should take a shared or exclusive borrow of the argument rather than taking ownership and dropping the argument.-->
関数*が*引数の所有権を必要と*しない*場合は、所有権を取得し引数を削除するのではなく、引数を共有または排他的に借用する必要があります。

```rust
#// Prefer this:
// これを好む：
fn foo(b: &Bar) {
    /* use b as borrowed */
}

#// Over this:
// これ以上：
fn foo(b: Bar) {
    /* use b as borrowed, it is implicitly dropped before function returns */
}
```

<!--The `Copy` trait should only be used as a bound when absolutely needed, not as a way of signaling that copies should be cheap to make.-->
`Copy`特性は、コピーが安価でなければならないことを通知する方法としてではなく、絶対に必要な場合にのみバインドとして使用する必要があります。


<span id="c-generic"></span><!--## Functions minimize assumptions about parameters by using generics (C-GENERIC)-->
##関数は、ジェネリック（C-GENERIC）を使用してパラメータに関する仮定を最小限に抑えます。

<!--The fewer assumptions a function makes about its inputs, the more widely usable it becomes.-->
関数がその入力について行う仮定が少ないほど、より広く使用できるようになります。

<!--Prefer-->
好む

```rust
fn foo<I: IntoIterator<Item = i64>>(iter: I) { /* ... */ }
```

<!--over any of-->
いずれかの

```rust
fn foo(c: &[i64]) { /* ... */ }
fn foo(c: &Vec<i64>) { /* ... */ }
fn foo(c: &SomeOtherCollection<i64>) { /* ... */ }
```

<!--if the function only needs to iterate over the data.-->
関数がデータを繰り返し処理する必要がある場合。

<!--More generally, consider using generics to pinpoint the assumptions a function needs to make about its arguments.-->
より一般的には、ジェネリックスを使用して、関数がその引数について行う必要がある仮定を特定することを検討してください。

### <!--Advantages of generics--> ジェネリック医薬品の利点

* <!-- _Reusability_ .-->
    _再利用性_ 。
<!--Generic functions can be applied to an open-ended collection of types, while giving a clear contract for the functionality those types must provide.-->
   汎用関数は、型の自由な集合に適用することができ、それらの型が提供しなければならない機能について明確な契約をします。

* <!-- _Static dispatch and optimization_ .-->
    _静的なディスパッチと最適化_ 。
<!--Each use of a generic function is specialized ("monomorphized") to the particular types implementing the trait bounds, which means that (1) invocations of trait methods are static, direct calls to the implementation and (2) the compiler can inline and otherwise optimize these calls.-->
   （1）形質メソッドの呼び出しは静的であり、実装への直接呼び出しであり、（2）コンパイラはインラインでも他の方法でも可能であることを意味するこれらの呼び出しを最適化します。

* <!-- _Inline layout_ .-->
    _インラインレイアウト_ 。
<!--If a `struct` and `enum` type is generic over some type parameter `T`, values of type `T` will be laid out inline in the `struct` / `enum`, without any indirection.-->
   `struct`と`enum`型がいくつかの型パラメータ`T`に対して汎用である場合、型`T`値は間接的な指定なしで`struct` / `enum`インラインで配置されます。

* <!-- _Inference_ .-->
    _推論_ 。
<!--Since the type parameters to generic functions can usually be inferred, generic functions can help cut down on verbosity in code where explicit conversions or other method calls would usually be necessary.-->
   ジェネリック関数への型パラメータは通常推論できるので、ジェネリック関数は、通常は明示的な変換や他のメソッド呼び出しが必要なコードの冗長性を減らすのに役立ちます。

* <!-- _Precise types_ .-->
    _正確なタイプ_ 。
<!--Because generic give a  _name_  to the specific type implementing a trait, it is possible to be precise about places where that exact type is required or produced.-->
   ジェネリックは特性を実装する特定のタイプに _名前_ を付けるので、その正確なタイプが必要とされる場所や生成される場所について正確にすることが可能です。
<!--For example, a function-->
   例えば、関数

<!--` ``rust fn binary<T: Trait>(x: T, y: T) -> T`` `-->
` ``rust fn binary<T: Trait>(x: T, y: T) -> T`` T`

<!--is guaranteed to consume and produce elements of exactly the same type `T`;-->
厳密に同じタイプ`T`要素を消費して生成することが保証されている。
<!--it cannot be invoked with parameters of different types that both implement `Trait`.-->
両方とも`Trait`実装する異なる型のパラメータで呼び出すことはできません。

### <!--Disadvantages of generics--> ジェネリック医薬品の短所

* <!-- _Code size_ .-->
    _コードサイズ_ 。
<!--Specializing generic functions means that the function body is duplicated.-->
   汎用関数の特殊化は、関数本体が複製されることを意味します。
<!--The increase in code size must be weighed against the performance benefits of static dispatch.-->
   コードサイズの増加は、静的ディスパッチのパフォーマンス上の利点と比較して重視する必要があります。

* <!-- _Homogeneous types_ .-->
    _同種のタイプ_ 。
<!--This is the other side of the "precise types"coin: if `T` is a type parameter, it stands for a  _single_  actual type.-->
   これは「正確な型」コインのもう1つの側面です`T`が型パラメータの場合、それは _単一の_ 実際の型を表します。
<!--So for example a `Vec<T>` contains elements of a single concrete type (and, indeed, the vector representation is specialized to lay these out in line).-->
   たとえば、`Vec<T>`には1つの具体的な型の要素が含まれています（実際には、ベクトル表現はこれらを並び替えるように特化されています）。
<!--Sometimes heterogeneous collections are useful;-->
   場合によっては異種コレクションが有用な場合もあります。
<!--see [trait objects][C-OBJECT].-->
   [特性オブジェクトを][C-OBJECT]参照してください。

* <!-- _Signature verbosity_ .-->
    _署名の冗長性_ 。
<!--Heavy use of generics can make it more difficult to read and understand a function's signature.-->
   ジェネリックを多用すると、関数のシグネチャを読み、理解することがより困難になる可能性があります。

[C-OBJECT]: #c-object

### <!--Examples from the standard library--> 標準ライブラリの例

- <!--[`std::fs::File::open`] takes an argument of generic type `AsRef<Path>`.-->
   [`std::fs::File::open`]はジェネリック型`AsRef<Path>`引数をとります。
<!--This allows files to be opened conveniently from a string literal `"f.txt"`, a [`Path`], an [`OsString`], and a few other types.-->
   これにより、文字列リテラル`"f.txt"`、 [`Path`]、 [`OsString`]、その他のいくつかのタイプからファイルを簡単に開くことができます。

<!--[`std::fs::File::open`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.open
 [`Path`]: https://doc.rust-lang.org/std/path/struct.Path.html
 [`OsString`]: https://doc.rust-lang.org/std/ffi/struct.OsString.html
-->
[`std::fs::File::open`]: https://doc.rust-lang.org/std/fs/struct.File.html#method.open
 [`Path`]: https://doc.rust-lang.org/std/path/struct.Path.html
 [`OsString`]: https://doc.rust-lang.org/std/ffi/struct.OsString.html



<span id="c-object"></span><!--## Traits are object-safe if they may be useful as a trait object (C-OBJECT)-->
##形質は形質オブジェクト（C-OBJECT）として有用である場合、オブジェクトセーフであり、

<!--Trait objects have some significant limitations: methods invoked through a trait object cannot use generics, and cannot use `Self` except in receiver position.-->
Traitオブジェクトにはいくつかの重要な制限があります。特性オブジェクトを通じて呼び出されるメソッドはジェネリックを使用できず、受信者の位置以外では`Self`は使用できません。

<!--When designing a trait, decide early on whether the trait will be used as an object or as a bound on generics.-->
形質を設計する際には、その形質が目的として使用されるのか、ジェネリックの限界として使用されるのかを早期に決定する。

<!--If a trait is meant to be used as an object, its methods should take and return trait objects rather than use generics.-->
形質がオブジェクトとして使用されることになっている場合、そのメソッドはジェネリックを使用するのではなく、特性オブジェクトを取得して返す必要があります。

<!--A `where` clause of `Self: Sized` may be used to exclude specific methods from the trait's object.-->
`Self: Sized` `where`句を使用して、特性のオブジェクトから特定のメソッドを除外することができます。
<!--The following trait is not object-safe due to the generic method.-->
次の特性は、汎用メソッドのためにオブジェクトセーフではありません。

```rust
trait MyTrait {
    fn object_safe(&self, i: i32);

    fn not_object_safe<T>(&self, t: T);
}
```

<!--Adding a requirement of `Self: Sized` to the generic method excludes it from the trait object and makes the trait object-safe.-->
`Self: Sized`という一般的なメソッドの要件を追加すると、それを特性オブジェクトから除外し、その特性をオブジェクト安全にします。

```rust
trait MyTrait {
    fn object_safe(&self, i: i32);

    fn not_object_safe<T>(&self, t: T) where Self: Sized;
}
```

### <!--Advantages of trait objects--> 特性オブジェクトの利点

* <!-- _Heterogeneity_ .-->
    _異種性_ 。
<!--When you need it, you really need it.-->
   あなたがそれを必要とするとき、あなたは本当にそれを必要とします。
* <!-- _Code size_ .-->
    _コードサイズ_ 。
<!--Unlike generics, trait objects do not generate specialized (monomorphized) versions of code, which can greatly reduce code size.-->
   ジェネリックと異なり、特性オブジェクトはコードの特殊なバージョンを生成することはなく、コードサイズを大幅に削減することができます。

### <!--Disadvantages of trait objects--> 形質オブジェクトの短所

* <!-- _No generic methods_ .-->
    _一般的な方法はありません_ 。
<!--Trait objects cannot currently provide generic methods.-->
   Traitオブジェクトは現在、汎用メソッドを提供することができません。
* <!-- _Dynamic dispatch and fat pointers_ .-->
    _動的ディスパッチおよびファットポインタ_ 
<!--Trait objects inherently involve indirection and vtable dispatch, which can carry a performance penalty.-->
   特性オブジェクトは、本質的に、インダイレクションおよびvtableディスパッチを含み、これはパフォーマンス上のペナルティをもたらす可能性がある。
* <!-- _No Self_ .-->
    _自己はいません_ 。
<!--Except for the method receiver argument, methods on trait objects cannot use the `Self` type.-->
   メソッドのreceiver引数を除いて、traitオブジェクトのメソッドは`Self`型を使用できません。

### <!--Examples from the standard library--> 標準ライブラリの例

- <!--The [`io::Read`] and [`io::Write`] traits are often used as objects.-->
   [`io::Read`]と[`io::Write`]は、しばしばオブジェクトとして使われます。
- <!--The [`Iterator`] trait has several generic methods marked with `where Self: Sized` to retain the ability to use `Iterator` as an object.-->
   [`Iterator`]特性は、`Iterator`をオブジェクトとして使用する能力を保持するために、`where Self: Sized`とマークされたいくつかの一般的なメソッドを持っています。

<!--[`io::Read`]: https://doc.rust-lang.org/std/io/trait.Read.html
 [`io::Write`]: https://doc.rust-lang.org/std/io/trait.Write.html
 [`Iterator`]: https://doc.rust-lang.org/std/iter/trait.Iterator.html
-->
[`io::Read`]: https://doc.rust-lang.org/std/io/trait.Read.html
 [`io::Write`]: https://doc.rust-lang.org/std/io/trait.Write.html
 [`Iterator`]: https://doc.rust-lang.org/std/iter/trait.Iterator.html

