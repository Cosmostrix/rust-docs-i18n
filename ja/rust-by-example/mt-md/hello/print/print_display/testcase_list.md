# <!--Testcase: List--> テストケース：リスト

<!--Implementing `fmt::Display` for a structure where the elements must each be handled sequentially is tricky.-->
要素を順次処理する必要がある構造体に対して`fmt::Display`を実装するのは難しいです。
<!--The problem is that each `write!` generates a `fmt::Result`.-->
問題は、それぞれの`write!`が`fmt::Result`生成する`write!`。
<!--Proper handling of this requires dealing with *all* the results.-->
これを適切に処理するには、*すべて*の結果を処理する必要があります。
<!--Rust provides the `?`-->
錆は`?`
<!--operator for exactly this purpose.-->
正確にこの目的のために演算子。

<!--Using `?`-->
を使用して`?`
<!--on `write!` looks like this:-->
`write!`は次のようになります：

```rust,ignore
#// Try `write!` to see if it errors. If it errors, return
#// the error. Otherwise continue.
// 試してみてください`write!`、それがエラーかどうかを確認します。エラーの場合はエラーを返します。そうでなければ続行する。
write!(f, "{}", value)?;
```

<!--Alternatively, you can also use the `try!` macro, which works the same way.-->
あるいは、同じ方法で動作する`try!`マクロを使用することもできます。
<!--This is a bit more verbose and no longer recommended, but you may still see it in older Rust code.-->
これはもう少し冗長であり、もはや推奨されていませんが、以前の錆コードではそれを見ることができます。
<!--Using `try!` looks like this:-->
`try!`を使用する`try!`次のようになります。

```rust,ignore
try!(write!(f, "{}", value));
```

<!--With `?`-->
と`?`
<!--available, implementing `fmt::Display` for a `Vec` is straightforward:-->
`Vec` `fmt::Display`を実装するのは簡単です：

```rust,editable
#//use std::fmt; // Import the `fmt` module.
use std::fmt; //  `fmt`モジュールをインポートします。

#// Define a structure named `List` containing a `Vec`.
//  `Vec`を含む`List`という名前の構造体を定義します。
struct List(Vec<i32>);

impl fmt::Display for List {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
#        // Extract the value using tuple indexing
#        // and create a reference to `vec`.
        // タプルインデックスを使用して値を抽出し、`vec`への参照を作成します。
        let vec = &self.0;

        write!(f, "[")?;

#        // Iterate over `vec` in `v` while enumerating the iteration
#        // count in `count`.
        // 反復回数を列挙しながら、`vec`で`v`を反復処理し`count`。
        for (count, v) in vec.iter().enumerate() {
#            // For every element except the first, add a comma.
#            // Use the ? operator, or try!, to return on errors.
            // 最初の要素を除くすべての要素に対して、カンマを追加します。使用？オペレータ、または試してみてください。
            if count != 0 { write!(f, ", ")?; }
            write!(f, "{}", v)?;
        }

#        // Close the opened bracket and return a fmt::Result value
        // 開いているブラケットを閉じ、fmt:: Resultの値を返します。
        write!(f, "]")
    }
}

fn main() {
    let v = List(vec![1, 2, 3]);
    println!("{}", v);
}
```

### <!--Activity--> アクティビティ

<!--Try changing the program so that the index of each element in the vector is also printed.-->
ベクトルの各要素のインデックスも印刷されるようにプログラムを変更してみてください。
<!--The new output should look like this:-->
新しい出力は次のようになります。

```rust,ignore
[0: 1, 1: 2, 2: 3]
```

### <!--See also--> も参照してください

<!--[`for`][for], [`ref`][ref], [`Result`][result], [`struct`][struct], [`?`][q_mark]-->
[`for`][for]、 [`ref`][ref]、 [`Result`][result]、 [`struct`][struct] [`?`][q_mark]
<!--, and [`vec!`][vec]-->
、および[`vec!`][vec]

<!--[for]: flow_control/for.html
 [result]: std/result.html
 [ref]: scope/borrow/ref.html
 [struct]: custom_types/structs.html
 [q_mark]: std/result/question_mark.html
 [vec]: std/vec.html
-->
[for]: flow_control/for.html
 [result]: std/result.html
 [ref]: scope/borrow/ref.html
 [struct]: custom_types/structs.html
 [q_mark]: std/result/question_mark.html
 [vec]: std/vec.html

