# <!--Type safety--> タイプセーフティ


<span id="c-newtype"></span><!--## Newtypes provide static distinctions (C-NEWTYPE)-->
##新しいタイプは静的な区別を提供します（C-NEWTYPE）

<!--Newtypes can statically distinguish between different interpretations of an underlying type.-->
Newtypeは、基礎となる型の異なる解釈を静的に区別できます。

<!--For example, a `f64` value might be used to represent a quantity in miles or in kilometers.-->
たとえば、`f64`値を使用して数量をマイルまたはキロメートルで表すことができます。
<!--Using newtypes, we can keep track of the intended interpretation:-->
newtypesを使って、意図した解釈を追跡することができます：

```rust
struct Miles(pub f64);
struct Kilometers(pub f64);

impl Miles {
    fn to_kilometers(self) -> Kilometers { /* ... */ }
}
impl Kilometers {
    fn to_miles(self) -> Miles { /* ... */ }
}
```

<!--Once we have separated these two types, we can statically ensure that we do not confuse them.-->
これらの2つのタイプを分離したら、それらを混同しないように静的に確認できます。
<!--For example, the function-->
例えば、関数

```rust
fn are_we_there_yet(distance_travelled: Miles) -> bool { /* ... */ }
```

<!--cannot accidentally be called with a `Kilometers` value.-->
誤って`Kilometers`値で呼び出すことはできません。
<!--The compiler will remind us to perform the conversion, thus averting certain [catastrophic bugs].-->
コンパイラは、変換を実行するように私たちに思い出させ、特定の[catastrophic bugs]を回避します。

[catastrophic bugs]: http://en.wikipedia.org/wiki/Mars_Climate_Orbiter


<span id="c-custom-type"></span><!--## Arguments convey meaning through types, not `bool` or `Option` (C-CUSTOM-TYPE)-->
##引数は、`bool`や`Option`（C-CUSTOM-TYPE）ではなく、型を通して意味を伝えます。

<!--Prefer-->
好む

```rust
let w = Widget::new(Small, Round)
```

<!--over-->
以上

```rust
let w = Widget::new(true, false)
```

<!--Core types like `bool`, `u8` and `Option` have many possible interpretations.-->
`bool`、 `u8`、 `Option`などのコアタイプには多くの解釈があります。

<!--Use a deliberate type (whether enum, struct, or tuple) to convey interpretation and invariants.-->
解釈と不変量を伝えるには、意図的な型（enum、struct、またはtuple）を使用します。
<!--In the above example, it is not immediately clear what `true` and `false` are conveying without looking up the argument names, but `Small` and `Round` are more suggestive.-->
上記の例では、引数の名前を調べずに`true`と`false`が何を伝えているかがすぐには分かりませんが、`Small`と`Round`はより示唆的です。

<!--Using custom types makes it easier to expand the options later on, for example by adding an `ExtraLarge` variant.-->
カスタムタイプを使用すると、`ExtraLarge`バリアントを追加するなど、後でオプションを簡単に拡張することができます。

<!--See the newtype pattern ([C-NEWTYPE]) for a no-cost way to wrap existing types with a distinguished name.-->
既存の型を識別名でラップする無償の方法については、newtypeパターン（[C-NEWTYPE]）を参照してください。

[C-NEWTYPE]: #c-newtype


<span id="c-bitflag"></span><!--## Types for a set of flags are `bitflags`, not enums (C-BITFLAG)-->
##フラグセットの型は、`bitflags`フラグ、enum（C-BITFLAG）ではなく、

<!--Rust supports `enum` types with explicitly specified discriminants:-->
Rustは明示的に指定された判別式を持つ`enum`型をサポートしています：

```rust
enum Color {
    Red = 0xff0000,
    Green = 0x00ff00,
    Blue = 0x0000ff,
}
```

