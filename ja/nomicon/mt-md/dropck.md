# <!--Drop Check--> ドロップチェック

<!--We have seen how lifetimes provide us some fairly simple rules for ensuring that we never read dangling references.-->
私たちは、生涯がどのように私たちにダングリングリファレンスを読んでいないことを保証するためのかなり簡単なルールを提供しているかを見てきました。
<!--However up to this point we have only ever interacted with the *outlives* relationship in an inclusive manner.-->
しかし、現時点までに包括的な方法で*アウトライフの*関係と交流してきました。
<!--That is, when we talked about `'a: 'b`, it was ok for `'a` to live *exactly* as long as `'b`.-->
それは我々がの話するとき、ある`'a: 'b`のために、それはOKだった`'a` *正確に*限り、生きるために`'b`。
<!--At first glance, this seems to be a meaningless distinction.-->
一見すると、これは無意味な区別のようです。
<!--Nothing ever gets dropped at the same time as another, right?-->
他の時間と同じ時間に落とされることはありませんか？
<!--This is why we used the following desugaring of `let` statements:-->
これが、`let`文の以下のような理由からです。

```rust,ignore
let x;
let y;
```

```rust,ignore
{
    let x;
    {
        let y;
    }
}
```

<!--Each creates its own scope, clearly establishing that one drops before the other.-->
それぞれは独自のスコープを作成し、一方が他方に先んじることを明示します。
<!--However, what if we do the following?-->
しかし、私たちが次のことをすればどうなるでしょうか？

```rust,ignore
let (x, y) = (vec![], vec![]);
```

<!--Does either value strictly outlive the other?-->
どちらか一方の値が他方の値よりも長生きしていますか？
<!--The answer is in fact *no*, neither value strictly outlives the other.-->
答えは実際には*いいえ*、どちらの値も厳密には他の値よりも長くはなりません。
<!--Of course, one of x or y will be dropped before the other, but the actual order is not specified.-->
もちろん、xまたはyのいずれかが他のものの前に落とされますが、実際の順序は指定されません。
<!--Tuples aren't special in this regard;-->
タプルはこの点で特別なものではありません。
<!--composite structures just don't guarantee their destruction order as of Rust 1.0.-->
複合構造はRust 1.0の破壊順序を保証するものではありません。

<!--We *could* specify this for the fields of built-in composites like tuples and structs.-->
タプルや構造体のような組み込み複合体のフィールドにこれを指定する*ことができ*ます。
<!--However, what about something like Vec?-->
しかし、Vecのようなものはどうですか？
<!--Vec has to manually drop its elements via pure-library code.-->
Vecは純粋なライブラリコードを使って要素を手動でドロップしなければなりません。
<!--In general, anything that implements Drop has a chance to fiddle with its innards during its final death knell.-->
一般的に、ドロップを実装するものは、最終的な死の刻みの中で、その内臓とバイディングするチャンスがあります。
<!--Therefore the compiler can't sufficiently reason about the actual destruction order of the contents of any type that implements Drop.-->
したがって、コンパイラは、Dropを実装するすべての型の内容の実際の破棄順序について十分に理由を付けることはできません。

<!--So why do we care?-->
ではなぜ私たちは気にしますか？
<!--We care because if the type system isn't careful, it could accidentally make dangling pointers.-->
タイプシステムが慎重でないと、誤ってペンダントがつぶれてしまう可能性があるので注意してください。
<!--Consider the following simple program:-->
以下の簡単なプログラムを考えてみましょう。

```rust
struct Inspector<'a>(&'a u8);

fn main() {
    let (inspector, days);
    days = Box::new(1);
    inspector = Inspector(&days);
}
```

<!--This program is totally sound and compiles today.-->
このプログラムは完全に健全で今日コンパイルされています。
<!--The fact that `days` does not *strictly* outlive `inspector` doesn't matter.-->
`days`が*厳密に* `inspector`よりも長生きしないという事実は重要ではない。
<!--As long as the `inspector` is alive, so is days.-->
`inspector`が生きている限り、それは日です。

<!--However if we add a destructor, the program will no longer compile!-->
しかし、デストラクタを追加すると、プログラムはコンパイルされなくなります。

