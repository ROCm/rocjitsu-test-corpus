#compilation0 = #iree_codegen.compilation_info<
  lowering_config = #iree_gpu.lowering_config<{  mma_kind = #iree_gpu.mma_layout<WMMA_F32_16x16x32_F16>,   subgroup_basis = [[1, 1, 1], [0, 1, 2]],   workgroup = [16, 16, 0],   reduction = [0, 0, 32] }>,
  translation_info = #iree_codegen.translation_info<pipeline = #iree_gpu.pipeline<VectorDistribute> workgroup_size = [32, 1, 1]
  subgroup_size = 32>>
util.func @matmul_accumulate_512x128xf16_times_128x512xf16_into_512x512xf32_for_VectorDistribute(%lhs: tensor<512x128xf16>, %rhs: tensor<128x512xf16>, %acc: tensor<512x512xf32>) -> tensor<512x512xf32> {
  %result = linalg.matmul  {compilation_info = #compilation0}  ins(%lhs, %rhs: tensor<512x128xf16>, tensor<128x512xf16>) outs(%acc: tensor<512x512xf32>) -> tensor<512x512xf32>
  util.return %result: tensor<512x512xf32>
}

#compilation1 = #iree_codegen.compilation_info<
  lowering_config = #iree_gpu.lowering_config<{  mma_kind = #iree_gpu.mma_layout<WMMA_F32_16x16x32_F16>,   subgroup_basis = [[1, 1, 1], [0, 1, 2]],   workgroup = [16, 16, 0],   reduction = [0, 0, 32] }>,
  translation_info = #iree_codegen.translation_info<pipeline = #iree_gpu.pipeline<VectorDistribute> workgroup_size = [32, 1, 1]
  subgroup_size = 32>>
util.func @matmul_512x128xf16_times_128x512xf16_into_512x512xf32_for_VectorDistribute(%lhs: tensor<512x128xf16>, %rhs: tensor<128x512xf16>) -> tensor<512x512xf32> {
  %init_acc = tensor.empty() : tensor<512x512xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<512x512xf32>) -> tensor<512x512xf32>
  %result = linalg.matmul  {compilation_info = #compilation1}  ins(%lhs, %rhs: tensor<512x128xf16>, tensor<128x512xf16>) outs(%acc: tensor<512x512xf32>) -> tensor<512x512xf32>
  util.return %result: tensor<512x512xf32>
}

