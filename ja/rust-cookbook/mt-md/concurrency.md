# <!--Concurrency--> 並行性

|<!--Recipe-->レシピ|<!--Crates-->クレート|<!--Categories-->カテゴリー|
|<!------------>--------|<!------------>--------|<!---------------->------------|
|<!--[Spawn a short-lived thread][ex-crossbeam-spawn]-->[短命のスレッドを生成する][ex-crossbeam-spawn]|<!--[!][crossbeam]-->[！][crossbeam][crossbeam-badge]|<!--[!][cat-concurrency]-->[！][cat-concurrency][cat-concurrency-badge]|
|<!--[Maintain global mutable state][ex-global-mut-state]-->[グローバル可変状態を維持する][ex-global-mut-state]|<!--[!][lazy_static]-->[！][lazy_static][lazy_static-badge]|<!--[!][cat-rust-patterns]-->[！][cat-rust-patterns][cat-rust-patterns-badge]|
|<!--[Calculate SHA1 sum of *.iso files concurrently][ex-threadpool-walk]-->[*.isoファイルのSHA1合計を同時に計算する][ex-threadpool-walk]|<!--[!][threadpool]-->[！][threadpool]<!--[threadpool-badge] [!][walkdir]-->[threadpool-badge] [！][walkdir]<!--[walkdir-badge] [!][num_cpus]-->[walkdir-badge] [！][num_cpus]<!--[num_cpus-badge] [!][ring]-->[num_cpus-badge] [！][ring][ring-badge]|<!--[!][cat-concurrency]-->[！][cat-concurrency]<!--[cat-concurrency-badge] [!][cat-filesystem]-->[cat-concurrency-badge] [！][cat-filesystem][cat-filesystem-badge]|
|<!--[Draw fractal dispatching work to a thread pool][ex-threadpool-fractal]-->[フラクタルディスパッチ作業をスレッドプールに引き出す][ex-threadpool-fractal]|<!--[!][threadpool]-->[！][threadpool]<!--[threadpool-badge] [!][num]-->[threadpool-badge] [！][num]<!--[num-badge] [!][num_cpus]-->[num-badge] [！][num_cpus]<!--[num_cpus-badge] [!][image]-->[num_cpus-badge] [！][image][image-badge]|<!--[!][cat-concurrency]-->[！][cat-concurrency]<!--[cat-concurrency-badge] [!][cat-science]-->[cat-concurrency-badge] [！][cat-science]<!--[cat-science-badge] [!][cat-rendering]-->[cat-science-badge] [！][cat-rendering][cat-rendering-badge]|
|<!--[Mutate the elements of an array in parallel][ex-rayon-iter-mut]-->[配列の要素を並列に突然変異させる][ex-rayon-iter-mut]|<!--[!][rayon]-->[！][rayon][rayon-badge]|<!--[!][cat-concurrency]-->[！][cat-concurrency][cat-concurrency-badge]|
|<!--[Test in parallel if any or all elements of a collection match a given predicate][ex-rayon-any-all]-->[コレクションの任意の要素またはすべての要素が指定された述部に一致するかどうかを並行してテストする][ex-rayon-any-all]|<!--[!][rayon]-->[！][rayon][rayon-badge]|<!--[!][cat-concurrency]-->[！][cat-concurrency][cat-concurrency-badge]|
|<!--[Search items using given predicate in parallel][ex-rayon-parallel-search]-->[与えられた述語を並行して使用して項目を検索する][ex-rayon-parallel-search]|<!--[!][rayon]-->[！][rayon][rayon-badge]|<!--[!][cat-concurrency]-->[！][cat-concurrency][cat-concurrency-badge]|
|<!--[Sort a vector in parallel][ex-rayon-parallel-sort]-->[ベクトルを並行してソートする][ex-rayon-parallel-sort]|<!--[!][rayon]-->[！][rayon]<!--[rayon-badge] [!][rand]-->[rayon-badge] [！][rand][rand-badge]|<!--[!][cat-concurrency]-->[！][cat-concurrency][cat-concurrency-badge]|
|<!--[Map-reduce in parallel][ex-rayon-map-reduce]-->[マップを並行して減らす][ex-rayon-map-reduce]|<!--[!][rayon]-->[！][rayon][rayon-badge]|<!--[!][cat-concurrency]-->[！][cat-concurrency][cat-concurrency-badge]|
|<!--[Generate jpg thumbnails in parallel][ex-rayon-thumbnails]-->[並行してjpgサムネイルを生成する][ex-rayon-thumbnails]|<!--[!][rayon]-->[！][rayon]<!--[rayon-badge] [!][glob]-->[rayon-badge] [！][glob]<!--[glob-badge] [!][image]-->[glob-badge] [！][image][image-badge]|<!--[!][cat-concurrency]-->[！][cat-concurrency]<!--[cat-concurrency-badge] [!][cat-filesystem]-->[cat-concurrency-badge] [！][cat-filesystem][cat-filesystem-badge]|


<!--[ex-crossbeam-spawn]: concurrency/threads.html#spawn-a-short-lived-thread
 [ex-global-mut-state]: concurrency/threads.html#maintain-global-mutable-state
 [ex-threadpool-walk]: concurrency/threads.html#calculate-sha1-sum-of-iso-files-concurrently
 [ex-threadpool-fractal]: concurrency/threads.html#draw-fractal-dispatching-work-to-a-thread-pool
 [ex-rayon-iter-mut]: concurrency/parallel.html#mutate-the-elements-of-an-array-in-parallel
 [ex-rayon-any-all]: concurrency/parallel.html#test-in-parallel-if-any-or-all-elements-of-a-collection-match-a-given-predicate
 [ex-rayon-parallel-search]: concurrency/parallel.html#search-items-using-given-predicate-in-parallel
 [ex-rayon-parallel-sort]: concurrency/parallel.html#sort-a-vector-in-parallel
 [ex-rayon-map-reduce]: concurrency/parallel.html#map-reduce-in-parallel
 [ex-rayon-thumbnails]: concurrency/parallel.html#generate-jpg-thumbnails-in-parallel
-->
[ex-crossbeam-spawn]: concurrency/threads.html#spawn-a-short-lived-thread
 [ex-global-mut-state]: concurrency/threads.html#maintain-global-mutable-state
 [ex-threadpool-walk]: concurrency/threads.html#calculate-sha1-sum-of-iso-files-concurrently
 [ex-threadpool-fractal]: concurrency/threads.html#draw-fractal-dispatching-work-to-a-thread-pool
 [ex-rayon-iter-mut]: concurrency/parallel.html#mutate-the-elements-of-an-array-in-parallel
 [ex-rayon-any-all]: concurrency/parallel.html#test-in-parallel-if-any-or-all-elements-of-a-collection-match-a-given-predicate
 [ex-rayon-parallel-search]: concurrency/parallel.html#search-items-using-given-predicate-in-parallel
 [ex-rayon-parallel-sort]: concurrency/parallel.html#sort-a-vector-in-parallel
 [ex-rayon-map-reduce]: concurrency/parallel.html#map-reduce-in-parallel
 [ex-rayon-thumbnails]: concurrency/parallel.html#generate-jpg-thumbnails-in-parallel
 [ex-rayon-map-reduce]: concurrency/parallel.html#map-reduce-in-parallel


<!--{{#include links.md}}-->
{{#include links.md}}
