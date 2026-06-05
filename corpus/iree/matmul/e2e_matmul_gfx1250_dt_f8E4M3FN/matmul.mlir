util.func @matmul_accumulate_DYNxDYNxf8E4M3FN_times_DYNxDYNxf8E4M3FN_into_DYNxDYNxf32(%lhs: tensor<?x?xf8E4M3FN>, %rhs: tensor<?x?xf8E4M3FN>, %acc: tensor<?x?xf32>) -> tensor<?x?xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<?x?xf8E4M3FN>, tensor<?x?xf8E4M3FN>) outs(%acc: tensor<?x?xf32>) -> tensor<?x?xf32>
  util.return %result: tensor<?x?xf32>
}

util.func @matmul_accumulate_1x1xf8E4M3FN_times_1x1xf8E4M3FN_into_1x1xf32(%lhs: tensor<1x1xf8E4M3FN>, %rhs: tensor<1x1xf8E4M3FN>, %acc: tensor<1x1xf32>) -> tensor<1x1xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<1x1xf8E4M3FN>, tensor<1x1xf8E4M3FN>) outs(%acc: tensor<1x1xf32>) -> tensor<1x1xf32>
  util.return %result: tensor<1x1xf32>
}

util.func @matmul_DYNxDYNxf8E4M3FN_times_DYNxDYNxf8E4M3FN_into_DYNxDYNxf32(%lhs: tensor<?x?xf8E4M3FN>, %rhs: tensor<?x?xf8E4M3FN>) -> tensor<?x?xf32> {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %acc_dim0 = tensor.dim %lhs, %c0 : tensor<?x?xf8E4M3FN>
  %acc_dim1 = tensor.dim %rhs, %c1 : tensor<?x?xf8E4M3FN>
  %init_acc = tensor.empty(%acc_dim0, %acc_dim1) : tensor<?x?xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<?x?xf32>) -> tensor<?x?xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<?x?xf8E4M3FN>, tensor<?x?xf8E4M3FN>) outs(%acc: tensor<?x?xf32>) -> tensor<?x?xf32>
  util.return %result: tensor<?x?xf32>
}

util.func @matmul_1x1xf8E4M3FN_times_1x1xf8E4M3FN_into_1x1xf32(%lhs: tensor<1x1xf8E4M3FN>, %rhs: tensor<1x1xf8E4M3FN>) -> tensor<1x1xf32> {
  %init_acc = tensor.empty() : tensor<1x1xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<1x1xf32>) -> tensor<1x1xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<1x1xf8E4M3FN>, tensor<1x1xf8E4M3FN>) outs(%acc: tensor<1x1xf32>) -> tensor<1x1xf32>
  util.return %result: tensor<1x1xf32>
}

util.func @matmul_accumulate_2x2xf8E4M3FN_times_2x2xf8E4M3FN_into_2x2xf32(%lhs: tensor<2x2xf8E4M3FN>, %rhs: tensor<2x2xf8E4M3FN>, %acc: tensor<2x2xf32>) -> tensor<2x2xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<2x2xf8E4M3FN>, tensor<2x2xf8E4M3FN>) outs(%acc: tensor<2x2xf32>) -> tensor<2x2xf32>
  util.return %result: tensor<2x2xf32>
}

util.func @matmul_accumulate_4x4xf8E4M3FN_times_4x4xf8E4M3FN_into_4x4xf32(%lhs: tensor<4x4xf8E4M3FN>, %rhs: tensor<4x4xf8E4M3FN>, %acc: tensor<4x4xf32>) -> tensor<4x4xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<4x4xf8E4M3FN>, tensor<4x4xf8E4M3FN>) outs(%acc: tensor<4x4xf32>) -> tensor<4x4xf32>
  util.return %result: tensor<4x4xf32>
}

util.func @matmul_accumulate_8x8xf8E4M3FN_times_8x8xf8E4M3FN_into_8x8xf32(%lhs: tensor<8x8xf8E4M3FN>, %rhs: tensor<8x8xf8E4M3FN>, %acc: tensor<8x8xf32>) -> tensor<8x8xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<8x8xf8E4M3FN>, tensor<8x8xf8E4M3FN>) outs(%acc: tensor<8x8xf32>) -> tensor<8x8xf32>
  util.return %result: tensor<8x8xf32>
}

