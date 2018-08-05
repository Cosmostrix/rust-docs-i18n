# <!--Functions--> 機能

<!--A  _function_  consists of a [block], along with a name and a set of parameters.-->
 _関数_ は、名前とパラメータのセットとともに[block]で構成されます。
<!--Other than a name, all these are optional.-->
名前以外はすべてオプションです。
<!--Functions are declared with the keyword `fn`.-->
関数はキーワード`fn`宣言されます。
<!--Functions may declare a set of *input* [*variables*][variables] as parameters, through which the caller passes arguments into the function, and the *output* [*type*][type] of the value the function will return to its caller on completion.-->
関数は、呼び出し元が引数を関数に渡すための*入力* [*variables*][variables]セットをパラメータとして宣言し、関数が完了時に呼び出し元に返す値の*出力* [*type*][type]を宣言することができます。

<!--When referred to, a  _function_  yields a first-class *value* of the corresponding zero-sized [*function item type*], which when called evaluates to a direct call to the function.-->
 _関数を_ 参照すると、対応するサイズゼロの[*function item type*]ファーストクラスの*値*が生成されます。[*function item type*]、呼び出されたときに関数の直接呼び出しを評価します。

<!--For example, this is a simple function: ` ``rust fn answer_to_life_the_universe_and_everything() -> i32 { return 42; }``-->
例えば、これは単純な関数です： ` ``rust fn answer_to_life_the_universe_and_everything() -> i32 { return 42; }``
<!--``rust fn answer_to_life_the_universe_and_everything() -> i32 { return 42; }`` `-->
``rust fn answer_to_life_the_universe_and_everything() -> i32 { return 42; }`` `

<!--As with `let` bindings, function arguments are irrefutable patterns, so any pattern that is valid in a let binding is also valid as an argument:-->
`let`バインディングと同様に、関数引数は反駁可能なパターンなので、letバインディングで有効なパターンも引数として有効です。

```rust
fn first((value, _): (i32, i32)) -> i32 { value }
```

<!--The block of a function is conceptually wrapped in a block that binds the argument patterns and then `return` s the value of the function's block.-->
関数のブロックは、引数パターンをバインドしたブロックに概念的にラップされ、関数のブロックの値が`return`ます。
<!--This means that the tail expression of the block, if evaluated, ends up being returned to the caller.-->
これは、ブロックの末尾の式が評価されると、呼び出し元に返されることを意味します。
<!--As usual, an explicit return expression within the body of the function will short-cut that implicit return, if reached.-->
いつものように、関数本体の明示的なリターン式は、暗黙的なリターンに達した場合にそれを短縮します。

<!--For example, the function above behaves as if it was written as:-->
たとえば、上記の関数は、次のように記述されているかのように動作します。

```rust,ignore
#// argument_0 is the actual first argument passed from the caller
//  argument_0は、呼び出し元から渡された実際の最初の引数です。
let (value, _) = argument_0;
return {
    value
};
```

## <!--Generic functions--> 汎用関数

<!--A  _generic function_  allows one or more  _parameterized types_  to appear in its signature.-->
 _ジェネリック関数_ は、1つまたは複数の _パラメータ化された型_ をそのシグネチャに現れるようにします。
<!--Each type parameter must be explicitly declared in an angle-bracket-enclosed and comma-separated list, following the function name.-->
それぞれの型パラメータは、関数名の後ろに角括弧で囲んだカンマ区切りリストで明示的に宣言する必要があります。

```rust
#// foo is generic over A and B
//  fooはAとBに共通です

fn foo<A, B>(x: A, y: B) {
# }
```

<!--Inside the function signature and body, the name of the type parameter can be used as a type name.-->
関数シグネチャとボディの内部では、型パラメータの名前を型名として使用できます。
<!--[Trait] bounds can be specified for type parameters to allow methods with that trait to be called on values of that type.-->
[Trait]境界を型パラメータに指定して、その特性を持つメソッドをその型の値で呼び出すことができます。
<!--This is specified using the `where` syntax:-->
これは`where`構文を使用して指定します。

```rust
# use std::fmt::Debug;
fn foo<T>(x: T) where T: Debug {
# }
```

