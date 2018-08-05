# <!--Encoding--> エンコーディング

|<!--Recipe-->レシピ|<!--Crates-->クレート|<!--Categories-->カテゴリー|
|<!------------>--------|<!------------>--------|<!---------------->------------|
|<!--[Percent-encode a string][ex-percent-encode]-->[パーセントエンコードの文字列][ex-percent-encode]|<!--[!][url]-->[！][url][url-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Encode a string as application/x-www-form-urlencoded][ex-urlencoded]-->[application / x-www-form-urlencodedとして文字列をエンコードする][ex-urlencoded]|<!--[!][url]-->[！][url][url-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Encode and decode hex][ex-hex-encode-decode]-->[16進数のエンコードとデコード][ex-hex-encode-decode]|<!--[!][data-encoding]-->[！][data-encoding][data-encoding-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Encode and decode base64][ex-base64]-->[base64のエンコードとデコード][ex-base64]|<!--[!][base64]-->[！][base64][base64-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Read CSV records][ex-csv-read]-->[CSVレコードを読む][ex-csv-read]|<!--[!][csv]-->[！][csv][csv-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Read CSV records with different delimiter][ex-csv-delimiter]-->[異なる区切り文字を使用してCSVレコードを読み取る][ex-csv-delimiter]|<!--[!][csv]-->[！][csv][csv-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Filter CSV records matching a predicate][ex-csv-filter]-->[述語と一致するCSVレコードをフィルタリングする][ex-csv-filter]|<!--[!][csv]-->[！][csv][csv-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Handle invalid CSV data with Serde][ex-invalid-csv]-->[Serdeで無効なCSVデータを処理する][ex-invalid-csv]|<!--[!][csv]-->[！][csv]<!--[csv-badge] [!][serde]-->[csv-badge] [！][serde][serde-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Serialize records to CSV][ex-serialize-csv]-->[レコードをCSVにシリアル化する][ex-serialize-csv]|<!--[!][csv]-->[！][csv][csv-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Serialize records to CSV using Serde][ex-csv-serde]-->[Serdeを使用してレコードをCSVにシリアル化する][ex-csv-serde]|<!--[!][csv]-->[！][csv]<!--[csv-badge] [!][serde]-->[csv-badge] [！][serde][serde-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Transform one column of a CSV file][ex-csv-transform-column]-->[CSVファイルの1つの列を変換する][ex-csv-transform-column]|<!--[!][csv]-->[！][csv]<!--[csv-badge] [!][serde]-->[csv-badge] [！][serde][serde-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Serialize and deserialize unstructured JSON][ex-json-value]-->[構造化されていないJSONを直列化および逆シリアル化する][ex-json-value]|<!--[!][serde-json]-->[！][serde-json][serde-json-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Deserialize a TOML configuration file][ex-toml-config]-->[TOML構成ファイルをデシリアライズする][ex-toml-config]|<!--[!][toml]-->[！][toml][toml-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|
|<!--[Read and write integers in little-endian byte order][ex-byteorder-le]-->[リトルエンディアンのバイト順で整数を読み書きする][ex-byteorder-le]|<!--[!][byteorder]-->[！][byteorder][byteorder-badge]|<!--[!][cat-encoding]-->[！][cat-encoding][cat-encoding-badge]|

<!--[ex-percent-encode]: encoding/strings.html#percent-encode-a-string
 [ex-urlencoded]: encoding/strings.html#encode-a-string-as-applicationx-www-form-urlencoded
 [ex-hex-encode-decode]: encoding/strings.html#encode-and-decode-hex
 [ex-base64]: encoding/strings.html#encode-and-decode-base64
 [ex-csv-read]: encoding/csv.html#read-csv-records
 [ex-csv-delimiter]: encoding/csv.html#read-csv-records-with-different-delimiter
 [ex-csv-filter]: encoding/csv.html#filter-csv-records-matching-a-predicate
 [ex-invalid-csv]: encoding/csv.html#handle-invalid-csv-data-with-serde
 [ex-serialize-csv]: encoding/csv.html#serialize-records-to-csv
 [ex-csv-serde]: encoding/csv.html#serialize-records-to-csv-using-serde
 [ex-csv-transform-column]: encoding/csv.html#transform-csv-column
 [ex-json-value]: encoding/complex.html#serialize-and-deserialize-unstructured-json
 [ex-toml-config]: encoding/complex.html#deserialize-a-toml-configuration-file
 [ex-byteorder-le]: encoding/complex.html#read-and-write-integers-in-little-endian-byte-order
-->
[ex-percent-encode]: encoding/strings.html#percent-encode-a-string
 [ex-urlencoded]: encoding/strings.html#encode-a-string-as-applicationx-www-form-urlencoded
 [ex-hex-encode-decode]: encoding/strings.html#encode-and-decode-hex
 [ex-base64]: encoding/strings.html#encode-and-decode-base64
 [ex-csv-read]: encoding/csv.html#read-csv-records
 [ex-csv-delimiter]: encoding/csv.html#read-csv-records-with-different-delimiter
 [ex-csv-filter]: encoding/csv.html#filter-csv-records-matching-a-predicate
 [ex-invalid-csv]: encoding/csv.html#handle-invalid-csv-data-with-serde
 [ex-serialize-csv]: encoding/csv.html#serialize-records-to-csv
 [ex-csv-serde]: encoding/csv.html#serialize-records-to-csv-using-serde
 [ex-csv-transform-column]: encoding/csv.html#transform-csv-column
 [ex-json-value]: encoding/complex.html#serialize-and-deserialize-unstructured-json
 [ex-toml-config]: encoding/complex.html#deserialize-a-toml-configuration-file
 [ex-byteorder-le]: encoding/complex.html#read-and-write-integers-in-little-endian-byte-order



<!--{{#include links.md}}-->
{{#include links.md}}
