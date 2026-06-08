func.func @attention1x3x4() -> tensor<1x3x4xf32> {
  %init = tensor.empty() : tensor<1x3x4xf32>
  %query = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>

  %key = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                          [0.5, 0.6, 0.7, 0.8],
                                          [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %value = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %scale = arith.constant 0.5 : f32
  %1 = iree_linalg_ext.attention  {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> ()>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d4)>]}
                     ins(%query, %key, %value, %scale : tensor<1x3x4xf32>,
        tensor<1x3x4xf32>, tensor<1x3x4xf32>, f32) outs(%init : tensor<1x3x4xf32>) {
          ^bb0(%arg0: f32):
          iree_linalg_ext.yield %arg0 : f32
        } -> tensor<1x3x4xf32>
  return %1 : tensor<1x3x4xf32>
}

func.func @causal_attention1x3x4() -> tensor<1x3x4xf32> {
  %init = tensor.empty() : tensor<1x3x4xf32>
  %query = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>

  %key = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                          [0.5, 0.6, 0.7, 0.8],
                                          [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %value = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %mask = util.unfoldable_constant dense<[[[true, false,  false],
                                           [true, true,   false],
                                           [true, true,   true]]]> : tensor<1x3x3xi1>
  %scale = arith.constant 0.5 : f32
  %1 = iree_linalg_ext.attention  {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> ()>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d3)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d4)>]}
                     ins(%query, %key, %value, %scale, %mask : tensor<1x3x4xf32>,
        tensor<1x3x4xf32>, tensor<1x3x4xf32>, f32, tensor<1x3x3xi1>) outs(%init : tensor<1x3x4xf32>) {
          ^bb0(%arg0: f32):
          iree_linalg_ext.yield %arg0 : f32
        } -> tensor<1x3x4xf32>
  return %1 : tensor<1x3x4xf32>
}

func.func @attention1x4x4_i1_mask_all_ones() -> tensor<1x4x4xf32> {
  %init = tensor.empty() : tensor<1x4x4xf32>
  %query = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2],
                                            [1.3, 1.4, 1.5, 1.6]]]> : tensor<1x4x4xf32>

  %key = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                          [0.5, 0.6, 0.7, 0.8],
                                          [0.9, 1.0, 1.1, 1.2],
                                          [1.3, 1.4, 1.5, 1.6]]]> : tensor<1x4x4xf32>
  %value = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2],
                                            [1.3, 1.4, 1.5, 1.6]]]> : tensor<1x4x4xf32>

  %mask = util.unfoldable_constant dense<[[[true, true, true, true],
                                           [true, true, true, true],
                                           [true, true, true, true],
                                           [true, true, true, true]]]> : tensor<1x4x4xi1>

  %scale = arith.constant 0.5 : f32
  %1 = iree_linalg_ext.attention  {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> ()>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d3)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d4)>]}
                     ins(%query, %key, %value, %scale, %mask : tensor<1x4x4xf32>,
        tensor<1x4x4xf32>, tensor<1x4x4xf32>, f32, tensor<1x4x4xi1>) outs(%init : tensor<1x4x4xf32>) {
          ^bb0(%arg0: f32):
          iree_linalg_ext.yield %arg0 : f32
        } -> tensor<1x4x4xf32>
  return %1 : tensor<1x4x4xf32>
}

func.func @softcap_attention1x3x4() -> tensor<1x3x4xf32> {
  %init = tensor.empty() : tensor<1x3x4xf32>
  %query = util.unfoldable_constant dense<[[[-0.6523,  0.7802, -0.6770, -0.9474],
                                            [ 0.6822,  0.8594,  0.1035, -0.5115],
                                            [-0.7860, -0.5562, -0.2750, -0.0973]]]> : tensor<1x3x4xf32>

  %key = util.unfoldable_constant dense<[[[-0.3457,  0.5223, -0.0553,  0.5851],
                                          [ 0.4057, -0.8352,  0.1931,  0.1678],
                                          [ 0.1438,  0.7713, -0.6535,  0.9221]]]> : tensor<1x3x4xf32>
  %value = util.unfoldable_constant dense<[[[-0.2679,  0.6395,  0.4953,  0.3751],
                                            [ 0.8195, -0.5137,  0.2178,  0.9182],
                                            [ 0.8644,  0.7615,  0.2934,  0.9721]]]> : tensor<1x3x4xf32>
  %scale = arith.constant 1.0 : f32
  %1 = iree_linalg_ext.attention  {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> ()>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d4)>]}
                     ins(%query, %key, %value, %scale : tensor<1x3x4xf32>,
        tensor<1x3x4xf32>, tensor<1x3x4xf32>, f32) outs(%init : tensor<1x3x4xf32>) {
          ^bb0(%arg0: f32):
          %tanh = math.tanh %arg0 : f32
          %cst = arith.constant 2.0 : f32
          %mul = arith.mulf %tanh, %cst : f32
          iree_linalg_ext.yield %mul : f32
        } -> tensor<1x3x4xf32>
  return %1 : tensor<1x3x4xf32>
}

