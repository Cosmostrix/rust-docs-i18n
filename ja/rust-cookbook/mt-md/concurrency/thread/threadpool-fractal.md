## <!--Draw fractal dispatching work to a thread pool--> フラクタルディスパッチ作業をスレッドプールに引き出す

<!--[!][threadpool]-->
[！][threadpool]
<!--[threadpool-badge] [!][num]-->
[threadpool-badge] [！][num]
<!--[num-badge] [!][num_cpus]-->
[num-badge] [！][num_cpus]
<!--[num_cpus-badge] [!][image]-->
[num_cpus-badge] [！][image]
<!--[image-badge] [!][cat-concurrency]-->
[image-badge] [！][cat-concurrency]
<!--[cat-concurrency-badge] [!][cat-science]-->
[cat-concurrency-badge] [！][cat-science]
<!--[cat-science-badge] [!][cat-rendering]-->
[cat-science-badge] [！][cat-rendering]
[cat-rendering-badge]
<!--This example generates an image by drawing a fractal from the [Julia set] with a thread pool for distributed computation.-->
この例では、分散計算用のスレッドプールを使用して[Julia set]からフラクタルを描画してイメージを生成します。

Link ("",[],[]) [Image ("",[],[("width","150")]) [] ("https://cloud.githubusercontent.com/assets/221000/26546700/9be34e80-446b-11e7-81dc-dd9871614ea1.png","")] ("https://cloud.githubusercontent.com/assets/221000/26546700/9be34e80-446b-11e7-81dc-dd9871614ea1.png","")
<!--Allocate memory for output image of given width and height with [`ImageBuffer::new`].-->
[`ImageBuffer::new`]使って、指定された幅と高さの出力イメージ用にメモリを割り当てます。
<!--[`Rgb::from_channels`] calculates RGB pixel values.-->
[`Rgb::from_channels`]はRGBピクセル値を計算します。
<!--Create [`ThreadPool`] with thread count equal to number of cores with [`num_cpus::get`].-->
[`num_cpus::get`]でコア数に等しいスレッド数で[`ThreadPool`]を作ります。
<!--[`ThreadPool::execute`] receives each pixel as a separate job.-->
[`ThreadPool::execute`]は、各ピクセルを別々のジョブとして受け取ります。

<!--[`mpsc::channel`] receives the jobs and [`Receiver::recv`] retrieves them.-->
[`mpsc::channel`]はジョブを受け取り、[`Receiver::recv`]はそれらを取得します。
<!--[`ImageBuffer::put_pixel`] uses the data to set the pixel color.-->
[`ImageBuffer::put_pixel`]はデータを使ってピクセルの色を設定します。
<!--[`ImageBuffer::save`] writes the image to `output.png`.-->
[`ImageBuffer::save`]はイメージを`output.png`ます。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
extern crate threadpool;
extern crate num;
extern crate num_cpus;
extern crate image;

use std::sync::mpsc::{channel, RecvError};
use threadpool::ThreadPool;
use num::complex::Complex;
use image::{ImageBuffer, Pixel, Rgb};
#
# error_chain! {
#     foreign_links {
#         MpscRecv(RecvError);
#         Io(std::io::Error);
#     }
# }
#
#//# // Function converting intensity values to RGB
# // 強度値をRGBに変換する機能
#//# // Based on http://www.efg2.com/Lab/ScienceAndEngineering/Spectra.htm
# //  http://www.efg2.com/Lab/ScienceAndEngineering/Spectra.htmに基づいています
# fn wavelength_to_rgb(wavelength: u32) -> Rgb<u8> {
#     let wave = wavelength as f32;
#
#     let (r, g, b) = match wavelength {
#         380...439 => ((440. - wave) / (440. - 380.), 0.0, 1.0),
#         440...489 => (0.0, (wave - 440.) / (490. - 440.), 1.0),
#         490...509 => (0.0, 1.0, (510. - wave) / (510. - 490.)),
#         510...579 => ((wave - 510.) / (580. - 510.), 1.0, 0.0),
#         580...644 => (1.0, (645. - wave) / (645. - 580.), 0.0),
#         645...780 => (1.0, 0.0, 0.0),
#         _ => (0.0, 0.0, 0.0),
#     };
#
#     let factor = match wavelength {
#         380...419 => 0.3 + 0.7 * (wave - 380.) / (420. - 380.),
#         701...780 => 0.3 + 0.7 * (780. - wave) / (780. - 700.),
#         _ => 1.0,
#     };
#
#     let (r, g, b) = (normalize(r, factor), normalize(g, factor), normalize(b, factor));
#     Rgb::from_channels(r, g, b, 0)
# }
#
#//# // Maps Julia set distance estimation to intensity values
# // マップJulia距離の推定値を強度値に設定
# fn julia(c: Complex<f32>, x: u32, y: u32, width: u32, height: u32, max_iter: u32) -> u32 {
#     let width = width as f32;
#     let height = height as f32;
#
#     let mut z = Complex {
#//#         // scale and translate the point to image coordinates
#         // スケールし、ポイントをイメージ座標に変換する
#         re: 3.0 * (x as f32 - 0.5 * width) / width,
#         im: 2.0 * (y as f32 - 0.5 * height) / height,
#     };
#
#     let mut i = 0;
#     for t in 0..max_iter {
#         if z.norm() >= 2.0 {
#             break;
#         }
#         z = z * z + c;
#         i = t;
#     }
#     i
# }
#
#//# // Normalizes color intensity values within RGB range
# //  RGB範囲内のカラー強度値を正規化します。
# fn normalize(color: f32, factor: f32) -> u8 {
#     ((color * factor).powf(0.8) * 255.) as u8
# }

