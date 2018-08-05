# <!--Linkage--> リンケージ

<!--The Rust compiler supports various methods to link crates together both statically and dynamically.-->
Rustコンパイラは、静的および動的の両方でクレートをリンクするさまざまな方法をサポートしています。
<!--This section will explore the various methods to link Rust crates together, and more information about native libraries can be found in the [FFI section of the book][ffi].-->
このセクションでは、Rustクレートをリンクするさまざまな方法について説明します。ネイティブライブラリの詳細について[は、本のFFIセクションを参照してください][ffi]。

[ffi]: ../book/ffi.html

<!--In one session of compilation, the compiler can generate multiple artifacts through the usage of either command line flags or the `crate_type` attribute.-->
コンパイルの1つのセッションでは、コンパイラはコマンドラインフラグまたは`crate_type`属性のいずれかを使用して複数の成果物を生成できます。
<!--If one or more command line flags are specified, all `crate_type` attributes will be ignored in favor of only building the artifacts specified by command line.-->
1つ以上のコマンドラインフラグが指定されている場合、コマンドラインで指定された成果物を構築するためだけに、すべての`crate_type`属性は無視されます。

* <!--`--crate-type=bin`, `#[crate_type = "bin"]` -A runnable executable will be produced.-->
   `--crate-type=bin`、 `#[crate_type = "bin"]` -実行可能な実行可能ファイルが生成されます。
<!--This requires that there is a `main` function in the crate which will be run when the program begins executing.-->
   これには、プログラムが実行を開始するときに実行される`main`機能がクレートに存在する必要があります。
<!--This will link in all Rust and native dependencies, producing a distributable binary.-->
   これにより、すべてのRustとネイティブの依存関係がリンクされ、配布可能なバイナリが生成されます。

* <!--`--crate-type=lib`, `#[crate_type = "lib"]` -A Rust library will be produced.-->
   `--crate-type=lib`、 `#[crate_type = "lib"]` -Rustライブラリが生成されます。
<!--This is an ambiguous concept as to what exactly is produced because a library can manifest itself in several forms.-->
   これは、ライブラリがいくつかの形で現れることができるため、正確に何が生成されるのかというあいまいな概念です。
<!--The purpose of this generic `lib` option is to generate the "compiler recommended"style of library.-->
   この汎用的な`lib`オプションの目的は、"コンパイラが推奨する"スタイルのライブラリを生成することです。
<!--The output library will always be usable by rustc, but the actual type of library may change from time-to-time.-->
   出力ライブラリは常にrustcで使用可能ですが、実際のライブラリのタイプは時々変更されることがあります。
<!--The remaining output types are all different flavors of libraries, and the `lib` type can be seen as an alias for one of them (but the actual one is compiler-defined).-->
   残りの出力タイプはすべてライブラリの異なるフレーバであり、`lib`タイプはそのうちの1つのエイリアスと`lib`ことができます（実際のものはコンパイラ定義です）。

* <!--`--crate-type=dylib`, `#[crate_type = "dylib"]` -A dynamic Rust library will be produced.-->
   `--crate-type=dylib`、 `#[crate_type = "dylib"]` -動的なRustライブラリが生成されます。
<!--This is different from the `lib` output type in that this forces dynamic library generation.-->
   これは、ダイナミックライブラリ生成を強制する点で、`lib`出力タイプとは異なります。
<!--The resulting dynamic library can be used as a dependency for other libraries and/or executables.-->
   生成された動的ライブラリは、他のライブラリや実行可能ファイルの依存として使用できます。
<!--This output type will create `*.so` files on linux, `*.dylib` files on osx, and `*.dll` files on windows.-->
   この出力タイプは、Linuxでは`*.so`ファイル、osxでは`*.dylib`ファイル、Windowsでは`*.dll`ファイルを作成します。

* <!--`--crate-type=staticlib`, `#[crate_type = "staticlib"]` -A static system library will be produced.-->
   `--crate-type=staticlib`、 `#[crate_type = "staticlib"]` -静的システムライブラリが生成されます。
<!--This is different from other library outputs in that the Rust compiler will never attempt to link to `staticlib` outputs.-->
   これは、Rustコンパイラが`staticlib`出力にリンクしようとしないという点で、他のライブラリの出力とは異なります。
<!--The purpose of this output type is to create a static library containing all of the local crate's code along with all upstream dependencies.-->
   この出力タイプの目的は、ローカルクレートのすべてのコードとすべてのアップストリーム依存関係を含む静的ライブラリを作成することです。
<!--The static library is actually a `*.a` archive on linux and osx and a `*.lib` file on windows.-->
   静的ライブラリは、実際にはlinuxとosxの`*.a`アーカイブとwindowsの`*.lib`ファイルです。
