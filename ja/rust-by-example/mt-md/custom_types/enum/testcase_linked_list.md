# <!--Testcase: linked-list--> テストケース：リンクリスト

<!--A common use for `enums` is to create a linked-list:-->
`enums`一般的な使い方は、リンクされたリストを作成することです：

```rust,editable
use List::*;

enum List {
#    // Cons: Tuple struct that wraps an element and a pointer to the next node
    // 短所：要素とポインタを次のノードにラップするタプル構造体
    Cons(u32, Box<List>),
#    // Nil: A node that signifies the end of the linked list
    //  Nil：リンクリストの終わりを示すノード
    Nil,
}

#// Methods can be attached to an enum
// メソッドを列挙型にアタッチすることができます
impl List {
#    // Create an empty list
    // 空のリストを作成する
    fn new() -> List {
#        // `Nil` has type `List`
        //  `Nil`は`List`型があります
        Nil
    }

#    // Consume a list, and return the same list with a new element at its front
    // リストを消費し、新しい要素を持つ同じリストを前面に返します
    fn prepend(self, elem: u32) -> List {
#        // `Cons` also has type List
        //  `Cons`にはList型もあります
        Cons(elem, Box::new(self))
    }

#    // Return the length of the list
    // リストの長さを返す
    fn len(&self) -> u32 {
#        // `self` has to be matched, because the behavior of this method
#        // depends on the variant of `self`
#        // `self` has type `&List`, and `*self` has type `List`, matching on a
#        // concrete type `T` is preferred over a match on a reference `&T`
        //  `self`この方法の動作は、の変形に依存するため、一致しなければならない`self` `self`入力た`&List`、及び`*self`入力した`List`コンクリート型に一致する、`T`基準に一致よりも好ましい`&T`
        match *self {
#            // Can't take ownership of the tail, because `self` is borrowed;
#            // instead take a reference to the tail
            //  `self`が借りているので、尾の所有権を取ることはできません。代わりにテールへの参照を取る
            Cons(_, ref tail) => 1 + tail.len(),
#            // Base Case: An empty list has zero length
            // ベースケース：空のリストの長さはゼロです
            Nil => 0
        }
    }

#    // Return representation of the list as a (heap allocated) string
    // リストの表示を（割り当てられたヒープの）文字列として返します。
    fn stringify(&self) -> String {
        match *self {
            Cons(head, ref tail) => {
#                // `format!` is similar to `print!`, but returns a heap
#                // allocated string instead of printing to the console
                //  `format!`は`print!`と似ていますが、コンソールに出力する代わりにヒープ割り当て文字列を返します
                format!("{}, {}", head, tail.stringify())
            },
            Nil => {
                format!("Nil")
            },
        }
    }
}

fn main() {
#    // Create an empty linked list
    // 空のリンクリストを作成する
    let mut list = List::new();

#    // Prepend some elements
    // いくつかの要素を先頭に追加する
    list = list.prepend(1);
    list = list.prepend(2);
    list = list.prepend(3);

#    // Show the final state of the list
    // リストの最終状態を表示する
    println!("linked list has length: {}", list.len());
    println!("{}", list.stringify());
}
```

### <!--See also:--> 参照：

<!--[`Box`][box] and [methods][methods]-->
[`Box`][box]と[methods][methods]

<!--[box]: std/box.html
 [methods]: fn/methods.html
-->
[box]: std/box.html
 [methods]: fn/methods.html

