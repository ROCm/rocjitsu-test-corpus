# Build the VFIO guest images

The two-GPU peer refetch probe and the four-node RCCL pod boot a Linux kernel
and separate BusyBox initramfs images. Start with the Release build and
environment variables in the [system CTS guide](../README.md#run-locally).
The [workload action](../../../.github/actions/test-vfio-workloads/action.yml)
lists the Ubuntu 24.04 packages for a cold build. The host needs sudo to
install missing packages, including the pinned guest headers used by DKMS.
The CI host uses SDK `10.1.0a20260812`. The guest uses the public gfx1250
userspace from `7.15.0a20260710`. In the four-guest test the August userspace
timed out in the 64-element Broadcast after AllReduce had passed. The same
failure reproduced on the simulator baseline `a0437a568721`.
The suite checks every rank at both sizes before the bundle is published.

```sh
# Optional: use an existing ROCm/amdgpu clone containing amdgpu-31.50.
# export AMDGPU_SOURCE_DIR=/path/to/amdgpu
bash "$CORPUS/corpus/system-cts/guest/build_base.sh" "$ROCJITSU" "$GUEST_WORK/base"
guest="$CORPUS/corpus/system-cts/guest"
python3 -m venv "$GUEST_WORK/guest-sdk"
uv pip install --python "$GUEST_WORK/guest-sdk/bin/python" --prerelease allow \
  --index-url https://rocm.nightlies.amd.com/whl-multi-arch/ -r "$guest/requirements.txt"
"$GUEST_WORK/guest-sdk/bin/rocm-sdk" init
guest_sdk=$("$GUEST_WORK/guest-sdk/bin/rocm-sdk" path --root)
ROCM_PATH="$guest_sdk" LD_LIBRARY_PATH="$guest_sdk/lib" python3 "$guest/build_images.py" \
  --base "$GUEST_WORK/base" --rocm "$guest_sdk" --build "$BUILD" \
  --output "$GUEST_WORK/images"
```

The base builder checks five pinned Ubuntu package SHA-256 hashes, builds
the unmodified AMDGPU DKMS sources against those headers, and compiles QEMU
10.1.0 with the simulator's three PCIe patches and TCG. It records checksums
for the installed QEMU, ROMs, kernel, modules, and driver source archive.
The image builder verifies those checksums, generates the modeled firmware and
IP discovery table, builds the HIP peer probe, and stages the selected build's
RCCL rank binary with its runtime libraries and gfx1250 device code. Each
builder takes a new output directory. Reuse the base for subsequent builds and
generate fresh images when the workload, simulator, or SDK changes.

The generated `images/inputs.json` points to both initramfs files, the QEMU
binary, kernel, staged `amdgpu.ko`, and driver source archive. Its paths are
relative, so `base/` and `images/` can move together. For a qualified CI
bundle, download the workflow artifact, run `sha256sum -c guest-bundle.sha256`
next to the tarball and extract it under `$GUEST_WORK`.

## Historical qualification inputs

The manual commands below run from the rocjitsu source directory. Set
`AMDGPU` to a local AMDGPU source checkout.

The reported 2026-10-15 and 2026-10-19 **final** VFIO pod runs used:

| Input | Version or source | Purpose |
| --- | --- | --- |
| QEMU | 10.1.0, commit `f8b2f64e2336a28bf0d50b6ef8a7d8c013e9bcf3` | Two `vfio-user-pci` functions and one NIC per guest |
| libvfio-user | commit `37491ed9af828fc161238dacd82e83ea35a09f87` with the downstream BAR-mask fix | Historical input for the October runs; standard VFIO-user DMA mapping |
| AMDGPU DKMS | `amdgpu-dkms_7.1.3.31500000-2390945.24.04_all.deb` | Guest `amdgpu.ko` and companion modules |
| Linux image and headers | `6.17.0-23-generic` | Guest `vmlinuz` and matching module build tree |
| ROCm guest user stack | HIP `7.14.60850-0000000`, ROCr `1.21`, RCCL `2.30.4-HEAD:2b22ab0` | Rank binary and runtime libraries |

Apply the three patches in `patches/qemu/10.1/` with
`scripts/apply-qemu-pcie-fixes.sh` to a **clean** checkout at the pinned QEMU
commit. They preserve the VFIO-user class code, supply a valid XIO3130
downstream LinkCap, and advertise opt-in root/switch AtomicOp support for
implemented guest-RAM atomics. They add no private VFIO-user protocol. For
example, from the rocJITsu source directory:

```sh
git clone https://gitlab.com/qemu-project/qemu.git /path/to/qemu-10.1-src
git -C /path/to/qemu-10.1-src checkout f8b2f64e2336a28bf0d50b6ef8a7d8c013e9bcf3
scripts/apply-qemu-pcie-fixes.sh /path/to/qemu-10.1-src
mkdir -p /path/to/qemu-10.1-build
cd /path/to/qemu-10.1-build
/path/to/qemu-10.1-src/configure --target-list=x86_64-softmmu --enable-kvm --disable-werror
ninja qemu-system-x86_64
```

Use the produced binary's `-device help` output to confirm `vfio-user-pci`.
The VFIO CMake build fetches libvfio-user at the revision pinned in
`cmake/rj_libvfio_user.cmake`.

For the **zero-patch** final gate, extract the pinned DKMS package and build
against headers for the *guest* kernel. Its `Makefile` handles configuration
and module dependencies:

```sh
dpkg-deb -x /path/to/amdgpu-dkms_7.1.3.31500000-2390945.24.04_all.deb /path/to/driver-tree
make -C /path/to/driver-tree/usr/src/amdgpu-7.1.3-2390945.24.04 \
  KERNELVER=6.17.0-23-generic
modinfo -F vermagic /path/to/driver-tree/usr/src/amdgpu-7.1.3-2390945.24.04/amd/amdgpu/amdgpu.ko
```

The build host needs `/lib/modules/6.17.0-23-generic/build` with the matching
kernel `.config` and `Module.symvers`. Copy the resulting `amdgpu.ko` and its
companion modules into the guest image in dependency order. Use the matching
`/boot/vmlinuz-6.17.0-23-generic` as the launcher's `--kernel`. Record
`sha256sum` for the package, module, kernel, QEMU binary, and final image.
The recorded gate used the distribution kernel image; it did not apply a
rocJITsu kernel patch or build a custom kernel. If rebuilding that kernel,
start from the source package for the same release with its exact config and
symbol versions, then rebuild the DKMS module against the resulting headers
and record the new binary hashes. A kernel with a matching version string but
different symbols is not an interchangeable module build target.

The October 14 diagnostic run used local AMDGPU error-path fixes, but the
October 15 and 19 final runs used **none** of those driver changes. The
diagnostic patches are not included in this repository or needed by the pod
controller, which checks directed fabric effects and guest workload logs.
Do not report a diagnostic module as the zero-patch result.

## Build the same driver from the AMDGPU source repository

The local-source qualification uses tag **amdgpu-31.50** from ROCm/amdgpu,
commit **48f2f4486a8dc6122195fa8755b6a1a6ee2ad3e2**. Export the paths in
the tag's DKMS manifest and run its build against the guest headers. Keep
the package revision and the source revision distinct when recording results.

```sh
GUEST_WORK=/absolute/path/to/guest-work
python3 "$CORPUS/corpus/system-cts/guest/export_dkms.py" \
  "$AMDGPU" amdgpu-31.50 "$GUEST_WORK/driver" \
  --archive "$GUEST_WORK/amdgpu-31.50.tar.gz"
(cd "$GUEST_WORK/driver/amd/dkms" && bash autogen.sh)
make -C "$GUEST_WORK/driver" KERNELVER=6.17.0-23-generic
```

Supply the resulting archive as `driver_source` in the CTS manifest, or
pass it with `--driver-source` when running the pod launcher directly.
Use the compiled module staged in the guest for `driver_module`.

The functional model uses five small firmware-format fixtures for this tag.
Their fields and sentinel bytes reproduce the historical guest input hashes.
Generate them in the guest's firmware directory, then generate the IP
discovery table with the same rocjitsu build that will serve the guest.

```sh
python3 "$CORPUS/corpus/system-cts/guest/firmware_fixtures.py" \
  --output "$GUEST_WORK/base/lib/firmware/amdgpu"
"$BUILD/tools/rj-ip-discovery/rj-ip-discovery" gfx1250 \
  "$GUEST_WORK/base/lib/firmware/amdgpu/ip_discovery.bin"
```

## Build and pack the guest payloads

Build the peer refetch probe with a gfx1250-capable `hipcc`. The same guest
image must include its loader and the transitive HIP/ROCr libraries:

```sh
hipcc --offload-arch=gfx1250 -O2 \
  -o /path/to/hip_owner_peer_refetch "$CORPUS"/corpus/system-cts/guest/hip_owner_peer_refetch.cpp
cmake --build build-vfio --target hip_rccl_gfx1250_test_target
```

Start from a compatible guest staging root containing BusyBox, the matching
kernel modules and firmware, network applets, ROCm libraries, and their ELF
dependencies. `docs/qemu-vfio.md` explains the firmware inventory and
`rj-ip-discovery` output. The pod init reads `/modules/load-order`, expects
the relocated libraries under `/opt/rocm/lib` or the historical
`/opt/rocm/core-7.14/lib`, and runs the rank binary at the path below.
The peer refetch init uses the same module list and an independent probe
binary. Pack separate images for the two workloads. Include a static BusyBox,
the gfx1250 RCCL kpack under the corresponding ROCm prefix's `.kpack/`
directory when the library uses an external archive, and the modules selected
by modinfo dependencies in dependency order. The reference Ubuntu kernel
builds virtio PCI and virtio networking into the kernel.

```sh
mkdir -p /path/to/pod-root /path/to/refetch-root
cp -a /path/to/compatible-base-root/. /path/to/pod-root/
install -D -m 0755 "$CORPUS"/corpus/system-cts/guest/rccl_pod_init /path/to/pod-root/init
install -D -m 0755 build-vfio/tests/hip_rccl_gfx1250_test \
  /path/to/pod-root/opt/rocjitsu/bin/hip_rccl_gfx1250_test
(cd /path/to/pod-root && find . -print0 | cpio --null -o -H newc) \
  | gzip -9 > /path/to/pod-initramfs.gz

cp -a /path/to/compatible-base-root/. /path/to/refetch-root/
install -D -m 0755 "$CORPUS"/corpus/system-cts/guest/hip_owner_peer_refetch_init /path/to/refetch-root/init
install -D -m 0755 /path/to/hip_owner_peer_refetch \
  /path/to/refetch-root/opt/rocjitsu/bin/hip_owner_peer_refetch
(cd /path/to/refetch-root && find . -print0 | cpio --null -o -H newc) \
  | gzip -9 > /path/to/refetch-initramfs.gz
```

Run the pod image with `scripts/run-rccl-pod-vfio.py`, the four-node manifest
`configs/gfx1250_mi455x_kmd_4node_2gpu_if.json`, and the exact external
artifact paths. The controller checks the guest's printed module hash against
`--driver-module`; the module staged in the image must be the same build.

```sh
python3 scripts/run-rccl-pod-vfio.py \
  --qemu /path/to/qemu-10.1-build/qemu-system-x86_64 \
  --kernel /boot/vmlinuz-6.17.0-23-generic \
  --initramfs /path/to/pod-initramfs.gz \
  --rocjitsu build-vfio/tools/rocjitsu/rocjitsu \
  --config configs/gfx1250_mi455x_kmd_4node_2gpu_if.json \
  --driver-module /path/to/driver-tree/usr/src/amdgpu-7.1.3-2390945.24.04/amd/amdgpu/amdgpu.ko \
  --driver-package /path/to/amdgpu-dkms_7.1.3.31500000-2390945.24.04_all.deb \
  --rank-binary build-vfio/tests/hip_rccl_gfx1250_test \
  --output /tmp/rocjitsu-pod-vfio --timeout 600
```

The dated qualification record gives the original commands and binary
hashes. For the peer probe, run one two-GPU node with
`scripts/run-vfio-guest.py`:

```sh
python3 scripts/run-vfio-guest.py \
  --qemu /path/to/qemu-10.1-build/qemu-system-x86_64 \
  --kernel /boot/vmlinuz-6.17.0-23-generic \
  --initramfs /path/to/refetch-initramfs.gz \
  --rocjitsu build-vfio/tools/rocjitsu/rocjitsu \
  --config configs/gfx1250_mi455x_kmd_4node_2gpu_if.json \
  --node node0 --socket /tmp/refetch-vfio/gpu0.sock \
  --socket /tmp/refetch-vfio/gpu1.sock \
  --output /tmp/refetch-vfio --accel tcg --memory 12G \
  --append 'console=ttyS0 rdinit=/init panic=-1 amdgpu.discovery=2 amdgpu.emu_mode=1 amdgpu.fw_load_type=0 amdgpu.vm_update_mode=3 amdgpu.gpu_recovery=0 amdgpu.vramlimit=1024 amdgpu.ip_block_mask=0x3f' \
  --expect-log 'guest: owner-peer-refetch PASS' \
  --reject-log 'guest: owner-peer-refetch FAIL'
```

Use a fresh, short `--output` path. The owner probe uses three ordinary
`global_load_b32` instructions without a system scope cache modifier and no
owner-side invalidate. The separate ready/done pages use system scope traffic
for ordering. The probe reports the first cached owner value, its repeated
hit, and the post-peer-write refetch; `result=PASS` is required. The
`TranslatedLocalCache.ExactHandlePtePolicyAndFabricBoundaryRefetchOwnerData`
unit test also establishes the negative control: after an external backing
write, a V$ invalidation alone still returns the stale L2 value, while full
completion invalidation refetches the new value. These tests exercise UC PCIe
peer mappings through rocJITsu's conservative fabric coherence model. They do
not establish native xGMI or guest cache-maintenance ordering.
