#!/usr/bin/env bash
# Copyright Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT
#
# Purpose: generate TensileLite candidate bundles for every YAML in a directory.
#
# What this script does:
#   1. Discover *.yaml files in YAML_DIR (sorted).
#   2. Invoke generate-kernels.sh once per file, writing each bundle under
#      CANDIDATES_DIR/<yaml-stem>/.
#
# Example:
#   ./generate-all-kernels.sh \
#     examples/gfx1250-test-list \
#     candidates/gfx1250-test-list \
#     --gpu-targets gfx1250

set -euo pipefail

usage() {
  echo "usage: $0 YAML_DIR CANDIDATES_DIR [Tensile options]" >&2
}

if (( $# < 2 )); then
  usage
  exit 2
fi

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
generate_kernels="$root_dir/generate-kernels.sh"
yaml_dir=$1
candidates_dir=$2
shift 2

if [[ ! -x "$generate_kernels" ]]; then
  echo "error: generate-kernels.sh is missing or not executable: $generate_kernels" >&2
  exit 1
fi
if [[ ! -d "$yaml_dir" ]]; then
  echo "error: yaml directory does not exist: $yaml_dir" >&2
  exit 1
fi

yaml_dir=$(cd "$yaml_dir" && pwd)
mkdir -p "$candidates_dir"
candidates_dir=$(cd "$candidates_dir" && pwd)

mapfile -d '' yaml_files < <(
  find "$yaml_dir" -maxdepth 1 -type f -name '*.yaml' -print0 | sort -z
)
if (( ${#yaml_files[@]} == 0 )); then
  echo "error: no *.yaml files found in $yaml_dir" >&2
  exit 1
fi

total=${#yaml_files[@]}
echo "Generating candidates for $total YAML file(s) in $yaml_dir"
echo "Output root: $candidates_dir"
echo

for index in "${!yaml_files[@]}"; do
  yaml_file=${yaml_files[$index]}
  yaml_name=$(basename "$yaml_file")
  candidate_name=${yaml_name%.yaml}
  candidate_dir="$candidates_dir/$candidate_name"
  step=$(( index + 1 ))

  echo "[$step/$total] $yaml_name -> $candidate_dir"
  "$generate_kernels" "$yaml_file" "$candidate_dir" "$@"
  echo
done

echo "Generated $total candidate bundle(s) under $candidates_dir"
