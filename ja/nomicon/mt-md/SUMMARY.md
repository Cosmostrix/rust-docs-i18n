# <!--Summary--> 概要

[Introduction](README.md)
* <!--[Meet Safe and Unsafe](meet-safe-and-unsafe.md)-->
   [安全で安心して会う](meet-safe-and-unsafe.md)
	* <!--[How Safe and Unsafe Interact](safe-unsafe-meaning.md)-->
    [どのように安全で安全でないかインタラクト](safe-unsafe-meaning.md)
	* <!--[What Unsafe Can Do](what-unsafe-does.md)-->
    [安全でないことができること](what-unsafe-does.md)
	* <!--[Working with Unsafe](working-with-unsafe.md)-->
    [危険な作業](working-with-unsafe.md)
* <!--[Data Layout](data.md)-->
   [データレイアウト](data.md)
	* [repr(Rust)](repr-rust.md)
	* <!--[Exotically Sized Types](exotic-sizes.md)-->
    [外来サイズのタイプ](exotic-sizes.md)
	* <!--[Other reprs](other-reprs.md)-->
    [他のreprs](other-reprs.md)
* [Ownership](ownership.md)
	* [References](references.md)
	* [Aliasing](aliasing.md)
	* [Lifetimes](lifetimes.md)
	* <!--[Limits of Lifetimes](lifetime-mismatch.md)-->
    [生涯の限界](lifetime-mismatch.md)
	* <!--[Lifetime Elision](lifetime-elision.md)-->
    [ライフタイムエリート](lifetime-elision.md)
	* <!--[Unbounded Lifetimes](unbounded-lifetimes.md)-->
    [無限の生涯](unbounded-lifetimes.md)
	* <!--[Higher-Rank Trait Bounds](hrtb.md)-->
    [高ランク特性限界](hrtb.md)
	* <!--[Subtyping and Variance](subtyping.md)-->
    [サブタイプと差異](subtyping.md)
	* <!--[Drop Check](dropck.md)-->
    [ドロップチェック](dropck.md)
	* [PhantomData](phantom-data.md)
	* <!--[Splitting Borrows](borrow-splitting.md)-->
    [分割借り](borrow-splitting.md)
* <!--[Type Conversions](conversions.md)-->
   [タイプ変換](conversions.md)
	* [Coercions](coercions.md)
	* <!--[The Dot Operator](dot-operator.md)-->
    [ドット演算子](dot-operator.md)
	* [Casts](casts.md)
	* [Transmutes](transmutes.md)
* <!--[Uninitialized Memory](uninitialized.md)-->
   [初期化されていないメモリ](uninitialized.md)
	* [Checked](checked-uninit.md)
	* <!--[Drop Flags](drop-flags.md)-->
    [ドロップフラグ](drop-flags.md)
	* [Unchecked](unchecked-uninit.md)
* <!--[Ownership Based Resource Management](obrm.md)-->
   [所有権ベースのリソース管理](obrm.md)
	* [Constructors](constructors.md)
	* [Destructors](destructors.md)
	* [Leaking](leaking.md)
* [Unwinding](unwinding.md)
	* <!--[Exception Safety](exception-safety.md)-->
    [例外の安全性](exception-safety.md)
	* [Poisoning](poisoning.md)
* [Concurrency](concurrency.md)
	* [Races](races.md)
	* <!--[Send and Sync](send-and-sync.md)-->
    [送信と同期](send-and-sync.md)
	* [Atomics](atomics.md)
* <!--[Implementing Vec](vec.md)-->
   [Vecの実装](vec.md)
	* [Layout](vec-layout.md)
	* [Allocating](vec-alloc.md)
	* <!--[Push and Pop](vec-push-pop.md)-->
    [プッシュアンドポップ](vec-push-pop.md)
	* [Deallocating](vec-dealloc.md)
	* [Deref](vec-deref.md)
	* <!--[Insert and Remove](vec-insert-remove.md)-->
    [挿入と削除](vec-insert-remove.md)
	* [IntoIter](vec-into-iter.md)
	* [RawVec](vec-raw.md)
	* [Drain](vec-drain.md)
	* <!--[Handling Zero-Sized Types](vec-zsts.md)-->
    [ゼロサイズの型の処理](vec-zsts.md)
	* <!--[Final Code](vec-final.md)-->
    [最終コード](vec-final.md)
* <!--[Implementing Arc and Mutex](arc-and-mutex.md)-->
   [アークとミューテックスの実装](arc-and-mutex.md)
* [FFI](ffi.md)
