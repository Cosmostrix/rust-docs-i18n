# <!--Queries: demand-driven compilation--> クエリ：需要主導のコンパイル

<!--As described in [the high-level overview of the compiler][hl], the Rust compiler is current transitioning from a traditional "pass-based"setup to a "demand-driven"system.-->
[コンパイラの概要で][hl]説明し[た][hl]ように[、][hl] Rustコンパイラは、従来の「パスベース」のセットアップから「デマンド駆動」のシステムに移行しています。
<!--**The Compiler Query System is the key to our new demand-driven organization.**-->
**コンパイラクエリシステムは、新しい需要主導の組織の鍵です。**
<!--The idea is pretty simple.-->
アイデアはかなり簡単です。
<!--You have various queries that compute things about the input – for example, there is a query called `type_of(def_id)` that, given the def-id of some item, will compute the type of that item and return it to you.-->
たとえば、ある項目のdef-idを指定すると、`type_of(def_id)`というクエリがあり、その項目の型を計算して返すなど、入力に関するものを計算するさまざまなクエリがあります。

[hl]: high-level-overview.html

<!--Query execution is **memoized** – so the first time you invoke a query, it will go do the computation, but the next time, the result is returned from a hashtable.-->
クエリの実行は**メモされ**ます。最初にクエリを呼び出すと計算が実行されますが、次回はハッシュテーブルから結果が返されます。
<!--Moreover, query execution fits nicely into **incremental computation**;-->
さらに、クエリの実行は**インクリメンタルな計算に**うまく収まり**ます**。
<!--the idea is roughly that, when you do a query, the result **may** be returned to you by loading stored data from disk (but that's a separate topic we won't discuss further here).-->
その考えはおおまかに言えば、クエリを実行すると、格納されたデータをディスクからロードすることによって結果**が**返されることがあります（ただし、ここではこれ以上は説明しません）。

<!--The overall vision is that, eventually, the entire compiler control-flow will be query driven.-->
全体的なビジョンは、最終的に、コンパイラの制御フロー全体がクエリ駆動型であることです。
<!--There will effectively be one top-level query ("compile") that will run compilation on a crate;-->
効果的にクレートでコンパイルを実行するトップレベルクエリ（「コンパイル」）が1つあります。
<!--this will in turn demand information about that crate, starting from the *end*.-->
これは、*最終的に*、そのクレートについての情報を要求する。
<!--For example:-->
例えば：

- <!--This "compile"query might demand to get a list of codegen-units (ie modules that need to be compiled by LLVM).-->
   この "コンパイル"クエリは、codegen-units（すなわち、LLVMによってコンパイルされる必要があるモジュール）のリストを取得することを要求するかもしれません。
- <!--But computing the list of codegen-units would invoke some subquery that returns the list of all modules defined in the Rust source.-->
   しかしcodegen-unitsのリストを計算すると、Rustソースに定義されているすべてのモジュールのリストを返すサブクエリが呼び出されます。
- <!--That query in turn would invoke something asking for the HIR.-->
   その照会は、HIRを求める何かを呼び出すでしょう。
- <!--This keeps going further and further back until we wind up doing the actual parsing.-->
   これは、実際の解析を行うまで、さらに進んでいきます。

<!--However, that vision is not fully realized.-->
しかし、そのビジョンは完全には実現されていません。
<!--Still, big chunks of the compiler (for example, generating MIR) work exactly like this.-->
それでも、コンパイラの大きなチャンク（例えば、MIRを生成する）は、これとまったく同じように動作します。

### <!--Invoking queries--> クエリの呼び出し

<!--To invoke a query is simple.-->
クエリを呼び出すのは簡単です。
<!--The tcx ("type context") offers a method for each defined query.-->
tcx（"type context"）は、定義された各クエリのメソッドを提供します。
<!--So, for example, to invoke the `type_of` query, you would just do this:-->
たとえば、`type_of`クエリを呼び出すには、次のようにします。

