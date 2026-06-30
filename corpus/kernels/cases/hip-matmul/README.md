# HIP Matmul Notes

## TheRock 6.4 vs 7.14 Correctness

The extracted upstream source is `nod-ai/hip-matmul` at revision
`f932f783976342b397b255361f158bbc7c7a7ea3`. The upstream repository was also
cloned locally at `/home/amily/hip-matmul/main` and tested directly with its
native `./build_and_test.sh` script, outside this corpus.

On `gfx942`, the same upstream `matmul.hip` source behaves differently across
TheRock toolchains:

- TheRock `6.4.0rc20250520` passes upstream `matmul` and `matvec` correctness.
- TheRock `7.14.0a20260602` fails upstream `matmul` correctness in
  `MmtKernel_256t_MSxNS_amdgcn_mfma_f32_16x16x4f32_shared_Kx4_doublebuffer_take2<8, 8>`.
- With TheRock `7.14.0a20260602`, upstream `matvec.hip` also does not compile
  directly because HIP 7 exposes `warpSize` in a way that is not usable as a
  non-type template argument. The kernel corpus matvec wrapper works around
  that by defining `warpSize` to `KERNEL_CORPUS_HIP_MATMUL_WARP_SIZE`.

The relevant toolchains were:

- TheRock `6.4.0rc20250520`: HIP `6.5.25202`, AMD clang 19.
- TheRock `7.14.0a20260602`: HIP `7.14.60850`, AMD clang 23.

The upstream `doublebuffer_take2` kernel has a latent shared-memory race. Its
main loop performs:

```cpp
load_shared_from_global(1);
__syncthreads();
mfma(0);
load_shared_from_global(0);
mfma(1);
```

There is no `__syncthreads()` between `mfma(0)` and reloading shared buffer 0.
That allows one wave to overwrite shared buffer 0 while another wave is still
reading it for `mfma(0)`.

The previous upstream `doublebuffer_naive` kernel has an in-source comment
describing the same class of issue:

```cpp
// We thought that there should be no __syncthreads here, as the next
// iteration will load into separate parts of A_shared and B_shared.
// But we observed a data race giving intermittent failures in practice.
__syncthreads();
```

Side-by-side assembly showed why the versions differ in practice:

- Clang 19 from TheRock 6.4 schedules the shared-buffer reload late enough that
  the missing barrier does not show up in the tested run.
- Clang 23 from TheRock 7.14 schedules the `ds_write_b128` reloads of shared
  buffer 0 much earlier, while MFMA consumption of the previous contents can
  still be in flight across the workgroup.

This means the TheRock 7.14 failure is best understood as the newer compiler
exposing undefined synchronization in the upstream kernel, not as a kernel
corpus wrapper bug.

The corpus keeps the unmodified upstream behavior in `matmul_hazard`. The normal
`matmul` runner preserves the upstream test list but overrides
`doublebuffer_take2` with a case-local copy that adds barriers before either
double buffer can be overwritten.

Useful direct upstream repro commands:

```sh
# TheRock 6.4, passes. This artifact needed an explicit device bitcode path.
PATH=/home/amily/therock-artifacts/6.4.0rc20250520/bin:$PATH \
ROCM_PATH=/home/amily/therock-artifacts/6.4.0rc20250520 \
HIP_PATH=/home/amily/therock-artifacts/6.4.0rc20250520 \
LD_LIBRARY_PATH=/home/amily/therock-artifacts/6.4.0rc20250520/lib:${LD_LIBRARY_PATH:-} \
HIPCC_COMPILE_FLAGS_APPEND=--rocm-device-lib-path=/home/amily/therock-artifacts/6.4.0rc20250520/lib/llvm/amdgcn/bitcode \
BENCHMARK_MIN_MS=1 FIXED_ITERATIONS=1 ./build_and_test.sh

# TheRock 7.14, matmul fails in doublebuffer_take2.
PATH=/home/amily/therock-artifacts/7.14.0a20260602/install/bin:$PATH \
ROCM_PATH=/home/amily/therock-artifacts/7.14.0a20260602/install \
HIP_PATH=/home/amily/therock-artifacts/7.14.0a20260602/install \
LD_LIBRARY_PATH=/home/amily/therock-artifacts/7.14.0a20260602/install/lib:/home/amily/therock-artifacts/7.14.0a20260602/install/lib64:${LD_LIBRARY_PATH:-} \
BENCHMARK_MIN_MS=1 FIXED_ITERATIONS=1 ./build_and_test.sh
```
