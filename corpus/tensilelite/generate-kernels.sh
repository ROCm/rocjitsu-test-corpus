#!/usr/bin/env bash
# Copyright Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT
#
# Purpose: generate a portable TensileLite candidate bundle from a tuning YAML.
#
# What this script does:
#   1. Run Tensile in build-only mode to compile kernels and code objects.
#   2. Run Tensile again in CPU-only mode to emit ClientParameters.ini files.
#   3. Extract each generated case into a normalized, relocatable bundle:
#        candidate_dir/
#        ├── input.yaml
#        ├── manifest.tsv
#        └── gemms/<gemm>/<step>/<cache>/
#            ├── ClientParameters.ini
#            ├── library/
#            ├── assembly/
#            ├── cache.yaml
#            └── solutions.yaml
#   4. Rewrite ClientParameters.ini paths to be bundle-relative and validate
#      that every referenced library/code object exists.
#
# Example:
#   ./generate-kernels.sh \
#     examples/small-gemm.yaml \
#     candidates/small-gemm \
#     --gpu-targets gfx1250
#
#   ./generate-kernels.sh \
#     input-yaml/fp16_gfx1250.yaml \
#     candidates/gfx1250-all/fp16_gfx1250 \
#     --gpu-targets gfx1250

set -euo pipefail

usage() {
  echo "usage: $0 CONFIG.yaml CANDIDATE_DIR [Tensile options]" >&2
}

