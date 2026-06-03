#!/usr/bin/env bash
set -uo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/run_gfx1250_regression.sh [options] ENV_FILE

Sources ENV_FILE, then runs the packaged gfx1250 e2e and matmul VMFB checks.

Options:
  --out-dir DIR       Output directory for results.csv and logs.
  --only KIND         all, e2e, or matmul. Default: all.
  --list             Print commands without running them.
  -h, --help         Show this help.

Environment overrides:
  DEVICE                         Default: hip
  TIMEOUT_SECS                   Default: 0, meaning no timeout
  IREE_CHECK_MODULE              Default: iree-check-module
  IREE_E2E_MATMUL_TEST           Default: iree-e2e-matmul-test
  MATMUL_REQUIRE_EXACT_RESULTS   Default: false
  MATMUL_ACCEPTABLE_FP_DELTA     Default: 1e-04
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
export REPO_ROOT="${REPO_ROOT:-$repo_root}"

env_file=
out_dir=${OUT_DIR:-}
only=all
list_only=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out-dir)
      [[ $# -ge 2 ]] || die "--out-dir requires a value"
      out_dir=$2
      shift 2
      ;;
    --only)
      [[ $# -ge 2 ]] || die "--only requires a value"
      only=$2
      shift 2
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
      [[ -z "$env_file" ]] || die "only one ENV_FILE may be provided"
      env_file=$1
      shift
      ;;
  esac
done

[[ -n "$env_file" ]] || { usage >&2; exit 2; }
[[ -r "$env_file" ]] || die "cannot read env file: $env_file"
case "$only" in
  all|e2e|matmul) ;;
  *) die "--only must be all, e2e, or matmul" ;;
esac

env_file="$(cd "$(dirname "$env_file")" && pwd)/$(basename "$env_file")"

set -a
# shellcheck source=/dev/null
source "$env_file"
set +a

export LC_ALL=C

DEVICE=${DEVICE:-hip}
TIMEOUT_SECS=${TIMEOUT_SECS:-0}
IREE_CHECK_MODULE=${IREE_CHECK_MODULE:-iree-check-module}
IREE_E2E_MATMUL_TEST=${IREE_E2E_MATMUL_TEST:-iree-e2e-matmul-test}
MATMUL_REQUIRE_EXACT_RESULTS=${MATMUL_REQUIRE_EXACT_RESULTS:-false}
MATMUL_ACCEPTABLE_FP_DELTA=${MATMUL_ACCEPTABLE_FP_DELTA:-1e-04}

[[ "$TIMEOUT_SECS" =~ ^[0-9]+$ ]] || die "TIMEOUT_SECS must be an integer"
if (( list_only == 0 )); then
  if [[ "$only" == all || "$only" == e2e ]]; then
    command -v "$IREE_CHECK_MODULE" >/dev/null 2>&1 || die "missing tool in PATH: $IREE_CHECK_MODULE"
  fi
  if [[ "$only" == all || "$only" == matmul ]]; then
    command -v "$IREE_E2E_MATMUL_TEST" >/dev/null 2>&1 || die "missing tool in PATH: $IREE_E2E_MATMUL_TEST"
  fi
fi

if [[ -z "$out_dir" ]]; then
  env_name=$(basename "$env_file")
  env_name=${env_name%.sh}
  out_dir="$REPO_ROOT/results-$env_name-$(date +%Y%m%d-%H%M%S)"
fi

if (( list_only == 0 )); then
  mkdir -p "$out_dir/logs"
  results_csv="$out_dir/results.csv"
  printf 'kind,name,status,elapsed_s,returncode,log\n' > "$results_csv"
else
  results_csv=
fi

total=0
failures=0

run_case() {
  local kind=$1
  local name=$2
  shift 2

  if (( list_only != 0 )); then
    printf '[%s] %s: ' "$kind" "$name"
    quote_command "$@"
    printf '\n'
    total=$((total + 1))
    return 0
  fi

  local safe_name=${name//[^A-Za-z0-9_.-]/_}
  local log="$out_dir/logs/${kind}_${safe_name}.log"
  {
    printf 'ENV_FILE: %q\n' "$env_file"
    printf 'PWD: %q\n' "$(pwd)"
    printf 'COMMAND: '
    quote_command "$@"
    printf '\n\n'
  } > "$log"

  printf '%-6s %-56s ' "$kind" "$name"
  local start_ns end_ns elapsed_ms elapsed_s rc status
  start_ns=$(date +%s%N)
  if (( TIMEOUT_SECS > 0 )); then
    timeout --foreground "$TIMEOUT_SECS" "$@" >> "$log" 2>&1
  else
    "$@" >> "$log" 2>&1
  fi
  rc=$?
  end_ns=$(date +%s%N)
  elapsed_ms=$(((end_ns - start_ns) / 1000000))
  elapsed_s=$(fmt_ms_as_s "$elapsed_ms")

  if [[ "$rc" -eq 0 ]]; then
    status=PASS
  else
    status=FAIL
    failures=$((failures + 1))
  fi
  total=$((total + 1))

  printf '%s %ss\n' "$status" "$elapsed_s"
  csv_escape "$kind" >> "$results_csv"
  printf ',' >> "$results_csv"
  csv_escape "$name" >> "$results_csv"
  printf ',%s,%s,%s,' "$status" "$elapsed_s" "$rc" >> "$results_csv"
  csv_escape "$log" >> "$results_csv"
  printf '\n' >> "$results_csv"
}

run_e2e_cases() {
  shopt -s nullglob
  local vmfbs=("$REPO_ROOT"/corpus/e2e/*.vmfb)
  shopt -u nullglob

  if [[ "${#vmfbs[@]}" -eq 0 ]]; then
    echo "warning: no e2e VMFBs found under $REPO_ROOT/corpus/e2e" >&2
    return 0
  fi

  local vmfb name
  for vmfb in "${vmfbs[@]}"; do
    name=$(basename "$vmfb" .vmfb)
    run_case e2e "$name" \
      "$IREE_CHECK_MODULE" \
      --device="$DEVICE" \
      --module="$vmfb"
  done
}

run_matmul_cases() {
  shopt -s nullglob
  local matmul_vmfbs=("$REPO_ROOT"/corpus/matmul/*/*_matmul.vmfb)
  shopt -u nullglob

  if [[ "${#matmul_vmfbs[@]}" -eq 0 ]]; then
    echo "warning: no matmul VMFBs found under $REPO_ROOT/corpus/matmul" >&2
    return 0
  fi

  local matmul_vmfb calls_vmfb name
  for matmul_vmfb in "${matmul_vmfbs[@]}"; do
    calls_vmfb=${matmul_vmfb%_matmul.vmfb}_calls.vmfb
    [[ -r "$calls_vmfb" ]] || die "missing calls VMFB for $matmul_vmfb"
    name=$(basename "$(dirname "$matmul_vmfb")")
    run_case matmul "$name" \
      "$IREE_E2E_MATMUL_TEST" \
      --device="$DEVICE" \
      --module="$matmul_vmfb" \
      --module="$calls_vmfb" \
      --require_exact_results="$MATMUL_REQUIRE_EXACT_RESULTS" \
      --acceptable_fp_delta="$MATMUL_ACCEPTABLE_FP_DELTA"
  done
}

echo "env:    $env_file"
echo "device: $DEVICE"
echo "only:   $only"
if (( list_only == 0 )); then
  echo "out:    $out_dir"
fi

case "$only" in
  all)
    run_e2e_cases
    run_matmul_cases
    ;;
  e2e)
    run_e2e_cases
    ;;
  matmul)
    run_matmul_cases
    ;;
esac

if (( list_only != 0 )); then
  echo "listed $total command(s)"
  exit 0
fi

echo
echo "results: $results_csv"
echo "passed:  $((total - failures))/$total"
echo "failed:  $failures/$total"

if (( failures != 0 )); then
  exit 1
fi
