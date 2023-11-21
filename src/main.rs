#![no_main]
#![no_std]
#![feature(type_alias_impl_trait)]
#![feature(asm_experimental_arch)]

use embassy_executor::Spawner;
use embassy_time::{Duration, Timer};

#[embassy_executor::task]
async fn run_stub_timer() {
    loop {
        defmt::info!("tick");
        Timer::after(Duration::from_secs(6))
            .await;
    }
}

#[embassy_executor::main]
async fn main(spawner: Spawner) {
    spawner.spawn(run_stub_timer())
        .unwrap();
}
