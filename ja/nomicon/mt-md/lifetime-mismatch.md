# <!--Limits of Lifetimes--> 生涯の限界

<!--Given the following code:-->
次のコードを与えます：

```rust,ignore
struct Foo;

impl Foo {
    fn mutate_and_share(&mut self) -> &Self { &*self }
    fn share(&self) {}
}

fn main() {
    let mut foo = Foo;
    let loan = foo.mutate_and_share();
    foo.share();
}
```

<!--One might expect it to compile.-->
コンパイルが期待されるかもしれません。
<!--We call `mutate_and_share`, which mutably borrows `foo` temporarily, but then returns only a shared reference.-->
私たちは`mutate_and_share`を呼び出します`mutate_and_share`、 `foo`一時的に借用しますが、共有参照のみを返します。
<!--Therefore we would expect `foo.share()` to succeed as `foo` shouldn't be mutably borrowed.-->
したがって、`foo`が変更されるべきではないので、`foo.share()`が成功することが期待されます。

<!--However when we try to compile it:-->
しかし、コンパイルしようとすると：

```text
<anon>:11:5: 11:8 error: cannot borrow `foo` as immutable because it is also borrowed as mutable
<anon>:11     foo.share();
              ^~~
<anon>:10:16: 10:19 note: previous borrow of `foo` occurs here; the mutable borrow prevents subsequent moves, borrows, or modification of `foo` until the borrow ends
<anon>:10     let loan = foo.mutate_and_share();
                         ^~~
<anon>:12:2: 12:2 note: previous borrow ends here
<anon>:8 fn main() {
<anon>:9     let mut foo = Foo;
<anon>:10     let loan = foo.mutate_and_share();
<anon>:11     foo.share();
<anon>:12 }
          ^
```

<!--What happened?-->
何が起こった？
<!--Well, we got the exact same reasoning as we did for [Example 2 in the previous section][ex2].-->
まあ、[前のセクションの例2の][ex2]場合とまったく同じ理由があります。
<!--We desugar the program and we get the following:-->
私たちはプログラムをdesugarと我々は以下を取得：

```rust,ignore
struct Foo;

impl Foo {
    fn mutate_and_share<'a>(&'a mut self) -> &'a Self { &'a *self }
    fn share<'a>(&'a self) {}
}

fn main() {
	'b: {
    	let mut foo: Foo = Foo;
    	'c: {
    		let loan: &'c Foo = Foo::mutate_and_share::<'c>(&'c mut foo);
    		'd: {
    			Foo::share::<'d>(&'d foo);
    		}
    	}
    }
}
```

<!--The lifetime system is forced to extend the `&mut foo` to have lifetime `'c`, due to the lifetime of `loan` and mutate_and_share's signature.-->
生涯システムを拡張することを強制される`&mut foo`一生持って`'c`の寿命のために、`loan`およびmutate_and_shareの署名を。
<!--Then when we try to call `share`, and it sees we're trying to alias that `&'c mut foo` and blows up in our face!-->
その後、我々は呼び出すしようとすると`share`、そしてそれは我々がそのエイリアスにしようとしている見ている`&'c mut foo`、私たちの顔に吹きます！

<!--This program is clearly correct according to the reference semantics we actually care about, but the lifetime system is too coarse-grained to handle that.-->
このプログラムは、私たちが実際に気にしている参照セマンティクスに従ってはっきりと正しいですが、生涯システムはそれを処理するには粗すぎます。


<!--TODO: other common problems?-->
TODO：その他の一般的な問題？
<!--SEME regions stuff, mostly?-->
主にSEMEの領域のもの、？




[ex2]: lifetimes.html#example-aliasing-a-mutable-reference
