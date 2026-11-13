# Upstream notices and fixed-selection derivation

Vendored files in this directory are unchanged byte-for-byte from full Tensile
in [ROCm/rocm-libraries at 1c63e26254a357007ce2d963266085a30b39515b](https://github.com/ROCm/rocm-libraries/tree/1c63e26254a357007ce2d963266085a30b39515b/shared/tensile).
Their copyright and license notices are retained. [LICENSE.md](LICENSE.md) is
copied from the same full Tensile root, under the MIT license:
[upstream license](https://github.com/ROCm/rocm-libraries/blob/1c63e26254a357007ce2d963266085a30b39515b/shared/tensile/LICENSE.md).

| Local file | Exact source |
| --- | --- |
| `sgemm_asm_nn.yaml` | [Tensile/Tests/extended/nonbatched/sgemm_asm_nn.yaml](https://github.com/ROCm/rocm-libraries/blob/1c63e26254a357007ce2d963266085a30b39515b/shared/tensile/Tensile/Tests/extended/nonbatched/sgemm_asm_nn.yaml) |
| `test_tensor_contraction.yaml` | [Tensile/Tests/extended/classic/test_tensor_contraction.yaml](https://github.com/ROCm/rocm-libraries/blob/1c63e26254a357007ce2d963266085a30b39515b/shared/tensile/Tensile/Tests/extended/classic/test_tensor_contraction.yaml) |
| `sgemm_general_batch_asm_nn.yaml` | [Tensile/Tests/pre_checkin/sgemm_general_batch_asm_nn.yaml](https://github.com/ROCm/rocm-libraries/blob/1c63e26254a357007ce2d963266085a30b39515b/shared/tensile/Tensile/Tests/pre_checkin/sgemm_general_batch_asm_nn.yaml) |

The first-party `../prepare.py` derives one solution, not an unchanged upstream
benchmark recipe. Source-root validation compares these seed bytes with the
clean pinned source. Selection YAML and receipt hashes record the derivation.

- **valu**: first problem and first assembly group in nonbatched SGEMM; first
  value of each common/fork choice; TT4x8, WG8x8x1, GSU1, PLR false, PGR true.
  Resolve adaptive DepthU and VectorWidth to 8 and 1; explicitly wave64, no MI.
  Shape 3072x2048x1024, alpha1/beta0, distinct C/D.
- **splitk**: same seed/group, select upstream GSU3, explicitly resolve
  `GlobalSplitUAlgorithm=SingleBuffer`; same TT/WG/DU/VW/non-MI choices.
  Shape 3072x2048x1536, alpha1/beta1. Full runtime's solve supplies the beta
  helper plus atomic main. Do not replace it with a one-invocation Lite adapter.
- **pointer**: first problem/first assembly group in general-batch SGEMM;
  preserve `Batched=True`, `StridedBatched=False`; first fork choices,
  TT4x8/WG8x8x1/GSU1/DU8/VW1/wave64/no MI. Shape M1024,N1024,batch8,K1024
  in Tensile index order, alpha1/beta1. This is uniform pointer-array batching,
  not arbitrary grouped GEMM.
- **tensor**: second problem in classic tensor-contraction seed; A indices
  `[2,0,3]`, B `[2,1,3]`, two C indices. Select TT4x4/WG8x8x1/DU8,
  PLR false/PGR false; explicitly Assembly/VW1/GSU1/wave64/no MI. Preserve
  unflattened two-summation addressing (`PackSummationDims=0`). Shape
  i2048,j2048,k16,l64, alpha1/beta1. Do not inherit legacy `ExitOnFails:1`.

Only source configs/license are vendored, not the upstream runtime/client.
Generation/build imports the separately checked source. First-party adapter,
reference, tests and documentation are not represented as upstream code.
FP16 WMMA vendor recipes and artifacts are intentionally absent.
