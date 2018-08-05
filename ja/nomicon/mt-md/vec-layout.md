# <!--Layout--> レイアウト

<!--First off, we need to come up with the struct layout.-->
まず、構造体レイアウトを考え出す必要があります。
<!--A Vec has three parts: a pointer to the allocation, the size of the allocation, and the number of elements that have been initialized.-->
Vecには、割り当てのポインタ、割り当てのサイズ、および初期化された要素の数の3つの部分があります。

<!--Naively, this means we just want this design:-->
純粋に、これは単にこのデザインが必要なことを意味します：

```rust
pub struct Vec<T> {
    ptr: *mut T,
    cap: usize,
    len: usize,
}
# fn main() {}
```

<!--And indeed this would compile.-->
そして確かにこれはコンパイルされます。
<!--Unfortunately, it would be incorrect.-->
残念ながら、それは間違っています。
<!--First, the compiler will give us too strict variance.-->
まず、コンパイラはあまりにも厳密な分散を与えます。
<!--So a `&Vec<&'static str>` couldn't be used where an `&Vec<&'a str>` was expected.-->
だから、`&Vec<&'static str>`どこに使用することができませんでした`&Vec<&'a str>`期待されていました。
<!--More importantly, it will give incorrect ownership information to the drop checker, as it will conservatively assume we don't own any values of type `T`.-->
さらに重要なことは、`T`型の値を保有していないと控えめに仮定するので、誤った所有権情報をドロップチェッカーに与えることになります。
<!--See [the chapter on ownership and lifetimes][ownership] for all the details on variance and drop check.-->
分散とドロップチェックの詳細については[、所有権と存続期間に関する章を][ownership]参照し[て][ownership]ください。

<!--As we saw in the ownership chapter, we should use `Unique<T>` in place of `*mut T` when we have a raw pointer to an allocation we own.-->
所有権の章で見てきたように、私たちが所有している割り当てに対する生のポインタを持っているときは、`*mut T`代わりに`Unique<T>`使うべきです。
<!--Unique is unstable, so we'd like to not use it if possible, though.-->
ユニークなものは不安定なので、できるだけ使用しないことをおすすめします。

<!--As a recap, Unique is a wrapper around a raw pointer that declares that:-->
要約すると、Uniqueは以下のことを宣言する生ポインタのラッパーです：

* <!--We are variant over `T`-->
   我々は`T`
* <!--We may own a value of type `T` (for drop check)-->
   タイプ`T`値を所有している可能性があります（ドロップチェック用）
* <!--We are Send/Sync if `T` is Send/Sync-->
   `T`がSend / Syncの場合はSend / Syncです
* <!--Our pointer is never null (so `Option<Vec<T>>` is null-pointer-optimized)-->
   私たちのポインタは決してヌルではありません（`Option<Vec<T>>`はヌルポインタに最適化されています）

<!--We can implement all of the above requirements except for the last one in stable Rust:-->
安定したRustの最後のものを除いて、上記のすべての要件を実装することができます：

```rust
use std::marker::PhantomData;
use std::ops::Deref;
use std::mem;

struct Unique<T> {
#//    ptr: *const T,              // *const for variance
    ptr: *const T,              //  *分散のためのconst
#//    _marker: PhantomData<T>,    // For the drop checker
    _marker: PhantomData<T>,    // ドロップチェッカーの場合
}

#// Deriving Send and Sync is safe because we are the Unique owners
#// of this data. It's like Unique<T> is "just" T.
// 私たちはこのデータの一意の所有者であるため、送信と同期の派生は安全です。ユニークのようなものです "ちょうど"Tです。
unsafe impl<T: Send> Send for Unique<T> {}
unsafe impl<T: Sync> Sync for Unique<T> {}

impl<T> Unique<T> {
    pub fn new(ptr: *mut T) -> Self {
        Unique { ptr: ptr, _marker: PhantomData }
    }

    pub fn as_ptr(&self) -> *mut T {
        self.ptr as *mut T
    }
}

# fn main() {}
```

<!--Unfortunately the mechanism for stating that your value is non-zero is unstable and unlikely to be stabilized soon.-->
残念ながら、あなたの価値がゼロではないと述べる仕組みは不安定で、すぐには安定しないでしょう。
<!--As such we're just going to take the hit and use std's Unique:-->
このように、ヒットしてstdのUniqueを使用するだけです：


```rust
#![feature(ptr_internals, unique)]

use std::ptr::{Unique, self};

pub struct Vec<T> {
    ptr: Unique<T>,
    cap: usize,
    len: usize,
}

# fn main() {}
```

<!--If you don't care about the null-pointer optimization, then you can use the stable code.-->
nullポインタの最適化を気にしない場合は、安定したコードを使用できます。
<!--However we will be designing the rest of the code around enabling this optimization.-->
しかし、この最適化を可能にするために残りのコードを設計する予定です。
<!--It should be noted that `Unique::new` is unsafe to call, because putting `null` inside of it is Undefined Behavior.-->
ことに留意すべきである`Unique::new`入れているため、呼び出すことが安全ではない`null`その中には未定義の動作です。
<!--Our stable Unique doesn't need `new` to be unsafe because it doesn't make any interesting guarantees about its contents.-->
私たちの安定したユニークは、内容に関して面白い保証をしていないため、`new`ものは安全でない必要はありません。

[ownership]: ownership.html
