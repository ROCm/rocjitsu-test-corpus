#!/usr/bin/env bash
# Build the pinned, unmodified HRX AMDGPU CTS for gfx1201 and gfx1250.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="${1:-${repo_root}/.build/hrx-system}"
mkdir -p "$build_root"
build_root="$(cd "$build_root" && pwd)"
source_dir="${build_root}/src"
revision="$(cat "${repo_root}/corpus/hrx-system/revision.txt")"

if [[ ! -e "${source_dir}/.git" ]]; then
  git init "$source_dir"
  git -C "$source_dir" remote add origin https://github.com/ROCm/hrx-system.git
  git -C "$source_dir" fetch --depth 1 origin "$revision"
  git -C "$source_dir" checkout --detach FETCH_HEAD
fi
if [[ "$(git -C "$source_dir" rev-parse HEAD)" != "$revision" ]] ||
   ! git -C "$source_dir" diff --quiet HEAD; then
  echo "Expected an unmodified HRX checkout at ${revision}: ${source_dir}" >&2
  exit 1
fi

rocm_root="$(rocm-sdk path --root)"
mapfile -t cases < "${repo_root}/corpus/hrx-system/cases.txt"
targets=()
for name in "${cases[@]}"; do
  targets+=("iree_hal_drivers_amdgpu_cts_${name}")
done

for gfx in gfx1201 gfx1250; do
  build_dir="${build_root}/build/${gfx}"
  cmake -S "$source_dir" -B "$build_dir" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$rocm_root/llvm/bin/clang" \
    -DCMAKE_CXX_COMPILER="$rocm_root/llvm/bin/clang++" \
    -DCMAKE_AR="$rocm_root/llvm/bin/llvm-ar" \
    -DCMAKE_RANLIB="$rocm_root/llvm/bin/llvm-ranlib" \
    -DIREE_ROCM_PATH="$rocm_root" \
    -DIREE_ROCM_DEPENDENCY_MODE=pinned \
    -DIREE_HAL_DRIVER_AMDGPU=ON \
    -DIREE_HAL_AMDGPU_TARGETS="$gfx" \
    -DIREE_HAL_AMDGPU_DEVICE_BINARY_BUILD_MODE=source \
    -DIREE_BUILD_TESTS=ON \
    -DLIBHRX_BUILD=OFF \
    -DIREE_BUILD_BENCHMARKS=OFF
  cmake --build "$build_dir" --parallel 4 --target "${targets[@]}"
done
