# <!--Structs--> 構造

> <!--**<sup>Syntax</sup>** \  _Struct_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _Struct_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!-- _StructStruct_  \ &nbsp;&nbsp;-->
>  _StructStruct_  \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!-- _TupleStruct_ -->
>  _TupleStruct_ 
> 
> <!-- _StructStruct_ :\ &nbsp;&nbsp;-->
>  _StructStruct_ ：\＆nbsp;＆nbsp;
> <!--`struct` [IDENTIFIER] &nbsp;-->
> `struct` [IDENTIFIER] ＆nbsp;
> <!--[_Generics_]  __?__ -->
> [_Generics_]  __？__ 
> <!--[_WhereClause_]  __?__ -->
> [_WhereClause_]  __？__ 
> <!--(`{`  _StructFields_   __?__  `}` | `;`)-->
> （`{`  _StructFields_   __？__  `}` | `;`）
> 
> <!-- _TupleStruct_ :\ &nbsp;&nbsp;-->
>  _TupleStruct_ ：\＆nbsp;＆nbsp;
> <!--`struct` [IDENTIFIER] &nbsp;-->
> `struct` [IDENTIFIER] ＆nbsp;
> <!--[_Generics_]  __?__ -->
> [_Generics_]  __？__ 
> <!--`(`  _TupleFields_   __?__  `)` [_WhereClause_]  __?__ -->
> `(`  _TupleFields_   __？__  `)` [_WhereClause_]  __？__ 
> `;`
> <!-- _StructFields_ :\ &nbsp;&nbsp;-->
>  _StructFields_ ：\＆nbsp;＆nbsp;
> <!-- _StructField_  (`,`  _StructField_ )  __\ *</sup> `,`<sup>?</sup> _StructField_:\ &nbsp;&nbsp;*__ -->
>  _StructField_ （ `,`  _StructField_ ）  __\ *</ sup> `、` <sup>？</ sup> _StructField_：\＆nbsp;＆nbsp;*__ 
> <!-- __*[_OuterAttribute_]<sup>\*__  \ &nbsp;&nbsp;-->
>  __*[_OuterAttribute _] <sup> \*__  \＆nbsp;＆nbsp;
> <!--[_Visibility_] &nbsp;&nbsp;-->
> [_Visibility_] ＆nbsp;＆nbsp;
> <!--[IDENTIFIER] `:` [_Type_]-->
> [IDENTIFIER] `:` [_Type_]
> 
> <!-- _TupleFields_ :\ &nbsp;&nbsp;-->
>  _TupleFields_ ：\＆nbsp;＆nbsp;
> <!-- _TupleField_  (`,`  _TupleField_ )  __\ *</sup> `,`<sup>?</sup> _TupleField_:\ &nbsp;&nbsp;*__ -->
>  _TupleField_ （ `,`  _TupleField_ ）  __\ *</ sup> `、` <sup>？</ sup> _TupleField_：\＆nbsp;＆nbsp;*__ 
> <!-- __*[_OuterAttribute_]<sup>\*__  \ &nbsp;&nbsp;-->
>  __*[_OuterAttribute _] <sup> \*__  \＆nbsp;＆nbsp;
> <!--[_Visibility_] &nbsp;&nbsp;-->
> [_Visibility_] ＆nbsp;＆nbsp;
> [_Type_]

<!--A  _struct_  is a nominal [struct type] defined with the keyword `struct`.-->
 _構造体_ は、キーワード`struct`定義された公称[struct type]です。

<!--An example of a `struct` item and its use:-->
`struct`アイテムとその使用例：

```rust
struct Point {x: i32, y: i32}
let p = Point {x: 10, y: 11};
let px: i32 = p.x;
```

<!--A  _tuple struct_  is a nominal [tuple type], also defined with the keyword `struct`.-->
 _タプル構造体_ は公称[tuple type]で、キーワード`struct`定義されています。
<!--For example:-->
例えば：

<!--[struct type]: types.html#struct-types
 [tuple type]: types.html#tuple-types
-->
[struct type]: types.html#struct-types
 [tuple type]: types.html#tuple-types


```rust
struct Point(i32, i32);
let p = Point(10, 11);
let px: i32 = match p { Point(x, _) => x };
```

<!--A  _unit-like struct_  is a struct without any fields, defined by leaving off the list of fields entirely.-->
 _ユニットのような構造体_ は、フィールドのない _構造体で_ あり、フィールドのリストを完全に残して定義されます。
<!--Such a struct implicitly defines a constant of its type with the same name.-->
このような構造体は、同じ名前の型の定数を暗黙的に定義します。
<!--For example:-->
例えば：

```rust
struct Cookie;
let c = [Cookie, Cookie {}, Cookie, Cookie {}];
```

<!--is equivalent to-->
は

```rust
struct Cookie {}
const Cookie: Cookie = Cookie {};
let c = [Cookie, Cookie {}, Cookie, Cookie {}];
```

<!--The precise memory layout of a struct is not specified.-->
構造体の正確なメモリレイアウトは指定されていません。
<!--One can specify a particular layout using the [`repr` attribute].-->
[`repr` attribute]を使って特定のレイアウトを指定することができます。

[`repr` attribute]: attributes.html#ffi-attributes

<!--[_OuterAttribute_]: attributes.html
 [IDENTIFIER]: identifiers.html
 [_Generics_]: items/generics.html
 [_WhereClause_]: items/generics.html#where-clauses
 [_Visibility_]: visibility-and-privacy.html
 [_Type_]: types.html
-->
[_OuterAttribute_]: attributes.html
 [IDENTIFIER]: identifiers.html
 [_Generics_]: items/generics.html
 [_WhereClause_]: items/generics.html#where-clauses
 [_Visibility_]: visibility-and-privacy.html
 [_Type_]: types.html

