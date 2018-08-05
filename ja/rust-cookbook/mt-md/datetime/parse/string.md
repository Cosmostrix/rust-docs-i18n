## <!--Parse string into DateTime struct--> 文字列をDateTime構造体にパースする

<!--[!][chrono]-->
[！][chrono]
<!--[chrono-badge] [!][cat-date-and-time]-->
[chrono-badge] [！][cat-date-and-time]
[cat-date-and-time-badge]
<!--Parses a [`DateTime`] struct from strings representing the well-known formats [RFC 2822], [RFC 3339], and a custom format, using [`DateTime::parse_from_rfc2822`], [`DateTime::parse_from_rfc3339`], and [`DateTime::parse_from_str`] respectively.-->
[`DateTime::parse_from_rfc2822`]、 [`DateTime::parse_from_rfc3339`]、および[`DateTime::parse_from_str`]それぞれ使用して、よく知られている書式[RFC 2822]、 [RFC 3339]、およびカスタム書式を表す文字列から[`DateTime`]構造体を解析します。

<!--Escape sequences that are available for the [`DateTime::parse_from_str`] can be found at [`chrono::format::strftime`].-->
[`DateTime::parse_from_str`]利用できるエスケープシーケンスは、[`chrono::format::strftime`]ます。
<!--Note that the [`DateTime::parse_from_str`] requires that such a DateTime struct must be creatable that it uniquely identifies a date and a time.-->
[`DateTime::parse_from_str`]は、そのようなDateTime構造体は、日付と時刻を一意に識別できるように作成可能でなければならないことに注意してください。
<!--For parsing dates and times without timezones use [`NaiveDate`], [`NaiveTime`], and [`NaiveDateTime`].-->
タイムゾーンのない日付と時刻の解析には、[`NaiveDate`]、 [`NaiveTime`]、および[`NaiveDateTime`]ます。

```rust
extern crate chrono;
# #[macro_use]
# extern crate error_chain;
#
use chrono::{DateTime, NaiveDate, NaiveDateTime, NaiveTime};
#
# error_chain! {
#     foreign_links {
#         DateParse(chrono::format::ParseError);
#     }
# }

fn run() -> Result<()> {
    let rfc2822 = DateTime::parse_from_rfc2822("Tue, 1 Jul 2003 10:52:37 +0200")?;
    println!("{}", rfc2822);

    let rfc3339 = DateTime::parse_from_rfc3339("1996-12-19T16:39:57-08:00")?;
    println!("{}", rfc3339);

    let custom = DateTime::parse_from_str("5.8.1994 8:00 am +0000", "%d.%m.%Y %H:%M %P %z")?;
    println!("{}", custom);

    let time_only = NaiveTime::parse_from_str("23:56:04", "%H:%M:%S")?;
    println!("{}", time_only);

    let date_only = NaiveDate::parse_from_str("2015-09-05", "%Y-%m-%d")?;
    println!("{}", date_only);

    let no_timezone = NaiveDateTime::parse_from_str("2015-09-05 23:56:04", "%Y-%m-%d %H:%M:%S")?;
    println!("{}", no_timezone);

    Ok(())
}
#
# quick_main!(run);
```

<!--[`chrono::format::strftime`]: https://docs.rs/chrono/*/chrono/format/strftime/index.html
 [`DateTime::format`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.format
 [`DateTime::parse_from_rfc2822`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.parse_from_rfc2822
 [`DateTime::parse_from_rfc3339`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.parse_from_rfc3339
 [`DateTime::parse_from_str`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.parse_from_str
 [`DateTime::to_rfc2822`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.to_rfc2822
 [`DateTime::to_rfc3339`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.to_rfc3339
 [`DateTime`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html
 [`NaiveDate`]: https://docs.rs/chrono/*/chrono/naive/struct.NaiveDate.html
 [`NaiveDateTime`]: https://docs.rs/chrono/*/chrono/naive/struct.NaiveDateTime.html
 [`NaiveTime`]: https://docs.rs/chrono/*/chrono/naive/struct.NaiveTime.html
-->
[`chrono::format::strftime`]: https://docs.rs/chrono/*/chrono/format/strftime/index.html
 [`DateTime::format`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.format
 [`DateTime::parse_from_rfc2822`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.parse_from_rfc2822
 [`DateTime::parse_from_rfc3339`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.parse_from_rfc3339
 [`DateTime::parse_from_str`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.parse_from_str
 [`DateTime::to_rfc2822`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.to_rfc2822
 [`DateTime::to_rfc3339`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.to_rfc3339
 [`DateTime`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html
 [`NaiveDate`]: https://docs.rs/chrono/*/chrono/naive/struct.NaiveDate.html
 [`NaiveDateTime`]: https://docs.rs/chrono/*/chrono/naive/struct.NaiveDateTime.html
 [`NaiveTime`]: https://docs.rs/chrono/*/chrono/naive/struct.NaiveTime.html


<!--[RFC 2822]: https://www.ietf.org/rfc/rfc2822.txt
 [RFC 3339]: https://www.ietf.org/rfc/rfc3339.txt
-->
[RFC 2822]: https://www.ietf.org/rfc/rfc2822.txt
 [RFC 3339]: https://www.ietf.org/rfc/rfc3339.txt

