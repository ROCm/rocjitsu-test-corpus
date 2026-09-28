# HRX AMDGPU driver CTS

The opt-in `hrx` suite runs the 16 CTest records under
`runtime/src/iree/hal/drivers/amdgpu/cts` from the HRX revision in
[`revision.txt`](revision.txt). It supports `gfx1201` and `gfx1250`. Source
and build products stay under the ignored `.build/` directory. The suite uses
a pinned TheRock wheel for the ROCm compiler and HSA runtime.

## Build

The build script fetches an unmodified HRX checkout at the pinned revision and
builds the 16 CTS binaries for each target. The adapter checks the revision,
CMake target and binaries before running anything. From this repository's root:

```sh
python -m pip install -r corpus/hrx-system/requirements-rocm.txt
rocm-sdk init
bash scripts/build_hrx_cts.sh
```

The default source and build directories are under `.build/hrx-system`; pass a
different root as the script's first argument. The pinned-header mode avoids
requiring separately installed AQL profile SDK headers. The source device
binary mode is required for gfx1250 because this HRX revision has no prebuilt
gfx1250 binary. HRX's pinned source dependencies need network access on the
first configure.

## Run

Run the suite on the target GPU, or pass the existing corpus wrapper to launch
CTest through RocJITsu. Each selected CTest record runs once and writes a log
under the artifact directory.

To run all 16 CTest records directly (268 Google Test cases in the gfx1201
build), use one CTest command:

```sh
rocm_root="$(rocm-sdk path --root)"
export IREE_HAL_AMDGPU_LIBHSA_PATH="$rocm_root/lib/libhsa-runtime64.so.1"

ctest --test-dir "$PWD/.build/hrx-system/build/gfx1201" \
  -R '^iree/hal/drivers/amdgpu/cts/' --output-on-failure
```

Replace the build directory for gfx1250. Prefix the CTest command with
`rocjitsu --config ... --` when running under the simulator. The gfx1250
source build emits A0 code objects, so its RocJITsu config must identify an
A0 device (`revision_id=0`). For CI, use the checked-in
`rocm-systems/emulation/rocjitsu/configs/gfx1250_mi455x_single_xcc.json`
profile. It checks gfx1250 execution on one simulated XCC; it does not
represent the full MI455X partition layout.

```sh
rocm_root="$(rocm-sdk path --root)"
export IREE_HAL_AMDGPU_LIBHSA_PATH="$rocm_root/lib/libhsa-runtime64.so.1"

HRX_SYSTEM_BUILD_DIR="$PWD/.build/hrx-system/build/gfx1201" \
  pytest tests/test_corpus.py --suite hrx --target gfx1201

HRX_SYSTEM_BUILD_DIR="$PWD/.build/hrx-system/build/gfx1250" \
  pytest tests/test_corpus.py --suite hrx --target gfx1250 \
    --run-wrapper "rocjitsu --config /path/to/rocm-systems/emulation/rocjitsu/configs/gfx1250_mi455x_single_xcc.json --"
```

Use `--case core_tests` for one CTest record. The `hrx` suite is opt-in and
does not change the default HIP corpus matrix. Each record saves CTest output
and Google Test XML. A failed CTest record, missing or entirely skipped Google
Test result, or unavailable backend fails its pytest case. Individual
capability skips remain in the XML. A shared lock under `.build/` keeps HRX
records from overlapping across pytest workers on the same GPU.

The `rocm-systems` runner selects the checked-in simulator configs and runs
each target separately in CI; see its `run-hrx-cts.sh` for local reproduction.

All 16 gfx1250 binaries build with this wheel. On the full MI455X A0
RocJITsu configuration, all 16 currently fail while creating queue resources
spanning interleaved hardware partitions. HRX groups two execution units per
queue resource on gfx12.5, but the first pair maps to different XCCs, so
device initialization returns `UNIMPLEMENTED` before any CTS case executes.
The single-XCC profile gets past that HRX limitation; sanitizer VMEM and some
code-object tests still fail and remain visible in the CI result.
