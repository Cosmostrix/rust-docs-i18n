# <!--Constructors--> コンストラクタ

<!--There is exactly one way to create an instance of a user-defined type: name it, and initialize all its fields at once:-->
ユーザー定義型のインスタンスを作成するには、名前を付けて、すべてのフィールドを一度に初期化するという方法があります。

```rust
struct Foo {
    a: u8,
    b: u32,
    c: bool,
}

enum Bar {
    X(u32),
    Y(bool),
}

struct Unit;

let foo = Foo { a: 0, b: 1, c: false };
let bar = Bar::X(0);
let empty = Unit;
```

<!--That's it.-->
それでおしまい。
<!--Every other way you make an instance of a type is just calling a totally vanilla function that does some stuff and eventually bottoms out to The One True Constructor.-->
あなたがタイプのインスタンスを作る他のすべての方法は、いくつかのものを行い、最終的にThe One True Constructorにボトムアウトする完全にバニラの関数を呼び出すことです。

<!--Unlike C++, Rust does not come with a slew of built-in kinds of constructor.-->
C ++とは異なり、Rustには数多くの組み込みのコンストラクタが付属していません。
<!--There are no Copy, Default, Assignment, Move, or whatever constructors.-->
コピー、デフォルト、割り当て、移動などのコンストラクタはありません。
<!--The reasons for this are varied, but it largely boils down to Rust's philosophy of *being explicit*.-->
これの理由は様々ですが、主にRustの哲学*に明示されてい*ます。

<!--Move constructors are meaningless in Rust because we don't enable types to "care"about their location in memory.-->
タイプのメモリ内の位置を「気にする」ことができないため、移動のコンストラクタは意味がありません。
<!--Every type must be ready for it to be blindly memcopied to somewhere else in memory.-->
すべてのタイプは、メモリ内の他の場所に盲目的にmemcopiedする準備ができている必要があります。
<!--This means pure on-the-stack-but-still-movable intrusive linked lists are simply not happening in Rust (safely).-->
これは、純粋なスタック上ではあるが、依然として移動可能な侵入型のリンクされたリストは、単にRust（安全に）では起こっていないことを意味します。

<!--Assignment and copy constructors similarly don't exist because move semantics are the only semantics in Rust.-->
割り当てセマンティクスとコピー・コンストラクタは同様に存在しません。これは、移動セマンティクスがRustの唯一のセマンティクスであるためです。
<!--At most `x = y` just moves the bits of y into the x variable.-->
せいぜい`x = y`はxの変数にyのビットを移動するだけです。
<!--Rust does provide two facilities for providing C++'s copy-oriented semantics: `Copy` and `Clone`.-->
Rustは、C ++の`Copy`指向セマンティクスを提供するための2つの機能を提供しています： `Copy`と`Clone`。
<!--Clone is our moral equivalent of a copy constructor, but it's never implicitly invoked.-->
クローンは、コピーコンストラクタと私たちの道徳的に同等ですが、暗黙のうちに呼び出されることはありません。
<!--You have to explicitly call `clone` on an element you want to be cloned.-->
`clone`する要素に対して明示的に`clone`を呼び出さなければなりません。
<!--Copy is a special case of Clone where the implementation is just "copy the bits".-->
コピーは、実装がちょうど "ビットをコピーする"場合のクローンの特別なケースです。
<!--Copy types *are* implicitly cloned whenever they're moved, but because of the definition of Copy this just means not treating the old copy as uninitialized --a no-op.-->
コピータイプ*は*移動されるたびに暗黙的に複製されますが、Copyの定義のために、これは古いコピーを初期化されていないものとして扱わないことを意味します。

<!--While Rust provides a `Default` trait for specifying the moral equivalent of a default constructor, it's incredibly rare for this trait to be used.-->
Rustはデフォルトのコンストラクタのモラル相当を指定する`Default`特性を提供しますが、この特性を使用することは非常にまれです。
<!--This is because variables [aren't implicitly initialized][uninit].-->
これは、変数[が暗黙的に初期化されていない][uninit]ためです。
<!--Default is basically only useful for generic programming.-->
デフォルトは、基本的には汎用プログラミングでのみ有効です。
<!--In concrete contexts, a type will provide a static `new` method for any kind of "default"constructor.-->
具体的な文脈では、ある型は任意の種類の「デフォルト」コンストラクタに対して静的`new`メソッドを提供します。
<!--This has no relation to `new` in other languages and has no special meaning.-->
これは他の言語では`new`は関係がなく、特別な意味はありません。
<!--It's just a naming convention.-->
それは単なる命名規則です。

<!--TODO: talk about "placement new"?-->
TODO： "placement new"について話しますか？

[uninit]: uninitialized.html
