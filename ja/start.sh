#!/bin/bash
#set -x
shopt -s globstar #nullglob
target_lang_dir=$(dirname $0)
source_lang_dir=$target_lang_dir/../en
PROG=$(which maptrans)

echo "INFO: $source_lang_dir => $target_lang_dir"

function gen_html() {
  repo_dir=$1
  mds=$(cd $source_lang_dir; ls $repo_dir/src/**/*.md)
  for md in $mds; do
    target_dir=$target_lang_dir/$(dirname $(echo $md | sed 's/\/src\//\/html-md\//'))
    echo "Convert $md into HTML in $target_dir"
    mkdir -p $target_dir $(echo $target_dir | sed 's/html-md/mt-html/')
    $PROG map2html $source_lang_dir/$md $target_dir
  done
}

function stage0() {
  gen_html api-guidelines
  gen_html book/first-edition
  gen_html book/second-edition
  gen_html book/2018-edition
  gen_html cargo/src/doc
  gen_html edition-guide
  gen_html nomicon
  gen_html reference
  gen_html rust-by-example
  gen_html rust-cookbook
  gen_html rust/src/doc/rustc
  gen_html rust/src/doc/rustdoc
  gen_html rust/src/doc/unstable-book
  gen_html rustc-guide
  $PROG map2html en/rust/CODE_OF_CONDUCT.md ja/rust/html-md
  $PROG map2html en/rust/CONTRIBUTING.md ja/rust/html-md
  $PROG map2html en/rust/README.md ja/rust/html-md
  $PROG map2html en/rust/RELEASES.md ja/rust/html-md
  cp -a en/rust/src/doc/man/rustdoc.1 ja/rust/html-md/doc/man/rustdoc.1.txt
  cp -a en/rust/src/doc/man/rustc.1 ja/rust/html-md/doc/man/rustc.1.txt
}

function back_to_md() {
  repo_dir=$1
  pushd $target_lang_dir
  htmls=$(ls $(echo $repo_dir/src/ | sed 's/\/src\//\/mt-html\//')**/*.html)
  echo $htmls
  for src in $htmls; do
    target_dir=$(dirname $(echo $src | sed 's/\/mt-html\//\/mt-md\//'))
    echo "Convert $src into Markdown in $target_dir"
    mkdir -p $target_dir
    $PROG back2md $src $target_dir
  done
  popd
}

function stage1() {
  back_to_md api-guidelines
  back_to_md book/first-edition
  back_to_md book/second-edition
  #back_to_md book/2018-edition
  back_to_md cargo/mt-html/doc
  back_to_md edition-guide
  back_to_md nomicon
  back_to_md reference
  back_to_md rust-by-example
  back_to_md rust-cookbook
  back_to_md rust/src/doc/rustc
  back_to_md rust/src/doc/rustdoc
  back_to_md rust/src/doc/unstable-book
  back_to_md rustc-guide
  pushd ja
  $PROG back2md rust/mt-html/CODE_OF_CONDUCT.html rust/mt-md
  $PROG back2md rust/mt-html/CONTRIBUTING.html rust/mt-md
  $PROG back2md rust/mt-html/README.html rust/mt-md
  $PROG back2md rust/mt-html/RELEASES.html rust/mt-md
  popd
}

function apply_table() {
  repo_dir=$1
  pushd $target_lang_dir
  #mds=$(ls $repo_dir/mt-md/**/*.md)
  mds=$(ls $(echo $repo_dir/src/ | sed 's/\/src\//\/mt-md\//')**/*.md)
  echo $mds
  for src in $mds; do
    target_dir=$(dirname $(echo $src | sed 's/\/mt-md\//\/coarse\//'))
    echo "Apply table $src into $target_dir"
    mkdir -p $target_dir $(echo $target_dir | sed 's/\/coarse\//\/fine\//')
    $PROG apply-table $src $target_dir
  done
  popd
}

function stage2() {
  apply_table api-guidelines
  apply_table book/first-edition
  apply_table book/second-edition
  #apply_table book/2018-edition
  apply_table cargo/src/doc
  apply_table edition-guide
  apply_table nomicon
  apply_table reference
  apply_table rust-by-example
  apply_table rust-cookbook
  apply_table rust/src/doc/rustc
  apply_table rust/src/doc/rustdoc
  apply_table rust/src/doc/unstable-book
  apply_table rustc-guide
  pushd ja
  $PROG apply-table rust/mt-md/CODE_OF_CONDUCT.md rust/coarse
  $PROG apply-table rust/mt-md/CONTRIBUTING.md rust/coarse
  $PROG apply-table rust/mt-md/README.md rust/coarse
  #$PROG apply-table rust/mt-md/RELEASES.md rust/coarse
  popd
}

function stage3() {
  echo # Not impl
}

function copy_to_src() {
  repo_dir=$1
  cp -nrv $source_lang_dir/$repo_dir/{book.toml,theme,assets,src/{img,theme}} \
          $target_lang_dir/$repo_dir
  pushd $target_lang_dir
  mds=$(ls $repo_dir/coarse/**/*.md)
  echo $mds
  for coarse in $mds; do
    fine=$(echo $coarse | sed 's/\/coarse\//\/fine\//')
    target_dir=$(dirname $(echo $coarse | sed 's/\/coarse\//\/src\//'))
    mkdir -p $target_dir
    if [ -e $fine ]; then
      $PROG uncomment $fine $target_dir
    else
      $PROG uncomment $coarse $target_dir
    fi
  done
  cd $repo_dir; ~/.cargo/bin/mdbook build
  popd
}

function stage4() {
  copy_to_src api-guidelines
  copy_to_src book/first-edition
  copy_to_src book/second-edition
  #copy_to_src book/2018-edition
  copy_to_src cargo/src/doc
  copy_to_src edition-guide
  copy_to_src nomicon
  copy_to_src reference
  copy_to_src rust-by-example
  copy_to_src rust-cookbook
  copy_to_src rust/src/doc/rustc
  copy_to_src rust/src/doc/rustdoc
  copy_to_src rust/src/doc/unstable-book
  copy_to_src rustc-guide
  pushd ja
  #cp -v rust/{coarse,fine}/CODE_OF_CONDUCT.md rust/src
  #cp -v rust/{coarse,fine}/CONTRIBUTING.md rust/src
  #cp -v rust/{coarse,fine}/README.md rust/src
  #cp -v rust/{coarse,fine}/RELEASES.md rust/src
  popd
}

#stage0
stage1
stage2
stage3
stage4
