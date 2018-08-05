# <!--Destructors--> デストラクタ

<!--What the language *does* provide is full-blown automatic destructors through the `Drop` trait, which provides the following method:-->
言語*が*提供しているのは、`Drop`属性を使用した完全な自動デストラクタです。これは、次の方法を提供します。

```rust,ignore
fn drop(&mut self);
```

<!--This method gives the type time to somehow finish what it was doing.-->
このメソッドは、それがやっていたことを何とかして終了する型の時間を与えます。

<!--**After `drop` is run, Rust will recursively try to drop all of the fields of `self`.**-->
**`drop`が実行された後、Rustは` self`のすべてのフィールドを再帰的に削除しようとします。**

<!--This is a convenience feature so that you don't have to write "destructor boilerplate"to drop children.-->
これは便利な機能なので、子を削除するために「デストラクタ定型文」を書く必要はありません。
<!--If a struct has no special logic for being dropped other than dropping its children, then it means `Drop` doesn't need to be implemented at all!-->
構造体に子をドロップする以外にドロップされる特別なロジックがない場合、`Drop`はまったく実装する必要がないことを意味します。

<!--**There is no stable way to prevent this behavior in Rust 1.0.**-->
**Rust 1.0でこの動作を防止する安定した方法はありません。**

<!--Note that taking `&mut self` means that even if you could suppress recursive Drop, Rust will prevent you from eg moving fields out of self.-->
`&mut self`を取ることは、たとえあなたが再帰的なドロップを抑制することができたとしても、Rustはフィールドを自分自身から移動させないようにします。
<!--For most types, this is totally fine.-->
ほとんどのタイプでは、これはまったく問題ありません。

<!--For instance, a custom implementation of `Box` might write `Drop` like this:-->
例えば、`Box`カスタム実装では、以下のように`Drop`書くことができます：

```rust
#![feature(ptr_internals, allocator_api, unique)]

use std::alloc::{Alloc, Global, GlobalAlloc, Layout};
use std::mem;
use std::ptr::{drop_in_place, NonNull, Unique};

struct Box<T>{ ptr: Unique<T> }

impl<T> Drop for Box<T> {
    fn drop(&mut self) {
        unsafe {
            drop_in_place(self.ptr.as_ptr());
            let c: NonNull<T> = self.ptr.into();
            Global.dealloc(c.cast(), Layout::new::<T>())
        }
    }
}
# fn main() {}
```

<!--and this works fine because when Rust goes to drop the `ptr` field it just sees a [Unique] that has no actual `Drop` implementation.-->
Rustが`ptr`フィールドをドロップすると、実際の`Drop`実装がない[Unique]が表示されるため、これはうまく`ptr`ます。
<!--Similarly nothing can use-after-free the `ptr` because when drop exits, it becomes inaccessible.-->
同様に、ドロップが終了するとアクセスできないため、`ptr`解放してから使用することはできません。

<!--However this wouldn't work:-->
しかし、これはうまくいかないでしょう：

```rust
#![feature(allocator_api, ptr_internals, unique)]

use std::alloc::{Alloc, Global, GlobalAlloc, Layout};
use std::ptr::{drop_in_place, Unique, NonNull};
use std::mem;

struct Box<T>{ ptr: Unique<T> }

impl<T> Drop for Box<T> {
    fn drop(&mut self) {
        unsafe {
            drop_in_place(self.ptr.as_ptr());
            let c: NonNull<T> = self.ptr.into();
            Global.dealloc(c.cast(), Layout::new::<T>());
        }
    }
}

struct SuperBox<T> { my_box: Box<T> }

impl<T> Drop for SuperBox<T> {
    fn drop(&mut self) {
        unsafe {
#            // Hyper-optimized: deallocate the box's contents for it
#            // without `drop`ing the contents
            // ハイパー最適化：内容を`drop`ことなくボックスのコンテンツの割り当てを解除する
            let c: NonNull<T> = self.my_box.ptr.into();
            Global.dealloc(c.cast::<u8>(), Layout::new::<T>());
        }
    }
}
# fn main() {}
```

<!--After we deallocate the `box` 's ptr in SuperBox's destructor, Rust will happily proceed to tell the box to Drop itself and everything will blow up with use-after-frees and double-frees.-->
スーパー`box`のデストラクタで`box`のptrの割り当てを解除した後、Rustは喜んでボックスをドロップするように進み、すべてが使用後に解放され、ダブルフリーになります。

