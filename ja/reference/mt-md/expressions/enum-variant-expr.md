# <!--Enumeration Variant expressions--> 列挙型バリアント式

<!--Enumeration variants can be constructed similarly to structs, using a path to an enum variant instead of to a struct:-->
構造体の代わりに列挙型バリアントへのパスを使用して、列挙型バリアントを構造体と同様に構築できます。

```rust
# enum Message {
#     Quit,
#     WriteString(String),
#     Move { x: i32, y: i32 },
# }
let q = Message::Quit;
let w = Message::WriteString("Some string".to_string());
let m = Message::Move { x: 50, y: 200 };
```
