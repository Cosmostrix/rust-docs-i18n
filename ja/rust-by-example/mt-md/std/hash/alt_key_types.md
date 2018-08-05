# <!--Alternate/custom key types--> 代替/カスタムキータイプ

<!--Any type that implements the `Eq` and `Hash` traits can be a key in `HashMap`.-->
`Eq`および`Hash`特性を実装するすべての型は、`HashMap`キーになります。
<!--This includes:-->
これも：

* <!--`bool` (though not very useful since there is only two possible keys)-->
   `bool`（可能なキーは2つしかないのであまり役に立ちませんが）
* <!--`int`, `uint`, and all variations thereof-->
   `int`、 `uint`、およびそのすべての変形
* <!--`String` and `&str` (protip: you can have a `HashMap` keyed by `String`-->
   `String`と`&str`（protip：あなたは`HashMap`を`String`キーすることができます
<!--and call `.get()` with an `&str`)-->
`&str` `.get()`を`&str`と呼ぶ）

<!--Note that `f32` and `f64` do *not* implement `Hash`, likely because [floating-point precision errors][floating] would make using them as hashmap keys horribly error-prone.-->
`f32`と`f64`は`Hash`実装してい*ない*ことに注意してください。[浮動小数点精度エラー][floating]はハッシュマップキーとしてエラーを起こしやすいためです。

<!--All collection classes implement `Eq` and `Hash` if their contained type also respectively implements `Eq` and `Hash`.-->
含まれる型がそれぞれ`Eq`と`Hash`実装している場合、すべてのコレクションクラスは`Eq`と`Hash`実装します。
<!--For example, `Vec<T>` will implement `Hash` if `T` implements `Hash`.-->
例えば、`Vec<T>`を実装します`Hash`場合`T`実装`Hash`。

<!--You can easily implement `Eq` and `Hash` for a custom type with just one line: `#[derive(PartialEq, Eq, Hash)]`-->
1つの行でカスタム型の`Eq`と`Hash`を簡単に実装できます： `#[derive(PartialEq, Eq, Hash)]`

<!--The compiler will do the rest.-->
コンパイラは残りの処理を行います。
<!--If you want more control over the details, you can implement `Eq` and/or `Hash` yourself.-->
詳細をより詳細に制御したい場合は、`Eq`や`Hash`自分で実装することができます。
<!--This guide will not cover the specifics of implementing `Hash`.-->
このガイドでは、`Hash`の実装の詳細は`Hash`ません。

<!--To play around with using a `struct` in `HashMap`, let's try making a very simple user logon system:-->
`HashMap`で`struct`を使って遊ぶために、非常に簡単なユーザログオンシステムを作ろう：

```rust,editable
use std::collections::HashMap;

#// Eq requires that you derive PartialEq on the type.
//  Eqでは、型に対してPartialEqを派生させる必要があります。
#[derive(PartialEq, Eq, Hash)]
struct Account<'a>{
    username: &'a str,
    password: &'a str,
}

struct AccountInfo<'a>{
    name: &'a str,
    email: &'a str,
}

type Accounts<'a> = HashMap<Account<'a>, AccountInfo<'a>>;

fn try_logon<'a>(accounts: &Accounts<'a>,
        username: &'a str, password: &'a str){
    println!("Username: {}", username);
    println!("Password: {}", password);
    println!("Attempting logon...");

    let logon = Account {
        username: username,
        password: password,
    };

    match accounts.get(&logon) {
        Some(account_info) => {
            println!("Successful logon!");
            println!("Name: {}", account_info.name);
            println!("Email: {}", account_info.email);
        },
        _ => println!("Login failed!"),
    }
}

fn main(){
    let mut accounts: Accounts = HashMap::new();

    let account = Account {
        username: "j.everyman",
        password: "password123",
    };

    let account_info = AccountInfo {
        name: "John Everyman",
        email: "j.everyman@email.com",
    };

    accounts.insert(account, account_info);

    try_logon(&accounts, "j.everyman", "psasword123");

    try_logon(&accounts, "j.everyman", "password123");
}
```

<!--[hash]: https://en.wikipedia.org/wiki/Hash_function
 [floating]: https://en.wikipedia.org/wiki/Floating_point#Accuracy_problems
-->
[hash]: https://en.wikipedia.org/wiki/Hash_function
 [floating]: https://en.wikipedia.org/wiki/Floating_point#Accuracy_problems

