#!/usr/bin/env bash
# Build the llama.cpp backend-ops corpus executable.
# Usage: ./corpus/llama/build_llama_tests.sh [--targets gfx1201 gfx942] [--build-dir DIR] [--jobs N]
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
build_dir="${source_dir}/build"
jobs="$(( ($(nproc) + 1) / 2 ))"
targets=(gfx1201)

usage() {
  echo "Usage: $0 [--targets GFX_TARGET...] [--build-dir DIR] [--jobs N]" >&2
}

while (( $# )); do
  case "$1" in
    --targets)
      shift
      targets=()
      while (( $# )) && [[ "$1" != --* ]]; do
        targets+=("$1")
        shift
      done
      if (( ${#targets[@]} == 0 )); then
        usage
        exit 2
      fi
      ;;
    --build-dir)
      if (( $# < 2 )); then
        usage
        exit 2
      fi
      build_dir="$2"
      shift 2
      ;;
    --jobs)
      if (( $# < 2 )) || [[ ! "$2" =~ ^[1-9][0-9]*$ ]]; then
        usage
        exit 2
      fi
      jobs="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

target_list="$(IFS=';'; echo "${targets[*]}")"

cmake \
  -S "${source_dir}" \
  -B "${build_dir}" \
  -DCMAKE_HIP_ARCHITECTURES="${target_list}"
cmake --build "${build_dir}" --target test-backend-ops -j "${jobs}"
