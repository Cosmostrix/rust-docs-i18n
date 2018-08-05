# <!--Well-formedness checking--> 整形式チェック

<!--This chapter is mostly *to be written*.-->
この章はほとんど*が書かれてい*ます。
<!--WF checking, in short, has the job of checking that the various declarations in a Rust program are well-formed.-->
要するに、WFチェックは、Rustプログラムのさまざまな宣言が整形式であることをチェックする仕事をしています。
<!--This is the basis for implied bounds, and partly for that reason, this checking can be surprisingly subtle!-->
これは暗黙の境界の基礎であり、その理由の一部はこのチェックが驚くほど微妙なことです！
<!--(For example, we have to be sure that each impl proves the WF conditions declared on the trait.)-->
（例えば、各インプラントがその形質で宣言されたWF条件を証明していることを確認する必要があります）。



