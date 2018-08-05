# <!--External blocks--> 外部ブロック

<!--External blocks form the basis for Rust's foreign function interface.-->
外部ブロックは、Rustの外部関数インタフェースの基礎を形成します。
<!--Declarations in an external block describe symbols in external, non-Rust libraries.-->
外部ブロックの宣言は、外部の非Rustライブラリのシンボルを記述します。

<!--Functions within external blocks are declared in the same way as other Rust functions, with the exception that they may not have a body and are instead terminated by a semicolon.-->
外部ブロック内の関数は、他のRust関数と同じ方法で宣言されますが、本体がなく、セミコロンで終了することはありません。

<!--Functions within external blocks may be called by Rust code, just like functions defined in Rust.-->
外部ブロック内の関数は、Rustで定義された関数と同様に、Rustコードで呼び出すことができます。
<!--The Rust compiler automatically translates between the Rust ABI and the foreign ABI.-->
Rustコンパイラは、Rust ABIと外部ABIを自動的に変換します。

<!--Functions within external blocks may be variadic by specifying `...` after one or more named arguments in the argument list:-->
外部ブロック内の関数は、引数リスト内の1つまたは複数の名前付き引数の後に`...`を指定することで可変的になります。

```rust,ignore
extern {
    fn foo(x: i32, ...);
}
```

<!--A number of [attributes] control the behavior of external blocks.-->
多くの[attributes]が外部ブロックの動作を制御します。

[attributes]: attributes.html#ffi-attributes

<!--By default external blocks assume that the library they are calling uses the standard C ABI on the specific platform.-->
デフォルトでは、外部ブロックは、呼び出しているライブラリが特定のプラットフォーム上で標準C ABIを使用していることを前提としています。
<!--Other ABIs may be specified using an `abi` string, as shown here:-->
他のABIは、以下に示すように、`abi`文字列を使用して指定できます。

```rust,ignore
#// Interface to the Windows API
//  Windows APIへのインターフェイス
extern "stdcall" { }
```

<!--There are three ABI strings which are cross-platform, and which all compilers are guaranteed to support:-->
クロスプラットフォームであり、すべてのコンパイラがサポートすることが保証されている3つのABI文字列があります。

* <!--`extern "Rust"` --The default ABI when you write a normal `fn foo()` in any Rust code.-->
   `extern "Rust"` -任意の錆コードに通常の`fn foo()`を書くと、デフォルトのABIです。
* <!--`extern "C"` --This is the same as `extern fn foo()`;-->
   `extern "C"` -これは`extern fn foo()`と同じです。
<!--whatever the default your C compiler supports.-->
   あなたのCコンパイラがサポートしているものは何でも。
* <!--`extern "system"` --Usually the same as `extern "C"`, except on Win32, in which case it's `"stdcall"`, or what you should use to link to the Windows API itself-->
   `extern "system"` -通常は`extern "C"`と同じですが、Win32では`"stdcall"`、Windows API自体にリンクするためには何を使うべきですか

<!--There are also some platform-specific ABI strings:-->
プラットフォーム固有のABI文字列もいくつかあります。

* <!--`extern "cdecl"` --The default for x86\_32 C code.-->
   `extern "cdecl"` -x86 \ _32 Cコードのデフォルト。
* <!--`extern "stdcall"` --The default for the Win32 API on x86\_32.-->
   `extern "stdcall"` -x86 \ _32上のWin32 APIのデフォルト。
* <!--`extern "win64"` --The default for C code on x86\_64 Windows.-->
   `extern "win64"` -x86 \ _64 WindowsのCコードのデフォルト。
* <!--`extern "sysv64"` --The default for C code on non-Windows x86\_64.-->
   `extern "sysv64"` -非Windows x86のCコードのデフォルト値\ _64。
* <!--`extern "aapcs"` --The default for ARM.-->
   `extern "aapcs"` -ARMのデフォルトです。
* <!--`extern "fastcall"` --The `fastcall` ABI --corresponds to MSVC's `__fastcall` and GCC and clang's `__attribute__((fastcall))`-->
   `extern "fastcall"` -`fastcall` ABI -MSVCの`__fastcall`とGCCとclangの`__attribute__((fastcall))`
* <!--`extern "vectorcall"` --The `vectorcall` ABI --corresponds to MSVC's `__vectorcall` and clang's `__attribute__((vectorcall))`-->
   `extern "vectorcall"` -`vectorcall` ABI -MSVCの`__vectorcall`およびclangの`__attribute__((vectorcall))`

<!--Finally, there are some rustc-specific ABI strings:-->
最後に、rustc特有のABI文字列があります：

* <!--`extern "rust-intrinsic"` --The ABI of rustc intrinsics.-->
   `extern "rust-intrinsic"` -`extern "rust-intrinsic"`のABIです。
* <!--`extern "rust-call"` --The ABI of the Fn::call trait functions.-->
   `extern "rust-call"` -Fn:: call tr​​ait関数のABI。
* <!--`extern "platform-intrinsic"` --Specific platform intrinsics --like, for example, `sqrt` --have this ABI.-->
   `extern "platform-intrinsic"` -特定のプラットフォーム組み込み関数 -たとえば`sqrt` -このABIを持っています。
<!--You should never have to deal with it.-->
   あなたはそれに対処する必要はありません。

<!--The `link` attribute allows the name of the library to be specified.-->
`link`属性では、ライブラリの名前を指定できます。
<!--When specified the compiler will attempt to link against the native library of the specified name.-->
指定すると、コンパイラは指定された名前のネイティブライブラリとのリンクを試みます。

```rust,ignore
#[link(name = "crypto")]
extern { }
```

<!--The type of a function declared in an extern block is `extern "abi" fn(A1, ..., An) -> R`, where `A1...An` are the declared types of its arguments and `R` is the declared return type.-->
externブロックで宣言された関数の型は`extern "abi" fn(A1, ..., An) -> R`。ここで、 `A1...An`は宣言された引数の型、`R`は宣言された戻り型です。

<!--It is valid to add the `link` attribute on an empty extern block.-->
空のexternブロックに`link`属性を追加することは有効です。
<!--You can use this to satisfy the linking requirements of extern blocks elsewhere in your code (including upstream crates) instead of adding the attribute to each extern block.-->
これを使用して、各externブロックに属性を追加するのではなく、コードの他の場所（上流のテンプレートを含む）のexternブロックのリンク要件を満たすことができます。
