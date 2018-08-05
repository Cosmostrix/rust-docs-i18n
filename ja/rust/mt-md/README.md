# <!--The Rust Programming Language--> 錆プログラミング言語

<!--This is the main source code repository for [Rust].-->
これは、[Rust]主なソースコードリポジトリです。
<!--It contains the compiler, standard library, and documentation.-->
コンパイラ、標準ライブラリ、およびドキュメントが含まれています。

[Rust]: https://www.rust-lang.org

## <!--Quick Start--> クイックスタート
[quick-start]: #quick-start

<!--Read ["Installation"] from [The Book].-->
[The Book]から["Installation"]を読んでください。

<!--["Installation"]: https://doc.rust-lang.org/book/second-edition/ch01-01-installation.html
 [The Book]: https://doc.rust-lang.org/book/index.html
-->
["Installation"]: https://doc.rust-lang.org/book/second-edition/ch01-01-installation.html
 [The Book]: https://doc.rust-lang.org/book/index.html


## <!--Building from Source--> ソースからのビルド
[building-from-source]: #building-from-source

### <!--Building on *nix 1. Make sure you have installed the dependencies:* `g++` 4.7 or later or `clang++` 3.x or later--> *nixへの*ビルド*1.* `g++` 4.7以降または`clang++` 3.x以降の*依存関係がインストールされていることを確認します。*
   * <!--`python` 2.7 (but not 3.x)-->
      `python` 2.7（ただし、3.xでは使用できません）
   * <!--GNU `make` 3.81 or later-->
      GNU `make` 3.81以降
   * <!--`cmake` 3.4.3 or later-->
      `cmake` 3.4.3以降
   * `curl`
   * `git`

2. <!--Clone the [source] with `git`:-->
    `git` [source]をクローン：

<!--` ``sh $ git clone https://github.com/rust-lang/rust.git $ cd rust`` `-->
` ``sh $ git clone https://github.com/rust-lang/rust.git $ cd rust``

[source]: https://github.com/rust-lang/rust

3. <!--Build and install:-->
    ビルドとインストール：

<!--` ``sh $ git submodule update --init --recursive --progress $ ./x.py build && sudo ./x.py install`` `-->
` ``sh $ git submodule update --init --recursive --progress $ ./x.py build && sudo ./x.py install``

<!--> * **Note:** * Install locations can be adjusted by copying the config file > from `./config.toml.example` to `./config.toml`, and > adjusting the `prefix` option under `[install]`.-->
> * **注意：** *設定ファイルを`./config.toml`から`./config.toml.example`にコピーし、`[install]` `prefix`オプションを調整することで、インストール場所を調整することができます。
<!--Various other options, such > as enabling debug information, are also supported, and are documented in > the config file.-->
デバッグ情報を有効にするなど、さまざまなオプションもサポートされており、> configファイルに記述されています。

<!--When complete, `sudo ./x.py install` will place several programs into `/usr/local/bin`: `rustc`, the Rust compiler, and `rustdoc`, the API-documentation tool.-->
完了すると、`sudo ./x.py install`は、いくつかのプログラムを`/usr/local/bin`： `rustc`、Rustコンパイラ、およびAPIドキュメントツール`rustdoc`ます。
<!--This install does not include [Cargo], Rust's package manager, which you may also want to build.-->
このインストールには、[Cargo]、Rustのパッケージマネージャーは含まれていません。

[Cargo]: https://github.com/rust-lang/cargo

### <!--Building on Windows--> Windowsでのビルド
[building-on-windows]: #building-on-windows

