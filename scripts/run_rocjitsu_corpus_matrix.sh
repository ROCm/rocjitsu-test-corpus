#!/usr/bin/env bash
#
# Usage example:
#   ROCM_VENV=path/to/.venv \
#   ROCJITSU_WORKSPACE=path/to/rocjitsu-workspace \ # contains configs and rocjitsu binary
#   ROCJITSU_EXE=path/to/rocjitsu-binary \
#   run_rocjitsu_corpus_matrix.sh

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ROCJITSU_WORKSPACE=${ROCJITSU_WORKSPACE:-rocjitsu-workspace}
ROCJITSU_EXE=${ROCJITSU_EXE:-rocjitsu}
ROCJITSU_CONFIG_DIR=${ROCJITSU_CONFIG_DIR:-"$ROCJITSU_WORKSPACE/configs"}
ROCM_VENV=${ROCM_VENV:-}
ROCM_PATH=${ROCM_PATH:-}
PYTEST_TIMEOUT_SECONDS=${PYTEST_TIMEOUT_SECONDS:-1200}

if [[ -n "$ROCM_VENV" ]]; then
  export PATH="$ROCM_VENV/bin:$PATH"
fi

if [[ -z "$ROCM_PATH" ]]; then
  if command -v rocm-sdk >/dev/null 2>&1; then
    ROCM_PATH="$(rocm-sdk path --root)"
  else
    echo "Set ROCM_PATH or make rocm-sdk available in PATH." >&2
    exit 2
  fi
fi

export ROCM_PATH
export LD_LIBRARY_PATH="$ROCM_PATH/lib:${LD_LIBRARY_PATH:-}"

targets=(
  "gfx942 gfx942_cdna3.json"
  "gfx950 gfx950_cdna4.json"
  "gfx1100 gfx1100_w7900.json"
  "gfx1201 gfx1201_r9700.json"
  "gfx1250 gfx1250.json"
)

cd "$repo_root"

status=0
for target in "${targets[@]}"; do
  read -r name rocjitsu_config <<< "$target"
  echo "==> pytest ($name)"

  if ! "$ROCJITSU_EXE" \
    --config "$ROCJITSU_CONFIG_DIR/$rocjitsu_config" \
    -- pytest tests/test_corpus.py -vv \
    --target "$name" \
    --suite iree,cts,kernels \
    --timeout "$PYTEST_TIMEOUT_SECONDS"; then
    status=1
  fi
done

exit "$status"
