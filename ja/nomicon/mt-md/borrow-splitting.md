# <!--Splitting Borrows--> 分割借り

<!--The mutual exclusion property of mutable references can be very limiting when working with a composite structure.-->
変更可能な参照の相互排除プロパティは、複合構造を使用して作業する場合、非常に制限される可能性があります。
<!--The borrow checker understands some basic stuff, but will fall over pretty easily.-->
借用チェッカーはいくつかの基本的なことを理解していますが、かなり簡単に落ちます。
<!--It does understand structs sufficiently to know that it's possible to borrow disjoint fields of a struct simultaneously.-->
それは構造体の独立したフィールドを同時に借りることが可能であることを知るために構造体を十分に理解しています。
<!--So this works today:-->
それで今日はうまくいく：

```rust
struct Foo {
    a: i32,
    b: i32,
    c: i32,
}

let mut x = Foo {a: 0, b: 0, c: 0};
let a = &mut x.a;
let b = &mut x.b;
let c = &x.c;
*b += 1;
let c2 = &x.c;
*a += 10;
println!("{} {} {} {}", a, b, c, c2);
```

<!--However borrowck doesn't understand arrays or slices in any way, so this doesn't work:-->
しかし、borrowckは何らかの形で配列やスライスを理解していないので、これはうまくいきません：

```rust,ignore
let mut x = [1, 2, 3];
let a = &mut x[0];
let b = &mut x[1];
println!("{} {}", a, b);
```

```text
<anon>:4:14: 4:18 error: cannot borrow `x[..]` as mutable more than once at a time
<anon>:4 let b = &mut x[1];
                      ^~~~
<anon>:3:14: 3:18 note: previous borrow of `x[..]` occurs here; the mutable borrow prevents subsequent moves, borrows, or modification of `x[..]` until the borrow ends
<anon>:3 let a = &mut x[0];
                      ^~~~
<anon>:6:2: 6:2 note: previous borrow ends here
<anon>:1 fn main() {
<anon>:2 let mut x = [1, 2, 3];
<anon>:3 let a = &mut x[0];
<anon>:4 let b = &mut x[1];
<anon>:5 println!("{} {}", a, b);
<anon>:6 }
         ^
error: aborting due to 2 previous errors
```

<!--While it was plausible that borrowck could understand this simple case, it's pretty clearly hopeless for borrowck to understand disjointness in general container types like a tree, especially if distinct keys actually *do* map to the same value.-->
借り手がこの単純なケースを理解することは可能ですが、特に、別個のキーが実際に同じ値にマップされている場合は、借り手がツリーのような一般的なコンテナタイプのディスジョイントを理解することは明らかに望ましくあり*ません*。

<!--In order to "teach"borrowck that what we're doing is ok, we need to drop down to unsafe code.-->
私たちがやっていることが大丈夫だということを借り手に教えるには、安全でないコードに落とす必要があります。
<!--For instance, mutable slices expose a `split_at_mut` function that consumes the slice and returns two mutable slices.-->
例えば、可変スライスは、スライスを消費し、2つの可変スライスを返す`split_at_mut`関数を公開します。
<!--One for everything to the left of the index, and one for everything to the right.-->
1つはインデックスの左側にあり、もう1つはすべて右側にあります。
<!--Intuitively we know this is safe because the slices don't overlap, and therefore alias.-->
直感的にわかるように、スライスは重複しないため、エイリアスは安全です。
<!--However the implementation requires some unsafety:-->
しかし、実装には、いくつかの安全性が要求されます。

```rust,ignore
fn split_at_mut(&mut self, mid: usize) -> (&mut [T], &mut [T]) {
    let len = self.len();
    let ptr = self.as_mut_ptr();
    assert!(mid <= len);
    unsafe {
        (from_raw_parts_mut(ptr, mid),
         from_raw_parts_mut(ptr.offset(mid as isize), len - mid))
    }
}
```

