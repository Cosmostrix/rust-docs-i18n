# <!--Lifetime elision--> 永久脱出

<!--Rust has rules that allow lifetimes to be elided in various places where the compiler can infer a sensible default choice.-->
錆は、コンパイラが賢明なデフォルト選択を推論できる様々な場所で寿命を省略できる規則を持っています。

## <!--Lifetime elision in functions--> 機能の永久脱出

<!--In order to make common patterns more ergonomic, lifetime arguments can be *elided* in [function item], [function pointer] and [closure trait] signatures.-->
一般的なパターンをより人間工学的にするために、生涯引数は、[function item]、 [function pointer]、および[closure trait]シグネチャで*省略*することができます。
<!--The following rules are used to infer lifetime parameters for elided lifetimes.-->
以下の規則は、寿命のない寿命の寿命パラメータを推測するために使用されます。
<!--It is an error to elide lifetime parameters that cannot be inferred.-->
推論できない寿命パラメータを削除するのは誤りです。
<!--The placeholder lifetime, `'_`, can also be used to have a lifetime inferred in the same way.-->
プレースホルダの寿命`'_`は、同じように推論された生涯を持つために使用することもできます。
<!--For lifetimes in paths, using `'_` is preferred.-->
パスのライフタイムには、`'_`を使用することが望ましい。
<!--Trait object lifetimes follow different rules discussed [below](#default-trait-object-lifetimes).-->
特性オブジェクトの寿命は、[below](#default-trait-object-lifetimes)説明[below](#default-trait-object-lifetimes)さまざまなルールに従い[below](#default-trait-object-lifetimes)。

* <!--Each elided lifetime in the parameters becomes a distinct lifetime parameter.-->
   パラメータ内の各寿命は、生涯の異なるパラメータになります。
* <!--If there is exactly one lifetime used in the parameters (elided or not), that lifetime is assigned to *all* elided output lifetimes.-->
   パラメータに使用されているライフタイムが1つだけ（省略されているかどうかにかかわらず）、そのライフタイムが省略された*すべての*出力ライフタイムに割り当てられます。

<!--In method signatures there is another rule-->
メソッドのシグネチャには別の規則があります

* <!--If the receiver has type `&Self` or `&mut Self`, then the lifetime of that reference to `Self` is assigned to all elided output lifetime parameters.-->
   受信機は、入力がある場合`&Self`又は`&mut Self`、その後にその参照の寿命`Self`全て省略さ出力寿命パラメータに割り当てられています。

<!--Examples:-->
例：

```rust,ignore
#//fn print(s: &str);                                      // elided
fn print(s: &str);                                      // 逃げた
#//fn print(s: &'_ str);                                   // also elided
fn print(s: &'_ str);                                   // また、
#//fn print<'a>(s: &'a str);                               // expanded
fn print<'a>(s: &'a str);                               // 拡張された

#//fn debug(lvl: usize, s: &str);                          // elided
fn debug(lvl: usize, s: &str);                          // 逃げた
#//fn debug<'a>(lvl: usize, s: &'a str);                   // expanded
fn debug<'a>(lvl: usize, s: &'a str);                   // 拡張された

#//fn substr(s: &str, until: usize) -> &str;               // elided
fn substr(s: &str, until: usize) -> &str;               // 逃げた
#//fn substr<'a>(s: &'a str, until: usize) -> &'a str;     // expanded
fn substr<'a>(s: &'a str, until: usize) -> &'a str;     // 拡張された

#//fn get_str() -> &str;                                   // ILLEGAL
fn get_str() -> &str;                                   // 不当

#//fn frob(s: &str, t: &str) -> &str;                      // ILLEGAL
fn frob(s: &str, t: &str) -> &str;                      // 不当

#//fn get_mut(&mut self) -> &mut T;                        // elided
fn get_mut(&mut self) -> &mut T;                        // 逃げた
#//fn get_mut<'a>(&'a mut self) -> &'a mut T;              // expanded
fn get_mut<'a>(&'a mut self) -> &'a mut T;              // 拡張された

#//fn args<T: ToCStr>(&mut self, args: &[T]) -> &mut Command;                  // elided
fn args<T: ToCStr>(&mut self, args: &[T]) -> &mut Command;                  // 逃げた
#//fn args<'a, 'b, T: ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command; // expanded
fn args<'a, 'b, T: ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command; // 拡張された

#//fn new(buf: &mut [u8]) -> BufWriter<'_>;                // elided - preferred
fn new(buf: &mut [u8]) -> BufWriter<'_>;                // 省略された
#//fn new(buf: &mut [u8]) -> BufWriter;                    // elided
fn new(buf: &mut [u8]) -> BufWriter;                    // 逃げた
#//fn new<'a>(buf: &'a mut [u8]) -> BufWriter<'a>;         // expanded
fn new<'a>(buf: &'a mut [u8]) -> BufWriter<'a>;         // 拡張された

#//type FunPtr = fn(&str) -> &str;                         // elided
type FunPtr = fn(&str) -> &str;                         // 逃げた
#//type FunPtr = for<'a> fn(&'a str) -> &'a str;           // expanded
type FunPtr = for<'a> fn(&'a str) -> &'a str;           // 拡張された

#//type FunTrait = dyn Fn(&str) -> &str;                   // elided
type FunTrait = dyn Fn(&str) -> &str;                   // 逃げた
#//type FunTrait = dyn for<'a> Fn(&'a str) -> &'a str;     // expanded
type FunTrait = dyn for<'a> Fn(&'a str) -> &'a str;     // 拡張された
```

## <!--Default trait object lifetimes--> デフォルトの特性オブジェクトの存続期間

<!--The assumed lifetime of references held by a [trait object] is called its  _default object lifetime bound_ .-->
[trait object]によって保持される参照の仮定された存続時間は、その _デフォルトのオブジェクト有効期間_ と呼ばれ _ます_ 。
<!--These were defined in [RFC 599] and amended in [RFC 1156].-->
これらは[RFC 599]定義され、[RFC 1156]修正され[RFC 1156]。

<!--These default object lifetime bounds are used instead of the lifetime parameter elision rules defined above when the lifetime bound is omitted entirely.-->
有効期限が完全に省略されている場合、上記で定義された有効期限パラメータの抽出規則の代わりに、これらの既定のオブジェクト有効期限が使用されます。
<!--If `'_` is used as the lifetime bound then the bound follows the usual elision rules.-->
`'_`が生涯の拘束として使用される場合、拘束は通常の逃避の規則に従います。

<!--If the trait object is used as a type argument of a generic type then the containing type is first used to try to infer a bound.-->
特性オブジェクトがジェネリック型の型引数として使用されている場合、包含する型は最初にバインドを推測しようとするために使用されます。

* <!--If there is a unique bound from the containing type then that is the default-->
   包含する型からの一意の境界がある場合、それがデフォルトです
* <!--If there is more than one bound from the containing type then an explicit bound must be specified-->
   包含する型から複数のバウンドがある場合、明示的なバウンドを指定する必要があります

<!--If neither of those rules apply, then the bounds on the trait are used:-->
これらのルールのどちらも適用されない場合、特性の境界が使用されます。

* <!--If the trait is defined with a single lifetime  _bound_  then that bound is used.-->
   特性が単一の生涯の _境界で_ 定義されている場合、その境界が使用されます。
* <!--If `'static` is used for any lifetime bound then `'static` is used.-->
   `'static`が任意の生涯に使用されて`'static`場合は、`'static`が使用されます。
* <!--If the trait has no lifetime bounds, then the lifetime is inferred in expressions and is `'static` outside of expressions.-->
   特性が生涯の境界を持たない場合、生涯は表現の中で推論され、表現の外では`'static`である。

```rust,ignore
#// For the following trait...
// 次の特性のために...
trait Foo { }

#// These two are the same as Box<T> has no lifetime bound on T
// これら2つはBoxと同じです Tに生涯はありません
Box<dyn Foo>
Box<dyn Foo + 'static>

#// ...and so are these:
// ...これらもそうです：
impl dyn Foo {}
impl dyn Foo + 'static {}

#// ...so are these, because &'a T requires T: 'a
// ... TはTを必要とするので、これもそうです： 'a
&'a dyn Foo
&'a (dyn Foo + 'a)

#// std::cell::Ref<'a, T> also requires T: 'a, so these are the same
//  std:: cell:: Ref <'a、T>はTも必要です：' a、これは同じです
std::cell::Ref<'a, dyn Foo>
std::cell::Ref<'a, dyn Foo + 'a>

#// This is an error:
// これはエラーです：
struct TwoBounds<'a, 'b, T: ?Sized + 'a + 'b>
#//TwoBounds<'a, 'b, dyn Foo> // Error: the lifetime bound for this object type
#                           // cannot be deduced from context
TwoBounds<'a, 'b, dyn Foo> // エラー：このオブジェクトタイプの有効期間はコンテキストから推測できません
```

<!--Note that the innermost object sets the bound, so `&'a Box<dyn Foo>` is still `&'a Box<dyn Foo + 'static>`.-->
最も内側のオブジェクトがバインドを設定するので、`&'a Box<dyn Foo>`はまだ`&'a Box<dyn Foo + 'static>`です。

```rust,ignore
#// For the following trait...
// 次の特性のために...
trait Bar<'a>: 'a { }

#// ...these two are the same:
// ...これら2つは同じです：
Box<dyn Bar<'a>>
Box<dyn Bar<'a> + 'a>

#// ...and so are these:
// ...これらもそうです：
impl<'a> dyn Foo<'a> {}
impl<'a> dyn Foo<'a> + 'a {}

#// This is still an error:
// これはまだエラーです。
struct TwoBounds<'a, 'b, T: ?Sized + 'a + 'b>
TwoBounds<'a, 'b, dyn Foo<'c>>
```

## <!--`'static` lifetime elision--> `'static`寿命エリシジョン

<!--Both [constant] and [static] declarations of reference types have *implicit* `'static` lifetimes unless an explicit lifetime is specified.-->
明示的な存続期間が指定されていない限り、参照型の[constant]宣言と[static]宣言は両方とも*暗黙* `'static`存続時間を持ちます。
<!--As such, the constant declarations involving `'static` above may be written without the lifetimes.-->
そのようなものとして、上記`'static`宣言は、生存期間なしで記述することができます。

```rust
#// STRING: &'static str
//  STRING：＆ 'static str
const STRING: &str = "bitstring";

struct BitsNStrings<'a> {
    mybits: [u32; 2],
    mystring: &'a str,
}

#// BITS_N_STRINGS: BitsNStrings<'static>
//  BITS_N_STRINGS：BitsNStrings <'static>
const BITS_N_STRINGS: BitsNStrings<'_> = BitsNStrings {
    mybits: [1, 2],
    mystring: STRING,
};
```

<!--Note that if the `static` or `const` items include function or closure references, which themselves include references, the compiler will first try the standard elision rules.-->
場合があります`static`または`const`項目自体が参照を含む関数やクロージャの参照が含まれ、コンパイラは最初の標準エリジオンルールをしようとします。
<!--If it is unable to resolve the lifetimes by its usual rules, then it will error.-->
寿命が通常のルールで解決できない場合は、エラーになります。
<!--By way of example:-->
例として：

```rust,ignore
#// Resolved as `fn<'a>(&'a str) -> &'a str`.
//  `fn<'a>(&'a str) -> &'a str`。
const RESOLVED_SINGLE: fn(&str) -> &str = ..

#// Resolved as `Fn<'a, 'b, 'c>(&'a Foo, &'b Bar, &'c Baz) -> usize`.
//  `Fn<'a, 'b, 'c>(&'a Foo, &'b Bar, &'c Baz) -> usize`。
const RESOLVED_MULTIPLE: &dyn Fn(&Foo, &Bar, &Baz) -> usize = ..

#// There is insufficient information to bound the return reference lifetime
#// relative to the argument lifetimes, so this is an error.
// 引数の存続期間と比較してリターン参照のライフタイムを束縛する情報が不十分であるため、これはエラーです。
const RESOLVED_STATIC: &dyn Fn(&Foo, &Bar) -> &Baz = ..
```

<!--[closure trait]: types.html#closure-types
 [constant]: items/constant-items.html
 [function item]: types.html#function-item-types
 [function pointer]: types.html#function-pointer-types
 [implementation]: items/implementations.html
 [RFC 599]: https://github.com/rust-lang/rfcs/blob/master/text/0599-default-object-bound.md
 [RFC 1156]: https://github.com/rust-lang/rfcs/blob/master/text/1156-adjust-default-object-bounds.md
 [static]: items/static-items.html
 [trait object]: types.html#trait-objects
 [type aliases]: items/type-aliases.html
-->
[closure trait]: types.html#closure-types
 [constant]: items/constant-items.html
 [function item]: types.html#function-item-types
 [function pointer]: types.html#function-pointer-types
 [implementation]: items/implementations.html
 [RFC 599]: https://github.com/rust-lang/rfcs/blob/master/text/0599-default-object-bound.md
 [RFC 1156]: https://github.com/rust-lang/rfcs/blob/master/text/1156-adjust-default-object-bounds.md
 [static]: items/static-items.html
 [trait object]: types.html#trait-objects
 [type aliases]: items/type-aliases.html

