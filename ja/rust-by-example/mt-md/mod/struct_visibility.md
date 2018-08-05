# <!--Struct visibility--> 構造体の可視性

<!--Structs have an extra level of visibility with their fields.-->
構造体は、フィールドとの追加の可視性を持っています。
<!--The visibility defaults to private, and can be overridden with the `pub` modifier.-->
可視性はデフォルトでprivateになり、`pub`修飾子で上書きできます。
<!--This visibility only matters when a struct is accessed from outside the module where it is defined, and has the goal of hiding information (encapsulation).-->
この可視性は、構造体が定義されているモジュールの外部から構造体にアクセスし、情報を隠すこと（カプセル化）を目的とする場合にのみ重要です。

```rust,editable
mod my {
#    // A public struct with a public field of generic type `T`
    // ジェネリック型`T`パブリックフィールドを持つパブリック構造体
    pub struct OpenBox<T> {
        pub contents: T,
    }

#    // A public struct with a private field of generic type `T`
    // ジェネリック型`T`プライベートフィールドを持つパブリック構造体
    #[allow(dead_code)]
    pub struct ClosedBox<T> {
        contents: T,
    }

    impl<T> ClosedBox<T> {
#        // A public constructor method
        // パブリックコンストラクタメソッド
        pub fn new(contents: T) -> ClosedBox<T> {
            ClosedBox {
                contents: contents,
            }
        }
    }
}

fn main() {
#    // Public structs with public fields can be constructed as usual
    // パブリックフィールドを持つパブリック構造体は通常どおり構築できます
    let open_box = my::OpenBox { contents: "public information" };

#    // and their fields can be normally accessed.
    // そのフィールドには通常アクセスできます。
    println!("The open box contains: {}", open_box.contents);

#    // Public structs with private fields cannot be constructed using field names.
#    // Error! `ClosedBox` has private fields
    // プライベートフィールドを持つパブリック構造体は、フィールド名を使用して構築することはできません。エラー！ `ClosedBox`はプライベートフィールドがあります
    //let closed_box = my::ClosedBox { contents: "classified information" };
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる

#    // However, structs with private fields can be created using
#    // public constructors
    // ただし、パブリックコンストラクタを使用してプライベートフィールドを持つ構造体を作成することはできます
    let _closed_box = my::ClosedBox::new("classified information");

#    // and the private fields of a public struct cannot be accessed.
#    // Error! The `contents` field is private
    // パブリック構造体のプライベートフィールドにはアクセスできません。エラー！ `contents`フィールドは非公開です
    //println!("The closed box contains: {}", _closed_box.contents);
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる
}
```

### <!--See also:--> 参照：

<!--[generics][generics] and [methods][methods]-->
[generics][generics]と[methods][methods]

<!--[generics]: generics.html
 [methods]: fn/methods.html
-->
[generics]: generics.html
 [methods]: fn/methods.html

