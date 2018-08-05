# <!--Tokens--> トークン

<!--Tokens are primitive productions in the grammar defined by regular (non-recursive) languages.-->
トークンは、規則的な（非再帰的な）言語で定義された文法の原始的なプロダクションです。
<!--"Simple"tokens are given in [string table production] form, and occur in the rest of the grammar in `monospace` font.-->
"シンプル"トークンは[string table production]形式で与えられ、残りの文法では`monospace`フォントで現れます。
<!--Other tokens have exact rules given.-->
他のトークンには厳密な規則があります。

[string table production]: notation.html#string-table-productions

## <!--Literals--> リテラル

<!--A literal is an expression consisting of a single token, rather than a sequence of tokens, that immediately and directly denotes the value it evaluates to, rather than referring to it by name or some other evaluation rule.-->
リテラルは、名前やその他の評価規則で参照するのではなく、評価する値を直接的かつ直接的に示すトークンのシーケンスではなく、単一のトークンで構成される式です。
<!--A literal is a form of [constant expression](expressions.html#constant-expressions), so is evaluated (primarily) at compile time.-->
リテラルは[定数式の](expressions.html#constant-expressions)形式[な](expressions.html#constant-expressions)ので、コンパイル時に（主に）評価されます。

### <!--Examples--> 例

#### <!--Characters and strings--> 文字と文字列

| |<!--Example-->例|<!--`#` sets-->`#`セット|<!--Characters-->キャラクター|<!--Escapes-->エスケープ|
|<!-------------------------------------------------->----------------------------------------------|<!--------------------->-----------------|<!----------------->-------------|<!----------------->-------------|<!------------------------->---------------------|
|[Character](#character-literals)|`'H'`|<!--0-->0|<!--All Unicode-->すべてのUnicode|<!--[Quote](#quote-escapes) & [ASCII](#ascii-escapes) & [Unicode](#unicode-escapes)-->[Quote](#quote-escapes) ＆ [ASCII](#ascii-escapes) ＆ [Unicode](#unicode-escapes)|
|[String](#string-literals)|`"hello"`|<!--0-->0|<!--All Unicode-->すべてのUnicode|<!--[Quote](#quote-escapes) & [ASCII](#ascii-escapes) & [Unicode](#unicode-escapes)-->[Quote](#quote-escapes) ＆ [ASCII](#ascii-escapes) ＆ [Unicode](#unicode-escapes)|
|[Raw](#raw-string-literals)|`r#"hello"#`|<!--0 or more\*-->0以上\ *|<!--All Unicode-->すべてのUnicode|`N/A`|
|[Byte](#byte-literals)|`b'H'`|<!--0-->0|<!--All ASCII-->すべてのASCII|<!--[Quote](#quote-escapes) & [Byte](#byte-escapes)-->[Quote](#quote-escapes) ＆ [Byte](#byte-escapes)|
|<!--[Byte string](#byte-string-literals)-->[バイト列](#byte-string-literals)|`b"hello"`|<!--0-->0|<!--All ASCII-->すべてのASCII|<!--[Quote](#quote-escapes) & [Byte](#byte-escapes)-->[Quote](#quote-escapes) ＆ [Byte](#byte-escapes)|
|<!--[Raw byte string](#raw-byte-string-literals)-->[生のバイト文字列](#raw-byte-string-literals)|`br#"hello"#`|<!--0 or more\*-->0以上\ *|<!--All ASCII-->すべてのASCII|`N/A`|

<!--\* The number of `#` s on each side of the same literal must be equivalent-->
\ *同じリテラルの両側にある`#`の数は同等でなければなりません

#### <!--ASCII escapes--> ASCIIエスケープ

| |<!--Name-->名|
|<!------->---|<!---------->------|
|`\x41`|<!--7-bit character code (exactly 2 digits, up to 0x7F)-->7ビット文字コード（正確に2桁、0x7Fまで）|
|`\n`|<!--Newline-->改行|
|`\r`|<!--Carriage return-->キャリッジリターン|
|`\t`|<!--Tab-->タブ|
|`\\`|<!--Backslash-->バックスラッシュ|
|`\0`|<!--Null-->ヌル|

#### <!--Byte escapes--> バイトエスケープ

| |<!--Name-->名|
|<!------->---|<!---------->------|
|`\x7F`|<!--8-bit character code (exactly 2 digits)-->8ビット文字コード（正確に2桁）|
|`\n`|<!--Newline-->改行|
|`\r`|<!--Carriage return-->キャリッジリターン|
|`\t`|<!--Tab-->タブ|
|`\\`|<!--Backslash-->バックスラッシュ|
|`\0`|<!--Null-->ヌル|

#### <!--Unicode escapes--> Unicodeエスケープ

| |<!--Name-->名|
|<!------->---|<!---------->------|
|`\u{7FFF}`|<!--24-bit Unicode character code (up to 6 digits)-->24ビットのUnicode文字コード（最大6桁）|

#### <!--Quote escapes--> エスケープの引用

| |<!--Name-->名|
|<!------->---|<!---------->------|
|`\'`|<!--Single quote-->一重引用符|
|`\"`|<!--Double quote-->二重引用符|

#### <!--Numbers--> 数字

|<!--[Number literals](#number-literals) `*`-->[数値リテラル](#number-literals) `*`|<!--Example-->例|<!--Exponentiation-->累乗|<!--Suffixes-->接尾辞|
|<!-------------------------------------------->----------------------------------------|<!------------->---------|<!-------------------->----------------|<!-------------->----------|
|<!--Decimal integer-->10進整数|`98_222`|`N/A`|<!--Integer suffixes-->整数の接尾辞|
|<!--Hex integer-->16進整数|`0xff`|`N/A`|<!--Integer suffixes-->整数の接尾辞|
|<!--Octal integer-->オクタル整数|`0o77`|`N/A`|<!--Integer suffixes-->整数の接尾辞|
|<!--Binary integer-->2進整数|`0b1111_0000`|`N/A`|<!--Integer suffixes-->整数の接尾辞|
|<!--Floating-point-->浮動小数点|`123.0E+77`|`Optional`|<!--Floating-point suffixes-->浮動小数点接尾辞|

<!--`*` All number literals allow `_` as a visual separator: `1_234.0E+18f64`-->
`*`すべての数値リテラルで`_`をビジュアルセパレータとして使用できます： `1_234.0E+18f64`

#### <!--Suffixes--> 接尾辞

|<!--Integer-->整数|<!--Floating-point-->浮動小数点|
|<!------------->---------|<!-------------------->----------------|
|<!--`u8`, `i8`, `u16`, `i16`, `u32`, `i32`, `u64`, `i64`, `u128`, `i128`, `usize`, `isize`-->`u8`、 `i8`、 `u16`、 `i16`、 `u32`、 `i32`、 `u64`、 `i64`、 `u128`、 `i128`、 `usize`、 `isize`|<!--`f32`, `f64`-->`f32`、 `f64`|

### <!--Character and string literals--> 文字と文字列リテラル

#### <!--Character literals--> 文字リテラル

> <!--**<sup>Lexer</sup>** \ CHAR_LITERAL:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ CHAR_LITERAL：\＆nbsp;＆nbsp;
> <!--`'` (~ [`'` `\` \\n \\r \\t] | QUOTE_ESCAPE | ASCII_ESCAPE | UNICODE_ESCAPE) `'`-->
> `'`（〜 [`'` `\` \\n \\r \\t] | QUOTE_ESCAPE | ASCII_ESCAPE | UNICODE_ESCAPE）`'`
> 
> <!--QUOTE_ESCAPE:\ &nbsp;&nbsp;-->
> QUOTE_ESCAPE：\＆nbsp;＆nbsp;
> <!--`\'` |-->
> `\'` |
> `\"`
> <!--ASCII_ESCAPE:\ &nbsp;&nbsp;-->
> ASCII_ESCAPE：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`\x` OCT_DIGIT HEX_DIGIT\ &nbsp;&nbsp;-->
> `\x` OCT_DIGIT HEX_DIGIT \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`\n` |-->
> `\n` |
> <!--`\r` |-->
> `\r` |
> <!--`\t` |-->
> `\t` |
> <!--`\\` |-->
> `\\` |
> `\0`
> <!--UNICODE_ESCAPE:\ &nbsp;&nbsp;-->
> UNICODE_ESCAPE：\＆nbsp;＆nbsp;
> <!--`\u{` (HEX_DIGIT `_`  __\*__ )  __1..6__  `}`-->
> `\u{`（HEX_DIGIT `_`  __\ *__ ）  __1..6__  `}`

<!--A  _character literal_  is a single Unicode character enclosed within two `U+0027` (single-quote) characters, with the exception of `U+0027` itself, which must be  _escaped_  by a preceding `U+005C` character (`\`).-->
 _文字リテラル_ は、2つの`U+0027`（一重引用符）文字で囲まれた単一のUnicode文字です（ `U+0027`自体を除く）。前の`U+005C`文字（`\`）で _エスケープ_ する必要があります。

#### <!--String literals--> 文字列リテラル

> <!--**<sup>Lexer</sup>** \ STRING_LITERAL:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ STRING_LITERAL：\＆nbsp;＆nbsp;
> <!--`"` (\ &nbsp;&nbsp; &nbsp;&nbsp; ~ [`"` `\` _IsolatedCR_] \ &nbsp;&nbsp; &nbsp;&nbsp; | QUOTE_ESCAPE\ &nbsp;&nbsp; &nbsp;&nbsp; | ASCII_ESCAPE\ &nbsp;&nbsp; &nbsp;&nbsp; | UNICODE_ESCAPE\ &nbsp;&nbsp; &nbsp;&nbsp; | STRING_CONTINUE\ &nbsp;&nbsp;)  __\*__  `"`-->
> `"`（\＆nbsp;＆nbsp;＆nbsp;＆nbsp;〜 [`"` `\` _IsolatedCR_] \＆nbsp;＆nbsp;＆nbsp;＆nbsp; | QUOTE_ESCAPE \＆nbsp;＆nbsp;＆nbsp;＆nbsp; | ASCII_ESCAPE \＆nbsp;＆nbsp;＆nbsp;＆nbsp; | UNICODE_ESCAPE \＆nbsp;＆nbsp;＆nbsp;＆nbsp; | STRING_CONTINUE \＆nbsp;＆nbsp;） __\ *__  `"`
> 
> <!--STRING_CONTINUE:\ &nbsp;&nbsp;-->
> STRING_CONTINUE：\＆nbsp;＆nbsp;
> <!--`\`  _followed by_  \\n-->
> `\`  _続いて_  \\ n

<!--A  _string literal_  is a sequence of any Unicode characters enclosed within two `U+0022` (double-quote) characters, with the exception of `U+0022` itself, which must be  _escaped_  by a preceding `U+005C` character (`\`).-->
 _文字列リテラル_ は、`U+005C`文字（`\`）で _エスケープ_ しなければならない`U+0022`自体を除いて、2つの`U+0022`（二重引用符）文字で囲まれた任意のUnicode文字のシーケンスです。

<!--Line-break characters are allowed in string literals.-->
改行文字は文字列リテラルで使用できます。
<!--Normally they represent themselves (ie no translation), but as a special exception, when an unescaped `U+005C` character (`\`) occurs immediately before the newline (`U+000A`), the `U+005C` character, the newline, and all whitespace at the beginning of the next line are ignored.-->
通常、それらは自分自身を表現します（つまり、翻訳はしません）が、特別な例外として、改行（`U+000A`）の直前にエスケープされていない`U+005C`文字（`\`）、 `U+005C`文字、改行、次の行の先頭は無視されます。
<!--Thus `a` and `b` are equal:-->
したがって`a`と`b`は等しい。

```rust
let a = "foobar";
let b = "foo\
         bar";

assert_eq!(a,b);
```

#### <!--Character escapes--> 文字エスケープ

<!--Some additional  _escapes_  are available in either character or non-raw string literals.-->
追加の _エスケープ_ は、文字列リテラルでも文字列でも使用できます。
<!--An escape starts with a `U+005C` (`\`) and continues with one of the following forms:-->
エスケープは`U+005C`（ `\`）で始まり、次のいずれかの形式で続行されます。

* <!--A  _7-bit code point escape_  starts with `U+0078` (`x`) and is followed by exactly two  _hex digits_  with value up to `0x7F`.-->
    _7ビットコードポイントのエスケープ_ は`U+0078`（ `x`）で始まり、 `0x7F`までの値を持つ正確に2  _桁の16進数_ が続きます。
<!--It denotes the ASCII character with value equal to the provided hex value.-->
   これは、指定された16進値と等しい値を持つASCII文字を示します。
<!--Higher values are not permitted because it is ambiguous whether they mean Unicode code points or byte values.-->
   より高い値はUnicodeコードポイントを意味するのかバイト値を示すのかが曖昧であるため許可されません。
* <!--A  _24-bit code point escape_  starts with `U+0075` (`u`) and is followed by up to six  _hex digits_  surrounded by braces `U+007B` (`{`) and `U+007D` (`}`).-->
    _24ビットコードポイントのエスケープ_ は、`U+0075`（ `u`）で始まり、 `U+007B`（ `{`）および`U+007D`（ `}`）で囲まれた6  _桁の16進数_ が続きます。
<!--It denotes the Unicode code point equal to the provided hex value.-->
   これは、指定された16進値に等しいUnicodeコードポイントを示します。
* <!--A  _whitespace escape_  is one of the characters `U+006E` (`n`), `U+0072` (`r`), or `U+0074` (`t`), denoting the Unicode values `U+000A` (LF), `U+000D` (CR) or `U+0009` (HT) respectively.-->
    _空白エスケープ文字_ の一つである`U+006E`（ `n`）、 `U+0072`（ `r`）、または`U+0074`（ `t`ユニコード値表す）`U+000A`（LF）、 `U+000D`（CR）または`U+0009`（HT）と呼ばれる。
* <!--The  _null escape_  is the character `U+0030` (`0`) and denotes the Unicode value `U+0000` (NUL).-->
    _nullエスケープ_ は`U+0030`（ `0`）の文字で、Unicode値`U+0000`（NUL）を示します。
* <!--The  _backslash escape_  is the character `U+005C` (`\`) which must be escaped in order to denote itself.-->
    _バックスラッシュのエスケープ_ 文字`U+005C`（ `\`）は、それ自体を示すためにエスケープする必要があります。

#### <!--Raw string literals--> 生の文字列リテラル

> <!--**<sup>Lexer</sup>** \ RAW_STRING_LITERAL:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ RAW_STRING_LITERAL：\＆nbsp;＆nbsp;
> <!--`r` RAW_STRING_CONTENT-->
> `r` RAW_STRING_CONTENT
> 
> <!--RAW_STRING_CONTENT:\ &nbsp;&nbsp;-->
> RAW_STRING_CONTENT：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`"` (~  _IsolatedCR_ )  __* (non-greedy)__  `"` \ &nbsp;&nbsp;-->
> `"`（  _〜IsolatedCR_ ）  __*（貪欲でない）__  `"` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`#` RAW_STRING_CONTENT `#`-->
> `#` RAW_STRING_CONTENT `#`

<!--Raw string literals do not process any escapes.-->
生の文字列リテラルはエスケープを処理しません。
<!--They start with the character `U+0072` (`r`), followed by zero or more of the character `U+0023` (`#`) and a `U+0022` (double-quote) character.-->
それらは文字`U+0072`（ `r`）で始まり、0以上の文字`U+0023`（ `#`）と`U+0022`（二重引用符）の文字が続きます。
<!--The  _raw string body_  can contain any sequence of Unicode characters and is terminated only by another `U+0022` (double-quote) character, followed by the same number of `U+0023` (`#`) characters that preceded the opening `U+0022` (double-quote) character.-->
 _生の文字列本体には、Unicode_ 文字の任意のシーケンスを含めることができ、唯一の別によって終了される`U+0022`の同じ番号が続く（二重引用符）文字、`U+0023`（ `#`開口部の前）の文字`U+0022`（ダブルを引用符）の文字。

<!--All Unicode characters contained in the raw string body represent themselves, the characters `U+0022` (double-quote) (except when followed by at least as many `U+0023` (`#`) characters as were used to start the raw string literal) or `U+005C` (`\`) do not have any special meaning.-->
生の文字列本体に含まれるすべてのUnicode文字は文字そのものを表す`U+0022`（二重引用符（）が続く場合を除き、少なくとも同数の`U+0023`（ `#`）文字リテラル生の文字列を開始するために使用されたもの）または`U+005C`（ `\`）は特別な意味を持ちません。

<!--Examples for string literals:-->
文字列リテラルの例：

```rust
#//"foo"; r"foo";                     // foo
"foo"; r"foo";                     //  foo
#//"\"foo\""; r#""foo""#;             // "foo"
"\"foo\""; r#""foo""#;             //  "foo"

"foo #\"# bar";
#//r##"foo #"# bar"##;                // foo #"# bar
r##"foo #"# bar"##;                //  foo＃ "＃bar

#//"\x52"; "R"; r"R";                 // R
"\x52"; "R"; r"R";                 //  R
#//"\\x52"; r"\x52";                  // \x52
"\\x52"; r"\x52";                  //  \ x52
```

### <!--Byte and byte string literals--> バイト文字列リテラルとバイト文字列リテラル

#### <!--Byte literals--> バイトリテラル

> <!--**<sup>Lexer</sup>** \ BYTE_LITERAL:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ BYTE_LITERAL：\＆nbsp;＆nbsp;
> <!--`b'` (ASCII_FOR_CHAR | BYTE_ESCAPE) `'`-->
> `b'`（ASCII_FOR_CHAR | BYTE_ESCAPE）`'`
> 
> <!--ASCII_FOR_CHAR:\ &nbsp;&nbsp;-->
> ASCII_FOR_CHAR：\＆nbsp;＆nbsp;
> <!-- _any ASCII (ie 0x00 to 0x7F), except_  `'`, `\`, \\n, \\r or \\t-->
> `'`、 `\`、\\ n、\\ rまたは\\ t  _を除く任意のASCII（0x00から0x7F）_ 
> 
> <!--BYTE_ESCAPE:\ &nbsp;&nbsp;-->
> BYTE_ESCAPE：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`\x` HEX_DIGIT HEX_DIGIT\ &nbsp;&nbsp;-->
> `\x` HEX_DIGIT HEX_DIGIT \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`\n` |-->
> `\n` |
> <!--`\r` |-->
> `\r` |
> <!--`\t` |-->
> `\t` |
> <!--`\\` |-->
> `\\` |
> `\0`

<!--A  _byte literal_  is a single ASCII character (in the `U+0000` to `U+007F` range) or a single  _escape_  preceded by the characters `U+0062` (`b`) and `U+0027` (single-quote), and followed by the character `U+0027`.-->
 _リテラルバイトは、（_ 単一のASCII文字である`U+0000`に`U+007F`範囲）、または文字によって先行シングル _エスケープ_  `U+0062`（ `b`）と`U+0027`（単一引用符）、および文字が続く`U+0027`。
<!--If the character `U+0027` is present within the literal, it must be  _escaped_  by a preceding `U+005C` (`\`) character.-->
文字`U+0027`がリテラル内に存在する場合は、前の`U+005C`（ `\`）文字で _エスケープ_ する必要があります。
<!--It is equivalent to a `u8` unsigned 8-bit integer  _number literal_ .-->
これは、と等価である`u8`  _リテラル_ 符号なし8ビット _整数_ 。

#### <!--Byte string literals--> バイト文字列リテラル

> <!--**<sup>Lexer</sup>** \ BYTE_STRING_LITERAL:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ BYTE_STRING_LITERAL：\＆nbsp;＆nbsp;
> <!--`b"` (ASCII_FOR_STRING | BYTE_ESCAPE | STRING_CONTINUE)  __\*__  `"`-->
> `b"`（ASCII_FOR_STRING | BYTE_ESCAPE | STRING_CONTINUE） __\ *__  `"`
> 
> <!--ASCII_FOR_STRING:\ &nbsp;&nbsp;-->
> ASCII_FOR_STRING：\＆nbsp;＆nbsp;
> <!-- _any ASCII (ie 0x00 to 0x7F), except_  `"`, `\`  _and IsolatedCR_ -->
> `"`、 `\`  _およびIsolatedCR_   _を除く任意のASCII（すなわち、0x00から0x7F）_ 

<!--A non-raw  _byte string literal_  is a sequence of ASCII characters and  _escapes_ , preceded by the characters `U+0062` (`b`) and `U+0022` (double-quote), and followed by the character `U+0022`.-->
非生の _バイト文字列リテラル_ は、`U+0062`（ `b`）と`U+0022`（二重引用符）の後に文字`U+0022`続くASCII文字と _エスケープの_ シーケンスです。
<!--If the character `U+0022` is present within the literal, it must be  _escaped_  by a preceding `U+005C` (`\`) character.-->
文字`U+0022`がリテラル内に存在する場合は、先行する`U+005C`（ `\`）文字で _エスケープ_ する必要があります。
<!--Alternatively, a byte string literal can be a  _raw byte string literal_ , defined below.-->
あるいは、 _バイトストリングリテラルは_ 、以下で定義される _生のバイトストリングリテラルに_ することができます。
<!--The type of a byte string literal of length `n` is `&'static [u8; n]`-->
長さ`n`バイト文字列リテラルの型は`&'static [u8; n]`
<!--`&'static [u8; n]`.-->
`&'static [u8; n]`。

<!--Some additional  _escapes_  are available in either byte or non-raw byte string literals.-->
追加の _エスケープ_ は、バイト文字列リテラルまたはバイト文字列リテラルでも使用できます。
<!--An escape starts with a `U+005C` (`\`) and continues with one of the following forms:-->
エスケープは`U+005C`（ `\`）で始まり、次のいずれかの形式で続行されます。

* <!--A  _byte escape_  escape starts with `U+0078` (`x`) and is followed by exactly two  _hex digits_ .-->
    _バイトエスケープ_ エスケープは`U+0078`（ `x`）で始まり、正確に2  _桁の16進数_ が続き _ます_ 。
<!--It denotes the byte equal to the provided hex value.-->
   それは提供された16進値と等しいバイトを示します。
* <!--A  _whitespace escape_  is one of the characters `U+006E` (`n`), `U+0072` (`r`), or `U+0074` (`t`), denoting the bytes values `0x0A` (ASCII LF), `0x0D` (ASCII CR) or `0x09` (ASCII HT) respectively.-->
    _空白エスケープ文字_ の一つである`U+006E`（ `n`）、 `U+0072`（ `r`）、または`U+0074`（ `t`バイトを表すこと値）`0x0A`（ASCII LF）、`0x0D`（ASCIIのCR）または`0x09`（ASCII HTを）である。
* <!--The  _null escape_  is the character `U+0030` (`0`) and denotes the byte value `0x00` (ASCII NUL).-->
    _nullエスケープ_ は`U+0030`（ `0`）の文字で、 `0x00`（ASCII NUL）のバイト値を示し`0x00`。
* <!--The  _backslash escape_  is the character `U+005C` (`\`) which must be escaped in order to denote its ASCII encoding `0x5C`.-->
    _バックスラッシュのエスケープ_ 文字`U+005C`（ `\`）はASCIIコード`0x5C`を示すためにエスケープする必要があります。

#### <!--Raw byte string literals--> 生のバイト文字列リテラル

> <!--**<sup>Lexer</sup>** \ RAW_BYTE_STRING_LITERAL:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ RAW_BYTE_STRING_LITERAL：\＆nbsp;＆nbsp;
> <!--`br` RAW_BYTE_STRING_CONTENT-->
> `br` RAW_BYTE_STRING_CONTENT
> 
> <!--RAW_BYTE_STRING_CONTENT:\ &nbsp;&nbsp;-->
> RAW_BYTE_STRING_CONTENT：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`"` ASCII  __* (non-greedy)__  `"` \ &nbsp;&nbsp;-->
> `"` ASCII  __*（非貪欲）__  `"` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`#` RAW_STRING_CONTENT `#`-->
> `#` RAW_STRING_CONTENT `#`
> 
> <!--ASCII:\ &nbsp;&nbsp;-->
> ASCII：\＆nbsp;＆nbsp;
> <!-- _any ASCII (ie 0x00 to 0x7F)_ -->
>  _任意のASCII（0x00〜0x7F）_ 

<!--Raw byte string literals do not process any escapes.-->
生のバイト文字列リテラルはエスケープを処理しません。
<!--They start with the character `U+0062` (`b`), followed by `U+0072` (`r`), followed by zero or more of the character `U+0023` (`#`), and a `U+0022` (double-quote) character.-->
文字`U+0062`（ `b`）、 `U+0072`（ `r`）、 `U+0023`（ `#`）、 `U+0022`（二重引用符）の文字が続きます。
<!--The  _raw string body_  can contain any sequence of ASCII characters and is terminated only by another `U+0022` (double-quote) character, followed by the same number of `U+0023` (`#`) characters that preceded the opening `U+0022` (double-quote) character.-->
 _生の文字列本体には、ASCII_ 文字の任意のシーケンスを含めることができ、唯一の別によって終了される`U+0022`の同じ番号が続く（二重引用符）文字、`U+0023`（ `#`開口部の前）の文字`U+0022`（ダブルを引用符）の文字。
<!--A raw byte string literal can not contain any non-ASCII byte.-->
生のバイト文字列リテラルには、ASCII以外のバイトを含めることはできません。

<!--All characters contained in the raw string body represent their ASCII encoding, the characters `U+0022` (double-quote) (except when followed by at least as many `U+0023` (`#`) characters as were used to start the raw string literal) or `U+005C` (`\`) do not have any special meaning.-->
生の文字列本体に含まれるすべての文字は、そのASCIIエンコーディング、文字を表す`U+0022`（少なくとも同数が続くとき以外は（二重引用符を） `U+0023`（ `#`または）文字リテラル生の文字列を開始するために使用されたとして）`U+005C`（ `\`）は特別な意味を持ちません。

<!--Examples for byte string literals:-->
バイト文字列リテラルの例：

```rust
#//b"foo"; br"foo";                     // foo
b"foo"; br"foo";                     //  foo
#//b"\"foo\""; br#""foo""#;             // "foo"
b"\"foo\""; br#""foo""#;             //  "foo"

b"foo #\"# bar";
#//br##"foo #"# bar"##;                 // foo #"# bar
br##"foo #"# bar"##;                 //  foo＃ "＃bar

#//b"\x52"; b"R"; br"R";                // R
b"\x52"; b"R"; br"R";                //  R
#//b"\\x52"; br"\x52";                  // \x52
b"\\x52"; br"\x52";                  //  \ x52
```

### <!--Number literals--> 数リテラル

<!--A  _number literal_  is either an  _integer literal_  or a  _floating-point literal_ .-->
 _数値リテラル_ は、 _整数リテラル_ または _浮動小数点_   _リテラルの_ いずれかです。
<!--The grammar for recognizing the two kinds of literals is mixed.-->
2種類のリテラルを認識するための文法は混在しています。

#### <!--Integer literals--> 整数リテラル

> <!--**<sup>Lexer</sup>** \ INTEGER_LITERAL:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ INTEGER_LITERAL：\＆nbsp;＆nbsp;
> <!--(DEC_LITERAL | BIN_LITERAL | OCT_LITERAL | HEX_LITERAL) INTEGER_SUFFIX  __?__ -->
> （DEC_LITERAL | BIN_LITERAL | OCT_LITERAL | HEX_LITERAL）INTEGER_SUFFIX  __？__ 
> 
> <!--DEC_LITERAL:\ &nbsp;&nbsp;-->
> DEC_LITERAL：\＆nbsp;＆nbsp;
> <!--DEC_DIGIT (DEC_DIGIT| `_`)  __\ *</sup> TUPLE_INDEX:\ &nbsp;&nbsp;*__ -->
> DEC_DIGIT（DEC_DIGIT | `_`）  __\ *</ sup> TUPLE_INDEX：\＆nbsp;＆nbsp;*__ 
> <!-- __*&nbsp;&nbsp;*__ -->
>  __*＆nbsp;＆nbsp;*__ 
> <!-- __*`0` &nbsp;&nbsp;*__ -->
>  __*`0`＆nbsp;＆nbsp;*__ 
> <!-- __*|*__ -->
>  __*|*__ 
> <!-- __*NON_ZERO_DEC_DIGIT DEC_DIGIT<sup>\*__ -->
>  __*NON_ZERO_DEC_DIGIT DEC_DIGIT <sup> \*__ 
> 
> <!--BIN_LITERAL:\ &nbsp;&nbsp;-->
> BIN_LITERAL：\＆nbsp;＆nbsp;
> <!--`0b` (BIN_DIGIT| `_`)  __\ *</sup> BIN_DIGIT (BIN_DIGIT|`_`)<sup>\*__ -->
> `0b`（BIN_DIGIT | `_`）  __\ *</ sup> BIN_DIGIT（BIN_DIGIT | `_`）<sup> \*__ 
> 
> <!--OCT_LITERAL:\ &nbsp;&nbsp;-->
> OCT_LITERAL：\＆nbsp;＆nbsp;
> <!--`0o` (OCT_DIGIT| `_`)  __\ *</sup> OCT_DIGIT (OCT_DIGIT|`_`)<sup>\*__ -->
> `0o`（OCT_DIGIT | `_`）  __\ *</ sup> OCT_DIGIT（OCT_DIGIT | `_`）<sup> \*__ 
> 
> <!--HEX_LITERAL:\ &nbsp;&nbsp;-->
> HEX_LITERAL：\＆nbsp;＆nbsp;
> <!--`0x` (HEX_DIGIT| `_`)  __\ *</sup> HEX_DIGIT (HEX_DIGIT|`_`)<sup>\*__ -->
> `0x`（HEX_DIGIT | `_`）  __\ *</ sup> HEX_DIGIT（HEX_DIGIT | `_`）<sup> \*__ 
> 
> <!--BIN_DIGIT: [`0`-`1`]-->
> BIN_DIGIT： [`0`-`1`]
> 
> <!--OCT_DIGIT: [`0`-`7`]-->
> OCT_DIGIT： [`0`-`7`] 0` [`0`-`7`]
> 
> <!--DEC_DIGIT: [`0`-`9`]-->
> DEC_DIGIT： [`0`-`9`] 0` [`0`-`9`]
> 
> <!--NON_ZERO_DEC_DIGIT: [`1`-`9`]-->
> NON_ZERO_DEC_DIGIT： [`1`-`9`] 1` [`1`-`9`]
> 
> <!--HEX_DIGIT: [`0`-`9` `a`-`f` `A`-`F`]-->
> HEX_DIGIT： [`0`-`9` `a`-`f` `A`-`F`]
> 
> <!--INTEGER_SUFFIX:\ &nbsp;&nbsp;-->
> INTEGER_SUFFIX：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`u8` |-->
> `u8` |
> <!--`u16` |-->
> `u16` |
> <!--`u32` |-->
> `u32` |
> <!--`u64` |-->
> `u64` |
> <!--`u128` |-->
> `u128` |
> <!--`usize` \ &nbsp;&nbsp;-->
> `usize` \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--`i8` |-->
> `i8` |
> <!--`i16` |-->
> `i16` |
> <!--`i32` |-->
> `i32` |
> <!--`i64` |-->
> `i64` |
> <!--`i128` |-->
> | `i128` |
> `isize`

<!--An  _integer literal_  has one of four forms:-->
 _整数リテラルに_ は、次の4つの形式のいずれかがあります。

* <!--A  _decimal literal_  starts with a *decimal digit* and continues with any mixture of *decimal digits* and  _underscores_ .-->
    _小数点のリテラル_ は _10進数で_ 始まり、*10* *進数*と _下線が_ 混在してい _ます_ 。
* <!--A  _tuple index_  is either `0`, or starts with a *non-zero decimal digit* and continues with zero or more decimal digits.-->
    _タプルインデックス_ は`0`か*ゼロ以外の10進数で*始まり、`0`以上の10進数で続きます。
<!--Tuple indexes are used to refer to the fields of [tuples], [tuple structs] and [tuple variants].-->
   タプルインデックスは、[tuples]、 [tuple structs]、および[tuple variants]のフィールドを参照するために使用され[tuple variants]。
* <!--A  _hex literal_  starts with the character sequence `U+0030` `U+0078` (`0x`) and continues as any mixture (with at least one digit) of hex digits and underscores.-->
    _16進リテラル_ は、文字シーケンス`U+0030` `U+0078`（ `0x`）で始まり、16進数とアンダースコアの任意の混合（少なくとも1桁以上）として続きます。
* <!--An  _octal literal_  starts with the character sequence `U+0030` `U+006F` (`0o`) and continues as any mixture (with at least one digit) of octal digits and underscores.-->
    _8進数のリテラル_ は、文字シーケンス`U+0030` `U+006F`（ `0o`）で始まり、8進数と下線の任意の混合（少なくとも1桁）として続きます。
* <!--A  _binary literal_  starts with the character sequence `U+0030` `U+0062` (`0b`) and continues as any mixture (with at least one digit) of binary digits and underscores.-->
    _バイナリリテラル_ は、文字シーケンス`U+0030` `U+0062`（ `0b`）で始まり、2進数とアンダースコアの任意の混合（少なくとも1桁以上）として続きます。

<!--Like any literal, an integer literal may be followed (immediately, without any spaces) by an  _integer suffix_ , which forcibly sets the type of the literal.-->
任意のリテラルと同様に、整数リテラルは、リテラルのタイプを強制的に設定する _整数サフィックス_ によって（スペースなしで）直ちに続けることができます。
<!--The integer suffix must be the name of one of the integral types: `u8`, `i8`, `u16`, `i16`, `u32`, `i32`, `u64`, `i64`, `u128`, `i128`, `usize`, or `isize`.-->
整数接尾辞は、整数型（`u8`、 `i8`、 `u16`、 `i16`、 `u32`、 `i32`、 `u64`、 `i64`、 `u128`、 `i128`、 `usize`、または`isize`）のいずれかの名前でなければなりません。

<!--The type of an  _unsuffixed_  integer literal is determined by type inference:-->
 _接尾辞なしの_ 整数リテラルの型は、型推論によって決まります。

* <!--If an integer type can be  _uniquely_  determined from the surrounding program context, the unsuffixed integer literal has that type.-->
   整数型が周囲のプログラムコンテキストから _一意に_ 決定できる場合、接尾辞のない整数リテラルはその型を持ちます。

* <!--If the program context under-constrains the type, it defaults to the signed 32-bit integer `i32`.-->
   プログラムのコンテキストがタイプを過小に制限する場合、デフォルトでは符号付き32ビット整数`i32`ます。

* <!--If the program context over-constrains the type, it is considered a static type error.-->
   プログラムコンテキストが型を過度に制約する場合、静的型エラーとみなされます。

<!--Examples of integer literals of various forms:-->
さまざまな形式の整数リテラルの例：

```rust
#//123;                               // type i32
123;                               // タイプi32
#//123i32;                            // type i32
123i32;                            // タイプi32
#//123u32;                            // type u32
123u32;                            // タイプu32
#//123_u32;                           // type u32
123_u32;                           // タイプu32
#//let a: u64 = 123;                  // type u64
let a: u64 = 123;                  // タイプu64

#//0xff;                              // type i32
0xff;                              // タイプi32
#//0xff_u8;                           // type u8
0xff_u8;                           // タイプu8

#//0o70;                              // type i32
0o70;                              // タイプi32
#//0o70_i16;                          // type i16
0o70_i16;                          // タイプi16

#//0b1111_1111_1001_0000;             // type i32
0b1111_1111_1001_0000;             // タイプi32
#//0b1111_1111_1001_0000i64;          // type i64
0b1111_1111_1001_0000i64;          // タイプi64
#//0b________1;                       // type i32
0b________1;                       // タイプi32

#//0usize;                            // type usize
0usize;                            // タイプusize
```

<!--Examples of invalid integer literals:-->
無効な整数リテラルの例：

```rust,ignore
#// invalid suffixes
// 無効な接尾辞

0invalidSuffix;

#// uses numbers of the wrong base
// 間違ったベースの番号を使用する

123AFB43;
0b0102;
0o0581;

#// integers too big for their type (they overflow)
// 型が大きすぎる整数（オーバーフロー）

128_i8;
256_u8;

#// bin, hex and octal literals must have at least one digit
//  bin、hex、およびoctalリテラルには少なくとも1桁の数字が必要です

0b_;
0b____;
```

<!--Note that the Rust syntax considers `-1i8` as an application of the [unary minus operator] to an integer literal `1i8`, rather than a single integer literal.-->
Rust構文では、`1i8`は単一の整数リテラルではなく、整数リテラル`1i8`への[unary minus operator]アプリケーションと`-1i8`れます。

[unary minus operator]: expressions/operator-expr.html#negation-operators

#### <!--Floating-point literals--> 浮動小数点リテラル

> <!--**<sup>Lexer</sup>** \ FLOAT_LITERAL:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ FLOAT_LITERAL：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--DEC_LITERAL `.`-->
> DEC_LITERAL `.`
> <!-- _(not immediately followed by `.`, `_  `or an [identifier]_)\ &nbsp;&nbsp; | DEC_LITERAL FLOAT_EXPONENT\ &nbsp;&nbsp; | DEC_LITERAL`-->
>  _（直後に `.`、` `_  `or an [identifier]_)\ &nbsp;&nbsp; | DEC_LITERAL FLOAT_EXPONENT\ &nbsp;&nbsp; | DEC_LITERAL`  _続きません_  `or an [identifier]_)\ &nbsp;&nbsp; | DEC_LITERAL FLOAT_EXPONENT\ &nbsp;&nbsp; | DEC_LITERAL`
> `or an [identifier]_)\ &nbsp;&nbsp; | DEC_LITERAL FLOAT_EXPONENT\ &nbsp;&nbsp; | DEC_LITERAL` <!--`or an [identifier]_)\ &nbsp;&nbsp; | DEC_LITERAL FLOAT_EXPONENT\ &nbsp;&nbsp; | DEC_LITERAL`.-->
> `or an [identifier]_)\ &nbsp;&nbsp; | DEC_LITERAL FLOAT_EXPONENT\ &nbsp;&nbsp; | DEC_LITERAL`。
> `DEC_LITERAL FLOAT_EXPONENT<sup>?</sup>\ &nbsp;&nbsp; | DEC_LITERAL (` <!--`DEC_LITERAL FLOAT_EXPONENT<sup>?</sup>\ &nbsp;&nbsp; | DEC_LITERAL (`.` DEC_LITERAL)  __?__ -->
> `DEC_LITERAL FLOAT_EXPONENT<sup>?</sup>\ &nbsp;&nbsp; | DEC_LITERAL (`.` DEC_LITERAL） __？__ 
> <!--FLOAT_EXPONENT  __?__ -->
> FLOAT_EXPONENT  __？__ 
> <!--FLOAT_SUFFIX-->
> FLOAT_SUFFIX
> 
> <!--FLOAT_EXPONENT:\ &nbsp;&nbsp;-->
> FLOAT_EXPONENT：\＆nbsp;＆nbsp;
> <!--(`e` | `E`) (`+` | `-`)?-->
> （`e` | `E`）（ `+` | `-`）？
> <!--(DEC_DIGIT| `_`)  __\ *</sup> DEC_DIGIT (DEC_DIGIT|`_`)<sup>\*__ -->
> （DEC_DIGIT | `_`）  __\ *</ sup> DEC_DIGIT（DEC_DIGIT | `_`）<sup> \*__ 
> 
> <!--FLOAT_SUFFIX:\ &nbsp;&nbsp;-->
> FLOAT_SUFFIX：\＆nbsp;＆nbsp;
> <!--`f32` |-->
> `f32` |
> `f64`

<!--A  _floating-point literal_  has one of two forms:-->
 _浮動小数点型リテラルに_ は、次の2つの形式のいずれかがあります。

* <!--A  _decimal literal_  followed by a period character `U+002E` (`.`).-->
    _小数点以下のリテラルと_ それに続くピリオド`U+002E`（ `.`）。
<!--This is optionally followed by another decimal literal, with an optional  _exponent_ .-->
   これにはオプションで、オプションの _指数部を_ 持つ10進リテラルが続きます。
* <!--A single  _decimal literal_  followed by an  _exponent_ .-->
   1つの _10進リテラルと_ それに続く _指数_ 。

<!--Like integer literals, a floating-point literal may be followed by a suffix, so long as the pre-suffix part does not end with `U+002E` (`.`).-->
整数リテラルと同様に、浮動小数点型のリテラルには、接尾辞の前の部分が`U+002E`（ `.`）で終わっていない限り、接尾辞の後に続くことがあります。
<!--The suffix forcibly sets the type of the literal.-->
接尾辞は、リテラルのタイプを強制的に設定します。
<!--There are two valid  _floating-point suffixes_ , `f32` and `f64` (the 32-bit and 64-bit floating point types), which explicitly determine the type of the literal.-->
2つの有効な _浮動小数点接尾辞_  `f32`と`f64`（32ビットと64ビットの浮動小数点型）があり、リテラルの型を明示的に決定します。

<!--The type of an  _unsuffixed_  floating-point literal is determined by type inference:-->
 _接尾辞なしの_ 浮動小数点型の型は、型推論によって決まります。

* <!--If a floating-point type can be  _uniquely_  determined from the surrounding program context, the unsuffixed floating-point literal has that type.-->
   浮動小数点型が周囲のプログラムコンテキストから _一意に_ 決定できる場合、接尾辞のない浮動小数点型はその型を持ちます。

* <!--If the program context under-constrains the type, it defaults to `f64`.-->
   プログラムのコンテキストが型の制約を受けない場合、デフォルトは`f64`ます。

* <!--If the program context over-constrains the type, it is considered a static type error.-->
   プログラムコンテキストが型を過度に制約する場合、静的型エラーとみなされます。

<!--Examples of floating-point literals of various forms:-->
さまざまな形式の浮動小数点リテラルの例：

```rust
#//123.0f64;        // type f64
123.0f64;        // タイプf64
#//0.1f64;          // type f64
0.1f64;          // タイプf64
#//0.1f32;          // type f32
0.1f32;          // タイプf32
#//12E+99_f64;      // type f64
12E+99_f64;      // タイプf64
#//let x: f64 = 2.; // type f64
let x: f64 = 2.; // タイプf64
```

<!--This last example is different because it is not possible to use the suffix syntax with a floating point literal ending in a period.-->
この最後の例は、ピリオドで終わる浮動小数点リテラルで接尾辞構文を使用することができないため、異なるものです。
<!--`2.f64` would attempt to call a method named `f64` on `2`.-->
`2.f64`は`f64`という名前のメソッドを`2` `2.f64`うとします。

<!--The representation semantics of floating-point numbers are described in ["Machine Types"].-->
浮動小数点数の表現セマンティクスについては、["Machine Types"]説明しています。

["Machine Types"]: types.html#machine-types

### <!--Boolean literals--> ブールリテラル

> <!--**<sup>Lexer</sup>** \ BOOLEAN_LITERAL:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ BOOLEAN_LITERAL：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`true` \ &nbsp;&nbsp;-->
> `true` \＆nbsp;＆nbsp;
> <!--|-->
> |
> `false`

<!--The two values of the boolean type are written `true` and `false`.-->
ブール型の2つの値は`true`と`false`と書かれてい`false`。

## <!--Lifetimes and loop labels--> ライフタイムとループラベル

> <!--**<sup>Lexer</sup>** \ LIFETIME_TOKEN:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ LIFETIME_TOKEN：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`'` [IDENTIFIER_OR_KEYWORD][identifier] \ &nbsp;&nbsp;-->
> `'` [IDENTIFIER_OR_KEYWORD][identifier] \＆nbsp;＆nbsp;
> <!--|-->
> |
> `'_`
> <!--LIFETIME_OR_LABEL:\ &nbsp;&nbsp;-->
> LIFETIME_OR_LABEL：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`'` [IDENTIFIER][identifier]-->
> `'` [IDENTIFIER][identifier]

<!--Lifetime parameters and [loop labels] use LIFETIME_OR_LABEL tokens.-->
寿命パラメータと[loop labels]は、LIFETIME_OR_LABELトークンが使用されます。
<!--Any LIFETIME_TOKEN will be accepted by the lexer, and for example, can be used in macros.-->
LIFETIME_TOKENはレクサーによって受け入れられ、たとえば、マクロで使用できます。

[loop labels]: expressions/loop-expr.html

## <!--Symbols--> シンボル

<!--Symbols are a general class of printable [tokens] that play structural roles in a variety of grammar productions.-->
シンボルは、様々な文法制作において構造的役割を果たす印刷可能な[tokens]一般的なクラスです。
<!--They are a set of remaining miscellaneous printable tokens that do not otherwise appear as [unary operators], [binary operators], or [keywords].-->
それらは、その他の[unary operators]、 [binary operators]、または[keywords]として表示されない印刷可能なその他のトークンの集合です。
<!--They are catalogued in [the Symbols section][symbols] of the Grammar document.-->
それらは、文法文書の[「シンボル」セクション][symbols]でカタログ化され[てい][symbols]ます。

<!--[unary operators]: expressions/operator-expr.html#borrow-operators
 [binary operators]: expressions/operator-expr.html#arithmetic-and-logical-binary-operators
 [tokens]: #tokens
 [symbols]: ../grammar.html#symbols
 [keywords]: keywords.html
 [identifier]: identifiers.html
 [tuples]: types.html#tuple-types
 [tuple structs]: items/structs.html
 [tuple variants]: items/enumerations.html
-->
[unary operators]: expressions/operator-expr.html#borrow-operators
 [binary operators]: expressions/operator-expr.html#arithmetic-and-logical-binary-operators
 [tokens]: #tokens
 [symbols]: ../grammar.html#symbols
 [keywords]: keywords.html
 [identifier]: identifiers.html
 [tuples]: types.html#tuple-types
 [tuple structs]: items/structs.html
 [tuple variants]: items/enumerations.html