util.func @matmul_accumulate_9x9xf8E4M3FN_times_9x9xf8E4M3FN_into_9x9xf32(%lhs: tensor<9x9xf8E4M3FN>, %rhs: tensor<9x9xf8E4M3FN>, %acc: tensor<9x9xf32>) -> tensor<9x9xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<9x9xf8E4M3FN>, tensor<9x9xf8E4M3FN>) outs(%acc: tensor<9x9xf32>) -> tensor<9x9xf32>
  util.return %result: tensor<9x9xf32>
}

util.func @matmul_accumulate_6x13xf8E4M3FN_times_13x3xf8E4M3FN_into_6x3xf32(%lhs: tensor<6x13xf8E4M3FN>, %rhs: tensor<13x3xf8E4M3FN>, %acc: tensor<6x3xf32>) -> tensor<6x3xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<6x13xf8E4M3FN>, tensor<13x3xf8E4M3FN>) outs(%acc: tensor<6x3xf32>) -> tensor<6x3xf32>
  util.return %result: tensor<6x3xf32>
}

util.func @matmul_15x37xf8E4M3FN_times_37x7xf8E4M3FN_into_15x7xf32(%lhs: tensor<15x37xf8E4M3FN>, %rhs: tensor<37x7xf8E4M3FN>) -> tensor<15x7xf32> {
  %init_acc = tensor.empty() : tensor<15x7xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<15x7xf32>) -> tensor<15x7xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<15x37xf8E4M3FN>, tensor<37x7xf8E4M3FN>) outs(%acc: tensor<15x7xf32>) -> tensor<15x7xf32>
  util.return %result: tensor<15x7xf32>
}

util.func @matmul_accumulate_81x19xf8E4M3FN_times_19x41xf8E4M3FN_into_81x41xf32(%lhs: tensor<81x19xf8E4M3FN>, %rhs: tensor<19x41xf8E4M3FN>, %acc: tensor<81x41xf32>) -> tensor<81x41xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<81x19xf8E4M3FN>, tensor<19x41xf8E4M3FN>) outs(%acc: tensor<81x41xf32>) -> tensor<81x41xf32>
  util.return %result: tensor<81x41xf32>
}

util.func @matmul_accumulate_1x10xf8E4M3FN_times_10x10xf8E4M3FN_into_1x10xf32(%lhs: tensor<1x10xf8E4M3FN>, %rhs: tensor<10x10xf8E4M3FN>, %acc: tensor<1x10xf32>) -> tensor<1x10xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<1x10xf8E4M3FN>, tensor<10x10xf8E4M3FN>) outs(%acc: tensor<1x10xf32>) -> tensor<1x10xf32>
  util.return %result: tensor<1x10xf32>
}

util.func @matmul_1x10xf8E4M3FN_times_10x10xf8E4M3FN_into_1x10xf32(%lhs: tensor<1x10xf8E4M3FN>, %rhs: tensor<10x10xf8E4M3FN>) -> tensor<1x10xf32> {
  %init_acc = tensor.empty() : tensor<1x10xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<1x10xf32>) -> tensor<1x10xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<1x10xf8E4M3FN>, tensor<10x10xf8E4M3FN>) outs(%acc: tensor<1x10xf32>) -> tensor<1x10xf32>
  util.return %result: tensor<1x10xf32>
}

util.func @matmul_accumulate_10x1xf8E4M3FN_times_1x10xf8E4M3FN_into_10x10xf32(%lhs: tensor<10x1xf8E4M3FN>, %rhs: tensor<1x10xf8E4M3FN>, %acc: tensor<10x10xf32>) -> tensor<10x10xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<10x1xf8E4M3FN>, tensor<1x10xf8E4M3FN>) outs(%acc: tensor<10x10xf32>) -> tensor<10x10xf32>
  util.return %result: tensor<10x10xf32>
}

