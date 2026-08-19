#!/usr/bin/env bash
# Copyright Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT
# Purpose: build the vendored TensileLite correctness-validation client against the ROCm SDK.
# Example: activate a compatible ROCm SDK Python environment, then run ./build-client.sh

set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if ! command -v rocm-sdk >/dev/null 2>&1; then
  echo "error: rocm-sdk is not on PATH; activate the shared ROCm venv" >&2
  exit 1
fi

sdk_root=$(rocm-sdk path --root)
sdk_tensilelite="$sdk_root/share/hipblaslt/tensilelite"
build_dir="$root_dir/build/client"

export ROCM_PATH="$sdk_root"
export PATH="$sdk_root/bin:$sdk_root/lib/llvm/bin:$PATH"
export LD_LIBRARY_PATH="$sdk_root/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

cmake -S "$root_dir" -B "$build_dir" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER="$(command -v amdclang)" \
  -DCMAKE_CXX_COMPILER="$(command -v amdclang++)" \
  -DCMAKE_PREFIX_PATH="$sdk_root;$sdk_root/lib/llvm" \
  -DLLVM_DIR="$sdk_root/lib/llvm/lib/cmake/llvm" \
  -DROCM_PATH="$sdk_root" \
  -DROCISA_INCLUDE_ROOT="$sdk_tensilelite"

cmake --build "$build_dir" --target tensilelite-client --parallel

echo "Client: $build_dir/client/tensilelite-client"
