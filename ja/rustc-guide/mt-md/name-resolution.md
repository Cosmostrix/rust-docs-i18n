# <!--Name resolution--> 名前解決

<!--The name resolution is a separate pass in the compiler.-->
名前解決は、コンパイラ内の別のパスです。
<!--Its input is the syntax tree, produced by parsing input files.-->
その入力は、入力ファイルを解析することによって生成された構文木です。
<!--It produces links from all the names in the source to relevant places where the name was introduced.-->
ソース内のすべての名前から、名前が導入された関連する場所へのリンクが作成されます。
<!--It also generates helpful error messages, like typo suggestions, traits to import or lints about unused items.-->
また、入力ミス、未使用アイテムのインポートやリントなどの有用なエラーメッセージも生成されます。

<!--A successful run of the name resolution (`Resolver::resolve_crate`) creates kind of an index the rest of the compilation may use to ask about the present names (through the `hir::lowering::Resolver` interface).-->
名前解決（`Resolver::resolve_crate`）の実行が成功すると、コンパイルの残りの部分が（ `hir::lowering::Resolver`インターフェースを介して）現在の名前について尋ねるために使用できるインデックスの種類が作成されます。

<!--The name resolution lives in the `librustc_resolve` crate, with the meat in `lib.rs` and some helpers or symbol-type specific logic in the other modules.-->
名前解決は`librustc_resolve`枠内にあり、`librustc_resolve`の肉と、他のモジュールのヘルパーやシンボル型の特定のロジックを`lib.rs`ます。

## <!--Namespaces--> 名前空間

<!--Different kind of symbols live in different namespaces ‒ eg.-->
異なる種類のシンボルは、異なる名前空間に存在します。
<!--types don't clash with variables.-->
型は変数と衝突しません。
<!--This usually doesn't happen, because variables start with lower-case letter while types with upper case one, but this is only a convention.-->
変数は小文字で始まり、大文字の型で始まるタイプなので、通常はこれは起こりませんが、これは慣例に過ぎません。
<!--This is legal Rust code that'll compile (with warnings):-->
これはコンパイルできる合法的な錆のコードです（警告付き）：

```rust
type x = u32;
let x: x = 1;
#//let y: x = 2; // See? x is still a type here.
let y: x = 2; // 見る？ xはまだここの型です。
```

<!--To cope with this, and with slightly different scoping rules for these namespaces, the resolver keeps them separated and builds separate structures for them.-->
これに対処するために、これらの名前空間のスコープの規則が少しずつ異なりますが、リゾルバはそれらを分離して保持し、それらのために別々の構造を構築します。

<!--In other words, when the code talks about namespaces, it doesn't mean the module hierarchy, it's types vs. values vs. macros.-->
言い換えれば、コードが名前空間について語るとき、それはモジュールの階層を意味するものではなく、型と値の対マクロです。

## <!--Scopes and ribs--> スコープとリブ

<!--A name is visible only in certain area in the source code.-->
名前は、ソースコードの特定の領域でのみ表示されます。
<!--This forms a hierarchical structure, but not necessarily a simple one ‒ if one scope is part of another, it doesn't mean the name visible in the outer one is also visible in the inner one, or that it refers to the same thing.-->
これは階層構造を形成しますが、必ずしも単純なものではありません。つまり、あるスコープが別のスコープの一部である場合、外側のスコープに表示されている名前も内側のスコープ内に表示されているか、同じものを参照しているわけではありません。

<!--To cope with that, the compiler introduces the concept of Ribs.-->
それに対処するために、コンパイラはRibsの概念を導入します。
<!--This is abstraction of a scope.-->
これはスコープの抽象です。
<!--Every time the set of visible names potentially changes, a new rib is pushed onto a stack.-->
表示される名前のセットが変更されるたびに、新しいリブがスタックにプッシュされます。
<!--The places where this can happen includes for example:-->
これが起こる可能性のある場所は、たとえば次のとおりです。

* <!--The obvious places ‒ curly braces enclosing a block, function boundaries, modules.-->
   明白な場所 -ブロック、関数境界、モジュールを囲む中括弧。
* <!--Introducing a let binding ‒ this can shadow another binding with the same name.-->
   letバインディングの導入 -これは、同じ名前の別のバインディングをシャドウすることができます。
* <!--Macro expansion border ‒ to cope with macro hygiene.-->
   Macro expansion border -マクロの衛生に対処する。

<!--When searching for a name, the stack of ribs is traversed from the innermost outwards.-->
名前を検索するとき、肋骨のスタックは最も内側から外側に横断されます。
<!--This helps to find the closest meaning of the name (the one not shadowed by anything else).-->
これは、名前の最も近い意味を見つけるのに役立ちます。
<!--The transition to outer rib may also change the rules what names are usable ‒ if there are nested functions (not closures), the inner one can't access parameters and local bindings of the outer one, even though they should be visible by ordinary scoping rules.-->
外側のリブへの遷移は、名前が使えるルールも変更することがあります。ネストされた関数（クロージャではない）があると、通常のスコープで見ることができるにもかかわらず、内側のものは外側のパラメータとローカルバインディングにアクセスできませんルール
<!--An example:-->
例：

