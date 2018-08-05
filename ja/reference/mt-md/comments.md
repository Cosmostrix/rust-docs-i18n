# <!--Comments--> コメント

> <!--**<sup>Lexer</sup>** \ LINE_COMMENT:\ &nbsp;&nbsp;-->
> **<sup> Lexer </ sup>** \ LINE_COMMENT：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--`//` (~ [`/` `!`] | `//`) ~ `\n`  __\ *</sup>\ &nbsp;&nbsp;*__ -->
> `//`（〜 [`/` `!`] | `//`）〜 `\n`  __\ *</ sup> \＆nbsp;＆nbsp;*__ 
> <!-- __*|*__ -->
>  __*|*__ 
> <!-- __*`//` BLOCK_COMMENT:\ &nbsp;&nbsp;*__ -->
>  __*`//` BLOCK_COMMENT：\＆nbsp;＆nbsp;*__ 
> <!-- __*&nbsp;&nbsp;*__ -->
>  __*＆nbsp;＆nbsp;*__ 
> <!-- __*`/* `(~[` *` `!`] | `* *` | _BlockCommentOrDoc_) (_BlockCommentOrDoc_ | ~`* / `)<sup>\*</sup>` */`\ &nbsp;&nbsp;*__ -->
>  __*`/* `(~[` *` ``！ `] |`* *`| _BlockCommentOrDoc_）（_BlockCommentOrDoc_ |〜`* / `)<sup>\*</sup>` */ `\＆nbsp;*__ 
> <!-- __*|*__ -->
>  __*|*__ 
> <!-- __*`/* */`\ &nbsp;&nbsp;*__ -->
>  __*`/* */` \＆nbsp;＆nbsp;*__ 
> <!-- __*|*__ -->
>  __*|*__ 
> <!-- __*`/* * */` INNER_LINE_DOC:\ &nbsp;&nbsp;*__ -->
>  __*`/* * */` INNER_LINE_DOC：\＆nbsp;＆nbsp;*__ 
> <!-- __*`//!` ~[`\n` _IsolatedCR_]<sup>\*__ -->
>  __*`//！`〜[`\ n` _IsolatedCR _] <sup> \*__ 
> 
> <!--INNER_BLOCK_DOC:\ &nbsp;&nbsp;-->
> INNER_BLOCK_DOC：\＆nbsp;＆nbsp;
> <!--`/*!` ( _BlockCommentOrDoc_  | ~ [`*/` _IsolatedCR_])  __\ *</sup> `* /`__ -->
> `/*!`（  _BlockCommentOrDoc_  |〜 [`*/` _IsolatedCR_]）  __\ *</ sup> `* /`__ 
> 
> <!--OUTER_LINE_DOC:\ &nbsp;&nbsp;-->
> OUTER_LINE_DOC：\＆nbsp;＆nbsp;
> <!--`///` (~ `/` ~ [`\n` _IsolatedCR_]  __\ *</sup>)<sup>?</sup> OUTER_BLOCK_DOC:\ &nbsp;&nbsp;*__ -->
> `///`（〜 `/` 〜 [`\n` _IsolatedCR_]  __\ *</ sup>）<sup>？</ sup> OUTER_BLOCK_DOC：\＆nbsp;＆nbsp;*__ 
> <!-- __*`/* *` (~`* `| _BlockCommentOrDoc_ ) (_BlockCommentOrDoc_ | ~[` */` _IsolatedCR_])<sup>\*__  `*/`-->
>  __*`/* *`（〜 `* *_BlockCommentOrDoc_* `| _BlockCommentOrDoc_ ) (_BlockCommentOrDoc_ | ~[` */` _IsolatedCR _]）<sup> \*__  `*/`
> 
> <!-- _BlockCommentOrDoc_ :\ &nbsp;&nbsp;-->
>  _BlockCommentOrDoc_ ：\＆nbsp;＆nbsp;
> <!--&nbsp;&nbsp;-->
> ＆nbsp;＆nbsp;
> <!--BLOCK_COMMENT\ &nbsp;&nbsp;-->
> BLOCK_COMMENT \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--OUTER_BLOCK_DOC\ &nbsp;&nbsp;-->
> OUTER_BLOCK_DOC \＆nbsp;＆nbsp;
> <!--|-->
> |
> <!--INNER_BLOCK_DOC-->
> INNER_BLOCK_DOC
> 
> <!-- _IsolatedCR_ :\ &nbsp;&nbsp;-->
>  _隔離されたCR_ ：\＆nbsp;＆nbsp;
> <!-- _A `\r` not followed by a `\n`_ -->
>  _`\ r`の後ろに` \ n`が続く_ 

## <!--Non-doc comments--> 非ドキュメンテーションコメント

<!--Comments in Rust code follow the general C++ style of line (`//`) and block (`/* ... */`) comment forms.-->
錆コードのコメントは、一般的なC ++スタイルの行（`//`）とブロック（ `/* ... */`）コメントフォームに従います。
<!--Nested block comments are supported.-->
ネストされたブロックコメントがサポートされています。

<!--Non-doc comments are interpreted as a form of whitespace.-->
非ドキュメンテーションコメントは、空白の形として解釈されます。

## <!--Doc comments--> ドキュメントのコメント

<!--Line doc comments beginning with exactly  _three_  slashes (`///`), and block doc comments (`/** ... */`), both inner doc comments, are interpreted as a special syntax for `doc` [attributes].-->
 _3つの_ スラッシュ（`///`）で始まる行文書コメントとブロック文書コメント（ `/** ... */`）は、内部の文書コメントの両方とも、 `doc` [attributes]特殊な構文として解釈され[attributes]。
<!--That is, they are equivalent to writing `#[doc="..."]` around the body of the comment, ie, `/// Foo` turns into `#[doc="Foo"]` and `/** Bar */` turns into `#[doc="Bar"]`.-->
つまり、コメント本体に`#[doc="..."]`を書くことと同じ`#[doc="..."]`つまり、`/// Foo`は`#[doc="Foo"]`変わり、`/** Bar */`は`#[doc="Bar"]`。

<!--Line comments beginning with `//!` and block comments `/*! ... */` are doc comments that apply to the parent of the comment, rather than the item that follows.-->
`//!`始まり、コメント`/*! ... */`始まる行コメントは、後続の項目ではなく、コメントの親に適用されるドキュメンテーションコメントです。
<!--That is, they are equivalent to writing `#![doc="..."]` around the body of the comment.-->
つまり、コメントの本文の前後に`#![doc="..."]`を書くことと同じです。
<!--`//!` comments are usually used to document modules that occupy a source file.-->
`//!`コメントは、通常、ソースファイルを占めるモジュールを記述するために使用されます。

<!--Isolated CRs (`\r`), ie not followed by LF (`\n`), are not allowed in doc comments.-->
隔離されたCR（`\r`）、つまりLF（ `\n`）の後に続くものは、ドキュメンテーションコメントには使用できません。

## <!--Examples--> 例

```rust
//! A doc comment that applies to the implicit anonymous module of this crate

pub mod outer_module {

    //!  - Inner line doc
    //!! - Still an inner line doc (but with a bang at the beginning)

    /*!  - Inner block doc */
    /*!! - Still an inner block doc (but with a bang at the beginning) */

#    //   - Only a comment
    //  -コメントのみ
#//    ///  - Outer line doc (exactly 3 slashes)
    ///  -外側の線のdoc（正確に3つのスラッシュ）
#//    //// - Only a comment
    ////  -コメントのみ

    /*   - Only a comment */
    /**  - Outer block doc (exactly) 2 asterisks */
    /*** - Only a comment */

    pub mod inner_module {}

    pub mod nested_comments {
        /* In Rust /* we can /* nest comments */ */ */

#        // All three types of block comments can contain or be nested inside
#        // any other type:
        //  3種類のブロックコメントはすべて、他のタイプの中に入れたり、入れ子にすることができます。

        /*   /* */  /** */  /*! */  */
        /*!  /* */  /** */  /*! */  */
        /**  /* */  /** */  /*! */  */
        pub mod dummy_item {}
    }

    pub mod degenerate_cases {
#        // empty inner line doc
        // 空の内部線doc
        //!

#        // empty inner block doc
        // 空の内部ブロック文書
        /*!*/

#        // empty line comment
        // 空行コメント
        //

#        // empty outer line doc
        // 空の外部行doc
        ///

#        // empty block comment
        // 空のブロックコメント
        /**/

        pub mod dummy_item {}

#        // empty 2-asterisk block isn't a doc block, it is a block comment
        // 空の2 -アスタリスクブロックはdocブロックではない、ブロックコメントである
        /***/

    }

    /* The next one isn't allowed because outer doc comments
       require an item that will receive the doc */

#//    /// Where is my item?
    /// 私の商品はどこですか？
#   mod boo {}
}
```

[attributes]: attributes.html