```rust,ignore
let ty = tcx.type_of(some_def_id);
```

### <!--Cycles between queries--> クエリ間のサイクル数

<!--A cycle is when a query becomes stuck in a loop eg query A generates query B which generates query A again.-->
1つのサイクルは、クエリがループ内でスタックになった場合などです。たとえば、クエリAはクエリAを再度生成するクエリBを生成します。

<!--Currently, cycles during query execution should always result in a compilation error.-->
現在、クエリ実行中のサイクルでは、常にコンパイルエラーが発生します。
<!--Typically, they arise because of illegal programs that contain cyclic references they shouldn't (though sometimes they arise because of compiler bugs, in which case we need to factor our queries in a more fine-grained fashion to avoid them).-->
一般に、コンパイラのバグのために発生することはありますが、コンパイラのバグのために発生することもありますが、コンパイラのバグを避けるためには、より詳細なファクタをファクタ化する必要があります。

<!--However, it is nonetheless often useful to *recover* from a cycle (after reporting an error, say) and try to soldier on, so as to give a better user experience.-->
しかし、それでも、（エラーを報告した後に）サイクルから*回復*し、より良いユーザーエクスペリエンスを提供するために兵士に挑戦することはしばしば有益です。
<!--In order to recover from a cycle, you don't get to use the nice method-call-style syntax.-->
サイクルから回復するために、niceメソッド呼び出しスタイルの構文を使用する必要はありません。
<!--Instead, you invoke using the `try_get` method, which looks roughly like this:-->
代わりに、`try_get`メソッドを使用して呼び出します。これは、おおよそ次のようになります。

```rust,ignore
use ty::queries;
...
match queries::type_of::try_get(tcx, DUMMY_SP, self.did) {
  Ok(result) => {
#    // no cycle occurred! You can use `result`
    // サイクルは起こらなかった！ `result`を使用することができます
  }
  Err(err) => {
#    // A cycle occurred! The error value `err` is a `DiagnosticBuilder`,
#    // meaning essentially an "in-progress", not-yet-reported error message.
#    // See below for more details on what to do here.
    // サイクルが発生しました！エラー値`err`は`DiagnosticBuilder`であり、基本的には「進行中」で、まだ報告されていないエラーメッセージです。ここで何をするかの詳細については、以下を参照してください。
  }
}
```

<!--So, if you get back an `Err` from `try_get`, then a cycle *did* occur.-->
したがって、`try_get`から`Err`を`try_get`と、サイクル*が*発生しました。
<!--This means that you must ensure that a compiler error message is reported.-->
つまり、コンパイラーのエラーメッセージが確実に報告されるようにする必要があります。
<!--You can do that in two ways:-->
あなたは2つの方法でそれを行うことができます：

<!--The simplest is to invoke `err.emit()`.-->
最も簡単なのは、`err.emit()`を呼び出すこと`err.emit()`。
<!--This will emit the cycle error to the user.-->
これにより、サイクルエラーがユーザに出されます。

<!--However, often cycles happen because of an illegal program, and you know at that point that an error either already has been reported or will be reported due to this cycle by some other bit of code.-->
しかし、不正なプログラムのためにサイクルが頻繁に発生し、その時点でエラーが既に報告されているか、このサイクルのために他のコードによって報告されることがあります。
<!--In that case, you can invoke `err.cancel()` to not emit any error.-->
その場合、`err.cancel()`を呼び出してエラーを出さないようにすることができます。
<!--It is traditional to then invoke:-->
次にそれを呼び出すのは伝統的です。

```rust,ignore
tcx.sess.delay_span_bug(some_span, "some message")
```

