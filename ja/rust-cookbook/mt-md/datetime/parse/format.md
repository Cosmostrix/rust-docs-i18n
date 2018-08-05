## <!--Display formatted date and time--> フォーマットされた日付と時刻を表示する

<!--[!][chrono]-->
[！][chrono]
<!--[chrono-badge] [!][cat-date-and-time]-->
[chrono-badge] [！][cat-date-and-time]
[cat-date-and-time-badge]
<!--Gets and displays the current time in UTC using [`Utc::now`].-->
[`Utc::now`]を使ってUTCで現在の時刻を取得して表示します。
<!--Formats the current time in the well-known formats [RFC 2822] using [`DateTime::to_rfc2822`] and [RFC 3339] using [`DateTime::to_rfc3339`], and in a custom format using [`DateTime::format`].-->
フォーマットのよく知られたフォーマットで現在の時刻[RFC 2822]使って[`DateTime::to_rfc2822`]および[RFC 3339]使用して[`DateTime::to_rfc3339`]、カスタムフォーマットで使用して[`DateTime::format`]。

```rust
extern crate chrono;
use chrono::{DateTime, Utc};

fn main() {
    let now: DateTime<Utc> = Utc::now();

    println!("UTC now is: {}", now);
    println!("UTC now in RFC 2822 is: {}", now.to_rfc2822());
    println!("UTC now in RFC 3339 is: {}", now.to_rfc3339());
    println!("UTC now in a custom format is: {}", now.format("%a %b %e %T %Y"));
}
```

<!--[`DateTime::format`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.format
 [`DateTime::to_rfc2822`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.to_rfc2822
 [`DateTime::to_rfc3339`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.to_rfc3339
 [`Utc::now`]: https://docs.rs/chrono/*/chrono/offset/struct.Utc.html#method.now
-->
[`DateTime::format`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.format
 [`DateTime::to_rfc2822`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.to_rfc2822
 [`DateTime::to_rfc3339`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.to_rfc3339
 [`Utc::now`]: https://docs.rs/chrono/*/chrono/offset/struct.Utc.html#method.now


<!--[RFC 2822]: https://www.ietf.org/rfc/rfc2822.txt
 [RFC 3339]: https://www.ietf.org/rfc/rfc3339.txt
-->
[RFC 2822]: https://www.ietf.org/rfc/rfc2822.txt
 [RFC 3339]: https://www.ietf.org/rfc/rfc3339.txt