fn run() -> Result<()> {
    let (width, height) = (1920, 1080);
    let mut img = ImageBuffer::new(width, height);
    let iterations = 300;

    let c = Complex::new(-0.8, 0.156);

    let pool = ThreadPool::new(num_cpus::get());
    let (tx, rx) = channel();

    for y in 0..height {
        let tx = tx.clone();
        pool.execute(move || for x in 0..width {
                         let i = julia(c, x, y, width, height, iterations);
                         let pixel = wavelength_to_rgb(380 + i * 400 / iterations);
                         tx.send((x, y, pixel)).expect("Could not send data!");
                     });
    }

    for _ in 0..(width * height) {
        let (x, y, pixel) = rx.recv()?;
        img.put_pixel(x, y, pixel);
    }
    let _ = img.save("output.png")?;
    Ok(())
}
#
# quick_main!(run);
```

<!--[`ImageBuffer::new`]: https://docs.rs/image/*/image/struct.ImageBuffer.html#method.new
 [`ImageBuffer::put_pixel`]: https://docs.rs/image/*/image/struct.ImageBuffer.html#method.put_pixel
 [`ImageBuffer::save`]: https://docs.rs/image/*/image/struct.ImageBuffer.html#method.save
 [`mpsc::channel`]: https://doc.rust-lang.org/std/sync/mpsc/fn.channel.html
 [`num_cpus::get`]: https://docs.rs/num_cpus/*/num_cpus/fn.get.html
 [`Receiver::recv`]: https://doc.rust-lang.org/std/sync/mpsc/struct.Receiver.html#method.recv
 [`Rgb::from_channels`]: https://docs.rs/image/*/image/struct.Rgb.html#method.from_channels
 [`ThreadPool`]: https://docs.rs/threadpool/*/threadpool/struct.ThreadPool.html
 [`ThreadPool::execute`]: https://docs.rs/threadpool/*/threadpool/struct.ThreadPool.html#method.execute
-->
[`ImageBuffer::new`]: https://docs.rs/image/*/image/struct.ImageBuffer.html#method.new
 [`ImageBuffer::put_pixel`]: https://docs.rs/image/*/image/struct.ImageBuffer.html#method.put_pixel
 [`ImageBuffer::save`]: https://docs.rs/image/*/image/struct.ImageBuffer.html#method.save
 [`mpsc::channel`]: https://doc.rust-lang.org/std/sync/mpsc/fn.channel.html
 [`num_cpus::get`]: https://docs.rs/num_cpus/*/num_cpus/fn.get.html
 [`Receiver::recv`]: https://doc.rust-lang.org/std/sync/mpsc/struct.Receiver.html#method.recv
 [`Rgb::from_channels`]: https://docs.rs/image/*/image/struct.Rgb.html#method.from_channels
 [`ThreadPool`]: https://docs.rs/threadpool/*/threadpool/struct.ThreadPool.html
 [`ThreadPool::execute`]: https://docs.rs/threadpool/*/threadpool/struct.ThreadPool.html#method.execute


[Julia set]: https://en.wikipedia.org/wiki/Julia_set
