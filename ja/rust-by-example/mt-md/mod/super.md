# <!--`super` and `self`--> `super`と`self`

<!--The `super` and `self` keywords can be used in the path to remove ambiguity when accessing items and to prevent unnecessary hardcoding of paths.-->
項目にアクセスする際の曖昧さを除去し、パスの不必要なハードコーディングを防止するために、`super`キーワードと`self`キーワードをパスで使用できます。

```rust,editable
fn function() {
    println!("called `function()`");
}

mod cool {
    pub fn function() {
        println!("called `cool::function()`");
    }
}

mod my {
    fn function() {
        println!("called `my::function()`");
    }
    
    mod cool {
        pub fn function() {
            println!("called `my::cool::function()`");
        }
    }
    
    pub fn indirect_call() {
#        // Let's access all the functions named `function` from this scope!
        // のは、名前のすべての機能にアクセスしてみましょう`function`、この範囲から！
        print!("called `my::indirect_call()`, that\n> ");
        
#        // The `self` keyword refers to the current module scope - in this case `my`.
#        // Calling `self::function()` and calling `function()` directly both give
#        // the same result, because they refer to the same function.
        //  `self`キーワードは、現在のモジュールスコープ（この場合は`my`ます。`self::function()`を呼び出すと`function()`直接呼び出すと、同じ関数を参照するため、同じ結果が得られます。
        self::function();
        function();
        
#        // We can also use `self` to access another module inside `my`:
        //  `self`を使って`my`中の別のモジュールにアクセスすることもできます：
        self::cool::function();
        
#        // The `super` keyword refers to the parent scope (outside the `my` module).
        //  `super`キーワードは親スコープ（`my`モジュールの外側）を参照します。
        super::function();
        
#        // This will bind to the `cool::function` in the *crate* scope.
#        // In this case the crate scope is the outermost scope.
        // これは*crate*スコープ内の`cool::function`にバインドされます。この場合、クレートスコープは最も外側のスコープです。
        {
            use cool::function as root_function;
            root_function();
        }
    }
}

fn main() {
    my::indirect_call();
}
```