<!--There are two prominent ABIs in use on Windows: the native (MSVC) ABI used by Visual Studio, and the GNU ABI used by the GCC toolchain.-->
Windows上では、Visual Studioで使用されるネイティブ（MSVC）ABIと、GCCツールチェーンで使用されるGNU ABIの2つの著名なABIが使用されています。
<!--Which version of Rust you need depends largely on what C/C++ libraries you want to interoperate with: for interop with software produced by Visual Studio use the MSVC build of Rust;-->
あなたが必要とするRustのバージョンは、相互運用するC / C ++ライブラリの大部分によって異なります。Visual Studioで作成されたソフトウェアとの相互運用には、RustのMSVCビルドを使用します。
<!--for interop with GNU software built using the MinGW/MSYS2 toolchain use the GNU build.-->
MinGW / MSYS2ツールチェーンを使用して構築されたGNUソフトウェアとの相互運用性については、GNUビルドを使用してください。

#### <!--MinGW--> MinGW
[windows-mingw]: #windows-mingw

<!--[MSYS2][msys2] can be used to easily build Rust on Windows:-->
[MSYS2][msys2]を使用すると、Windowsで簡単にRustを構築できます。

[msys2]: https://msys2.github.io/

1. <!--Grab the latest [MSYS2 installer][msys2] and go through the installer.-->
    最新の[MSYS2インストーラ][msys2]を[取得][msys2]し、インストーラを実行します。

2. <!--Run `mingw32_shell.bat` or `mingw64_shell.bat` from wherever you installed MSYS2 (ie `C:\msys64`), depending on whether you want 32-bit or 64-bit Rust.-->
    32ビットまたは64ビットの錆を必要とするかどうかに応じて、`mingw32_shell.bat`または`mingw64_shell.bat`をインストールした場所（つまり`C:\msys64`）から実行します。
<!--(As of the latest version of MSYS2 you have to run `msys2_shell.cmd -mingw32` or `msys2_shell.cmd -mingw64` from the command line instead)-->
    （MSYS2の最新バージョンでは、代わりに`msys2_shell.cmd -mingw32`または`msys2_shell.cmd -mingw64`をコマンドラインから実行する必要があります）

3. <!--From this terminal, install the required tools:-->
    この端末から、必要なツールをインストールします。

<!--` ``sh # Update package mirrors (may be needed if you have a fresh install of MSYS2) $ pacman -Sy pacman-mirrors # Install build tools needed for Rust. If you're building a 32-bit compiler, # then replace "x86_64" below with "i686". If you've already got git, python, # or CMake installed and in PATH you can remove them from this list. Note # that it is important that you do **not** use the 'python2' and 'cmake' # packages from the 'msys2' subsystem. The build has historically been known # to fail with these packages. $ pacman -S git \ make \ diffutils \ tar \ mingw-w64-x86_64-python2 \ mingw-w64-x86_64-cmake \ mingw-w64-x86_64-gcc``-->
` ``sh # Update package mirrors (may be needed if you have a fresh install of MSYS2) $ pacman -Sy pacman-mirrors # Install build tools needed for Rust. If you're building a 32-bit compiler, # then replace "x86_64" below with "i686". If you've already got git, python, # or CMake installed and in PATH you can remove them from this list. Note # that it is important that you do **not** use the 'python2' and 'cmake' # packages from the 'msys2' subsystem. The build has historically been known # to fail with these packages. $ pacman -S git \ make \ diffutils \ tar \ mingw-w64-x86_64-python2 \ mingw-w64-x86_64-cmake \ mingw-w64-x86_64-gcc``
``sh # Update package mirrors (may be needed if you have a fresh install of MSYS2) $ pacman -Sy pacman-mirrors # Install build tools needed for Rust. If you're building a 32-bit compiler, # then replace "x86_64" below with "i686". If you've already got git, python, # or CMake installed and in PATH you can remove them from this list. Note # that it is important that you do **not** use the 'python2' and 'cmake' # packages from the 'msys2' subsystem. The build has historically been known # to fail with these packages. $ pacman -S git \ make \ diffutils \ tar \ mingw-w64-x86_64-python2 \ mingw-w64-x86_64-cmake \ mingw-w64-x86_64-gcc`` <!--``sh # Update package mirrors (may be needed if you have a fresh install of MSYS2) $ pacman -Sy pacman-mirrors # Install build tools needed for Rust. If you're building a 32-bit compiler, # then replace "x86_64" below with "i686". If you've already got git, python, # or CMake installed and in PATH you can remove them from this list. Note # that it is important that you do **not** use the 'python2' and 'cmake' # packages from the 'msys2' subsystem. The build has historically been known # to fail with these packages. $ pacman -S git \ make \ diffutils \ tar \ mingw-w64-x86_64-python2 \ mingw-w64-x86_64-cmake \ mingw-w64-x86_64-gcc`` `-->
``sh # Update package mirrors (may be needed if you have a fresh install of MSYS2) $ pacman -Sy pacman-mirrors # Install build tools needed for Rust. If you're building a 32-bit compiler, # then replace "x86_64" below with "i686". If you've already got git, python, # or CMake installed and in PATH you can remove them from this list. Note # that it is important that you do **not** use the 'python2' and 'cmake' # packages from the 'msys2' subsystem. The build has historically been known # to fail with these packages. $ pacman -S git \ make \ diffutils \ tar \ mingw-w64-x86_64-python2 \ mingw-w64-x86_64-cmake \ mingw-w64-x86_64-gcc`` `

