# <!--References--> 参考文献

<!--There are two kinds of reference:-->
参照には2種類あります。

* <!--Shared reference: `&`-->
   共有参照： `&`
* <!--Mutable reference: `&mut`-->
   変更可能な参照： `&mut`

<!--Which obey the following rules:-->
それは以下の規則に従う：

* <!--A reference cannot outlive its referent-->
   参照はその指示対象よりも長く存続することはできません
* <!--A mutable reference cannot be aliased-->
   変更可能な参照にエイリアスを付けることはできません

<!--That's it.-->
それでおしまい。
<!--That's the whole model references follow.-->
それがモデルの参考文献全体です。

<!--Of course, we should probably define what *aliased* means.-->
もちろん、*エイリアスが*何を意味するのかを定義する必要があります。

```text
error[E0425]: cannot find value `aliased` in this scope
 --> <rust.rs>:2:20
  |
2 |     println!("{}", aliased);
  |                    ^^^^^^^ not found in this scope

error: aborting due to previous error
```

<!--Unfortunately, Rust hasn't actually defined its aliasing model.-->
残念ながら、Rustは実際にエイリアシングモデルを定義していません。
<!--🙀-->
🙀

<!--While we wait for the Rust devs to specify the semantics of their language, let's use the next section to discuss what aliasing is in general, and why it matters.-->
Rust開発者が言語のセマンティクスを指定するのを待つ間に、次のセクションを使用して、エイリアシングが一般的であることと重要な理由について議論しましょう。
