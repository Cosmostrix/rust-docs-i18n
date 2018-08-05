# <!--Insert and Remove--> 挿入と削除

<!--Something *not* provided by slice is `insert` and `remove`, so let's do those next.-->
スライスで提供されて*いない*ものは、`insert`と`remove`です。

<!--Insert needs to shift all the elements at the target index to the right by one.-->
Insertは、ターゲットインデックスのすべての要素を1つ右にシフトする必要があります。
<!--To do this we need to use `ptr::copy`, which is our version of C's `memmove`.-->
これを行うには、Cの`memmove`バージョンである`ptr::copy`を使用する必要があります。
<!--This copies some chunk of memory from one location to another, correctly handling the case where the source and destination overlap (which will definitely happen here).-->
これは、ある場所から別の場所にメモリの一部をコピーし、ソースと宛先が重複している場合を正しく処理します（ここでは間違いなく起こります）。

<!--If we insert at index `i`, we want to shift the `[i .. len]` to `[i+1 .. len+1]` using the old len.-->
インデックス`i`に挿入すると、古いlenを使用して`[i .. len]`を`[i+1 .. len+1]`します。

```rust,ignore
pub fn insert(&mut self, index: usize, elem: T) {
#    // Note: `<=` because it's valid to insert after everything
#    // which would be equivalent to push.
    // 注： `<=`はプッシュと同等のものの後に挿入するのが有効なためです。
    assert!(index <= self.len, "index out of bounds");
    if self.cap == self.len { self.grow(); }

    unsafe {
        if index < self.len {
#            // ptr::copy(src, dest, len): "copy from source to dest len elems"
            //  ptr:: copy（src、dest、len）： "ソースからdest len elemsへのコピー"
            ptr::copy(self.ptr.offset(index as isize),
                      self.ptr.offset(index as isize + 1),
                      self.len - index);
        }
        ptr::write(self.ptr.offset(index as isize), elem);
        self.len += 1;
    }
}
```

<!--Remove behaves in the opposite manner.-->
除去は逆の振る舞いをします。
<!--We need to shift all the elements from `[i+1 .. len + 1]` to `[i .. len]` using the *new* len.-->
*新しい* lenを使用して、すべての要素を`[i+1 .. len + 1]`から`[i .. len]`にシフトする必要があり`[i+1 .. len + 1]`。

```rust,ignore
pub fn remove(&mut self, index: usize) -> T {
#    // Note: `<` because it's *not* valid to remove after everything
    // 注： `<`すべてを削除して*も*有効で*はない*ため
    assert!(index < self.len, "index out of bounds");
    unsafe {
        self.len -= 1;
        let result = ptr::read(self.ptr.offset(index as isize));
        ptr::copy(self.ptr.offset(index as isize + 1),
                  self.ptr.offset(index as isize),
                  self.len - index);
        result
    }
}
```
