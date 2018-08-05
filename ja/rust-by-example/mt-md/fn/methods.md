# <!--Methods--> メソッド

<!--Methods are functions attached to objects.-->
メソッドは、オブジェクトに付属する関数です。
<!--These methods have access to the data of the object and its other methods via the `self` keyword.-->
これらのメソッドは、オブジェクトのデータおよび他のメソッドに`self`キーワードを使用してアクセスします。
<!--Methods are defined under an `impl` block.-->
メソッドは`impl`ブロックの下で定義されます。

```rust,editable
struct Point {
    x: f64,
    y: f64,
}

#// Implementation block, all `Point` methods go in here
// 実装ブロック、すべての`Point`メソッドがここに入る
impl Point {
#    // This is a static method
#    // Static methods don't need to be called by an instance
#    // These methods are generally used as constructors
    // これは静的メソッド静的メソッドはインスタンスによって呼び出される必要はありませんこれらのメソッドは一般にコンストラクタとして使用されます
    fn origin() -> Point {
        Point { x: 0.0, y: 0.0 }
    }

#    // Another static method, taking two arguments:
    // 別の静的メソッド.2つの引数をとります：
    fn new(x: f64, y: f64) -> Point {
        Point { x: x, y: y }
    }
}

struct Rectangle {
    p1: Point,
    p2: Point,
}

impl Rectangle {
#    // This is an instance method
#    // `&self` is sugar for `self: &Self`, where `Self` is the type of the
#    // caller object. In this case `Self` = `Rectangle`
    // これはインスタンスメソッドです。`&self`は`self: &Self`砂糖です。ここで`Self`は呼び出し元オブジェクトの型です。この場合、`Self` = `Rectangle`
    fn area(&self) -> f64 {
#        // `self` gives access to the struct fields via the dot operator
        //  `self`はドット演算子を介してstructフィールドにアクセスします
        let Point { x: x1, y: y1 } = self.p1;
        let Point { x: x2, y: y2 } = self.p2;

#        // `abs` is a `f64` method that returns the absolute value of the
#        // caller
        //  `abs`は呼び出し元の絶対値を返す`f64`メソッドです
        ((x1 - x2) * (y1 - y2)).abs()
    }

    fn perimeter(&self) -> f64 {
        let Point { x: x1, y: y1 } = self.p1;
        let Point { x: x2, y: y2 } = self.p2;

        2.0 * ((x1 - x2).abs() + (y1 - y2).abs())
    }

#    // This method requires the caller object to be mutable
#    // `&mut self` desugars to `self: &mut Self`
    // このメソッドでは、呼び出し側オブジェクトをmutable `&mut self` desugarsにする必要があります`self: &mut Self`
    fn translate(&mut self, x: f64, y: f64) {
        self.p1.x += x;
        self.p2.x += x;

        self.p1.y += y;
        self.p2.y += y;
    }
}

#// `Pair` owns resources: two heap allocated integers
//  `Pair`はリソースを所有しています：2つのヒープ割り当て整数
struct Pair(Box<i32>, Box<i32>);

impl Pair {
#    // This method "consumes" the resources of the caller object
#    // `self` desugars to `self: Self`
    // このメソッドは、呼び出し元オブジェクトのリソースを`self`消費者に「消費する」 `self: Self`
    fn destroy(self) {
#        // Destructure `self`
        //  `self`破壊`self`
        let Pair(first, second) = self;

        println!("Destroying Pair({}, {})", first, second);

#        // `first` and `second` go out of scope and get freed
        //  `first`と`second`が範囲外に出て解放される
    }
}

fn main() {
    let rectangle = Rectangle {
#        // Static methods are called using double colons
        // 静的メソッドは、二重コロンを使用して呼び出されます。
        p1: Point::origin(),
        p2: Point::new(3.0, 4.0),
    };

#    // Instance methods are called using the dot operator
#    // Note that the first argument `&self` is implicitly passed, i.e.
#    // `rectangle.perimeter()` === `Rectangle::perimeter(&rectangle)`
    // インスタンスメソッドはドット演算子を使って呼び出されます。最初の引数`&self`は暗黙的に渡されます。つまり、`rectangle.perimeter()` === `Rectangle::perimeter(&rectangle)`
    println!("Rectangle perimeter: {}", rectangle.perimeter());
    println!("Rectangle area: {}", rectangle.area());

    let mut square = Rectangle {
        p1: Point::origin(),
        p2: Point::new(1.0, 1.0),
    };

#    // Error! `rectangle` is immutable, but this method requires a mutable
#    // object
    // エラー！ `rectangle`は不変ですが、このメソッドは可変オブジェクトが必要です
    //rectangle.translate(1.0, 0.0);
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる

#    // Okay! Mutable objects can call mutable methods
    // はい！変更可能なオブジェクトは、変更可能なメソッドを呼び出すことができます
    square.translate(1.0, 1.0);

    let pair = Pair(Box::new(1), Box::new(2));

    pair.destroy();

#    // Error! Previous `destroy` call "consumed" `pair`
    // エラー！前のコール "消耗した"`pair` `destroy`
    //pair.destroy();
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる
}
```
