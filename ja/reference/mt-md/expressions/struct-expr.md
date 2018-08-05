# <!--Struct expressions--> 構造式

<!--There are several forms of struct expressions.-->
構造式にはいくつかの形式があります。
<!--A  _struct expression_  consists of the [path] of a [struct item](items/structs.html), followed by a brace-enclosed list of zero or more comma-separated name-value pairs, providing the field values of a new instance of the struct.-->
 _構造体式_ は、[構造体項目の](items/structs.html) [path]の後に、0個以上のカンマ区切りの名前と値のペアのブレースで囲まれたリストが続き、構造体の新しいインスタンスのフィールド値を提供します。
<!--A field name can be any [identifier], and is separated from its value expression by a colon.-->
フィールド名は任意の[identifier]、値の式からコロンで区切られます。
<!--In the case of a tuple struct the field names are numbers corresponding to the position of the field.-->
タプル構造体の場合、フィールド名はフィールドの位置に対応する数字です。
<!--The numbers must be written in decimal, containing no underscores and with no leading zeros or integer suffix.-->
数字は、アンダースコアを含まず、先行ゼロまたは整数接尾辞を含まない10進数で書かなければなりません。
<!--A value of a [union](items/unions.html) type can also be created using this syntax, except that it must specify exactly one field.-->
[union](items/unions.html)型の値は、この構文を使用して作成することもできますが、1つのフィールドを正確に指定する必要がある点が異なります。

<!--Struct expressions can't be used directly in the head of a [loop] or an [if], [if let] or [match] expression.-->
構造体の表現はの頭の中で直接使用することはできません[loop]またはAN [if]、 [if let]または[match]式を。
<!--But struct expressions can still be in used inside parentheses, for example.-->
しかし、構造体式は括弧の中で使用することができます。

<!--A  _tuple struct expression_  consists of the path of a struct item, followed by a parenthesized list of one or more comma-separated expressions (in other words, the path of a struct item followed by a tuple expression).-->
 _タプル構造体式_ は、構造体項目のパスの後に、1つ以上のカンマ区切り式のカッコで囲まれたリスト（つまり、構造項目の後にタプル式が続くパス）で構成されます。
<!--The struct item must be a tuple struct item.-->
構造体アイテムはタプル構造体アイテムでなければなりません。

<!--A  _unit-like struct expression_  consists only of the path of a struct item.-->
 _ユニット様の構造式_ は、構造体項目のパスのみから構成されます。

<!--The following are examples of struct expressions:-->
構造式の例を次に示します。

```rust
# struct Point { x: f64, y: f64 }
# struct NothingInMe { }
# struct TuplePoint(f64, f64);
# mod game { pub struct User<'a> { pub name: &'a str, pub age: u32, pub score: usize } }
# struct Cookie; fn some_fn<T>(t: T) {}
Point {x: 10.0, y: 20.0};
NothingInMe {};
TuplePoint(10.0, 20.0);
#//TuplePoint { 0: 10.0, 1: 20.0 }; // Results in the same value as the above line
TuplePoint { 0: 10.0, 1: 20.0 }; // 上記の結果と同じ値になります
let u = game::User {name: "Joe", age: 35, score: 100_000};
some_fn::<Cookie>(Cookie);
```

<!--A struct expression forms a new value of the named struct type.-->
構造体式は、指定された構造体型の新しい値を形成します。
<!--Note that for a given *unit-like* struct type, this will always be the same value.-->
与えられた*ユニットのような*構造体型の場合、これは常に同じ値になることに注意してください。

<!--A struct expression can terminate with the syntax `..` followed by an expression to denote a functional update.-->
構造体発現は、構文で終了することができる`..`機能更新を意味する表現が続きます。
<!--The expression following `..` (the base) must have the same struct type as the new struct type being formed.-->
`..`（基底）に続く式は、新しい構造体型と同じ構造体型を持たなければなりません。
<!--The entire expression denotes the result of constructing a new struct (with the same type as the base expression) with the given values for the fields that were explicitly specified and the values in the base expression for all other fields.-->
式全体は、明示的に指定されたフィールドの値と他のすべてのフィールドの基本式の値を持つ新しい構造体（基本式と同じ型）を構築した結果を示します。
<!--Just as with all struct expressions, all of the fields of the struct must be [visible](visibility-and-privacy.html), even those not explicitly named.-->
すべての構造体式と同様に、構造体のすべてのフィールドが明示的に指定されていなくても[visible](visibility-and-privacy.html)でなければなりません。

```rust
# struct Point3d { x: i32, y: i32, z: i32 }
let base = Point3d {x: 1, y: 2, z: 3};
Point3d {y: 0, z: 10, .. base};
```

## <!--Struct field init shorthand--> 構造体フィールドのinit短縮形

<!--When initializing a data structure (struct, enum, union) with named (but not numbered) fields, it is allowed to write `fieldname` as a shorthand for `fieldname: fieldname`.-->
名前の（しかし、番号なし）フィールドを持つデータ構造体（構造体、列挙型、労働組合）を初期化する場合は、書き込みを許可された`fieldname`の省略形として`fieldname: fieldname`。
<!--This allows a compact syntax with less duplication.-->
これにより、重複の少ないコンパクトな構文が可能になります。

<!--Example:-->
例：

```rust
# struct Point3d { x: i32, y: i32, z: i32 }
# let x = 0;
# let y_value = 0;
# let z = 0;
Point3d { x: x, y: y_value, z: z };
Point3d { x, y: y_value, z };
```

<!--[IDENTIFIER]: identifiers.html
 [path]: paths.html
 [loop]: expressions/loop-expr.html
 [if]: expressions/if-expr.html#if-expressions
 [if let]: expressions/if-expr.html#if-let-expressions
 [match]: expressions/match-expr.html
-->
[IDENTIFIER]: identifiers.html
 [path]: paths.html
 [loop]: expressions/loop-expr.html
 [if]: expressions/if-expr.html#if-expressions
 [if let]: expressions/if-expr.html#if-let-expressions
 [match]: expressions/match-expr.html

