# <!--Field access expressions--> フィールドアクセス式

> <!--**<sup>Syntax</sup>** \  _FieldExpression_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _FieldExpression_ ：\＆nbsp;＆nbsp;
> <!--[_Expression_] `.`-->
> [_Expression_] `.`
> [IDENTIFIER]

<!--A  _field expression_  consists of an expression followed by a single dot and an [identifier], when not immediately followed by a parenthesized expression-list (the latter is always a [method call expression]).-->
 _フィールド式_ は、単一のドットと[identifier]あとに括弧で囲まれた式リスト（直後には常に[method call expression]が続きます）が続く場合の _式で_ 構成されます。
<!--A field expression denotes a field of a [struct] or [union].-->
フィールド式は、[struct]または[union] [struct]フィールドを示します。
<!--To call a function stored in a struct, parentheses are needed around the field expression.-->
構造体に格納された関数を呼び出すには、フィールド式の周りにかっこが必要です。

```rust,ignore
mystruct.myfield;
foo().x;
(Struct {a: 10, b: 20}).a;
#//mystruct.method();          // Method expression
mystruct.method();          // メソッド式
#//(mystruct.function_field)() // Call expression containing a field expression
(mystruct.function_field)() // フィールド式を含む呼び出し式
```

<!--A field access is a [place expression] referring to the location of that field.-->
フィールドアクセスは、そのフィールドの場所を参照する[place expression]です。
<!--When the subexpression is [mutable], the field expression is also mutable.-->
部分式が[mutable]場合、フィールド式も変更可能です。

<!--Also, if the type of the expression to the left of the dot is a pointer, it is automatically dereferenced as many times as necessary to make the field access possible.-->
また、ドットの左側の式のタイプがポインタの場合、フィールドアクセスを可能にするために必要な回数だけ自動的に逆参照されます。
<!--In cases of ambiguity, we prefer fewer autoderefs to more.-->
あいまいさがある場合は、autoderefsをもっと少なくするほうが望ましいです。

<!--Finally, the fields of a struct or a reference to a struct are treated as separate entities when borrowing.-->
最後に、構造体のフィールドまたは構造体への参照は、借用時に別個のエンティティとして扱われます。
<!--If the struct does not implement [`Drop`](special-types-and-traits.html#drop) and is stored in a local variable, this also applies to moving out of each of its fields.-->
構造体が[`Drop`](special-types-and-traits.html#drop)を実装しておらず、ローカル変数に格納されている場合は、各フィールドからの移動にも適用されます。
<!--This also does not apply if automatic dereferencing is done though user defined types.-->
これは、ユーザー定義型を使用して自動逆参照が行われている場合には適用されません。

```rust
struct A { f1: String, f2: String, f3: String }
let mut x: A;
# x = A {
#     f1: "f1".to_string(),
#     f2: "f2".to_string(),
#     f3: "f3".to_string()
# };
#//let a: &mut String = &mut x.f1; // x.f1 borrowed mutably
let a: &mut String = &mut x.f1; //  x.f1が借り換えられる
#//let b: &String = &x.f2;         // x.f2 borrowed immutably
let b: &String = &x.f2;         //  x.f2が不変に借りた
#//let c: &String = &x.f2;         // Can borrow again
let c: &String = &x.f2;         // もう一度借りることができる
#//let d: String = x.f3;           // Move out of x.f3
let d: String = x.f3;           //  x.f3から移動する
```

<!--[_Expression_]: expressions.html
 [IDENTIFIER]: identifiers.html
 [method call expression]: expressions/method-call-expr.html
 [struct]: items/structs.html
 [union]: items/unions.html
 [place expression]: expressions.html#place-expressions-and-value-expressions
 [mutable]: expressions.html#mutability
-->
[_Expression_]: expressions.html
 [IDENTIFIER]: identifiers.html
 [method call expression]: expressions/method-call-expr.html
 [struct]: items/structs.html
 [union]: items/unions.html
 [place expression]: expressions.html#place-expressions-and-value-expressions
 [mutable]: expressions.html#mutability

