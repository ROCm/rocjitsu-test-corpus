# Corpus exclusions

The target configurations were replayed with TheRock `10.2.0a20261008` and
IREE `3.13.0rc20261007` on 2026-10-08. The remaining exclusions have distinct
purposes:

- IREE's 42 compile exclusions on gfx942, gfx950, gfx1100, and gfx1201 select
  matmul cases containing gfx1250-specific lowering configurations or intrinsics.
  Both the previous IREE pin and the current pin reject them. Upstream IREE's
  source CI gates these cases by GPU target; upgrading the compiler does not
  make the unsupported target combinations valid.
- The 13 generated gfx1250 IREE matmul definitions use `compile_only` because
  their calls require the native `iree-e2e-matmul-test` support module, which
  `iree-run-module` does not provide. They still compile wherever supported.
  Normal pytest runs report their runtime checks as skipped, with the reason
  from the case definition. All 50 ordinary executable IREE cases pass on
  each of the five configured targets with the new pin.
- The 4096-cubed hip-matmul cases on gfx942 and gfx950 remain runtime skips for
  simulator cost. Compilation remains enabled, and smaller numerical cases
  exercise the kernels. This includes the gfx942 hazard variant.
- `hipkittens_gemm_fp8fp32_4wave` on gfx950 has an upstream source build error:
  `block_count` is not a constant expression in `4_wave.cu`. Its compile
  exclusion remains; the separately named MXFP8 case is enabled.
- Runtime CTS manifest skips describe physical KFD/firmware qualification
  failures. A simulator pass does not qualify that hardware stack. Three of
  the five explicitly skipped cases pass after the RocJITsu doorbell/AQL
  fixes; the two metadata-on cases require KFD 1.19 while the simulator
  advertises 1.18. Slow cases remain opt-in with `--run-slow`.
- Vulkan's recorded `NotSupported` results remain strict feature baselines:
  the cases execute, and only the recorded unsupported status is accepted.
- Tensile's vendored target markers constrain artifact generation. Five
  gfx1250 Stream-K configurations explicitly require unsupported NoSwizzle
  generation; the other target markers exclude unrelated architectures.

Simulator-specific exclusions belong in RocJITsu's consumer configuration.
The sparse IU8 gfx1250 case still needs an independent physical layout check:
its manual-derived B/index layout disagrees with RocJITsu's hardware-qualified
Tensile layout. The DBT expected memory-limit failure likewise belongs to the
consumer, which chooses the 4096 MiB per-object resource budget.

A runtime exclusion must not be reported as a numerical pass after a successful
build. The unified adapters report `skip_run_tests` with pytest's skipped
outcome. An explicitly requested compile-only run retains its compilation
success semantics.