<!--When a generic function is referenced, its type is instantiated based on the context of the reference.-->
汎用関数が参照されると、その型は参照のコンテキストに基づいてインスタンス化されます。
<!--For example, calling the `foo` function here:-->
たとえば、`foo`関数をここで呼び出すと、次のようになります。

```rust
use std::fmt::Debug;

fn foo<T>(x: &[T]) where T: Debug {
#    // details elided
    // 詳細は省略されました
}

foo(&[1, 2]);
```

<!--will instantiate type parameter `T` with `i32`.-->
`i32`型パラメータ`T`をインスタンス化します。

<!--The type parameters can also be explicitly supplied in a trailing [path] component after the function name.-->
型パラメータは、関数名の後に続く[path]コンポーネントで明示的に指定することもできます。
<!--This might be necessary if there is not sufficient context to determine the type parameters.-->
これは、型パラメータを決定するのに十分なコンテキストがない場合に必要となる可能性があります。
<!--For example, `mem::size_of::<u32>() == 4`.-->
例えば、`mem::size_of::<u32>() == 4`です。

## <!--Extern functions--> Extern関数

<!--Extern functions are part of Rust's foreign function interface, providing the opposite functionality to [external blocks].-->
Extern関数はRustの外部関数インタフェースの一部であり、[external blocks]は逆の機能を提供し[external blocks]。
<!--Whereas external blocks allow Rust code to call foreign code, extern functions with bodies defined in Rust code  _can be called by foreign code_ .-->
外部ブロックはRustコードで外部コードを呼び出す _ことができますが_ 、Rustコードで定義された本体の外部関数は外部コードによって呼び出す _ことができます_ 。
<!--They are defined in the same way as any other Rust function, except that they have the `extern` modifier.-->
それらは`extern`修飾子を持っていることを除けば、他のRust関数と同じ方法で定義されます。

```rust
#// Declares an extern fn, the ABI defaults to "C"
//  extern fnを宣言し、ABIのデフォルトは "C"
extern fn new_i32() -> i32 { 0 }

#// Declares an extern fn with "stdcall" ABI
//  extern fnと "stdcall"ABIを宣言する
# #[cfg(target_arch = "x86_64")]
extern "stdcall" fn new_i32_stdcall() -> i32 { 0 }
```

<!--Unlike normal functions, extern fns have type `extern "ABI" fn()`.-->
通常の関数とは異なり、extern fnは`extern "ABI" fn()`です。
<!--This is the same type as the functions declared in an extern block.-->
これは、externブロックで宣言された関数と同じ型です。

```rust
# extern fn new_i32() -> i32 { 0 }
let fptr: extern "C" fn() -> i32 = new_i32;
```

<!--As non-Rust calling conventions do not support unwinding, unwinding past the end of an extern function will cause the process to abort.-->
非Rust呼び出し規約は巻き戻しをサポートしていないため、extern関数の終わりを過ぎて巻き戻すと、プロセスが中止されます。
<!--In LLVM, this is implemented by executing an illegal instruction.-->
LLVMでは、これは不正な命令を実行することによって実現されます。

## <!--Function attributes--> 関数属性

<!--Inner [attributes] on the function's block apply to the function item as a whole.-->
関数のブロックの内部[attributes]は、関数項目全体に適用されます。

<!--For example, this function will only be available while running tests.-->
たとえば、この機能はテストの実行中にのみ使用できます。

```
fn test_only() {
    #![test]
}
```

> <!--Note: Except for lints, it is idiomatic to only use outer attributes on function items.-->
> 注意：lintsを除いて、関数項目の外部属性のみを使用するのは慣習的です。

<!--[external blocks]: items/external-blocks.html
 [path]: paths.html
 [block]: expressions/block-expr.html
 [variables]: variables.html
 [type]: types.html
 [*function item type*]: types.html#function-item-types
 [Trait]: items/traits.html
 [attributes]: attributes.html
-->
[external blocks]: items/external-blocks.html
 [path]: paths.html
 [block]: expressions/block-expr.html
 [variables]: variables.html
 [type]: types.html
 [*function item type*]: types.html#function-item-types
 [Trait]: items/traits.html
 [attributes]: attributes.html

