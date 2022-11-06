#!/bin/bash
if [ -z "${U_BOOT_ROOT}" ]; then 
    echo "U_BOOT_ROOT environment variable isn't set!"
    exit 1
fi
if [ ! -f "${U_BOOT_ROOT}/lib/efi_loader/efi_crt0.o" ]; then 
    echo "U-Boot isn't built! (Please build it first)"
    exit 1
fi
cargo xbuild --target armv6kz-none-eabihf.json --features uefi-services/panic_handler
ld.lld-12 -nostdlib -zexecstack -znocombreloc -T ${U_BOOT_ROOT}/arch/arm/lib/elf_arm_efi.lds -shared -Bsymbolic -znorelro ./target/armv6kz-none-eabihf/debug/libhello_world_arm_efi.a ${U_BOOT_ROOT}/lib/efi_loader/efi_crt0.o ${U_BOOT_ROOT}/lib/efi_loader/efi_reloc.o -o hello_world_arm_efi.so.debug
ld.lld-12 -nostdlib -zexecstack -znocombreloc -T ${U_BOOT_ROOT}/arch/arm/lib/elf_arm_efi.lds -shared -Bsymbolic -znorelro -s ./target/armv6kz-none-eabihf/debug/libhello_world_arm_efi.a ${U_BOOT_ROOT}/lib/efi_loader/efi_crt0.o ${U_BOOT_ROOT}/lib/efi_loader/efi_reloc.o -o hello_world_arm_efi.so
arm-linux-gnueabi-objcopy -j .header -j .text -j .sdata -j .data -j .dynamic -j .dynsym  -j .rel* -j .rela* -j .reloc -O binary hello_world_arm_efi.so hello_world_arm_efi.efi
# Comment this in to automatically copy it to the tftp folder
# cp hello_world_arm_efi.efi /srv/tftp/helloworld.efi
