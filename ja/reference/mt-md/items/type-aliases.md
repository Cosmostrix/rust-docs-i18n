# <!--Type aliases--> タイプエイリアス

> <!--**<sup>Syntax</sup>** \  _TypeAlias_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _TypeAlias_ ：\＆nbsp;＆nbsp;
> <!--`type` [IDENTIFIER] &nbsp;-->
> `type` [IDENTIFIER] ＆NBSP;
> <!--[_Generics_]  __?__ -->
> [_Generics_]  __？__ 
> <!--[_WhereClause_]  __?__ -->
> [_WhereClause_]  __？__ 
> <!--`=` [_Type_] `;`-->
> `=` [_Type_] `;`

<!--A  _type alias_  defines a new name for an existing [type].-->
 _タイプエイリアス_ は、既存の[type]新しい名前を定義します。
<!--Type aliases are declared with the keyword `type`.-->
型エイリアスはキーワード`type`宣言されます。
<!--Every value has a single, specific type, but may implement several different traits, or be compatible with several different type constraints.-->
すべての値は単一の特定の型を持ちますが、いくつかの異なる特性を実装したり、いくつかの異なる型の制約と互換性があります。

[type]: types.html

<!--For example, the following defines the type `Point` as a synonym for the type `(u8, u8)`, the type of pairs of unsigned 8 bit integers:-->
たとえば、次の例では、型`Point` `(u8, u8)`シノニムとして、`Point`型を符号なし8ビット整数のペアの型として定義しています。

```rust
type Point = (u8, u8);
let p: Point = (41, 68);
```

<!--A type alias to an enum type cannot be used to qualify the constructors:-->
列挙型の型エイリアスは、コンストラクタを修飾するために使用できません。

```rust
enum E { A }
type F = E;
#//let _: F = E::A;  // OK
let _: F = E::A;  //  [OK]
#// let _: F = F::A;  // Doesn't work
//  _：F = F:: A; //動作しません
```

<!--[IDENTIFIER]: identifiers.html
 [_Generics_]: items/generics.html
 [_WhereClause_]: items/generics.html#where-clauses
 [_Type_]: types.html
-->
[IDENTIFIER]: identifiers.html
 [_Generics_]: items/generics.html
 [_WhereClause_]: items/generics.html#where-clauses
 [_Type_]: types.html

