# <!--Unions--> 組合

> <!--**<sup>Syntax</sup>** \  _Union_ :\ &nbsp;&nbsp;-->
> **<sup>構文</ sup>** \  _Union_ ：\＆nbsp;＆nbsp;
> <!--`union` [IDENTIFIER] &nbsp;-->
> `union` [IDENTIFIER] ＆nbsp;
> <!--[_Generics_]  __?__ -->
> [_Generics_]  __？__ 
> <!--[_WhereClause_]  __?__ -->
> [_WhereClause_]  __？__ 
> <!--`{` [_StructFields_] `}`-->
> `{` [_StructFields_] `}`

<!--A union declaration uses the same syntax as a struct declaration, except with `union` in place of `struct`.-->
共用体宣言は、構造体宣言と同じ構文を使用しますが、構造体の代わりに`union` `struct`ます。

```rust
#[repr(C)]
union MyUnion {
    f1: u32,
    f2: f32,
}
```

<!--The key property of unions is that all fields of a union share common storage.-->
組合の重要な特性は、組合のすべてのフィールドが共通のストレージを共有することです。
<!--As a result writes to one field of a union can overwrite its other fields, and size of a union is determined by the size of its largest field.-->
結果として、共用体の1つのフィールドへの書き込みは他のフィールドを上書きすることができ、共用体のサイズは最大のフィールドのサイズによって決まります。

<!--A value of a union type can be created using the same syntax that is used for struct types, except that it must specify exactly one field:-->
共用体型の値は、構造体型に使用されるのと同じ構文を使用して作成できます。ただし、1つのフィールドを正確に指定する必要がある点が異なります。

```rust
# union MyUnion { f1: u32, f2: f32 }
#
let u = MyUnion { f1: 1 };
```

<!--The expression above creates a value of type `MyUnion` with active field `f1`.-->
上記の式は、アクティブなフィールド`f1`持つ`MyUnion`型の値を作成します。
<!--Active field of a union can be accessed using the same syntax as struct fields:-->
共用体のアクティブフィールドは、structフィールドと同じ構文を使用してアクセスできます。

```rust,ignore
let f = u.f1;
```

<!--Inactive fields can be accessed as well (using the same syntax) if they are sufficiently layout compatible with the current value kept by the union.-->
非アクティブなフィールドは、共用体によって保持されている現在の値と十分にレイアウトが互換性がある場合にも同様の構文を使用してアクセスできます。
<!--Reading incompatible fields results in undefined behavior.-->
互換性のないフィールドを読み取ると、未定義の動作が発生します。
<!--However, the active field is not generally known statically, so all reads of union fields have to be placed in `unsafe` blocks.-->
しかし、アクティブフィールドは一般に静的には知られていないため、すべてのユニオンフィールドの読み込みは`unsafe`で`unsafe`ブロックに配置する必要があります。

```rust
# union MyUnion { f1: u32, f2: f32 }
# let u = MyUnion { f1: 1 };
#
unsafe {
    let f = u.f1;
}
```

<!--Writes to `Copy` union fields do not require reads for running destructors, so these writes don't have to be placed in `unsafe` blocks-->
`Copy`ユニオン・フィールドへの書き込みは、デストラクタを実行するための読み込みを必要としないため、これらの書き込みは`unsafe`で`unsafe`ブロックに配置する必要はありません

```rust
# union MyUnion { f1: u32, f2: f32 }
# let mut u = MyUnion { f1: 1 };
#
u.f1 = 2;
```

<!--Commonly, code using unions will provide safe wrappers around unsafe union field accesses.-->
一般的に、共用体を使用するコードは、安全でない共用体のフィールド・アクセスの周りに安全なラッパーを提供します。

<!--Another way to access union fields is to use pattern matching.-->
ユニオンフィールドにアクセスする別の方法は、パターンマッチングを使用することです。
<!--Pattern matching on union fields uses the same syntax as struct patterns, except that the pattern must specify exactly one field.-->
ユニオンフィールドのパターンマッチングでは、構造体パターンと同じ構文を使用しますが、パターンでは正確に1つのフィールドを指定する必要があります。
<!--Since pattern matching accesses potentially inactive fields it has to be placed in `unsafe` blocks as well.-->
パターンマッチングは潜在的に非アクティブなフィールドにアクセスするため、`unsafe`で`unsafe`ブロックに配置する必要があります。

