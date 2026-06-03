#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/build_tensilelite_repro.sh [options]

Installs the Python dependencies needed by the Tensile gfx1250 corpus, builds
rocisa from the supplied rocm-libraries checkout, and builds tensilelite-client.

Options:
  --env-file FILE        Source FILE first for ROCm/TheRock paths.
  --tensilelite-root DIR ROCm rocm-libraries/projects/hipblaslt/tensilelite.
  --rocm-path DIR        ROCm SDK root. Defaults to ROCM_PATH or rocm-sdk.
  --python EXE           Python interpreter. Defaults to PYTHON or python.
  --gpu-targets LIST     GPU targets for tensilelite-client. Default: gfx1250.
  --build-dir DIR        TensileLite build dir. Default: build_tmp.
  --clean                Remove the client build dir before configuring.
  --skip-python-deps     Do not pip install requirements.txt.
  --skip-rocisa          Do not build/install rocisa.
  --skip-client          Do not build tensilelite-client.
  -h, --help             Show this help.

The build step intentionally unsets runtime-only variables such as LD_PRELOAD
and RJ_CONFIG after sourcing the env file. Use those again when running the
corpus, not while configuring/building the client.
EOF
}

die() {
  echo "error: $*" >&2
  exit 2
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
env_file=
tensilelite_root=${TENSILELITE_ROOT:-}
rocm_path=${ROCM_PATH:-}
python_exe=${PYTHON:-python}
gpu_targets=gfx1250
build_dir=build_tmp
clean=0
install_python_deps=1
build_rocisa=1
build_client=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --env-file)
      [[ $# -ge 2 ]] || die "--env-file requires a value"
      env_file=$2
      shift 2
      ;;
    --tensilelite-root)
      [[ $# -ge 2 ]] || die "--tensilelite-root requires a value"
      tensilelite_root=$2
      shift 2
      ;;
    --rocm-path)
      [[ $# -ge 2 ]] || die "--rocm-path requires a value"
      rocm_path=$2
      shift 2
      ;;
    --python)
      [[ $# -ge 2 ]] || die "--python requires a value"
      python_exe=$2
      shift 2
      ;;
    --gpu-targets)
      [[ $# -ge 2 ]] || die "--gpu-targets requires a value"
      gpu_targets=$2
      shift 2
      ;;
    --build-dir)
      [[ $# -ge 2 ]] || die "--build-dir requires a value"
      build_dir=$2
      shift 2
      ;;
    --clean)
      clean=1
      shift
      ;;
    --skip-python-deps)
      install_python_deps=0
      shift
      ;;
    --skip-rocisa)
      build_rocisa=0
      shift
      ;;
    --skip-client)
      build_client=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

if [[ -n "$env_file" ]]; then
  [[ -r "$env_file" ]] || die "cannot read env file: $env_file"
  env_file="$(cd "$(dirname "$env_file")" && pwd)/$(basename "$env_file")"
  set -a
  # shellcheck source=/dev/null
  source "$env_file"
  set +a
fi

tensilelite_root=${tensilelite_root:-${TENSILELITE_ROOT:-}}
rocm_path=${rocm_path:-${ROCM_PATH:-}}
python_exe=${python_exe:-${PYTHON:-python}}

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

if [[ -z "$rocm_path" && -n "${ROCM_VENV:-}" && -x "$ROCM_VENV/bin/rocm-sdk" ]]; then
  rocm_path=$("$ROCM_VENV/bin/rocm-sdk" path --root)
fi
if [[ -z "$rocm_path" ]] && command -v rocm-sdk >/dev/null 2>&1; then
  rocm_path=$(rocm-sdk path --root)
fi
[[ -n "$rocm_path" ]] || die "set ROCM_PATH, pass --rocm-path, or provide rocm-sdk in PATH"
rocm_path="$(cd "$rocm_path" && pwd)"
[[ -x "$rocm_path/bin/amdclang++" ]] || die "missing amdclang++ under ROCm path: $rocm_path"

if [[ -n "${ROCM_VENV:-}" && -x "$ROCM_VENV/bin/python" && "$python_exe" == python ]]; then
  python_exe="$ROCM_VENV/bin/python"
fi

export ROCM_PATH="$rocm_path"
export HIP_PATH="$rocm_path"
if [[ "$python_exe" == */* ]]; then
  export PATH="$(dirname "$python_exe"):$rocm_path/bin:$PATH"
else
  export PATH="$rocm_path/bin:$PATH"
fi
export LD_LIBRARY_PATH="$rocm_path/lib:$rocm_path/lib64:$rocm_path/lib/llvm/lib:${LD_LIBRARY_PATH:-}"
export CC="$rocm_path/bin/amdclang"
export CXX="$rocm_path/bin/amdclang++"

unset LD_PRELOAD
unset RJ_CONFIG
unset HSA_MODEL_LIB
unset HSA_MODEL_TOPOLOGY
unset HSA_OVERRIDE_GFX_VERSION

echo "tensilelite: $tensilelite_root"
echo "rocm:        $rocm_path"
echo "python:      $python_exe"
echo "targets:     $gpu_targets"

if (( install_python_deps != 0 )); then
  "$python_exe" -m pip install -r "$repo_root/requirements.txt"
fi

if (( build_rocisa != 0 )); then
  nanobind_dir=$("$python_exe" -m nanobind --cmake_dir)
  export CMAKE_ARGS="-DROCM_PATH=$rocm_path -DCMAKE_PREFIX_PATH=$rocm_path;$nanobind_dir -Dnanobind_DIR=$nanobind_dir -DCMAKE_C_COMPILER=$rocm_path/bin/amdclang -DCMAKE_CXX_COMPILER=$rocm_path/bin/amdclang++ -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DROCISA_INCLUDE_BUILD_INFO=ON"
  export CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL:-$(getconf _NPROCESSORS_ONLN)}
  "$python_exe" -m pip install --no-build-isolation -e "$tensilelite_root/rocisa"
fi

if (( build_client != 0 )); then
  client_args=(build-client --gpu-targets "$gpu_targets" --rocm-path "$rocm_path" --build-dir "$build_dir" --export-compile-commands)
  if (( clean != 0 )); then
    client_args+=(--clean)
  fi
  (cd "$tensilelite_root" && invoke "${client_args[@]}")
fi

client_path="$tensilelite_root/$build_dir/tensilelite/client/tensilelite-client"
if [[ -x "$client_path" ]]; then
  echo "client:      $client_path"
else
  echo "client:      not built"
fi