<!--Note that the recursive drop behavior applies to all structs and enums regardless of whether they implement Drop.-->
再帰ドロップ動作は、Dropを実装するかどうかに関係なく、すべての構造体と列挙型に適用されます。
<!--Therefore something like-->
したがって、

```rust
struct Boxy<T> {
    data1: Box<T>,
    data2: Box<T>,
    info: u32,
}
```

<!--will have its data1 and data2's fields destructors whenever it "would"be dropped, even though it itself doesn't implement Drop.-->
drop自体がドロップを実装していなくても、ドロップされるたびにそのdata1とdata2のフィールドはデストラクタになります。
<!--We say that such a type *needs Drop*, even though it is not itself Drop.-->
私たちは、そのようなタイプ*はドロップ*ではないと言っていますが、それはドロップではありません。

<!--Similarly,-->
同様に、

```rust
enum Link {
    Next(Box<Link>),
    None,
}
```

<!--will have its inner Box field dropped if and only if an instance stores the Next variant.-->
インスタンスに次のバリアントが格納されている場合にのみ、その内部ボックスフィールドが削除されます。

<!--In general this works really nicely because you don't need to worry about adding/removing drops when you refactor your data layout.-->
一般に、これは本当にうまく動作します。なぜなら、データレイアウトをリファクタリングするときにドロップの追加/削除を心配する必要がないからです。
<!--Still there's certainly many valid usecases for needing to do trickier things with destructors.-->
確かに、デストラクタでやっかいなことをする必要があるため、多くの有効な用途があります。

<!--The classic safe solution to overriding recursive drop and allowing moving out of Self during `drop` is to use an Option:-->
再帰的なドロップをオーバーライドし、`drop`中にSelfから移動することを可能にする古典的な安全なソリューションは、Option：

```rust
#![feature(allocator_api, ptr_internals, unique)]

use std::alloc::{Alloc, GlobalAlloc, Global, Layout};
use std::ptr::{drop_in_place, Unique, NonNull};
use std::mem;

struct Box<T>{ ptr: Unique<T> }

impl<T> Drop for Box<T> {
    fn drop(&mut self) {
        unsafe {
            drop_in_place(self.ptr.as_ptr());
            let c: NonNull<T> = self.ptr.into();
            Global.dealloc(c.cast(), Layout::new::<T>());
        }
    }
}

struct SuperBox<T> { my_box: Option<Box<T>> }

impl<T> Drop for SuperBox<T> {
    fn drop(&mut self) {
        unsafe {
#            // Hyper-optimized: deallocate the box's contents for it
#            // without `drop`ing the contents. Need to set the `box`
#            // field as `None` to prevent Rust from trying to Drop it.
            // ハイパー最適化：内容を`drop`ことなくボックスのコンテンツの割り当てを解除します。錆がドロップしようとするのを防ぐには、`box`フィールドを`None`に設定する必要があり`box`。
            let my_box = self.my_box.take().unwrap();
            let c: NonNull<T> = my_box.ptr.into();
            Global.dealloc(c.cast(), Layout::new::<T>());
            mem::forget(my_box);
        }
    }
}
# fn main() {}
```

<!--However this has fairly odd semantics: you're saying that a field that *should* always be Some *may* be None, just because that happens in the destructor.-->
しかし、これはかなり奇妙な意味を持っている：あなたは、常にいくつかを*あるべき*分野はそれがデストラクタで起こるという理由だけで、Noneになる*かもしれ*ませんことを言っています。
<!--Of course this conversely makes a lot of sense: you can call arbitrary methods on self during the destructor, and this should prevent you from ever doing so after deinitializing the field.-->
もちろん、これは逆に意味があります。デストラクタ中に自分自身に任意のメソッドを呼び出すことができます。これにより、フィールドの初期化を解除した後も、これを実行できなくなります。
<!--Not that it will prevent you from producing any other arbitrarily invalid state in there.-->
そうでないと、そこに他の任意の無効な状態が生成されるのを防ぎます。

<!--On balance this is an ok choice.-->
バランスのとれたこれは良い選択です。
<!--Certainly what you should reach for by default.-->
確かにあなたはデフォルトで何を手に入れるべきですか？
<!--However, in the future we expect there to be a first-class way to announce that a field shouldn't be automatically dropped.-->
しかし、将来的には、フィールドが自動的に削除されるべきでないことを発表するファーストクラスの方法が存在することが期待されます。

[Unique]: phantom-data.html