```rust
#//fn do_something<T: Default>(val: T) { // <- New rib in both types and values (1)
fn do_something<T: Default>(val: T) { //  < -型と値の両方の新しいrib（1）
#    // `val` is accessible, as is the helper function
#    // `T` is accessible
    //  `val`はアクセス可能であり、ヘルパー関数`T`はアクセス可能である
#//    let helper = || { // New rib on `helper` (2) and another on the block (3)
    let helper = || { //  `helper`新しいリブ（2）とブロックの新しいリブ（3）
#        // `val` is accessible here
        //  `val`ここにアクセス可能です
#//    }; // End of (3)
    }; // （3）の終わり
#    // `val` is accessible, `helper` variable shadows `helper` function
    //  `val`はアクセス可能で、`helper`変数のシャドウ`helper`関数
#//    fn helper() { // <- New rib in both types and values (4)
    fn helper() { //  < -型と値の両方に新しいリブ（4）
#        // `val` is not accessible here, (4) is not transparent for locals)
#        // `T` is not accessible here
        // ここでは`val`アクセスできない、（4）地方には透明ではない）`T`はここではアクセスできない
#//    } // End of (4)
    } // （4）の終わり
#//    let val = T::default(); // New rib (5)
    let val = T::default(); // 新しいリブ（5）
#    // `val` is the variable, not the parameter here
    //  `val`は変数であり、ここではパラメータではありません
#//} // End of (5), (2) and (1)
} // （5）、（2）、（1）の終わり
```

<!--Because the rules for different namespaces are a bit different, each namespace has its own independent rib stack that is constructed in parallel to the others.-->
異なる名前空間の規則は少し異なりますので、各名前空間は他の名前空間と並行して構築された独自の独立したリブスタックを持っています。
<!--In addition, there's also a rib stack for local labels (eg. names of loops or blocks), which isn't a full namespace in its own right.-->
さらに、ローカルラベル用のリブスタック（ループやブロックの名前など）もありますが、これは完全な名前空間ではありません。

## <!--Overall strategy--> 全体的な戦略

<!--To perform the name resolution of the whole crate, the syntax tree is traversed top-down and every encountered name is resolved.-->
クレート全体の名前解決を実行するには、構文ツリーを上下に移動し、遭遇したすべての名前が解決されます。
<!--This works for most kinds of names, because at the point of use of a name it is already introduced in the Rib hierarchy.-->
これは名前の使用時にすでにRib階層に導入されているため、ほとんどの種類の名前に有効です。

<!--There are some exceptions to this.-->
これにはいくつかの例外があります。
<!--Items are bit tricky, because they can be used even before encountered ‒ therefore every block needs to be first scanned for items to fill in its Rib.-->
アイテムは遭遇する前であっても使用することができるため、少し厄介です。したがって、すべてのブロックを最初にスキャンして、その肋骨に記入する必要があります。

<!--Other, even more problematic ones, are imports which need recursive fixed-point resolution and macros, that need to be resolved and expanded before the rest of the code can be processed.-->
その他の問題のあるものは、再帰的な固定小数点の解決とマクロが必要なインポートです。残りのコードを処理できるようになる前に解決して展開する必要があります。

<!--Therefore, the resolution is performed in multiple stages.-->
したがって、解像度は多段階で行われる。

## <!--TODO:--> TODO：

<!--This is a result of the first pass of learning the code.-->
これは、コードを学習する最初の段階の結果です。
<!--It is definitely incomplete and not detailed enough.-->
間違いなく不完全であり、十分詳細ではない。
<!--It also might be inaccurate in places.-->
また、場所によっては不正確かもしれません。
<!--Still, it probably provides useful first guidepost to what happens in there.-->
それでも、そこで起こることに役立つ最初の目安を与えるでしょう。

* <!--What exactly does it link to and how is that published and consumed by following stages of compilation?-->
   それは正確に何にリンクされ、コンパイルの後続の段階でどのように公開され、消費されますか？
* <!--Who calls it and how it is actually used.-->
   誰がそれを呼び出し、どのように実際に使用されているか。
* <!--Is it a pass and then the result is only used, or can it be computed incrementally (eg. for RLS)?-->
   それは合格ですか、結果は唯一使用されるか、またはそれを段階的に計算できますか（例えばRLSの場合）？
* <!--The overall strategy description is a bit vague.-->
   全体的な戦略の説明は少し曖昧です。
* <!--Where does the name `Rib` come from?-->
   `Rib`の名前はどこから来たのですか？
* <!--Does this thing have its own tests, or is it tested only as part of some e2e testing?-->
   このものは独自のテストを持っていますか、または一部のe2eテストの一部としてのみテストされていますか？
