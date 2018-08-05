# <!--Deref--> デレフ

<!--Alright!-->
よかった！
<!--We've got a decent minimal stack implemented.-->
まともな最小スタックが実装されています。
<!--We can push, we can pop, and we can clean up after ourselves.-->
私達は押すことができる、私達はポップできる、そして私達は自分自身の後できれいにすることができる。
<!--However there's a whole mess of functionality we'd reasonably want.-->
しかし、私たちは合理的に欲しいと思っている機能が全面的に混乱しています。
<!--In particular, we have a proper array, but none of the slice functionality.-->
特に、適切な配列はありますが、スライス機能はありません。
<!--That's actually pretty easy to solve: we can implement `Deref<Target=[T]>`.-->
実際には解決するのはかなり簡単です： `Deref<Target=[T]>`実装することができます。
<!--This will magically make our Vec coerce to, and behave like, a slice in all sorts of conditions.-->
これは、魔法のように私たちのVecをあらゆる種類の条件にスライスし、スライスしたようにします。

<!--All we need is `slice::from_raw_parts`.-->
必要なのは、`slice::from_raw_parts`です。
<!--It will correctly handle empty slices for us.-->
空のスライスを正しく処理します。
<!--Later once we set up zero-sized type support it will also Just Work for those too.-->
後でゼロサイズのサポートを設定すると、それだけでも機能します。

```rust,ignore
use std::ops::Deref;

impl<T> Deref for Vec<T> {
    type Target = [T];
    fn deref(&self) -> &[T] {
        unsafe {
            ::std::slice::from_raw_parts(self.ptr.as_ptr(), self.len)
        }
    }
}
```

<!--And let's do DerefMut too:-->
そしてDerefMutもやりましょう：

```rust,ignore
use std::ops::DerefMut;

impl<T> DerefMut for Vec<T> {
    fn deref_mut(&mut self) -> &mut [T] {
        unsafe {
            ::std::slice::from_raw_parts_mut(self.ptr.as_ptr(), self.len)
        }
    }
}
```

<!--Now we have `len`, `first`, `last`, indexing, slicing, sorting, `iter`, `iter_mut`, and all other sorts of bells and whistles provided by slice.-->
今、我々は、スライスによって提供される鐘と笛の他のすべての種類の`len`、 `first`、 `last`、索引付け、スライス、ソート、 `iter`、 `iter_mut`、および他のすべての種類を持っています。
<!--Sweet!-->
甘い！