<!--`delay_span_bug()` is a helper that says: we expect a compilation error to have happened or to happen in the future;-->
`delay_span_bug()`は、次のようなヘルパーです：コンパイルエラーが起こったか、将来起こることが予想されます。
<!--so, if compilation ultimately succeeds, make an ICE with the message `"some message"`.-->
したがって、コンパイルが最終的に成功した場合は、メッセージ`"some message"`を持つICEを作成します。
<!--This is basically just a precaution in case you are wrong.-->
これは基本的にあなたが間違っている場合の予防措置です。

### <!--How the compiler executes a query--> コンパイラによるクエリの実行方法

<!--So you may be wondering what happens when you invoke a query method.-->
したがって、クエリメソッドを呼び出すときに何が起こるのか不思議に思うかもしれません。
<!--The answer is that, for each query, the compiler maintains a cache – if your query has already been executed, then, the answer is simple: we clone the return value out of the cache and return it (therefore, you should try to ensure that the return types of queries are cheaply cloneable; insert a `Rc` if necessary).-->
その答えは、各クエリについて、コンパイラがキャッシュを保持していることです。クエリがすでに実行されていれば、その答えは簡単です。戻り値をキャッシュからクローン化して返します（したがって、戻り値の型は安価に複製可能である;必要に応じて`Rc`挿入する）。

#### <!--Providers--> プロバイダー

<!--If, however, the query is *not* in the cache, then the compiler will try to find a suitable **provider**.-->
ただし、クエリがキャッシュに*ない*場合、コンパイラは適切な**プロバイダ**を検索しようとします。
<!--A provider is a function that has been defined and linked into the compiler somewhere that contains the code to compute the result of the query.-->
プロバイダは、クエリの結果を計算するコードを含むコンパイラに定義され、リンクされている関数です。

<!--**Providers are defined per-crate.**-->
**プロバイダーはクレートごとに定義されています。**
<!--The compiler maintains, internally, a table of providers for every crate, at least conceptually.-->
コンパイラは、少なくとも概念的には、すべてのクレートのプロバイダのテーブルを内部的に保持します。
<!--Right now, there are really two sets: the providers for queries about the **local crate** (that is, the one being compiled) and providers for queries about **external crates** (that is, dependencies of the local crate).-->
現在、実際には2つのセットがあります。**ローカル・クレート**（つまり、コンパイルされているもの）に関する照会のプロバイダーと、 **外部クレート**（つまり、ローカル・クレートの依存関係）に関する照会のプロバイダーです。
<!--Note that what determines the crate that a query is targeting is not the *kind* of query, but the *key*.-->
クエリがターゲットとするクレートを決定するのは、クエリの*種類*ではなく、*キー*です。
<!--For example, when you invoke `tcx.type_of(def_id)`, that could be a local query or an external query, depending on what crate the `def_id` is referring to (see the `self::keys::Key` trait for more information on how that works).-->
たとえば、`tcx.type_of(def_id)`を呼び出すと、`def_id`が参照しているクレートに応じてローカルクエリまたは外部クエリになる可能性があります（`self::keys::Key`特性を参照してください）作品）。

<!--Providers always have the same signature:-->
プロバイダには常に同じシグネチャがあります。

```rust,ignore
fn provider<'cx, 'tcx>(tcx: TyCtxt<'cx, 'tcx, 'tcx>,
                       key: QUERY_KEY)
                       -> QUERY_RESULT
{
    ...
}
```

<!--Providers take two arguments: the `tcx` and the query key.-->
プロバイダには、`tcx`と`tcx` 2つの引数があります。
<!--Note also that they take the *global* tcx (ie they use the `'tcx` lifetime twice), rather than taking a tcx with some active inference context.-->
また、彼らは*グローバルな* tcxを取ることに注意してください（つまり、彼らはいくつかのアクティブ推論コンテキストでtcxを取るのではなく、`'tcx` lifetimeを2回使用します）。
<!--They return the result of the query.-->
彼らはクエリの結果を返します。

#### <!--How providers are setup--> プロバイダの設定方法