<!--Custom discriminants are useful when an `enum` type needs to be serialized to an integer value compatibly with some other system/language.-->
カスタム判別式は、`enum`型を他のシステム/言語と互換性のある整数値にシリアル化する必要がある場合に便利です。
<!--They support "typesafe"APIs: by taking a `Color`, rather than an integer, a function is guaranteed to get well-formed inputs, even if it later views those inputs as integers.-->
彼らは「型保証」APIをサポートしています。整数ではなく`Color`をとることによって、後で整数として整数を表示しても、関数は正しい形式の入力を得ることが保証されます。

<!--An `enum` allows an API to request exactly one choice from among many.-->
`enum`使用すると、APIは多数の中から1つの選択肢だけを要求できます。
<!--Sometimes an API's input is instead the presence or absence of a set of flags.-->
時には、APIの入力は、フラグのセットの有無です。
<!--In C code, this is often done by having each flag correspond to a particular bit, allowing a single integer to represent, say, 32 or 64 flags.-->
Cコードでは、これは、各フラグを特定のビットに対応させることによって行われることが多く、単一の整数、例えば32または64フラグを表すことができます。
<!--Rust's [`bitflags`] crate provides a typesafe representation of this pattern.-->
Rustの[`bitflags`]はこのパターンの型保証表現を提供します。

[`bitflags`]: https://github.com/rust-lang-nursery/bitflags

```rust
#[macro_use]
extern crate bitflags;

bitflags! {
    struct Flags: u32 {
        const FLAG_A = 0b00000001;
        const FLAG_B = 0b00000010;
        const FLAG_C = 0b00000100;
    }
}

fn f(settings: Flags) {
    if settings.contains(Flags::FLAG_A) {
        println!("doing thing A");
    }
    if settings.contains(Flags::FLAG_B) {
        println!("doing thing B");
    }
    if settings.contains(Flags::FLAG_C) {
        println!("doing thing C");
    }
}

fn main() {
    f(Flags::FLAG_A | Flags::FLAG_C);
}
```


<span id="c-builder"></span><!--## Builders enable construction of complex values (C-BUILDER)-->
##ビルダーは複雑な値の構築を可能にする（C-BUILDER）

<!--Some data structures are complicated to construct, due to their construction needing:-->
いくつかのデータ構造は、構築が必要なため、構築が複雑です。

* <!--a large number of inputs-->
   多数の入力
* <!--compound data (eg slices)-->
   複合データ（例えばスライス）
* <!--optional configuration data-->
   オプションの構成データ
* <!--choice between several flavors-->
   いくつかの味の間の選択

<!--which can easily lead to a large number of distinct constructors with many arguments each.-->
それぞれ多数の引数を持つ多数の異なるコンストラクタに簡単につながる可能性があります。

<!--If `T` is such a data structure, consider introducing a `T`  _builder_ :-->
`T`がそのようなデータ構造である場合は、`T`  _ビルダーの_ 導入を検討してください。

1. <!--Introduce a separate data type `TBuilder` for incrementally configuring a `T` value.-->
    `T`値を段階的に構成するための別個のデータ型`TBuilder`を導入する。
<!--When possible, choose a better name: eg [`Command`] is the builder for a [child process], [`Url`] can be created from a [`ParseOptions`].-->
    可能な場合は、より良い名前を選択します。例えば[`Command`]のためのビルダーである[child process]、 [`Url`]から作成することができます[`ParseOptions`]。
2. <!--The builder constructor should take as parameters only the data  _required_  to make a `T`.-->
    ビルダコンストラクタは、`T`を作るために _必要な_ データだけをパラメータとして取る必要があります。
3. <!--The builder should offer a suite of convenient methods for configuration, including setting up compound inputs (like slices) incrementally.-->
    ビルダーは、複雑な入力（スライスなど）を徐々に設定するなど、便利な設定方法を提供する必要があります。
<!--These methods should return `self` to allow chaining.-->
    これらのメソッドは連鎖を可能にするために`self`を返すべきです。