func.func @attention1x4x4() -> tensor<1x4x4xf32> {
  %init = tensor.empty() : tensor<1x4x4xf32>
  %query = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2],
                                            [1.3, 1.4, 1.5, 1.6]]]> : tensor<1x4x4xf32>
  %key = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                          [0.5, 0.6, 0.7, 0.8],
                                          [0.9, 1.0, 1.1, 1.2],
                                          [1.3, 1.4, 1.5, 1.6]]]> : tensor<1x4x4xf32>
  %value = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2],
                                            [1.3, 1.4, 1.5, 1.6]]]> : tensor<1x4x4xf32>
  %scale = arith.constant 0.5 : f32
  %1 = iree_linalg_ext.attention  {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> ()>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d4)>]}
                     ins(%query, %key, %value, %scale : tensor<1x4x4xf32>,
        tensor<1x4x4xf32>, tensor<1x4x4xf32>, f32) outs(%init : tensor<1x4x4xf32>) {
          ^bb0(%arg0: f32):
          iree_linalg_ext.yield %arg0 : f32
        } -> tensor<1x4x4xf32>
  return %1 : tensor<1x4x4xf32>
}

func.func @attention3x3x4() -> tensor<3x3x4xf32> {
  %init = tensor.empty() : tensor<3x3x4xf32>
  %query = util.unfoldable_constant dense<[[[-1.5256, -0.7502, -0.6540, -1.6095],
                                            [-0.6092, -0.9798, -1.6091, -0.7121],
                                            [ 0.4676, -0.6970, -1.1608,  0.6995]],
                                           [[ 0.8657,  0.2444, -0.6629,  0.8073],
                                            [-0.1759, -2.2456, -1.4465,  0.0612],
                                            [-0.7735,  0.1991,  0.0457,  0.1530]],
                                           [[-0.1110,  0.2927, -0.1578, -0.0288],
                                            [ 1.1422, 0.2486,  -1.7754, -0.0255],
                                            [ 1.6103, -0.7040, -0.1853, -0.9962]]]> : tensor<3x3x4xf32>
  %key = util.unfoldable_constant dense<[[[-0.6092, -0.9798, -1.6091, -0.7121],
                                          [-0.7773, -0.2515, -0.2223,  1.6871],
                                          [ 0.4676, -0.6970, -1.1608,  0.6995]],
                                         [[ 0.8657,  0.2444, -0.6629,  0.8073],
                                          [-0.7981, -0.1316,  1.8793, -0.0721],
                                          [-0.7735,  0.1991,  0.0457,  0.1530]],
                                         [[-0.1110,  0.2927, -0.1578, -0.0288],
                                          [ 1.1422,  0.2486, -1.7754, -0.0255],
                                          [ 1.6103, -0.7040, -0.1853, -0.9962]]]> : tensor<3x3x4xf32>
  %value = util.unfoldable_constant dense<[[[-1.5256, -0.7502, -0.6540, -1.6095],
                                            [-0.6092, -0.9798, -1.6091, -0.7121],
                                            [ 0.4676, -0.6970, -1.1608,  0.6995]],
                                           [[ 0.8657,  0.2444, -0.6629,  0.8073],
                                            [-0.1759, -2.2456, -1.4465,  0.0612],
                                            [-0.7773, -0.2515, -0.2223,  1.6871]],
                                           [[-0.1110,  0.2927, -0.1578, -0.0288],
                                            [-0.5962, -1.0055,  0.4285,  1.4761],
                                            [ 1.6103, -0.7040, -0.1853, -0.9962]]]> : tensor<3x3x4xf32>
  %scale = arith.constant 0.5 : f32
  %1 = iree_linalg_ext.attention  {indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> ()>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d4)>]}
                     ins(%query, %key, %value, %scale : tensor<3x3x4xf32>,
        tensor<3x3x4xf32>, tensor<3x3x4xf32>, f32) outs(%init : tensor<3x3x4xf32>) {
          ^bb0(%arg0: f32):
          iree_linalg_ext.yield %arg0 : f32
        } -> tensor<3x3x4xf32>
  return %1 : tensor<3x3x4xf32>
}

