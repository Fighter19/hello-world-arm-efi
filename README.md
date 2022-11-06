# Summary
This is a project that demonstrates how to build a simple Hello World EFI application for ARM devices.
It targets the armv6kz-none-eabihf triplet, which means the files should be executable on a Raspberry Pi with an appropriate EFI loader as well as QEMU.

# Building
To build this application, it's required to have built U-Boot for your ARM device and have it exported through the environment variable U_BOOT_ROOT. A version close to v2022.10 of U-Boot is expected.
Furthermore ld.lld-12 from LLVM is required (build.sh can be altered to use other linkers, although your mileage may vary).

This project uses cargo-xbuild to cross-compile the application.
For this, XARGO_RUST_SRC needs to be exported or the rustup component "rust-src" needs to be installed.

For more information, please consult the [cargo-xbuild README](https://github.com/rust-osdev/cargo-xbuild#readme).

The program can be built using following command from the root of this project.

```bash
./build.sh
```

# Running
Once the file is loaded, it should print out following lines:

```
Init ok
Hello World from Rust!
Test Concat: Ok
```

# License
The contents of this project can be considered licensed under MIT OR Unlicense (where applicable).
Please be aware, that this does not guarantee, that the resulting binary can be treated as MIT OR Unlicense.

Possibly it's dependencies (U-Boot) require the binary to comply with GPL2.0+ or other licenses.
See this [thread](https://lists.denx.de/pipermail/u-boot/2010-January/067174.html) for more information about this issue.
Please come to your own conclusions or consult a lawyer.

# Bugs
U-Boot currently has a bug, where the relocations are broken.
This will lead to a crash when executing certain functions.
(Such as the "Test Concat" line).
This bug is still present in version v2022.10 of U-Boot.

To workaround this bug, see this suggested [patch](https://lists.denx.de/pipermail/u-boot/2022-October/498762.html).
