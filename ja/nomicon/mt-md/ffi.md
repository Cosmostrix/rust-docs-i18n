# <!--Foreign Function Interface--> 外部関数インタフェース

# <!--Introduction--> 前書き

<!--This guide will use the [snappy](https://github.com/google/snappy) compression/decompression library as an introduction to writing bindings for foreign code.-->
このガイドでは、外部コード用のバインディングを作成するための紹介として、[snappy](https://github.com/google/snappy)圧縮/解凍ライブラリを使用します。
<!--Rust is currently unable to call directly into a C++ library, but snappy includes a C interface (documented in [`snappy-ch`](https://github.com/google/snappy/blob/master/snappy-c.h)).-->
Rustは現在のところC ++ライブラリに直接呼び出すことはできませんが、スナッピーにはCインターフェイス（[`snappy-ch`](https://github.com/google/snappy/blob/master/snappy-c.h)記載されています）が含まれています。

## <!--A note about libc--> libcについての注意

<!--Many of these examples use [the `libc` crate][libc], which provides various type definitions for C types, among other things.-->
これらの例の多くは[、`libc` crateを][libc]使用し[て][libc]います[`libc` crateは][libc]、Cタイプなどのさまざまな型定義を提供します。
<!--If you're trying these examples yourself, you'll need to add `libc` to your `Cargo.toml`:-->
これらの例を自分で試しているのであれば、`Cargo.toml` `libc`を追加する必要があります：

```toml
[dependencies]
libc = "0.2.0"
```

[libc]: https://crates.io/crates/libc

<!--and add `extern crate libc;`-->
`extern crate libc;`を追加し`extern crate libc;`
<!--to your crate root.-->
あなたのクレートの根に。

## <!--Calling foreign functions--> 外国の関数を呼び出す

<!--The following is a minimal example of calling a foreign function which will compile if snappy is installed:-->
以下は、snappyがインストールされている場合にコンパイルする外部関数を呼び出す最小限の例です。

```rust,ignore
extern crate libc;
use libc::size_t;

#[link(name = "snappy")]
extern {
    fn snappy_max_compressed_length(source_length: size_t) -> size_t;
}

fn main() {
    let x = unsafe { snappy_max_compressed_length(100) };
    println!("max compressed length of a 100 byte buffer: {}", x);
}
```

<!--The `extern` block is a list of function signatures in a foreign library, in this case with the platform's C ABI.-->
`extern`ブロックは、外部ライブラリの関数シグネチャのリストです（この場合、プラットフォームのC ABIが使用されます）。
<!--The `#[link(...)]` attribute is used to instruct the linker to link against the snappy library so the symbols are resolved.-->
`#[link(...)]`属性は、シンボルが解決されるようにスナッピーライブラリとリンクするようリンカーに指示するために使用されます。

<!--Foreign functions are assumed to be unsafe so calls to them need to be wrapped with `unsafe {}` as a promise to the compiler that everything contained within truly is safe.-->
外部関数は安全ではないと想定されているため、コンパイラに対する約束として`unsafe {}`で`unsafe {}`で`unsafe {}`必要があります。
<!--C libraries often expose interfaces that aren't thread-safe, and almost any function that takes a pointer argument isn't valid for all possible inputs since the pointer could be dangling, and raw pointers fall outside of Rust's safe memory model.-->
Cライブラリはスレッドセーフではないインターフェイスを頻繁に公開し、ポインタ引数をとるほとんどすべての関数は、ポインタがぶら下がっている可能性があり、生ポインタがRustの安全メモリモデルの外にあるため、すべての可能な入力に対して有効ではありません。

<!--When declaring the argument types to a foreign function, the Rust compiler cannot check if the declaration is correct, so specifying it correctly is part of keeping the binding correct at runtime.-->
引数型を外部関数に宣言するとき、Rustコンパイラは宣言が正しいかどうかをチェックすることはできません。したがって、正しく指定することは実行時にバインディングを正しく保持することの一部です。

<!--The `extern` block can be extended to cover the entire snappy API:-->
`extern`ブロックは、スナッピーAPI全体をカバーするように拡張することができます：

```rust,ignore
extern crate libc;
use libc::{c_int, size_t};

#[link(name = "snappy")]
extern {
    fn snappy_compress(input: *const u8,
                       input_length: size_t,
                       compressed: *mut u8,
                       compressed_length: *mut size_t) -> c_int;
    fn snappy_uncompress(compressed: *const u8,
                         compressed_length: size_t,
                         uncompressed: *mut u8,
                         uncompressed_length: *mut size_t) -> c_int;
    fn snappy_max_compressed_length(source_length: size_t) -> size_t;
    fn snappy_uncompressed_length(compressed: *const u8,
                                  compressed_length: size_t,
                                  result: *mut size_t) -> c_int;
    fn snappy_validate_compressed_buffer(compressed: *const u8,
                                         compressed_length: size_t) -> c_int;
}
# fn main() {}
```

# <!--Creating a safe interface--> 安全なインターフェースを作成する

<!--The raw C API needs to be wrapped to provide memory safety and make use of higher-level concepts like vectors.-->
生のC APIは、メモリの安全性を提供し、ベクトルのようなより高いレベルの概念を利用するためにラップする必要があります。
<!--A library can choose to expose only the safe, high-level interface and hide the unsafe internal details.-->
ライブラリは、安全で高水準のインタフェースだけを公開し、安全ではない内部の詳細を隠すことを選択できます。

<!--Wrapping the functions which expect buffers involves using the `slice::raw` module to manipulate Rust vectors as pointers to memory.-->
バッファを必要とする関数をラップするには、`slice::raw`モジュールを使ってメモリへのポインタとしてのルースベクトルを操作する必要があります。
<!--Rust's vectors are guaranteed to be a contiguous block of memory.-->
Rustのベクトルは、連続したメモリブロックであることが保証されています。
<!--The length is the number of elements currently contained, and the capacity is the total size in elements of the allocated memory.-->
長さは現在含まれている要素の数であり、容量は割り当てられたメモリの要素の合計サイズです。
<!--The length is less than or equal to the capacity.-->
長さは容量以下です。

```rust,ignore
# extern crate libc;
# use libc::{c_int, size_t};
# unsafe fn snappy_validate_compressed_buffer(_: *const u8, _: size_t) -> c_int { 0 }
# fn main() {}
pub fn validate_compressed_buffer(src: &[u8]) -> bool {
    unsafe {
        snappy_validate_compressed_buffer(src.as_ptr(), src.len() as size_t) == 0
    }
}
```

<!--The `validate_compressed_buffer` wrapper above makes use of an `unsafe` block, but it makes the guarantee that calling it is safe for all inputs by leaving off `unsafe` from the function signature.-->
上記の`validate_compressed_buffer`ラッパーは`unsafe`ブロックを使用しますが、関数シグニチャーから`unsafe`ままにすることで、すべての入力に対して安全であることを保証します。

<!--The `snappy_compress` and `snappy_uncompress` functions are more complex, since a buffer has to be allocated to hold the output too.-->
`snappy_compress`と`snappy_uncompress`バッファがあまりにも出力を保持するために割り当てられなければならないので機能は、より複雑です。

<!--The `snappy_max_compressed_length` function can be used to allocate a vector with the maximum required capacity to hold the compressed output.-->
`snappy_max_compressed_length`関数を使用すると、圧縮出力を保持するために必要な最大容量のベクトルを割り当てることができます。
<!--The vector can then be passed to the `snappy_compress` function as an output parameter.-->
その後、出力パラメータとして`snappy_compress`関数に渡すことができます。
<!--An output parameter is also passed to retrieve the true length after compression for setting the length.-->
長さを設定するために圧縮後に真の長さを取り出すために、出力パラメータも渡されます。

```rust,ignore
# extern crate libc;
# use libc::{size_t, c_int};
# unsafe fn snappy_compress(a: *const u8, b: size_t, c: *mut u8,
#                           d: *mut size_t) -> c_int { 0 }
# unsafe fn snappy_max_compressed_length(a: size_t) -> size_t { a }
# fn main() {}
pub fn compress(src: &[u8]) -> Vec<u8> {
    unsafe {
        let srclen = src.len() as size_t;
        let psrc = src.as_ptr();

        let mut dstlen = snappy_max_compressed_length(srclen);
        let mut dst = Vec::with_capacity(dstlen as usize);
        let pdst = dst.as_mut_ptr();

        snappy_compress(psrc, srclen, pdst, &mut dstlen);
        dst.set_len(dstlen as usize);
        dst
    }
}
```

<!--Decompression is similar, because snappy stores the uncompressed size as part of the compression format and `snappy_uncompressed_length` will retrieve the exact buffer size required.-->
`snappy_uncompressed_length`は圧縮されていないサイズを圧縮フォーマットの一部として格納し、`snappy_uncompressed_length`は必要な正確なバッファサイズを取得するため、圧縮`snappy_uncompressed_length`ます。

```rust,ignore
# extern crate libc;
# use libc::{size_t, c_int};
# unsafe fn snappy_uncompress(compressed: *const u8,
#                             compressed_length: size_t,
#                             uncompressed: *mut u8,
#                             uncompressed_length: *mut size_t) -> c_int { 0 }
# unsafe fn snappy_uncompressed_length(compressed: *const u8,
#                                      compressed_length: size_t,
#                                      result: *mut size_t) -> c_int { 0 }
# fn main() {}
pub fn uncompress(src: &[u8]) -> Option<Vec<u8>> {
    unsafe {
        let srclen = src.len() as size_t;
        let psrc = src.as_ptr();

        let mut dstlen: size_t = 0;
        snappy_uncompressed_length(psrc, srclen, &mut dstlen);

        let mut dst = Vec::with_capacity(dstlen as usize);
        let pdst = dst.as_mut_ptr();

        if snappy_uncompress(psrc, srclen, pdst, &mut dstlen) == 0 {
            dst.set_len(dstlen as usize);
            Some(dst)
        } else {
#//            None // SNAPPY_INVALID_INPUT
            None //  SNAPPY_INVALID_INPUT
        }
    }
}
```

<!--Then, we can add some tests to show how to use them.-->
次に、それらを使用する方法を示すいくつかのテストを追加することができます。

```rust,ignore
# extern crate libc;
# use libc::{c_int, size_t};
# unsafe fn snappy_compress(input: *const u8,
#                           input_length: size_t,
#                           compressed: *mut u8,
#                           compressed_length: *mut size_t)
#                           -> c_int { 0 }
# unsafe fn snappy_uncompress(compressed: *const u8,
#                             compressed_length: size_t,
#                             uncompressed: *mut u8,
#                             uncompressed_length: *mut size_t)
#                             -> c_int { 0 }
# unsafe fn snappy_max_compressed_length(source_length: size_t) -> size_t { 0 }
# unsafe fn snappy_uncompressed_length(compressed: *const u8,
#                                      compressed_length: size_t,
#                                      result: *mut size_t)
#                                      -> c_int { 0 }
# unsafe fn snappy_validate_compressed_buffer(compressed: *const u8,
#                                             compressed_length: size_t)
#                                             -> c_int { 0 }
# fn main() { }

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn valid() {
        let d = vec![0xde, 0xad, 0xd0, 0x0d];
        let c: &[u8] = &compress(&d);
        assert!(validate_compressed_buffer(c));
        assert!(uncompress(c) == Some(d));
    }

    #[test]
    fn invalid() {
        let d = vec![0, 0, 0, 0];
        assert!(!validate_compressed_buffer(&d));
        assert!(uncompress(&d).is_none());
    }

    #[test]
    fn empty() {
        let d = vec![];
        assert!(!validate_compressed_buffer(&d));
        assert!(uncompress(&d).is_none());
        let c = compress(&d);
        assert!(validate_compressed_buffer(&c));
        assert!(uncompress(&c) == Some(d));
    }
}
```

# <!--Destructors--> デストラクタ

<!--Foreign libraries often hand off ownership of resources to the calling code.-->
外国の図書館は、しばしば呼び出しコードにリソースの所有権を渡します。
<!--When this occurs, we must use Rust's destructors to provide safety and guarantee the release of these resources (especially in the case of panic).-->
これが発生すると、Rustのデストラクタを使用して安全性を確保し、これらのリソースの解放を保証する必要があります（特にパニックの場合）。

<!--For more about destructors, see the [Drop trait](../std/ops/trait.Drop.html).-->
デストラクタの詳細については、[Drop特性を](../std/ops/trait.Drop.html)参照してください。

# <!--Callbacks from C code to Rust functions--> CコードからRust関数へのコールバック

<!--Some external libraries require the usage of callbacks to report back their current state or intermediate data to the caller.-->
一部の外部ライブラリでは、現在の状態または中間データを呼び出し元に報告するためにコールバックを使用する必要があります。
<!--It is possible to pass functions defined in Rust to an external library.-->
Rustで定義された関数を外部ライブラリに渡すことは可能です。
<!--The requirement for this is that the callback function is marked as `extern` with the correct calling convention to make it callable from C code.-->
このために必要なのは、コールバック関数がCコードから呼び出し可能にする正しい呼び出し規約で`extern`としてマークされていることです。

<!--The callback function can then be sent through a registration call to the C library and afterwards be invoked from there.-->
コールバック関数は、Cライブラリへの登録呼び出しによって送信され、その後、そこから呼び出されます。

<!--A basic example is:-->
基本的な例は次のとおりです。

<!--Rust code:-->
錆のコード：

```rust,no_run
extern fn callback(a: i32) {
    println!("I'm called from C with value {0}", a);
}

#[link(name = "extlib")]
extern {
   fn register_callback(cb: extern fn(i32)) -> i32;
   fn trigger_callback();
}

fn main() {
    unsafe {
        register_callback(callback);
#//        trigger_callback(); // Triggers the callback.
        trigger_callback(); // コールバックをトリガーします。
    }
}
```

<!--C code:-->
Cコード：

```c
typedef void (*rust_callback)(int32_t);
rust_callback cb;

int32_t register_callback(rust_callback callback) {
    cb = callback;
    return 1;
}

void trigger_callback() {
#//  cb(7); // Will call callback(7) in Rust.
  cb(7); //  Rustのコールバック（7）を呼び出します。
}
```

<!--In this example Rust's `main()` will call `trigger_callback()` in C, which would, in turn, call back to `callback()` in Rust.-->
この例では、Rustの`main()`はCで`trigger_callback()`を呼び出し、Rustの`callback()`にコールバックし`callback()`。


## <!--Targeting callbacks to Rust objects--> Rustオブジェクトへのコールバックのターゲット設定

<!--The former example showed how a global function can be called from C code.-->
前者の例では、Cコードからグローバル関数を呼び出す方法を示しました。
<!--However it is often desired that the callback is targeted to a special Rust object.-->
しかし、しばしばコールバックが特別なRustオブジェクトを対象とすることが望まれます。
<!--This could be the object that represents the wrapper for the respective C object.-->
これは、それぞれのCオブジェクトのラッパーを表すオブジェクトである可能性があります。

<!--This can be achieved by passing a raw pointer to the object down to the C library.-->
これは、オブジェクトへの生ポインタをCライブラリに渡すことで実現できます。
<!--The C library can then include the pointer to the Rust object in the notification.-->
Cライブラリは、通知内のRustオブジェクトへのポインタを含めることができます。
<!--This will allow the callback to unsafely access the referenced Rust object.-->
これによりコールバックは参照されているRustオブジェクトに安全にアクセスできなくなります。

<!--Rust code:-->
錆のコード：

```rust,no_run
#[repr(C)]
struct RustObject {
    a: i32,
#    // Other members...
    // 他のメンバー...
}

extern "C" fn callback(target: *mut RustObject, a: i32) {
    println!("I'm called from C with value {0}", a);
    unsafe {
#        // Update the value in RustObject with the value received from the callback:
        //  RustObjectの値をコールバックから受け取った値で更新します。
        (*target).a = a;
    }
}

#[link(name = "extlib")]
extern {
   fn register_callback(target: *mut RustObject,
                        cb: extern fn(*mut RustObject, i32)) -> i32;
   fn trigger_callback();
}

fn main() {
#    // Create the object that will be referenced in the callback:
    // コールバックで参照されるオブジェクトを作成します。
    let mut rust_object = Box::new(RustObject { a: 5 });

    unsafe {
        register_callback(&mut *rust_object, callback);
        trigger_callback();
    }
}
```

<!--C code:-->
Cコード：

```c
typedef void (*rust_callback)(void*, int32_t);
void* cb_target;
rust_callback cb;

int32_t register_callback(void* callback_target, rust_callback callback) {
    cb_target = callback_target;
    cb = callback;
    return 1;
}

void trigger_callback() {
#//  cb(cb_target, 7); // Will call callback(&rustObject, 7) in Rust.
  cb(cb_target, 7); //  Rustのコールバック（＆rustObject、7）を呼び出します。
}
```

## <!--Asynchronous callbacks--> 非同期コールバック

<!--In the previously given examples the callbacks are invoked as a direct reaction to a function call to the external C library.-->
前述の例では、コールバックは外部Cライブラリへの関数呼び出しへの直接的な反応として呼び出されます。
<!--The control over the current thread is switched from Rust to C to Rust for the execution of the callback, but in the end the callback is executed on the same thread that called the function which triggered the callback.-->
現在のスレッドに対する制御は、コールバックの実行のためにRustからCへRustに切り替えられますが、コールバックは、コールバックをトリガした関数を呼び出したスレッドと同じスレッドで実行されます。

<!--Things get more complicated when the external library spawns its own threads and invokes callbacks from there.-->
外部ライブラリが独自のスレッドを生成し、そこからコールバックを呼び出すと、状況はより複雑になります。
<!--In these cases access to Rust data structures inside the callbacks is especially unsafe and proper synchronization mechanisms must be used.-->
これらの場合、コールバック内のRustデータ構造へのアクセスは特に安全ではなく、適切な同期メカニズムを使用する必要があります。
<!--Besides classical synchronization mechanisms like mutexes, one possibility in Rust is to use channels (in `std::sync::mpsc`) to forward data from the C thread that invoked the callback into a Rust thread.-->
mutexのような古典的な同期メカニズムの他に、Rustの1つの可能性は、チャネルを使って（`std::sync::mpsc`）コールバックを呼び出したCスレッドからRustスレッドにデータを転送することです。

<!--If an asynchronous callback targets a special object in the Rust address space it is also absolutely necessary that no more callbacks are performed by the C library after the respective Rust object gets destroyed.-->
非同期コールバックがRustアドレス空間の特別なオブジェクトをターゲットにしている場合は、それぞれのRustオブジェクトが破棄された後に、Cライブラリがこれ以上コールバックを実行しないことも絶対必要です。
<!--This can be achieved by unregistering the callback in the object's destructor and designing the library in a way that guarantees that no callback will be performed after deregistration.-->
これは、オブジェクトのデストラクタでコールバックの登録を解除し、登録解除後にコールバックが実行されないようにライブラリを設計することで実現できます。

# <!--Linking--> リンクする

<!--The `link` attribute on `extern` blocks provides the basic building block for instructing rustc how it will link to native libraries.-->
`extern`ブロックの`link`属性は、ネイティブライブラリへのリンク方法をrustcに指示するための基本的なビルディングブロックを提供します。
<!--There are two accepted forms of the link attribute today:-->
今日、リンク属性には2つの形式があります。

* `#[link(name = "foo")]`
* `#[link(name = "foo", kind = "bar")]`

<!--In both of these cases, `foo` is the name of the native library that we're linking to, and in the second case `bar` is the type of native library that the compiler is linking to.-->
どちらの場合も、`foo`はリンク先のネイティブライブラリの名前です.2番目の例では、`bar`は、コンパイラがリンクしているネイティブライブラリのタイプです。
<!--There are currently three known types of native libraries:-->
現在、3つのタイプのネイティブライブラリがあります。

* <!--Dynamic -`#[link(name = "readline")]`-->
   動的 -`#[link(name = "readline")]`
* <!--Static -`#[link(name = "my_build_dependency", kind = "static")]`-->
   静的 -`#[link(name = "my_build_dependency", kind = "static")]`
* <!--Frameworks -`#[link(name = "CoreFoundation", kind = "framework")]`-->
   フレームワーク -`#[link(name = "CoreFoundation", kind = "framework")]`

<!--Note that frameworks are only available on macOS targets.-->
フレームワークはmacOSターゲットでのみ利用可能であることに注意してください。

<!--The different `kind` values are meant to differentiate how the native library participates in linkage.-->
異なる`kind`値は、ネイティブライブラリがリンケージにどのように関与するかを区別するためのものです。
<!--From a linkage perspective, the Rust compiler creates two flavors of artifacts: partial (rlib/staticlib) and final (dylib/binary).-->
リンケージの観点から、Rustコンパイラは、部分（rlib / staticlib）と最終（dylib / binary）という2つのアーティファクトのフレーバを作成します。
<!--Native dynamic library and framework dependencies are propagated to the final artifact boundary, while static library dependencies are not propagated at all, because the static libraries are integrated directly into the subsequent artifact.-->
静的ライブラリは後続の成果物に直接統合されるため、ネイティブの動的ライブラリとフレームワークの依存関係は最終的な成果物の境界に伝播され、静的ライブラリの依存関係はまったく伝播されません。

<!--A few examples of how this model can be used are:-->
このモデルの使用方法の例をいくつか示します。

* <!--A native build dependency.-->
   ネイティブビルドの依存関係。
<!--Sometimes some C/C++ glue is needed when writing some Rust code, but distribution of the C/C++ code in a library format is a burden.-->
   いくつかのC / C ++グルーがいくつかの錆コードを書くときに必要になることがありますが、C / C ++コードをライブラリ形式で配布することは負担です。
<!--In this case, the code will be archived into `libfoo.a` and then the Rust crate would declare a dependency via `#[link(name = "foo", kind = "static")]`.-->
   この場合、コードは`libfoo.a`にアーカイブされ、Rustの`libfoo.a` `#[link(name = "foo", kind = "static")]`介して依存関係を宣言します。

<!--Regardless of the flavor of output for the crate, the native static library will be included in the output, meaning that distribution of the native static library is not necessary.-->
クレートの出力のフレーバにかかわらず、ネイティブのスタティックライブラリが出力に含まれます。つまり、ネイティブのスタティックライブラリの配布は不要です。

* <!--A normal dynamic dependency.-->
   通常の動的依存関係。
<!--Common system libraries (like `readline`) are available on a large number of systems, and often a static copy of these libraries cannot be found.-->
   一般的なシステムライブラリ（`readline`）は多数のシステムで利用可能で、しばしばこれらのライブラリの静的なコピーが見つかりません。
<!--When this dependency is included in a Rust crate, partial targets (like rlibs) will not link to the library, but when the rlib is included in a final target (like a binary), the native library will be linked in.-->
   この依存関係がRustクレートに含まれていると、部分ターゲット（rlibなど）はライブラリにリンクされませんが、最終ターゲット（バイナリなど）に含まれると、ネイティブライブラリがリンクされます。

<!--On macOS, frameworks behave with the same semantics as a dynamic library.-->
macOSでは、フレームワークはダイナミックライブラリと同じセマンティクスで動作します。

# <!--Unsafe blocks--> 安全でないブロック

<!--Some operations, like dereferencing raw pointers or calling functions that have been marked unsafe are only allowed inside unsafe blocks.-->
生ポインタや安全でないとマークされた関数を参照解除するような操作は、安全でないブロックの中でのみ許可されます。
<!--Unsafe blocks isolate unsafety and are a promise to the compiler that the unsafety does not leak out of the block.-->
安全でないブロックは安全でないものを分離し、安全ではないブロックから漏れないことをコンパイラーに約束します。

<!--Unsafe functions, on the other hand, advertise it to the world.-->
一方、安全でない関数は、それを世界に宣伝します。
<!--An unsafe function is written like this:-->
安全でない関数は次のように書かれています：

```rust
unsafe fn kaboom(ptr: *const i32) -> i32 { *ptr }
```

<!--This function can only be called from an `unsafe` block or another `unsafe` function.-->
この関数は、`unsafe`ブロックまたは別の`unsafe`関数からのみ呼び出すことができます。

# <!--Accessing foreign globals--> 海外のグローバルにアクセスする

<!--Foreign APIs often export a global variable which could do something like track global state.-->
外部APIは、しばしばグローバル状態を追跡するような何かをする可能性のあるグローバル変数をエクスポートします。
<!--In order to access these variables, you declare them in `extern` blocks with the `static` keyword:-->
これらの変数にアクセスするには、`static`キーワードを使用して`extern`ブロックで宣言します。

```rust,ignore
extern crate libc;

#[link(name = "readline")]
extern {
    static rl_readline_version: libc::c_int;
}

fn main() {
    println!("You have readline version {} installed.",
             unsafe { rl_readline_version as i32 });
}
```

<!--Alternatively, you may need to alter global state provided by a foreign interface.-->
あるいは、外部インタフェースによって提供されるグローバル状態を変更する必要があるかもしれません。
<!--To do this, statics can be declared with `mut` so we can mutate them.-->
これを行うには、静的`mut`を`mut`で宣言して、それらを突然変異させることができます。

```rust,ignore
extern crate libc;

use std::ffi::CString;
use std::ptr;

#[link(name = "readline")]
extern {
    static mut rl_prompt: *const libc::c_char;
}

fn main() {
    let prompt = CString::new("[my-awesome-shell] $").unwrap();
    unsafe {
        rl_prompt = prompt.as_ptr();

        println!("{:?}", rl_prompt);

        rl_prompt = ptr::null();
    }
}
```

<!--Note that all interaction with a `static mut` is unsafe, both reading and writing.-->
`static mut`とのやりとりはすべて、読み書きの両方が安全でないことに注意してください。
<!--Dealing with global mutable state requires a great deal of care.-->
グローバルな可変状態を扱うには、大きな注意が必要です。

# <!--Foreign calling conventions--> 外国の呼び出し規約

<!--Most foreign code exposes a C ABI, and Rust uses the platform's C calling convention by default when calling foreign functions.-->
ほとんどの外部コードはC ABIを公開し、Rustは外部関数を呼び出すときにデフォルトでプラットフォームのC呼び出し規約を使用します。
<!--Some foreign functions, most notably the Windows API, use other calling conventions.-->
一部の外部関数、特にWindows APIは、他の呼び出し規約を使用しています。
<!--Rust provides a way to tell the compiler which convention to use:-->
Rustはコンパイラにどのような規約を使用するかを伝える方法を提供します：

```rust,ignore
extern crate libc;

#[cfg(all(target_os = "win32", target_arch = "x86"))]
#[link(name = "kernel32")]
#[allow(non_snake_case)]
extern "stdcall" {
    fn SetEnvironmentVariableA(n: *const u8, v: *const u8) -> libc::c_int;
}
# fn main() { }
```

<!--This applies to the entire `extern` block.-->
これは`extern`ブロック全体に適用されます。
<!--The list of supported ABI constraints are:-->
サポートされているABI制約のリストは次のとおりです。

* `stdcall`
* `aapcs`
* `cdecl`
* `fastcall`
* `vectorcall`
<!--This is currently hidden behind the `abi_vectorcall` gate and is subject to change.-->
これは現在、`abi_vectorcall`ゲートの裏に隠されており、変更される可能性があります。
<!--* `Rust` * `rust-intrinsic` * `system` * `C` * `win64` * `sysv64`-->
* `Rust` * `rust-intrinsic` * `system` * `C` * `win64` * `sysv64`

<!--Most of the abis in this list are self-explanatory, but the `system` abi may seem a little odd.-->
このリストのほとんどのabisは自明であるが、`system` abiはちょっと奇妙に思えるかもしれない。
<!--This constraint selects whatever the appropriate ABI is for interoperating with the target's libraries.-->
この制約は、ターゲットのライブラリと相互運用するための適切なABIが何であれ選択します。
<!--For example, on win32 with a x86 architecture, this means that the abi used would be `stdcall`.-->
たとえば、x86アーキテクチャのwin32では、これはabiが`stdcall`ことを意味します。
<!--On x86_64, however, windows uses the `C` calling convention, so `C` would be used.-->
しかし、x86_64では、ウィンドウは`C`呼び出し規約を使用しているため、`C`が使用されます。
<!--This means that in our previous example, we could have used `extern "system" { ... }` to define a block for all windows systems, not only x86 ones.-->
つまり、前の例では、`extern "system" { ... }`を使用して、x86システムだけでなく、すべてのWindowsシステム用のブロックを定義することができました。

# <!--Interoperability with foreign code--> 外部コードとの相互運用性

<!--Rust guarantees that the layout of a `struct` is compatible with the platform's representation in C only if the `#[repr(C)]` attribute is applied to it.-->
Rustは、`#[repr(C)]`属性が適用されている場合に限り、`struct`のレイアウトがC言語でのプラットフォームの表現と互換性があることを保証します。
<!--`#[repr(C, packed)]` can be used to lay out struct members without padding.-->
`#[repr(C, packed)]`は`#[repr(C, packed)]`パディングなしで構造体メンバをレイアウトするために使用できます。
<!--`#[repr(C)]` can also be applied to an enum.-->
`#[repr(C)]`はenumにも適用できます。

<!--Rust's owned boxes (`Box<T>`) use non-nullable pointers as handles which point to the contained object.-->
Rustの所有ボックス（`Box<T>`）は、含まれているオブジェクトを指すハンドルとしてnullableではないポインタを使用します。
<!--However, they should not be manually created because they are managed by internal allocators.-->
ただし、内部のアロケータによって管理されるため、手動で作成するべきではありません。
<!--References can safely be assumed to be non-nullable pointers directly to the type.-->
参照は、その型に直接的にnull値ではないポインタであると見なすことができます。
<!--However, breaking the borrow checking or mutability rules is not guaranteed to be safe, so prefer using raw pointers (`*`) if that's needed because the compiler can't make as many assumptions about them.-->
しかし、借用検査または変更可能ルールを破ることは安全であるとは保証されていないため、コンパイラはそれらについて多くの仮定を行うことができないため、必要な場合は生ポインタ（`*`）を使用することをお勧めします。

<!--Vectors and strings share the same basic memory layout, and utilities are available in the `vec` and `str` modules for working with C APIs.-->
ベクトルと文字列は同じ基本的なメモリレイアウトを共有し、C APIを扱うための`vec`と`str`モジュールでユーティリティが利用できます。
<!--However, strings are not terminated with `\0`.-->
ただし、文字列は`\0`終了しません。
<!--If you need a NUL-terminated string for interoperability with C, you should use the `CString` type in the `std::ffi` module.-->
Cとの相互運用性のためにNULで終了する文字列が必要な場合は、`std::ffi`モジュールで`CString`型を使用する必要があります。

<!--The [`libc` crate on crates.io][libc] includes type aliases and function definitions for the C standard library in the `libc` module, and Rust links against `libc` and `libm` by default.-->
[crates.io][libc]の[`libc` crateに][libc]は、`libc`モジュールのC標準ライブラリのタイプ別名と関数定義、およびデフォルトで`libc`と`libm`に対するRustリンクが含まれています。

# <!--Variadic functions--> バリアント関数

<!--In C, functions can be 'variadic', meaning they accept a variable number of arguments.-->
Cでは、関数は可変的な数の引数を受け入れることを意味する 'variadic'にすることができます。
<!--This can be achieved in Rust by specifying `...` within the argument list of a foreign function declaration:-->
これは、外部関数宣言の引数リスト内で`...`を指定することで、Rustで実現できます。

```no_run
extern {
    fn foo(x: i32, ...);
}

fn main() {
    unsafe {
        foo(10, 20, 30, 40, 50);
    }
}
```

<!--Normal Rust functions can *not* be variadic:-->
通常の錆関数は可変ではあり*ませ*ん：

```ignore
#// This will not compile
// これはコンパイルされません

fn foo(x: i32, ...) { }
```

# <!--The "nullable pointer optimization"--> 「ヌル可能ポインタ最適化」は、

<!--Certain Rust types are defined to never be `null`.-->
特定の錆タイプは、決して`null`にならないように定義されてい`null`。
<!--This includes references (`&T`, `&mut T`), boxes (`Box<T>`), and function pointers (`extern "abi" fn()`).-->
これには、参照（`&T`、 `&mut T`）、ボックス（ `Box<T>`）、および関数ポインタ（ `extern "abi" fn()`）が含まれます。
<!--When interfacing with C, pointers that might be `null` are often used, which would seem to require some messy `transmute` s and/or unsafe code to handle conversions to/from Rust types.-->
C言語とのインタフェースでは、`null`可能性があるポインタが頻繁に使用されるため、Rust型への変換やRust型からの変換を処理するために、乱雑な`transmute`や安全でないコードが必要になるようです。
<!--However, the language provides a workaround.-->
ただし、この言語は回避策を提供します。

<!--As a special case, an `enum` is eligible for the "nullable pointer optimization"if it contains exactly two variants, one of which contains no data and the other contains a field of one of the non-nullable types listed above.-->
特別なケースとして、`enum`型に2つのバリアントが含まれていて、そのうちの1つにデータが含まれておらず、もう1つには上記のnull不可能な型のフィールドが含まれている場合、"nullable pointer optimization"の対象となります。
<!--This means no extra space is required for a discriminant;-->
これは、判別式に余分なスペースが必要ないことを意味します。
<!--rather, the empty variant is represented by putting a `null` value into the non-nullable field.-->
むしろ、空のバリアントは、`null`値を非ヌル可能フィールドに入れることによって表される。
<!--This is called an "optimization", but unlike other optimizations it is guaranteed to apply to eligible types.-->
これは「最適化」と呼ばれますが、他の最適化とは異なり、対象となるタイプに適用されることが保証されています。

<!--The most common type that takes advantage of the nullable pointer optimization is `Option<T>`, where `None` corresponds to `null`.-->
null可能なポインタの最適化を利用する最も一般的な型は`Option<T>`です。ここで`None`は`null`対応し`null`。
<!--So `Option<extern "C" fn(c_int) -> c_int>` is a correct way to represent a nullable function pointer using the C ABI (corresponding to the C type `int (*)(int)`).-->
したがって、`Option<extern "C" fn(c_int) -> c_int>`は、C ABI（Cの型`int (*)(int)`対応）を使用してnull可能な関数ポインタを表す正しい方法です。

<!--Here is a contrived example.-->
ここには工夫した例があります。
<!--Let's say some C library has a facility for registering a callback, which gets called in certain situations.-->
ある種の状況で呼び出されるコールバックを登録する機能をCライブラリが持っているとしましょう。
<!--The callback is passed a function pointer and an integer and it is supposed to run the function with the integer as a parameter.-->
コールバックには関数ポインタと整数が渡され、その整数をパラメータとして実行することになっています。
<!--So we have function pointers flying across the FFI boundary in both directions.-->
したがって、FFI境界をまたがって両方向に飛ぶ関数ポインタがあります。

```rust,ignore
extern crate libc;
use libc::c_int;

# #[cfg(hidden)]
extern "C" {
#//    /// Registers the callback.
    /// コールバックを登録します。
    fn register(cb: Option<extern "C" fn(Option<extern "C" fn(c_int) -> c_int>, c_int) -> c_int>);
}
# unsafe fn register(_: Option<extern "C" fn(Option<extern "C" fn(c_int) -> c_int>,
#                                            c_int) -> c_int>)
# {}

#///// This fairly useless function receives a function pointer and an integer
/// この無駄な関数は関数ポインタと整数を受け取ります
#///// from C, and returns the result of calling the function with the integer.
///  Cから取り出し、その関数を整数で呼び出した結果を返します。
#///// In case no function is provided, it squares the integer by default.
/// 関数が提供されていない場合は、デフォルトで整数に二乗されます。
extern "C" fn apply(process: Option<extern "C" fn(c_int) -> c_int>, int: c_int) -> c_int {
    match process {
        Some(f) => f(int),
        None    => int * int
    }
}

fn main() {
    unsafe {
        register(Some(apply));
    }
}
```

<!--And the code on the C side looks like this:-->
C側のコードは次のようになります。

```c
void register(void (*f)(void (*)(int), int)) {
    ...
}
```

<!--No `transmute` required!-->
`transmute`不要！

# <!--Calling Rust code from C--> Cから錆​​のコードを呼び出す

<!--You may wish to compile Rust code in a way so that it can be called from C. This is fairly easy, but requires a few things:-->
RustコードをCから呼び出せるようにコンパイルすることもできます。これはかなり簡単ですが、いくつか必要です。

```rust
#[no_mangle]
pub extern fn hello_rust() -> *const u8 {
    "Hello, world!\0".as_ptr()
}
# fn main() {}
```

<!--The `extern` makes this function adhere to the C calling convention, as discussed above in "[Foreign Calling Conventions](ffi.html#foreign-calling-conventions) ".-->
`extern`は、上記の「 [外部呼び出し規約](ffi.html#foreign-calling-conventions) 」で説明したように、この関数をC呼び出し規約に従わせます。
<!--The `no_mangle` attribute turns off Rust's name mangling, so that it is easier to link to.-->
`no_mangle`属性はRustの名前の変更を無効にします。リンクする方が簡単です。

# <!--FFI and panics--> FFIとパニック

<!--It's important to be mindful of `panic!` s when working with FFI.-->
FFIと一緒に働くときは、`panic!`に気をつけることが重要です。
<!--A `panic!` across an FFI boundary is undefined behavior.-->
FFI境界を横切る`panic!`は未定義の動作です。
<!--If you're writing code that may panic, you should run it in a closure with [`catch_unwind`]:-->
パニックに陥るかもしれないコードを書いているなら、[`catch_unwind`]てクロージャーで実行するべき[`catch_unwind`]：

```rust
use std::panic::catch_unwind;

#[no_mangle]
pub extern fn oh_no() -> i32 {
    let result = catch_unwind(|| {
        panic!("Oops!");
    });
    match result {
        Ok(_) => 0,
        Err(_) => 1,
    }
}

fn main() {}
```

<!--Please note that [`catch_unwind`] will only catch unwinding panics, not those who abort the process.-->
[`catch_unwind`]はプロセスを中止する人ではなく、巻き戻すパニックを[`catch_unwind`]するだけであることに注意してください。
<!--See the documentation of [`catch_unwind`] for more information.-->
詳細は[`catch_unwind`]のドキュメントを参照してください。

[`catch_unwind`]: ../std/panic/fn.catch_unwind.html

# <!--Representing opaque structs--> 不透明な構造体を表現する

<!--Sometimes, a C library wants to provide a pointer to something, but not let you know the internal details of the thing it wants.-->
時々、Cライブラリは何かへのポインタを提供したいが、あなたが望むものの内部の詳細を知らせない。
<!--The simplest way is to use a `void *` argument:-->
最も簡単な方法は`void *`引数を使うことです：

```c
void foo(void *arg);
void bar(void *arg);
```

<!--We can represent this in Rust with the `c_void` type:-->
これを`c_void`で表すことができます：

```rust,ignore
extern crate libc;

extern "C" {
    pub fn foo(arg: *mut libc::c_void);
    pub fn bar(arg: *mut libc::c_void);
}
# fn main() {}
```

<!--This is a perfectly valid way of handling the situation.-->
これは状況を処理するための完全に有効な方法です。
<!--However, we can do a bit better.-->
しかし、少し上手くいくことができます。
<!--To solve this, some C libraries will instead create a `struct`, where the details and memory layout of the struct are private.-->
これを解決するために、Cライブラリの中には`struct`を作成するものがあります。`struct`の詳細とメモリレイアウトはprivateです。
<!--This gives some amount of type safety.-->
これにより、ある程度の型の安全性が得られます。
<!--These structures are called 'opaque'.-->
これらの構造は「不透明」と呼ばれます。
<!--Here's an example, in C:-->
ここではCの例を示します：

```c
struct Foo; /* Foo is a structure, but its contents are not part of the public interface */
struct Bar;
void foo(struct Foo *arg);
void bar(struct Bar *arg);
```

<!--To do this in Rust, let's create our own opaque types with `enum`:-->
Rustでこれを行うには、`enum`独自の不透明な型を作成しましょう：

```rust
pub enum Foo {}
pub enum Bar {}

extern "C" {
    pub fn foo(arg: *mut Foo);
    pub fn bar(arg: *mut Bar);
}
# fn main() {}
```

<!--By using an `enum` with no variants, we create an opaque type that we can't instantiate, as it has no variants.-->
バリアントを持たない`enum`を使用することで、バリアントが存在しないため、インスタンス化できない不透明な型を作成します。
<!--But because our `Foo` and `Bar` types are different, we'll get type safety between the two of them, so we cannot accidentally pass a pointer to `Foo` to `bar()`.-->
しかし、`Foo`と`Bar`型が異なるため、2つの型の間で型の安全性が確保されるため、`Foo`へのポインタを`bar()`渡すことはできません。
