# <!--Rust API Guidelines Checklist--> 錆APIガイドラインのチェックリスト

<!-- Read CONTRIBUTING.md before writing new guidelines -->

- <!--**Naming** *(crate aligns with Rust naming conventions)*-->
   **命名** *（クレートはRust命名規則に沿っています）*
  - [] <!--Casing conforms to RFC 430 ([C-CASE])-->
     ケーシングは、RFC 430（[C-CASE]）
  - [] <!--Ad-hoc conversions follow `as_`, `to_`, `into_` conventions ([C-CONV])-->
     アドホック変換は、`as_`、 `to_`、 `into_`（ [C-CONV]）
  - [] <!--Getter names follow Rust convention ([C-GETTER])-->
     ゲッター名はRust convention（[C-GETTER]）に従います。
  - [] <!--Methods on collections that produce iterators follow `iter`, `iter_mut`, `into_iter` ([C-ITER])-->
     イテレータを生成するコレクションのメソッドは、`iter`、 `iter_mut`、 `into_iter`従います（[C-ITER]）
  - [] <!--Iterator type names match the methods that produce them ([C-ITER-TY])-->
     イテレータの型名は、それらを生成するメソッドと一致します（[C-ITER-TY]）
  - [] <!--Feature names are free of placeholder words ([C-FEATURE])-->
     機能名にはプレースホルダ語はありません（[C-FEATURE]）
  - [] <!--Names use a consistent word order ([C-WORD-ORDER])-->
     名前は一貫した語順を使用します（[C-WORD-ORDER]）
- <!--**Interoperability** *(crate interacts nicely with other library functionality)*-->
   **相互運用性** *（crateは他のライブラリ機能とうまくやりとりします）*
  - [] <!--Types eagerly implement common traits ([C-COMMON-TRAITS])-->
     タイプは熱心に共通の特性を実装する（[C-COMMON-TRAITS]）
    - <!--`Copy`, `Clone`, `Eq`, `PartialEq`, `Ord`, `PartialOrd`, `Hash`, `Debug`, `Display`, `Default`-->
       `Copy`、 `Clone`、 `Eq`、 `PartialEq`、 `Ord`、 `PartialOrd`、 `Hash`、 `Debug`、 `Display`、 `Default`
  - [] <!--Conversions use the standard traits `From`, `AsRef`, `AsMut` ([C-CONV-TRAITS])-->
     変換は、標準的な形質使用`From`、 `AsRef`、 `AsMut`（ [C-CONV-TRAITS]）
  - [] <!--Collections implement `FromIterator` and `Extend` ([C-COLLECT])-->
     コレクションは`FromIterator`および`Extend`（ [C-COLLECT]）を実装してい`FromIterator`
  - [] <!--Data structures implement Serde's `Serialize`, `Deserialize` ([C-SERDE])-->
     データ構造は、[C-SERDE]の`Serialize`、 `Deserialize`（ [C-SERDE]）
  - [] <!--Types are `Send` and `Sync` where possible ([C-SEND-SYNC])-->
     可能な場合は、`Send`と`Sync`がタイプされます（[C-SEND-SYNC]）
  - [] <!--Error types are meaningful and well-behaved ([C-GOOD-ERR])-->
     エラーの種類は意味があり、適切に動作します（[C-GOOD-ERR]）
  - [] <!--Binary number types provide `Hex`, `Octal`, `Binary` formatting ([C-NUM-FMT])-->
     バイナリ形式は、`Hex`、 `Octal` `Binary`、 `Binary`（ [C-NUM-FMT]）
  - [] <!--Generic reader/writer functions take `R: Read` and `W: Write` by value ([C-RW-VALUE])-->
     一般的なリーダ/ライタ関数は、`R: Read`、 `W: Write`値で`W: Write`（ [C-RW-VALUE]）
