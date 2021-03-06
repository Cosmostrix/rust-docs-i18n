## <!--Listen on unused port TCP/IP--> 未使用ポートのTCP / IPをリッスンする

<!--[!][std]-->
[！][std]
<!--[std-badge] [!][cat-net]-->
[std-badge] [！][cat-net]
[cat-net-badge]
<!--In this example, the port is displayed on the console, and the program will listen until a request is made.-->
この例では、コンソールにポートが表示され、要求が行われるまでプログラムはリッスンします。
<!--`SocketAddrV4` assigns a random port when setting port to 0.-->
`SocketAddrV4`、ポートを0に設定するときにランダムなポートを割り当てます。

```rust,no_run
# #[macro_use]
# extern crate error_chain;
#
use std::net::{SocketAddrV4, Ipv4Addr, TcpListener};
use std::io::Read;
#
# error_chain! {
#     foreign_links {
#         Io(::std::io::Error);
#     }
# }

fn run() -> Result<()> {
    let loopback = Ipv4Addr::new(127, 0, 0, 1);
    let socket = SocketAddrV4::new(loopback, 0);
    let listener = TcpListener::bind(socket)?;
    let port = listener.local_addr()?;
    println!("Listening on {}, access this port to end the program", port);
    let (mut tcp_stream, addr) = listener.accept()?; //block  until requested
    println!("Connection received! {:?} is sending data.", addr);
    let mut input = String::new();
    let _ = tcp_stream.read_to_string(&mut input)?;
    println!("{:?} says {}", addr, input);
    Ok(())
}
#
# quick_main!(run);
```
