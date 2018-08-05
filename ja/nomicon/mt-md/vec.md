# <!--Example: Implementing Vec--> 例：Vecの実装

<!--To bring everything together, we're going to write `std::Vec` from scratch.-->
すべてをまとめるために、最初から`std::Vec`を書くつもりです。
<!--Because all the best tools for writing unsafe code are unstable, this project will only work on nightly (as of Rust 1.9.0).-->
安全でないコードを書くための最良のツールはすべて不安定であるため、このプロジェクトは夜間のみで動作します（Rust 1.9.0以降）。
<!--With the exception of the allocator API, much of the unstable code we'll use is expected to be stabilized in a similar form as it is today.-->
アロケータAPIを除いて、使用する不安定なコードの多くは、今日のような形で安定すると予想されます。

<!--However we will generally try to avoid unstable code where possible.-->
しかし、一般的に、可能であれば不安定なコードを避けようとします。
<!--In particular we won't use any intrinsics that could make a code a little bit nicer or efficient because intrinsics are permanently unstable.-->
特に、イントリンシックが永久に不安定であるため、コードを少しやや効率的または効率的にすることができるイントリンシックは使用しません。
<!--Although many intrinsics *do* become stabilized elsewhere (`std::ptr` and `str::mem` consist of many intrinsics).-->
多くのintrinsics *は*他の場所で安定しています（`std::ptr`と`str::mem`は多くの組み込み関数で構成されてい`str::mem`）。

<!--Ultimately this means our implementation may not take advantage of all possible optimizations, though it will be by no means *naive*.-->
結局のところ、私たちの実装ではすべての可能な最適化を利用できないかもしれませんが、それは決して*素朴*ではありません。
<!--We will definitely get into the weeds over nitty-gritty details, even when the problem doesn't *really* merit it.-->
私たちは間違いなく、問題が*本当に*価値がないときでさえ、きめ細かな細部について雑草に入るでしょう。

<!--You wanted advanced.-->
あなたは進歩したかった。
<!--We're gonna go advanced.-->
私たちは進んで行くつもりです。
