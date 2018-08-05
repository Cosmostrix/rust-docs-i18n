# <!--Parameter Environment--> パラメータ環境

<!--When working with associated and/or or generic items (types, constants, functions/methods) it is often relevant to have more information about the `Self` or generic parameters.-->
関連項目や汎用項目（型、定数、関数/メソッド）を操作する場合は、`Self`またはgenericパラメータに関する詳細情報が必要な場合があります。
<!--Trait bounds and similar information is encoded in the `ParamEnv`.-->
特性境界および同様の情報は、`ParamEnv`コード化されてい`ParamEnv`。
<!--Often this is not enough information to obtain things like the type's `Layout`, but you can do all kinds of other checks on it (eg whether a type implements `Copy`) or you can evaluate an associated constant whose value does not depend on anything from the parameter environment.-->
多くの場合、これは型の`Layout`ようなものを取得するのに十分な情報ではありませんが、他のすべての種類のチェックを行うことができます（たとえば、型が`Copy`実装するかどうか）、またはパラメータの値に依存しない環境。

<!--For example if you have a function-->
たとえば、関数がある場合

```rust
fn foo<T: Copy>(t: T) {
}
```

<!--the parameter environment for that function is `[T: Copy]`.-->
その関数のパラメータ環境は`[T: Copy]`です。
<!--This means any evaluation within this function will, when accessing the type `T`, know about its `Copy` bound via the parameter environment.-->
つまり、この関数内の評価は、タイプ`T`にアクセスするときに、パラメータ環境を介してその`Copy`バインドについて知っていることを意味します。

<!--Although you can obtain a valid `ParamEnv` for any item via `tcx.param_env(def_id)`, this `ParamEnv` can be too generic for your use case.-->
`tcx.param_env(def_id)`を`ParamEnv`して任意の項目に対して有効な`ParamEnv`を取得することはできますが、この`ParamEnv`はユースケースにはあまりにも汎用性があります。
<!--Using the `ParamEnv` from the surrounding context can allow you to evaluate more things.-->
周囲のコンテキストから`ParamEnv`を使用すると、より多くのものを評価することができます。

<!--Another great thing about `ParamEnv` is that you can use it to bundle the thing depending on generic parameters (eg a `Ty`) by calling `param_env.and(ty)`.-->
`ParamEnv`についてのもう一つの素晴らしい点は、`param_env.and(ty)`呼び出すことによって、汎用パラメータ（例えば`Ty`）に依存するものをバンドルするのに使用できることです。
<!--This will produce a `ParamEnvAnd<Ty>`, making clear that you should probably not be using the inner value without taking care to also use the `ParamEnv`.-->
これにより、`ParamEnvAnd<Ty>`が生成され、`ParamEnvAnd<Ty>`も使用することなく内部値を使用しないで`ParamEnv`。
