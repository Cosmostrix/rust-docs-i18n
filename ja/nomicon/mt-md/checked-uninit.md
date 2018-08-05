# <!--Checked Uninitialized Memory--> チェックされている初期化されていないメモリ

<!--Like C, all stack variables in Rust are uninitialized until a value is explicitly assigned to them.-->
Cのように、Rustのすべてのスタック変数は、明示的に値が割り当てられるまで初期化されません。
<!--Unlike C, Rust statically prevents you from ever reading them until you do:-->
Cとは異なり、Rustはあなたが次のことをするまで静かに読むことができません：

```rust,ignore
fn main() {
    let x: i32;
    println!("{}", x);
}
```

```text
src/main.rs:3:20: 3:21 error: use of possibly uninitialized variable: `x`
src/main.rs:3     println!("{}", x);
                                 ^
```

<!--This is based off of a basic branch analysis: every branch must assign a value to `x` before it is first used.-->
これは、基本的な分岐分析に基づいています。すべての分岐は、最初に使用される前に`x`に値を割り当てる必要があります。
<!--Interestingly, Rust doesn't require the variable to be mutable to perform a delayed initialization if every branch assigns exactly once.-->
興味深いことに、Rustでは、すべてのブランチが正確に1回割り当てられると、遅延初期設定を実行するために変数を変更する必要はありません。
<!--However the analysis does not take advantage of constant analysis or anything like that.-->
しかし、分析は、一定の分析などを利用していません。
<!--So this compiles:-->
これはコンパイルされます：

```rust
fn main() {
    let x: i32;

    if true {
        x = 1;
    } else {
        x = 2;
    }

    println!("{}", x);
}
```

<!--but this doesn't:-->
しかしこれはしません：

```rust,ignore
fn main() {
    let x: i32;
    if true {
        x = 1;
    }
    println!("{}", x);
}
```

```text
src/main.rs:6:17: 6:18 error: use of possibly uninitialized variable: `x`
src/main.rs:6   println!("{}", x);
```

<!--while this does:-->
これは、

```rust
fn main() {
    let x: i32;
    if true {
        x = 1;
        println!("{}", x);
    }
#    // Don't care that there are branches where it's not initialized
#    // since we don't use the value in those branches
    // それらのブランチで値を使用しないため、初期化されていないブランチがあることに気にしないでください
}
```

<!--Of course, while the analysis doesn't consider actual values, it does have a relatively sophisticated understanding of dependencies and control flow.-->
もちろん、分析では実際の値は考慮されませんが、依存関係や制御フローについて比較的洗練された理解があります。
<!--For instance, this works:-->
たとえば、次のように動作します。

```rust
let x: i32;

loop {
#    // Rust doesn't understand that this branch will be taken unconditionally,
#    // because it relies on actual values.
    //  Rustは、実際の値に依存しているため、このブランチは無条件に取得されることを理解していません。
    if true {
#        // But it does understand that it will only be taken once because
#        // we unconditionally break out of it. Therefore `x` doesn't
#        // need to be marked as mutable.
        // しかし、私たちが無条件にそれから脱出するので、それは一度しか取られないことを理解しています。したがって、`x`は変更可能とマークする必要はありません。
        x = 0;
        break;
    }
}
#// It also knows that it's impossible to get here without reaching the break.
#// And therefore that `x` must be initialized here!
// それはまた、休憩に達することなくここに来ることは不可能であることも知っています。したがって、`x`はここで初期化されなければなりません！
println!("{}", x);
```

<!--If a value is moved out of a variable, that variable becomes logically uninitialized if the type of the value isn't Copy.-->
値が変数から移動された場合、値の型がコピーでない場合、その変数は論理的に初期化されません。
<!--That is:-->
あれは：

```rust
fn main() {
    let x = 0;
    let y = Box::new(0);
#//    let z1 = x; // x is still valid because i32 is Copy
    let z1 = x; //  i32はコピーであるため、xはまだ有効です。
#//    let z2 = y; // y is now logically uninitialized because Box isn't Copy
    let z2 = y; //  Boxはコピーではないため、yは論理的に初期化されていません
}
```

<!--However reassigning `y` in this example *would* require `y` to be marked as mutable, as a Safe Rust program could observe that the value of `y` changed:-->
しかし、再割り当て`y`必要*と*する*でしょう*。この例では`y`安全な錆プログラムがの価値ことを観察できたとして、のように変更可能とマークされる`y`変更されました：

```rust
fn main() {
    let mut y = Box::new(0);
#//    let z = y; // y is now logically uninitialized because Box isn't Copy
    let z = y; //  Boxはコピーではないため、yは論理的に初期化されていません
#//    y = Box::new(1); // reinitialize y
    y = Box::new(1); //  yを再初期化する
}
```

<!--Otherwise it's like `y` is a brand new variable.-->
そうでなければ、`y`はまったく新しい変数です。
