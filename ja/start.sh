#!/bin/bash
#set -x
shopt -s nullglob globstar
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

#gen_html book
#gen_html rust/src/doc/man
gen_html api-guidelines
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
