## <!--Perform checked date and time calculations--> チェックされた日付と時刻の計算を実行する

<!--[!][chrono]-->
[！][chrono]
<!--[chrono-badge] [!][cat-date-and-time]-->
[chrono-badge] [！][cat-date-and-time]
[cat-date-and-time-badge]
<!--Calculates and displays the date and time two weeks from now using [`DateTime::checked_add_signed`] and the date of the day before that using [`DateTime::checked_sub_signed`].-->
計算し、今使用してから、日付と時刻の2週間を表示する[`DateTime::checked_add_signed`]と使用して、その前日の日付[`DateTime::checked_sub_signed`]。
<!--The methods return None if the date and time cannot be calculated.-->
日付と時刻を計算できない場合、メソッドはNoneを返します。

<!--Escape sequences that are available for the [`DateTime::format`] can be found at [`chrono::format::strftime`].-->
[`DateTime::format`]利用できるエスケープシーケンスは、[`chrono::format::strftime`]で[`DateTime::format`]ことができます。

```rust
extern crate chrono;
use chrono::{DateTime, Duration, Utc};

fn day_earlier(date_time: DateTime<Utc>) -> Option<DateTime<Utc>> {
    date_time.checked_sub_signed(Duration::days(1))
}

fn main() {
    let now = Utc::now();
    println!("{}", now);

    let almost_three_weeks_from_now = now.checked_add_signed(Duration::weeks(2))
            .and_then(|in_2weeks| in_2weeks.checked_add_signed(Duration::weeks(1)))
            .and_then(day_earlier);

    match almost_three_weeks_from_now {
        Some(x) => println!("{}", x),
        None => eprintln!("Almost three weeks from now overflows!"),
    }

    match now.checked_add_signed(Duration::max_value()) {
        Some(x) => println!("{}", x),
        None => eprintln!("We can't use chrono to tell the time for the Solar System to complete more than one full orbit around the galactic center."),
    }
}
```

<!--[`chrono::format::strftime`]: https://docs.rs/chrono/*/chrono/format/strftime/index.html
 [`DateTime::checked_add_signed`]: https://docs.rs/chrono/*/chrono/struct.Date.html#method.checked_add_signed
 [`DateTime::checked_sub_signed`]: https://docs.rs/chrono/*/chrono/struct.Date.html#method.checked_sub_signed
 [`DateTime::format`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.format
-->
[`chrono::format::strftime`]: https://docs.rs/chrono/*/chrono/format/strftime/index.html
 [`DateTime::checked_add_signed`]: https://docs.rs/chrono/*/chrono/struct.Date.html#method.checked_add_signed
 [`DateTime::checked_sub_signed`]: https://docs.rs/chrono/*/chrono/struct.Date.html#method.checked_sub_signed
 [`DateTime::format`]: https://docs.rs/chrono/*/chrono/struct.DateTime.html#method.format