<!--This format is recommended for use in situations such as linking Rust code into an existing non-Rust application because it will not have dynamic dependencies on other Rust code.-->
   この形式は、Rustコードを他のRustコードと動的に依存しないため、既存の非Rustアプリケーションにリンクするなどの状況で使用することをお勧めします。

* <!--`--crate-type=cdylib`, `#[crate_type = "cdylib"]` -A dynamic system library will be produced.-->
   `--crate-type=cdylib`、 `#[crate_type = "cdylib"]` -動的システムライブラリが生成されます。
<!--This is used when compiling Rust code as a dynamic library to be loaded from another language.-->
   Rustコードを別の言語からロードする動的ライブラリとしてコンパイルするときに使用されます。
<!--This output type will create `*.so` files on Linux, `*.dylib` files on macOS, and `*.dll` files on Windows.-->
   この出力タイプは、Linuxでは`*.so`ファイル、MacOSでは`*.dylib`ファイル、Windowsでは`*.dll`ファイルを作成します。

* <!--`--crate-type=rlib`, `#[crate_type = "rlib"]` -A "Rust library"file will be produced.-->
   `--crate-type=rlib`、 `#[crate_type = "rlib"]` -"Rust library"ファイルが生成されます。
<!--This is used as an intermediate artifact and can be thought of as a "static Rust library".-->
   これは中間アーティファクトとして使用され、「スタティック・ルスト・ライブラリ」と考えることができます。
<!--These `rlib` files, unlike `staticlib` files, are interpreted by the Rust compiler in future linkage.-->
   これらの`rlib`のファイルは、とは異なり`staticlib`ファイル、今後の連携で錆コンパイラによって解釈されています。
<!--This essentially means that `rustc` will look for metadata in `rlib` files like it looks for metadata in dynamic libraries.-->
   これは、本質的に、`rustc`が動的ライブラリのメタデータを探すような`rlib`ファイルのメタデータを探すことを意味します。
<!--This form of output is used to produce statically linked executables as well as `staticlib` outputs.-->
   この形式の出力は、静的にリンクされた実行可能ファイルと`staticlib`出力を生成するために使用されます。

* <!--`--crate-type=proc-macro`, `#[crate_type = "proc-macro"]` -The output produced is not specified, but if a `-L` path is provided to it then the compiler will recognize the output artifacts as a macro and it can be loaded for a program.-->
   `--crate-type=proc-macro`、 `#[crate_type = "proc-macro"]` -生成される出力は指定されていませんが、`-L`パスが指定されている場合、コンパイラは出力成果物をマクロとして認識し、それはプログラムのためにロードすることができます。
<!--If a crate is compiled with the `proc-macro` crate type it will forbid exporting any items in the crate other than those functions tagged `#[proc_macro_derive]` and those functions must also be placed at the crate root.-->
   クレートが`proc-macro` crateタイプでコンパイルされている場合は、`#[proc_macro_derive]`タグの`#[proc_macro_derive]`もの以外のクレート内のアイテムの書き出しを禁止し、それらの関数もクレートルートに配置する必要があります。
<!--Finally, the compiler will automatically set the `cfg(proc_macro)` annotation whenever any crate type of a compilation is the `proc-macro` crate type.-->
   最後に、コンパイルのいずれかのクレートタイプが`proc-macro` `cfg(proc_macro)`タイプである場合、コンパイラは自動的に`cfg(proc_macro)`アノテーションを設定します。

<!--Note that these outputs are stackable in the sense that if multiple are specified, then the compiler will produce each form of output at once without having to recompile.-->
これらの出力は、複数が指定された場合、コンパイル時に各形式の出力を一度に再コンパイルせずに生成できるという意味でスタック可能です。
<!--However, this only applies for outputs specified by the same method.-->
ただし、これは同じメソッドで指定された出力にのみ適用されます。
<!--If only `crate_type` attributes are specified, then they will all be built, but if one or more `--crate-type` command line flags are specified, then only those outputs will be built.-->
`crate_type`属性のみが指定されている場合はすべてビルドされますが、1つ以上の`--crate-type`コマンドラインフラグが指定されていれば、その出力だけが構築されます。

<!--With all these different kinds of outputs, if crate A depends on crate B, then the compiler could find B in various different forms throughout the system.-->
これらの異なる種類のアウトプットの全てで、クレートAがクレートBに依存する場合、コンパイラはシステム全体にわたって様々な異なる形のBを見つけることができます。
<!--The only forms looked for by the compiler, however, are the `rlib` format and the dynamic library format.-->
ただし、コンパイラが`rlib`する`rlib`形式は、`rlib`形式と動的ライブラリ形式です。
<!--With these two options for a dependent library, the compiler must at some point make a choice between these two formats.-->
これらの2つのオプションの依存ライブラリーを使用すると、コンパイラーはある時点でこれらの2つの形式を選択する必要があります。
<!--With this in mind, the compiler follows these rules when determining what format of dependencies will be used:-->
これを念頭に置いて、コンパイラは、使用される依存関係の形式を決定する際に、次の規則に従います。

