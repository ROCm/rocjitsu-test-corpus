#!/usr/bin/env bash
# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
# Build portable QEMU, the guest kernel, and its stock AMDGPU module closure.
set -euo pipefail
if [[ $# != 2 ]]; then
  echo "usage: $0 ROCJITSU_SOURCE_DIR OUTPUT_DIRECTORY" >&2
  exit 2
fi
rocjitsu=$(realpath "$1")
out=$(realpath -m "$2")
guest=$(dirname "$(realpath "$0")")
release=6.17.0-23-generic
driver_commit=48f2f4486a8dc6122195fa8755b6a1a6ee2ad3e2
archive=https://archive.ubuntu.com/ubuntu/pool/main/l
snapshot=https://snapshot.ubuntu.com/ubuntu/20260501T000000Z/pool/main/l
[[ ! -e "$out" ]] || { echo "Select a new output directory: $out" >&2; exit 1; }
mkdir -p "$(dirname "$out")"
work=$(mktemp -d "$(dirname "$out")/vfio-build.XXXXXXXX")
trap 'rm -rf -- "$work"' EXIT
base=$work/base
mkdir -p "$base/qemu/bin" "$base/qemu/share/qemu" "$work/packages"
jobs=${CMAKE_BUILD_PARALLEL_LEVEL:-$(nproc)}
cd "$work/packages"
curl_args=(--fail --location --silent --show-error --retry 4 --connect-timeout 30)
while read -r digest package; do
  mkdir -p "$(dirname "$package")"
  # The dated snapshot retains packages after they leave the main archive.
  curl "${curl_args[@]}" "$archive/$package" -o "$package" ||
    curl "${curl_args[@]}" "$snapshot/$package" -o "$package"
  echo "$digest  $package" | sha256sum -c -
done < "$guest/ubuntu-kernel.sha256"
# The upstream DKMS build resolves its headers through /lib/modules/<release>/build.
headers=("$PWD"/linux-hwe-6.17/*headers*.deb)
for header in "${headers[@]}"; do
  package=$(dpkg-deb -f "$header" Package)
  version=$(dpkg-deb -f "$header" Version)
  installed=$(dpkg-query -W -f='${db:Status-Abbrev} ${Version}' "$package" 2>/dev/null || true)
  if [[ $installed != "ii  $version" || ! -e "/lib/modules/$release/build/include/config/auto.conf" ]]; then
    sudo -n apt-get -o Acquire::Retries=5 install -y --no-install-recommends "${headers[@]}"
    break
  fi
done
mkdir "$work/kernel"
for package in linux-signed-*/*.deb linux-hwe-*/linux-modules*.deb; do
  dpkg-deb -x "$package" "$work/kernel"
done
depmod -b "$work/kernel" "$release"
install -m 0644 "$work/kernel/boot/vmlinuz-$release" "$base/vmlinuz"
cd "$work"
if [[ -z ${AMDGPU_SOURCE_DIR:-} ]]; then
  git clone --quiet --no-checkout --depth 1 --branch amdgpu-31.50 \
    https://github.com/ROCm/amdgpu.git amdgpu
  AMDGPU_SOURCE_DIR=$work/amdgpu
fi
python3 "$guest/export_dkms.py" "$AMDGPU_SOURCE_DIR" "$driver_commit" "$work/dkms" \
  --archive "$base/amdgpu-source.tar.gz"
(cd dkms/amd/dkms && bash autogen.sh)
make -C dkms KERNELVER="$release" num_cpu_cores="$jobs"
python3 "$guest/stage_modules.py" "$work/kernel" "$release" "$work/dkms" "$base/modules"
rm -rf -- "$work/dkms" "$work/kernel" "$work/packages"

git clone --quiet --depth 1 --branch v10.1.0 https://gitlab.com/qemu-project/qemu.git qemu
bash "$rocjitsu/scripts/apply-qemu-pcie-fixes.sh" "$work/qemu"
mkdir qemu-build
cd qemu-build
../qemu/configure --target-list=x86_64-softmmu --without-default-features \
  --enable-tcg --disable-docs --disable-werror
ninja -j "$jobs" qemu-system-x86_64
install -s -m 0755 qemu-system-x86_64 "$base/qemu/bin/"
cp "$work"/qemu/pc-bios/*.{bin,rom} "$base/qemu/share/qemu/"
"$base/qemu/bin/qemu-system-x86_64" -device help > "$work/devices"
grep -q '"vfio-user-pci"' "$work/devices"
# Exercise ROM lookup from the installed layout independently of the build tree.
printf 'quit\n' | "$base/qemu/bin/qemu-system-x86_64" -machine q35,accel=tcg \
  -S -nodefaults -display none -serial none -monitor stdio
(cd "$base" && find . -type f ! -name SHA256SUMS -print0 | sort -z | xargs -0 sha256sum > SHA256SUMS)
mv -T "$base" "$out"
