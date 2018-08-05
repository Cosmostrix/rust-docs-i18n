# <!--Argument parsing--> 引数の解析

<!--Matching can be used to parse simple arguments:-->
マッチングは単純な引数を解析するために使用できます：

```rust,editable
use std::env;

fn increase(number: i32) {
    println!("{}", number + 1);
}

fn decrease(number: i32) {
    println!("{}", number - 1);
}

fn help() {
    println!("usage:
match_args <string>
    Check whether given string is the answer.
match_args {{increase|decrease}} <integer>
    Increase or decrease given integer by one.");
}

fn main() {
    let args: Vec<String> = env::args().collect();

    match args.len() {
#        // no arguments passed
        // 引数が渡されなかった
        1 => {
            println!("My name is 'match_args'. Try passing some arguments!");
        },
#        // one argument passed
        //  1つの引数を渡した
        2 => {
            match args[1].parse() {
                Ok(42) => println!("This is the answer!"),
                _ => println!("This is not the answer."),
            }
        },
#        // one command and one argument passed
        //  1つのコマンドと1つの引数が渡される
        3 => {
            let cmd = &args[1];
            let num = &args[2];
#            // parse the number
            // 数を解析する
            let number: i32 = match num.parse() {
                Ok(n) => {
                    n
                },
                Err(_) => {
                    eprintln!("error: second argument not an integer");
                    help();
                    return;
                },
            };
#            // parse the command
            // コマンドを解析する
            match &cmd[..] {
                "increase" => increase(number),
                "decrease" => decrease(number),
                _ => {
                    eprintln!("error: invalid command");
                    help();
                },
            }
        },
#        // all the other cases
        // その他すべての場合
        _ => {
#            // show a help message
            // ヘルプメッセージを表示する
            help();
        }
    }
}
```

```bash
$ ./match_args Rust
This is not the answer.
$ ./match_args 42
This is the answer!
$ ./match_args do something
error: second argument not an integer
usage:
match_args <string>
    Check whether given string is the answer.
match_args {increase|decrease} <integer>
    Increase or decrease given integer by one.
$ ./match_args do 42
error: invalid command
usage:
match_args <string>
    Check whether given string is the answer.
match_args {increase|decrease} <integer>
    Increase or decrease given integer by one.
$ ./match_args increase 42
43
```
