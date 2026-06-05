# IREE VMFB Corpus Inventory

This inventory records the current VMFB-oriented IREE corpus names and the
planned MLIR-native destinations. The legacy VMFB files are ignored by git, but
the regression runner discovers them from:

- `corpus/e2e/*.vmfb`
- `corpus/matmul/*/*_{matmul,calls}.vmfb`

## E2E Modules

E2E destinations keep one copied MLIR module per directory. JSON case names are
derived from the exported functions in the source MLIR so each JSON owns one
`iree-run-module` invocation.

| Legacy VMFB | Source MLIR | MLIR destination | JSON case names |
| --- | --- | --- | --- |
| `corpus/e2e/check_gfx1250_hip_argmax.vmfb` | `tests/e2e/linalg/argmax.mlir` | `corpus/iree/e2e/argmax/module.mlir` | `argmax_1d.json` |
| `corpus/e2e/check_gfx1250_hip_attention.vmfb` | `tests/e2e/linalg_ext_ops/attention.mlir` | `corpus/iree/e2e/attention/module.mlir` | `attention1x3x4.json`, `causal_attention1x3x4.json`, `attention1x4x4_i1_mask_all_ones.json`, `softcap_attention1x3x4.json`, `attention1x4x4.json`, `attention3x3x4.json` |
| `corpus/e2e/check_gfx1250_hip_conv2d.vmfb` | `tests/e2e/linalg/conv2d.mlir` | `corpus/iree/e2e/conv2d/module.mlir` | `conv2d_nopadding.json` |
| `corpus/e2e/check_gfx1250_hip_gather_like_ops.vmfb` | `tests/e2e/linalg/gather_like_ops.mlir` | `corpus/iree/e2e/gather_like_ops/module.mlir` | `gather_like_op.json` |
| `corpus/e2e/check_gfx1250_hip_index.vmfb` | `tests/e2e/linalg/index.mlir` | `corpus/iree/e2e/index/module.mlir` | `extract_slice_strided.json` |
| `corpus/e2e/check_gfx1250_hip_map_load.vmfb` | `tests/e2e/linalg_ext_ops/map_load.mlir` | `corpus/iree/e2e/map_load/module.mlir` | `copy_like.json`, `expand_shape_like.json`, `collapse_shape_like.json`, `pad_slice_like.json` |
| `corpus/e2e/check_gfx1250_hip_map_store.vmfb` | `tests/e2e/linalg_ext_ops/map_store.mlir` | `corpus/iree/e2e/map_store/module.mlir` | `copy_like.json`, `collapse_shape_like.json`, `expand_shape_shape_like.json`, `extract_slice_like.json` |
| `corpus/e2e/check_gfx1250_hip_pack_i8.vmfb` | `tests/e2e/linalg/pack_i8.mlir` | `corpus/iree/e2e/pack_i8/module.mlir` | `static_pack_vnni_lhs_large.json`, `static_pack_vnni_rhs_large.json`, `static_pack_vnni_lhs_large_with_pad.json`, `static_pack_vnni_rhs_large_with_pad.json` |
| `corpus/e2e/check_gfx1250_hip_scatter.vmfb` | `tests/e2e/linalg_ext_ops/scatter.mlir` | `corpus/iree/e2e/scatter/module.mlir` | `scatter_2d_origin.json`, `scatter_2d_offset.json`, `scatter_2d_offset_swapped.json`, `scatter_2d_multiple.json`, `scatter_2d_unit_batch.json`, `scatter_2d_batch.json` |
| `corpus/e2e/check_gfx1250_hip_softmax.vmfb` | `tests/e2e/linalg/softmax.mlir` | `corpus/iree/e2e/softmax/module.mlir` | `softmax_static_10x256x256xf32.json`, `softmax_dynamic_10x256x256xf32.json` |
| `corpus/e2e/check_gfx1250_hip_unpack.vmfb` | `tests/e2e/linalg/unpack.mlir` | `corpus/iree/e2e/unpack/module.mlir` | `static_unpack_simple.json`, `dynamic_unpack_simple.json`, `static_unpack_simple_extract_slice.json`, `dynamic_unpack_simple_extract_slice.json`, `static_unpack_large.json`, `dynamic_unpack_large.json`, `dynamic_unpack_transpose_inner_dims_large.json`, `dynamic_unpack_transpose_outer_dims_large.json`, `dynamic_unpack_transpose_inner_and_outer_dims_large.json`, `static_unpack_extract_slice_large.json`, `dynamic_unpack_extract_slice_large.json`, `static_unpack_extract_slice_transpose_inner_dims_large.json`, `static_unpack_extract_slice_transpose_outer_dims_large.json`, `static_unpack_extract_slice_transpose_inner_and_outer_dims_large.json`, `dynamic_unpack_extract_slice_transpose_inner_dims_large.json`, `dynamic_unpack_extract_slice_transpose_outer_dims_large.json`, `dynamic_unpack_extract_slice_transpose_inner_and_outer_dims_large.json` |

## Matmul Modules

Matmul destinations preserve the legacy corpus case directory names. Each
destination owns `matmul.mlir`, `calls.mlir`, and `test.json`.

Current IREE build outputs use the generated source suffix
`_rocm_hip_{matmul,calls}.mlir`. All listed gfx1250 direct tiling, `wmma_*`,
and `tileandfusewmma_*` cases have exact generated MLIR basenames in the
refreshed build tree.

| Legacy VMFB directory | Generated MLIR source basename | MLIR destination | JSON case name |
| --- | --- | --- | --- |
| `corpus/matmul/e2e_matmul_gfx1250_dt_f16/` | `e2e_matmul_gfx1250_dt_f16_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_dt_f16/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_dt_f8E4M3FN/` | `e2e_matmul_gfx1250_dt_f8E4M3FN_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_dt_f8E4M3FN/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_dt_i8/` | `e2e_matmul_gfx1250_dt_i8_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_dt_i8/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_tileandfusewmma_f16/` | `e2e_matmul_gfx1250_tileandfusewmma_f16_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_tileandfusewmma_f16/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_tileandfusewmma_f16_tb/` | `e2e_matmul_gfx1250_tileandfusewmma_f16_tb_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_tileandfusewmma_f16_tb/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_tileandfusewmma_f8E4M3FN/` | `e2e_matmul_gfx1250_tileandfusewmma_f8E4M3FN_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_tileandfusewmma_f8E4M3FN/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_tileandfusewmma_f8E4M3FN_tb/` | `e2e_matmul_gfx1250_tileandfusewmma_f8E4M3FN_tb_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_tileandfusewmma_f8E4M3FN_tb/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_tileandfusewmma_i8_tb/` | `e2e_matmul_gfx1250_tileandfusewmma_i8_tb_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_tileandfusewmma_i8_tb/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_wmma_f16/` | `e2e_matmul_gfx1250_wmma_f16_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_wmma_f16/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_wmma_f16_tb/` | `e2e_matmul_gfx1250_wmma_f16_tb_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_wmma_f16_tb/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_wmma_f8E4M3FN/` | `e2e_matmul_gfx1250_wmma_f8E4M3FN_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_wmma_f8E4M3FN/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_wmma_f8E4M3FN_tb/` | `e2e_matmul_gfx1250_wmma_f8E4M3FN_tb_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_wmma_f8E4M3FN_tb/` | `test.json` |
| `corpus/matmul/e2e_matmul_gfx1250_wmma_i8_tb/` | `e2e_matmul_gfx1250_wmma_i8_tb_rocm_hip` | `corpus/iree/matmul/e2e_matmul_gfx1250_wmma_i8_tb/` | `test.json` |