```rust,ignore
struct Inspector<'a>(&'a u8);

impl<'a> Drop for Inspector<'a> {
    fn drop(&mut self) {
        println!("I was only {} days from retirement!", self.0);
    }
}

fn main() {
    let (inspector, days);
    days = Box::new(1);
    inspector = Inspector(&days);
#    // Let's say `days` happens to get dropped first.
#    // Then when Inspector is dropped, it will try to read free'd memory!
    // 最初に落ちる`days`があるとしましょう。インスペクタが落とされたら、それは自由なメモリを読み込もうとします！
}
```

```text
error: `days` does not live long enough
  --> <anon>:15:1
   |
12 |     inspector = Inspector(&days);
   |                            ---- borrow occurs here
...
15 | }
   | ^ `days` dropped here while still borrowed
   |
   = note: values in a scope are dropped in the opposite order they are created

error: aborting due to previous error
```

<!--Implementing `Drop` lets the `Inspector` execute some arbitrary code during its death.-->
`Drop`実装することで、`Inspector`は死に至る間に任意のコードを実行することができます。
<!--This means it can potentially observe that types that are supposed to live as long as it does actually were destroyed first.-->
つまり、最初に実際に破壊されている限り、生きているはずのタイプを潜在的に観察することができます。

<!--Interestingly, only generic types need to worry about this.-->
興味深いことに、ジェネリック型だけがこれについて心配する必要があります。
<!--If they aren't generic, then the only lifetimes they can harbor are `'static`, which will truly live *forever*.-->
彼らが一般的でない場合、彼らが抱くことができる唯一の生涯は`'static`であり、本当に*永遠に*生きるでしょ*う*。
<!--This is why this problem is referred to as *sound generic drop*.-->
これが、この問題を*健全な一般的なドロップ*と呼ぶ理由です。
<!--Sound generic drop is enforced by the *drop checker*.-->
健全な一般的なドロップは、*ドロップチェッカー*によって強制されます。
<!--As of this writing, some of the finer details of how the drop checker validates types is totally up in the air.-->
この記事の執筆時点では、ドロップ・チェッカーがタイプを検証する方法の細かい詳細のいくつかは、全面的に上がっています。
<!--However The Big Rule is the subtlety that we have focused on this whole section:-->
しかし、ビッグ・ルールはこの全セクションに焦点を当てた微妙なものです。

<!--**For a generic type to soundly implement drop, its generics arguments must strictly outlive it.**-->
**ジェネリック型が健全にdropを実装するためには、ジェネリック型の引数は厳密にそれよりも長くなければなりません。**

<!--Obeying this rule is (usually) necessary to satisfy the borrow checker;-->
このルールに従うことは、（通常）借用チェッカーを満たすために必要です。
<!--obeying it is sufficient but not necessary to be sound.-->
それに従うことは十分ですが、健全である必要はありません。
<!--That is, if your type obeys this rule then it's definitely sound to drop.-->
つまり、あなたのタイプがこのルールに従えば、間違いなく落ちるはずです。

<!--The reason that it is not always necessary to satisfy the above rule is that some Drop implementations will not access borrowed data even though their type gives them the capability for such access.-->
上記のルールを必ずしも満たす必要はないという理由は、Dropの実装によっては、借用されたデータにそのタイプがアクセスできるようになっていてもアクセスできないためです。

<!--For example, this variant of the above `Inspector` example will never access borrowed data:-->
たとえば、上記の`Inspector`例のこの変形は、借用したデータには決してアクセスしません。

```rust,ignore
struct Inspector<'a>(&'a u8, &'static str);

impl<'a> Drop for Inspector<'a> {
    fn drop(&mut self) {
        println!("Inspector(_, {}) knows when *not* to inspect.", self.1);
    }
}

fn main() {
    let (inspector, days);
    days = Box::new(1);
    inspector = Inspector(&days, "gadget");
#    // Let's say `days` happens to get dropped first.
#    // Even when Inspector is dropped, its destructor will not access the
#    // borrowed `days`.
    // 最初に落ちる`days`があるとしましょう。インスペクタが落とされても、デストラクタは借用`days`アクセスしません。
}
```

<!--Likewise, this variant will also never access borrowed data:-->
同様に、この亜種は借用したデータにもアクセスしません。

