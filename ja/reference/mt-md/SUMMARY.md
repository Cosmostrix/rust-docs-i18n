# <!--The Rust Reference--> 錆リファレンス

[Introduction](introduction.md)
- [Notation](notation.md)

- <!--[Lexical structure](lexical-structure.md)-->
   [語彙構造](lexical-structure.md)
    - <!--[Input format](input-format.md)-->
       [入力形式](input-format.md)
    - [Keywords](keywords.md)
    - [Identifiers](identifiers.md)
    - [Comments](comments.md)
    - [Whitespace](whitespace.md)
    - [Tokens](tokens.md)
    - [Paths](paths.md)

- [Macros](macros.md)
    - <!--[Macros By Example](macros-by-example.md)-->
       [例によるマクロ](macros-by-example.md)
    - <!--[Procedural Macros](procedural-macros.md)-->
       [手続き型マクロ](procedural-macros.md)

- <!--[Crates and source files](crates-and-source-files.md)-->
   [クレートとソースファイル](crates-and-source-files.md)

- <!--[Items and attributes](items-and-attributes.md)-->
   [アイテムと属性](items-and-attributes.md)
    - [Items](items.md)
        - [Modules](items/modules.md)
        - <!--[Extern crates](items/extern-crates.md)-->
           [エクステンション箱](items/extern-crates.md)
        - <!--[Use declarations](items/use-declarations.md)-->
           [宣言を使用する](items/use-declarations.md)
        - [Functions](items/functions.md)
        - <!--[Type aliases](items/type-aliases.md)-->
           [タイプエイリアス](items/type-aliases.md)
        - [Structs](items/structs.md)
        - [Enumerations](items/enumerations.md)
        - [Unions](items/unions.md)
        - <!--[Constant items](items/constant-items.md)-->
           [定数項目](items/constant-items.md)
        - <!--[Static items](items/static-items.md)-->
           [静的アイテム](items/static-items.md)
        - [Traits](items/traits.md)
        - [Implementations](items/implementations.md)
        - <!--[External blocks](items/external-blocks.md)-->
           [外部ブロック](items/external-blocks.md)
    - <!--[Type and lifetime parameters](items/generics.md)-->
       [タイプと有効期間のパラメータ](items/generics.md)
    - <!--[Associated Items](items/associated-items.md)-->
       [関連商品](items/associated-items.md)
    - <!--[Visibility and Privacy](visibility-and-privacy.md)-->
       [可視性とプライバシー](visibility-and-privacy.md)
    - [Attributes](attributes.md)

- <!--[Statements and expressions](statements-and-expressions.md)-->
   [ステートメントと式](statements-and-expressions.md)
    - [Statements](statements.md)
    - [Expressions](expressions.md)
        - <!--[Literal expressions](expressions/literal-expr.md)-->
           [リテラル式](expressions/literal-expr.md)
        - <!--[Path expressions](expressions/path-expr.md)-->
           [パス式](expressions/path-expr.md)
        - <!--[Block expressions](expressions/block-expr.md)-->
           [表現をブロックする](expressions/block-expr.md)
        - <!--[Operator expressions](expressions/operator-expr.md)-->
           [演算子式](expressions/operator-expr.md)
        - <!--[Grouped expressions](expressions/grouped-expr.md)-->
           [グループ化された式](expressions/grouped-expr.md)
        - <!--[Array and index expressions](expressions/array-expr.md)-->
           [配列式とインデックス式](expressions/array-expr.md)
        - <!--[Tuple and index expressions](expressions/tuple-expr.md)-->
           [タプルとインデックス式](expressions/tuple-expr.md)
        - <!--[Struct expressions](expressions/struct-expr.md)-->
           [構造式](expressions/struct-expr.md)
        - <!--[Enum variant expressions](expressions/enum-variant-expr.md)-->
           [Enumバリアント式](expressions/enum-variant-expr.md)
        - <!--[Call expressions](expressions/call-expr.md)-->
           [呼び出し式](expressions/call-expr.md)
        - <!--[Method call expressions](expressions/method-call-expr.md)-->
           [メソッド呼び出し式](expressions/method-call-expr.md)
        - <!--[Field access expressions](expressions/field-expr.md)-->
           [フィールドアクセス式](expressions/field-expr.md)
        - <!--[Closure expressions](expressions/closure-expr.md)-->
           [クロージャ式](expressions/closure-expr.md)
        - <!--[Loop expressions](expressions/loop-expr.md)-->
           [ループ式](expressions/loop-expr.md)
        - <!--[Range expressions](expressions/range-expr.md)-->
           [範囲式](expressions/range-expr.md)
        - <!--[If and if let expressions](expressions/if-expr.md)-->
           [もし、let式なら](expressions/if-expr.md)
        - <!--[Match expressions](expressions/match-expr.md)-->
           [式の一致](expressions/match-expr.md)
        - <!--[Return expressions](expressions/return-expr.md)-->
           [式を返す](expressions/return-expr.md)

- <!--[Type system](type-system.md)-->
   [タイプシステム](type-system.md)
    - [Types](types.md)
    - <!--[Dynamically Sized Types](dynamically-sized-types.md)-->
       [動的にサイズの変更された型](dynamically-sized-types.md)
    - <!--[Type layout](type-layout.md)-->
       [タイプのレイアウト](type-layout.md)
    - <!--[Interior mutability](interior-mutability.md)-->
       [内部の変更](interior-mutability.md)
    - <!--[Subtyping and Variance](subtyping.md)-->
       [サブタイプと差異](subtyping.md)
    - <!--[Trait and lifetime bounds](trait-bounds.md)-->
       [特性と生涯の境界](trait-bounds.md)
    - <!--[Type coercions](type-coercions.md)-->
       [型変換](type-coercions.md)
    - [Destructors](destructors.md)
    - <!--[Lifetime elision](lifetime-elision.md)-->
       [永久脱出](lifetime-elision.md)

- <!--[Special types and traits](special-types-and-traits.md)-->
   [特殊なタイプと特性](special-types-and-traits.md)

- <!--[Memory model](memory-model.md)-->
   [メモリモデル](memory-model.md)
    - <!--[Memory allocation and lifetime](memory-allocation-and-lifetime.md)-->
       [メモリの割り当てと有効期間](memory-allocation-and-lifetime.md)
    - <!--[Memory ownership](memory-ownership.md)-->
       [メモリの所有権](memory-ownership.md)
    - [Variables](variables.md)

- [Linkage](linkage.md)

- [Unsafety](unsafety.md)
    - <!--[Unsafe functions](unsafe-functions.md)-->
       [安全でない関数](unsafe-functions.md)
    - <!--[Unsafe blocks](unsafe-blocks.md)-->
       [安全でないブロック](unsafe-blocks.md)
    - <!--[Behavior considered undefined](behavior-considered-undefined.md)-->
       [定義されていない動作](behavior-considered-undefined.md)
    - <!--[Behavior not considered unsafe](behavior-not-considered-unsafe.md)-->
       [安全でないとみなされない行動](behavior-not-considered-unsafe.md)

<!--[Appendix: Influences](influences.md)-->
[付録：影響](influences.md)

<!--[Appendix: As-yet-undocumented Features](undocumented.md)-->
[付録：未だ文書化されていない機能](undocumented.md)

<!--[Appendix: Glossary](glossary.md)-->
[付録：用語集](glossary.md)