4. <!--The builder should provide one or more " _terminal_  "methods for actually building a `T`.-->
    ビルダーは、実際に`T`構築するための1つ以上の「  _端末_  」メソッドを提供する必要があります。

<!--[`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [child process]: https://doc.rust-lang.org/std/process/struct.Child.html
 [`Url`]: https://docs.rs/url/1.4.0/url/struct.Url.html
 [`ParseOptions`]: https://docs.rs/url/1.4.0/url/struct.ParseOptions.html
-->
[`Command`]: https://doc.rust-lang.org/std/process/struct.Command.html
 [child process]: https://doc.rust-lang.org/std/process/struct.Child.html
 [`Url`]: https://docs.rs/url/1.4.0/url/struct.Url.html
 [`ParseOptions`]: https://docs.rs/url/1.4.0/url/struct.ParseOptions.html


<!--The builder pattern is especially appropriate when building a `T` involves side effects, such as spawning a task or launching a process.-->
ビルダーパターンは、`T`を構築する際に、タスクの生成やプロセスの起動などの副作用がある場合に特に適しています。

<!--In Rust, there are two variants of the builder pattern, differing in the treatment of ownership, as described below.-->
Rustには、以下に説明するように、所有者の扱いが異なる建築パターンの2つのバリアントがあります。

### <!--Non-consuming builders (preferred)--> 非消費ビルダー（推奨）

<!--In some cases, constructing the final `T` does not require the builder itself to be consumed.-->
場合によっては、最終`T`構築する際に、ビルダー自体を消費する必要はありません。
<!--The following variant on [`std::process::Command`] is one example:-->
[`std::process::Command`]の次の亜種が一例です：

[`std::process::Command`]: https://doc.rust-lang.org/std/process/struct.Command.html

```rust
#// NOTE: the actual Command API does not use owned Strings;
#// this is a simplified version.
// 注：実際のCommand APIは所有されているStringを使用しません。これは単純化されたバージョンです。

pub struct Command {
    program: String,
    args: Vec<String>,
    cwd: Option<String>,
#    // etc
    // 等
}

impl Command {
    pub fn new(program: String) -> Command {
        Command {
            program: program,
            args: Vec::new(),
            cwd: None,
        }
    }

#//    /// Add an argument to pass to the program.
    /// プログラムに渡す引数を追加します。
    pub fn arg(&mut self, arg: String) -> &mut Command {
        self.args.push(arg);
        self
    }

#//    /// Add multiple arguments to pass to the program.
    /// 複数の引数を追加してプログラムに渡します。
    pub fn args(&mut self, args: &[String]) -> &mut Command {
        self.args.extend_from_slice(args);
        self
    }

#//    /// Set the working directory for the child process.
    /// 子プロセスの作業ディレクトリを設定します。
    pub fn current_dir(&mut self, dir: String) -> &mut Command {
        self.cwd = Some(dir);
        self
    }

#//    /// Executes the command as a child process, which is returned.
    /// 子プロセスとしてコマンドを実行し、それが返されます。
    pub fn spawn(&self) -> io::Result<Child> {
        /* ... */
    }
}
```

<!--Note that the `spawn` method, which actually uses the builder configuration to spawn a process, takes the builder by shared reference.-->
実際にビルダー構成を使用してプロセスを生成する`spawn`メソッドは、共有参照によってビルダーを取得することに注意してください。
<!--This is possible because spawning the process does not require ownership of the configuration data.-->
これは、プロセスの起動に構成データの所有権が必要ないため可能です。

<!--Because the terminal `spawn` method only needs a reference, the configuration methods take and return a mutable borrow of `self`.-->
端末の`spawn`メソッドは参照のみを必要と`spawn`ため、設定メソッドは`self`可変的な借用を受け取り返します。

#### <!--The benefit--> 利益

<!--By using borrows throughout, `Command` can be used conveniently for both one-liner and more complex constructions:-->
全体を通して借用を使用することにより、`Command`は1ライナーとより複雑な構成の両方に便利に使用できます。

```rust
#// One-liners
// ワンライナー
Command::new("/bin/cat").arg("file.txt").spawn();

#// Complex configuration
// 複雑な構成
let mut cmd = Command::new("/bin/ls");
cmd.arg(".");
if size_sorted {
    cmd.arg("-S");
}
cmd.spawn();
```

### <!--Consuming builders--> 消費者ビルダー

<!--Sometimes builders must transfer ownership when constructing the final type `T`, meaning that the terminal methods must take `self` rather than `&self`.-->
ビルダーは最終的な型`T`構築するときに所有権を移譲する必要があります。つまり、端末のメソッドは`&self`ではなく`self`とる必要があります。

```rust
impl TaskBuilder {
#//    /// Name the task-to-be.
    /// タスクの名前を指定します。
    pub fn named(mut self, name: String) -> TaskBuilder {
        self.name = Some(name);
        self
    }

#//    /// Redirect task-local stdout.
    /// タスクローカルstdoutをリダイレクトします。
    pub fn stdout(mut self, stdout: Box<io::Write + Send>) -> TaskBuilder {
        self.stdout = Some(stdout);
        self
    }

#//    /// Creates and executes a new child task.
    /// 新しい子タスクを作成して実行します。
    pub fn spawn<F>(self, f: F) where F: FnOnce() + Send {
        /* ... */
    }
}
```

<!--Here, the `stdout` configuration involves passing ownership of an `io::Write`, which must be transferred to the task upon construction (in `spawn`).-->
ここでは、`stdout`設定には`io::Write`所有権が渡されますが、これは構築時に（`spawn`）タスクに転送する必要があります。

<!--When the terminal methods of the builder require ownership, there is a basic tradeoff:-->
ビルダーの端末メソッドに所有権が必要な場合、基本的なトレードオフがあります。

* <!--If the other builder methods take/return a mutable borrow, the complex configuration case will work well, but one-liner configuration becomes impossible.-->
   他のビルダーメソッドが変更可能な借用を受け入れる/返す場合、複雑な構成の場合はうまくいくが、1ライナーの構成は不可能になる。

* <!--If the other builder methods take/return an owned `self`, one-liners continue to work well but complex configuration is less convenient.-->
   他のビルダーメソッドが所有する`self`取得/返却する場合、1ライナーは引き続きうまく機能しますが、複雑な設定はあまり便利ではありません。

<!--Under the rubric of making easy things easy and hard things possible, all builder methods for a consuming builder should take and returned an owned `self`.-->
簡単なものを簡単に、難しいものにするというルーブリックの下で、消費するビルダーのためのすべてのビルダーメソッドは所有している`self`返すべきです。
<!--Then client code works as follows:-->
クライアントコードは次のように動作します。

```rust
#// One-liners
// ワンライナー
TaskBuilder::new("my_task").spawn(|| { /* ... */ });

#// Complex configuration
// 複雑な構成
let mut task = TaskBuilder::new();
#//task = task.named("my_task_2"); // must re-assign to retain ownership
task = task.named("my_task_2"); // 所有権を保持するために再割り当てする必要があります
if reroute {
    task = task.stdout(mywriter);
}
task.spawn(|| { /* ... */ });
```

<!--One-liners work as before, because ownership is threaded through each of the builder methods until being consumed by `spawn`.-->
1ライナーは以前と同じように動作し`spawn`。なぜなら、所有権は、 `spawn`によって消費されるまで、各ビルダーメソッドにスレッド化されているからです。
<!--Complex configuration, however, is more verbose: it requires re-assigning the builder at each step.-->
ただし、複雑な構成はより冗長です。ビルダーを各ステップで再割り当てする必要があります。
