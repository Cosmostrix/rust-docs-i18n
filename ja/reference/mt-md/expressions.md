# <!--Expressions--> 式

> <!--**<sup>Syntax</sup>** \  _Expression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _Expression_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[_LiteralExpression_] \ &nbsp;&nbsp;-->
> [_LiteralExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_PathExpression_] \ &nbsp;&nbsp;-->
> [_PathExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_BlockExpression_] \ &nbsp;&nbsp;-->
> [_BlockExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_OperatorExpression_] \ &nbsp;&nbsp;-->
> [_OperatorExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_GroupedExpression_] \ &nbsp;&nbsp;-->
> [_GroupedExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_ArrayExpression_] \ &nbsp;&nbsp;-->
> [_ArrayExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_IndexExpression_] \ &nbsp;&nbsp;-->
> [_IndexExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_TupleExpression_] \ &nbsp;&nbsp;-->
> [_TupleExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_TupleIndexingExpression_] \ &nbsp;&nbsp;-->
> [_TupleIndexingExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_StructExpression_] \ &nbsp;&nbsp;-->
> [_StructExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_EnumerationVariantExpression_] \ &nbsp;&nbsp;-->
> [_EnumerationVariantExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_CallExpression_] \ &nbsp;&nbsp;-->
> [_CallExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_MethodCallExpression_] \ &nbsp;&nbsp;-->
> [_MethodCallExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_FieldExpression_] \ &nbsp;&nbsp;-->
> [_FieldExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_ClosureExpression_] \ &nbsp;&nbsp;-->
> [_ClosureExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_LoopExpression_] \ &nbsp;&nbsp;-->
> [_LoopExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_ContinueExpression_] \ &nbsp;&nbsp;-->
> [_ContinueExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_BreakExpression_] \ &nbsp;&nbsp;-->
> [_BreakExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_RangeExpression_] \ &nbsp;&nbsp;-->
> [_RangeExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_IfExpression_] \ &nbsp;&nbsp;-->
> [_IfExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_IfLetExpression_] \ &nbsp;&nbsp;-->
> [_IfLetExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--[_MatchExpression_] \ &nbsp;&nbsp;-->
> [_MatchExpression_] \＆nbsp;＆nbsp;
> <!--|-->
> |
> [_ReturnExpression_]

<!--An expression may have two roles: it always produces a *value*, and it may have *effects* (otherwise known as "side effects").-->
式には2つの役割があります：常に*値を*生成し、それに*影響を与える*可能性があり*ます*（「副作用」としても知られています）。
<!--An expression *evaluates to* a value, and has effects during *evaluation*.-->
式は値に*評価され*、 *評価*中に影響を与えます。
<!--Many expressions contain sub-expressions (operands).-->
多くの式には、サブ式（オペランド）が含まれています。
<!--The meaning of each kind of expression dictates several things:-->
それぞれの種類の表現の意味は、いくつかのことを定めています。

* <!--Whether or not to evaluate the sub-expressions when evaluating the expression-->
   式を評価する際にサブ式を評価するかどうか
* <!--The order in which to evaluate the sub-expressions-->
   サブ式を評価する順序
* <!--How to combine the sub-expressions' values to obtain the value of the expression-->
   サブ式の値を組み合わせて式の値を取得する方法

<!--In this way, the structure of expressions dictates the structure of execution.-->
このように、式の構造は実行の構造を決定します。
<!--Blocks are just another kind of expression, so blocks, statements, expressions, and blocks again can recursively nest inside each other to an arbitrary depth.-->
ブロックは別の種類の式なので、ブロック、ステートメント、式、およびブロックは、互いに内部的に任意の深さに再帰的にネストできます。

## <!--Expression precedence--> 式の優先順位

<!--The precedence of Rust operators and expressions is ordered as follows, going from strong to weak.-->
Rust演算子と式の優先順位は、強いものから弱いものへと順番に並べられます。
<!--Binary Operators at the same precedence level are grouped in the order given by their associativity.-->
同じ優先レベルのバイナリ演算子は、それらの結合性によって与えられた順序でグループ化されます。

|<!--Operator/Expression-->演算子/式|<!--Associativity-->関連性|
|<!--------------------------------->-----------------------------|<!------------------------->---------------------|
|<!--Paths-->パス| |
|<!--Method calls-->メソッド呼び出し| |
|<!--Field expressions-->フィールド式|<!--left to right-->左から右へ|
|<!--Function calls, array indexing-->関数呼び出し、配列の索引付け| |
|`?`| |
|<!--Unary `-` `*` `!` `&` `&mut`-->単項`-` `*` `!` `&` `&mut`| |
|`as`|<!--left to right-->左から右へ|
|<!--`*` `/` `%`-->`*` `/` `%`|<!--left to right-->左から右へ|
|<!--`+` `-`-->`+` `-`|<!--left to right-->左から右へ|
|<!--`<<` `>>`-->`<<` `>>`|<!--left to right-->左から右へ|
|`&`|<!--left to right-->左から右へ|
|`^`|<!--left to right-->左から右へ|
|`&#124;`|<!--left to right-->左から右へ|
|<!--`==` `!=` `<` `>` `<=` `>=`-->`==` `!=` `<` `>` `<=` `>=`|<!--Require parentheses-->かっこを必要とする|
|`&&`|<!--left to right-->左から右へ|
|`&#124;&#124;`|<!--left to right-->左から右へ|
|<!--`..` `..=`-->`..` `..=`|<!--Require parentheses-->かっこを必要とする|
|<!--`=` `+=` `-=` `*=` `/=` `%=`-->`=` `+=` `-=` `*=` `/=` `%=`<!--`&=` `&#124;=` `^=` `<<=` `>>=`-->`&=` `&#124;=` `^=` `<<=` `>>=`|<!--right to left-->右から左に|
|<!--`return` `break` closures-->`return` `break`クロージャ| |

## <!--Place Expressions and Value Expressions--> 式と値の式の配置

<!--Expressions are divided into two main categories: place expressions and value expressions.-->
式は、2つの主要なカテゴリに分かれています。
<!--Likewise within each expression, sub-expressions may occur in either place context or value context.-->
各式内で同様に、部分式は場所コンテキストまたは値コンテキストのいずれかで発生する可能性があります。
<!--The evaluation of an expression depends both on its own category and the context it occurs within.-->
表現の評価は、それ自身のカテゴリーとその中で起こる文脈の両方に依存する。

<!--A *place expression* is an expression that represents a memory location.-->
*プレース・エクスプレッション*は、メモリーの場所を表す式です。
<!--These expressions are [paths] which refer to local variables, [static variables], [dereferences] &nbsp;(`*expr`), [array indexing] expressions (`expr[expr]`), [field] references (`expr.f`) and parenthesized place expressions.-->
これらの式は、[paths]ローカル変数を参照する[static variables]、 [dereferences]（;＆NBSP `*expr`）、 [array indexing]式（`expr[expr]`）、 [field]参照（`expr.f`）と括弧場所表現。
<!--All other expressions are value expressions.-->
その他の式はすべて値式です。

<!--A *value expression* is an expression that represents an actual value.-->
*値式*は、実際の値を表す式です。

<!--The left operand of an [assignment][assign] or [compound assignment] expression is a place expression context, as is the single operand of a unary [borrow], and the operand of any [implicit borrow].-->
[assignment][assign]または[compound assignment]式の左のオペランドは、単項の[borrow]単一のオペランドと同様に、場所式のコンテキストと、[implicit borrow]オペランドです。
<!--The discriminant or subject of a [match expression][match] and right side of a [let statement] is also a place expression context.-->
[一致式][match]の判別式または主題と[let statement]右側は、場所式コンテキストでもあります。
<!--All other expression contexts are value expression contexts.-->
他のすべての式コンテキストは、値式コンテキストです。

> <!--Note: Historically, place expressions were called *lvalues* and value expressions were called *rvalues*.-->
> 注：これまで、プレース・エクスプレッションは*左辺値*と呼ばれ、値式は*左辺値*と呼ばれてい*ました*。

### <!--Moved and copied types--> 移動したタイプとコピーしたタイプ

<!--When a place expression is evaluated in a value expression context, or is bound by value in a pattern, it denotes the value held  _in_  that memory location.-->
プレース・エクスプレッションは、値式コンテキストで評価されるか、パターン内の値によってバインドされると _、_ そのメモリ位置に保持さ _れ_ ている値を示します。
<!--If the type of that value implements [`Copy`], then the value will be copied.-->
その値の型が[`Copy`]実装するなら、値はコピーされます。
<!--In the remaining situations if that type is [`Sized`], then it may be possible to move the value.-->
残りの状況では、そのタイプが[`Sized`]であれば、値を移動することができます。
<!--Only the following place expressions may be moved out of:-->
次の場所式だけが移動できます。

* <!--[Variables] which are not currently borrowed.-->
   現在借用されていない[Variables]。
* <!--[Temporary values](#temporary-lifetimes).-->
   [一時的な値](#temporary-lifetimes)。
* <!--[Fields][field] of a place expression which can be moved out of and doesn't implement [`Drop`].-->
   [Fields][field]の外に移動することができ、実装されていない場所の表現の[`Drop`]。
* <!--The result of [dereferencing] an expression with type [`Box `]-->
   タイプが[`Box `]式を[dereferencing]た結果
RawInline (Format "html") "<t>" <!--[`Box `] and that can also be moved out of.-->
   [`Box `]それはまた移動することができます。

<!--Moving out of a place expression that evaluates to a local variable, the location is deinitialized and cannot be read from again until it is reinitialized.-->
ローカル変数に評価されるプレース・エクスプレッションから移動すると、そのロケーションは初期化されず、再初期化されるまで再読み込みできません。
<!--In all other cases, trying to use a place expression in a value expression context is an error.-->
それ以外の場合は、値式コンテキストでプレース・エクスプレッションを使用しようとするとエラーになります。

### <!--Mutability--> 変異性

<!--For a place expression to be [assigned][assign] to, mutably [borrowed][borrow], [implicitly mutably borrowed], or bound to a pattern containing `ref mut` it must be  _mutable_ .-->
する場所の発現のために[assigned][assign] mutablyに、[borrowed][borrow]、 [implicitly mutably borrowed]、または含むパターンにバインドされた`ref mut`それは _変更可能_ でなければなりません。
<!--We call these *mutable place expressions*.-->
我々は、これらの*変更可能な場所表現*を呼ぶ。
<!--In contrast, other place expressions are called *immutable place expressions*.-->
対照的に、他の場所式は*不変の場所式*と呼ば*れます*。

<!--The following expressions can be mutable place expression contexts:-->
次の式は、変更可能な場所の式コンテキストにすることができます。

* <!--Mutable [variables], which are not currently borrowed.-->
   現在借りていない変更可能な[variables]。
* <!--[Mutable `static` items].-->
   [Mutable `static` items]。
* <!--[Temporary values].-->
   [Temporary values]。
* <!--[Fields][field], this evaluates the subexpression in a mutable place expression context.-->
   [Fields][field]、これは、変更可能なプレースの式コンテキストの部分式を評価します。
* <!--[Dereferences] of a `*mut T` pointer.-->
   [Dereferences]の`*mut T`ポインタ。
* <!--Dereference of a variable, or field of a variable, with type `&mut T`.-->
   変数のフィールド、または変数のフィールドを、`&mut T`型のタイプで参照解除する。
<!--Note: This is an exception to the requirement of the next rule.-->
   注：これは次の規則の要件に対する例外です。
* <!--Dereferences of a type that implements `DerefMut`, this then requires that the value being dereferenced is evaluated is a mutable place expression context.-->
   `DerefMut`を実装する型の`DerefMut`では、逆参照される値が変更可能な場所式コンテキストであることが必要です。
* <!--[Array indexing] of a type that implements `DerefMut`, this then evaluates the value being indexed, but not the index, in mutable place expression context.-->
   `DerefMut`を実装する型の[Array indexing]と、これは、変更可能な場所の式コンテキストで、インデックスではなくインデックスである値を評価します。

### <!--Temporary lifetimes--> 一時的な生涯

<!--When using a value expression in most place expression contexts, a temporary unnamed memory location is created initialized to that value and the expression evaluates to that location instead, except if promoted to `'static`.-->
ほとんどのプレース・エクスプレッション・コンテキストで値式を使用すると、一時的な名前の付いていないメモリー位置がその値に初期化されて作成され、代わりにその位置に評価され`'static`。
<!--Promotion of a value expression to a `'static` slot occurs when the expression could be written in a constant, borrowed, and dereferencing that borrow where the expression was the originally written, without changing the runtime behavior.-->
`'static`スロットへの値式の昇格は、実行時の振る舞いを変更せずに、式が最初に書き込まれた場所から借用した定数、借用、参照解除で式を記述できるときに発生します。
<!--That is, the promoted expression can be evaluated at compile-time and the resulting value does not contain [interior mutability] or [destructors] (these properties are determined based on the value where possible, eg `&None` always has the type `&'static Option<_>`, as it contains nothing disallowed).-->
つまり、宣言された式はコンパイル時に評価することができ、結果の値には[interior mutability]または[destructors]は含まれません（これらのプロパティは可能な値に基づいて決定されます。たとえば`&None`常に`&'static Option<_>`それには何も許されないので）。
<!--Otherwise, the lifetime of temporary values is typically-->
それ以外の場合、一時的な値の存続期間は通常は

- <!--the innermost enclosing statement;-->
   最も内側の文。
<!--the tail expression of a block is considered part of the statement that encloses the block, or-->
   ブロックの末尾の式は、ブロックを囲む文の一部とみなされます。
- <!--the condition expression or the loop conditional expression if the temporary is created in the condition expression of an `if` or in the loop conditional expression of a `while` expression.-->
   条件式または一時的な場合はループの条件式は、の条件式で作成された`if`やループの条件式`while`式。

<!--When a temporary value expression is being created that is assigned into a [`let` declaration][let], however, the temporary is created with the lifetime of the enclosing block instead, as using the enclosing [`let` declaration][let] would be a guaranteed error (since a pointer to the temporary would be stored into a variable, but the temporary would be freed before the variable could be used).-->
しかし、[`let`宣言に][let]代入されている一時的な値式が作成されているときは、囲みブロックの有効期間を使って一時的に作成されます。囲み[`let`宣言][let]は保証されたエラーになります。変数に格納することはできますが、一時変数は変数を使用する前に解放されます）。
<!--The compiler uses simple syntactic rules to decide which values are being assigned into a `let` binding, and therefore deserve a longer temporary lifetime.-->
コンパイラは単純な構文規則を使用して、どの値が`let`バインディングに割り当てられているかを判断するので、より長い一時的な有効期間が必要です。

<!--Here are some examples:-->
ここではいくつかの例を示します。

- <!--`let x = foo(&temp())`.-->
   `let x = foo(&temp())`。
<!--The expression `temp()` is a value expression.-->
   式`temp()`は値式です。
<!--As it is being borrowed, a temporary is created which will be freed after the innermost enclosing statement;-->
   それが借用されているとき、一番内側の文の後に解放される一時的なものが作成されます。
<!--in this case, the `let` declaration.-->
   この場合、`let`宣言。
- <!--`let x = temp().foo()`.-->
   `let x = temp().foo()`。
<!--This is the same as the previous example, except that the value of `temp()` is being borrowed via autoref on a method-call.-->
   これは、前の例と同じですが、`temp()`値がメソッド呼び出しでautorefを介して借用されていることを除けば、これは前の例と同じです。
<!--Here we are assuming that `foo()` is an `&self` method defined in some trait, say `Foo`.-->
   ここでは、`foo()`がある種の特性、例えば`Foo`定義された`&self`メソッドであると仮定しています。
<!--In other words, the expression `temp().foo()` is equivalent to `Foo::foo(&temp())`.-->
   言い換えれば、式`temp().foo()`は`Foo::foo(&temp())`と等価です。
- `let x = if foo(&temp()) {bar()} else {baz()};` <!--.-->
   。
<!--The expression `temp()` is a value expression.-->
   式`temp()`は値式です。
<!--As the temporary is created in the condition expression of an `if`, it will be freed at the end of the condition expression;-->
   テンポラリは`if`条件式で作成されるため、条件式の最後に解放されます。
<!--in this example before the call to `bar` or `baz` is made.-->
   この例では、`bar`または`baz`への呼び出しが行われます。
- `let x = if temp().must_run_bar {bar()} else {baz()};` <!--.-->
   。
<!--Here we assume the type of `temp()` is a struct with a boolean field `must_run_bar`.-->
   ここでは、`temp()`型はbooleanフィールド`must_run_bar`持つ構造体であると`must_run_bar`ます。
<!--As the previous example, the temporary corresponding to `temp()` will be freed at the end of the condition expression.-->
   前の例のように、`temp()`対応する`temp()`的なものは、条件式の最後に解放されます。
- <!--`while foo(&temp()) {bar();}`.-->
   `while foo(&temp()) {bar();}`
<!--The temporary containing the return value from the call to `temp()` is created in the loop conditional expression.-->
   呼び出しからの戻り値`temp()`を含む一時は、ループ条件式で作成されます。
<!--Hence it will be freed at the end of the loop conditional expression;-->
   したがって、ループ条件式の最後に解放されます。
<!--in this example before the call to `bar` if the loop body is executed.-->
   この例では、ループ本体が実行されると`bar`前に呼び出され`bar`。
- <!--`let x = &temp()`.-->
   `let x = &temp()`ます。
<!--Here, the same temporary is being assigned into `x`, rather than being passed as a parameter, and hence the temporary's lifetime is considered to be the enclosing block.-->
   ここでは、パラメータとして渡されるのではなく、同じ一時的なものが`x`に割り当てられているため、一時的な有効期間は囲みブロックとみなされます。
- <!--`let x = SomeStruct { foo: &temp() }`.-->
   `let x = SomeStruct { foo: &temp() }`。
<!--As in the previous case, the temporary is assigned into a struct which is then assigned into a binding, and hence it is given the lifetime of the enclosing block.-->
   前の例と同様に、一時的なものは構造体に割り当てられ、次に構造体に割り当てられます。したがって、それは囲むブロックの有効期間が与えられます。
- <!--`let x = [ &temp() ]`.-->
   `let x = [ &temp() ]`。
<!--As in the previous case, the temporary is assigned into an array which is then assigned into a binding, and hence it is given the lifetime of the enclosing block.-->
   前述の場合と同様に、一時的なものは配列に割り当てられ、次にバインディングに割り当てられ、したがって囲むブロックの有効期間が与えられます。
- <!--`let ref x = temp()`.-->
   `let ref x = temp()`ます。
<!--In this case, the temporary is created using a ref binding, but the result is the same: the lifetime is extended to the enclosing block.-->
   この場合、一時バインディングはrefバインディングを使用して作成されますが、結果は同じです。有効期間は、囲むブロックに拡張されます。

### <!--Implicit Borrows--> 暗黙の借り

<!--Certain expressions will treat an expression as a place expression by implicitly borrowing it.-->
特定の式は暗黙的に借用して式を場所式として扱います。
<!--For example, it is possible to compare two unsized [slices] for equality directly, because the `==` operator implicitly borrows it's operands:-->
例えば、`==`演算子が暗黙的にそのオペランドを借用するため、2つのunsized [slices]を直接比較することは可能です。

```rust
# let c = [1, 2, 3];
# let d = vec![1, 2, 3];
let a: &[i32];
let b: &[i32];
# a = &c;
# b = &d;
#// ...
// ...
*a == *b;
#// Equivalent form:
// 同等の形式：
::std::cmp::PartialEq::eq(&*a, &*b);
```

<!--Implicit borrows may be taken in the following expressions:-->
暗黙の借り入れは、次の式で行うことができます。

* <!--Left operand in [method-call] expressions.-->
   [method-call]式の左オペランド。
* <!--Left operand in [field] expressions.-->
   [field]式の左オペランド。
* <!--Left operand in [call expressions].-->
   [call expressions]左オペランド。
* <!--Left operand in [array indexing] expressions.-->
   [array indexing]式の左オペランド。
* <!--Operand of the [dereference operator] \(`*`).-->
   [dereference operator]オペランド\（`*`）。
* <!--Operands of [comparison].-->
   [comparison]オペランド。
* <!--Left operands of the [compound assignment].-->
   [compound assignment]左オペランド。

## <!--Constant expressions--> 定数式

<!--Certain types of expressions can be evaluated at compile time.-->
特定のタイプの式はコンパイル時に評価できます。
<!--These are called  _constant expressions_ .-->
これらは _定数式_ と呼ばれ _ます_ 。
<!--Certain places, such as in [constants](items/constant-items.html) and [statics](items/static-items.html), require a constant expression, and are always evaluated at compile time.-->
[constants](items/constant-items.html)や[statics](items/static-items.html)などの特定の場所は定数式を必要とし、コンパイル時に常に評価されます。
<!--In other places, such as in [`let` statements](statements.html#let-statements), constant expressions may be evaluated at compile time.-->
[`let`文の](statements.html#let-statements)ような他の場所では、定数式はコンパイル時に評価されます。
<!--If errors, such as out of bounds [array indexing] or [overflow] occurs, then it is a compiler error if the value must be evaluated at compile time, otherwise it is just a warning, but the code will most likely panic when run.-->
範囲外の[array indexing]や[overflow]などのエラーが発生した場合、コンパイル時に値を評価する必要がある場合はコンパイラエラーです。そうでない場合は警告に過ぎませんが、コードは実行時にパニックになりがちです。

<!--The following expressions are constant expressions, so long as any operands are also constant expressions and do not cause any [`Drop::drop`][destructors] calls to be ran.-->
次の式は定数式であり、オペランドも定数式であり、[`Drop::drop`][destructors]呼び出しが実行されない限りです。

* <!--[Literals].-->
   [Literals]。
* <!--[Paths] to [functions](items/functions.html) and constants.-->
   [functions](items/functions.html)と定数の[Paths]。
<!--Recursively defining constants is not allowed.-->
   再帰的に定数を定義することはできません。
* <!--[Tuple expressions].-->
   [Tuple expressions]。
* <!--[Array expressions].-->
   [Array expressions]。
* <!--[Struct] expressions.-->
   [Struct]式。
* <!--[Enum variant] expressions.-->
   [Enum variant]式。
* <!--[Block expressions], including `unsafe` blocks, which only contain items and possibly a constant tail expression.-->
   `unsafe`ブロックを含む[Block expressions]をブロックします。これにはアイテムだけが含まれ、定数テール式も含まれます。
* <!--[Field] expressions.-->
   [Field]式。
* <!--Index expressions, [array indexing] or [slice] with a `usize`.-->
   インデックス式、[array indexing]または`usize`した[slice]
* <!--[Range expressions].-->
   [Range expressions]。
* <!--[Closure expressions] which don't capture variables from the environment.-->
   環境から変数を取得しない[Closure expressions]を[Closure expressions]ます。
* <!--Built in [negation], [arithmetic, logical], [comparison] or [lazy boolean] operators used on integer and floating point types, `bool` and `char`.-->
   整数型および浮動小数点型、`bool`および`char`使用される[negation]、 [arithmetic, logical]、 [comparison]または[lazy boolean]演算子に組み込まれています。
* <!--Shared [borrow] s, except if applied to a type with [interior mutability].-->
   [interior mutability]型に適用される場合を除いて、共有は[borrow]ます。
* <!--The [dereference operator].-->
   [dereference operator]。
* <!--[Grouped] expressions.-->
   [Grouped]式。
* <!--[Cast] expressions, except pointer to address and function pointer to address casts.-->
   [Cast]アドレスへのポインタとキャストに対処するための関数ポインタを除いて、式を。

## <!--Overloading Traits--> 特性のオーバーロード

<!--Many of the following operators and expressions can also be overloaded for other types using traits in `std::ops` or `std::cmp`.-->
次の演算子や式の多くは、`std::ops`や`std::cmp`特性を使って他の型のためにオーバーロードすることもできます。
<!--These traits also exist in `core::ops` and `core::cmp` with the same names.-->
これらの特性は同じ名前の`core::ops`と`core::cmp`も存在します。

<!--[block expressions]: %20%20%20expressions/block-expr.html
 [call expressions]: %20%20%20%20expressions/call-expr.html
 [closure expressions]: %20expressions/closure-expr.html
 [enum variant]: %20%20%20%20%20%20%20%20expressions/enum-variant-expr.html
 [field]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/field-expr.html
 [grouped]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/grouped-expr.html
 [literals]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/literal-expr.html
 [match]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/match-expr.html
 [method-call]: %20%20%20%20%20%20%20%20%20expressions/method-call-expr.html
 [paths]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/path-expr.html
 [range expressions]: %20%20%20expressions/range-expr.html
 [struct]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/struct-expr.html
 [tuple expressions]: %20%20%20expressions/tuple-expr.html
-->
[block expressions]: %20%20%20expressions/block-expr.html
 [call expressions]: %20%20%20%20expressions/call-expr.html
 [closure expressions]: %20expressions/closure-expr.html
 [enum variant]: %20%20%20%20%20%20%20%20expressions/enum-variant-expr.html
 [field]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/field-expr.html
 [grouped]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/grouped-expr.html
 [literals]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/literal-expr.html
 [match]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/match-expr.html
 [method-call]: %20%20%20%20%20%20%20%20%20expressions/method-call-expr.html
 [paths]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/path-expr.html
 [range expressions]: %20%20%20expressions/range-expr.html
 [struct]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/struct-expr.html
 [tuple expressions]: %20%20%20expressions/tuple-expr.html


<!--[array expressions]: %20%20%20expressions/array-expr.html
 [array indexing]: %20%20%20%20%20%20expressions/array-expr.html#array-and-slice-indexing-expressions
-->
[array expressions]: %20%20%20expressions/array-expr.html
 [array indexing]: %20%20%20%20%20%20expressions/array-expr.html#array-and-slice-indexing-expressions


<!--[arithmetic, logical]: %20expressions/operator-expr.html#arithmetic-and-logical-binary-operators
 [assign]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#assignment-expressions
 [borrow]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#borrow-operators
 [cast]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#type-cast-expressions
 [comparison]: %20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#comparison-operators
 [compound assignment]: %20expressions/operator-expr.html#compound-assignment-expressions
 [dereferences]: %20%20%20%20%20%20%20%20expressions/operator-expr.html#the-dereference-operator
 [dereferencing]: %20%20%20%20%20%20%20expressions/operator-expr.html#the-dereference-operator
 [dereference operator]: expressions/operator-expr.html#the-dereference-operator
 [lazy boolean]: %20%20%20%20%20%20%20%20expressions/operator-expr.html#lazy-boolean-operators
 [negation]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#negation-operators
 [overflow]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#overflow
-->
[arithmetic, logical]: %20expressions/operator-expr.html#arithmetic-and-logical-binary-operators
 [assign]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#assignment-expressions
 [borrow]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#borrow-operators
 [cast]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#type-cast-expressions
 [comparison]: %20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#comparison-operators
 [compound assignment]: %20expressions/operator-expr.html#compound-assignment-expressions
 [dereferences]: %20%20%20%20%20%20%20%20expressions/operator-expr.html#the-dereference-operator
 [dereferencing]: %20%20%20%20%20%20%20expressions/operator-expr.html#the-dereference-operator
 [dereference operator]: expressions/operator-expr.html#the-dereference-operator
 [dereferences]: %20%20%20%20%20%20%20%20expressions/operator-expr.html#the-dereference-operator
 [dereferencing]: %20%20%20%20%20%20%20expressions/operator-expr.html#the-dereference-operator
 [dereference operator]: expressions/operator-expr.html#the-dereference-operator
 [lazy boolean]: %20%20%20%20%20%20%20%20expressions/operator-expr.html#lazy-boolean-operators
 [negation]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#negation-operators
 [overflow]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html#overflow


<!--[destructors]: %20%20%20%20%20%20%20%20%20destructors.html
 [interior mutability]: %20interior-mutability.html
 [`Box<T>`]: %20%20%20%20%20%20%20%20%20%20%20%20../std/boxed/struct.Box.html
 [`Copy`]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20special-types-and-traits.html#copy
 [`Drop`]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20special-types-and-traits.html#drop
 [`Sized`]: %20%20%20%20%20%20%20%20%20%20%20%20%20special-types-and-traits.html#sized
 [implicit borrow]: %20%20%20%20%20#implicit-borrows
 [implicitly mutably borrowed]: #implicit-borrows
 [let]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20statements.html#let-statements
 [let statement]: %20%20%20%20%20%20%20statements.html#let-statements
 [Mutable `static` items]: items/static-items.html#mutable-statics
 [slice]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20types.html#array-and-slice-types
 [static variables]: %20%20%20%20items/static-items.html
 [Temporary values]: %20%20%20%20#temporary-lifetimes
 [Variables]: %20%20%20%20%20%20%20%20%20%20%20variables.html
-->
[destructors]: %20%20%20%20%20%20%20%20%20destructors.html
 [interior mutability]: %20interior-mutability.html
 [`Box<T>`]: %20%20%20%20%20%20%20%20%20%20%20%20../std/boxed/struct.Box.html
 [`Copy`]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20special-types-and-traits.html#copy
 [`Drop`]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20special-types-and-traits.html#drop
 [`Sized`]: %20%20%20%20%20%20%20%20%20%20%20%20%20special-types-and-traits.html#sized
 [implicit borrow]: %20%20%20%20%20#implicit-borrows
 [implicitly mutably borrowed]: #implicit-borrows
 [let]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20statements.html#let-statements
 [let statement]: %20%20%20%20%20%20%20statements.html#let-statements
 [Mutable `static` items]: items/static-items.html#mutable-statics
 [slice]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20types.html#array-and-slice-types
 [static variables]: %20%20%20%20items/static-items.html
 [Temporary values]: %20%20%20%20#temporary-lifetimes
 [Variables]: %20%20%20%20%20%20%20%20%20%20%20variables.html


<!--[_ArrayExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/array-expr.html
 [_BlockExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/block-expr.html
 [_BreakExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/loop-expr.html#break-expressions
 [_CallExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/call-expr.html
 [_ClosureExpression_]: %20%20%20%20%20%20%20%20%20%20%20expressions/closure-expr.html
 [_ContinueExpression_]: %20%20%20%20%20%20%20%20%20%20expressions/loop-expr.html#continue-expressions
 [_EnumerationVariantExpression_]: expressions/enum-variant-expr.html
 [_FieldExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/field-expr.html
 [_GroupedExpression_]: %20%20%20%20%20%20%20%20%20%20%20expressions/grouped-expr.html
 [_IfExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/if-expr.html#if-expressions
 [_IfLetExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/if-expr.html#if-let-expressions
 [_IndexExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/array-expr.html#array-and-slice-indexing-expressions
 [_LiteralExpression_]: %20%20%20%20%20%20%20%20%20%20%20expressions/literal-expr.html
 [_LoopExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/loop-expr.html
 [_MatchExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/match-expr.html
 [_MethodCallExpression_]: %20%20%20%20%20%20%20%20expressions/method-call-expr.html
 [_OperatorExpression_]: %20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html
 [_PathExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/path-expr.html
 [_RangeExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/range-expr.html
 [_ReturnExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/return-expr.html
 [_StructExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/struct-expr.html
 [_TupleExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/tuple-expr.html
 [_TupleIndexingExpression_]: %20%20%20%20%20expressions/tuple-expr.html#tuple-indexing-expressions
-->
[_ArrayExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/array-expr.html
 [_BlockExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/block-expr.html
 [_BreakExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/loop-expr.html#break-expressions
 [_CallExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/call-expr.html
 [_ClosureExpression_]: %20%20%20%20%20%20%20%20%20%20%20expressions/closure-expr.html
 [_ContinueExpression_]: %20%20%20%20%20%20%20%20%20%20expressions/loop-expr.html#continue-expressions
 [_EnumerationVariantExpression_]: expressions/enum-variant-expr.html
 [_FieldExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/field-expr.html
 [_GroupedExpression_]: %20%20%20%20%20%20%20%20%20%20%20expressions/grouped-expr.html
 [_IfExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/if-expr.html#if-expressions
 [_IfLetExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/if-expr.html#if-let-expressions
 [_IndexExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/array-expr.html#array-and-slice-indexing-expressions
 [_LiteralExpression_]: %20%20%20%20%20%20%20%20%20%20%20expressions/literal-expr.html
 [_LoopExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/loop-expr.html
 [_MatchExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/match-expr.html
 [_MethodCallExpression_]: %20%20%20%20%20%20%20%20expressions/method-call-expr.html
 [_OperatorExpression_]: %20%20%20%20%20%20%20%20%20%20expressions/operator-expr.html
 [_PathExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20%20expressions/path-expr.html
 [_RangeExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/range-expr.html
 [_ReturnExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/return-expr.html
 [_StructExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20expressions/struct-expr.html
 [_TupleExpression_]: %20%20%20%20%20%20%20%20%20%20%20%20%20expressions/tuple-expr.html
 [_TupleIndexingExpression_]: %20%20%20%20%20expressions/tuple-expr.html#tuple-indexing-expressions