<!--When the tcx is created, it is given the providers by its creator using the `Providers` struct.-->
tcxが作成されると、`Providers`構造体を使用してその作成者によってプロバイダーが指定され`Providers`。
<!--This struct is generated by the macros here, but it is basically a big list of function pointers:-->
この構造体はここではマクロによって生成されますが、基本的には関数ポインタの大きなリストです：

```rust,ignore
struct Providers {
    type_of: for<'cx, 'tcx> fn(TyCtxt<'cx, 'tcx, 'tcx>, DefId) -> Ty<'tcx>,
    ...
}
```

<!--At present, we have one copy of the struct for local crates, and one for external crates, though the plan is that we may eventually have one per crate.-->
現時点では、ローカルクレート用の構造体と外部クレート用の構造体のコピーを1つ用意していますが、最終的にはクレートごとに1つずつ作成する予定です。

<!--These `Provider` structs are ultimately created and populated by `librustc_driver`, but it does this by distributing the work throughout the other `rustc_*` crates.-->
これらの`Provider`構造体は、`librustc_driver`によって最終的に作成され、`librustc_driver`され`librustc_driver`が、他の`rustc_*`箱全体に作業を分散することでこれを`rustc_*`。
<!--This is done by invoking various `provide` functions.-->
これは、さまざまな`provide`関数を呼び出すことによって行われます。
<!--These functions tend to look something like this:-->
これらの関数は次のようになります。

```rust,ignore
pub fn provide(providers: &mut Providers) {
    *providers = Providers {
        type_of,
        ..*providers
    };
}
```

<!--That is, they take an `&mut Providers` and mutate it in place.-->
つまり、`&mut Providers`、それを変更します。
<!--Usually we use the formulation above just because it looks nice, but you could as well do `providers.type_of = type_of`, which would be equivalent.-->
通常は上の`providers.type_of = type_of`を使っていますが、それはうまく見えますが、同様のものを`providers.type_of = type_of`とすることもできます。
<!--(Here, `type_of` would be a top-level function, defined as we saw before.) So, if we want to add a provider for some other query, let's call it `fubar`, into the crate above, we might modify the `provide()` function like so:-->
（ここでは、`type_of`我々の前に見たように定義されたトップレベルの関数で、となります。）だから、我々はいくつかの他のクエリのためのプロバイダを追加したい場合は、のは、それを呼びましょう`fubar`、上記木枠の中に、我々は変更する可能性`provide()`次のように機能します：

```rust,ignore
pub fn provide(providers: &mut Providers) {
    *providers = Providers {
        type_of,
        fubar,
        ..*providers
    };
}

fn fubar<'cx, 'tcx>(tcx: TyCtxt<'cx, 'tcx>, key: DefId) -> Fubar<'tcx> { ... }
```

<!--NB Most of the `rustc_*` crates only provide **local providers**.-->
注意`rustc_*`箱のほとんどは、**地元の提供者**のみを提供して**います**。
<!--Almost all **extern providers** wind up going through the [`rustc_metadata` crate][rustc_metadata], which loads the information from the crate metadata.-->
ほとんどすべての[`rustc_metadata`][rustc_metadata] **プロバイダ**は[`rustc_metadata`クレート][rustc_metadata]を通過し、クレートメタデータから情報をロードします。
<!--But in some cases there are crates that provide queries for *both* local and external crates, in which case they define both a `provide` and a `provide_extern` function that `rustc_driver` can invoke.-->
しかし、いくつかのケースではそれらが定義するどちらの場合には、ローカルと外部*の両方の*箱のためのクエリを提供箱がある`provide`し、`provide_extern`機能`rustc_driver`呼び出すことができますが。

[rustc_metadata]: https://github.com/rust-lang/rust/tree/master/src/librustc_metadata

### <!--Adding a new kind of query--> 新しい種類のクエリを追加する

<!--So suppose you want to add a new kind of query, how do you do so?-->
新しい種類のクエリを追加したいとします。どのようにそうしますか？
<!--Well, defining a query takes place in two steps:-->
さて、クエリの定義は2つのステップで行われます。