util.func @matmul_accumulate_10x10xf8E4M3FN_times_10x1xf8E4M3FN_into_10x1xf32(%lhs: tensor<10x10xf8E4M3FN>, %rhs: tensor<10x1xf8E4M3FN>, %acc: tensor<10x1xf32>) -> tensor<10x1xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<10x10xf8E4M3FN>, tensor<10x1xf8E4M3FN>) outs(%acc: tensor<10x1xf32>) -> tensor<10x1xf32>
  util.return %result: tensor<10x1xf32>
}

util.func @matmul_10x10xf8E4M3FN_times_10x1xf8E4M3FN_into_10x1xf32(%lhs: tensor<10x10xf8E4M3FN>, %rhs: tensor<10x1xf8E4M3FN>) -> tensor<10x1xf32> {
  %init_acc = tensor.empty() : tensor<10x1xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<10x1xf32>) -> tensor<10x1xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<10x10xf8E4M3FN>, tensor<10x1xf8E4M3FN>) outs(%acc: tensor<10x1xf32>) -> tensor<10x1xf32>
  util.return %result: tensor<10x1xf32>
}

util.func @matmul_457x330xf8E4M3FN_times_330x512xf8E4M3FN_into_457x512xf32(%lhs: tensor<457x330xf8E4M3FN>, %rhs: tensor<330x512xf8E4M3FN>) -> tensor<457x512xf32> {
  %init_acc = tensor.empty() : tensor<457x512xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<457x512xf32>) -> tensor<457x512xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<457x330xf8E4M3FN>, tensor<330x512xf8E4M3FN>) outs(%acc: tensor<457x512xf32>) -> tensor<457x512xf32>
  util.return %result: tensor<457x512xf32>
}

util.func @matmul_438x331xf8E4M3FN_times_331x513xf8E4M3FN_into_438x513xf32(%lhs: tensor<438x331xf8E4M3FN>, %rhs: tensor<331x513xf8E4M3FN>) -> tensor<438x513xf32> {
  %init_acc = tensor.empty() : tensor<438x513xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<438x513xf32>) -> tensor<438x513xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<438x331xf8E4M3FN>, tensor<331x513xf8E4M3FN>) outs(%acc: tensor<438x513xf32>) -> tensor<438x513xf32>
  util.return %result: tensor<438x513xf32>
}

util.func @matmul_540x332xf8E4M3FN_times_332x516xf8E4M3FN_into_540x516xf32(%lhs: tensor<540x332xf8E4M3FN>, %rhs: tensor<332x516xf8E4M3FN>) -> tensor<540x516xf32> {
  %init_acc = tensor.empty() : tensor<540x516xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<540x516xf32>) -> tensor<540x516xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<540x332xf8E4M3FN>, tensor<332x516xf8E4M3FN>) outs(%acc: tensor<540x516xf32>) -> tensor<540x516xf32>
  util.return %result: tensor<540x516xf32>
}

util.func @matmul_1000x4xf8E4M3FN_times_4x512xf8E4M3FN_into_1000x512xf32(%lhs: tensor<1000x4xf8E4M3FN>, %rhs: tensor<4x512xf8E4M3FN>) -> tensor<1000x512xf32> {
  %init_acc = tensor.empty() : tensor<1000x512xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<1000x512xf32>) -> tensor<1000x512xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<1000x4xf8E4M3FN>, tensor<4x512xf8E4M3FN>) outs(%acc: tensor<1000x512xf32>) -> tensor<1000x512xf32>
  util.return %result: tensor<1000x512xf32>
}

util.func @matmul_4x1000xf8E4M3FN_times_1000x512xf8E4M3FN_into_4x512xf32(%lhs: tensor<4x1000xf8E4M3FN>, %rhs: tensor<1000x512xf8E4M3FN>) -> tensor<4x512xf32> {
  %init_acc = tensor.empty() : tensor<4x512xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<4x512xf32>) -> tensor<4x512xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<4x1000xf8E4M3FN>, tensor<1000x512xf8E4M3FN>) outs(%acc: tensor<4x512xf32>) -> tensor<4x512xf32>
  util.return %result: tensor<4x512xf32>
}

