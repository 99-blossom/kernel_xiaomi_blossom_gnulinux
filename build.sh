# build.sh
# gnulinux-unified

make O=out ARCH=arm64 \
  CC="clang --target=aarch64-linux-gnu -fuse-ld=lld" \
  HOSTCC=clang \
  CLANG_TRIPLE=aarch64-linux-gnu- \
  CROSS_COMPILE=aarch64-linux-gnu- \
  CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
  LD=ld.lld \
  HOSTLD=ld.lld \
  AR=llvm-ar \
  NM=llvm-nm \
  OBJCOPY=llvm-objcopy \
  OBJDUMP=llvm-objdump \
  STRIP=llvm-strip \
  LLVM_IAS=0 \
  -j$(nproc)