```rust,ignore
use std::fmt;

struct Inspector<T: fmt::Display>(T, &'static str);

impl<T: fmt::Display> Drop for Inspector<T> {
    fn drop(&mut self) {
        println!("Inspector(_, {}) knows when *not* to inspect.", self.1);
    }
}

fn main() {
    let (inspector, days): (Inspector<&u8>, Box<u8>);
    days = Box::new(1);
    inspector = Inspector(&days, "gadget");
#    // Let's say `days` happens to get dropped first.
#    // Even when Inspector is dropped, its destructor will not access the
#    // borrowed `days`.
    // 最初に落ちる`days`があるとしましょう。インスペクタが落とされても、デストラクタは借用`days`アクセスしません。
}
```

<!--However, *both* of the above variants are rejected by the borrow checker during the analysis of `fn main`, saying that `days` does not live long enough.-->
しかし、`fn main`の分析中に、上記の*両方*のバリエーションが借用チェッカーによって拒否され、`days`が十分に長くは生きていないと言っています。

<!--The reason is that the borrow checking analysis of `main` does not know about the internals of each `Inspector` 's `Drop` implementation.-->
その理由は、`main` borrow checkingの分析では、`Inspector`の`Drop`実装の内部についてはわからないからです。
<!--As far as the borrow checker knows while it is analyzing `main`, the body of an inspector's destructor might access that borrowed data.-->
借用チェッカーが`main`解析中に知っている限り、インスペクタのデストラクタの本体はその借用したデータにアクセスする可能性があります。

<!--Therefore, the drop checker forces all borrowed data in a value to strictly outlive that value.-->
したがって、ドロップチェッカーは、すべての借用データを強制的にその値よりも長く維持するようにします。

# <!--An Escape Hatch--> エスケープハッチ

<!--The precise rules that govern drop checking may be less restrictive in the future.-->
ドロップチェックを管理する正確なルールは、今後制限の少ないものになります。

<!--The current analysis is deliberately conservative and trivial;-->
現在の分析は、故意に保守的で簡単です。
<!--it forces all borrowed data in a value to outlive that value, which is certainly sound.-->
その値の中のすべての借用データを強制的にその値よりも長くすることを強制します。

<!--Future versions of the language may make the analysis more precise, to reduce the number of cases where sound code is rejected as unsafe.-->
将来のバージョンの言語では、サウンドコードが安全でないとして拒否されるケースの数を減らすために、解析をより正確に行うことができます。
<!--This would help address cases such as the two `Inspector` s above that know not to inspect during destruction.-->
これは、破壊中に検査しないことを知っている上記の2人の`Inspector`のような場合に役立ちます。

<!--In the meantime, there is an unstable attribute that one can use to assert (unsafely) that a generic type's destructor is *guaranteed* to not access any expired data, even if its type gives it the capability to do so.-->
その間に、ジェネリック型のデストラクタは、たとえその型がそれを行う能力を与えても、期限切れのデータにアクセスしないことが*保証さ*れている（不安全な）ことをアサーションするために使用できる不安定な属性があります。

<!--That attribute is called `may_dangle` and was introduced in [RFC 1327][rfc1327].-->
その属性は`may_dangle`と呼ばれ、[RFC 1327で][rfc1327]導入され[ました][rfc1327]。
<!--To deploy it on the `Inspector` example from above, we would write:-->
上記の`Inspector`例に展開するには、次のように記述します。

```rust,ignore
struct Inspector<'a>(&'a u8, &'static str);

unsafe impl<#[may_dangle] 'a> Drop for Inspector<'a> {
    fn drop(&mut self) {
        println!("Inspector(_, {}) knows when *not* to inspect.", self.1);
    }
}
```

<!--Use of this attribute requires the `Drop` impl to be marked `unsafe` because the compiler is not checking the implicit assertion that no potentially expired data (eg `self.0` above) is accessed.-->
この属性を使用すると、コンパイラーは潜在的に期限切れのデータ（上記の`self.0`）にアクセスしないという暗黙のアサーションをチェックし`unsafe`ため、`Drop` implが`unsafe`とマークする必要があります。

