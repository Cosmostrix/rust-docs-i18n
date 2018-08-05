# <!--Default match bindings--> デフォルトのマッチバインディング

<!--Have you ever had a borrowed `Option<T>` and tried to match on it?-->
あなたは借用された`Option<T>`を持っていて、それにマッチさせようとしましたか？
<!--You probably wrote this:-->
あなたはおそらくこれを書きました：

```rust,ignore
let s: &Option<String> = &Some("hello".to_string());

match s {
    Some(s) => println!("s is: {}", s),
    _ => (),
};
```

<!--In Rust 2015, this would fail to compile, and you would have to write the following instead:-->
Rust 2015では、これはコンパイルに失敗し、以下のように書く必要があります。

```rust,ignore
#// Rust 2015
//  2015年の錆

let s: &Option<String> = &Some("hello".to_string());

match s {
    &Some(ref s) => println!("s is: {}", s),
    _ => (),
};
```

<!--Rust 2018, by contrast, will infer the `&` s and `ref` s, and your original code will Just Work.-->
対照的に、Rust 2018は`&` sと`ref`を推測し、元のコードはJust Workとなります。

<!--This affects not just `match`, but patterns everywhere, such as in `let` statements, closure arguments, and `for` loops.-->
これは、単に`match`だけ`match`なく、`let`文、クロージャ引数、`for`ループなどのあらゆるところでパターンに影響`for`ます。

## <!--More details--> 詳細

<!--The mental model of patterns has shifted a bit with this change, to bring it into line with other aspects of the language.-->
パターンの精神モデルは、言語の他の側面と一致させるために、この変更で少しシフトしました。
<!--For example, when writing a `for` loop, you can iterate over borrowed contents of a collection by borrowing the collection itself:-->
たとえば、`for`ループを記述する`for`、コレクション自体を借用して、コレクションの借用されたコンテンツを反復処理できます。

```rust,ignore
let my_vec: Vec<i32> = vec![0, 1, 2];

for x in &my_vec { ... }
```

<!--The idea is that an `&T` can be understood as a *borrowed view of `T`*, and so when you iterate, match, or otherwise destructure a `&T` you get a borrowed view of its internals as well.-->
その考え方は、`&T`が*`T 'の借用ビュー*として理解できるということです。したがって、あなたが反復、マッチング、または他の方法で`&T`を破壊すると、内部の借用ビューも取得されます。

<!--More formally, patterns have a "binding mode,"which is either by value (`x`), by reference (`ref x`), or by mutable reference (`ref mut x`).-->
より形式的には、パターンは、値（`x`）、参照（ `ref x`）、または変更可能な参照（ `ref mut x`）のいずれかである「結合モード」を持ちます。
<!--In Rust 2015, `match` always started in by-value mode, and required you to explicitly write `ref` or `ref mut` in patterns to switch to a borrowing mode.-->
Rust 2015では、`match`常にby-valueモードで開始されており、借用モードに切り替えるために`ref`または`ref mut`をパターンで明示的に書く必要がありました。
<!--In Rust 2018, the type of the value being matched informs the binding mode, so that if you match against an `&Option<String>` with a `Some` variant, you are put into `ref` mode automatically, giving you a borrowed view of the internal data.-->
Rust 2018では、一致する値のタイプによってバインディングモードが通知されるため、`&Option<String>`と`Some`バリアントを照合すると、自動的に`ref`モードになり、内部データの借用ビューが得られます。
<!--Similarly, `&mut Option<String>` would give you a `ref mut` view.-->
同様に、`&mut Option<String>`を使用すると、`ref mut`ビューが得られます。
