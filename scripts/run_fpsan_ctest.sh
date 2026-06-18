#!/usr/bin/env bash
set -uo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/run_fpsan_ctest.sh [options]

Configures corpus/fpsan and runs selected FPSAN CTest cases listed in a target
config JSON file.

Options:
  --config FILE        FPSAN config JSON. Default: corpus/fpsan/configs/general.json
  --out-dir DIR        Output directory for logs, build tree, and results.csv.
  --case TEXT          Run tests whose name contains TEXT.
  --limit N            Stop after N matching tests.
  --timeout SECS       Timeout for configure, build, and ctest steps. 0 disables.
  --list               Print selected tests without running them.
  -h, --help           Show this help.

Environment overrides:
  PYTHON               Default: python3
  TIMEOUT_SECS         Default: 10. Set to 0 for no timeout.
  CMAKE                Default: cmake
  CTEST                Default: ctest
EOF
}

die() {
  echo "error: $*" >&2
  exit 2
}

csv_escape() {
  local s=${1//\"/\"\"}
  printf '"%s"' "$s"
}

fmt_ms_as_s() {
  local ms=$1
  printf '%d.%03d' "$((ms / 1000))" "$((ms % 1000))"
}

quote_command() {
  local arg
  printf '%q' "$1"
  shift
  for arg in "$@"; do
    printf ' %q' "$arg"
  done
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_file="corpus/fpsan/configs/general.json"
out_dir=${OUT_DIR:-}
case_filter=
limit=0
list_only=0
timeout_secs=

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config)
      [[ $# -ge 2 ]] || die "--config requires a value"
      config_file=$2
      shift 2
      ;;
    --out-dir)
      [[ $# -ge 2 ]] || die "--out-dir requires a value"
      out_dir=$2
      shift 2
      ;;
    --case)
      [[ $# -ge 2 ]] || die "--case requires a value"
      case_filter=$2
      shift 2
      ;;
    --limit)
      [[ $# -ge 2 ]] || die "--limit requires a value"
      limit=$2
      shift 2
      ;;
    --timeout)
      [[ $# -ge 2 ]] || die "--timeout requires a value"
      timeout_secs=$2
      shift 2
      ;;
    --timeout=*)
      timeout_secs=${1#--timeout=}
      shift
      ;;
    --list)
      list_only=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      die "unknown option: $1"
      ;;
    *)
      die "unexpected positional argument: $1"
      ;;
  esac
done

[[ "$limit" =~ ^[0-9]+$ ]] || die "--limit must be an integer"

if [[ "$config_file" != /* ]]; then
  config_file="$repo_root/$config_file"
fi
[[ -r "$config_file" ]] || die "cannot read config file: $config_file"

export LC_ALL=C

PYTHON=${PYTHON:-python3}
TIMEOUT_SECS=${TIMEOUT_SECS:-10}
CMAKE=${CMAKE:-cmake}
CTEST=${CTEST:-ctest}
if [[ -n "$timeout_secs" ]]; then
  TIMEOUT_SECS=$timeout_secs
fi

[[ "$TIMEOUT_SECS" =~ ^[0-9]+$ ]] || die "TIMEOUT_SECS must be an integer"
command -v "$PYTHON" >/dev/null 2>&1 || die "missing tool in PATH: $PYTHON"
if (( list_only == 0 )); then
  command -v "$CMAKE" >/dev/null 2>&1 || die "missing tool in PATH: $CMAKE"
  command -v "$CTEST" >/dev/null 2>&1 || die "missing tool in PATH: $CTEST"
fi

config_name=
hip_architectures=
selected_tests=()
selected_count=0

while IFS= read -r line; do
  case "$line" in
    CONFIG_NAME=*)
      config_name=${line#CONFIG_NAME=}
      ;;
    HIP_ARCHITECTURES=*)
      hip_architectures=${line#HIP_ARCHITECTURES=}
      ;;
    TEST=*)
      test_name=${line#TEST=}
      if [[ -n "$case_filter" && "$test_name" != *"$case_filter"* ]]; then
        continue
      fi
      selected_tests+=("$test_name")
      selected_count=$((selected_count + 1))
      if (( limit > 0 && selected_count >= limit )); then
        break
      fi
      ;;
  esac
done < <(
  "$PYTHON" - "$config_file" <<'PY'
import json
import pathlib
import sys

config_path = pathlib.Path(sys.argv[1])
with config_path.open("r", encoding="utf-8") as f:
    config = json.load(f)

if not isinstance(config, dict):
    raise SystemExit(f"{config_path} must be a JSON object")

for field in ("config_name", "hip_architectures", "tests"):
    if field not in config:
        raise SystemExit(f"{config_path} is missing required field '{field}'")

config_name = config["config_name"]
hip_architectures = config["hip_architectures"]
tests = config["tests"]

if not isinstance(config_name, str) or not config_name:
    raise SystemExit(f"{config_path} has invalid config_name")
if not isinstance(hip_architectures, list):
    raise SystemExit(f"{config_path} field hip_architectures must be a list")
if not isinstance(tests, list):
    raise SystemExit(f"{config_path} field tests must be a list")

for item in hip_architectures:
    if not isinstance(item, str) or not item:
        raise SystemExit(f"{config_path} has invalid hip_architecture entry")

for test_name in tests:
    if not isinstance(test_name, str) or not test_name:
        raise SystemExit(f"{config_path} has invalid test entry")

print(f"CONFIG_NAME={config_name}")
print(f"HIP_ARCHITECTURES={';'.join(hip_architectures)}")
for test_name in tests:
    print(f"TEST={test_name}")
PY
)

[[ -n "$config_name" ]] || die "failed to parse config_name from $config_file"

if [[ -z "$out_dir" ]]; then
  out_dir="$repo_root/results-fpsan-$config_name-$(date +%Y%m%d-%H%M%S)"
fi

if (( list_only == 0 )); then
  mkdir -p "$out_dir/logs" "$out_dir/build"
  results_csv="$out_dir/results.csv"
  printf 'kind,config,name,status,elapsed_s,returncode,log\n' > "$results_csv"
else
  results_csv=
fi

build_dir="$out_dir/build/$config_name"
fpsan_source_dir="$repo_root/corpus/fpsan"

echo "config:   $config_file"
echo "profile:  $config_name"
if [[ -n "$hip_architectures" ]]; then
  echo "arches:   $hip_architectures"
else
  echo "arches:   <none>"
fi
if (( list_only == 0 )); then
  echo "out:      $out_dir"
fi

if (( list_only != 0 )); then
  for test_name in "${selected_tests[@]}"; do
    echo "$test_name"
  done
  echo "listed ${#selected_tests[@]} test(s)"
  exit 0
fi

configure_log="$out_dir/logs/configure.log"
configure_cmd=(
  "$CMAKE"
  -S "$fpsan_source_dir"
  -B "$build_dir"
)
if [[ -n "$hip_architectures" ]]; then
  configure_cmd+=("-DCMAKE_HIP_ARCHITECTURES=$hip_architectures")
fi
if [[ -n "${ROCM_PATH:-}" ]]; then
  configure_cmd+=("-DROCM_PATH=$ROCM_PATH")
fi

{
  printf 'CONFIG: %q\n' "$config_file"
  printf 'BUILD_DIR: %q\n' "$build_dir"
  printf 'COMMAND: '
  quote_command "${configure_cmd[@]}"
  printf '\n\n'
} > "$configure_log"

if (( TIMEOUT_SECS > 0 )); then
  timeout --foreground "$TIMEOUT_SECS" "${configure_cmd[@]}" >> "$configure_log" 2>&1 || die "cmake configure failed: $configure_log"
else
  "${configure_cmd[@]}" >> "$configure_log" 2>&1 || die "cmake configure failed: $configure_log"
fi

total=0
failures=0

run_case() {
  local test_name=$1
  local safe_name=${test_name//[^A-Za-z0-9_.-]/_}
  local log="$out_dir/logs/fpsan_${safe_name}.log"
  local build_rc ctest_rc rc status start_ns end_ns elapsed_ms elapsed_s

  local build_cmd=("$CMAKE" --build "$build_dir" --target "$test_name")
  local ctest_cmd=("$CTEST" --test-dir "$build_dir" -R "^${test_name}$" --output-on-failure)

  {
    printf 'CONFIG: %q\n' "$config_file"
    printf 'BUILD_DIR: %q\n' "$build_dir"
    printf 'BUILD: '
    quote_command "${build_cmd[@]}"
    printf '\n'
    printf 'CTEST: '
    quote_command "${ctest_cmd[@]}"
    printf '\n\n'
  } > "$log"

  printf '%-6s %-56s ' "fpsan" "$test_name"
  start_ns=$(date +%s%N)
  if (( TIMEOUT_SECS > 0 )); then
    timeout --foreground "$TIMEOUT_SECS" "${build_cmd[@]}" >> "$log" 2>&1
  else
    "${build_cmd[@]}" >> "$log" 2>&1
  fi
  build_rc=$?

  if (( TIMEOUT_SECS > 0 )); then
    timeout --foreground "$TIMEOUT_SECS" "${ctest_cmd[@]}" >> "$log" 2>&1
  else
    "${ctest_cmd[@]}" >> "$log" 2>&1
  fi
  ctest_rc=$?

  end_ns=$(date +%s%N)
  elapsed_ms=$(((end_ns - start_ns) / 1000000))
  elapsed_s=$(fmt_ms_as_s "$elapsed_ms")

  rc=$ctest_rc
  if [[ "$ctest_rc" -eq 0 ]]; then
    status=PASS
  else
    status=FAIL
  fi

  if [[ "$build_rc" -ne 0 ]]; then
    printf 'BUILD_RETURN_CODE: %s\n' "$build_rc" >> "$log"
  fi
  printf 'CTEST_RETURN_CODE: %s\n' "$ctest_rc" >> "$log"

  printf '%s %ss\n' "$status" "$elapsed_s"
  csv_escape "fpsan" >> "$results_csv"
  printf ',' >> "$results_csv"
  csv_escape "$config_name" >> "$results_csv"
  printf ',' >> "$results_csv"
  csv_escape "$test_name" >> "$results_csv"
  printf ',%s,%s,%s,' "$status" "$elapsed_s" "$rc" >> "$results_csv"
  csv_escape "$log" >> "$results_csv"
  printf '\n' >> "$results_csv"

  [[ "$status" == PASS ]]
}

for test_name in "${selected_tests[@]}"; do
  if run_case "$test_name"; then
    :
  else
    failures=$((failures + 1))
  fi
  total=$((total + 1))
done

echo
echo "results: $results_csv"
echo "passed:  $((total - failures))/$total"
echo "failed:  $failures/$total"

if (( failures != 0 )); then
  exit 1
fi
