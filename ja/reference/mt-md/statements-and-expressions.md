# <!--Statements and expressions--> ステートメントと式

<!--Rust is  _primarily_  an expression language.-->
錆は _主_ に表現言語です。
<!--This means that most forms of value-producing or effect-causing evaluation are directed by the uniform syntax category of  _expressions_ .-->
これは、ほとんどの形の価値創造または効果をもたらす評価が統一された _表現の_ カテゴリーの _表現_ によって導かれることを意味します。
<!--Each kind of expression can typically  _nest_  within each other kind of expression, and rules for evaluation of expressions involve specifying both the value produced by the expression and the order in which its sub-expressions are themselves evaluated.-->
それぞれの種類の式は、通常、互いの種類の式内に _ネスト_ することができ、式の評価ルールでは、式によって生成された値とそのサブ式自体が評価される順序の両方を指定する必要があります。

<!--In contrast, statements in Rust serve  _mostly_  to contain and explicitly sequence expression evaluation.-->
対照的に、Rustのステートメントは _主_ に式の評価を含み、明示的に順序付けする役割を果たします。
