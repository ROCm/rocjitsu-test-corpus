#!/usr/bin/env bash
# Copyright Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT
# Purpose: verify the Python and ROCm SDK dependencies used by vendored TensileLite.
# Example: export ROCM_PATH=/path/to/rocm (optional), then run ./setup_my.sh

set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

: "${ROCM_PATH:=$(rocm-sdk path --root)}"
export ROCM_PATH

rocm_tensilelite="$ROCM_PATH/share/hipblaslt/tensilelite"
export PATH="$ROCM_PATH/bin:$ROCM_PATH/lib/llvm/bin:$PATH"

for tool in amdclang++ clang-offload-bundler; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "error: $tool is not on PATH" >&2
    exit 1
  fi
done

if ! compgen -G "$rocm_tensilelite/rocisa/_rocisa*.so" >/dev/null; then
  echo "error: compiled rocisa was not found under $rocm_tensilelite/rocisa" >&2
  exit 1
fi

export PYTHONPATH="$root_dir:$rocm_tensilelite${PYTHONPATH:+:$PYTHONPATH}"
export LD_LIBRARY_PATH="$ROCM_PATH/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

python - <<'PY'
import sys

if sys.version_info < (3, 12):
    raise SystemExit("error: rocisa requires Python 3.12+")

import joblib
import packaging
import rocisa
import yaml

print(f"Python: {sys.version.split()[0]}")
print(f"rocisa: {rocisa._rocisa.__file__}")
print("TensileLite dependencies: OK")
PY
