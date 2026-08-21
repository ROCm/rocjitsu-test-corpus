#!/usr/bin/env bash
# Copyright Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT
#
# Purpose: validate each TensileLite kernel solution in isolation and record
# its wall-clock elapsed time.
#
# What this script does:
#   1. Discover every ClientParameters.ini below CASE_ROOT.
#   2. Read the generated solution indices from each case library.
#   3. Run validate-kernel-case.sh once per solution, serially.
#   4. Measure each isolated validation with GNU time and write a CSV summary.
#
# Example:
#   ./validate-kernel-solutions.sh \
#     candidates/gfx1250-all/1024_vgpr_gfx1250/gemms/Cijk_Ailk_Bjlk_BBS_BH_Bias_HA_S_SAV_UserArgs_00
#
#   ./validate-kernel-solutions.sh \
#     --output-csv logs/1024-vgpr-kernels.csv \
#     candidates/gfx1250-all/1024_vgpr_gfx1250/gemms/Cijk_Ailk_Bjlk_BBS_BH_Bias_HA_S_SAV_UserArgs_00

set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
validate_case="$root_dir/validate-kernel-case.sh"

usage() {
  echo "usage: $0 [--output-csv FILE] CASE_ROOT" >&2
}

output_csv=
case_root=

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
      if [[ -n "$case_root" ]]; then
        echo "error: only one case root may be specified" >&2
        usage
        exit 2
      fi
      case_root=$1
      ;;
  esac
  shift
done

if [[ -z "$case_root" ]]; then
  usage
  exit 2
fi
if [[ ! -d "$case_root" ]]; then
  echo "error: case root does not exist: $case_root" >&2
  exit 1
fi
if [[ ! -x "$validate_case" ]]; then
  echo "error: validate-kernel-case.sh is missing or not executable: $validate_case" >&2
  exit 1
fi

time_command=$(type -P time || true)
if [[ -z "$time_command" ]]; then
  echo "error: GNU time is not available on PATH" >&2
  exit 1
fi

case_root=$(cd "$case_root" && pwd)
if [[ -z "$output_csv" ]]; then
  output_csv="$case_root/kernel-validation-results.csv"
fi

mapfile -d '' parameter_files < <(
  find "$case_root" -type f -name ClientParameters.ini -print0 | sort -z
)
if (( ${#parameter_files[@]} == 0 )); then
  echo "error: no ClientParameters.ini files found under: $case_root" >&2
  exit 1
fi

: "${ROCM_PATH:=$(rocm-sdk path --root)}"
export ROCM_PATH
export PATH="$ROCM_PATH/bin:$ROCM_PATH/lib/llvm/bin:$PATH"
export LD_LIBRARY_PATH="$ROCM_PATH/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

mkdir -p "$(dirname "$output_csv")"
timing_file=$(mktemp "${TMPDIR:-/tmp}/tensilelite-kernel-time.XXXXXX")
cleanup() {
  rm -f -- "$timing_file"
}
trap cleanup EXIT

failed=0
kernel_count=0
printf 'test_name,solution_index,elapsed_time,status\n' >"$output_csv"

for parameter_file in "${parameter_files[@]}"; do
  case_dir=$(dirname "$parameter_file")
  library_file=
  while IFS='=' read -r key value; do
    if [[ "$key" == library-file ]]; then
      if [[ -n "$library_file" ]]; then
        echo "error: multiple library-file entries in: $parameter_file" >&2
        exit 1
      fi
      library_file=$value
    fi
  done <"$parameter_file"

  if [[ -z "$library_file" ]]; then
    echo "error: library-file is missing from: $parameter_file" >&2
    exit 1
  fi
  if [[ "$library_file" = /* ]]; then
    echo "error: case contains an absolute library-file path: $library_file" >&2
    exit 1
  fi
  library_path="$case_dir/$library_file"
  if [[ ! -f "$library_path" ]]; then
    echo "error: case library does not exist: $library_path" >&2
    exit 1
  fi

  mapfile -t solution_indices < <(
    awk '
      /^solutions:$/ { in_solutions = 1; next }
      in_solutions && /^  index: [0-9]+$/ { print $2 }
    ' "$library_path"
  )
  if (( ${#solution_indices[@]} == 0 )); then
    echo "error: no solution indices found in generated library: $library_path" >&2
    exit 1
  fi

  if [[ "$case_dir" == "$case_root" ]]; then
    case_name=$(basename "$case_dir")
  else
    case_name=${case_dir#"$case_root"/}
  fi

  for solution_index in "${solution_indices[@]}"; do
    test_name="$case_name.solution-$solution_index"
    : >"$timing_file"
    set +e
    row=$(
      "$time_command" -f '%e' -o "$timing_file" \
        "$validate_case" \
        --test-name "$test_name" \
        --solution-index "$solution_index" \
        "$case_dir"
    )
    return_code=$?
    set -e

    elapsed_time=$(<"$timing_file")
    status=${row##*,}
    if [[ -z "$row" || -z "$elapsed_time" ]]; then
      status=ERROR
    fi
    if (( return_code != 0 )) || [[ "$status" != PASS ]]; then
      failed=1
    fi

    printf '%s,%s,%s,%s\n' \
      "$test_name" "$solution_index" "$elapsed_time" "$status" \
      >>"$output_csv"
    (( kernel_count += 1 ))
    echo "[$kernel_count] ${elapsed_time}s $status $test_name" >&2
  done
done

echo "Results: $output_csv"
echo "Kernel solutions: $kernel_count"
if (( failed )); then
  exit 1
fi
