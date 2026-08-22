#!/usr/bin/env bash
# Copyright Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT
#
# Purpose: validate all candidate bundles produced by generate-all-kernels.sh.
#
# Each immediate subdirectory of CANDIDATES_DIR represents one input YAML. The
# directory name is converted back to <name>.yaml for the top-level CSV report.
# Detailed output from validate-kernels.sh is saved in a single log file. Each
# candidate bundle has a 30-minute timeout so one test cannot block the batch.
#
# Example:
#   ./validate_all-kernels.sh \
#     --candidates-dir candidates/gfx1250-test-list
#
#   ./validate_all-kernels.sh \
#     --candidates-dir candidates/gfx1250-test-list \
#     --output-csv logs/gfx1250-validation.csv \
#     --log-file logs/gfx1250-validation.log

set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
validate_kernels="$root_dir/validate-kernels.sh"
timeout_duration=30m

usage() {
  cat >&2 <<EOF
usage: $0 --candidates-dir DIR [--output-csv FILE] [--log-file FILE]

options:
  --candidates-dir DIR  Output directory created by generate-all-kernels.sh.
  --output-csv FILE     Summary CSV (default: DIR/validation-results.csv).
  --log-file FILE       Combined validation log (default: DIR/validation.log).
  -h, --help            Show this help message.
EOF
}

candidates_dir=
output_csv=
log_file=

while (( $# > 0 )); do
  case "$1" in
    --candidates-dir)
      if (( $# < 2 )); then
        echo "error: --candidates-dir requires a value" >&2
        usage
        exit 2
      fi
      candidates_dir=$2
      shift 2
      ;;
    --output-csv)
      if (( $# < 2 )); then
        echo "error: --output-csv requires a value" >&2
        usage
        exit 2
      fi
      output_csv=$2
      shift 2
      ;;
    --log-file)
      if (( $# < 2 )); then
        echo "error: --log-file requires a value" >&2
        usage
        exit 2
      fi
      log_file=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$candidates_dir" ]]; then
  echo "error: --candidates-dir is required" >&2
  usage
  exit 2
fi
if [[ ! -d "$candidates_dir" ]]; then
  echo "error: candidates directory does not exist: $candidates_dir" >&2
  exit 1
fi
if [[ ! -x "$validate_kernels" ]]; then
  echo "error: validate-kernels.sh is missing or not executable: $validate_kernels" >&2
  exit 1
fi
if ! command -v timeout >/dev/null 2>&1; then
  echo "error: GNU timeout is not available on PATH" >&2
  exit 1
fi

candidates_dir=$(cd "$candidates_dir" && pwd)
: "${output_csv:=$candidates_dir/validation-results.csv}"
: "${log_file:=$candidates_dir/validation.log}"

if [[ "$output_csv" == "$log_file" ]]; then
  echo "error: --output-csv and --log-file must name different files" >&2
  exit 2
fi

mapfile -d '' candidate_dirs < <(
  find "$candidates_dir" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z
)
if (( ${#candidate_dirs[@]} == 0 )); then
  echo "error: no candidate bundles found under: $candidates_dir" >&2
  exit 1
fi

mkdir -p "$(dirname "$output_csv")" "$(dirname "$log_file")"
printf 'test_name,test_result,elapsed_time\n' >"$output_csv"
{
  printf 'Validation started: %s\n' "$(date --iso-8601=seconds)"
  printf 'Candidates directory: %s\n' "$candidates_dir"
  printf 'CSV summary: %s\n' "$output_csv"
  printf 'Candidate bundles: %s\n' "${#candidate_dirs[@]}"
  printf 'Timeout per candidate bundle: %s\n' "$timeout_duration"
} >"$log_file"

failed=0
total=${#candidate_dirs[@]}

for index in "${!candidate_dirs[@]}"; do
  candidate_dir=${candidate_dirs[$index]}
  candidate_name=$(basename "$candidate_dir")
  test_name="$candidate_name.yaml"
  step=$(( index + 1 ))
  candidate_csv="$candidate_dir/validation-results.csv"

  {
    printf '\n===== [%s/%s] %s =====\n' "$step" "$total" "$test_name"
    printf 'Candidate directory: %s\n' "$candidate_dir"
  } >>"$log_file"

  echo "[$step/$total] Validating $test_name"
  start_epoch=$(date +%s)
  if timeout --signal=TERM --kill-after=30s "$timeout_duration" \
      "$validate_kernels" \
      --output-csv "$candidate_csv" \
      "$candidate_dir" >>"$log_file" 2>&1; then
    return_code=0
    test_result=PASS
  else
    return_code=$?
    if (( return_code == 124 || return_code == 137 )); then
      test_result=TIMEOUT
      printf 'error: validation exceeded the %s timeout\n' \
        "$timeout_duration" >>"$log_file"
    else
      test_result=FAIL
    fi
    failed=1
  fi
  elapsed_time=$(( $(date +%s) - start_epoch ))

  printf '%s,%s,%s\n' \
    "$test_name" "$test_result" "$elapsed_time" >>"$output_csv"
  {
    printf 'Test result: %s\n' "$test_result"
    printf 'Exit code: %s\n' "$return_code"
    printf 'Elapsed time: %ss\n' "$elapsed_time"
  } >>"$log_file"
  echo "[$step/$total] ${test_result} (${elapsed_time}s) $test_name"
done

printf '\nValidation finished: %s\n' "$(date --iso-8601=seconds)" >>"$log_file"
echo "Results: $output_csv"
echo "Log: $log_file"

if (( failed )); then
  exit 1
fi
