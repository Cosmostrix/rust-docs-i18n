# <!--Method-call expressions--> メソッド呼び出し式

<!--A  _method call_  consists of an expression (the *receiver*) followed by a single dot, an [identifier], and a parenthesized expression-list.-->
 _メソッド呼び出し_ は、式（*受信者*）に続いて単一のドット、 [identifier]、およびカッコで囲まれた式リストから構成されます。
<!--Method calls are resolved to associated [methods] on specific traits, either statically dispatching to a method if the exact `self` -type of the left-hand-side is known, or dynamically dispatching if the left-hand-side expression is an indirect [trait object](types.html#trait-objects).-->
メソッド呼び出しは、特定の特性に関する関連[methods]に解決され[methods]左辺の正確な`self`型がわかっている場合は静的にメソッドにディスパッチされ、左辺の式が間接的な[特性オブジェクトで](types.html#trait-objects)あれば動的にディスパッチされ[ます](types.html#trait-objects)。

```rust
let pi: Result<f32, _> = "3.14".parse();
let log_pi = pi.unwrap_or(1.0).log(2.72);
# assert!(1.14 < log_pi && log_pi < 1.15)
```

<!--When looking up a method call, the receiver may be automatically dereferenced or borrowed in order to call a method.-->
メソッド呼び出しをルックアップするとき、メソッドを呼び出すためにレシーバが自動的に参照解除または借用されることがあります。
<!--This requires a more complex lookup process than for other functions, since there may be a number of possible methods to call.-->
これには、呼び出す可能性のあるメソッドが多数ある可能性があるため、他の関数よりも複雑なルックアップ処理が必要です。
<!--The following procedure is used:-->
次の手順が使用されます。

<!--The first step is to build a list of candidate receiver types.-->
最初のステップは、候補受信者タイプのリストを作成することです。
<!--Obtain these by repeatedly [dereferencing][dereference] the receiver expression's type, adding each type encountered to the list, then finally attempting an [unsized coercion] at the end, and adding the result type if that is successful.-->
受信者式のタイプを繰り返し[dereferencing][dereference]し、リストに出現した各タイプを追加し、最後に最後に[unsized coercion]を試行し、成功した場合は結果タイプを追加します。
<!--Then, for each candidate `T`, add `&T` and `&mut T` to the list immediately after `T`.-->
次に、各候補`T`について、`&T`と`&mut T`を`T`直後のリストに追加します。

<!--For instance, if the receiver has type `Box<[i32;2]>`, then the candidate types will be `Box<[i32;2]>`, `&Box<[i32;2]>`, `&mut Box<[i32;2]>`, `[i32; 2]`-->
たとえば、受信者が`Box<[i32;2]>`タイプの場合、候補タイプは`Box<[i32;2]>`、 `&Box<[i32;2]>` `&mut Box<[i32;2]>`、 `[i32; 2]`
<!--`[i32; 2]` (by dereferencing), `&[i32; 2]`-->
`[i32; 2]`（逆参照による）、 `&[i32; 2]`
<!--`&[i32; 2]`, `&mut [i32; 2]`-->
`&[i32; 2]`、 `&mut [i32; 2]`
<!--`&mut [i32; 2]`, `[i32]` (by unsized coercion), `&[i32]`, and finally `&mut [i32]`.-->
`&mut [i32; 2]`、 `[i32]`（unsized coercionによる）、`&[i32]`、最後に`&mut [i32]`。

<!--Then, for each candidate type `T`, search for a [visible] method with a receiver of that type in the following places:-->
次に、候補タイプ`T`ごとに、以下の場所にそのタイプの受信者を含む[visible]メソッドを検索します。

1. <!--`T` 's inherent methods (methods implemented directly on `T`).-->
    `T`の固有のメソッド（`T`直接実装されたメソッド）。
1. <!--Any of the methods provided by a [visible] trait implemented by `T`.-->
    `T`によって実装された[visible]的な形質によって提供される方法のいずれか。
<!--If `T` is a type parameter, methods provided by trait bounds on `T` are looked up first.-->
    場合`T`タイプパラメータである、上で形質境界によって提供される方法`T`最初に検索されます。
<!--Then all remaining methods in scope are looked up.-->
    スコープ内の残りのメソッドがすべて検索されます。

> <!--Note: the lookup is done for each type in order, which can occasionally lead to surprising results.-->
> 注：ルックアップは各タイプごとに順番に行われ、驚くべき結果につながることがあります。
> <!--The below code will print "In trait impl!", because `&self` methods are looked up first, the trait method is found before the struct's `&mut self` method is found.-->
> 以下のコードは、`&self`メソッドが最初に検索されるので、"trait impl！"と表示されます`&mut self`メソッドは、構造体の`&mut self`メソッドが見つかる前に見つけられます。
> 
> ```rust
> struct Foo {}
> 
> trait Bar {
>   fn bar(&self);
> }
> 
> impl Foo {
>   fn bar(&mut self) {
>     println!("In struct impl!")
>   }
> }
> 
> impl Bar for Foo {
>   fn bar(&self) {
>     println!("In trait impl!")
>   }
> }
> 
> fn main() {
>   let mut f = Foo{};
>   f.bar();
> }
> ```

<!--If this results in multiple possible candidates, then it is an error, and the receiver must be [converted][disambiguate%20call] to an appropriate receiver type to make the method call.-->
これが複数の可能性のある候補になる場合、それはエラーであり、受信者はメソッド呼び出しを行うために適切な受信者タイプに[converted][disambiguate%20call]れなければならない。

<!--This process does not take into account the mutability or lifetime of the receiver, or whether a method is `unsafe`.-->
このプロセスでは、レシーバの変更可能性やライフタイム、またはメソッドが`unsafe`かどうかは考慮されていませ`unsafe`。
<!--Once a method is looked up, if it can't be called for one (or more) of those reasons, the result is a compiler error.-->
メソッドが参照されると、その理由の1つ（またはそれ以上）が呼び出せない場合、結果はコンパイラエラーです。

<!--If a step is reached where there is more than one possible method, such as where generic methods or traits are considered the same, then it is a compiler error.-->
ジェネリックメソッドまたは特性が同じと見なされる場合など、複数の可能なメソッドがある場合は、コンパイラエラーです。
<!--These cases require a [disambiguating function call syntax] for method and function invocation.-->
これらのケースでは、メソッド呼び出しと関数呼び出しのための[disambiguating function call syntax]が必要です。

Div ("",["warning"],[]) [RawBlock (Format "html") "</p>",Plain [LineBreak],Para [Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "*",Space,Strong [Str "Warning:"],Space,Str "*",Space,Str "For",Space,Link ("",["notranslate"],[]) [Str "trait",Space,Str "objects"] ("#4trait%20objects",""),Space,Str ",",Space,Str "if",Space,Str "there",Space,Str "is",Space,Str "an",Space,Str "inherent",Space,Str "method",Space,Str "of",Space,Str "the",Space,Str "same",Space,Str "name",Space,Str "as",Space,Str "a",Space,Str "trait",Space,Str "method,",Space,Str "it",Space,Str "will",Space,Str "give",Space,Str "a",Space,Str "compiler",Space,Str "error",Space,Str "when",Space,Str "trying",Space,Str "to",Space,Str "call",Space,Str "the",Space,Str "method",Space,Str "in",Space,Str "a",Space,Str "method",Space,Str "call",Space,Str "expression."],Space,Str "*",Space,Strong [Str "\35686\21578\65306"],Space,Str "*",Space,Link ("",["notranslate"],[]) [Str "trait",Space,Str "objects"] ("#4trait%20objects",""),Str "\22580\21512\12289trait\12513\12477\12483\12489\12392\21516\12376\21517\21069\12398\22266\26377\12398\12513\12477\12483\12489\12364\12354\12427\22580\21512\12289\12513\12477\12483\12489\21628\12403\20986\12375\24335\12391\12513\12477\12483\12489\12434\21628\12403\20986\12381\12358\12392\12377\12427\12392\12467\12531\12497\12452\12521\12456\12521\12540\12364\30330\29983\12375\12414\12377\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "Instead,",Space,Str "you",Space,Str "can",Space,Str "call",Space,Str "the",Space,Str "method",Space,Str "using",Space,Link ("",["notranslate"],[]) [Str "disambiguating",Space,Str "function",Space,Str "call",Space,Str "syntax"] ("#4disambiguating%20function%20call%20syntax",""),Space,Str ",",Space,Str "in",Space,Str "which",Space,Str "case",Space,Str "it",Space,Str "calls",Space,Str "the",Space,Str "trait",Space,Str "method,",Space,Str "not",Space,Str "the",Space,Str "inherent",Space,Str "method."],Str "\20195\12431\12426\12395\12289",Space,Link ("",["notranslate"],[]) [Str "disambiguating",Space,Str "function",Space,Str "call",Space,Str "syntax"] ("#4disambiguating%20function%20call%20syntax",""),Str "\12434\20351\29992\12375\12390\12513\12477\12483\12489\12434\21628\12403\20986\12377\12371\12392\12364\12391\12365",Link ("",["notranslate"],[]) [Str "disambiguating",Space,Str "function",Space,Str "call",Space,Str "syntax"] ("#4disambiguating%20function%20call%20syntax",""),Space,Str "\12290\12371\12398\22580\21512\12289\22266\26377\12398\12513\12477\12483\12489\12391\12399\12394\12367trait\12513\12477\12483\12489\12364\21628\12403\20986\12373\12428\12414\12377\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "There",Space,Str "is",Space,Str "no",Space,Str "way",Space,Str "to",Space,Str "call",Space,Str "the",Space,Str "inherent",Space,Str "method."],Str "\22266\26377\12398\12513\12477\12483\12489\12434\21628\12403\20986\12377\26041\27861\12399\12354\12426\12414\12379\12435\12290"],Space,Span ("",["notranslate"],[("onmouseover","_tipon(this)"),("onmouseout","_tipoff()")]) [Span ("",["google-src-text"],[("style","direction: ltr; text-align: left")]) [Str "Just",Space,Str "don't",Space,Str "define",Space,Str "inherent",Space,Str "methods",Space,Str "on",Space,Str "trait",Space,Str "objects",Space,Str "with",Space,Str "the",Space,Str "same",Space,Str "name",Space,Str "a",Space,Str "trait",Space,Str "method",Space,Str "and",Space,Str "you'll",Space,Str "be",Space,Str "fine."],Str "\21516\12376\21517\21069\12398\24418\36074\12458\12502\12472\12455\12463\12488\12395\26412\36074\30340\12394\12513\12477\12483\12489\12434\23450\32681\12375\12394\12356\12391\12367\12384\12373\12356\12290\12371\12428\12399\29305\33394\12395\12394\12426\12414\12377\12290"]],Plain [LineBreak]]RawBlock (Format "html") "</p>"
<!--[IDENTIFIER]: identifiers.html
 [visible]: visibility-and-privacy.html
 [array]: types.html#array-and-slice-types
 [trait objects]: types.html#trait-objects
 [disambiguate call]: expressions/call-expr.html#disambiguating-function-calls
 [disambiguating function call syntax]: expressions/call-expr.html#disambiguating-function-calls
 [dereference]: expressions/operator-expr.html#the-dereference-operator
 [methods]: items/associated-items.html#methods
-->
[IDENTIFIER]: identifiers.html
 [visible]: visibility-and-privacy.html
 [array]: types.html#array-and-slice-types
 [trait objects]: types.html#trait-objects
 [disambiguate call]: expressions/call-expr.html#disambiguating-function-calls
 [disambiguating function call syntax]: expressions/call-expr.html#disambiguating-function-calls
 [dereference]: expressions/operator-expr.html#the-dereference-operator
 [methods]: items/associated-items.html#methods