1. <!--first, you have to specify the query name and arguments;-->
    まず、クエリ名と引数を指定する必要があります。
<!--and then,-->
    その後、
2. <!--you have to supply query providers where needed.-->
    必要に応じてクエリプロバイダを提供する必要があります。

<!--To specify the query name and arguments, you simply add an entry to the big macro invocation in [`src/librustc/ty/query/mod.rs`][query-mod], which looks something like:-->
クエリ名と引数を指定するには、単純に[`src/librustc/ty/query/mod.rs`][query-mod]の大きなマクロ呼び出しにエントリを追加し[`src/librustc/ty/query/mod.rs`][query-mod]。

[query-mod]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/ty/query/index.html

```rust,ignore
define_queries! { <'tcx>
#//    /// Records the type of every item.
    /// 各項目の種類を記録します。
    [] fn type_of: TypeOfItem(DefId) -> Ty<'tcx>,

    ...
}
```

<!--Each line of the macro defines one query.-->
マクロの各行は1つのクエリを定義します。
<!--The name is broken up like this:-->
名前は次のように分かれています：

```rust,ignore
[] fn type_of: TypeOfItem(DefId) -> Ty<'tcx>,
^^    ^^^^^^^  ^^^^^^^^^^ ^^^^^     ^^^^^^^^
|     |        |          |         |
|     |        |          |         result type of query
|     |        |          query key type
|     |        dep-node constructor
|     name of query
query flags
```

<!--Let's go over them one by one:-->
それらを一つずつ上に行きましょう：

- <!--**Query flags:** these are largely unused right now, but the intention is that we'll be able to customize various aspects of how the query is processed.-->
   **クエリフラグ：**これらは現在ほとんど使われていませんが、クエリの処理方法のさまざまな側面をカスタマイズできるということです。
- <!--**Name of query:** the name of the query method (`tcx.type_of(..)`).-->
   **クエリ**の名前**：**クエリメソッドの名前（`tcx.type_of(..)`）。
<!--Also used as the name of a struct (`ty::queries::type_of`) that will be generated to represent this query.-->
   また、このクエリを表すために生成されるstruct（`ty::queries::type_of`）の名前としても使用されます。
- <!--**Dep-node constructor:** indicates the constructor function that connects this query to incremental compilation.-->
   **Dep-node constructor：**このクエリを増分コンパイルに接続するコンストラクタ関数を示します。
<!--Typically, this is a `DepNode` variant, which can be added by modifying the `define_dep_nodes!` macro invocation in [`librustc/dep_graph/dep_node.rs`][dep-node].-->
   典型的には、これは`DepNode`変更することによって追加することができる変異体、`define_dep_nodes!`マクロ呼び出し[`librustc/dep_graph/dep_node.rs`][dep-node]。
  - <!--However, sometimes we use a custom function, in which case the name will be in snake case and the function will be defined at the bottom of the file.-->
     ただし、カスタム関数を使用する場合があります。この場合、名前はスネークケースになり、関数はファイルの最後に定義されます。
<!--This is typically used when the query key is not a def-id, or just not the type that the dep-node expects.-->
     これは、通常、照会キーがdef-idでない場合、またはdep-nodeが予期しているタイプでない場合に使用されます。
- <!--**Query key type:** the type of the argument to this query.-->
   **クエリーキータイプ：**このクエリーの引数のタイプ。
<!--This type must implement the `ty::query::keys::Key` trait, which defines (for example) how to map it to a crate, and so forth.-->
   この型は`ty::query::keys::Key`特性を実装しなければなりません。これは（例えば）木箱にマップする方法などを定義します。
- <!--**Result type of query:** the type produced by this query.-->
   **クエリの結果の型：**このクエリによって生成される型。
