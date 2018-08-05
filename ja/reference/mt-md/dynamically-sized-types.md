# <!--Dynamically Sized Types--> 動的にサイズの変更された型

<!--Most types have a fixed size that is known at compile time and implement the trait [`Sized`][sized].-->
ほとんどのタイプは、コンパイル時に知られており、特色実装された固定サイズ持っている[`Sized`][sized]。
<!--A type with a size that is known only at run-time is called a  _dynamically sized type_  ( _DST_ ) or, informally, an unsized type.-->
実行時にしかわかっていない _サイズの型_ は、 _動的サイズ型_ （  _DST_ ）と呼ばれ、非形式 _型_ とも呼ばれます。
<!--[Slices] and [trait objects] are two examples of RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTsRawInline (Format "html") "</abbr>".-->
[Slices]と[trait objects]は、RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTのRawInline (Format "html") "</abbr>" 2つの例です。
<!--Such types can only be used in certain cases:-->
そのようなタイプは、特定の場合にのみ使用できます。

* <!--[Pointer types] to RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTsRawInline (Format "html") "</abbr>" are sized but have twice the size of pointers to sized types-->
   RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTRawInline (Format "html") "</abbr>"への[Pointer types]は、サイズが設定されていますが、サイズ型のポインタのサイズの2倍です
    * <!--Pointers to slices also store the number of elements of the slice.-->
       スライスへのポインタには、スライスの要素数も格納されます。
    * <!--Pointers to trait objects also store a pointer to a vtable.-->
       特性オブジェクトへのポインタは、vtableへのポインタも格納します。
* <!--RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTsRawInline (Format "html") "</abbr>" can be provided as type arguments when a bound of `?Sized`.-->
   `?Sized`境界がある場合、RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTRawInline (Format "html") "</abbr>"は型引数として提供できます。
<!--By default any type parameter has a `Sized` bound.-->
   デフォルトでは、どの型パラメータも`Sized`境界を持ちます。
* <!--Traits may be implemented for RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTsRawInline (Format "html") "</abbr>".-->
   RawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"DSTのRawInline (Format "html") "</abbr>"ためにRawInline (Format "html") "<abbr title=\"\21205\30340\12395\12469\12452\12474\12434\25351\23450\12377\12427\22411\">"形質をRawInline (Format "html") "</abbr>"実装することができます。
<!--Unlike type parameters `Self: ?Sized` by default in trait definitions.-->
   タイプパラメータとは異なり、`Self: ?Sized`デフォルトでは、特性定義に`Self: ?Sized`が設定されています。
* <!--Structs may contain a RawInline (Format "html") "<abbr title=\"\12480\12452\12490\12511\12483\12463\12469\12452\12474\12398\12479\12452\12503\">"DSTRawInline (Format "html") "</abbr>" as the last field, this makes the struct itself a RawInline (Format "html") "<abbr title=\"\12480\12452\12490\12511\12483\12463\12469\12452\12474\12398\12479\12452\12503\">"DSTRawInline (Format "html") "</abbr>".-->
   構造体は最後のフィールドとしてRawInline (Format "html") "<abbr title=\"\12480\12452\12490\12511\12483\12463\12469\12452\12474\12398\12479\12452\12503\">"DSTRawInline (Format "html") "</abbr>"を含むことができます。これにより、構造体自体がRawInline (Format "html") "<abbr title=\"\12480\12452\12490\12511\12483\12463\12469\12452\12474\12398\12479\12452\12503\">"DSTになりRawInline (Format "html") "</abbr>"ます。

<!--Notably: [variables], function parameters, [const] and [static] items must be `Sized`.-->
注目すべきは、[variables]、関数パラメータ、 [const]および[static]項目が`Sized`です。

<!--[sized]: special-types-and-traits.html#sized
 [Slices]: types.html#array-and-slice-types
 [trait objects]: types.html#trait-objects
 [Pointer types]: types.html#pointer-types
 [variables]: variables.html
 [const]: items/constant-items.html
 [static]: items/static-items.html
-->
[sized]: special-types-and-traits.html#sized
 [Slices]: types.html#array-and-slice-types
 [trait objects]: types.html#trait-objects
 [Pointer types]: types.html#pointer-types
 [variables]: variables.html
 [const]: items/constant-items.html
 [static]: items/static-items.html

