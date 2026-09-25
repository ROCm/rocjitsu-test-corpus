# Vulkan compute and buffer CTS

This opt-in `vulkan` suite runs an exact selection from Khronos VK-GL-CTS at
`93bca01861b0e3ef3c387027a9791e6d065f900c`. It covers RDNA3 (`gfx1100`, W7900)
and RDNA4 (`gfx1201`, R9700). It is separate from the HIP `cts` suite.

The checked-in lists come from the compute/buffer qualification accompanying
ROCm/rocm-systems #11939, #11941 and #11942:

- `compute.txt`: 747 selected buffer compute, subgroup, SPIR-V and memory-model
  cases that passed on both physical devices.
- `texel-buffer.txt`: 2,543 buffer load/store/atomic cases. These use the buffer
  instruction path despite their upstream `dEQP-VK.image.*` names.
- `unsupported-gfx*.txt`: `*` patterns for cases reported as `NotSupported` on the
  physical target with Mesa RADV 25.2.8 and libdrm 2.4.125 (589 on RDNA3; 565 on
  RDNA4), expanded only against `compute.txt` and `texel-buffer.txt`. Patterns
  matching no selected cases are rejected. Unit tests check the count and digest
  of each expanded set against the original exact hardware baseline.
- `smoke.txt`: ten representative compute and texel-buffer cases.
- `stress.txt`: twelve maximum-workgroup/LDS cases for separate timing and
  optional selection with `--case stress`. `--case ci` selects the other 3,278.
- `excluded-graphics.txt`: four cases from the original 751-case compute
  selection that also initialize images. They are excluded from `compute.txt`
  because image initialization is outside this buffer-only selection. They are
  not expected `NotSupported` results.

The three excluded `non_semantic_info` cases always upload a storage image in
`getComputeShaderSpec`/`SpvAsmComputeShaderInstance::queuePass`. The excluded
`compute_shader_derivatives` case clears sampled-image mip levels before its
compute dispatch. With unmodified CTS, these operations use the universal queue;
RADV 25.2.8 implements them with graphics draws. These are valid CTS operations
outside this buffer selection. No upstream queue-selection patch is applied.

Graphics, image tiling, sampling and general Vulkan conformance are outside this
selection. The selection lists contain exact names, so updating CTS cannot
silently expand the scope. Every selected case is executed, including the known
unsupported cases.
An unexpected `NotSupported`, missing result, warning, crash or timeout fails.
Known unsupported results are reported as pytest skips; a newly supported case
must pass. With the recorded driver, expect:

| Selection | RDNA3 | RDNA4 |
| --- | --- | --- |
| CI (3,278 cases) | 2,689 passes / 589 skips | 2,713 passes / 565 skips |
| Full (3,290 cases) | 2,701 passes / 589 skips | 2,725 passes / 565 skips |

New names in `compute.txt` or `texel-buffer.txt` join `--case ci` unless they
are also listed in `stress.txt`.

## Build once

On Ubuntu 24.04, install system userspace and build tools:

```sh
sudo apt-get update
sudo apt-get install -y build-essential cmake ninja-build git pkg-config \
  libdrm-dev libdrm-amdgpu1 libpng-dev libvulkan1 mesa-vulkan-drivers
uv venv .venv
uv pip install --python .venv/bin/python -r corpus/vulkan/requirements.txt
source .venv/bin/activate
bash scripts/build_vulkan_cts.sh
```

Use Mesa 25.2.8 or newer and libdrm 2.4.125 or newer, including support for RDNA4.
The builder fetches the pinned upstream commit and its pinned dependencies,
builds the unmodified headless `deqp-vk` target in Release mode, and keeps its
data alongside the executable. Tracked source modifications are rejected.
CTS chooses its queues normally, including graphics-capable queues for compute
tests. This is a regression selection, not a Vulkan conformance run.

The builder can be rerun without rebuilding unchanged files. The default
directory is `.build/vulkan-cts`; pass another directory as its first argument.
No GPU, display server, ROCm SDK or graphics session is needed to build CTS.

## Run on hardware

From this checkout, with its Python environment active, select Mesa RADV and run
CTS directly:

```sh
export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/radeon_icd.json
python -m pytest tests/test_corpus.py --suite vulkan --target gfx1100 \
  --case smoke -n 4 --artifact-directory .pytest-artifacts/vulkan-gfx1100 \
  --junitxml .pytest-artifacts/vulkan-gfx1100/junit.xml
```

Some distributions name the ICD manifest `radeon_icd.x86_64.json` instead.
The qualified devices are W7900 (`gfx1100`, PCI ID `0x7448`) and R9700
(`gfx1201`, PCI ID `0x7551`). Replace `--target gfx1100` and the artifact paths
with `gfx1201` for the latter. The target checks the result's device identity;
it does not select a physical GPU. On a multi-GPU host, use Mesa's
[`DRI_PRIME`](https://docs.mesa3d.org/envvars.html#envvar-DRI_PRIME), for example
`DRI_PRIME='pci-0000_03_00_0!'` with your GPU's PCI address. The `!` exposes only
that GPU to Vulkan. The adapter preserves device-selection environment variables.

Use `--case ci` for the 3,278-case selection. Omit `--case smoke` for all
3,290 cases, or use `--case stress` for the twelve expensive cases. Individual
collections and cases also work, such as `--case texel-buffer` or
`--case dEQP-VK.compute.pipeline.basic.copy_ssbo_bounds`.
Pytest-xdist's `-n` option controls concurrent case processes; use `-n 0` to run
serially. Each process executes the same unmodified CTS binary.

`VULKAN_CTS_TIMEOUT` controls each child process's timeout in seconds (600 by
default); the adapter kills its process group on timeout or interruption.
`VULKAN_CTS_BINARY` selects an existing build of the unmodified pinned CTS revision.
`VULKAN_CTS_DATA_DIR` optionally selects the directory containing its `vulkan/`
data subtree, otherwise the executable's directory is used. Each QPA record
must identify the pinned CTS revision, RADV, and the target's PCI ID.

The optional generic `--run-wrapper <command>` prefixes the CTS executable, for
example to run under an external launcher. Without it, the adapter launches
CTS directly. Build requirements, selection and result validation are identical
in both modes; the corpus does not configure the execution environment.

Diagnostics live under the chosen `--artifact-directory`: per-case QPA,
stdout/stderr and JSON with the exact command, case name, binary SHA-256, exit
code and elapsed host time. Hash-based case directories avoid filesystem
filename limits. Give concurrent runs separate artifact directories and
`--junitxml` paths.

Validate the adapter without a GPU or CTS build with:

```sh
python -m pytest tests/test_vulkan_suite.py -q
```

Upstream build documentation:
[Vulkan CTS README](https://github.com/KhronosGroup/VK-GL-CTS/blob/93bca01861b0e3ef3c387027a9791e6d065f900c/external/vulkancts/README.md).
Driver documentation: [Mesa RADV](https://docs.mesa3d.org/drivers/radv.html).
