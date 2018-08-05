# <!--if let--> もしlet

<!--For some use cases, when matching enums, `match` is awkward.-->
いくつかのユースケースでは、enumを`match`と、`match`は扱いにくいものになります。
<!--For example:-->
例えば：

```rust
#// Make `optional` of type `Option<i32>`
//  `optional`のタイプを作成する`Option<i32>`
let optional = Some(7);

match optional {
    Some(i) => {
        println!("This is a really long string and `{:?}`", i);
#        // ^ Needed 2 indentations just so we could destructure
#        // `i` from the option.
        //  ^ `i`はオプションから私を破棄することができるように2つのインデントを必要としました。
    },
    _ => {},
#    // ^ Required because `match` is exhaustive. Doesn't it seem
#    // like wasted space?
    //  ^ `match`が網羅的であるため必須です。それは無駄なスペースのように見えますか？
};

```

<!--`if let` is cleaner for this use case and in addition allows various failure options to be specified:-->
`if let`がこのユースケースでよりクリーンで、さらにさまざまな失敗オプションを指定できる場合：

```rust,editable
fn main() {
#    // All have type `Option<i32>`
    // すべての種類があります`Option<i32>`
    let number = Some(7);
    let letter: Option<i32> = None;
    let emoticon: Option<i32> = None;

#    // The `if let` construct reads: "if `let` destructures `number` into
#    // `Some(i)`, evaluate the block (`{}`).
    //  `if let`構文は次のようになります。"`let` some `Some(i)` `number`をdestructuresすると、ブロック（`{}`）が評価されます。
    if let Some(i) = number {
        println!("Matched {:?}!", i);
    }

#    // If you need to specify a failure, use an else:
    // 失敗を指定する必要がある場合は、else：
    if let Some(i) = letter {
        println!("Matched {:?}!", i);
    } else {
#        // Destructure failed. Change to the failure case.
        // 破壊に失敗しました。障害の場合に変更します。
        println!("Didn't match a number. Let's go with a letter!");
    };

#    // Provide an altered failing condition.
    // 変更された障害状態を提供します。
    let i_like_letters = false;

    if let Some(i) = emoticon {
        println!("Matched {:?}!", i);
#    // Destructure failed. Evaluate an `else if` condition to see if the
#    // alternate failure branch should be taken:
    // 破壊に失敗しました。`else if`条件を評価して、代替障害分岐を実行する必要があるかどうかを確認します。
    } else if i_like_letters {
        println!("Didn't match a number. Let's go with a letter!");
    } else {
#        // The condition evaluated false. This branch is the default:
        // 条件はfalseと評価されます。このブランチはデフォルトです。
        println!("I don't like letters. Let's go with an emoticon :)!");
    };
}
```

<!--In the same way, `if let` can be used to match any enum value:-->
同様に`if let`を使用して任意の列挙値を一致`if let`ことができる`if let`、次の`if let`なります。

```rust,editable
#// Our example enum
// 私たちの例enum
enum Foo {
    Bar,
    Baz,
    Qux(u32)
}

fn main() {
#    // Create example variables
    // サンプル変数を作成する
    let a = Foo::Bar;
    let b = Foo::Baz;
    let c = Foo::Qux(100);
    
#    // Variable a matches Foo::Bar
    // 変数aはFoo:: Barと一致します
    if let Foo::Bar = a {
        println!("a is foobar");
    }
    
#    // Variable b does not match Foo::Bar
#    // So this will print nothing
    // 変数bがFoo:: Barと一致しないので、何も印刷されません
    if let Foo::Bar = b {
        println!("b is foobar");
    }
    
#    // Variable c matches Foo::Qux which has a value
#    // Similar to Some() in the previous example
    // 変数cは、前の例のSome（）と同じ値を持つFoo:: Quxにマッチします。
    if let Foo::Qux(value) = c {
        println!("c is {}", value);
    }
}
```

### <!--See also:--> 参照：

<!--[`enum`][enum], [`Option`][option], and the [RFC][if_let_rfc]-->
[`enum`][enum]、 [`Option`][option]、および[RFC][if_let_rfc]

<!--[enum]: custom_types/enum.html
 [if_let_rfc]: https://github.com/rust-lang/rfcs/pull/160
 [option]: std/option.html
-->
[enum]: custom_types/enum.html
 [if_let_rfc]: https://github.com/rust-lang/rfcs/pull/160
 [option]: std/option.html

