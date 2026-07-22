#!/bin/bash
set -e

FLASH_ROOTFS=false
for arg in "$@"; do
    if [ "$arg" = "-flash-rootfs" ]; then
        FLASH_ROOTFS=true
    fi
done

sudo -v
sudo umount -R rootfs/ 2>/dev/null || true

cp out/arch/arm64/boot/Image.gz-dtb AIK/split_img/boot.img-kernel

sudo rm -rf AIK/ramdisk/*

sudo cp -a initramfs/src/initramfs/* AIK/ramdisk/
(
    cd initramfs/src/initramfs
    find . | cpio -o -H newc | gzip -9 > ../../../AIK/split_img/boot.img-ramdisk.cpio.gz
)

cd AIK/
./repackimg.sh
cd ..

fastboot flash boot AIK/image-new.img
if [ "$FLASH_ROOTFS" = true ]; then
    echo "Flashing rootfs.img to userdata..."
    fastboot flash userdata rootfs.img
fi
fastboot reboot
