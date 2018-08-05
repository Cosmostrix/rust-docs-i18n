# <!--Module system--> モジュールシステム

<!--The module system is one of the most confusing aspects of Rust 2015 for many Rustaceans.-->
モジュールシステムは、多くの錆びた人にとってRust 2015の最も混乱しやすい側面の1つです。
<!--Rust 2018 includes an overhaul of the module system.-->
Rust 2018には、モジュールシステムのオーバーホールが含まれています。
<!--In the words of the core team:-->
コアチームの言葉で：

> <!--In other words, while there are simple and consistent rules defining the module system, their consequences can feel inconsistent, counterintuitive and mysterious.-->
> 言い換えれば、モジュールシステムを定義する単純で一貫性のある規則が存在するが、それらの結果は一貫性がなく、直観に反して不思議に感じることがある。

<!--Rust 2018's module system also consists of simple rules, but they fit together in a much nicer way.-->
Rust 2018のモジュールシステムもシンプルなルールで構成されていますが、もっとうまく組み合わせることができます。
<!--We expect these changes to be one of the favorites in this edition.-->
これらの変更がこのエディションのお気に入りの1つになることが期待されます。
