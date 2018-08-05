# <!--Identifiers--> 識別子

> <!--**<sup>Lexer:<sup>** \ IDENTIFIER_OR_KEYWORD:\ &nbsp;&nbsp;-->
> **<sup>レクサー：<sup>** \ IDENTIFIER_OR_KEYWORD：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--[`a`-`z` `A`-`Z`] &nbsp;-->
> [`a`-`z` `A`-`Z`] ＆nbsp;
> <!--[`a`-`z` `A`-`Z` `0`-`9` `_`]  __\ *</sup>\ &nbsp;&nbsp;*__ -->
> [`a`-`z` `A`-`Z` `0`-`9` `_`]  __*<* \__  [`a`-`z` `A`-`Z` `0`-`9` `_`]  __*/*__  [`a`-`z` `A`-`Z` `0`-`9` `_`]  __*>*__  [`a`-`z` `A`-`Z` `0`-`9` `_`]  __*＆*__  [`a`-`z` `A`-`Z` `0`-`9` `_`]
> <!-- __*|*__ -->
>  __*|*__ 
> <!-- __*`_` [`a`-`z` `A`-`Z` `0`-`9` `_`]<sup>+</sup> IDENTIFIER:\ IDENTIFIER_OR_KEYWORD <sub>* Except a [strict] or [reserved] keyword*__ -->
>  __*ID：_IDENTIFIER_OR_KEYWORD <sub>* [strict]または[reserved]キーワードを除いて、*'_' [`a``z```````````````````````` <sup> + </ sup>* *__ 

<!--An identifier is any nonempty ASCII string of the following form:-->
識別子は、次の形式の空でないASCII文字列です。

<!--Either-->
いずれか

* <!--The first character is a letter.-->
   最初の文字は文字です。
* <!--The remaining characters are alphanumeric or `_`.-->
   残りの文字は英数字または`_`です。

<!--Or-->
または

* <!--The first character is `_`.-->
   最初の文字は`_`です。
* <!--The identifier is more than one character.-->
   識別子は複数の文字です。
<!--`_` alone is not an identifier.-->
   `_`単独では識別子ではありません。
* <!--The remaining characters are alphanumeric or `_`.-->
   残りの文字は英数字または`_`です。

<!--[strict]: keywords.html#strict-keywords
 [reserved]: keywords.html#reserved-keywords
-->
[strict]: keywords.html#strict-keywords
 [reserved]: keywords.html#reserved-keywords

