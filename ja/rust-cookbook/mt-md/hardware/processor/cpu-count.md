## <!--Check number of logical cpu cores--> 論理CPUコアの数を確認する

<!--[!][num_cpus]-->
[！][num_cpus]
<!--[num_cpus-badge] [!][cat-hardware-support]-->
[num_cpus-badge] [！][cat-hardware-support]
[cat-hardware-support-badge]
<!--Shows the number of logical CPU cores in current machine using [`num_cpus::get`].-->
[`num_cpus::get`]を使って現在のマシンの論理CPUコアの数を表示します。

```rust
extern crate num_cpus;

fn main() {
    println!("Number of logical cores is {}", num_cpus::get());
}
```
