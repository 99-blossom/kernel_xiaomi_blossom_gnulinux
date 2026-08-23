#!/usr/bin/env bash
set -uo pipefail
# ccache-build.sh
# gnulinux-unified
START=$(date +%s)

CORES=$(nproc)
JOBS=$((CORES + 1))

printf "\033[1;37mLegend:\033[0m \033[0;35m󰋼 info\033[0m, \033[0;32m󰄳 success\033[0m, \033[0;31m fail\033[0m\n"

printf "\n\033[0;35m  󰋼 nproc reports %d logical cores available\033[0m\n" "${CORES}"
printf "\033[0;35m  󰋼 adding 1, using -j%d for build\033[0m\n\n" "${JOBS}"

make O=out ARCH=arm64 \
  CC="ccache clang --target=aarch64-linux-gnu -fuse-ld=lld" \
  HOSTCC="ccache clang" \
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
  -j${JOBS}

STATUS=$?
T=$(( $(date +%s) - START ))
H=$((T/3600)); M=$(((T%3600)/60)); S=$((T%60))
TIME_STR=$(printf "%02dh:%02dm:%02ds" $H $M $S)

if [ $STATUS -eq 0 ]; then
  printf "\n\033[0;32m  󰄳 build succeeded in %s\033[0m\n" "${TIME_STR}"
else
  printf "\n\033[0;31m   build failed in %s\033[0m\n" "${TIME_STR}"
fi
