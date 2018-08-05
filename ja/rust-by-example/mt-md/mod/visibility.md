# <!--Visibility--> 可視性

<!--By default, the items in a module have private visibility, but this can be overridden with the `pub` modifier.-->
デフォルトでは、モジュール内の項目にはプライベートな可視性がありますが、これは`pub`修飾子でオーバーライドできます。
<!--Only the public items of a module can be accessed from outside the module scope.-->
モジュールスコープの外部からアクセスできるのは、モジュールの公開アイテムだけです。

```rust,editable
#// A module named `my_mod`
//  `my_mod`という名前のモジュール
mod my_mod {
#    // Items in modules default to private visibility.
    // モジュールの項目は、デフォルトでプライベートな可視性になっています。
    fn private_function() {
        println!("called `my_mod::private_function()`");
    }

#    // Use the `pub` modifier to override default visibility.
    //  `pub`修飾子を使用すると、デフォルトの可視性を上書きできます。
    pub fn function() {
        println!("called `my_mod::function()`");
    }

#    // Items can access other items in the same module,
#    // even when private.
    // アイテムは、プライベートであっても、同じモジュール内の他のアイテムにアクセスできます。
    pub fn indirect_access() {
        print!("called `my_mod::indirect_access()`, that\n> ");
        private_function();
    }

#    // Modules can also be nested
    // モジュールはネストすることもできます
    pub mod nested {
        pub fn function() {
            println!("called `my_mod::nested::function()`");
        }

        #[allow(dead_code)]
        fn private_function() {
            println!("called `my_mod::nested::private_function()`");
        }

#        // Functions declared using `pub(in path)` syntax are only visible
#        // within the given path. `path` must be a parent or ancestor module
        //  `pub(in path)`構文を使用して宣言された関数は、指定されたパス内でのみ表示されます。`path`は親モジュールまたは祖先モジュールでなければなりません
        pub(in my_mod) fn public_function_in_my_mod() {
            print!("called `my_mod::nested::public_function_in_my_mod()`, that\n > ");
            public_function_in_nested()
        }

#        // Functions declared using `pub(self)` syntax are only visible within
#        // the current module
        //  `pub(self)`構文を使用して宣言された関数は、現在のモジュール内でのみ表示されます
        pub(self) fn public_function_in_nested() {
            println!("called `my_mod::nested::public_function_in_nested");
        }

#        // Functions declared using `pub(super)` syntax are only visible within
#        // the parent module
        //  `pub(super)`構文を使用して宣言された関数は、親モジュール内でのみ表示されます
        pub(super) fn public_function_in_super_mod() {
            println!("called my_mod::nested::public_function_in_super_mod");
        }
    }

    pub fn call_public_function_in_my_mod() {
        print!("called `my_mod::call_public_funcion_in_my_mod()`, that\n> ");
        nested::public_function_in_my_mod();
        print!("> ");
        nested::public_function_in_super_mod();
    }

#    // pub(crate) makes functions visible only within the current crate
    //  pub（crate）は、現在のクレート内でのみ関数を表示する
    pub(crate) fn public_function_in_crate() {
        println!("called `my_mod::public_function_in_crate()");
    }

#    // Nested modules follow the same rules for visibility
    // ネストされたモジュールは同じルールに従って表示されます
    mod private_nested {
        #[allow(dead_code)]
        pub fn function() {
            println!("called `my_mod::private_nested::function()`");
        }
    }
}

fn function() {
    println!("called `function()`");
}

fn main() {
#    // Modules allow disambiguation between items that have the same name.
    // モジュールは、同じ名前を持つアイテム間の曖昧さ回避を可能にします。
    function();
    my_mod::function();

#    // Public items, including those inside nested modules, can be
#    // accessed from outside the parent module.
    // ネストされたモジュールの内部アイテムを含むパブリックアイテムは、親モジュールの外部からアクセスできます。
    my_mod::indirect_access();
    my_mod::nested::function();
    my_mod::call_public_function_in_my_mod();

#    // pub(crate) items can be called from anywhere in the same crate
    // パブ（クレート）アイテムは同じクレートのどこからでも呼び出すことができます
    my_mod::public_function_in_crate();

#    // pub(in path) items can only be called from within the mode specified
#    // Error! function `public_function_in_my_mod` is private
    // パブ（パス内）アイテムは、指定されたモードで呼び出すことができます。エラー！ function `public_function_in_my_mod`はプライベートです
    //my_mod::nested::public_function_in_my_mod();
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる

#    // Private items of a module cannot be directly accessed, even if
#    // nested in a public module:
    // パブリックモジュールにネストされていても、モジュールのプライベートアイテムに直接アクセスすることはできません。

#    // Error! `private_function` is private
    // エラー！ `private_function`はプライベートです
    //my_mod::private_function();
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる

#    // Error! `private_function` is private
    // エラー！ `private_function`はプライベートです
    //my_mod::nested::private_function();
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる

#    // Error! `private_nested` is a private module
    // エラー！ `private_nested`はプライベートモジュールです
    //my_mod::private_nested::function();
#    // TODO ^ Try uncommenting this line
    //  TODO ^この行のコメントを外してみる
}
```
