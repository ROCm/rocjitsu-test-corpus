# Example environment file for gfx1250 kmd.so simulator runs.
#
# Edit ROCJITSU_WORKSPACE or export it before running this file if the RocJITsu
# build lives somewhere else. IREE tools are expected to be in PATH.

ROCJITSU_WORKSPACE=${ROCJITSU_WORKSPACE:-/home/jakub/rocjitsu/gfx1250-dbt}
ROCM_VENV=${ROCM_VENV:-$ROCJITSU_WORKSPACE/venv}

if [[ -x "$ROCM_VENV/bin/rocm-sdk" ]]; then
  SDK_ROOT=$("$ROCM_VENV/bin/rocm-sdk" path --root)
  export ROCM_PATH="$SDK_ROOT"
  export HIP_PATH="$SDK_ROOT"
  export PATH="$ROCM_VENV/bin:$SDK_ROOT/bin:$PATH"
  export LD_LIBRARY_PATH="$SDK_ROOT/lib:$SDK_ROOT/lib64:$SDK_ROOT/lib/llvm/lib:${LD_LIBRARY_PATH:-}"
fi

unset HSA_MODEL_LIB
unset HSA_MODEL_TOPOLOGY
unset HSA_OVERRIDE_GFX_VERSION

export LD_PRELOAD="$ROCJITSU_WORKSPACE/build/lib/rocjitsu/src/rocjitsu/kmd/librocjitsu_kmd.so"
export RJ_CONFIG="$ROCJITSU_WORKSPACE/rocm-systems/emulation/rocjitsu/configs/amdgpu_gfx1250.json"
export HSA_ENABLE_SDMA=1
export ROCPROFILER_REGISTER_ENABLED=0
