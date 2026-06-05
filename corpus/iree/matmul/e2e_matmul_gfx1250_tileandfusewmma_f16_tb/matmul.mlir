#compilation0 = #iree_codegen.compilation_info<
  lowering_config = #iree_gpu.lowering_config<{  mma_kind = #iree_gpu.mma_layout<WMMA_F32_16x16x32_F16>,   subgroup = [1, 1, 0],     promote_operands = [0, 1],   workgroup = [16, 16, 0],   reduction = [0, 0, 1] }>,
  translation_info = #iree_codegen.translation_info<pipeline = #iree_gpu.pipeline<TileAndFuse> workgroup_size = [32, 1, 1]
  subgroup_size = 32>>
util.func @matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs: tensor<512x128xf16>, %rhs: tensor<512x128xf16>, %acc: tensor<512x512xf32>) -> tensor<512x512xf32> {
  %result = linalg.matmul indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>] {compilation_info = #compilation0}  ins(%lhs, %rhs: tensor<512x128xf16>, tensor<512x128xf16>) outs(%acc: tensor<512x512xf32>) -> tensor<512x512xf32>
  util.return %result: tensor<512x512xf32>
}

#compilation1 = #iree_codegen.compilation_info<
  lowering_config = #iree_gpu.lowering_config<{  mma_kind = #iree_gpu.mma_layout<WMMA_F32_16x16x32_F16>,   subgroup = [1, 1, 0],     promote_operands = [0, 1],   workgroup = [16, 16, 0],   reduction = [0, 0, 1] }>,
  translation_info = #iree_codegen.translation_info<pipeline = #iree_gpu.pipeline<TileAndFuse> workgroup_size = [32, 1, 1]
  subgroup_size = 32>>
util.func @matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs: tensor<512x128xf16>, %rhs: tensor<512x128xf16>) -> tensor<512x512xf32> {
  %init_acc = tensor.empty() : tensor<512x512xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<512x512xf32>) -> tensor<512x512xf32>
  %result = linalg.matmul indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>] {compilation_info = #compilation1}  ins(%lhs, %rhs: tensor<512x128xf16>, tensor<512x128xf16>) outs(%acc: tensor<512x512xf32>) -> tensor<512x512xf32>
  util.return %result: tensor<512x512xf32>
}