1. <!--If a static library is being produced, all upstream dependencies are required to be available in `rlib` formats.-->
    静的ライブラリが作成されている場合は、すべての上流依存ファイルが`rlib`形式で使用可能である必要があります。
<!--This requirement stems from the reason that a dynamic library cannot be converted into a static format.-->
    この要件は、動的ライブラリを静的フォーマットに変換できないという理由から生じます。

<!--Note that it is impossible to link in native dynamic dependencies to a static library, and in this case warnings will be printed about all unlinked native dynamic dependencies.-->
ネイティブの動的依存関係を静的ライブラリにリンクすることは不可能であることに注意してください。この場合、リンクされていないすべてのネイティブ動的依存関係に関する警告が出力されます。

2. <!--If an `rlib` file is being produced, then there are no restrictions on what format the upstream dependencies are available in. It is simply required that all upstream dependencies be available for reading metadata from.-->
    `rlib`ファイルが作成されている場合、アップストリーム依存関係がどの形式で使用できるかに制限はありません。すべてのアップストリーム依存関係をメタデータの読み込みに使用するだけで済みます。

<!--The reason for this is that `rlib` files do not contain any of their upstream dependencies.-->
その理由は、`rlib`ファイルに上流の依存関係が含まれていないからです。
<!--It wouldn't be very efficient for all `rlib` files to contain a copy of `libstd.rlib`!-->
すべての`rlib`ファイルが`libstd.rlib`コピーを含むことはあまり効率的ではありません！

3. <!--If an executable is being produced and the `-C prefer-dynamic` flag is not specified, then dependencies are first attempted to be found in the `rlib` format.-->
    実行可能ファイルが生成されており、`-C prefer-dynamic`フラグが指定されていない場合、依存関係は`rlib`形式で最初に見つかるように試みられます。
<!--If some dependencies are not available in an rlib format, then dynamic linking is attempted (see below).-->
    いくつかの依存関係がrlib形式で利用できない場合、動的リンクが試みられます（下記参照）。

4. <!--If a dynamic library or an executable that is being dynamically linked is being produced, then the compiler will attempt to reconcile the available dependencies in either the rlib or dylib format to create a final product.-->
    ダイナミックライブラリまたは動的にリンクされている実行可能ファイルが生成されている場合、コンパイラはrlibまたはdylib形式で使用可能な依存関係を調整して最終製品を作成しようとします。

<!--A major goal of the compiler is to ensure that a library never appears more than once in any artifact.-->
コンパイラの主な目的は、ライブラリがアーティファクトに何度も出現しないようにすることです。
<!--For example, if dynamic libraries B and C were each statically linked to library A, then a crate could not link to B and C together because there would be two copies of A. The compiler allows mixing the rlib and dylib formats, but this restriction must be satisfied.-->
たとえば、ダイナミックライブラリBとCがそれぞれライブラリAに静的にリンクされている場合、Aのコピーが2つ存在するため、クレートはBとCにリンクできませんでした。コンパイラはrlibとdylibのフォーマットを混合できますが、満足しなければならない。

<!--The compiler currently implements no method of hinting what format a library should be linked with.-->
現在のところ、コンパイラは、ライブラリをどの形式にリンクするべきかを示す方法を実装していません。
<!--When dynamically linking, the compiler will attempt to maximize dynamic dependencies while still allowing some dependencies to be linked in via an rlib.-->
動的にリンクするとき、コンパイラは動的依存関係を最大化しようとしますが、rlibを介していくつかの依存関係をリンクさせることもできます。

<!--For most situations, having all libraries available as a dylib is recommended if dynamically linking.-->
ダイナミックリンクの場合、ほとんどの場合、すべてのライブラリをdylibとして利用可能にすることをお勧めします。
<!--For other situations, the compiler will emit a warning if it is unable to determine which formats to link each library with.-->
他の状況では、各ライブラリをどのフォーマットでリンクするかを判断できない場合、コンパイラは警告を発します。

<!--In general, `--crate-type=bin` or `--crate-type=lib` should be sufficient for all compilation needs, and the other options are just available if more fine-grained control is desired over the output format of a Rust crate.-->
一般に、--`--crate-type=bin`または`--crate-type=lib`はすべてのコンパイルの必要性に十分でなければならず、他のオプションは、Rustクレートの出力フォーマットより細かい制御が必要な場合にのみ使用できます。