4. <!--Navigate to Rust's source code (or clone it), then build it:-->
    Rustのソースコードに移動し（またはクローンして）、ビルドします。

<!--` ``sh $ ./x.py build && ./x.py install`` `-->
` ``sh $ ./x.py build && ./x.py install``

#### <!--MSVC--> MSVC
[windows-msvc]: #windows-msvc

<!--MSVC builds of Rust additionally require an installation of Visual Studio 2013 (or later) so `rustc` can use its linker.-->
RustのMSVCビルドでは、Visual Studio 2013（またはそれ以降）をインストールする必要があります。そのため、`rustc`はリンカーを使用できます。
<!--Make sure to check the “C++ tools” option.-->
"C ++ tools"オプションを確認してください。

<!--With these dependencies installed, you can build the compiler in a `cmd.exe` shell with:-->
これらの依存関係がインストールされていると、`cmd.exe`シェルでコンパイラをビルドできます。

```sh
> python x.py build
```

<!--Currently, building Rust only works with some known versions of Visual Studio.-->
現在、Rustのビルドは、Visual Studioの既知のバージョンでのみ動作します。
<!--If you have a more recent version installed the build system doesn't understand then you may need to force rustbuild to use an older version.-->
より新しいバージョンがインストールされている場合は、ビルドシステムが理解できないため、古いバージョンを使用するようにrustbuildに強制する必要があるかもしれません。
<!--This can be done by manually calling the appropriate vcvars file before running the bootstrap.-->
これは、ブートストラップを実行する前に、適切なvcvarsファイルを手動で呼び出して行うことができます。

```
CALL "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"
python x.py build
```

#### <!--Specifying an ABI--> ABIの指定
[specifying-an-abi]: #specifying-an-abi

<!--Each specific ABI can also be used from either environment (for example, using the GNU ABI in PowerShell) by using an explicit build triple.-->
各特定のABIは、明示的なビルドトリプルを使用して、どちらの環境（たとえば、PowerShellのGNU ABIを使用）からでも使用できます。
<!--The available Windows build triples are: -GNU ABI (using GCC) -`i686-pc-windows-gnu` -`x86_64-pc-windows-gnu` -The MSVC ABI -`i686-pc-windows-msvc` -`x86_64-pc-windows-msvc`-->
-GNU ABI（GCCを使用）-`i686-pc-windows-gnu` -`x86_64-pc-windows-gnu` -MSVC ABI-`i686-pc-windows-msvc` -`x86_64-pc-windows-msvc`

<!--The build triple can be specified by either specifying `--build=<triple>` when invoking `x.py` commands, or by copying the `config.toml` file (as described in Building From Source), and modifying the `build` option under the `[build]` section.-->
ビルドトリプルは、`x.py`コマンドを呼び出すときに`--build=<triple>`を指定するか、`config.toml`ファイルをコピーして（`build`元で説明されているように）、`build`オプションを`[build]`セクション。

### <!--Configure and Make--> 設定と作成
[configure-and-make]: #configure-and-make

<!--While it's not the recommended build system, this project also provides a configure script and makefile (the latter of which just invokes `x.py`).-->
推奨されるビルドシステムではありませんが、このプロジェクトではconfigureスクリプトとmakefileも提供されています（後者は`x.py`起動するだけ`x.py`）。

```sh
$ ./configure
$ make && sudo make install
```

<!--When using the configure script, the generated `config.mk` file may override the `config.toml` file.-->
configureスクリプトを使用する場合、生成された`config.mk`ファイルは`config.toml`ファイルを上書きすることがあります。
<!--To go back to the `config.toml` file, delete the generated `config.mk` file.-->
`config.toml`ファイルに戻るには、生成された`config.mk`ファイルを削除します。

## <!--Building Documentation--> ドキュメントの作成
[building-documentation]: #building-documentation

<!--If you'd like to build the documentation, it's almost the same:-->
ドキュメントを作成したい場合は、ほぼ同じです。

```sh
$ ./x.py doc
```

<!--The generated documentation will appear under `doc` in the `build` directory for the ABI used.-->
生成された`doc`は、使用されているABIの`build`ディレクトリの`doc`下に表示されます。
<!--Ie, if the ABI was `x86_64-pc-windows-msvc`, the directory will be `build\x86_64-pc-windows-msvc\doc`.-->
つまり、ABIが`x86_64-pc-windows-msvc`場合、ディレクトリは`build\x86_64-pc-windows-msvc\doc`ます。

## <!--Notes--> ノート
[notes]: #notes

<!--Since the Rust compiler is written in Rust, it must be built by a precompiled "snapshot"version of itself (made in an earlier stage of development).-->
RustコンパイラはRustで書かれているので、コンパイル済みの "スナップショット"バージョン（開発の初期段階で作成されたもの）によって構築されなければなりません。
<!--As such, source builds require a connection to the Internet, to fetch snapshots, and an OS that can execute the available snapshot binaries.-->
そのため、ソースビルドには、インターネットへの接続、スナップショットの取得、および使用可能なスナップショットバイナリを実行できるOSが必要です。

<!--Snapshot binaries are currently built and tested on several platforms:-->
スナップショットバイナリは、現在、いくつかのプラットフォームで構築され、テストされています。

|<!--Platform / Architecture-->プラットフォーム/アーキテクチャ|<!--x86-->x86|<!--x86_64-->x86_64|
|<!------------------------------------>--------------------------------|<!--------->-----|<!------------>--------|
|<!--Windows (7, 8, Server 2008 R2)-->Windows（7,8、Server 2008 R2）|<!--✓-->✓|<!--✓-->✓|
|<!--Linux (2.6.18 or later)-->Linux（2.6.18以降）|<!--✓-->✓|<!--✓-->✓|
|<!--OSX (10.7 Lion or later)-->OSX（10.7 Lion以降）|<!--✓-->✓|<!--✓-->✓|

<!--You may find that other platforms work, but these are our officially supported build environments that are most likely to work.-->
他のプラットフォームも動作しているかもしれませんが、これらは正式にサポートされているビルド環境です。

<!--Rust currently needs between 600MiB and 1.5GiB of RAM to build, depending on platform.-->
Rustは現在、プラットフォームに応じて、600MiB〜1.5GiBのRAMを構築する必要があります。
<!--If it hits swap, it will take a very long time to build.-->
それがスワップに当たったら、ビルドするのに非常に時間がかかるでしょう。

<!--There is more advice about hacking on Rust in [CONTRIBUTING.md].-->
[CONTRIBUTING.md]にRustのハッキングに関するアドバイスがあります。

[CONTRIBUTING.md]: https://github.com/rust-lang/rust/blob/master/CONTRIBUTING.md

## <!--Getting Help--> ヘルプの利用
[getting-help]: #getting-help

<!--The Rust community congregates in a few places:-->
Rustコミュニティはいくつかの場所に集まります：

* <!--[Stack Overflow] -Direct questions about using the language.-->
   [Stack Overflow] -言語の使用に関する直接の質問。
* <!--[users.rust-lang.org] -General discussion and broader questions.-->
   [users.rust-lang.org] -一般的な議論とより幅広い質問。
* <!--[/r/rust] -News and general discussion.-->
   [/r/rust] -ニュースと一般的な議論。

<!--[Stack Overflow]: https://stackoverflow.com/questions/tagged/rust
 [/r/rust]: https://reddit.com/r/rust
 [users.rust-lang.org]: https://users.rust-lang.org/
-->
[Stack Overflow]: https://stackoverflow.com/questions/tagged/rust
 [/r/rust]: https://reddit.com/r/rust
 [users.rust-lang.org]: https://users.rust-lang.org/


## <!--Contributing--> 貢献する
[contributing]: #contributing

<!--To contribute to Rust, please see [CONTRIBUTING](CONTRIBUTING.md).-->
錆に貢献するには、以下を参照してください[CONTRIBUTING](CONTRIBUTING.md)。

<!--Rust has an [IRC] culture and most real-time collaboration happens in a variety of channels on Mozilla's IRC network, irc.mozilla.org.-->
Rustは[IRC]文化を持ち、ほとんどのリアルタイムコラボレーションはMozillaのIRCネットワーク、irc.mozilla.orgのさまざまなチャンネルで行われます。
<!--The most popular channel is [#rust], a venue for general discussion about Rust.-->
最も人気のあるチャンネルはRustに関する一般的な議論の場である[#rust]です。
<!--And a good place to ask for help would be [#rust-beginners].-->
そして助けを求める良い場所は、[#rust-beginners]でしょう。

<!--The [rustc guide] might be a good place to start if you want to find out how various parts of the compiler work.-->
[rustc guide]は、コンパイラのさまざまな部分がどのように動作しているかを知りたい場合には、良いスタート地点になるかもしれません。

<!--Also, you may find the [rustdocs for the compiler itself][rustdocs] useful.-->
また、[コンパイラ自体のrustdocsが][rustdocs]便利かもしれません。

<!--[IRC]: https://en.wikipedia.org/wiki/Internet_Relay_Chat
 [#rust]: irc://irc.mozilla.org/rust
 [#rust-beginners]: irc://irc.mozilla.org/rust-beginners
 [rustc guide]: https://rust-lang-nursery.github.io/rustc-guide/about-this-guide.html
 [rustdocs]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/
-->
[IRC]: https://en.wikipedia.org/wiki/Internet_Relay_Chat
 [#rust]: irc://irc.mozilla.org/rust
 [#rust-beginners]: irc://irc.mozilla.org/rust-beginners
 [rustc guide]: https://rust-lang-nursery.github.io/rustc-guide/about-this-guide.html
 [rustdocs]: https://doc.rust-lang.org/nightly/nightly-rustc/rustc/


## <!--License--> ライセンス
[license]: #license

<!--Rust is primarily distributed under the terms of both the MIT license and the Apache License (Version 2.0), with portions covered by various BSD-like licenses.-->
Rustは、主にMITライセンスとApache License（バージョン2.0）の両方の条件で配布され、その一部はさまざまなBSDライクなライセンスでカバーされています。

<!--See [LICENSE-APACHE](LICENSE-APACHE), [LICENSE-MIT](LICENSE-MIT), and [COPYRIGHT](COPYRIGHT) for details.-->
詳細については、[LICENSE-APACHE](LICENSE-APACHE)、 [LICENSE-MIT](LICENSE-MIT)、および[COPYRIGHT](COPYRIGHT)を参照してください。
