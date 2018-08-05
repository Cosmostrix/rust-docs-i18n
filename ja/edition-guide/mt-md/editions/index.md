# <!--What are Editions?--> エディションとは何ですか？

<!--Rust ships releases on a six-week cycle.-->
錆は6週間のサイクルで放出されます。
<!--This means that users get a constant stream of new features.-->
これは、ユーザーが新しい機能の一定のストリームを取得することを意味します。
<!--This is much faster than updates for other languages, but this also means that each update is smaller.-->
これは他の言語の更新よりもはるかに高速ですが、これは各更新がより少ないことを意味します。
<!--After a while, all of those tiny changes add up.-->
しばらくすると、その小さな変化のすべてが足りなくなる。
<!--But, from release to release, it can be hard to look back and say *"Wow, between Rust 1.10 and Rust 1.20, Rust has changed a lot!"*-->
しかし、リリースからリリースまで、それを振り返るのは難しいかもしれません。*「ワースト、錆1.10と錆1.20の間に、錆が大きく変わった！*

<!--Every two or three years, we'll be producing a new *edition* of Rust.-->
2〜3年ごとに、新しい*版*のRustを制作します。
<!--Each edition brings together the features that have landed into a clear package, with fully updated documentation and tooling.-->
各エディションでは、完全に更新されたドキュメントとツールを使用して、明確なパッケージになっている機能をまとめています。
<!--New editions ship through the usual release process.-->
新しい版は通常のリリースプロセスで出荷されます。

<!--This serves different purposes for different people:-->
これは、異なる人々のために異なる目的を果たします。

- <!--For active Rust users, it brings together incremental changes into an easy-to-understand package.-->
   アクティブなRustユーザーの場合、インクリメンタルな変更を理解しやすいパッケージにまとめます。

- <!--For non-users, it signals that some major advancements have landed, which might make Rust worth another look.-->
   非ユーザのために、それはいくつかの主要な進歩が着陸したことを示しているので、Rustは別の見方をする価値があります。

- <!--For those developing Rust itself, it provides a rallying point for the project as a whole.-->
   Rustそのものを開発する人にとっては、プロジェクト全体の合理的なポイントを提供します。

## <!--Compatibility--> 互換性

<!--When a new edition becomes available in the compiler, crates must explicitly opt in to it to take full advantage.-->
新しいエディションがコンパイラで利用できるようになると、クレートは明示的にオプトインする必要があります。
<!--This opt in enables editions to contain incompatible changes, like adding a new keyword that might conflict with identifiers in code, or turning warnings into errors.-->
このオプションを使用すると、コード内の識別子と競合する可能性のある新しいキーワードを追加する、警告をエラーにするなど、互換性のない変更をエディションに含めることができます。
<!--A Rust compiler will support all editions that existed prior to the compiler's release, and can link crates of any supported editions together.-->
Rustコンパイラは、コンパイラのリリース以前に存在していたすべてのエディションをサポートし、サポートされているエディションのすべてをリンクすることができます。
<!--Edition changes only affect the way the compiler initially parses the code.-->
エディションの変更は、コンパイラが最初にコードを解析する方法にのみ影響します。
<!--Therefore, if you're using Rust 2015, and one of your dependencies uses Rust 2018, it all works just fine.-->
したがって、Rust 2015を使用していて、依存関係の1つがRust 2018を使用している場合、すべてうまく動作します。
<!--The opposite situation works as well.-->
逆の状況も同様に働く。

<!--Just to be clear: most features will be available on all editions.-->
わかりやすい：ほとんどの機能はすべてのエディションで利用できます。
<!--People using any edition of Rust will continue to see improvements as new stable releases are made.-->
Rustのいずれかのエディションを使用している人は、新しい安定版がリリースされると、引き続き改善を見ていきます。
<!--In some cases however, mainly when new keywords are added, but sometimes for other reasons, there may be new features that are only available in later editions.-->
ただし、主に新しいキーワードが追加された場合は、主に新しいキーワードが追加される場合がありますが、それ以外の理由で新しい機能が追加されることがあります。
<!--You only need to upgrade if you want to take advantage of such features.-->
このような機能を利用するには、アップグレードする必要があります。

## <!--Trying out the 2018 edition--> 2018年版を試す

<!--At the time of writing, there are two editions: 2015 and 2018. 2015 is today's Rust;-->
執筆時点では、2015年と2018年の2つの版があります.2015年は今日の錆です。
<!--Rust 2018 will ship later this year.-->
錆2018は今年後半に出荷される予定です。
<!--To transition to the 2018 edition from the 2015 edition, you'll want to get started with the [transition guide](editions/transitioning.html).-->
2015年版から2018年版に移行するには、[transition guide](editions/transitioning.html)使い始めることをおすすめします。
