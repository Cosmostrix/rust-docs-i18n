# <!--Foreign Function Interface--> 外部関数インタフェース

<!--Rust provides a Foreign Function Interface (FFI) to C libraries.-->
RustはCライブラリにFFI（Foreign Function Interface）を提供します。
<!--Foreign functions must be declared inside an `extern` block annotated with a `#[link]` attribute containing the name of the foreign library.-->
外部関数は、外部ライブラリの名前を含む`#[link]`属性で注釈が付けられた`extern`ブロック内で宣言されなければなりません。

```rust,ignore
use std::fmt;

#// this extern block links to the libm library
// このexternブロックはlibmライブラリにリンクしています
#[link(name = "m")]
extern {
#    // this is a foreign function
#    // that computes the square root of a single precision complex number
    // これは、単精度複素数の平方根を計算する外部関数です
    fn csqrtf(z: Complex) -> Complex;

    fn ccosf(z: Complex) -> Complex;
}

#// Since calling foreign functions is considered unsafe,
#// it's common to write safe wrappers around them.
// 外部関数を呼び出すことは安全ではないと考えられているので、安全なラッパーを書くのが一般的です。
fn cos(z: Complex) -> Complex {
    unsafe { ccosf(z) }
}

fn main() {
#    // z = -1 + 0i
    //  z = -1 + 0i
    let z = Complex { re: -1., im: 0. };

#    // calling a foreign function is an unsafe operation
    // 外部関数を呼び出すことは危険な操作です
    let z_sqrt = unsafe { csqrtf(z) };

    println!("the square root of {:?} is {:?}", z, z_sqrt);

#    // calling safe API wrapped around unsafe operation
    // 安全でない操作をラップする安全なAPIを呼び出す
    println!("cos({:?}) = {:?}", z, cos(z));
}

#// Minimal implementation of single precision complex numbers
// 単精度複素数の最小限の実装
#[repr(C)]
#[derive(Clone, Copy)]
struct Complex {
    re: f32,
    im: f32,
}

impl fmt::Debug for Complex {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if self.im < 0. {
            write!(f, "{}-{}i", self.re, -self.im)
        } else {
            write!(f, "{}+{}i", self.re, self.im)
        }
    }
}
```
