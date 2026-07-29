#!/usr/bin/env bash
# Build test-backend-ops from vendored or sparse-checked-out llama.cpp sources.
# Usage: bash corpus/llama/build.sh

set -euo pipefail

source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
targets=${1:-"gfx942;gfx950;gfx1100;gfx1201;gfx1250"}
build_dir=${2:-"$source_dir/build"}
llama_source_dir="$source_dir/third_party/llama.cpp"
jobs=$((($(nproc) + 1) / 2))

if [[ -n "${LLAMACPP_CHECKOUT_HASH:-}" ]]; then
  checkout_dir="$build_dir/llama.cpp-source"
  if [[ ! -d "$checkout_dir/.git" ]]; then
    git init "$checkout_dir"
    git -C "$checkout_dir" remote add origin \
      https://github.com/ggml-org/llama.cpp.git
  fi
  git -C "$checkout_dir" fetch \
    --depth=1 \
    --filter=blob:none \
    origin "$LLAMACPP_CHECKOUT_HASH"
  git -C "$checkout_dir" sparse-checkout init --no-cone
  git -C "$checkout_dir" sparse-checkout set --no-cone \
    /ggml/ \
    /tests/test-backend-ops.cpp
  git -C "$checkout_dir" checkout --detach FETCH_HEAD
  llama_source_dir="$checkout_dir"
fi

cmake \
  -S "$source_dir" \
  -B "$build_dir" \
  "-DCMAKE_HIP_ARCHITECTURES=$targets" \
  "-DLLAMA_CORPUS_SOURCE_DIR=$llama_source_dir"
cmake \
  --build "$build_dir" \
  --target test-backend-ops \
  -j "$jobs"
