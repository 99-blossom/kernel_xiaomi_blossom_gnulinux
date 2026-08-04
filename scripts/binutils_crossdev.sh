#!/bin/sh
# gnulinux-unified

set -e

if command -v aarch64-linux-gnu-as >/dev/null 2>&1 && command -v arm-linux-gnueabi-as >/dev/null 2>&1; then
    echo "arm64 & arm binutils already installed, exiting."
    exit 0
fi

su -c "crossdev -s0 -t aarch64-linux-gnu && crossdev -s0 -t arm-linux-gnueabi"

echo "done"
