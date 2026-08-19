#!/usr/bin/env bash
# Copyright Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT
#
# Purpose: validate one extracted TensileLite candidate case directory.
#
# What this script does:
#   1. Check that CASE_DIR contains a harness-ready ClientParameters.ini.
#   2. Run tensilelite-client for that case.
#   3. Print one CSV row to stdout: test_name,elapsed_seconds,status
#      Client output is kept in CASE_DIR/validation.log
#
# Example:
#   ./validate-kernel-case.sh \
#     candidates/gfx1250-all/fp16_gfx1250/gemms/Cijk_Ailk_Bjlk_HHS_BH_Bias_HA_S_SAV_UserArgs_00/00_Final/3c0993c997ef
#
#   ./validate-kernel-case.sh \
#     --test-name custom-name \
#     candidates/gfx1250-all/fp16_gfx1250/gemms/Cijk_Ailk_Bjlk_HHS_BH_Bias_HA_S_SAV_UserArgs_00/00_Final/3c0993c997ef

set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
client="$root_dir/build/client/client/tensilelite-client"

usage() {
  echo "usage: $0 [--test-name NAME] CASE_DIR" >&2
}

default_test_name() {
  local dir=$1

  if [[ "$dir" == *"/gemms/"* ]]; then
    printf 'gemms/%s' "${dir#*gemms/}"
    return
  fi
  basename "$dir"
}

test_name=
case_dir=

while (( $# > 0 )); do
  case "$1" in
    --test-name)
      if (( $# < 2 )); then
        echo "error: --test-name requires a value" >&2
        usage
        exit 2
      fi
      test_name=$2
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
      if [[ -n "$case_dir" ]]; then
        echo "error: only one case directory may be specified" >&2
        usage
        exit 2
      fi
      case_dir=$1
      ;;
  esac
  shift
done

if [[ -z "$case_dir" ]]; then
  usage
  exit 2
fi
if [[ ! -d "$case_dir" ]]; then
  echo "error: case directory does not exist: $case_dir" >&2
  exit 1
fi

case_dir=$(cd "$case_dir" && pwd)
if [[ -z "$test_name" ]]; then
  test_name=$(default_test_name "$case_dir")
fi
parameter_file="$case_dir/ClientParameters.ini"
if [[ ! -f "$parameter_file" ]]; then
  echo "error: ClientParameters.ini is missing under: $case_dir" >&2
  exit 1
fi

if [[ ! -x "$client" ]]; then
  echo "error: validation client is not built; run ./build-client.sh first" >&2
  exit 1
fi

: "${ROCM_PATH:=$(rocm-sdk path --root)}"
export ROCM_PATH
export PATH="$ROCM_PATH/bin:$ROCM_PATH/lib/llvm/bin:$PATH"
export LD_LIBRARY_PATH="$ROCM_PATH/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

library_count=0
code_object_count=0
while IFS='=' read -r key value; do
  case "$key" in
    library-file|code-object)
      if [[ "$key" == library-file ]]; then
        (( library_count += 1 ))
      else
        (( code_object_count += 1 ))
      fi
      if [[ "$value" = /* ]]; then
        echo "error: $test_name contains an absolute $key path: $value" >&2
        printf '%s,%s,INVALID\n' "$test_name" 0
        exit 1
      fi
      if [[ ! -f "$case_dir/$value" ]]; then
        echo "error: $test_name is missing $key: $value" >&2
        printf '%s,%s,INVALID\n' "$test_name" 0
        exit 1
      fi
      ;;
  esac
done < "$parameter_file"

if (( library_count == 0 || code_object_count == 0 )); then
  echo "error: $test_name does not identify a library and code object" >&2
  printf '%s,%s,INVALID\n' "$test_name" 0
  exit 1
fi
if ! grep -qx 'num-elements-to-validate=-1' "$parameter_file"; then
  echo "error: $test_name is not configured to validate every output element" >&2
  printf '%s,%s,INVALID\n' "$test_name" 0
  exit 1
fi
if ! grep -qx 'num-syncs-per-benchmark=0' "$parameter_file"; then
  echo "error: $test_name enables benchmark timing iterations" >&2
  printf '%s,%s,INVALID\n' "$test_name" 0
  exit 1
fi

echo "Validating: $test_name" >&2
start_epoch=$(date +%s)
validation_log="$case_dir/validation.log"
return_code=0
status=ERROR

if (
    cd "$case_dir"
    "$client" --config-file ClientParameters.ini
  ) >"$validation_log" 2>&1; then
  if grep -q ',PASSED,' "$validation_log"; then
    status=PASS
  else
    status=FAIL
    return_code=1
    echo "error: no candidate passed numerical validation for $test_name" >&2
  fi
else
  return_code=1
  status=ERROR
  echo "error: client failed for $test_name" >&2
fi

echo "Log: $validation_log" >&2

elapsed=$(( $(date +%s) - start_epoch ))
printf '%s,%s,%s\n' "$test_name" "$elapsed" "$status"
exit "$return_code"
