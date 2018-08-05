# <!--Crates--> クレート

<!--A crate is a compilation unit in Rust.-->
クレートは、ルーストのコンパイルユニットです。
<!--Whenever `rustc some_file.rs` is called, `some_file.rs` is treated as the *crate file*.-->
`rustc some_file.rs`が呼び出されると、`some_file.rs`は`some_file.rs` *ファイル*として扱われ*ます*。
<!--If `some_file.rs` has `mod` declarations in it, then the contents of the module files would be inserted in places where `mod` declarations in the crate file are found, *before* running the compiler over it.-->
`some_file.rs`に`mod`宣言がある場合、モジュールファイルの内容は、コンパイラを実行する*前*に、crateファイルの`mod`宣言が見つかった場所に挿入されます。
<!--In other words, modules do *not* get compiled individually, only crates get compiled.-->
言い換えれば、モジュールは個別にコンパイルされ*ず*、クレートだけがコンパイルされます。

<!--A crate can be compiled into a binary or into a library.-->
クレートは、バイナリまたはライブラリにコンパイルすることができます。
<!--By default, `rustc` will produce a binary from a crate.-->
デフォルトでは、`rustc`はクレートからバイナリを生成します。
<!--This behavior can be overridden by passing the `--crate-type` flag to `rustc`.-->
この動作は、--`--crate-type`フラグを`rustc`渡すことによって無効にすることができます。
