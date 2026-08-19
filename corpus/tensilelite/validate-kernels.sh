#!/usr/bin/env bash
# Copyright Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT
#
# Purpose: validate every case in a candidate bundle and write a CSV summary.
#
# What this script does:
#   1. Discover every ClientParameters.ini under CANDIDATE_DIR.
#   2. Call validate-kernel-case.sh once per case.
#   3. Write validation-results.csv with:
#        test_name,elapsed_seconds,status
#
# Example:
#   ./build-client.sh
#   ./validate-kernels.sh candidates/small-gemm
#   ./validate-kernels.sh --output-csv logs/fp16-validation.csv candidates/gfx1250-all/fp16_gfx1250

set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
validate_case="$root_dir/validate-kernel-case.sh"

usage() {
  echo "usage: $0 [--output-csv FILE] CANDIDATE_DIR" >&2
}

output_csv=
candidate_dir=

while (( $# > 0 )); do
  case "$1" in
    --output-csv)
      if (( $# < 2 )); then
        echo "error: --output-csv requires a value" >&2
        usage
        exit 2
      fi
      output_csv=$2
      shift 2
      continue
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      echo "error: unknown option: $1" >&2
      usage
      exit 2
      ;;
    *)
      if [[ -n "$candidate_dir" ]]; then
        echo "error: only one candidate directory may be specified" >&2
        usage
        exit 2
      fi
      candidate_dir=$1
      ;;
  esac
  shift
done

if [[ -z "$candidate_dir" ]]; then
  usage
  exit 2
fi
if [[ ! -d "$candidate_dir" ]]; then
  echo "error: candidate directory does not exist: $candidate_dir" >&2
  exit 1
fi
if [[ ! -x "$validate_case" ]]; then
  echo "error: validate-kernel-case.sh is missing or not executable: $validate_case" >&2
  exit 1
fi

candidate_dir=$(cd "$candidate_dir" && pwd)
if [[ -z "$output_csv" ]]; then
  output_csv="$candidate_dir/validation-results.csv"
fi

mapfile -d '' parameter_files < <(
  find "$candidate_dir" -type f -name ClientParameters.ini -print0 | sort -z
)
if (( ${#parameter_files[@]} == 0 )); then
  echo "error: no ClientParameters.ini files found under: $candidate_dir" >&2
  exit 1
fi

: "${ROCM_PATH:=$(rocm-sdk path --root)}"
export ROCM_PATH
export PATH="$ROCM_PATH/bin:$ROCM_PATH/lib/llvm/bin:$PATH"
export LD_LIBRARY_PATH="$ROCM_PATH/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

mkdir -p "$(dirname "$output_csv")"
failed=0
{
  printf 'test_name,elapsed_seconds,status\n'
  for parameter_file in "${parameter_files[@]}"; do
    case_dir=$(dirname "$parameter_file")
    row=$("$validate_case" "$case_dir" || true)
    printf '%s\n' "$row"
    status=${row##*,}
    if [[ "$status" != PASS ]]; then
      failed=1
    fi
  done
} >"$output_csv"

echo "Results: $output_csv"
echo "Candidate cases: ${#parameter_files[@]}"
if (( failed )); then
  exit 1
fi
