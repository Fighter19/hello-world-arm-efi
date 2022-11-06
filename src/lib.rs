#![no_std]
#![no_main]
#![feature(abi_efiapi)]
extern crate alloc;

use uefi::{prelude::*, CStr16};

#[no_mangle]
pub extern "efiapi" fn efi_main(_image: uefi::Handle, mut st: SystemTable<Boot>) -> uefi::Status {

    // This code block ensures, that a message is generated when init of uefi_service was successful
    // In case it was not, it prints out an error message
    // This block (except for the call to uefi_services::init) can be safely removed, once it's known to work
    let mut buf = [0u16; 64];
    let msg = match uefi_services::init(&mut st) {
        Ok(_) => {
            let string = "Init ok\r\n".as_bytes();

            for i in 0..string.len() {
                buf[i] = string[i] as u16;
            }

            unsafe {CStr16::from_u16_with_nul_unchecked(&buf)}
        },
        Err(_) => {
            let string = "Init error\r\n".as_bytes();

            for i in 0..string.len() {
                buf[i] = string[i] as u16;
            }

            unsafe {CStr16::from_u16_with_nul_unchecked(&buf)}
        },
    };
    
    // Print the init status message using the system table directly
    st.stdout().output_string(msg).unwrap();

    uefi_services::println!("Hello World from Rust!");

    uefi_services::println!("Test Concat: {}", "Ok");


    loop {

    }
}
