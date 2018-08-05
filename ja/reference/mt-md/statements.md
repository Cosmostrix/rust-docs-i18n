# <!--Statements--> ステートメント

<!--A *statement* is a component of a [block], which is in turn a component of an outer [expression] or [function].-->
*ステートメント*は、[block]コンポーネントであり、これは外側の[expression]または[function]コンポーネントです。

<!--Rust has two kinds of statement: [declaration statements](#declaration-statements) and [expression statements](#expression-statements).-->
Rustには、[declaration statements](#declaration-statements)と[expression statements](#expression-statements) 2種類があり[expression statements](#expression-statements)。

## <!--Declaration statements--> 宣言文

<!--A *declaration statement* is one that introduces one or more *names* into the enclosing statement block.-->
*宣言ステートメント*は、1つ以上の*名前*を囲むステートメントブロックに導入するものです。
<!--The declared names may denote new variables or new [items][item].-->
宣言された名前は、新しい変数または新しい[items][item]示すことがあり[items][item]。

<!--The two kinds of declaration statements are item declarations and `let` statements.-->
2種類の宣言文は、項目宣言と`let`文です。

### <!--Item declarations--> アイテム宣言

<!--An *item declaration statement* has a syntactic form identical to an [item declaration][item] within a [module].-->
*項目宣言文*は、[module]内の[項目宣言][item]と同じ構文形式*を*持ち[module]。
<!--Declaring an item within a statement block restricts its scope to the block containing the statement.-->
ステートメントブロック内の項目を宣言すると、そのステートメントを含むブロックにそのスコープが制限されます。
<!--The item is not given a [canonical path] nor are any sub-items it may declare.-->
アイテムには[canonical path]与えられていないし、宣言されているサブアイテムもありません。
<!--The exception to this is that associated items defined by [implementations] are still accessible in outer scopes as long as the item and, if applicable, trait are accessible.-->
ただし、[implementations]によって定義された関連項目は、項目および該当する場合は特性にアクセス可能である限り、依然として外部スコープでアクセス可能です。
<!--It is otherwise identical in meaning to declaring the item inside a module.-->
それ以外の点では、モジュール内でその項目を宣言するのと同じ意味です。

<!--There is no implicit capture of the containing function's generic parameters, parameters, and local variables.-->
包含する関数の汎用パラメータ、パラメータ、およびローカル変数の暗黙的な取得はありません。
<!--For example, `inner` may not access `outer_var`.-->
たとえば、`inner`は`outer_var`アクセスできません。

```rust
fn outer() {
  let outer_var = true;

  fn inner() { /* outer_var is not in scope here */ }

  inner();
}
```

### <!--`let` statements--> `let`文を

<!--A *`let` statement* introduces a new set of [variables], given by a pattern.-->
*`let`ステートメント*はパターンによって与えられる新しい[variables]セットを導入します。
<!--The pattern is followed optionally by a type annotation and then optionally by an initializer expression.-->
パターンの後にはオプションで型アノテーションが続き、オプションで初期化式が続きます。
<!--When no type annotation is given, the compiler will infer the type, or signal an error if insufficient type information is available for definite inference.-->
型の注釈が与えられていないときは、コンパイラはその型を推論するか、型情報が不十分な場合にはエラーを通知します。
<!--Any variables introduced by a variable declaration are visible from the point of declaration until the end of the enclosing block scope.-->
変数宣言によって導入された変数は、宣言のポイントから囲むブロックスコープの終わりまで表示されます。

## <!--Expression statements--> 式文

<!--An *expression statement* is one that evaluates an [expression] and ignores its result.-->
*式ステートメント*は、[expression]を評価し、その結果を無視する*ステートメント*です。
<!--As a rule, an expression statement's purpose is to trigger the effects of evaluating its expression.-->
原則として、式文の目的は、その式を評価する効果を引き起こすことです。

<!--An expression that consists of only a [block expression][block] or control flow expression, if used in a context where a statement is permitted, can omit the trailing semicolon.-->
ステートメントが許可されているコンテキストで使用されている場合、[ブロック式][block]または制御フロー式のみで構成される式は、末尾のセミコロンを省略できます。
<!--This can cause an ambiguity between it being parsed as a standalone statement and as a part of another expression;-->
これは、スタンドアロン文として解析されるか、別の式の一部としてあいまいさを引き起こす可能性があります。
<!--in this case, it is parsed as a statement.-->
この場合、文として解析されます。

```rust
# let mut v = vec![1, 2, 3];
#//v.pop();          // Ignore the element returned from pop
v.pop();          //  popから返された要素を無視する
if v.is_empty() {
    v.push(5);
} else {
    v.remove(0);
#//}                 // Semicolon can be omitted.
}                 // セミコロンは省略できます。
#//[1];              // Separate expression statement, not an indexing expression.
[1];              // インデックス式ではなく、式を区切ります。
```

<!--When the trailing semicolon is omitted, the result must be type `()`.-->
末尾のセミコロンを省略すると、結果はtype `()`なければなりません。

```rust
#// bad: the block's type is i32, not ()
#// Error: expected `()` because of default return type
#// if true {
#//   1
#// }
//  bad：ブロックのタイプはi32で、not（）Error：expected `()` trueの場合のデフォルトの戻りタイプのため`()` {1}

#// good: the block's type is i32
// 良い：ブロックのタイプはi32です
if true {
  1
} else {
  2
};
```

## <!--Attributes on Statements--> ステートメントの属性

<!--Statements accept [outer attributes].-->
文は[outer attributes]受け入れ[outer attributes]。
<!--The attributes that have meaning on a statement are [`cfg`], and [the lint check attributes].-->
文で意味を持つ属性は[`cfg`]と[the lint check attributes]。

<!--[block]: expressions/block-expr.html
 [expression]: expressions.html
 [function]: items/functions.html
 [item]: items.html
 [module]: items/modules.html
 [canonical path]: paths.html#canonical-paths
 [implementations]: items/implementations.html
 [variables]: variables.html
 [outer attributes]: attributes.html
 [`cfg`]: attributes.html#conditional-compilation
 [the lint check attributes]: attributes.html#lint-check-attributes
-->
[block]: expressions/block-expr.html
 [expression]: expressions.html
 [function]: items/functions.html
 [item]: items.html
 [module]: items/modules.html
 [canonical path]: paths.html#canonical-paths
 [implementations]: items/implementations.html
 [variables]: variables.html
 [outer attributes]: attributes.html
 [`cfg`]: attributes.html#conditional-compilation
 [the lint check attributes]: attributes.html#lint-check-attributes

