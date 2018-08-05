# <!--File System--> ファイルシステム

|<!--Recipe-->レシピ|<!--Crates-->クレート|<!--Categories-->カテゴリー|
|<!------------>--------|<!------------>--------|<!---------------->------------|
|<!--[Read lines of strings from a file][ex-std-read-lines]-->[ファイルから文字列の行を読み込む][ex-std-read-lines]|<!--[!][std]-->[！][std][std-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|
|<!--[Avoid writing and reading from a same file][ex-avoid-read-write]-->[同じファイルからの書き込みと読み取りを避ける][ex-avoid-read-write]|<!--[!][same_file]-->[！][same_file][same_file-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|
|<!--[Access a file randomly using a memory map][ex-random-file-access]-->[メモリマップを使用してランダムにファイルにアクセスする][ex-random-file-access]|<!--[!][memmap]-->[！][memmap][memmap-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|
|<!--[File names that have been modified in the last 24 hours][ex-file-24-hours-modified]-->[過去24時間以内に変更されたファイル名][ex-file-24-hours-modified]|<!--[!][std]-->[！][std][std-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem]<!--[cat-filesystem-badge] [!][cat-os]-->[cat-filesystem-badge] [！][cat-os][cat-os-badge]|
|<!--[Find loops for a given path][ex-find-file-loops]-->[指定されたパスのループを見つける][ex-find-file-loops]|<!--[!][same_file]-->[！][same_file][same_file-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|
|<!--[Recursively find duplicate file names][ex-dedup-filenames]-->[再帰的に重複するファイル名を見つける][ex-dedup-filenames]|<!--[!][walkdir]-->[！][walkdir][walkdir-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|
|<!--[Recursively find all files with given predicate][ex-file-predicate]-->[与えられた述語を持つすべてのファイルを再帰的に見つける][ex-file-predicate]|<!--[!][walkdir]-->[！][walkdir][walkdir-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|
|<!--[Traverse directories while skipping dotfiles][ex-file-skip-dot]-->[ドットファイルをスキップしながらディレクトリを走査する][ex-file-skip-dot]|<!--[!][walkdir]-->[！][walkdir][walkdir-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|
|<!--[Recursively calculate file sizes at given depth][ex-file-sizes]-->[与えられた深さでファイルサイズを再帰的に計算する][ex-file-sizes]|<!--[!][walkdir]-->[！][walkdir][walkdir-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|
|<!--[Find all png files recursively][ex-glob-recursive]-->[すべてのpngファイルを再帰的に検索する][ex-glob-recursive]|<!--[!][glob]-->[！][glob][glob-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|
|<!--[Find all files with given pattern ignoring filename case][ex-glob-with]-->[ファイル名の大文字と小文字を無視][ex-glob-with]|<!--[!][glob]-->[！][glob][glob-badge]|<!--[!][cat-filesystem]-->[！][cat-filesystem][cat-filesystem-badge]|

<!--[ex-std-read-lines]: file/read-write.html#read-lines-of-strings-from-a-file
 [ex-avoid-read-write]: file/read-write.html#avoid-writing-and-reading-from-a-same-file
 [ex-random-file-access]: file/read-write.html#access-a-file-randomly-using-a-memory-map
 [ex-file-24-hours-modified]: file/dir.html#file-names-that-have-been-modified-in-the-last-24-hours
 [ex-find-file-loops]: file/dir.html#find-loops-for-a-given-path
 [ex-dedup-filenames]: file/dir.html#recursively-find-duplicate-file-names
 [ex-file-predicate]: file/dir.html#recursively-find-all-files-with-given-predicate
 [ex-file-skip-dot]: file/dir.html#traverse-directories-while-skipping-dotfiles
 [ex-file-sizes]: file/dir.html#recursively-calculate-file-sizes-at-given-depth
 [ex-glob-recursive]: file/dir.html#find-all-png-files-recursively
 [ex-glob-with]: file/dir.html#find-all-files-with-given-pattern-ignoring-filename-case
-->
[ex-std-read-lines]: file/read-write.html#read-lines-of-strings-from-a-file
 [ex-avoid-read-write]: file/read-write.html#avoid-writing-and-reading-from-a-same-file
 [ex-random-file-access]: file/read-write.html#access-a-file-randomly-using-a-memory-map
 [ex-file-24-hours-modified]: file/dir.html#file-names-that-have-been-modified-in-the-last-24-hours
 [ex-find-file-loops]: file/dir.html#find-loops-for-a-given-path
 [ex-dedup-filenames]: file/dir.html#recursively-find-duplicate-file-names
 [ex-file-predicate]: file/dir.html#recursively-find-all-files-with-given-predicate
 [ex-file-skip-dot]: file/dir.html#traverse-directories-while-skipping-dotfiles
 [ex-file-sizes]: file/dir.html#recursively-calculate-file-sizes-at-given-depth
 [ex-glob-recursive]: file/dir.html#find-all-png-files-recursively
 [ex-glob-with]: file/dir.html#find-all-files-with-given-pattern-ignoring-filename-case


<!--{{#include links.md}}-->
{{#include links.md}}