## <!--Static and dynamic C runtimes--> 静的および動的Cランタイム

<!--The standard library in general strives to support both statically linked and dynamically linked C runtimes for targets as appropriate.-->
一般的に、標準ライブラリは、静的にリンクされたリンクと動的にリンクされたCランタイムの両方をターゲットとして適切にサポートするよう努めています。
<!--For example the `x86_64-pc-windows-msvc` and `x86_64-unknown-linux-musl` targets typically come with both runtimes and the user selects which one they'd like.-->
たとえば、`x86_64-pc-windows-msvc`と`x86_64-unknown-linux-musl`ターゲットは通常、両方のランタイムが付属しており、ユーザーはどちらを使用するかを選択します。
<!--All targets in the compiler have a default mode of linking to the C runtime.-->
コンパイラのすべてのターゲットには、Cランタイムにリンクするデフォルトのモードがあります。
<!--Typically targets are linked dynamically by default, but there are exceptions which are static by default such as:-->
通常、ターゲットはデフォルトで動的にリンクされますが、次のようなデフォルトでは静的な例外があります。

* `arm-unknown-linux-musleabi`
* `arm-unknown-linux-musleabihf`
* `armv7-unknown-linux-musleabihf`
* `i686-unknown-linux-musl`
* `x86_64-unknown-linux-musl`

<!--The linkage of the C runtime is configured to respect the `crt-static` target feature.-->
Cランタイムのリンケージは、`crt-static`ターゲット機能を尊重するように構成されています。
<!--These target features are typically configured from the command line via flags to the compiler itself.-->
これらのターゲット機能は、通常、コマンドラインからフラグを介してコンパイラ自体に設定されます。
<!--For example to enable a static runtime you would execute:-->
たとえば、静的ランタイムを有効にするには、次のように実行します。

```notrust
rustc -C target-feature=+crt-static foo.rs
```

<!--whereas to link dynamically to the C runtime you would execute:-->
Cランタイムに動的にリンクするには、次のように実行します。

```notrust
rustc -C target-feature=-crt-static foo.rs
```

<!--Targets which do not support switching between linkage of the C runtime will ignore this flag.-->
Cランタイムのリンケージ間の切り替えをサポートしていないターゲットは、このフラグを無視します。
<!--It's recommended to inspect the resulting binary to ensure that it's linked as you would expect after the compiler succeeds.-->
結果のバイナリを調べて、コンパイラが成功した後に期待どおりにリンクされていることを確認することをお勧めします。

<!--Crates may also learn about how the C runtime is being linked.-->
Cratesは、Cランタイムがどのようにリンクされているかを知ることもできます。
<!--Code on MSVC, for example, needs to be compiled differently (eg with `/MT` or `/MD`) depending on the runtime being linked.-->
たとえば、MSVC上のコードは、リンクされているランタイムに応じて異なる方法でコンパイルする必要があります（たとえば、`/MT`または`/MD`）。
<!--This is exported currently through the `target_feature` attribute (note this is a nightly feature):-->
これは現在、`target_feature`属性を介してエクスポートされてい`target_feature`（これは夜間の機能です）。

```rust,ignore
#[cfg(target_feature = "crt-static")]
fn foo() {
    println!("the C runtime should be statically linked");
}

#[cfg(not(target_feature = "crt-static"))]
fn foo() {
    println!("the C runtime should be dynamically linked");
}
```

<!--Also note that Cargo build scripts can learn about this feature through [environment variables][cargo].-->
また、Cargoビルドスクリプトは[環境変数を][cargo]使ってこの機能について知ることができ[ます][cargo]。
<!--In a build script you can detect the linkage via:-->
ビルドスクリプトでは、次の方法でリンケージを検出できます。

```rust
use std::env;

fn main() {
    let linkage = env::var("CARGO_CFG_TARGET_FEATURE").unwrap_or(String::new());

    if linkage.contains("crt-static") {
        println!("the C runtime will be statically linked");
    } else {
        println!("the C runtime will be dynamically linked");
    }
}
```

[cargo]: http://doc.crates.io/environment-variables.html#environment-variables-cargo-sets-for-build-scripts

<!--To use this feature locally, you typically will use the `RUSTFLAGS` environment variable to specify flags to the compiler through Cargo.-->
この機能をローカルで使用するには、`RUSTFLAGS`環境変数を使用して、Cargoを介してコンパイラにフラグを指定します。
<!--For example to compile a statically linked binary on MSVC you would execute:-->
たとえば、MSVCで静的にリンクされたバイナリをコンパイルするには、次のコマンドを実行します。

```ignore,notrust
RUSTFLAGS='-C target-feature=+crt-static' cargo build --target x86_64-pc-windows-msvc
```
