#compilation0 = #iree_codegen.compilation_info<
  lowering_config = #iree_gpu.lowering_config<{  mma_kind = #iree_gpu.mma_layout<WMMA_I32_16x16x64_I8>,   subgroup_basis = [[1, 1, 1], [0, 1, 2]],   workgroup = [16, 16, 0],   reduction = [0, 0, 64] }>,
  translation_info = #iree_codegen.translation_info<pipeline = #iree_gpu.pipeline<VectorDistribute> workgroup_size = [32, 1, 1]
  subgroup_size = 32>>
util.func @matmul_accumulate_512x128xi8_times_512x128xi8_into_512x512xi32_for_VectorDistribute(%lhs: tensor<512x128xi8>, %rhs: tensor<512x128xi8>, %acc: tensor<512x512xi32>) -> tensor<512x512xi32> {
  %result = linalg.matmul indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>] {compilation_info = #compilation0}  ins(%lhs, %rhs: tensor<512x128xi8>, tensor<512x128xi8>) outs(%acc: tensor<512x512xi32>) -> tensor<512x512xi32>
  util.return %result: tensor<512x512xi32>
}

#compilation1 = #iree_codegen.compilation_info<
  lowering_config = #iree_gpu.lowering_config<{  mma_kind = #iree_gpu.mma_layout<WMMA_I32_16x16x64_I8>,   subgroup_basis = [[1, 1, 1], [0, 1, 2]],   workgroup = [16, 16, 0],   reduction = [0, 0, 64] }>,
  translation_info = #iree_codegen.translation_info<pipeline = #iree_gpu.pipeline<VectorDistribute> workgroup_size = [32, 1, 1]
  subgroup_size = 32>>
util.func @matmul_512x128xi8_times_512x128xi8_into_512x512xi32_for_VectorDistribute(%lhs: tensor<512x128xi8>, %rhs: tensor<512x128xi8>) -> tensor<512x512xi32> {
  %init_acc = tensor.empty() : tensor<512x512xi32>
  %c0_acc_type = arith.constant 0: i32
  %acc = linalg.fill ins(%c0_acc_type : i32) outs(%init_acc : tensor<512x512xi32>) -> tensor<512x512xi32>
  %result = linalg.matmul indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>] {compilation_info = #compilation1}  ins(%lhs, %rhs: tensor<512x128xi8>, tensor<512x128xi8>) outs(%acc: tensor<512x512xi32>) -> tensor<512x512xi32>
  util.return %result: tensor<512x512xi32>
}