<!--This type should (a) not use `RefCell` or other interior mutability and (b) be cheaply cloneable.-->
   このタイプは、（a）`RefCell`または他の内部の`RefCell`使用`RefCell`ず、（b）安価に複製可能でなければならない。
<!--Interning or using `Rc` or `Arc` is recommended for non-trivial data types.-->
   重大ではないデータ型には、インターンまたは`Rc`または`Arc`を使用することをお勧めします。
  - <!--The one exception to those rules is the `ty::steal::Steal` type, which is used to cheaply modify MIR in place.-->
     これらのルールの例外の1つは`ty::steal::Steal`タイプで、MIRを安価に修正するために使用されます。
<!--See the definition of `Steal` for more details.-->
     詳細については`Steal`の定義を参照してください。
<!--New uses of `Steal` should **not** be added without alerting `@rust-lang/compiler`.-->
     `Steal`新しい用途は、`@rust-lang/compiler`警告することなく追加するべきで**は**ありませ**ん**。

[dep-node]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/dep_graph/struct.DepNode.html

<!--So, to add a query:-->
したがって、クエリを追加するには：

- <!--Add an entry to `define_queries!` using the format above.-->
   上記の形式を使用して`define_queries!`エントリを追加します。
- <!--Possibly add a corresponding entry to the dep-node macro.-->
   可能であれば、dep-nodeマクロに対応するエントリを追加します。
- <!--Link the provider by modifying the appropriate `provide` method;-->
   適切な`provide`方法を変更してプロバイダをリンクします。
<!--or add a new one if needed and ensure that `rustc_driver` is invoking it.-->
   必要に応じて新しいものを追加して、`rustc_driver`が呼び出していることを確認して`rustc_driver`。

#### <!--Query structs and descriptions--> クエリの構造と説明

<!--For each kind, the `define_queries` macro will generate a "query struct"named after the query.-->
各種類について、`define_queries`マクロはクエリの後に指定された "query struct"を生成します。
<!--This struct is a kind of a place-holder describing the query.-->
この構造体は、クエリを記述するプレースホルダの一種です。
<!--Each such struct implements the `self::config::QueryConfig` trait, which has associated types for the key/value of that particular query.-->
このような各structは、`self::config::QueryConfig`特性を実装しています。この特性は、その特定のクエリのキー/値に関連する型を持ちます。
<!--Basically the code generated looks something like this:-->
基本的に生成されるコードは次のようになります。

```rust,ignore
#// Dummy struct representing a particular kind of query:
// 特定の種類のクエリーを表すDummy構造体：
pub struct type_of<'tcx> { phantom: PhantomData<&'tcx ()> }

impl<'tcx> QueryConfig for type_of<'tcx> {
  type Key = DefId;
  type Value = Ty<'tcx>;
}
```

<!--There is an additional trait that you may wish to implement called `self::config::QueryDescription`.-->
`self::config::QueryDescription`と呼ばれる実装したいかもしれない追加の特性があります。
<!--This trait is used during cycle errors to give a "human readable"name for the query, so that we can summarize what was happening when the cycle occurred.-->
この特性はサイクルエラー時に使用され、クエリーに「人間が判読可能な」名前を付けるので、サイクルが発生したときの状況を要約できます。
<!--Implementing this trait is optional if the query key is `DefId`, but if you *don't* implement it, you get a pretty generic error ("processing `foo`...").-->
クエリのキーが`DefId`場合、この特性の実装はオプションですが、実装して*いない*と、かなり一般的なエラーが発生します（「 `foo`処理しています...」）。
<!--You can put new impls into the `config` module.-->
あなたは`config`モジュールに新しいimplを置くことができます。
<!--They look something like this:-->
彼らはこのように見える：

```rust,ignore
impl<'tcx> QueryDescription for queries::type_of<'tcx> {
    fn describe(tcx: TyCtxt, key: DefId) -> String {
        format!("computing the type of `{}`", tcx.item_path_str(key))
    }
}
```

