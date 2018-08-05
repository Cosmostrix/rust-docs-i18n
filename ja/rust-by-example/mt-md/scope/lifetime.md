# <!--Lifetimes--> 生涯

<!--A *lifetime* is a construct the compiler (or more specifically, its *borrow checker*) uses to ensure all borrows are valid.-->
*生涯*は、すべての借用が有効であることを保証するためにコンパイラ（または具体的には、*借用チェッカー*）が使用する構造です。
<!--Specifically, a variable's lifetime begins when it is created and ends when it is destroyed.-->
具体的には、変数の生存期間は作成時に開始され、破壊された時点で終了します。
<!--While lifetimes and scopes are often referred to together, they are not the same.-->
生涯とスコープはしばしば一緒に参照されますが、それらは同じではありません。

<!--Take, for example, the case where we borrow a variable via `&`.-->
たとえば、`&`を介して変数を借りる場合を考えてみましょう。
<!--The borrow has a lifetime that is determined by where it is declared.-->
借りは宣言された場所によって決定される寿命を持っています。
<!--As a result, the borrow is valid as long as it ends before the lender is destroyed.-->
その結果、貸し手は破壊される前に終了する限り、貸借は有効です。
<!--However, the scope of the borrow is determined by where the reference is used.-->
しかし、借用の範囲は、参照が使用される場所によって決定されます。

<!--In the following example and in the rest of this section, we will see how lifetimes relate to scopes, as well as how the two differ.-->
次の例とこのセクションの残りの部分では、生存時間がスコープにどのように関係しているか、そしてその2つの違いについても見ていきます。

```rust,editable
#// Lifetimes are annotated below with lines denoting the creation
#// and destruction of each variable.
#// `i` has the longest lifetime because its scope entirely encloses 
#// both `borrow1` and `borrow2`. The duration of `borrow1` compared 
#// to `borrow2` is irrelevant since they are disjoint.
// ライフタイムは、各変数の作成および破壊を示す線で以下の注釈が付けられています。その範囲が`borrow1`と`borrow2`両方を完全に囲んでいるので、`i`は一番長い生涯を持っています。`borrow1`と比較した`borrow2`の持続時間は、それらが互いに素であるため無関係です。
fn main() {
#//    let i = 3; // Lifetime for `i` starts. ────────────────┐
    let i = 3; //  `i`生涯が始まります。────────────────────────────────────┘
#    //                                                     │
    //  │
#//    { //                                                   │
    { //  │
#//        let borrow1 = &i; // `borrow1` lifetime starts. ──┐│
        let borrow1 = &i; //  `borrow1`生涯が始まります。─┐│
#        //                                                ││
        //  ││
#//        println!("borrow1: {}", borrow1); //              ││
        println!("borrow1: {}", borrow1); //  ││
#//    } // `borrow1 ends. ──────────────────────────────────┘│
    } //  `borrow1が終了します。───────────────────────────────────────────────────────────────────────────
#    //                                                     │
#    //                                                     │
    //  ││
#//    { //                                                   │
    { //  │
#//        let borrow2 = &i; // `borrow2` lifetime starts. ──┐│
        let borrow2 = &i; //  `borrow2`生涯が始まります。─┐│
#        //                                                ││
        //  ││
#//        println!("borrow2: {}", borrow2); //              ││
        println!("borrow2: {}", borrow2); //  ││
#//    } // `borrow2` ends. ─────────────────────────────────┘│
    } //  `borrow2`は終了する。─────────────────────────────────────────────────────────────────────────
#    //                                                     │
    //  │
#//}   // Lifetime ends. ─────────────────────────────────────┘
}   // 生涯は終わる。───────────────────────────────────────────────────────────────────────────────────────────────
```

<!--Note that no names or types are assigned to label lifetimes.-->
ラベルの存続期間には名前やタイプが割り当てられていないことに注意してください。
<!--This restricts how lifetimes will be able to be used as we will see.-->
これは、私たちが見るように、生涯がどのように使用できるかを制限します。