```rust
# union MyUnion { f1: u32, f2: f32 }
#
fn f(u: MyUnion) {
    unsafe {
        match u {
            MyUnion { f1: 10 } => { println!("ten"); }
            MyUnion { f2 } => { println!("{}", f2); }
        }
    }
}
```

<!--Pattern matching may match a union as a field of a larger structure.-->
パターンマッチングは、より大きな構造のフィールドとしてユニオンにマッチするかもしれません。
<!--In particular, when using a Rust union to implement a C tagged union via FFI, this allows matching on the tag and the corresponding field simultaneously:-->
特に、Rust共用体を使用してFFIを介してCタグ付き共用体を実装する場合、これによりタグと対応するフィールドの同時マッチングが可能になります。

```rust
#[repr(u32)]
enum Tag { I, F }

#[repr(C)]
union U {
    i: i32,
    f: f32,
}

#[repr(C)]
struct Value {
    tag: Tag,
    u: U,
}

fn is_zero(v: Value) -> bool {
    unsafe {
        match v {
            Value { tag: I, u: U { i: 0 } } => true,
            Value { tag: F, u: U { f: 0.0 } } => true,
            _ => false,
        }
    }
}
```

<!--Since union fields share common storage, gaining write access to one field of a union can give write access to all its remaining fields.-->
共用体のフィールドは共通の記憶域を共有するため、共用体の1つのフィールドへの書込みアクセス権を獲得すると、残りのすべてのフィールドへの書込みアクセスが可能になります。
<!--Borrow checking rules have to be adjusted to account for this fact.-->
この事実を考慮に入れて、借り入れチェックルールを調整しなければならない。
<!--As a result, if one field of a union is borrowed, all its remaining fields are borrowed as well for the same lifetime.-->
その結果、組合の1つのフィールドが借用されている場合、残りのフィールドはすべて同じ借用になります。

```rust,ignore
#// ERROR: cannot borrow `u` (via `u.f2`) as mutable more than once at a time
// エラー：一度に複数回mutableを`u`（ `u.f2`経由で）から借りることはできません
fn test() {
    let mut u = MyUnion { f1: 1 };
    unsafe {
        let b1 = &mut u.f1;
                      ---- first mutable borrow occurs here (via `u.f1`)
        let b2 = &mut u.f2;
                      ^^^^ second mutable borrow occurs here (via `u.f2`)
        *b1 = 5;
    }
    - first borrow ends here
    assert_eq!(unsafe { u.f1 }, 5);
}
```

<!--As you could see, in many aspects (except for layouts, safety and ownership) unions behave exactly like structs, largely as a consequence of inheriting their syntactic shape from structs.-->
レイアウト、安全性、所有権を除いて、多くの面で、構造体から構文的形状を継承した結果、構造体とまったく同じように動作します。
<!--This is also true for many unmentioned aspects of Rust language (such as privacy, name resolution, type inference, generics, trait implementations, inherent implementations, coherence, pattern checking, etc etc etc).-->
これは、Rust言語の多くの言及されていない側面（プライバシー、名前解決、型推論、ジェネリックス、特性実装、固有の実装、一貫性、パターン検査などなど）にも当てはまります。

<!--More detailed specification for unions, including unstable bits, can be found in [RFC 1897 "Unions v1.2"](https://github.com/rust-lang/rfcs/pull/1897).-->
不安定なビットを含む、より詳細な共用体の仕様は、[RFC 1897「Unions v1.2」にあり](https://github.com/rust-lang/rfcs/pull/1897)ます。

<!--[IDENTIFIER]: identifiers.html
 [_Generics_]: items/generics.html
 [_WhereClause_]: items/generics.html#where-clauses
 [_StructFields_]: items/structs.html
-->
[IDENTIFIER]: identifiers.html
 [_Generics_]: items/generics.html
 [_WhereClause_]: items/generics.html#where-clauses
 [_StructFields_]: items/structs.html

