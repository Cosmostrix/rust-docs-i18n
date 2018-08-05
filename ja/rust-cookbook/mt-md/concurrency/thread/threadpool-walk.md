## <!--Calculate SHA1 sum of iso files concurrently--> isoファイルのSHA1合計を同時に計算する

<!--[!][threadpool]-->
[！][threadpool]
<!--[threadpool-badge] [!][num_cpus]-->
[threadpool-badge] [！][num_cpus]
<!--[num_cpus-badge] [!][walkdir]-->
[num_cpus-badge] [！][walkdir]
<!--[walkdir-badge] [!][ring]-->
[walkdir-badge] [！][ring]
<!--[ring-badge] [!][cat-concurrency]-->
[ring-badge] [！][cat-concurrency]
<!--[cat-concurrency-badge] [!][cat-filesystem]-->
[cat-concurrency-badge] [！][cat-filesystem]
[cat-filesystem-badge]
<!--This example calculates the SHA1 for every file with iso extension in the current directory.-->
この例では、カレントディレクトリのiso拡張子を持つファイルごとにSHA1を計算します。
<!--A threadpool generates threads equal to the number of cores present in the system found with [`num_cpus::get`].-->
スレッドプールは[`num_cpus::get`]見つかったシステムに存在するコアの数に等しいスレッドを生成します。
<!--[`Walkdir::new`] iterates the current directory and calls [`execute`] to perform the operations of reading and computing SHA1 hash.-->
[`Walkdir::new`]はカレントディレクトリを反復し、[`execute`]を呼び出してSHA1ハッシュの読み込みと計算を実行します。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate walkdir;
extern crate ring;
extern crate num_cpus;
extern crate threadpool;

# error_chain! {
#     foreign_links {
#         Io(std::io::Error);
#     }
# }
#
use walkdir::WalkDir;
use std::fs::File;
use std::io::{BufReader, Read};
use std::path::Path;
use threadpool::ThreadPool;
use std::sync::mpsc::channel;
use ring::digest::{Context, Digest, SHA1};

#//# // Verify the iso extension
# //  iso拡張子を確認する
# fn is_iso(entry: &Path) -> bool {
#     match entry.extension() {
#         Some(e) if e.to_string_lossy().to_lowercase() == "iso" => true,
#         _ => false,
#     }
# }
#
fn compute_digest<P: AsRef<Path>>(filepath: P) -> Result<(Digest, P)> {
    let mut buf_reader = BufReader::new(File::open(&filepath)?);
    let mut context = Context::new(&SHA1);
    let mut buffer = [0; 1024];

    loop {
        let count = buf_reader.read(&mut buffer)?;
        if count == 0 {
            break;
        }
        context.update(&buffer[..count]);
    }

    Ok((context.finish(), filepath))
}

fn run() -> Result<()> {
    let pool = ThreadPool::new(num_cpus::get());

    let (tx, rx) = channel();

    for entry in WalkDir::new("/home/user/Downloads")
        .follow_links(true)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| !e.path().is_dir() && is_iso(e.path())) {
            let path = entry.path().to_owned();
            let tx = tx.clone();
            pool.execute(move || {
                let digest = compute_digest(path);
                tx.send(digest).expect("Could not send data!");
            });
        }

    drop(tx);
    for t in rx.iter() {
        let (sha, path) = t?;
        println!("{:?} {:?}", sha, path);
    }
    Ok(())
}
#
# quick_main!(run);
```

<!--[`execute`]: https://docs.rs/threadpool/*/threadpool/struct.ThreadPool.html#method.execute
 [`num_cpus::get`]: https://docs.rs/num_cpus/*/num_cpus/fn.get.html
 [`Walkdir::new`]: https://docs.rs/walkdir/*/walkdir/struct.WalkDir.html#method.new
-->
[`execute`]: https://docs.rs/threadpool/*/threadpool/struct.ThreadPool.html#method.execute
 [`num_cpus::get`]: https://docs.rs/num_cpus/*/num_cpus/fn.get.html
 [`Walkdir::new`]: https://docs.rs/walkdir/*/walkdir/struct.WalkDir.html#method.new