<!--This is actually a bit subtle.-->
これは実際には少し微妙です。
<!--So as to avoid ever making two `&mut` 's to the same value, we explicitly construct brand-new slices through raw pointers.-->
2つの`&mut`同じ値にすることを避けるために、我々は明示的に生ポインタを使って真新しいスライスを構築します。

<!--However more subtle is how iterators that yield mutable references work.-->
しかし、より微妙なことは、変更可能な参照を生成するイテレータがどのように機能するかです。
<!--The iterator trait is defined as follows:-->
イテレータの特性は次のように定義されます。

```rust
trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}
```

<!--Given this definition, Self::Item has *no* connection to `self`.-->
この定義が与えられると、Self:: Itemは`self`へ*の*接続を持ち*ません*。
<!--This means that we can call `next` several times in a row, and hold onto all the results *concurrently*.-->
つまり、`next`の行を何度も呼び出すことができ、すべての結果を*同時に*保持することができます。
<!--This is perfectly fine for by-value iterators, which have exactly these semantics.-->
これは正確にこれらのセマンティクスを持つバイナリイテレータにとってはまったく問題ありません。
<!--It's also actually fine for shared references, as they admit arbitrarily many references to the same thing (although the iterator needs to be a separate object from the thing being shared).-->
実際には共有参照の場合も同じですが、同じことを複数の参照にすることは可能です（ただし、イテレータは共有オブジェクトとは別のオブジェクトである必要があります）。

<!--But mutable references make this a mess.-->
しかし、変更可能な参照はこれを混乱させます。
<!--At first glance, they might seem completely incompatible with this API, as it would produce multiple mutable references to the same object!-->
一見すると、同じオブジェクトへの複数の変更可能な参照を生成するため、このAPIと完全に互換性がないように見えるかもしれません。

<!--However it actually *does* work, exactly because iterators are one-shot objects.-->
しかし、イテレータはワンショットオブジェクトなので、実際に*は*動作します。
<!--Everything an IterMut yields will be yielded at most once, so we don't actually ever yield multiple mutable references to the same piece of data.-->
IterMutがもたらすすべてのものはたかだか1回しか返されないので、同じデータに複数の可変参照を実際に渡すことはありません。

<!--Perhaps surprisingly, mutable iterators don't require unsafe code to be implemented for many types!-->
多分、驚くべきことに、可変反復子は、安全でないコードを多くの型に対して実装する必要はありません！

<!--For instance here's a singly linked list:-->
例えば、ここには単独でリンクされたリストがあります：

```rust
# fn main() {}
type Link<T> = Option<Box<Node<T>>>;

struct Node<T> {
    elem: T,
    next: Link<T>,
}

pub struct LinkedList<T> {
    head: Link<T>,
}

pub struct IterMut<'a, T: 'a>(Option<&'a mut Node<T>>);

impl<T> LinkedList<T> {
    fn iter_mut(&mut self) -> IterMut<T> {
        IterMut(self.head.as_mut().map(|node| &mut **node))
    }
}

impl<'a, T> Iterator for IterMut<'a, T> {
    type Item = &'a mut T;

    fn next(&mut self) -> Option<Self::Item> {
        self.0.take().map(|node| {
            self.0 = node.next.as_mut().map(|node| &mut **node);
            &mut node.elem
        })
    }
}
```

<!--Here's a mutable slice:-->
ここには可変スライスがあります：

```rust
# fn main() {}
use std::mem;

pub struct IterMut<'a, T: 'a>(&'a mut[T]);

impl<'a, T> Iterator for IterMut<'a, T> {
    type Item = &'a mut T;

    fn next(&mut self) -> Option<Self::Item> {
        let slice = mem::replace(&mut self.0, &mut []);
        if slice.is_empty() { return None; }

        let (l, r) = slice.split_at_mut(1);
        self.0 = r;
        l.get_mut(0)
    }
}

impl<'a, T> DoubleEndedIterator for IterMut<'a, T> {
    fn next_back(&mut self) -> Option<Self::Item> {
        let slice = mem::replace(&mut self.0, &mut []);
        if slice.is_empty() { return None; }

        let new_len = slice.len() - 1;
        let (l, r) = slice.split_at_mut(new_len);
        self.0 = l;
        r.get_mut(0)
    }
}
```

