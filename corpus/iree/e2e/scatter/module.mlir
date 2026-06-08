
func.func @scatter_2d_origin() -> tensor<2x2xi32> {
  %original = util.unfoldable_constant dense<0> : tensor<2x2xi32>
  %update = util.unfoldable_constant dense<1> : tensor<1xi32>
  %indices = util.unfoldable_constant dense<0> : tensor<1x2xi32>
  %result = iree_linalg_ext.scatter dimension_map = [0, 1] unique_indices(true)
                          ins(%update, %indices : tensor<1xi32>, tensor<1x2xi32>)
                          outs(%original : tensor<2x2xi32>) {
                    ^bb0(%arg0: i32, %arg1: i32):
                      iree_linalg_ext.yield %arg0 : i32
  } -> tensor<2x2xi32>
  return %result : tensor<2x2xi32>
}

func.func @scatter_2d_offset() -> tensor<2x2xi32> {
  %original = util.unfoldable_constant dense<0> : tensor<2x2xi32>
  %update = util.unfoldable_constant dense<1> : tensor<1xi32>
  %indices = util.unfoldable_constant dense<[[0, 1]]> : tensor<1x2xi32>
  %result = iree_linalg_ext.scatter dimension_map = [0, 1] unique_indices(true)
                          ins(%update, %indices : tensor<1xi32>, tensor<1x2xi32>)
                          outs(%original : tensor<2x2xi32>) {
                    ^bb0(%arg0: i32, %arg1: i32):
                      iree_linalg_ext.yield %arg0 : i32
  } -> tensor<2x2xi32>
  return %result : tensor<2x2xi32>
}

func.func @scatter_2d_offset_swapped() -> tensor<2x2xi32> {
  %original = util.unfoldable_constant dense<0> : tensor<2x2xi32>
  %update = util.unfoldable_constant dense<1> : tensor<1xi32>
  %indices = util.unfoldable_constant dense<[[0, 1]]> : tensor<1x2xi32>
  %result = iree_linalg_ext.scatter dimension_map = [1, 0] unique_indices(true)
                          ins(%update, %indices : tensor<1xi32>, tensor<1x2xi32>)
                          outs(%original : tensor<2x2xi32>) {
                    ^bb0(%arg0: i32, %arg1: i32):
                      iree_linalg_ext.yield %arg0 : i32
  } -> tensor<2x2xi32>
  return %result : tensor<2x2xi32>
}

func.func @scatter_2d_multiple() -> tensor<2x2xi32> {
  %original = util.unfoldable_constant dense<0> : tensor<2x2xi32>
  %update = util.unfoldable_constant dense<1> : tensor<2xi32>
  %indices = util.unfoldable_constant dense<[[0, 0], [1, 1]]> : tensor<2x2xi32>
  %result = iree_linalg_ext.scatter dimension_map = [0, 1] unique_indices(true)
                          ins(%update, %indices : tensor<2xi32>, tensor<2x2xi32>)
                          outs(%original : tensor<2x2xi32>) {
                    ^bb0(%arg0: i32, %arg1: i32):
                      iree_linalg_ext.yield %arg0 : i32
  } -> tensor<2x2xi32>
  return %result : tensor<2x2xi32>
}

func.func @scatter_2d_unit_batch() -> tensor<2x2xi32> {
  %original = util.unfoldable_constant dense<0> : tensor<2x2xi32>
  %update = util.unfoldable_constant dense<1> : tensor<1x2xi32>
  %indices = util.unfoldable_constant dense<[[[0, 0], [1, 1]]]> : tensor<1x2x2xi32>
  %result = iree_linalg_ext.scatter dimension_map = [0, 1] unique_indices(true)
                          ins(%update, %indices : tensor<1x2xi32>, tensor<1x2x2xi32>)
                          outs(%original : tensor<2x2xi32>) {
                    ^bb0(%arg0: i32, %arg1: i32):
                      iree_linalg_ext.yield %arg0 : i32
  } -> tensor<2x2xi32>
  return %result : tensor<2x2xi32>
}

func.func @scatter_2d_batch() -> tensor<2x2xi32> {
  %original = util.unfoldable_constant dense<0> : tensor<2x2xi32>
  %update = util.unfoldable_constant dense<1> : tensor<2x2xi32>
  %indices = util.unfoldable_constant dense<[[[0, 0], [1, 1]], [[1, 0], [0, 1]]]> : tensor<2x2x2xi32>
  %result = iree_linalg_ext.scatter dimension_map = [0, 1] unique_indices(true)
                          ins(%update, %indices : tensor<2x2xi32>, tensor<2x2x2xi32>)
                          outs(%original : tensor<2x2xi32>) {
                    ^bb0(%arg0: i32, %arg1: i32):
                      iree_linalg_ext.yield %arg0 : i32
  } -> tensor<2x2xi32>
  return %result : tensor<2x2xi32>
}

func.func @scatter_operand_mask_preserves_original() -> tensor<4xi32> {
  %original = util.unfoldable_constant dense<[10, 20, 30, 40]> : tensor<4xi32>
  %update = util.unfoldable_constant dense<[1, 2]> : tensor<2xi32>
  %indices = util.unfoldable_constant dense<[[1], [3]]> : tensor<2x1xi32>
  %mask = util.unfoldable_constant dense<[true, false]> : tensor<2xi1>
  %result = iree_linalg_ext.scatter dimension_map = [0] unique_indices(true)
                          ins(%update, %indices, %mask : tensor<2xi32>, tensor<2x1xi32>, tensor<2xi1>)
                          outs(%original : tensor<4xi32>) {
                    ^bb0(%arg0: i32, %arg1: i32):
                      iree_linalg_ext.yield %arg0 : i32
  } -> tensor<4xi32>
  return %result : tensor<4xi32>
}
