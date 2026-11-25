# VFIO and multi-node system CTS

The gfx1250 system CTS exercises a VFIO-enabled rocjitsu build through a real
VFIO-user client, a two-GPU Linux guest, and RCCL communicators that span
multiple logical nodes. The corpus owns the workloads, expected results, and
test registration. The transport harness links against the selected rocjitsu
build so that reset and fault-injection cases can observe internal state.

| Case | Execution and required evidence |
| --- | --- |
| `VfioTransport` | A real Unix-socket client negotiates a device, maps memory, exercises guest atomics, runs a GART peer transfer, and checks interrupts, quiesce, unmap, reset, and disconnect. |
| `VfioSocketAliases` and `Launcher.*` | CLI rejection and process lifecycle, including child failure, readiness, isolation, and cleanup. |
| `Network` | Two daemon nodes, one GPU each. Both ranks must pass all five numerical collectives and report NET/Socket channels. |
| `HeliosMI455X.node0` through `.node3` | Launch each node of the shipped four-node MI455X configuration. Check its two KFD GPU IDs, names, unique IDs, PCI device IDs and gfx target, then require HIP to enumerate exactly two devices. |
| `EmulatedPod` | Four daemons, two GPUs per node. Eight ranks exercise local P2P and inter-node NET/Socket at two payload sizes. Route totals must agree with the fabric trace. |
| `GuestPeer` | A stock-driver two-GPU QEMU guest must see the owner's cached value twice, then the new value after a four-byte write through the requester-to-owner fabric route. |
| `GuestPod` | Four QEMU guests with two VFIO devices each run the eight-rank workload. The controller verifies every rank, both sizes, driver module hash, local and network channels, and lossless directed effect traces. |

The multi-node cases run on one Linux host. The QEMU guests use distinct TCP/IP
stacks, a virtio NIC per guest and a local multicast segment. These tests
qualify functional data movement and ordering. Both pod workloads select HIP
IPC for intra-node peers and RCCL NET/Socket between nodes. The guests execute
gfx1250 workloads directly with ROCr HotSwap disabled. Hardware link bandwidth and
cross-host deployment require separate measurements. The four-guest test
allocates four vCPUs and 12 GiB per guest and uses QEMU TCG.

## CI

The [corpus workflow](../../.github/workflows/vfio-system-cts.yml) runs on
relevant pull requests, pushes to `develop`, and manual dispatch. It builds
the pinned simulator and tests the corpus checkout. The rocm-systems Release
lane uses the same two corpus actions to test its simulator checkout.
Both lanes run the socket transport and launcher checks first. They restore
a checksummed QEMU/kernel/AMDGPU base or build it from upstream sources on a
cache miss. Each run builds its two initramfs images using the simulator's
rank binary and the [guest SDK pins](guest/requirements.txt), then requires
all eight workload cases. The daemon and topology tests use the host Release
SDK. The guest pin is independent so a host SDK update cannot silently
change what the stock kernel driver runs.

The job needs an x86-64 Ubuntu 24.04 runner with memory for four guests,
local Unix sockets, multicast networking and network access for provisioning.
Allow 1 GiB of writable space at `/dev/shm` for the host RCCL workloads. The
pinned host library allocates a 39.4 MiB proxy pool per rank. CI mounts a
private job volume there. The workloads run without a host GPU or `/dev/kvm`.
CI uploads workload logs and pod result JSON for seven days. Successful corpus
runs on `develop` and manual dispatch also upload the guest bundle and SHA-256
for 14 days.

## Run locally

Set `ROCJITSU` and `CORPUS` to the absolute source directories, `BUILD` to a
Release build directory, and `GUEST_WORK` to a short absolute output path.
Install the corpus pytest requirements and a gfx1250 SDK with HIP and RCCL.
Set `ROCM_PATH` to the SDK root (`rocm-sdk path --root` for wheel installs).

```sh
export LD_LIBRARY_PATH="$ROCM_PATH/lib:${LD_LIBRARY_PATH:-}"
cmake -S "$ROCJITSU" -B "$BUILD" -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER="$ROCM_PATH/lib/llvm/bin/amdclang" \
  -DCMAKE_CXX_COMPILER="$ROCM_PATH/lib/llvm/bin/amdclang++" \
  -DROCJITSU_ENABLE_VFIO=ON -DROCJITSU_SYSTEM_CTS_DIR="$CORPUS/corpus/system-cts" \
  -DROCJITSU_CTS_GUEST_INPUTS="$GUEST_WORK/images/inputs.json"
cmake --build "$BUILD" --target rocjitsu_bin rocjitsu_shared rocjitsu_hooks \
  rj_ip_discovery hip_rccl_gfx1250_test_target vfio_system_cts
```

Build the guest base and images using the [guest recipe](guest/README.md),
then run the suite from the corpus checkout.

```sh
cd "$CORPUS"
python -m pytest tests/test_corpus.py --suite system-cts --target gfx1250 \
  --binary-dir "$BUILD/tests/system-cts" -v -ra
```

Add `--case helios` to select the four node checks plus the emulated and QEMU
eight-rank pods. Use `--case GuestPeer` for the two-GPU coherence case alone.
The five host transport and launcher checks can run before preparing guest
inputs with `ctest --test-dir "$BUILD/tests/system-cts" -LE workload --output-on-failure`.
Pytest writes a verbose log per case under `.pytest-artifacts/system-cts/gfx1250`.
Set `ROCJITSU_CTS_LOG_DIR` to a short absolute path to collect raw guest,
server and rank outputs and the pod result JSON.