- <!--**Macros** *(crate presents well-behaved macros)*-->
   **マクロ** *（クレートは正常に動作するマクロを提示する）*
  - [] <!--Input syntax is evocative of the output ([C-EVOCATIVE])-->
     入力構文は出力（[C-EVOCATIVE]）を喚起します。
  - [] <!--Macros compose well with attributes ([C-MACRO-ATTR])-->
     マクロは属性（[C-MACRO-ATTR]）
  - [] <!--Item macros work anywhere that items are allowed ([C-ANYWHERE])-->
     アイテムマクロは、アイテムが許可されている場所であればどこでも動作します（[C-ANYWHERE]）
  - [] <!--Item macros support visibility specifiers ([C-MACRO-VIS])-->
     項目マクロは可視性指定子（[C-MACRO-VIS]）をサポートします。
  - [] <!--Type fragments are flexible ([C-MACRO-TY])-->
     タイプフラグメントはフレキシブル（[C-MACRO-TY]）
- <!--**Documentation** *(crate is abundantly documented)*-->
   **文書化** *（箱は豊富に文書化されている）*
  - [] <!--Crate level docs are thorough and include examples ([C-CRATE-DOC])-->
     クレートレベルのドキュメントは徹底しており、例（[C-CRATE-DOC]）
  - [] <!--All items have a rustdoc example ([C-EXAMPLE])-->
     すべてのアイテムにrustdocの例があります（[C-EXAMPLE]）
  - [] <!--Examples use `?`-->
     使用例は`?`
<!--, not `try!`, not `unwrap` ([C-QUESTION-MARK])-->
     、ではない`try!`、ない`unwrap`（ [C-QUESTION-MARK]）
  - [] <!--Function docs include error, panic, and safety considerations ([C-FAILURE])-->
     ファンクションドキュメントには、エラー、パニック、安全性に関する考慮事項（[C-FAILURE]）
  - [] <!--Prose contains hyperlinks to relevant things ([C-LINK])-->
     散文には関連するものへのハイパーリンクが含まれています（[C-LINK]）
  - [] <!--Cargo.toml includes all common metadata ([C-METADATA])-->
     Cargo.tomlにはすべての一般的なメタデータ（[C-METADATA]）
    - <!--authors, description, license, homepage, documentation, repository, readme, keywords, categories-->
       著者、説明、ライセンス、ホームページ、ドキュメント、リポジトリ、readme、キーワード、カテゴリ
  - [] <!--Crate sets html_root_url attribute "https://docs.rs/CRATE/XYZ"([C-HTML-ROOT])-->
     クレートセットhtml_root_url属性"https://docs.rs/CRATE/XYZ"（[C-HTML-ROOT]）
  - [] <!--Release notes document all significant changes ([C-RELNOTES])-->
     リリースノートにはすべての重要な変更点が記載されています（[C-RELNOTES]）
  - [] <!--Rustdoc does not show unhelpful implementation details ([C-HIDDEN])-->
     Rustdocは役に立たない実装の詳細を表示しません（[C-HIDDEN]）
- <!--**Predictability** *(crate enables legible code that acts how it looks)*-->
   **予測可能性** *（crateにより、見た目に影響を与える見やすいコードが可能になります）*
  - [] <!--Smart pointers do not add inherent methods ([C-SMART-PTR])-->
     スマートポインタは固有のメソッドを追加しません（[C-SMART-PTR]）
  - [] <!--Conversions live on the most specific type involved ([C-CONV-SPECIFIC])-->
     コンバージョンは、関連する最も具体的なタイプで実行されます（[C-CONV-SPECIFIC]）
  - [] <!--Functions with a clear receiver are methods ([C-METHOD])-->
     明確なレシーバを持つ関数はメソッド（[C-METHOD]）です。
  - [] <!--Functions do not take out-parameters ([C-NO-OUT])-->
     関数はパラメータを取り出さない（[C-NO-OUT]）
  - [] <!--Operator overloads are unsurprising ([C-OVERLOAD])-->
     オペレータの過負荷は驚異的です（[C-OVERLOAD]）
  - [] <!--Only smart pointers implement `Deref` and `DerefMut` ([C-DEREF])-->
     スマートポインタを実装のみ`Deref`と`DerefMut`（ [C-DEREF]）
  - [] <!--Constructors are static, inherent methods ([C-CTOR])-->
     コンストラクタは静的で固有のメソッド（[C-CTOR]）です。
