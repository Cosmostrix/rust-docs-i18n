# <!--Traits--> 形質

<!--A `trait` is a collection of methods defined for an unknown type: `Self`.-->
`trait`未知のタイプのために定義されたメソッドの集合です： `Self`。
<!--They can access other methods declared in the same trait.-->
彼らは同じ特性で宣言された他のメソッドにアクセスすることができます。

<!--Traits can be implemented for any data type.-->
形質は、任意のデータ型に対して実施することができる。
<!--In the example below, we define `Animal`, a group of methods.-->
以下の例では、メソッドのグループである`Animal`を定義します。
<!--The `Animal` `trait` is then implemented for the `Sheep` data type, allowing the use of methods from `Animal` with a `Sheep`.-->
次に、`Sheep`データ型の`Animal` `trait`が実装され、`Animal` with a `Sheep`メソッドを使用できます。

```rust,editable
struct Sheep { naked: bool, name: &'static str }

trait Animal {
#    // Static method signature; `Self` refers to the implementor type.
    // 静的メソッドのシグネチャ。`Self`とは、実装者のタイプを指します。
    fn new(name: &'static str) -> Self;

#    // Instance method signatures; these will return a string.
    // インスタンスメソッドのシグネチャ。これらは文字列を返します。
    fn name(&self) -> &'static str;
    fn noise(&self) -> &'static str;

#    // Traits can provide default method definitions.
    // 形質は、デフォルトのメソッド定義を提供することができます。
    fn talk(&self) {
        println!("{} says {}", self.name(), self.noise());
    }
}

impl Sheep {
    fn is_naked(&self) -> bool {
        self.naked
    }

    fn shear(&mut self) {
        if self.is_naked() {
#            // Implementor methods can use the implementor's trait methods.
            //  Implementorメソッドは、実装者のTraitメソッドを使用できます。
            println!("{} is already naked...", self.name());
        } else {
            println!("{} gets a haircut!", self.name);

            self.naked = true;
        }
    }
}

#// Implement the `Animal` trait for `Sheep`.
//  `Sheep`ための`Animal`特性を実装する。
impl Animal for Sheep {
#    // `Self` is the implementor type: `Sheep`.
    //  `Self`は実装者のタイプです： `Sheep`。
    fn new(name: &'static str) -> Sheep {
        Sheep { name: name, naked: false }
    }

    fn name(&self) -> &'static str {
        self.name
    }

    fn noise(&self) -> &'static str {
        if self.is_naked() {
            "baaaaah?"
        } else {
            "baaaaah!"
        }
    }
    
#    // Default trait methods can be overridden.
    // デフォルトの形質メソッドはオーバーライドできます。
    fn talk(&self) {
#        // For example, we can add some quiet contemplation.
        // たとえば、静かな熟考を加えることができます。
        println!("{} pauses briefly... {}", self.name, self.noise());
    }
}

fn main() {
#    // Type annotation is necessary in this case.
    // この場合、型注釈が必要です。
    let mut dolly: Sheep = Animal::new("Dolly");
#    // TODO ^ Try removing the type annotations.
    //  TODO ^型の注釈を削除してみてください。

    dolly.talk();
    dolly.shear();
    dolly.talk();
}
```
