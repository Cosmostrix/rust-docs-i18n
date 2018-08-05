# <!--Drop Flags--> ドロップフラグ

<!--The examples in the previous section introduce an interesting problem for Rust.-->
前のセクションの例では、Rustの興味深い問題を紹介しています。
<!--We have seen that it's possible to conditionally initialize, deinitialize, and reinitialize locations of memory totally safely.-->
条件付きでメモリの位置を完全に安全に初期化、初期化解除、再初期化することが可能であることがわかりました。
<!--For Copy types, this isn't particularly notable since they're just a random pile of bits.-->
コピータイプの場合、これは単なるランダムなビットなので、特に注目に値しません。
<!--However types with destructors are a different story: Rust needs to know whether to call a destructor whenever a variable is assigned to, or a variable goes out of scope.-->
しかし、デストラクタの型は別の話です：Rustは、変数が割り当てられるたびにデストラクタを呼び出すか、変数がスコープから外れるかを知る必要があります。
<!--How can it do this with conditional initialization?-->
これを条件付き初期化でどのように行うことができますか？

<!--Note that this is not a problem that all assignments need worry about.-->
これはすべての割り当てが心配する必要があるという問題ではないことに注意してください。
<!--In particular, assigning through a dereference unconditionally drops, and assigning in a `let` unconditionally doesn't drop:-->
特に、逆参照によって無条件に割り振ることで割り振り、無条件に`let`代入することは中止しません。

```
#//let mut x = Box::new(0); // let makes a fresh variable, so never need to drop
let mut x = Box::new(0); // 新鮮な変数を作るので、決して落とす必要はありません
let y = &mut x;
#//*y = Box::new(1); // Deref assumes the referent is initialized, so always drops
*y = Box::new(1); //  Derefは参照対象が初期化されていると仮定しているため、常にドロップされます
```

<!--This is only a problem when overwriting a previously initialized variable or one of its subfields.-->
これは、以前に初期化された変数またはそのサブフィールドの1つを上書きする場合にのみ問題になります。

<!--It turns out that Rust actually tracks whether a type should be dropped or not *at runtime*.-->
Rustは実際にタイプを削除するかどうか*を実行時*に追跡*します*。
<!--As a variable becomes initialized and uninitialized, a *drop flag* for that variable is toggled.-->
変数が初期化され、初期化されなくなると、その変数の*ドロップフラグ*がトグルされます。
<!--When a variable might need to be dropped, this flag is evaluated to determine if it should be dropped.-->
変数を削除する必要がある場合、このフラグを評価して、削除する必要があるかどうかを判断します。

<!--Of course, it is often the case that a value's initialization state can be statically known at every point in the program.-->
もちろん、値の初期化状態をプログラムのすべての点で静的に知ることができるケースがよくあります。
<!--If this is the case, then the compiler can theoretically generate more efficient code!-->
この場合、コンパイラは理論的にはより効率的なコードを生成できます。
<!--For instance, straight-line code has such *static drop semantics*:-->
例えば、直線コードは*静的なドロップセマンティクスを*持ってい*ます*：

```rust
#//let mut x = Box::new(0); // x was uninit; just overwrite.
let mut x = Box::new(0); //  xは無事だった。ただ上書きする。
#//let mut y = x;           // y was uninit; just overwrite and make x uninit.
let mut y = x;           //  yは無事だった。上書きしてxをuninitにするだけです。
#//x = Box::new(0);         // x was uninit; just overwrite.
x = Box::new(0);         //  xは無事だった。ただ上書きする。
#//y = x;                   // y was init; Drop y, overwrite it, and make x uninit!
#                         // y goes out of scope; y was init; Drop y!
#                         // x goes out of scope; x was uninit; do nothing.
y = x;                   //  yはinitです。それを上書きし、xをuninitにする！ yは範囲外になります。yはinitです。Drop y！ xは範囲外になります。xは無事だった。何もしない。
```

<!--Similarly, branched code where all branches have the same behavior with respect to initialization has static drop semantics:-->
同様に、すべてのブランチが初期化に関して同じ挙動を有する分岐コードは、静的なドロップセマンティクスを有する：

```rust
# let condition = true;
#//let mut x = Box::new(0);    // x was uninit; just overwrite.
let mut x = Box::new(0);    //  xは無事だった。ただ上書きする。
if condition {
#//    drop(x)                 // x gets moved out; make x uninit.
    drop(x)                 //  xは移動します。xをuninitにする。
} else {
    println!("{}", x);
#//    drop(x)                 // x gets moved out; make x uninit.
    drop(x)                 //  xは移動します。xをuninitにする。
}
#//x = Box::new(0);            // x was uninit; just overwrite.
#                            // x goes out of scope; x was init; Drop x!
x = Box::new(0);            //  xは無事だった。ただ上書きする。xは範囲外になります。xはinitでした。ドロップx！
```

<!--However code like this *requires* runtime information to correctly Drop:-->
しかし、このようなコードで*は、*ランタイム情報が正しく削除される*必要があり*ます。

```rust
# let condition = true;
let x;
if condition {
#//    x = Box::new(0);        // x was uninit; just overwrite.
    x = Box::new(0);        //  xは無事だった。ただ上書きする。
    println!("{}", x);
}
#                            // x goes out of scope; x might be uninit;
#                            // check the flag!
                            //  xは範囲外になります。xはuninitかもしれません。フラグをチェック！
```

<!--Of course, in this case it's trivial to retrieve static drop semantics:-->
もちろん、この場合、静的なドロップセマンティクスを取得するのは簡単です。

```rust
# let condition = true;
if condition {
    let x = Box::new(0);
    println!("{}", x);
}
```

<!--The drop flags are tracked on the stack and no longer stashed in types that implement drop.-->
ドロップフラグはスタック上で追跡され、ドロップを実装する型ではもはや隠されません。
