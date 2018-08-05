# <!--Functions--> 機能

<!--The same set of rules can be applied to functions: a type `T` becomes generic when preceded by `<T>`.-->
同じ規則の組を関数に適用することができます。型`T`は、`<T>`が前に付いたときに汎用的になります。

<!--Using generic functions sometimes requires explicitly specifying type parameters.-->
ジェネリック関数を使用すると、型パラメータを明示的に指定する必要があることがあります
<!--This may be the case if the function is called where the return type is generic, or if the compiler doesn't have enough information to infer the necessary type parameters.-->
戻り値の型が汎用である関数が呼び出された場合、またはコンパイラが必要な型パラメータを推測するのに十分な情報を持っていない場合は、このような場合があります。

<!--A function call with explicitly specified type parameters looks like: `fun::<A, B, ...>()`.-->
明示的に指定された型パラメータを持つ関数呼び出しは、`fun::<A, B, ...>()`ます。

```rust,editable
#//struct A;          // Concrete type `A`.
struct A;          // コンクリートタイプ`A`
#//struct S(A);       // Concrete type `S`.
struct S(A);       // コンクリートタイプ`S`
#//struct SGen<T>(T); // Generic type `SGen`.
struct SGen<T>(T); // 汎用タイプ`SGen`。

#// The following functions all take ownership of the variable passed into
#// them and immediately go out of scope, freeing the variable.
// 次の関数はすべて、渡された変数の所有権を持ち、すぐにスコープから外れ、変数を解放します。

#// Define a function `reg_fn` that takes an argument `_s` of type `S`.
#// This has no `<T>` so this is not a generic function.
// タイプ`S`引数`_s`を取る関数`reg_fn`を定義する。これは`<T>`を持たないので、これは汎用関数ではありません。
fn reg_fn(_s: S) {}

#// Define a function `gen_spec_t` that takes an argument `_s` of type `SGen<T>`.
#// It has been explicitly given the type parameter `A`, but because `A` has not 
#// been specified as a generic type parameter for `gen_spec_t`, it is not generic.
//  `SGen<T>`型の引数`_s`をとる関数`gen_spec_t`を定義します。明示的に型パラメータ`A`が与えられていますが、`A`は`gen_spec_t`ジェネリック型パラメータとして指定されていないため、汎用型ではありません。
fn gen_spec_t(_s: SGen<A>) {}

#// Define a function `gen_spec_i32` that takes an argument `_s` of type `SGen<i32>`.
#// It has been explicitly given the type parameter `i32`, which is a specific type.
#// Because `i32` is not a generic type, this function is also not generic.
//  `SGen<i32>`型の引数`_s`をとる関数`gen_spec_i32`を定義します。特定の型である型パラメータ`i32`が明示的に与えられています。`i32`は汎用タイプではないため、この関数も汎用ではありません。
fn gen_spec_i32(_s: SGen<i32>) {}

#// Define a function `generic` that takes an argument `_s` of type `SGen<T>`.
#// Because `SGen<T>` is preceded by `<T>`, this function is generic over `T`.
//  `SGen<T>`型の引数`_s`をとる`generic`関数を定義します。ので`SGen<T>`が先行する`<T>`は、この機能はオーバー総称である`T`。
fn generic<T>(_s: SGen<T>) {}

fn main() {
#    // Using the non-generic functions
    // 非ジェネリック関数の使用
#//    reg_fn(S(A));          // Concrete type.
    reg_fn(S(A));          // コンクリートタイプ。
#//    gen_spec_t(SGen(A));   // Implicitly specified type parameter `A`.
    gen_spec_t(SGen(A));   // 暗黙的に指定された型パラメータ`A`
#//    gen_spec_i32(SGen(6)); // Implicitly specified type parameter `i32`.
    gen_spec_i32(SGen(6)); // 暗黙的に指定された型パラメータ`i32`。

#    // Explicitly specified type parameter `char` to `generic()`.
    // 型パラメータ`char`を`generic()`明示的に指定します。
    generic::<char>(SGen('a'));

#    // Implicitly specified type parameter `char` to `generic()`.
    //  `generic()`への型パラメータ`char`を暗黙的に指定しました。
    generic(SGen('c'));
}
```

### <!--See also:--> 参照：

<!--[functions][fn] and [`struct` s][structs]-->
[functions][fn]と[`struct s`][structs]

<!--[fn]: fn.html
 [structs]: custom_types/structs.html
-->
[fn]: fn.html
 [structs]: custom_types/structs.html

