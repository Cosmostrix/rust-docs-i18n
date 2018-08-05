# <!--Macros--> マクロ


<span id="c-evocative"></span><!--## Input syntax is evocative of the output (C-EVOCATIVE)-->
##入力構文は出力（C-EVOCATIVE）を喚起します。

<!--Rust macros let you dream up practically whatever input syntax you want.-->
錆のマクロは、あなたが望むどんな入力構文であっても実質的に夢を見ることができます。
<!--Aim to keep input syntax familiar and cohesive with the rest of your users' code by mirroring existing Rust syntax where possible.-->
可能であれば、既存のRust構文をミラーリングすることで、入力構文をユーザーのコードの他の部分とよく似合うようにしてください。
<!--Pay attention to the choice and placement of keywords and punctuation.-->
キーワードと句読点の選択と配置に注意してください。

<!--A good guide is to use syntax, especially keywords and punctuation, that is similar to what will be produced in the output of the macro.-->
マクロの出力で生成される構文に似た構文、特にキーワードと句読点を使用することをお勧めします。

<!--For example if your macro declares a struct with a particular name given in the input, preface the name with the keyword `struct` to signal to readers that a struct is being declared with the given name.-->
例えば、マクロが入力に与えられた特定の名前を持つ構造体を宣言している場合は、構造体が指定された名前で宣言されていることを読者に知らせるためにキーワード`struct`を名前に付けます。

```rust
#// Prefer this...
// これを好む...
bitflags! {
    struct S: u32 { /* ... */ }
}

#// ...over no keyword...
// ...キーワードなし...
bitflags! {
    S: u32 { /* ... */ }
}

#// ...or some ad-hoc word.
// ...またはいくつかの特別な言葉。
bitflags! {
    flags S: u32 { /* ... */ }
}
```

<!--Another example is semicolons vs commas.-->
もう1つの例はセミコロンとコンマです。
<!--Constants in Rust are followed by semicolons so if your macro declares a chain of constants, they should likely be followed by semicolons even if the syntax is otherwise slightly different from Rust's.-->
Rustの定数の後ろにセミコロンが続くので、マクロが定数の連鎖を宣言している場合は、構文がRustのものと若干異なる場合でもセミコロンが続かなければなりません。

```rust
#// Ordinary constants use semicolons.
// 通常の定数はセミコロンを使用します。
const A: u32 = 0b000001;
const B: u32 = 0b000010;

#// So prefer this...
// だからこれを好む...
bitflags! {
    struct S: u32 {
        const C = 0b000100;
        const D = 0b001000;
    }
}

#// ...over this.
// ...これ以上。
bitflags! {
    struct S: u32 {
        const E = 0b010000,
        const F = 0b100000,
    }
}
```

<!--Macros are so diverse that these specific examples won't be relevant, but think about how to apply the same principles to your situation.-->
マクロは非常に多様であり、これらの具体的な例は関連しませんが、あなたの状況に同じ原則を適用する方法を考えてください。


<span id="c-macro-attr"></span><!--## Item macros compose well with attributes (C-MACRO-ATTR)-->
##アイテムマクロは属性（C-MACRO-ATTR）でうまく構成されます。

<!--Macros that produce more than one output item should support adding attributes to any one of those items.-->
複数の出力項目を生成するマクロは、それらの項目のいずれかに属性を追加することをサポートする必要があります。
<!--One common use case would be putting individual items behind a cfg.-->
1つの一般的な使用例は、個々の項目をcfgの後ろに置くことです。

```rust
bitflags! {
    struct Flags: u8 {
        #[cfg(windows)]
        const ControlCenter = 0b001;
        #[cfg(unix)]
        const Terminal = 0b010;
    }
}
```

<!--Macros that produce a struct or enum as output should support attributes so that the output can be used with derive.-->
出力として構造体または列挙型を生成するマクロは、出力を派生させて使用できるように属性をサポートする必要があります。

```rust
bitflags! {
    #[derive(Default, Serialize)]
    struct Flags: u8 {
        const ControlCenter = 0b001;
        const Terminal = 0b010;
    }
}
```