func.func @online_attention1x3x4() -> tensor<1x3x4xf32> {
  %cst0 = arith.constant 0.0 : f32
  %cst_neg_inf = arith.constant 0xFF800000 : f32
  %cst_one = arith.constant 1.0 : f32
  %scale = arith.constant 0.5 : f32
  %query = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %key = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                          [0.5, 0.6, 0.7, 0.8],
                                          [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %value = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %acc_e = tensor.empty() : tensor<1x3x4xf32>
  %ms_e = tensor.empty() : tensor<1x3xf32>
  %acc = linalg.fill ins(%cst0 : f32) outs(%acc_e : tensor<1x3x4xf32>) -> tensor<1x3x4xf32>
  %max = linalg.fill ins(%cst_neg_inf : f32) outs(%ms_e : tensor<1x3xf32>) -> tensor<1x3xf32>
  %sum = linalg.fill ins(%cst0 : f32) outs(%ms_e : tensor<1x3xf32>) -> tensor<1x3xf32>
  %r:3 = iree_linalg_ext.online_attention {
    indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> ()>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1)>]
  } ins(%query, %key, %value, %scale :
        tensor<1x3x4xf32>, tensor<1x3x4xf32>, tensor<1x3x4xf32>, f32)
    outs(%acc, %max, %sum :
         tensor<1x3x4xf32>, tensor<1x3xf32>, tensor<1x3xf32>) {
  ^bb0(%score : f32):
    iree_linalg_ext.yield %score : f32
  } -> tensor<1x3x4xf32>, tensor<1x3xf32>, tensor<1x3xf32>
  %out_e = tensor.empty() : tensor<1x3x4xf32>
  %normalized = linalg.generic {
    indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2) -> (d0, d1)>,
                     affine_map<(d0, d1, d2) -> (d0, d1, d2)>],
    iterator_types = ["parallel", "parallel", "parallel"]
  } ins(%r#0, %r#2 : tensor<1x3x4xf32>, tensor<1x3xf32>)
    outs(%out_e : tensor<1x3x4xf32>) {
  ^bb0(%a: f32, %s: f32, %_: f32):
    %inv = arith.divf %cst_one, %s : f32
    %v = arith.mulf %a, %inv : f32
    linalg.yield %v : f32
  } -> tensor<1x3x4xf32>
  return %normalized : tensor<1x3x4xf32>
}

func.func @causal_online_attention1x3x4() -> tensor<1x3x4xf32> {
  %cst0 = arith.constant 0.0 : f32
  %cst_neg_inf = arith.constant 0xFF800000 : f32
  %cst_one = arith.constant 1.0 : f32
  %scale = arith.constant 0.5 : f32
  %query = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %key = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                          [0.5, 0.6, 0.7, 0.8],
                                          [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %value = util.unfoldable_constant dense<[[[0.1, 0.2, 0.3, 0.4],
                                            [0.5, 0.6, 0.7, 0.8],
                                            [0.9, 1.0, 1.1, 1.2]]]> : tensor<1x3x4xf32>
  %mask = util.unfoldable_constant dense<[[[true, false,  false],
                                           [true, true,   false],
                                           [true, true,   true]]]> : tensor<1x3x3xi1>
  %acc_e = tensor.empty() : tensor<1x3x4xf32>
  %ms_e = tensor.empty() : tensor<1x3xf32>
  %acc = linalg.fill ins(%cst0 : f32) outs(%acc_e : tensor<1x3x4xf32>) -> tensor<1x3x4xf32>
  %max = linalg.fill ins(%cst_neg_inf : f32) outs(%ms_e : tensor<1x3xf32>) -> tensor<1x3xf32>
  %sum = linalg.fill ins(%cst0 : f32) outs(%ms_e : tensor<1x3xf32>) -> tensor<1x3xf32>
  %r:3 = iree_linalg_ext.online_attention {
    indexing_maps = [affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d2)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d3, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> ()>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d3)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d4)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1)>,
                     affine_map<(d0, d1, d2, d3, d4) -> (d0, d1)>]
  } ins(%query, %key, %value, %scale, %mask :
        tensor<1x3x4xf32>, tensor<1x3x4xf32>, tensor<1x3x4xf32>, f32, tensor<1x3x3xi1>)
    outs(%acc, %max, %sum :
         tensor<1x3x4xf32>, tensor<1x3xf32>, tensor<1x3xf32>) {
  ^bb0(%score : f32):
    iree_linalg_ext.yield %score : f32
  } -> tensor<1x3x4xf32>, tensor<1x3xf32>, tensor<1x3xf32>
  %out_e = tensor.empty() : tensor<1x3x4xf32>
  %normalized = linalg.generic {
    indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1, d2)>,
                     affine_map<(d0, d1, d2) -> (d0, d1)>,
                     affine_map<(d0, d1, d2) -> (d0, d1, d2)>],
    iterator_types = ["parallel", "parallel", "parallel"]
  } ins(%r#0, %r#2 : tensor<1x3x4xf32>, tensor<1x3xf32>)
    outs(%out_e : tensor<1x3x4xf32>) {
  ^bb0(%a: f32, %s: f32, %_: f32):
    %inv = arith.divf %cst_one, %s : f32
    %v = arith.mulf %a, %inv : f32
    linalg.yield %v : f32
  } -> tensor<1x3x4xf32>
  return %normalized : tensor<1x3x4xf32>
}