- <!--**Flexibility** *(crate supports diverse real-world use cases)*-->
   **柔軟性** *（さまざまな現実のユースケースをサポートするクレート）*
  - [] <!--Functions expose intermediate results to avoid duplicate work ([C-INTERMEDIATE])-->
     重複作業を避けるために中間結果を公開する関数（[C-INTERMEDIATE]）
  - [] <!--Caller decides where to copy and place data ([C-CALLER-CONTROL])-->
     発信者はデータをコピーして配置する場所を決定します（[C-CALLER-CONTROL]）
  - [] <!--Functions minimize assumptions about parameters by using generics ([C-GENERIC])-->
     関数は、ジェネリック（[C-GENERIC]）を使用してパラメータに関する仮定を最小化します。
  - [] <!--Traits are object-safe if they may be useful as a trait object ([C-OBJECT])-->
     形質は、形質オブジェクト（[C-OBJECT]）として有用である場合には、オブジェクトセーフであり、
- <!--**Type safety** *(crate leverages the type system effectively)*-->
   **タイプの安全性** *（クレートはタイプシステムを効果的に活用します）*
  - [] <!--Newtypes provide static distinctions ([C-NEWTYPE])-->
     新しい[C-NEWTYPE]は静的な区別を提供します（[C-NEWTYPE]）
  - [] <!--Arguments convey meaning through types, not `bool` or `Option` ([C-CUSTOM-TYPE])-->
     引数は、`bool`や`Option`（ [C-CUSTOM-TYPE]）ではなく、型を通して意味を伝えます。
  - [] <!--Types for a set of flags are `bitflags`, not enums ([C-BITFLAG])-->
     フラグのセットのタイプは、`bitflags`フラグです。列挙型ではありません（[C-BITFLAG]）
  - [] <!--Builders enable construction of complex values ([C-BUILDER])-->
     ビルダーは複雑な値の構築を可能にする（[C-BUILDER]）
- <!--**Dependability** *(crate is unlikely to do the wrong thing)*-->
   **信頼性** *（クレートは間違ったことをする可能性は低い）*
  - [] <!--Functions validate their arguments ([C-VALIDATE])-->
     関数は引数を検証します（[C-VALIDATE]）
  - [] <!--Destructors never fail ([C-DTOR-FAIL])-->
     デストラクタは決して失敗しません（[C-DTOR-FAIL]）
  - [] <!--Destructors that may block have alternatives ([C-DTOR-BLOCK])-->
     ブロックする可能性のあるデストラクタには代替（[C-DTOR-BLOCK]）
- <!--**Debuggability** *(crate is conducive to easy debugging)*-->
   **デバッグ能力** *（クレートは簡単なデバッグに* **つながります** *）*
  - [] <!--All public types implement `Debug` ([C-DEBUG])-->
     すべてのパブリック・タイプは、`Debug`（ [C-DEBUG]）
  - [] <!--`Debug` representation is never empty ([C-DEBUG-NONEMPTY])-->
     `Debug`表現が空になることはありません（[C-DEBUG-NONEMPTY]）
