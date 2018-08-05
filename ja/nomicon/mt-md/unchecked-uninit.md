# <!--Unchecked Uninitialized Memory--> チェックされていない初期化されていないメモリ

<!--One interesting exception to this rule is working with arrays.-->
このルールの1つの興味深い例外は、配列の操作です。
<!--Safe Rust doesn't permit you to partially initialize an array.-->
Safe Rustでは、配列を部分的に初期化することはできません。
<!--When you initialize an array, you can either set every value to the same thing with `let x = [val; N]`-->
配列を初期化するときは、`let x = [val; N]`
<!--`let x = [val; N]`, or you can specify each member individually with `let x = [val1, val2, val3]`.-->
`let x = [val; N]`、または`let x = [val1, val2, val3]`個々に各メンバーを指定することができます。
<!--Unfortunately this is pretty rigid, especially if you need to initialize your array in a more incremental or dynamic way.-->
残念ながら、これは非常に堅牢です。特に、配列をより漸進的または動的な方法で初期化する必要がある場合は、

<!--Unsafe Rust gives us a powerful tool to handle this problem: `mem::uninitialized`.-->
Unsafe Rustはこの問題を処理するための強力なツールを提供します： `mem::uninitialized`。
<!--This function pretends to return a value when really it does nothing at all.-->
この関数は実際に何もしないときに値を返すふりをします。
<!--Using it, we can convince Rust that we have initialized a variable, allowing us to do trickier things with conditional and incremental initialization.-->
それを使って、変数を初期化したことをRustに説得させることができ、条件付き初期化とインクリメンタル初期化を使ってより厄介なことを行うことができます。

<!--Unfortunately, this opens us up to all kinds of problems.-->
残念ながら、これは私たちにあらゆる種類の問題を引き起こします。
<!--Assignment has a different meaning to Rust based on whether it believes that a variable is initialized or not.-->
代入は、変数が初期化されているかどうかに基づいて、Rustとは異なる意味を持ちます。
<!--If it's believed uninitialized, then Rust will semantically just memcopy the bits over the uninitialized ones, and do nothing else.-->
初期化されていないと信じられている場合、Rustは意味論的に、ビットを初期化されていないものにmemcopyし、他に何もしません。
<!--However if Rust believes a value to be initialized, it will try to `Drop` the old value!-->
錆が初期化される値を信じている場合しかし、それはしようとします`Drop`古い値を！
<!--Since we've tricked Rust into believing that the value is initialized, we can no longer safely use normal assignment.-->
値が初期化されたと信じるようにRustを騙したので、もはや安全に通常の割り当てを使用することはできません。

<!--This is also a problem if you're working with a raw system allocator, which returns a pointer to uninitialized memory.-->
これは、初期化されていないメモリへのポインタを返すローシステムアロケータを使用している場合にも問題になります。

<!--To handle this, we must use the `ptr` module.-->
これを処理するには、`ptr`モジュールを使用する必要があります。
<!--In particular, it provides three functions that allow us to assign bytes to a location in memory without dropping the old value: `write`, `copy`, and `copy_nonoverlapping`.-->
特に、この関数は3つの関数を提供しています。これにより、古い値を削除せずに、`write`、 `copy`、および`copy_nonoverlapping`というメモリ内の場所にバイトを割り当てることができます。

* <!--`ptr::write(ptr, val)` takes a `val` and moves it into the address pointed to by `ptr`.-->
   `ptr::write(ptr, val)`は`val`をとり、それを`ptr`指すアドレスに移動します。
* <!--`ptr::copy(src, dest, count)` copies the bits that `count` T's would occupy from src to dest.-->
   `ptr::copy(src, dest, count)`ビットのコピー`count` Tさんは、SRCからDESTに占めます。
<!--(this is equivalent to memmove --note that the argument order is reversed!)-->
   （これはmemmoveと同じです -引数の順序が逆になっていることに注意してください）。
* <!--`ptr::copy_nonoverlapping(src, dest, count)` does what `copy` does, but a little faster on the assumption that the two ranges of memory don't overlap.-->
   `ptr::copy_nonoverlapping(src, dest, count)`は`copy`の動作を行いますが、メモリの2つの範囲が重複しないという前提で少し速くなります。
<!--(this is equivalent to memcpy --note that the argument order is reversed!)-->
   （これはmemcpyに相当します -引数の順序が逆になっていることに注意してください）。

<!--It should go without saying that these functions, if misused, will cause serious havoc or just straight up Undefined Behavior.-->
これらの機能が悪用されると、深刻な混乱を引き起こすか、まったくまっすぐな未定義の行動を引き起こすことは言うまでもない。
<!--The only things that these functions *themselves* require is that the locations you want to read and write are allocated.-->
これらの関数*自体が*必要とするのは、読み書きする場所が割り当てられることだけです。
<!--However the ways writing arbitrary bits to arbitrary locations of memory can break things are basically uncountable!-->
しかし、任意のビットをメモリの任意の場所に書き込む方法は、基本的には不可能です。

<!--Putting this all together, we get the following:-->
これをすべてまとめると、次のようになります。

```rust
use std::mem;
use std::ptr;

#// size of the array is hard-coded but easy to change. This means we can't
#// use [a, b, c] syntax to initialize the array, though!
// アレイのサイズはハードコードされていますが、変更が容易です。これは、配列を初期化する[a, b, c]構文を使うことはできないということです。
const SIZE: usize = 10;

let mut x: [Box<u32>; SIZE];

unsafe {
#//	// convince Rust that x is Totally Initialized
	//  xが完全に初期化されたとRustに説得する
	x = mem::uninitialized();
	for i in 0..SIZE {
#//		// very carefully overwrite each index without reading it
		// 各索引を読まずに非常に注意深く上書きする
#//		// NOTE: exception safety is not a concern; Box can't panic
		// 注：例外の安全性は問題ではありません。ボックスはパニックにならない
		ptr::write(&mut x[i], Box::new(i as u32));
	}
}

println!("{:?}", x);
```

<!--It's worth noting that you don't need to worry about `ptr::write` -style shenanigans with types which don't implement `Drop` or contain `Drop` types, because Rust knows not to try to drop them.-->
それはあなたが心配する必要がないことは注目に値します`ptr::write`実装していない種類のスタイルのペテンを`Drop`か、含まれている`Drop`錆がそれらをドロップしようとしないことを知っているので、種類を。
<!--Similarly you should be able to assign to fields of partially initialized structs directly if those fields don't contain any `Drop` types.-->
同様に、部分的に初期化された構造体のフィールドに、`Drop`型が含まれていない場合は直接割り当てることができます。

<!--However when working with uninitialized memory you need to be ever-vigilant for Rust trying to drop values you make like this before they're fully initialized.-->
しかし、初期化されていないメモリを扱うときは、完全に初期化される前に、このようにして値を落とそうとするRustに常に注意する必要があります。
<!--Every control path through that variable's scope must initialize the value before it ends, if it has a destructor.-->
その変数のスコープ内のすべての制御パスは、デストラクタがある場合は、終了する前に値を初期化する必要があります。
<!--*[This includes code panicking](unwinding.html)*.-->
*[これはコードパニックを含む]（unwinding.html）*。

<!--And that's about it for working with uninitialized memory!-->
それは初期化されていないメモリを扱うためのものです！
<!--Basically nothing anywhere expects to be handed uninitialized memory, so if you're going to pass it around at all, be sure to be *really* careful.-->
基本的にどこでも初期化されていないメモリが渡されることを期待しているわけではないので、まったく渡すつもりならば、*本当に*注意してください。
