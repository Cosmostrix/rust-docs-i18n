# <!--The Rustonomicon--> Rustonomicon

#### <!--The Dark Arts of Advanced and Unsafe Rust Programming--> 高度で不安全な錆プログラミングのダークアーツ

# <!--NOTE: This is a draft document that discusses several unstable aspects of Rust, and may contain serious errors or outdated information.--> 注：これはRustのいくつかの不安定な側面について説明するドラフトドキュメントであり、深刻なエラーや古い情報が含まれている可能性があります。

> <!--Instead of the programs I had hoped for, there came only a shuddering blackness and ineffable loneliness;-->
> 私が望んでいたプログラムの代わりに、震えるような黒と寂しいほどの寂しさしかありませんでした。
> <!--and I saw at last a fearful truth which no one had ever dared to breathe before — the unwhisperable secret of secrets — The fact that this language of stone and stridor is not a sentient perpetuation of Rust as London is of Old London and Paris of Old Paris, but that it is in fact quite unsafe, its sprawling body imperfectly embalmed and infested with queer animate things which have nothing to do with it as it was in compilation.-->
> 私は最後に誰も息を呑んだことのない恐ろしい真実を見ました -秘密の秘密ではありえない秘密 -石と悲しみのこの言葉は、ロンドンが旧ロンドンと旧パリのパリのように錆の感覚的な永続化ではないという事実パリ、それは実際には非常に安全ではない、その広がった体は不完全に包まれていて、それが編集にあったようにそれと関係のない奇妙な生き生きとしたものに冒されています。

<!--This book digs into all the awful details that are necessary to understand in order to write correct Unsafe Rust programs.-->
この本は、正しいUnsafe Rustプログラムを書くために理解するのに必要なすべてのひどい詳細を掘り下げています。
<!--Due to the nature of this problem, it may lead to unleashing untold horrors that shatter your psyche into a billion infinitesimal fragments of despair.-->
この問題の性質上、あなたの精神を数十億の絶望的な絶望の断片に砕く恐ろしい未知の恐怖を引き起こす可能性があります。

<!--Should you wish a long and happy career of writing Rust programs, you should turn back now and forget you ever saw this book.-->
あなたが長くて幸せなRustプログラムを書くことを望むなら、あなたは今戻って、この本を見たことを忘れるべきです。
<!--It is not necessary.-->
それは必要ない。
<!--However if you intend to write unsafe code — or just want to dig into the guts of the language — this book contains lots of useful information.-->
しかし、あなたが安全でないコードを書こうと思っている -あるいは、言語の勇気を掘り下げたい -この本は多くの有益な情報を含んでいます。

<!--Unlike *[The Rust Programming Language][trpl]*, we will be assuming considerable prior knowledge.-->
*[The Rust Programming Language] [trpl]*とは異なり、我々はかなりの事前知識を前提としています。
<!--In particular, you should be comfortable with basic systems programming and Rust.-->
特に、基本的なシステムプログラミングとRustに慣れている必要があります。
<!--If you don't feel comfortable with these topics, you should consider [reading The Book][trpl] first.-->
これらのトピックに慣れていない場合は、まず[The Bookを読む][trpl]ことを検討する必要があります。
<!--That said, we won't assume you have read it, and we will take care to occasionally give a refresher on the basics where appropriate.-->
それは、あなたがそれを読んだことを前提にしておらず、必要に応じて基本的なことを時折見直すように気をつけます。
<!--You can skip straight to this book if you want;-->
あなたが望むなら、あなたはこの本をまっすぐにスキップすることができます。
<!--just know that we won't be explaining everything from the ground up.-->
私たちが一からすべてを説明するわけではないことを知っているだけです。

<!--We're going to dig into exception-safety, pointer aliasing, memory models, compiler and hardware implementation details, and even some type-theory.-->
例外安全性、ポインタエイリアシング、メモリモデル、コンパイラとハードウェアの実装の詳細、さらにはいくつかの型理論を掘り下げます。
<!--Much text will be devoted to exotic corner cases that no one *should* ever have to care about, but suddenly become important because we wrote `unsafe`.-->
多くのテキストは、誰も気にしては*いけ*ないエキゾチックなコーナーケースに費やされますが、私たちが`unsafe`と書いたので、突然重要になります。

<!--We will also be spending a lot of time talking about the different kinds of safety and guarantees that programs could care about.-->
また、プログラムが気にするさまざまな種類の安全性と保証について多くの時間を費やしています。

[trpl]: ../book/index.html
