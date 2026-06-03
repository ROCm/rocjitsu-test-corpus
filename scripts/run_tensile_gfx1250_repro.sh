#!/usr/bin/env bash
set -uo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/run_tensile_gfx1250_repro.sh [options] ENV_FILE

Sources ENV_FILE, then runs the packaged Tensile gfx1250 YAML configs through
Tensile.Tensile().

By default this rebuilds all runnable configs in build-only mode. Use --numeric
to run Tensile's benchmark/validation path instead; numeric mode defaults to a
small smoke list unless --all or --case is supplied.

Options:
  --numeric              Run benchmark/validation instead of build-only.
  --all                  In numeric mode, run every runnable config.
  --case TEXT            Run configs whose path contains TEXT.
  --limit N              Stop after N matching configs.
  --out-dir DIR          Output directory for logs and results.csv.
  --tensilelite-root DIR ROCm rocm-libraries/projects/hipblaslt/tensilelite.
  --prebuilt-client EXE  tensilelite-client for numeric mode.
  --tensile-option ARG   Extra option passed to Tensile.Tensile(); repeatable.
  --list                 Print selected configs without running them.
  -h, --help             Show this help.

Environment overrides:
  PYTHON                 Default: python
  TENSILELITE_ROOT       Used if --tensilelite-root is omitted.
  TENSILE_PREBUILT_CLIENT Used if --prebuilt-client is omitted.
  TIMEOUT_SECS           Default: 0, meaning no timeout.
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
env_file=
out_dir=${OUT_DIR:-}
mode=build-only
run_all=0
case_filter=
limit=0
list_only=0
tensilelite_root=${TENSILELITE_ROOT:-}
prebuilt_client=${TENSILE_PREBUILT_CLIENT:-}
tensile_options=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --numeric)
      mode=numeric
      shift
      ;;
    --all)
      run_all=1
      shift
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
    --out-dir)
      [[ $# -ge 2 ]] || die "--out-dir requires a value"
      out_dir=$2
      shift 2
      ;;
    --tensilelite-root)
      [[ $# -ge 2 ]] || die "--tensilelite-root requires a value"
      tensilelite_root=$2
      shift 2
      ;;
    --prebuilt-client)
      [[ $# -ge 2 ]] || die "--prebuilt-client requires a value"
      prebuilt_client=$2
      shift 2
      ;;
    --tensile-option)
      [[ $# -ge 2 ]] || die "--tensile-option requires a value"
      tensile_options+=("$2")
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
[[ "$limit" =~ ^[0-9]+$ ]] || die "--limit must be an integer"

env_file="$(cd "$(dirname "$env_file")" && pwd)/$(basename "$env_file")"

set -a
# shellcheck source=/dev/null
source "$env_file"
set +a

export LC_ALL=C

PYTHON=${PYTHON:-python}
TIMEOUT_SECS=${TIMEOUT_SECS:-0}
[[ "$TIMEOUT_SECS" =~ ^[0-9]+$ ]] || die "TIMEOUT_SECS must be an integer"

if [[ -z "$tensilelite_root" ]]; then
  for candidate in \
    "$repo_root/../upstream-rocm-libraries/projects/hipblaslt/tensilelite" \
    "$repo_root/../rocm-libraries/projects/hipblaslt/tensilelite"; do
    if [[ -d "$candidate/Tensile" ]]; then
      tensilelite_root=$candidate
      break
    fi
  done
fi
[[ -n "$tensilelite_root" ]] || die "set TENSILELITE_ROOT or pass --tensilelite-root"
tensilelite_root="$(cd "$tensilelite_root" && pwd)"
[[ -d "$tensilelite_root/Tensile" ]] || die "not a TensileLite root: $tensilelite_root"

if [[ "$mode" == numeric && -z "$prebuilt_client" ]]; then
  prebuilt_client="$tensilelite_root/build_tmp/tensilelite/client/tensilelite-client"
fi
if [[ -n "$prebuilt_client" && -d "$(dirname "$prebuilt_client")" ]]; then
  prebuilt_client="$(cd "$(dirname "$prebuilt_client")" && pwd)/$(basename "$prebuilt_client")"
fi

manifest="$repo_root/corpus/tensile/manifest.csv"
smoke_list="$repo_root/corpus/tensile/numeric-smoke-configs.txt"
[[ -r "$manifest" ]] || die "missing manifest: $manifest"
if [[ "$mode" == numeric && "$run_all" -eq 0 && -z "$case_filter" ]]; then
  [[ -r "$smoke_list" ]] || die "missing numeric smoke list: $smoke_list"
fi

if [[ -z "$out_dir" ]]; then
  env_name=$(basename "$env_file")
  env_name=${env_name%.sh}
  out_dir="$repo_root/results-tensile-$mode-$env_name-$(date +%Y%m%d-%H%M%S)"
fi

if (( list_only == 0 )); then
  mkdir -p "$out_dir/logs"
  results_csv="$out_dir/results.csv"
  printf 'case_id,config,mode,status,elapsed_s,returncode,output_dir,log\n' > "$results_csv"
else
  results_csv=
fi

export PYTHONPATH="$tensilelite_root:${PYTHONPATH:-}"

if (( list_only == 0 )); then
  "$PYTHON" - <<'PY' >/dev/null
from Tensile import Tensile as tensile_mod
assert tensile_mod
PY
  if [[ "$mode" == numeric && ! -x "$prebuilt_client" ]]; then
    die "numeric mode needs tensilelite-client; run scripts/build_tensilelite_repro.sh or pass --prebuilt-client"
  fi
fi

is_selected() {
  local config=$1

  if [[ -n "$case_filter" ]]; then
    [[ "$config" == *"$case_filter"* ]]
    return $?
  fi

  if [[ "$mode" == numeric && "$run_all" -eq 0 ]]; then
    grep -Fxq "$config" "$smoke_list"
    return $?
  fi

  return 0
}

run_case() {
  local case_id=$1
  local config=$2
  local config_path="$repo_root/corpus/tensile/configs/$config"
  local case_out="$out_dir/work/$case_id"
  local safe_name=${case_id//[^A-Za-z0-9_.-]/_}
  local log="$out_dir/logs/${safe_name}.log"
  local args=("$config_path" "$case_out" "--gpu-targets" "gfx1250")

  [[ -r "$config_path" ]] || die "missing config: $config_path"
  if [[ "$mode" == build-only ]]; then
    args+=("--build-only")
  elif [[ -n "$prebuilt_client" ]]; then
    args+=("--prebuilt-client" "$prebuilt_client")
  fi
  args+=("${tensile_options[@]}")

  if (( list_only != 0 )); then
    printf '%s %s\n' "$case_id" "$config"
    return 0
  fi

  mkdir -p "$case_out"
  {
    printf 'ENV_FILE: %q\n' "$env_file"
    printf 'TENSILELITE_ROOT: %q\n' "$tensilelite_root"
    if [[ -n "$prebuilt_client" ]]; then
      printf 'PREBUILT_CLIENT: %q\n' "$prebuilt_client"
    fi
    printf 'MODE: %s\n' "$mode"
    printf 'COMMAND: '
    quote_command "$PYTHON" -c 'import sys; from Tensile import Tensile as tensile_mod; tensile_mod.Tensile(sys.argv[1:])' "${args[@]}"
    printf '\n\n'
  } > "$log"

  printf '%-28s %-7s ' "$case_id" "$mode"
  local start_ns end_ns elapsed_ms elapsed_s rc status
  start_ns=$(date +%s%N)
  if (( TIMEOUT_SECS > 0 )); then
    (cd "$case_out" && timeout --foreground "$TIMEOUT_SECS" "$PYTHON" -c \
      'import sys; from Tensile import Tensile as tensile_mod; tensile_mod.Tensile(sys.argv[1:])' \
      "${args[@]}") >> "$log" 2>&1
  else
    (cd "$case_out" && "$PYTHON" -c \
      'import sys; from Tensile import Tensile as tensile_mod; tensile_mod.Tensile(sys.argv[1:])' \
      "${args[@]}") >> "$log" 2>&1
  fi
  rc=$?
  end_ns=$(date +%s%N)
  elapsed_ms=$(((end_ns - start_ns) / 1000000))
  elapsed_s=$(fmt_ms_as_s "$elapsed_ms")

  if [[ "$rc" -eq 0 ]]; then
    status=PASS
  else
    status=FAIL
  fi

  printf '%s %ss\n' "$status" "$elapsed_s"
  csv_escape "$case_id" >> "$results_csv"
  printf ',' >> "$results_csv"
  csv_escape "$config" >> "$results_csv"
  printf ',%s,%s,%s,%s,' "$mode" "$status" "$elapsed_s" "$rc" >> "$results_csv"
  csv_escape "$case_out" >> "$results_csv"
  printf ',' >> "$results_csv"
  csv_escape "$log" >> "$results_csv"
  printf '\n' >> "$results_csv"

  [[ "$rc" -eq 0 ]]
}

echo "env:             $env_file"
echo "tensilelite:     $tensilelite_root"
echo "mode:            $mode"
if [[ "$mode" == numeric && "$run_all" -eq 0 && -z "$case_filter" ]]; then
  echo "numeric configs: smoke"
fi
if (( list_only == 0 )); then
  echo "out:             $out_dir"
fi

total=0
failures=0
while IFS=, read -r case_id config _elapsed _artifact_count; do
  [[ "$case_id" != "case_id" ]] || continue
  is_selected "$config" || continue

  if run_case "$case_id" "$config"; then
    :
  else
    failures=$((failures + 1))
  fi
  total=$((total + 1))
  if (( limit > 0 && total >= limit )); then
    break
  fi
done < "$manifest"

if (( list_only != 0 )); then
  echo "listed $total config(s)"
elif (( failures == 0 )); then
  echo "passed $total config(s)"
else
  echo "failed $failures of $total config(s)"
  exit 1
fi
