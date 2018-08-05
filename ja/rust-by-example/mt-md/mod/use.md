# <!--The `use` declaration--> `use`宣言

<!--The `use` declaration can be used to bind a full path to a new name, for easier access.-->
`use`宣言を使用して、フルパスを新しい名前にバインドして、より簡単にアクセスすることができます。

```rust,editable
#// Bind the `deeply::nested::function` path to `other_function`.
//  `other_function` `deeply::nested::function`パスを`other_function`ます。
use deeply::nested::function as other_function;

fn function() {
    println!("called `function()`");
}

mod deeply {
    pub mod nested {
        pub fn function() {
            println!("called `deeply::nested::function()`");
        }
    }
}

fn main() {
#    // Easier access to `deeply::nested::function`
    //  deep `deeply::nested::function`へのより簡単なアクセス
    other_function();

    println!("Entering block");
    {
#        // This is equivalent to `use deeply::nested::function as function`.
#        // This `function()` will shadow the outer one.
        // これは`use deeply::nested::function as function`。この`function()`は外側のものをシャドウします。
        use deeply::nested::function;
        function();

#        // `use` bindings have a local scope. In this case, the
#        // shadowing of `function()` is only in this block.
        //  `use`バインディングにはローカルスコープがあります。この場合、`function()`シャドーイングはこのブロック内にのみあります。
        println!("Leaving block");
    }

    function();
}
```
