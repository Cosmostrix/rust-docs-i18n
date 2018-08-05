# <!--Traits--> 形質

<!--Of course `trait` s can also be generic.-->
もちろん、`trait`一般的でもあり得る。
<!--Here we define one which reimplements the `Drop` `trait` as a generic method to `drop` itself and an input.-->
ここでは、`Drop` `trait`を、それ自体と入力を`drop`する一般的な方法として再実装するものを定義します。

```rust,editable
#// Non-copyable types.
// コピー不可タイプ。
struct Empty;
struct Null;

#// A trait generic over `T`.
//  `T`以上の特性。
trait DoubleDrop<T> {
#    // Define a method on the caller type which takes an
#    // additional single parameter `T` and does nothing with it.
    // 追加の単一パラメータ`T`を取り、それには何もしない呼び出し元の型のメソッドを定義します。
    fn double_drop(self, _: T);
}

#// Implement `DoubleDrop<T>` for any generic parameter `T` and
#// caller `U`.
// 任意の汎用パラメータ`T`と呼び出し元`U`に対して`DoubleDrop<T>`を実装します。
impl<T, U> DoubleDrop<T> for U {
#    // This method takes ownership of both passed arguments,
#    // deallocating both.
    // このメソッドは、渡された両方の引数の所有権を取得し、両方を解放します。
    fn double_drop(self, _: T) {}
}

fn main() {
    let empty = Empty;
    let null  = Null;

#    // Deallocate `empty` and `null`.
    //  Deallocate `empty`と`null`。
    empty.double_drop(null);

    //empty;
    //null;
#    // ^ TODO: Try uncommenting these lines.
    //  ^ TODO：これらの行のコメントを外してみてください。
}
```

### <!--See also:--> 参照：

<!--[`Drop`][Drop], [`struct`][structs], and [`trait`][traits]-->
[`Drop`][Drop]、 [`struct`][structs]、および[`trait`][traits]

<!--[Drop]: https://doc.rust-lang.org/std/ops/trait.Drop.html
 [structs]: custom_types/structs.html
 [traits]: trait.html
-->
[Drop]: https://doc.rust-lang.org/std/ops/trait.Drop.html
 [structs]: custom_types/structs.html
 [traits]: trait.html