if (( $# < 2 )); then
  usage
  exit 2
fi

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
config=$1
candidate_dir=$2
shift 2

if [[ ! -f "$config" ]]; then
  echo "error: config does not exist: $config" >&2
  exit 1
fi
if [[ -e "$candidate_dir" || -L "$candidate_dir" ]]; then
  echo "error: candidate directory already exists: $candidate_dir" >&2
  exit 1
fi
if ! command -v rocm-sdk >/dev/null 2>&1; then
  echo "error: rocm-sdk is not on PATH; activate a compatible ROCm SDK environment" >&2
  exit 1
fi

tensile_options=()
global_parameters=()
while (( $# > 0 )); do
  case "$1" in
    --build-only|--cpu-only|--use-cache)
      echo "error: $1 is controlled by this script" >&2
      exit 2
      ;;
    --global-parameters)
      shift
      parameter_count=0
      while (( $# > 0 )) && [[ "$1" != -* ]]; do
        global_parameters+=("$1")
        (( parameter_count += 1 ))
        shift
      done
      if (( parameter_count == 0 )); then
        echo "error: --global-parameters requires at least one KEY=VALUE argument" >&2
        exit 2
      fi
      continue
      ;;
    *)
      tensile_options+=("$1")
      ;;
  esac
  shift
done

config=$(realpath "$config")
candidate_parent=$(dirname "$candidate_dir")
candidate_name=$(basename "$candidate_dir")
mkdir -p "$candidate_parent"
candidate_parent=$(cd "$candidate_parent" && pwd)
candidate_dir="$candidate_parent/$candidate_name"

work_dir=$(mktemp -d "${TMPDIR:-/tmp}/tensilelite-generate.XXXXXX")
staging_dir=$(mktemp -d "$candidate_parent/.tensilelite-candidates.XXXXXX")

cleanup() {
  rm -rf -- "$work_dir"
  if [[ -n "$staging_dir" && -d "$staging_dir" ]]; then
    rm -rf -- "$staging_dir"
  fi
}
trap cleanup EXIT

sdk_root=$(rocm-sdk path --root)
sdk_tensilelite="$sdk_root/share/hipblaslt/tensilelite"
raw_dir="$work_dir/raw"

export ROCM_PATH="$sdk_root"
export PATH="$sdk_root/bin:$sdk_root/lib/llvm/bin:$PATH"
export PYTHONPATH="$root_dir:$sdk_tensilelite${PYTHONPATH:+:$PYTHONPATH}"
export LD_LIBRARY_PATH="$sdk_root/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

(
  cd "$work_dir"
  python "$root_dir/Tensile/bin/Tensile" "$config" "$raw_dir" \
    "${tensile_options[@]}" \
    --build-only \
    --global-parameters \
      "${global_parameters[@]}" \
      KeepBuildTmp=True
  python "$root_dir/Tensile/bin/Tensile" "$config" "$raw_dir" \
    "${tensile_options[@]}" \
    --use-cache \
    --cpu-only \
    --global-parameters \
      "${global_parameters[@]}" \
      KeepBuildTmp=True \
      NumElementsToValidate=-1 \
      SyncsPerBenchmark=0 \
      NumWarmups=0 \
      EnqueuesPerSync=1 \
      HardwareMonitor=False \
      ForceRedoBenchmarkProblems=True \
      ExitOnFails=2
)

benchmark_root="$raw_dir/1_BenchmarkProblems"
mapfile -d '' parameter_files < <(
  find "$benchmark_root" -type f -name ClientParameters.ini -print0 | sort -z
)
if (( ${#parameter_files[@]} == 0 )); then
  echo "error: Tensile did not generate any client parameter files" >&2
  exit 1
fi

cp -- "$config" "$staging_dir/input.yaml"
printf 'case\tgemm\tstep\tcache\n' > "$staging_dir/manifest.tsv"

for parameter_file in "${parameter_files[@]}"; do
  source_dir=$(dirname "$parameter_file")
  relative_source=${source_dir#"$benchmark_root"/}
  IFS=/ read -r gemm step caches_component cache_id source_component extra <<< "$relative_source"

  if [[ "$caches_component" != caches || "$source_component" != source || -n "${extra:-}" ]]; then
    echo "error: unexpected Tensile output layout: $relative_source" >&2
    exit 1
  fi

  case_relative="gemms/$gemm/$step/$cache_id"
  case_dir="$staging_dir/$case_relative"
  mkdir -p "$case_dir"

  if [[ ! -d "$source_dir/library" ]]; then
    echo "error: generated library directory is missing for $relative_source" >&2
    exit 1
  fi
  cp -a -- "$source_dir/library" "$case_dir/library"

  assembly_dir="$source_dir/build_tmp/SOURCE/assembly"
  if [[ -d "$assembly_dir" ]]; then
    mkdir -p "$case_dir/assembly"
    find "$assembly_dir" -maxdepth 1 -type f \( -name '*.s' -o -name '*.o' \) \
      -exec cp --target-directory="$case_dir/assembly" -- {} +
  fi

  cache_file=$(dirname "$source_dir")/cache.yaml
  if [[ -f "$cache_file" ]]; then
    cp -- "$cache_file" "$case_dir/cache.yaml"
  fi

  solution_file="$benchmark_root/$gemm/Data/$step.yaml"
  if [[ -f "$solution_file" ]]; then
    cp -- "$solution_file" "$case_dir/solutions.yaml"
  fi

  rewritten_parameters="$case_dir/.ClientParameters.ini.tmp"
  while IFS= read -r line || [[ -n "$line" ]]; do
    key=${line%%=*}
    value=${line#*=}
    case "$key" in
      library-file|code-object)
        if [[ "$value" == "$source_dir"/* ]]; then
          value=${value#"$source_dir"/}
        elif [[ "$value" = /* ]]; then
          echo "error: generated $key points outside its case: $value" >&2
          exit 1
        fi
        printf '%s=%s\n' "$key" "$value"
        ;;
      results-file)
        printf 'results-file=results.csv\n'
        ;;
      *)
        printf '%s\n' "$line"
        ;;
    esac
  done < "$parameter_file" > "$rewritten_parameters"
  mv -- "$rewritten_parameters" "$case_dir/ClientParameters.ini"

  while IFS='=' read -r key value; do
    case "$key" in
      library-file|code-object)
        if [[ ! -f "$case_dir/$value" ]]; then
          echo "error: extracted $key is missing for $case_relative: $value" >&2
          exit 1
        fi
        ;;
    esac
  done < "$case_dir/ClientParameters.ini"

  printf '%s\t%s\t%s\t%s\n' "$case_relative" "$gemm" "$step" "$cache_id" \
    >> "$staging_dir/manifest.tsv"
done

mv -- "$staging_dir" "$candidate_dir"
staging_dir=

echo "Candidates: $candidate_dir"
echo "GEMM cases: ${#parameter_files[@]}"
