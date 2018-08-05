# <!--Path clarity--> パスの明快さ

<!--The module system is often one of the hardest things for people new to Rust.-->
モジュールシステムは、多くの場合、Rustを初めて使う人にとって最も難しいものの1つです。
<!--Everyone has their own things that take time to master, of course, but there's a root cause for why it's so confusing to many: while there are simple and consistent rules defining the module system, their consequences can feel inconsistent, counterintuitive and mysterious.-->
もちろん、モジュールシステムを定義するシンプルで一貫したルールがありますが、その結果は一貫性がなく、直観に反して不思議に感じることがあります。

<!--As such, the 2018 edition of Rust introduces a few new module system features, but they end up *simplifying* the module system, to make it more clear as to what is going on.-->
そのため、Rustの2018年版には、いくつかの新しいモジュールシステム機能が導入されていますが、モジュールシステムの*簡素化*によって、何が起こっているかがより明確になります。

<!--Here's a brief summary:-->
簡単な要約を以下に示します。

* <!--`extern crate` is no longer needed-->
   `extern crate`はもはや必要ありません
* <!--Absolute paths begin with a crate name, where the keyword `crate` refers to the current crate.-->
   絶対パスはクレート名で始まり、キーワード`crate`は現在のクレートを参照します。
* <!--The `crate` keyword also acts as a visibility modifier, equivalent to today's `pub(crate)`.-->
   `crate`キーワードは、今日の`pub(crate)`と同等の可視性変更子としても機能します。
* <!--A `foo.rs` and `foo/` subdirectory may coexist;-->
   `foo.rs`と`foo/`サブディレクトリは共存できます。
<!--`mod.rs` is no longer needed when placing submodules in a subdirectory.-->
   `mod.rs`は、サブディレクトリをサブディレクトリに置くときにはもはや必要ありません。

<!--These may seem like arbitrary new rules when put this way, but the mental model is now significantly simplified overall.-->
このようにした場合、これらは恣意的な新しい規則のように見えるかもしれませんが、メンタルモデルは全体的に大幅に単純化されています。
<!--Read on for more details!-->
詳細はこちらをお読みください！

## <!--More details--> 詳細

<!--Let's talk about each new feature in turn.-->
各新機能について順番に説明しましょう。

### <!--No more `extern crate`--> これ以上の`extern crate`

<!--This one is quite straightforward: you no longer need to write `extern crate` to import a crate into your project.-->
これは非常に簡単です：プロジェクトに`extern crate`をインポートするために`extern crate`を書く必要はなくなりました。
<!--Before:-->
前：

```rust,ignore
#// Rust 2015
//  2015年の錆

extern crate futures;

mod submodule {
    use futures::Future;
}
```

<!--After:-->
後：

```rust,ignore
#// Rust 2018
// 錆2018

mod submodule {
    use futures::Future;
}
```

<!--Now, to add a new crate to your project, you can add it to your `Cargo.toml`, and then there is no step two.-->
今度は、あなたのプロジェクトに新しいクレートを追加するために、それをあなたの`Cargo.toml`追加することができます。`Cargo.toml`、ステップ2はありません。
<!--If you're not using Cargo, you already had to pass `--extern` flags to give `rustc` the location of external crates, so you'd just keep doing what you were doing there as well.-->
あなたが貨物を使用していない場合、あなたはすでに合格しなければならなかった`--extern`与えるフラグを`rustc`外部の箱の場所を、あなたはちょうどあなたがそこにも何をしていたやり続けると思います。

<!--One other use for `extern crate` was to import macros;-->
`extern crate`もう一つの用途は、マクロをインポートすることでした。
<!--that's no longer needed.-->
それはもはや必要ではありません。
<!--Check [the macro section](2018/transitioning/modules/macros.html) for more.-->
詳細について[はマクロセクション](2018/transitioning/modules/macros.html)を[参照](2018/transitioning/modules/macros.html)してください。

### <!--Absolute paths begin with `crate` or the crate name--> 絶対パスは`crate`またはクレート名で始まります

<!--In Rust 2018, paths in `use` statements *must* begin with one of:-->
Rust 2018では、`use`ステートメントのパスは、次のいずれかで始まる*必要*が*あり*ます。

- <!--A crate name-->
   木箱の名前
- <!--`crate` for the current crate's root-->
   `crate`現在のクレートのルートについて
- <!--`self` for the current module's root-->
   現在のモジュールのルートのための`self`
- <!--`super` for the current module's parent-->
   現在のモジュールの親に対して`super`

<!--Code that looked like this:-->
次のようなコード

```rust,ignore
#// Rust 2015
//  2015年の錆

extern crate futures;

use futures::Future;

mod foo {
    struct Bar;
}

use foo::Bar;
```

<!--Now looks like this:-->
今のように見える：

```rust,ignore
#// Rust 2018
// 錆2018

#// 'futures' is the name of a crate
//  「先物」はクレートの名前です
use futures::Future;

mod foo {
    struct Bar;
}

#// 'crate' means the current crate
//  'クレート'は現在のクレートを意味します
use crate::foo::Bar;
```

<!--In addition, all of these path forms are available outside of `use` statements as well, which eliminates many sources of confusion.-->
さらに、これらのパス形式はすべて、`use`に関する記述の外でも`use`できます。これにより、多くの混乱の原因が排除されます。
<!--Consider this code in Rust 2015:-->
Rust 2015でこのコードを考えてみましょう。

```rust,ignore
#// Rust 2015
//  2015年の錆

extern crate futures;

mod submodule {
#    // this works!
    // これは動作します！
    use futures::Future;

#    // so why doesn't this work?
    // それでなぜこれは機能しないのですか？
    fn my_poll() -> futures::Poll { ... }
}

fn main() {
#    // this works
    // この作品
    let five = std::sync::Arc::new(5);
}

mod submodule {
    fn function() {
#        // ... so why doesn't this work
        // ...なぜ、これはうまくいかないのですか？
        let five = std::sync::Arc::new(5);
    }
}
```

