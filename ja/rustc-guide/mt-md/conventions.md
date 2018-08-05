<!--This file offers some tips on the coding conventions for rustc.-->
このファイルにはrustcのコーディング規則に関するヒントがいくつかあります。
<!--This chapter covers [formatting](#formatting), [coding for correctness](#cc), [using crates from crates.io](#cio), and some tips on [structuring your PR for easy review](#er).-->
この章では、[formatting](#formatting)、 [正確性のコーディング、](#cc) [crates.ioからの箱の使用](#cio) [、簡単な見直しのためにPRの構造](#er)に関するヒントについて説明し[ます](#er)。

<span id="formatting"></span>
# <!--Formatting and the tidy script--> 書式設定と整頓されたスクリプト

<!--rustc is slowly moving towards the [Rust standard coding style][fmt];-->
rustcはゆっくりと[Rust標準コーディングスタイルに][fmt]向かっています。
<!--at the moment, however, it follows a rather more *chaotic* style.-->
しかし、現時点では、それはかなり*混沌とした*スタイルに従います。
<!--We do have some mandatory formatting conventions, which are automatically enforced by a script we affectionately call the "tidy"script.-->
私たちはいくつかの強制的なフォーマット規則を持っています。これは、「きちんとした」スクリプトと呼んでいるスクリプトによって自動的に強制されます。
<!--The tidy script runs automatically when you do `./x.py test` and can be run in isolation with `./x.py test src/tools/tidy`.-->
あなたが行うとききちんとスクリプトが自動的に実行さ`./x.py test`してと分離して実行することができます`./x.py test src/tools/tidy`。

[fmt]: https://github.com/rust-lang-nursery/fmt-rfcs

<span id="copyright"></span>
### <!--Copyright notice--> 著作権表示

<!--All files must begin with the following copyright notice:-->
すべてのファイルは、次の著作権表示で始まる必要があります。

```rust
#// Copyright 2012-2013 The Rust Project Developers. See the COPYRIGHT
#// file at the top-level directory of this distribution and at
#// http://rust-lang.org/COPYRIGHT.
//  Copyright 2012-2013 Rustプロジェクトの開発者。このディストリビューションのトップレベルのディレクトリであるCOPYRIGHTファイルとhttp://rust-lang.org/COPYRIGHTを参照してください。
//
#// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
#// http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
#// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
#// option. This file may not be copied, modified, or distributed
#// except according to those terms.
//  Apache License、Version 2.0でライセンスまたはMITライセンス、あなたの選択で。このファイルは、これらの条項を除き、コピー、変更、または配布することはできません。
```

<!--The year at the top is not meaningful: copyright protections are in fact automatic from the moment of authorship.-->
一番上の年は意義深いものではありません。著作権の保護は実際に著作権の瞬間から自動化されています。
<!--We do not typically edit the years on existing files.-->
我々は、通常、既存のファイルの年を編集しません。
<!--When creating a new file, you can use the current year if you like, but you don't have to.-->
新しいファイルを作成するときは、今年を好きなときに使うことができますが、そうする必要はありません。

## <!--Line length--> 行の長さ

<!--Lines should be at most 100 characters.-->
行は100文字以下である必要があります。
<!--It's even better if you can keep things to 80.-->
あなたが物事を80に保つことができればさらに良いです。

<!--**Ignoring the line length limit.**-->
**行の長さの制限を無視します。**
<!--Sometimes – in particular for tests – it can be necessary to exempt yourself from this limit.-->
場合によっては、特にテストのために、この制限から免除する必要があります。
<!--In that case, you can add a comment towards the top of the file (after the copyright notice) like so:-->
その場合は、次のように（著作権表示の後に）ファイルの先頭にコメントを追加することができます：

```rust
#// ignore-tidy-linelength
//  ignore-tidy-linelength
```

## <!--Tabs vs spaces--> タブとスペース

<!--Prefer 4-space indent.-->
4-spaceインデントを推奨します。

<span id="cc"></span>
# <!--Coding for correctness--> 正確性のためのコーディング

<!--Beyond formatting, there are a few other tips that are worth following.-->
書式設定以外にも、次に従う価値のあるヒントがいくつかあります。

## <!--Prefer exhaustive matches--> 網羅的なマッチを好む

<!--Using `_` in a match is convenient, but it means that when new variants are added to the enum, they may not get handled correctly.-->
マッチで`_`を使用すると便利ですが、新しいバリアントが列挙型に追加されると、正しく処理されないことがあります。
<!--Ask yourself: if a new variant were added to this enum, what's the chance that it would want to use the `_` code, versus having some other treatment?-->
新しい列挙型がこの列挙型に追加された場合、`_`コードを使用する可能性はありますか？
<!--Unless the answer is "low", then prefer an exhaustive match.-->
答えが「低」でない限り、網羅的なマッチを好む。
<!--(The same advice applies to `if let` and `while let`, which are effectively tests for a single variant.)-->
`if let`と`while let`についても同様のアドバイスが適用されます。これは単一のバリアントを効果的にテストします。

## <!--Use "TODO"comments for things you don't want to forget--> あなたが忘れたくないものについては、「TODO」コメントを使用してください

<!--As a useful tool to yourself, you can insert a `// TODO` comment for something that you want to get back to before you land your PR:-->
あなた自身の役に立つツールとして、あなたはあなたのPRに着陸する前に戻ってほしいもののための`// TODO`コメントを挿入することができます：

```rust,ignore
fn do_something() {
    if something_else {
#//        unimplemented!(): // TODO write this
        unimplemented!(): //  TODOはこれを書きます
    }
}
```

<!--The tidy script will report an error for a `// TODO` comment, so this code would not be able to land until the TODO is fixed (or removed).-->
整頓されたスクリプトは`// TODO`コメントのエラーを報告するので、このコードはTODOが修正（または削除）されるまで上陸できません。

<!--This can also be useful in a PR as a way to signal from one commit that you are leaving a bug that a later commit will fix:-->
これは、後でコミットするバグを残していることを1つのコミットから通知する方法として、PRにも役立ちます。

```rust,ignore
if foo {
#//    return true; // TODO wrong, but will be fixed in a later commit
    return true; //  TODOは間違っていますが、後でコミットされる予定です
}
```

<span id="cio"></span>
# <!--Using crates from crates.io--> crates.ioからの箱を使用する

<!--It is allowed to use crates from crates.io, though external dependencies should not be added gratuitously.-->
外部依存関係は無償で追加するべきではありませんが、crates.ioの箱を使用することは許可されています。
<!--All such crates must have a suitably permissive license.-->
そのような箱はすべて、適切に許可されたライセンスを持っていなければなりません。
<!--There is an automatic check which inspects the Cargo metadata to ensure this.-->
これを確実にするために貨物のメタデータを検査する自動チェックがあります。

<span id="er"></span>
# <!--How to structure your PR--> PRの仕組み

<!--How you prepare the commits in your PR can make a big difference for the reviewer.-->
PRでコミットをどのように準備すれば、レビューアにとって大きな違いが生まれるでしょうか。
<!--Here are some tips.-->
ここにいくつかのヒントがあります。

<!--**Isolate "pure refactorings"into their own commit.**-->
**純粋なリファクタリングを自分のコミットに分離する。**
<!--For example, if you rename a method, then put that rename into its own commit, along with the renames of all the uses.-->
たとえば、メソッドの名前を変更した場合、その名前をすべての用途の名前とともに、独自のコミットに入れます。

<!--**More commits is usually better.**-->
**通常、より多くのコミットが優れています。**
<!--If you are doing a large change, it's almost always better to break it up into smaller steps that can be independently understood.-->
大きな変更を行っている場合は、独立して理解できる小さなステップに分割するほうがほぼ常に良いです。
<!--The one thing to be aware of is that if you introduce some code following one strategy, then change it dramatically (versus adding to it) in a later commit, that 'back-and-forth' can be confusing.-->
注意すべき点の1つは、ある戦略に従ったコードを導入し、その後のコミットでそれを大幅に変更すると、「前後」が混乱する可能性があるということです。

<!--**If you run rustfmt and the file was not already formatted, isolate that into its own commit.**-->
**rustfmtを実行していて、ファイルがまだフォーマットされていない場合、それを独自のコミットに分離します。**
<!--This is really the same as the previous rule, but it's worth highlighting.-->
これは以前のルールと実際は同じですが、強調する価値があります。
<!--It's ok to rustfmt files, but since we do not currently run rustfmt all the time, that can introduce a lot of noise into your commit.-->
rustfmtファイルは大丈夫ですが、現在はrustfmtを常に実行していないので、コミットに多くのノイズが入る可能性があります。
<!--Please isolate that into its own commit.-->
それを自分のコミットに分けてください。
<!--This also makes rebases a lot less painful, since rustfmt tends to cause a lot of merge conflicts, and having those isolated into their own commit makes them easier to resolve.-->
rustfmtは多くのマージ競合を引き起こす傾向があり、分離されたものを独自のコミットにすることで解決しやすくなるため、これによりリベースの苦労は大幅に軽減されます。

<!--**No merges.**-->
**合併はありません。**
<!--We do not allow merge commits into our history, other than those by bors.-->
我々は、borsによるものを除いて、マージコミットが私たちの歴史には入れられないようにしています。
<!--If you get a merge conflict, rebase instead via a command like `git rebase -i rust-lang/master` (presuming you use the name `rust-lang` for your remote).-->
マージの競合が発生した場合は、代わりに`git rebase -i rust-lang/master`ようなコマンドを使って`git rebase -i rust-lang/master`してください（あなたのリモートには`rust-lang`という名前を使用していると仮定します）。

<!--**Individual commits do not have to build (but it's nice).**-->
**個々のコミットはビルドする必要はありません（ただし、うれしいです）。**
<!--We do not require that every intermediate commit successfully builds – we only expect to be able to bisect at a PR level.-->
すべての中間コミットが成功する必要はありません。PRレベルで二等分することができます。
<!--However, if you *can* make individual commits build, that is always helpful.-->
ただし、個々のコミットをビルド*できる*場合は、常に役立ちます。

