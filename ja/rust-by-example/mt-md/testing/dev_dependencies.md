# <!--Development dependencies--> 開発の依存関係

<!--Sometimes there is a need to have a dependencies for tests (examples, benchmarks) only.-->
場合によっては、テスト（例、ベンチマーク）にのみ依存する必要があります。
<!--Such dependencies are added to `Cargo.toml` in `[dev-dependencies]` section.-->
このような依存関係は`Cargo.toml` `[dev-dependencies]`セクションに追加されています。
<!--These dependencies are not propagated to other packages which depend on this package.-->
これらの依存関係は、このパッケージに依存する他のパッケージには伝播しません。

<!--One such example is using a crate that extends standard `assert!` macros.-->
そのような例の1つは、標準的な`assert!`マクロを拡張するクレートを使用しています。
<!--File `Cargo.toml`:-->
ファイル`Cargo.toml`：

```ignore
# standard crate data is left out
[dev-dependencies]
pretty_assertions = "0.4.0"
```

<!--File `src/lib.rs`:-->
ファイル`src/lib.rs`：

```rust,ignore
#// externing crate for test-only use
// テスト専用の外部クレート
#[cfg(test)]
#[macro_use]
extern crate pretty_assertions;

pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 3), 5);
    }
}
```

## <!--See Also--> 関連項目
<!--[Cargo][cargo] docs on specifying dependencies.-->
依存関係の指定に関する[Cargo][cargo]文書。

[cargo]: http://doc.crates.io/specifying-dependencies.html