<!--The attribute can be applied to any number of lifetime and type parameters.-->
この属性は、任意の数の生存時間および型パラメータに適用することができる。
<!--In the following example, we assert that we access no data behind a reference of lifetime `'b` and that the only uses of `T` will be moves or drops, but omit the attribute from `'a` and `U`, because we do access data with that lifetime and that type:-->
次の例では、生存時間`'b`参照の背後にあるデータにはアクセスしないと主張し、`T`の唯一の使用は移動または削除ですが、`'a`および`'a` `U` `'a`の属性は省略します。そのタイプ：

```rust,ignore
use std::fmt::Display;

struct Inspector<'a, 'b, T, U: Display>(&'a u8, &'b u8, T, U);

unsafe impl<'a, #[may_dangle] 'b, #[may_dangle] T, U: Display> Drop for Inspector<'a, 'b, T, U> {
    fn drop(&mut self) {
        println!("Inspector({}, _, _, {})", self.0, self.3);
    }
}
```

<!--It is sometimes obvious that no such access can occur, like the case above.-->
上記のようなアクセスが発生しないことが時々明らかです。
<!--However, when dealing with a generic type parameter, such access can occur indirectly.-->
しかし、ジェネリック型パラメータを扱う場合、そのようなアクセスは間接的に発生する可能性があります。
<!--Examples of such indirect access are:-->
このような間接アクセスの例は次のとおりです。

 * <!--invoking a callback,-->
    コールバックを呼び出す、
 * <!--via a trait method call.-->
    traitメソッド呼び出しを介して

<!--(Future changes to the language, such as impl specialization, may add other avenues for such indirect access.)-->
（implの専門化のような将来の言語の変更は、間接的なアクセスのための他の手段を追加する可能性があります。）

<!--Here is an example of invoking a callback:-->
コールバックを呼び出す例を次に示します。

```rust,ignore
struct Inspector<T>(T, &'static str, Box<for <'r> fn(&'r T) -> String>);

impl<T> Drop for Inspector<T> {
    fn drop(&mut self) {
#        // The `self.2` call could access a borrow e.g. if `T` is `&'a _`.
        //  `self.2`呼び出しは、例えば`T`が`&'a _`場合、`self.2`アクセスすることができます。
        println!("Inspector({}, {}) unwittingly inspects expired data.",
                 (self.2)(&self.0), self.1);
    }
}
```

<!--Here is an example of a trait method call:-->
以下は、traitメソッド呼び出しの例です：

```rust,ignore
use std::fmt;

struct Inspector<T: fmt::Display>(T, &'static str);

impl<T: fmt::Display> Drop for Inspector<T> {
    fn drop(&mut self) {
#        // There is a hidden call to `<T as Display>::fmt` below, which
#        // could access a borrow e.g. if `T` is `&'a _`
        // 下の`<T as Display>::fmt`への隠し呼び出しがあります。これは、`T`が`&'a _`
        println!("Inspector({}, {}) unwittingly inspects expired data.",
                 self.0, self.1);
    }
}
```

<!--And of course, all of these accesses could be further hidden within some other method invoked by the destructor, rather than being written directly within it.-->
もちろん、これらのアクセスはすべて、デストラクタによって呼び出される他のメソッドの中に隠される可能性があります。

<!--In all of the above cases where the `&'a u8` is accessed in the destructor, adding the `#[may_dangle]` attribute makes the type vulnerable to misuse that the borrower checker will not catch, inviting havoc.-->
上記のすべての場合`&'a u8`がアクセスされた場合、`#[may_dangle]`属性を追加すると、借り手のチェッカーがキャッチしないような誤用を受けやすくなります。
<!--It is better to avoid adding the attribute.-->
属性の追加を避ける方が良いでしょう。

# <!--Is that all about drop checker?--> それはすべてのドロップチェッカーについてですか？

<!--It turns out that when writing unsafe code, we generally don't need to worry at all about doing the right thing for the drop checker.-->
安全でないコードを書くときには、一般的に落としチェッカーのための正しいことを心配する必要はありません。
<!--However there is one special case that you need to worry about, which we will look at in the next section.-->
しかし、あなたが心配する必要がある特別なケースが1つあります。これについては、次のセクションで説明します。

[rfc1327]: https://github.com/rust-lang/rfcs/blob/master/text/1327-dropck-param-eyepatch.md
