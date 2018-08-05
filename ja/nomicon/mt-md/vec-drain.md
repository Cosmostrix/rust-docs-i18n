# <!--Drain--> ドレイン

<!--Let's move on to Drain.-->
ドレインに移動しましょう。
<!--Drain is largely the same as IntoIter, except that instead of consuming the Vec, it borrows the Vec and leaves its allocation untouched.-->
ドレインは、Vecを消費するのではなく、Vecを借りてその割り当てを変更しないという点を除いて、IntoIterとほぼ同じです。
<!--For now we'll only implement the "basic"full-range version.-->
今のところ、"基本的な"フルレンジバージョンだけを実装します。

```rust,ignore
use std::marker::PhantomData;

struct Drain<'a, T: 'a> {
#    // Need to bound the lifetime here, so we do it with `&'a mut Vec<T>`
#    // because that's semantically what we contain. We're "just" calling
#    // `pop()` and `remove(0)`.
    // 生涯をここに`&'a mut Vec<T>`必要があるので、それは意味的に私たちが含んでいるので、`&'a mut Vec<T>`行います。私たちは`pop()`と`remove(0)`呼び出すだけです。
    vec: PhantomData<&'a mut Vec<T>>,
    start: *const T,
    end: *const T,
}

impl<'a, T> Iterator for Drain<'a, T> {
    type Item = T;
    fn next(&mut self) -> Option<T> {
        if self.start == self.end {
            None
```

<!----wait, this is seeming familiar.-->
-待って、これはおなじみのようです。
<!--Let's do some more compression.-->
もう少し圧縮してみましょう。
<!--Both IntoIter and Drain have the exact same structure, let's just factor it out.-->
IntoIterとDrainは全く同じ構造をしています。

```rust
struct RawValIter<T> {
    start: *const T,
    end: *const T,
}

impl<T> RawValIter<T> {
#    // unsafe to construct because it has no associated lifetimes.
#    // This is necessary to store a RawValIter in the same struct as
#    // its actual allocation. OK since it's a private implementation
#    // detail.
    // 関連する生存期間がないため構築が安全ではありません。これはRawValIterを実際の割り当てと同じ構造体に格納するために必要です。それは私的な実装の詳細なのでOKです。
    unsafe fn new(slice: &[T]) -> Self {
        RawValIter {
            start: slice.as_ptr(),
            end: if slice.len() == 0 {
#                // if `len = 0`, then this is not actually allocated memory.
#                // Need to avoid offsetting because that will give wrong
#                // information to LLVM via GEP.
                //  `len = 0`場合、これは実際に割り当てられたメモリではありません。GEPを介してLLVMに間違った情報を与えるため、オフセットを避ける必要があります。
                slice.as_ptr()
            } else {
                slice.as_ptr().offset(slice.len() as isize)
            }
        }
    }
}

#// Iterator and DoubleEndedIterator impls identical to IntoIter.
//  IteratorとDoubleEndedIteratorはIntoIterと同じです。
```

<!--And IntoIter becomes the following:-->
IntoIterは次のようになります。

```rust,ignore
pub struct IntoIter<T> {
#//    _buf: RawVec<T>, // we don't actually care about this. Just need it to live.
    _buf: RawVec<T>, // 私たちは実際にこれに気をつけません。ただそれが生きるために必要です。
    iter: RawValIter<T>,
}

impl<T> Iterator for IntoIter<T> {
    type Item = T;
    fn next(&mut self) -> Option<T> { self.iter.next() }
    fn size_hint(&self) -> (usize, Option<usize>) { self.iter.size_hint() }
}

impl<T> DoubleEndedIterator for IntoIter<T> {
    fn next_back(&mut self) -> Option<T> { self.iter.next_back() }
}

impl<T> Drop for IntoIter<T> {
    fn drop(&mut self) {
        for _ in &mut self.iter {}
    }
}

impl<T> Vec<T> {
    pub fn into_iter(self) -> IntoIter<T> {
        unsafe {
            let iter = RawValIter::new(&self);

            let buf = ptr::read(&self.buf);
            mem::forget(self);

            IntoIter {
                iter: iter,
                _buf: buf,
            }
        }
    }
}
```

<!--Note that I've left a few quirks in this design to make upgrading Drain to work with arbitrary subranges a bit easier.-->
この設計では、ドレインをアップグレードして、任意の部分範囲を少し簡単に扱えるようにするため、いくつかの欠点を残しました。
<!--In particular we *could* have RawValIter drain itself on drop, but that won't work right for a more complex Drain.-->
特にRawValIterのドレイン自体をドロップする*こと*は*でき*ますが、それはもっと複雑なドレインの場合は正しく機能しません。
<!--We also take a slice to simplify Drain initialization.-->
ドレインの初期化を簡素化するためにスライスも使用します。

<!--Alright, now Drain is really easy:-->
さて、今すぐ排水は簡単です：

```rust,ignore
use std::marker::PhantomData;

pub struct Drain<'a, T: 'a> {
    vec: PhantomData<&'a mut Vec<T>>,
    iter: RawValIter<T>,
}

impl<'a, T> Iterator for Drain<'a, T> {
    type Item = T;
    fn next(&mut self) -> Option<T> { self.iter.next() }
    fn size_hint(&self) -> (usize, Option<usize>) { self.iter.size_hint() }
}

impl<'a, T> DoubleEndedIterator for Drain<'a, T> {
    fn next_back(&mut self) -> Option<T> { self.iter.next_back() }
}

impl<'a, T> Drop for Drain<'a, T> {
    fn drop(&mut self) {
        for _ in &mut self.iter {}
    }
}

impl<T> Vec<T> {
    pub fn drain(&mut self) -> Drain<T> {
        unsafe {
            let iter = RawValIter::new(&self);

#            // this is a mem::forget safety thing. If Drain is forgotten, we just
#            // leak the whole Vec's contents. Also we need to do this *eventually*
#            // anyway, so why not do it now?
            // これはmem:: safe thingを忘れる。Drainを忘れた場合、Vecの内容全体が漏れてしまいます。また、*最終的*にはこれをやる必要があるので、今はどうしたらいいですか？
            self.len = 0;

            Drain {
                iter: iter,
                vec: PhantomData,
            }
        }
    }
}
```

<!--For more details on the `mem::forget` problem, see the [section on leaks][leaks].-->
`mem::forget`問題の詳細については[、リーク][leaks]の[セクションを][leaks]参照してください。

[leaks]: leaking.html
