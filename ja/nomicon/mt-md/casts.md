# <!--Casts--> キャスト

<!--Casts are a superset of coercions: every coercion can be explicitly invoked via a cast.-->
キャストは強制的に強制的に呼び出されます。すべての強制はキャストによって明示的に呼び出すことができます。
<!--However some conversions require a cast.-->
しかし、いくつかの変換にはキャストが必要です。
<!--While coercions are pervasive and largely harmless, these "true casts"are rare and potentially dangerous.-->
強制的に普及し、ほとんど無害ですが、これらの「真のキャスト」はまれで潜在的に危険です。
<!--As such, casts must be explicitly invoked using the `as` keyword: `expr as Type`.-->
そのため、キャストは`as`キーワード`as`： `expr as Type`を使用して明示的に呼び出さなければなりません。

<!--True casts generally revolve around raw pointers and the primitive numeric types.-->
真のキャストは、一般に、生ポインタとプリミティブな数値型を中心にしています。
<!--Even though they're dangerous, these casts are infallible at runtime.-->
彼らは危険ですが、実行時にこれらのキャストは間違いありません。
<!--If a cast triggers some subtle corner case no indication will be given that this occurred.-->
キャストによって微妙なコーナーケースがトリガされた場合、これは発生していないことが示されます。
<!--The cast will simply succeed.-->
キャストは単に成功するでしょう。
<!--That said, casts must be valid at the type level, or else they will be prevented statically.-->
つまり、キャストは型レベルで有効でなければなりません。さもなければ、キャストは静的に防止されます。
<!--For instance, `7u8 as bool` will not compile.-->
たとえば、`7u8 as bool`はコンパイルされません。

<!--That said, casts aren't `unsafe` because they generally can't violate memory safety *on their own*.-->
つまり、キャストは一般的*に自分自身で*メモリの安全性*に*違反することはできないため、`unsafe`はありませ`unsafe`。
<!--For instance, converting an integer to a raw pointer can very easily lead to terrible things.-->
たとえば、整数を生ポインタに変換すると、非常に簡単に恐ろしいことにつながる可能性があります。
<!--However the act of creating the pointer itself is safe, because actually using a raw pointer is already marked as `unsafe`.-->
実際には未加工のポインタを使用しているので、すでに`unsafe`マークされているので、ポインタ自体を作成する動作は`unsafe`です。

<!--Here's an exhaustive list of all the true casts.-->
すべての真のキャストの網羅的なリストです。
<!--For brevity, we will use `*` to denote either a `*const` or `*mut`, and `integer` to denote any integral primitive:-->
簡潔にするために、a `*const`または`*mut`いずれかを表すために`*`を使用します。また、`integer`は整数プリミティブを示すために使用されます。

 * <!--`*T as *U` where `T, U: Sized`-->
    `*T as *U`ここで`T, U: Sized`
 * <!--`*T as *U` TODO: explain unsized situation-->
    `*T as *U` TODO：説明されていない状況
 * `*T as integer`
 * `integer as *T`
 * `number as number`
 * `field-less enum as integer`
 * `bool as integer`
 * `char as integer`
 * `u8 as char`
 * `&[T; n] as *const T`
 * <!--`fn as *T` where `T: Sized`-->
    `fn as *T`、 `T: Sized`
 * `fn as integer`

<!--Note that lengths are not adjusted when casting raw slices -`*const [u16] as *const [u8]` creates a slice that only includes half of the original memory.-->
生スライスをキャストするときに長さが調整されないことに注意してください。`*const [u16] as *const [u8]`は元のメモリの半分しか含まないスライスを作成します。

<!--Casting is not transitive, that is, even if `e as U1 as U2` is a valid expression, `e as U2` is not necessarily so.-->
キャスティングは推移的ではありません。すなわち、たとえ`e as U1 as U2`が有効な式であっても、`e as U2`は必ずしもそうであるとは限りません。

<!--For numeric casts, there are quite a few cases to consider:-->
数値キャストの場合、考慮する必要があります。

* <!--casting between two integers of the same size (eg i32 -> u32) is a no-op-->
   同じサイズの2つの整数間のキャスト（例：i32 -> u32）はノーオペレーションです
* <!--casting from a larger integer to a smaller integer (eg u32 -> u8) will truncate-->
   より大きな整数からより小さな整数（例えば、u32 -> u8）へのキャストは、
* <!--casting from a smaller integer to a larger integer (eg u8 -> u32) will-->
   小さな整数から大きな整数へのキャスト（例：u8 -> u32）
    * <!--zero-extend if the source is unsigned-->
       ソースが符号なしの場合はゼロ拡張
    * <!--sign-extend if the source is signed-->
       ソースが署名されている場合は符号拡張する
* <!--casting from a float to an integer will round the float towards zero-->
   浮動小数点から整数へのキャストは浮動小数点をゼロに向かって丸めます
    * <!--**[NOTE: currently this will cause Undefined Behavior if the rounded value cannot be represented by the target integer type][float-int]**.-->
       **[注記：現在、丸められた値をターゲット整数型で表現できない場合、未定義の振る舞いが発生します] [float-int]**。
<!--This includes Inf and NaN.-->
       これには、InfとNaNが含まれます。
<!--This is a bug and will be fixed.-->
       これはバグであり修正される予定です。
* <!--casting from an integer to float will produce the floating point representation of the integer, rounded if necessary (rounding to nearest, ties to even)-->
   整数から浮動小数点へのキャストは整数の浮動小数点表現を生成し、必要に応じて四捨五入します（最も近いものに四捨五入して偶数に結びます）
* <!--casting from an f32 to an f64 is perfect and lossless-->
   f32からf64へのキャストは完璧でロスレスです
* <!--casting from an f64 to an f32 will produce the closest possible value (rounding to nearest, ties to even)-->
   f64からf32へのキャストは、可能な限り近い値を生成します（最も近い値に四捨五入、偶数に結びつける）


[float-int]: https://github.com/rust-lang/rust/issues/10184
