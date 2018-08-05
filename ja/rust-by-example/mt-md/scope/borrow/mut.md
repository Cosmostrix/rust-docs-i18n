# <!--Mutability--> 変異性

<!--Mutable data can be mutably borrowed using `&mut T`.-->
変更可能なデータは、`&mut T`を使用して変更することができます。
<!--This is called a *mutable reference* and gives read/write access to the borrower.-->
これは*変更可能な参照*と呼ばれ、借り手への読み取り/書き込みアクセス権を与えます。
<!--In contrast, `&T` borrows the data via an immutable reference, and the borrower can read the data but not modify it:-->
対照的に、`&T`は不変参照を介してデータを借用し、借り手はデータを読み取ることはできますが、それを変更することはできません。

```rust,editable,ignore,mdbook-runnable
#[allow(dead_code)]
#[derive(Clone, Copy)]
struct Book {
#    // `&'static str` is a reference to a string allocated in read only memory
    //  `&'static str`は、読み取り専用メモリに割り当てられた文字列への参照です
    author: &'static str,
    title: &'static str,
    year: u32,
}

#// This function takes a reference to a book
// この関数は、本を参照します
fn borrow_book(book: &Book) {
    println!("I immutably borrowed {} - {} edition", book.title, book.year);
}

#// This function takes a reference to a mutable book and changes `year` to 2014
// この関数は変更可能なブックを参照し、2014 `year`に変更します
fn new_edition(book: &mut Book) {
    book.year = 2014;
    println!("I mutably borrowed {} - {} edition", book.title, book.year);
}

fn main() {
#    // Create an immutable Book named `immutabook`
    //  `immutabook`という名前の不変のブックを作成する
    let immutabook = Book {
#        // string literals have type `&'static str`
        // 文字列リテラルの型は`&'static str`
        author: "Douglas Hofstadter",
        title: "GĆ¶del, Escher, Bach",
        year: 1979,
    };

#    // Create a mutable copy of `immutabook` and call it `mutabook`
    //  `immutabook`可変コピーを作成し、それを`mutabook`
    let mut mutabook = immutabook;
    
#    // Immutably borrow an immutable object
    // 不変オブジェクトを不本意に借りる
    borrow_book(&immutabook);

#    // Immutably borrow a mutable object
    // 変更可能なオブジェクトを不本意に借りる
    borrow_book(&mutabook);
    
#    // Borrow a mutable object as mutable
    // 変更可能なオブジェクトを借用
    new_edition(&mut mutabook);
    
#    // Error! Cannot borrow an immutable object as mutable
    // エラー！不変オブジェクトを変更可能として借りることはできません
    new_edition(&mut immutabook);
#    // FIXME ^ Comment out this line
    //  FIXME ^この行をコメントアウトする
}
```

### <!--See also:--> 参照：
[`static`][static]
[static]: scope/lifetime/static_lifetime.html