<span id="c-anywhere"></span><!--## Item macros work anywhere that items are allowed (C-ANYWHERE)-->
##アイテムマクロは、アイテムが許可されている場所であればどこでも動作します（C-ANYWHERE）

<!--Rust allows items to be placed at the module level or within a tighter scope like a function.-->
錆は、アイテムをモジュールレベルに配置することも、機能のように狭い範囲に配置することもできます。
<!--Item macros should work equally well as ordinary items in all of these places.-->
アイテムマクロは、これらすべての場所の通常のアイテムと同じように機能するはずです。
<!--The test suite should include invocations of the macro in at least the module scope and function scope.-->
テストスイートには、少なくともモジュールスコープと関数スコープにマクロの呼び出しを含める必要があります。

```rust
#[cfg(test)]
mod tests {
    test_your_macro_in_a!(module);

    #[test]
    fn anywhere() {
        test_your_macro_in_a!(function);
    }
}
```

<!--As a simple example of how things can go wrong, this macro works great in a module scope but fails in a function scope.-->
どのように問題が起こるかの簡単な例として、このマクロはモジュールスコープでは機能しますが、関数スコープでは機能しません。

```rust
macro_rules! broken {
    ($m:ident :: $t:ident) => {
        pub struct $t;
        pub mod $m {
            pub use super::$t;
        }
    }
}

#//broken!(m::T); // okay, expands to T and m::T
broken!(m::T); // 大丈夫、Tとm:: Tに展開

fn g() {
#//    broken!(m::U); // fails to compile, super::U refers to the containing module not g
    broken!(m::U); // コンパイルに失敗した場合、super:: Uはgを含まないモジュールを参照します。
}
```


<span id="c-macro-vis"></span><!--## Item macros support visibility specifiers (C-MACRO-VIS)-->
##項目マクロは可視性指定子をサポートします（C-MACRO-VIS）

<!--Follow Rust syntax for visibility of items produced by a macro.-->
マクロによって生成された項目の可視性は、Rust構文に従います。
<!--Private by default, public if `pub` is specified.-->
`pub`が指定されている場合は、デフォルトで非公開です。

```rust
bitflags! {
    struct PrivateFlags: u8 {
        const A = 0b0001;
        const B = 0b0010;
    }
}

bitflags! {
    pub struct PublicFlags: u8 {
        const C = 0b0100;
        const D = 0b1000;
    }
}
```


<span id="c-macro-ty"></span><!--## Type fragments are flexible (C-MACRO-TY)-->
##タイプフラグメントは柔軟性があります（C-MACRO-TY）

<!--If your macro accepts a type fragment like `$t:ty` in the input, it should be usable with all of the following:-->
あなたのマクロが`$t:ty`ような型の断片を入力に受け入れるならば、それは以下のすべてで使えるはずです：

- <!--Primitives: `u8`, `&str`-->
   プリミティブ： `u8`、 `&str`
- <!--Relative paths: `m::Data`-->
   相対パス： `m::Data`
- <!--Absolute paths: `::base::Data`-->
   絶対パス`::base::Data`
- <!--Upward relative paths: `super::Data`-->
   上向きの相対パス： `super::Data`
- <!--Generics: `Vec<String>`-->
   ジェネリックス： `Vec<String>`

<!--As a simple example of how things can go wrong, this macro works great with primitives and absolute paths but fails with relative paths.-->
どのように問題が起こる可能性があるかの簡単な例として、このマクロはプリミティブと絶対パスではうまく動作しますが、相対パスでは失敗します。

```rust
macro_rules! broken {
    ($m:ident => $t:ty) => {
        pub mod $m {
            pub struct Wrapper($t);
        }
    }
}

#//broken!(a => u8); // okay
broken!(a => u8); // はい

#//broken!(b => ::std::marker::PhantomData<()>); // okay
broken!(b => ::std::marker::PhantomData<()>); // はい

struct S;
#//broken!(c => S); // fails to compile
broken!(c => S); // コンパイルに失敗する
```