- <!--**Future proofing** *(crate is free to improve without breaking users' code)*-->
   **将来の校正** *（クレートはユーザーのコードを壊すことなく改善することができます）*
  - [] <!--Sealed traits protect against downstream implementations ([C-SEALED])-->
     密閉された形質は下流の実装から保護します（[C-SEALED]）
  - [] <!--Structs have private fields ([C-STRUCT-PRIVATE])-->
     構造体にはプライベートフィールドがあります（[C-STRUCT-PRIVATE]）
  - [] <!--Newtypes encapsulate implementation details ([C-NEWTYPE-HIDE])-->
     Newtypesは実装の詳細をカプセル化します（[C-NEWTYPE-HIDE]）
  - [] <!--Data structures do not duplicate derived trait bounds ([C-STRUCT-BOUNDS])-->
     データ構造は、派生した特性境界を複製しません（[C-STRUCT-BOUNDS]）
- <!--**Necessities** *(to whom they matter, they really matter)*-->
   **必要性** *（誰にとって重要か、彼らは本当に重要です）*
  - [] <!--Public dependencies of a stable crate are stable ([C-STABLE])-->
     安定したクレートのパブリック依存関係は安定している（[C-STABLE]）
  - [] <!--Crate and its dependencies have a permissive license ([C-PERMISSIVE])-->
     クレートとその依存関係には許容ライセンスがあります（[C-PERMISSIVE]）


<!--[C-CASE]: naming.html#c-case
 [C-CONV]: naming.html#c-conv
 [C-GETTER]: naming.html#c-getter
 [C-ITER]: naming.html#c-iter
 [C-ITER-TY]: naming.html#c-iter-ty
 [C-FEATURE]: naming.html#c-feature
 [C-WORD-ORDER]: naming.html#c-word-order
-->
[C-CASE]: naming.html#c-case
 [C-CONV]: naming.html#c-conv
 [C-GETTER]: naming.html#c-getter
 [C-ITER]: naming.html#c-iter
 [C-ITER-TY]: naming.html#c-iter-ty
 [C-FEATURE]: naming.html#c-feature
 [C-WORD-ORDER]: naming.html#c-word-order


<!--[C-COMMON-TRAITS]: interoperability.html#c-common-traits
 [C-CONV-TRAITS]: interoperability.html#c-conv-traits
 [C-COLLECT]: interoperability.html#c-collect
 [C-SERDE]: interoperability.html#c-serde
 [C-SEND-SYNC]: interoperability.html#c-send-sync
 [C-GOOD-ERR]: interoperability.html#c-good-err
 [C-NUM-FMT]: interoperability.html#c-num-fmt
 [C-RW-VALUE]: interoperability.html#c-rw-value
-->
[C-COMMON-TRAITS]: interoperability.html#c-common-traits
 [C-CONV-TRAITS]: interoperability.html#c-conv-traits
 [C-COLLECT]: interoperability.html#c-collect
 [C-SERDE]: interoperability.html#c-serde
 [C-SEND-SYNC]: interoperability.html#c-send-sync
 [C-GOOD-ERR]: interoperability.html#c-good-err
 [C-NUM-FMT]: interoperability.html#c-num-fmt
 [C-RW-VALUE]: interoperability.html#c-rw-value


<!--[C-EVOCATIVE]: macros.html#c-evocative
 [C-MACRO-ATTR]: macros.html#c-macro-attr
 [C-ANYWHERE]: macros.html#c-anywhere
 [C-MACRO-VIS]: macros.html#c-macro-vis
 [C-MACRO-TY]: macros.html#c-macro-ty
-->
[C-EVOCATIVE]: macros.html#c-evocative
 [C-MACRO-ATTR]: macros.html#c-macro-attr
 [C-ANYWHERE]: macros.html#c-anywhere
 [C-MACRO-VIS]: macros.html#c-macro-vis
 [C-MACRO-TY]: macros.html#c-macro-ty


<!--[C-CRATE-DOC]: documentation.html#c-crate-doc
 [C-EXAMPLE]: documentation.html#c-example
 [C-QUESTION-MARK]: documentation.html#c-question-mark
 [C-FAILURE]: documentation.html#c-failure
 [C-LINK]: documentation.html#c-link
 [C-METADATA]: documentation.html#c-metadata
 [C-HTML-ROOT]: documentation.html#c-html-root
 [C-RELNOTES]: documentation.html#c-relnotes
 [C-HIDDEN]: documentation.html#c-hidden
-->
[C-CRATE-DOC]: documentation.html#c-crate-doc
 [C-EXAMPLE]: documentation.html#c-example
 [C-QUESTION-MARK]: documentation.html#c-question-mark
 [C-FAILURE]: documentation.html#c-failure
 [C-LINK]: documentation.html#c-link
 [C-METADATA]: documentation.html#c-metadata
 [C-HTML-ROOT]: documentation.html#c-html-root
 [C-RELNOTES]: documentation.html#c-relnotes
 [C-HIDDEN]: documentation.html#c-hidden


<!--[C-SMART-PTR]: predictability.html#c-smart-ptr
 [C-CONV-SPECIFIC]: predictability.html#c-conv-specific
 [C-METHOD]: predictability.html#c-method
 [C-NO-OUT]: predictability.html#c-no-out
 [C-OVERLOAD]: predictability.html#c-overload
 [C-DEREF]: predictability.html#c-deref
 [C-CTOR]: predictability.html#c-ctor
-->
[C-SMART-PTR]: predictability.html#c-smart-ptr
 [C-CONV-SPECIFIC]: predictability.html#c-conv-specific
 [C-METHOD]: predictability.html#c-method
 [C-NO-OUT]: predictability.html#c-no-out
 [C-OVERLOAD]: predictability.html#c-overload
 [C-DEREF]: predictability.html#c-deref
 [C-CTOR]: predictability.html#c-ctor


<!--[C-INTERMEDIATE]: flexibility.html#c-intermediate
 [C-CALLER-CONTROL]: flexibility.html#c-caller-control
 [C-GENERIC]: flexibility.html#c-generic
 [C-OBJECT]: flexibility.html#c-object
-->
[C-INTERMEDIATE]: flexibility.html#c-intermediate
 [C-CALLER-CONTROL]: flexibility.html#c-caller-control
 [C-GENERIC]: flexibility.html#c-generic
 [C-OBJECT]: flexibility.html#c-object


<!--[C-NEWTYPE]: type-safety.html#c-newtype
 [C-CUSTOM-TYPE]: type-safety.html#c-custom-type
 [C-BITFLAG]: type-safety.html#c-bitflag
 [C-BUILDER]: type-safety.html#c-builder
-->
[C-NEWTYPE]: type-safety.html#c-newtype
 [C-CUSTOM-TYPE]: type-safety.html#c-custom-type
 [C-BITFLAG]: type-safety.html#c-bitflag
 [C-BUILDER]: type-safety.html#c-builder


<!--[C-VALIDATE]: dependability.html#c-validate
 [C-DTOR-FAIL]: dependability.html#c-dtor-fail
 [C-DTOR-BLOCK]: dependability.html#c-dtor-block
-->
[C-VALIDATE]: dependability.html#c-validate
 [C-DTOR-FAIL]: dependability.html#c-dtor-fail
 [C-DTOR-BLOCK]: dependability.html#c-dtor-block


<!--[C-DEBUG]: debuggability.html#c-debug
 [C-DEBUG-NONEMPTY]: debuggability.html#c-debug-nonempty
-->
[C-DEBUG]: debuggability.html#c-debug
 [C-DEBUG-NONEMPTY]: debuggability.html#c-debug-nonempty


<!--[C-SEALED]: future-proofing.html#c-sealed
 [C-STRUCT-PRIVATE]: future-proofing.html#c-struct-private
 [C-NEWTYPE-HIDE]: future-proofing.html#c-newtype-hide
 [C-STRUCT-BOUNDS]: future-proofing.html#c-struct-bounds
-->
[C-SEALED]: future-proofing.html#c-sealed
 [C-STRUCT-PRIVATE]: future-proofing.html#c-struct-private
 [C-NEWTYPE-HIDE]: future-proofing.html#c-newtype-hide
 [C-STRUCT-BOUNDS]: future-proofing.html#c-struct-bounds


<!--[C-STABLE]: necessities.html#c-stable
 [C-PERMISSIVE]: necessities.html#c-permissive
-->
[C-STABLE]: necessities.html#c-stable
 [C-PERMISSIVE]: necessities.html#c-permissive

