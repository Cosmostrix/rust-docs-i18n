## <!--Behavior not considered `unsafe`--> `unsafe`ないとみなされ`unsafe`行動

<!--The Rust compiler does not consider the following behaviors  _unsafe_ , though a programmer may (should) find them undesirable, unexpected, or erroneous.-->
Rustコンパイラは、プログラマが望ましくない、予期しない、または間違ったものを見つけられるかもしれませんが、以下の動作は _安全_ ではないと考えません。

##### <!--Deadlocks--> デッドロック
##### <!--Leaks of memory and other resources--> メモリおよびその他のリソースのリーク
##### <!--Exiting without calling destructors--> デストラクタを呼び出さずに終了する
##### <!--Exposing randomized base addresses through pointer leaks--> ポインタリークによるランダム化されたベースアドレスの公開
##### <!--Integer overflow--> 整数オーバーフロー

<!--If a program contains arithmetic overflow, the programmer has made an error.-->
プログラムに算術オーバーフローが含まれていると、プログラマーがエラーを起こしました。
<!--In the following discussion, we maintain a distinction between arithmetic overflow and wrapping arithmetic.-->
以下の説明では、算術オーバーフローとラッピング演算の区別を維持しています。
<!--The first is erroneous, while the second is intentional.-->
最初のものは間違っていますが、2番目のものは意図的なものです。

<!--When the programmer has enabled `debug_assert!` assertions (for example, by enabling a non-optimized build), implementations must insert dynamic checks that `panic` on overflow.-->
プログラマが`debug_assert!`アサーションを有効にした場合（たとえば、最適化されていないビルドを有効にするなど）、実装はオーバーフローで`panic`する動的チェックを挿入する必要があります。
<!--Other kinds of builds may result in `panics` or silently wrapped values on overflow, at the implementation's discretion.-->
実装の裁量で、他の種類のビルドで`panics`やオーバーフロー時の値を静かにラップすることがあります。

<!--In the case of implicitly-wrapped overflow, implementations must provide well-defined (even if still considered erroneous) results by using two's complement overflow conventions.-->
暗黙的にラップされたオーバーフローの場合、実装では、2の補数オーバーフロー規則を使用して、明確な（誤っていると見なされても）結果を提供する必要があります。

<!--The integral types provide inherent methods to allow programmers explicitly to perform wrapping arithmetic.-->
整数型は、プログラマが明示的にラッピング演算を実行できるようにする固有のメソッドを提供します。
<!--For example, `i32::wrapping_add` provides two's complement, wrapping addition.-->
たとえば、`i32::wrapping_add`は、2の補数である追加を提供します。

<!--The standard library also provides a `Wrapping<T>` newtype which ensures all standard arithmetic operations for `T` have wrapping semantics.-->
標準ライブラリも提供`Wrapping<T>`のためのすべての標準的な演算を保証するのnewtype `T`セマンティクスをラップしているが。

<!--See [RFC 560] for error conditions, rationale, and more details about integer overflow.-->
エラー条件、根拠、整数オーバーフローの詳細については、[RFC 560]を参照してください。

[RFC 560]: https://github.com/rust-lang/rfcs/blob/master/text/0560-integer-overflow.md