<!--And here's a binary tree:-->
ここにバイナリツリーがあります：

```rust
# fn main() {}
use std::collections::VecDeque;

type Link<T> = Option<Box<Node<T>>>;

struct Node<T> {
    elem: T,
    left: Link<T>,
    right: Link<T>,
}

pub struct Tree<T> {
    root: Link<T>,
}

struct NodeIterMut<'a, T: 'a> {
    elem: Option<&'a mut T>,
    left: Option<&'a mut Node<T>>,
    right: Option<&'a mut Node<T>>,
}

enum State<'a, T: 'a> {
    Elem(&'a mut T),
    Node(&'a mut Node<T>),
}

pub struct IterMut<'a, T: 'a>(VecDeque<NodeIterMut<'a, T>>);

impl<T> Tree<T> {
    pub fn iter_mut(&mut self) -> IterMut<T> {
        let mut deque = VecDeque::new();
        self.root.as_mut().map(|root| deque.push_front(root.iter_mut()));
        IterMut(deque)
    }
}

impl<T> Node<T> {
    pub fn iter_mut(&mut self) -> NodeIterMut<T> {
        NodeIterMut {
            elem: Some(&mut self.elem),
            left: self.left.as_mut().map(|node| &mut **node),
            right: self.right.as_mut().map(|node| &mut **node),
        }
    }
}


impl<'a, T> Iterator for NodeIterMut<'a, T> {
    type Item = State<'a, T>;

    fn next(&mut self) -> Option<Self::Item> {
        match self.left.take() {
            Some(node) => Some(State::Node(node)),
            None => match self.elem.take() {
                Some(elem) => Some(State::Elem(elem)),
                None => match self.right.take() {
                    Some(node) => Some(State::Node(node)),
                    None => None,
                }
            }
        }
    }
}

impl<'a, T> DoubleEndedIterator for NodeIterMut<'a, T> {
    fn next_back(&mut self) -> Option<Self::Item> {
        match self.right.take() {
            Some(node) => Some(State::Node(node)),
            None => match self.elem.take() {
                Some(elem) => Some(State::Elem(elem)),
                None => match self.left.take() {
                    Some(node) => Some(State::Node(node)),
                    None => None,
                }
            }
        }
    }
}

impl<'a, T> Iterator for IterMut<'a, T> {
    type Item = &'a mut T;
    fn next(&mut self) -> Option<Self::Item> {
        loop {
            match self.0.front_mut().and_then(|node_it| node_it.next()) {
                Some(State::Elem(elem)) => return Some(elem),
                Some(State::Node(node)) => self.0.push_front(node.iter_mut()),
                None => if let None = self.0.pop_front() { return None },
            }
        }
    }
}

impl<'a, T> DoubleEndedIterator for IterMut<'a, T> {
    fn next_back(&mut self) -> Option<Self::Item> {
        loop {
            match self.0.back_mut().and_then(|node_it| node_it.next_back()) {
                Some(State::Elem(elem)) => return Some(elem),
                Some(State::Node(node)) => self.0.push_back(node.iter_mut()),
                None => if let None = self.0.pop_back() { return None },
            }
        }
    }
}
```

<!--All of these are completely safe and work on stable Rust!-->
これらのすべては完全に安全で、安定した錆に取り組んでいます！
<!--This ultimately falls out of the simple struct case we saw before: Rust understands that you can safely split a mutable reference into subfields.-->
これは最終的に私が見たシンプルな構造体のケースから逸脱しています。Rustは、可変参照を安全にサブフィールドに分割できることを理解しています。
<!--We can then encode permanently consuming a reference via Options (or in the case of slices, replacing with an empty slice).-->
その後、オプションを使用してリファレンスを消費する（またはスライスの場合は空のスライスに置き換えて）永久にエンコードすることができます。
