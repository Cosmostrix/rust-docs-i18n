# <!--Variables--> 変数

<!--A  _variable_  is a component of a stack frame, either a named function parameter, an anonymous [temporary](expressions.html#temporary-lifetimes), or a named local variable.-->
 _変数_ は、名前付き関数パラメーター、匿名の[temporary](expressions.html#temporary-lifetimes)変数、または名前付きのローカル変数のいずれかの、スタックフレームのコンポーネントです。

<!--A  _local variable_  (or *stack-local* allocation) holds a value directly, allocated within the stack's memory.-->
 _ローカル変数_ （または*スタックローカル*割り当て）は、スタックのメモリ内に割り当てられた値を直接保持します。
<!--The value is a part of the stack frame.-->
値はスタックフレームの一部です。

<!--Local variables are immutable unless declared otherwise.-->
ローカル変数は、別途宣言されていなければ変更できません。
<!--For example: `let mut x = ...`.-->
たとえば、`let mut x = ...`。

<!--Function parameters are immutable unless declared with `mut`.-->
`mut`宣言されていない限り、関数のパラメータは不変です。
<!--The `mut` keyword applies only to the following parameter.-->
`mut`キーワードは、次のパラメータにのみ適用されます。
<!--For example: `|mut x, y|`-->
次に例を示します。`|mut x, y|`
<!--and `fn f(mut x: Box<i32>, y: Box<i32>)` declare one mutable variable `x` and one immutable variable `y`.-->
と`fn f(mut x: Box<i32>, y: Box<i32>)` 1つの可変変数`x`と1つの不変変数`y`宣言します。

<!--Methods that take either `self` or `Box<Self>` can optionally place them in a mutable variable by prefixing them with `mut` (similar to regular arguments).-->
`self`または`Box<Self>`いずれかをとるメソッドは、それらにプレフィックスとして`mut`（通常の引数と同様）を付けることで、それらを可変変数に置くこともできます。
<!--For example:-->
例えば：

```rust
trait Changer: Sized {
    fn change(mut self) {}
    fn modify(mut self: Box<Self>) {}
}
```

<!--Local variables are not initialized when allocated.-->
ローカル変数は、割り当て時に初期化されません。
<!--Instead, the entire frame worth of local variables are allocated, on frame-entry, in an uninitialized state.-->
その代わりに、フレーム変数全体が、フレームエントリ上で初期化されていない状態で割り当てられます。
<!--Subsequent statements within a function may or may not initialize the local variables.-->
関数内の後続のステートメントは、ローカル変数を初期化する場合と初期化しない場合があります。
<!--Local variables can be used only after they have been initialized through all reachable control flow paths.-->
ローカル変数は、すべての到達可能な制御フローパスを通じて初期化された後にのみ使用できます。

<!--In this next example, `init_after_if` is initialized after the [`if` expression] while `uninit_after_if` is not because it is not initialized in the `else` case.-->
この次の例では、`init_after_if`は[`if` expression]後で初期化され、`uninit_after_if`は`else` caseでは初期化されていないため初期化されません。

```rust
# fn random_bool() -> bool { true }
fn initialization_example() {
    let init_after_if: ();
    let uninit_after_if: ();

    if random_bool() {
        init_after_if = ();
        uninit_after_if = ();
    } else {
        init_after_if = ();
    }

#//    init_after_if; // ok
    init_after_if; //  OK
#    // uninit_after_if; // err: use of possibly uninitialized `uninit_after_if`
    //  uninit_after_if; // err：おそらく初期化されていない`uninit_after_if`使用
}
```