<!--In the `futures` example, the `my_poll` function signature is incorrect, because `submodule` contains no items named `futures`;-->
`futures`例では、`submodule`に`futures`という名前の項目が含まれていないため、`my_poll`関数の署名が正しくありません。
<!--that is, this path is considered relative.-->
つまり、このパスは相対パスとみなされます。
<!--But because `use` is absolute, `use futures::` works even though a lone `futures::` doesn't!-->
しかし、`use`は絶対的なものなので、`use futures::`しかし、`futures::`してください！
<!--With `std` it can be even more confusing, as you never wrote the `extern crate std;`-->
`std`では、あなたは`extern crate std;`書いたことがないので、さらに混乱する可能性があり`extern crate std;`
<!--line at all.-->
まったく同じです。
<!--So why does it work in `main` but not in a submodule?-->
では、なぜ`main`ではなく、サブモジュールでは動作しますか？
<!--Same thing: it's a relative path because it's not in a `use` declaration.-->
同じこと： `use`宣言にないため、相対パスです。
`extern crate std;` <!--is inserted at the crate root, so it's fine in `main`, but it doesn't exist in the submodule at all.-->
クレートルートに挿入されているので、`main`では問題ありませんが、サブモジュールにはまったく存在しません。

<!--Let's look at how this change affects things:-->
この変更がどのように物事に影響を与えるかを見てみましょう：

```rust,ignore
#// Rust 2018
// 錆2018

#// no more `extern crate futures;`
//  `extern crate futures;`はもうありません`extern crate futures;`

mod submodule {
#    // 'futures' is the name of a crate, so this is absolute and works
    //  'futures'はクレートの名前なので、これは絶対的なものです
    use futures::Future;

#    // 'futures' is the name of a crate, so this is absolute and works
    //  'futures'はクレートの名前なので、これは絶対的なものです
    fn my_poll() -> futures::Poll { ... }
}

fn main() {
#    // 'std' is the name of a crate, so this is absolute and works
    //  'std'は木箱の名前なので、これは絶対的なものです
    let five = std::sync::Arc::new(5);
}

mod submodule {
    fn function() {
#        // 'std' is the name of a crate, so this is absolute and works
        //  'std'は木箱の名前なので、これは絶対的なものです
        let five = std::sync::Arc::new(5);
    }
}
```

<!--Much more straightforward.-->
はるかに簡単。

<!--**Note**: an alternative syntax is also under consideration: writing `::some::Local` rather than `crate::some::Local`.-->
**注**：別の構文も検討中です：crate `::some::Local`ではなく、writing `crate::some::Local`です。
<!--If you have thoughts about this alternative, please leave a comment on [the tracking issue](https://github.com/rust-lang/rust/issues/44660) or start a thread on the [edition feedback category](https://internals.rust-lang.org/c/edition-2018-feedback).-->
この代替案に関する考えがある場合は[、追跡の問題に](https://github.com/rust-lang/rust/issues/44660)コメントを残すか、[エディションのフィードバックカテゴリで](https://internals.rust-lang.org/c/edition-2018-feedback)スレッドを開始し[て](https://github.com/rust-lang/rust/issues/44660)ください。

### <!--The `crate` visibility modifier--> `crate`可視性修飾子

<!--In Rust 2015, you can use `pub(crate)` to make something visible to your entire crate, but not exported publicly:-->
2015年の錆では、`pub(crate)`を使用してクレート全体を見えるようにできますが、一般公開されません。

```rust
mod foo {
    pub mod bar {
        pub(crate) struct Foo;
    }
}

use foo::bar::Foo;
# fn main() {}
```

<!--In Rust 2018, the `crate` keyword is a synonym for this:-->
Rust 2018では、`crate`キーワードはこれと同義語です：

```rust,ignore
mod foo {
    pub mod bar {
        crate struct Foo;
    }
}

use foo::bar::Foo;
#fn main() {}
```

<!--This is a minor bit of syntax sugar, but makes using it feel much more natural.-->
これは構文砂糖の小さなビットですが、それを使用するのがはるかに自然な感じになります。

### <!--No more `mod.rs`--> `mod.rs`ありません

<!--In Rust 2015, if you have a submodule:-->
Rust 2015では、サブモジュールがある場合：

```rust,ignore
mod foo;
```

<!--It can live in `foo.rs` or `foo/mod.rs`.-->
`foo.rs`または`foo/mod.rs`に`foo.rs`ことができます。
<!--If it has submodules of its own, it *must* be `foo/mod.rs`.-->
独自のサブモジュールがある場合は、`foo/mod.rs`で*なければなりません*。
<!--So a `bar` submodule of `foo` would live at `foo/bar.rs`.-->
`foo` `bar`サブモジュールは`foo/bar.rs`ます。

<!--In Rust 2018, `mod.rs` is no longer needed.-->
Rust 2018では、`mod.rs`はもはや必要ありません。
<!--`foo.rs` can just be `foo.rs`, and the submodule is still `foo/bar.rs`.-->
`foo.rs`は`foo.rs`だけでも`foo.rs`ません。サブモジュールはまだ`foo/bar.rs`です。
<!--This eliminates the special name, and if you have a bunch of files open in your editor, you can clearly see their names, instead of having a bunch of tabs named `mod.rs`.-->
これにより、特別な名前がなくなり、エディタで開いているファイルがたくさんある場合は、`mod.rs`というタブの代わりに名前をはっきりと見ることができます。
