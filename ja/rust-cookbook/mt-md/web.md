# <!--Web Programming--> Webプログラミング

## <!--Scraping Web Pages--> Webページのスクラップ

|<!--Recipe-->レシピ|<!--Crates-->クレート|<!--Categories-->カテゴリー|
|<!------------>--------|<!------------>--------|<!---------------->------------|
|<!--[Extract all links from a webpage HTML][ex-extract-links-webpage]-->[ウェブページHTMLからすべてのリンクを抽出する][ex-extract-links-webpage]|<!--[!][reqwest]-->[！][reqwest]<!--[reqwest-badge] [!][select]-->[reqwest-badge] [！][select][select-badge]|<!--[!][cat-net]-->[！][cat-net][cat-net-badge]|
|<!--[Check webpage for broken links][ex-check-broken-links]-->[ウェブページの壊れたリンクを確認する][ex-check-broken-links]|<!--[!][reqwest]-->[！][reqwest]<!--[reqwest-badge] [!][select]-->[reqwest-badge] [！][select]<!--[select-badge] [!][url]-->[select-badge] [！][url][url-badge]|<!--[!][cat-net]-->[！][cat-net][cat-net-badge]|
|<!--[Extract all unique links from a MediaWiki markup][ex-extract-mediawiki-links]-->[MediaWikiのマークアップからすべてのユニークなリンクを抽出する][ex-extract-mediawiki-links]|<!--[!][reqwest]-->[！][reqwest]<!--[reqwest-badge] [!][regex]-->[reqwest-badge] [！][regex][regex-badge]|<!--[!][cat-net]-->[！][cat-net][cat-net-badge]|

## <!--Uniform Resource Locations (URL)--> ユニフォームリソースの場所（URL）

|<!--Recipe-->レシピ|<!--Crates-->クレート|<!--Categories-->カテゴリー|
|<!------------>--------|<!------------>--------|<!---------------->------------|
|<!--[Parse a URL from a string to a `Url` type][ex-url-parse]-->[文字列から`Url`型へのURLの解析][ex-url-parse]|<!--[!][url]-->[！][url][url-badge]|<!--[!][cat-net]-->[！][cat-net][cat-net-badge]|
|<!--[Create a base URL by removing path segments][ex-url-base]-->[パスセグメントを削除してベースURLを作成する][ex-url-base]|<!--[!][url]-->[！][url][url-badge]|<!--[!][cat-net]-->[！][cat-net][cat-net-badge]|
|<!--[Create new URLs from a base URL][ex-url-new-from-base]-->[ベースURLから新しいURLを作成する][ex-url-new-from-base]|<!--[!][url]-->[！][url][url-badge]|<!--[!][cat-net]-->[！][cat-net][cat-net-badge]|
|<!--[Extract the URL origin (scheme / host / port)][ex-url-origin]-->[URL原点（scheme / host / port）を抽出します。][ex-url-origin]|<!--[!][url]-->[！][url][url-badge]|<!--[!][cat-net]-->[！][cat-net][cat-net-badge]|
|<!--[Remove fragment identifiers and query pairs from a URL][ex-url-rm-frag]-->[フラグメント識別子とクエリーのペアをURLから削除する][ex-url-rm-frag]|<!--[!][url]-->[！][url][url-badge]|<!--[!][cat-net]-->[！][cat-net][cat-net-badge]|

## <!--Media Types (MIME)--> メディアタイプ（MIME）

|<!--Recipe-->レシピ|<!--Crates-->クレート|<!--Categories-->カテゴリー|
|<!------------>--------|<!------------>--------|<!---------------->------------|
|<!--[Get MIME type from string][ex-mime-from-string]-->[文字列からMIMEタイプを取得する][ex-mime-from-string]|<!--[!][mime]-->[！][mime][mime-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Get MIME type from filename][ex-mime-from-filename]-->[ファイル名からMIMEタイプを取得する][ex-mime-from-filename]|<!--[!][mime]-->[！][mime][mime-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Parse the MIME type of a HTTP response][ex-http-response-mime-type]-->[HTTPレスポンスのMIMEタイプを解析する][ex-http-response-mime-type]|<!--[!][mime]-->[！][mime]<!--[mime-badge] [!][reqwest]-->[mime-badge] [！][reqwest][reqwest-badge]|<!--[!][cat-net]-->[！][cat-net]<!--[cat-net-badge] [!][cat-encoding]-->[cat-net-badge] [！][cat-encoding][cat-encoding-badge]|


<!--{{#include web/clients.md}}-->
{{#include web / clients.md}}

<!--[ex-extract-links-webpage]: web/scraping.html#extract-all-links-from-a-webpage-html
 [ex-check-broken-links]: web/scraping.html#check-a-webpage-for-broken-links
 [ex-extract-mediawiki-links]: web/scraping.html#extract-all-unique-links-from-a-mediawiki-markup
-->
[ex-extract-links-webpage]: web/scraping.html#extract-all-links-from-a-webpage-html
 [ex-check-broken-links]: web/scraping.html#check-a-webpage-for-broken-links
 [ex-extract-mediawiki-links]: web/scraping.html#extract-all-unique-links-from-a-mediawiki-markup


<!--[ex-url-parse]: web/url.html#parse-a-url-from-a-string-to-a-url-type
 [ex-url-base]: web/url.html#create-a-base-url-by-removing-path-segments
 [ex-url-new-from-base]: web/url.html#create-new-urls-from-a-base-url
 [ex-url-origin]: web/url.html#extract-the-url-origin-scheme--host--port
 [ex-url-rm-frag]: web/url.html#remove-fragment-identifiers-and-query-pairs-from-a-url
-->
[ex-url-parse]: web/url.html#parse-a-url-from-a-string-to-a-url-type
 [ex-url-base]: web/url.html#create-a-base-url-by-removing-path-segments
 [ex-url-new-from-base]: web/url.html#create-new-urls-from-a-base-url
 [ex-url-origin]: web/url.html#extract-the-url-origin-scheme--host--port
 [ex-url-rm-frag]: web/url.html#remove-fragment-identifiers-and-query-pairs-from-a-url


<!--[ex-mime-from-string]: web/mime.html#get-mime-type-from-string
 [ex-mime-from-filename]: web/mime.html#get-mime-type-from-filename
 [ex-http-response-mime-type]: web/mime.html#parse-the-mime-type-of-a-http-response
-->
[ex-mime-from-string]: web/mime.html#get-mime-type-from-string
 [ex-mime-from-filename]: web/mime.html#get-mime-type-from-filename
 [ex-http-response-mime-type]: web/mime.html#parse-the-mime-type-of-a-http-response


<!--{{#include links.md}}-->
{{#include links.md}}
