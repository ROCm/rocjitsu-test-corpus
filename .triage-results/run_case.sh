#!/usr/bin/env bash
# Run one llama test-backend-ops case under a chosen ROCjitsu build tree.
# ASAN needs handle_segv=2 and allow_user_segv_handler=0 because the ROCm
# runtime installs its own SIGSEGV handler that otherwise swallows the fault.
# Usage: ./run_case.sh asan gfx1201 "MUL_MAT(type_a=bf16,...)" out.log
set -euo pipefail

variant="${1:?usage: $0 <plain|trace|asan> <target> <case> <logfile> [config]}"
target="${2:?missing target}"
case_name="${3:?missing case}"
log="${4:?missing logfile}"
config="${5:-}"

results_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
corpus="$(dirname "$results_dir")"
worktree="$HOME/rocjitsu_dev/wt/rocm-systems/llama-root-cause-trace"
rocjitsu_src="$worktree/emulation/rocjitsu"
llvm="$HOME/rocjitsu_dev/.venv/lib/python3.12/site-packages"
llvm="$llvm/_rocm_sdk_devel/lib/llvm"

case "$variant" in
  plain) build="$rocjitsu_src/build" ;;
  trace) build="$rocjitsu_src/build-trace" ;;
  asan) build="$rocjitsu_src/build-asan" ;;
  *) echo "unknown variant: $variant" >&2; exit 2 ;;
esac

if [ -z "$config" ]; then
  config="$results_dir/trace-configs/$target.json"
fi

mkdir -p "$(dirname "$log")"
log="$(cd "$(dirname "$log")" && pwd)/$(basename "$log")"

if [ "$variant" = asan ]; then
  rt="$llvm/lib/clang/23/lib/linux/libclang_rt.asan-x86_64.so"
  export LD_PRELOAD="$rt"
  export ASAN_SYMBOLIZER_PATH="$llvm/bin/llvm-symbolizer"
  export ASAN_OPTIONS="detect_leaks=0:handle_segv=2:allow_user_segv_handler=0:symbolize=1:fast_unwind_on_fatal=0"
  export UBSAN_OPTIONS="print_stacktrace=1:symbolize=1"
fi

cd "$corpus"
set +e
timeout "${RJ_CASE_TIMEOUT:-600}" "$build/tools/rocjitsu/rocjitsu" \
  --config "$config" -- \
  corpus/llama/build/test-backend-ops test -o "$case_name" \
  -b ROCm0 -j 1 --output csv >"$log" 2>&1
status=$?
set -e

echo "exit=$status log=$log"
exit 0