util.func @matmul_512x1000xf8E4M3FN_times_1000x4xf8E4M3FN_into_512x4xf32(%lhs: tensor<512x1000xf8E4M3FN>, %rhs: tensor<1000x4xf8E4M3FN>) -> tensor<512x4xf32> {
  %init_acc = tensor.empty() : tensor<512x4xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<512x4xf32>) -> tensor<512x4xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<512x1000xf8E4M3FN>, tensor<1000x4xf8E4M3FN>) outs(%acc: tensor<512x4xf32>) -> tensor<512x4xf32>
  util.return %result: tensor<512x4xf32>
}

util.func @matmul_513x128xf8E4M3FN_times_128x55xf8E4M3FN_into_513x55xf32(%lhs: tensor<513x128xf8E4M3FN>, %rhs: tensor<128x55xf8E4M3FN>) -> tensor<513x55xf32> {
  %init_acc = tensor.empty() : tensor<513x55xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<513x55xf32>) -> tensor<513x55xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<513x128xf8E4M3FN>, tensor<128x55xf8E4M3FN>) outs(%acc: tensor<513x55xf32>) -> tensor<513x55xf32>
  util.return %result: tensor<513x55xf32>
}

util.func @matmul_7x160xf8E4M3FN_times_160x31xf8E4M3FN_into_7x31xf32(%lhs: tensor<7x160xf8E4M3FN>, %rhs: tensor<160x31xf8E4M3FN>) -> tensor<7x31xf32> {
  %init_acc = tensor.empty() : tensor<7x31xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<7x31xf32>) -> tensor<7x31xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<7x160xf8E4M3FN>, tensor<160x31xf8E4M3FN>) outs(%acc: tensor<7x31xf32>) -> tensor<7x31xf32>
  util.return %result: tensor<7x31xf32>
}

util.func @matmul_512x330xf8E4M3FN_times_330x33xf8E4M3FN_into_512x33xf32(%lhs: tensor<512x330xf8E4M3FN>, %rhs: tensor<330x33xf8E4M3FN>) -> tensor<512x33xf32> {
  %init_acc = tensor.empty() : tensor<512x33xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<512x33xf32>) -> tensor<512x33xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<512x330xf8E4M3FN>, tensor<330x33xf8E4M3FN>) outs(%acc: tensor<512x33xf32>) -> tensor<512x33xf32>
  util.return %result: tensor<512x33xf32>
}

util.func @matmul_accumulate_1x1000xf8E4M3FN_times_1000x1000xf8E4M3FN_into_1x1000xf32(%lhs: tensor<1x1000xf8E4M3FN>, %rhs: tensor<1000x1000xf8E4M3FN>, %acc: tensor<1x1000xf32>) -> tensor<1x1000xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<1x1000xf8E4M3FN>, tensor<1000x1000xf8E4M3FN>) outs(%acc: tensor<1x1000xf32>) -> tensor<1x1000xf32>
  util.return %result: tensor<1x1000xf32>
}

util.func @matmul_accumulate_1000x1000xf8E4M3FN_times_1000x1xf8E4M3FN_into_1000x1xf32(%lhs: tensor<1000x1000xf8E4M3FN>, %rhs: tensor<1000x1xf8E4M3FN>, %acc: tensor<1000x1xf32>) -> tensor<1000x1xf32> {
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<1000x1000xf8E4M3FN>, tensor<1000x1xf8E4M3FN>) outs(%acc: tensor<1000x1xf32>) -> tensor<1000x1xf32>
  util.return %result: tensor<1000x1xf32>
}

util.func @matmul_1000x1000xf8E4M3FN_times_1000x1xf8E4M3FN_into_1000x1xf32(%lhs: tensor<1000x1000xf8E4M3FN>, %rhs: tensor<1000x1xf8E4M3FN>) -> tensor<1000x1xf32> {
  %init_acc = tensor.empty() : tensor<1000x1xf32>
  %c0_acc_type = arith.constant 0.0: f32
  %acc = linalg.fill ins(%c0_acc_type : f32) outs(%init_acc : tensor<1000x1xf32>) -> tensor<1000x1xf32>
  %result = linalg.matmul   ins(%lhs, %rhs: tensor<1000x1000xf8E4M3FN>, tensor<1000x1xf8E4M3FN>) outs(%acc: tensor<1000x1xf32>) -> tensor<1000x1xf32>
  util.return %result: tensor<1000x1xf32>
}

