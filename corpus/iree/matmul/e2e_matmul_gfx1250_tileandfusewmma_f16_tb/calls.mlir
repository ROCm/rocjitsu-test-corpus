builtin.module @calls attributes {
  
} {

util.func private @matmul_test.generate_random_matrix(%device: !hal.device, %dim0: i64, %dim1: i64, %element_type: i32, %seed: i32) -> !hal.buffer_view
util.func private @matmul_test.check_matmul_results(%device: !hal.device, %m: i64, %k: i64, %n: i64, %transpose_rhs: i32, %lhs: !hal.buffer_view, %rhs: !hal.buffer_view, %acc: !hal.buffer_view, %actual_result: !hal.buffer_view)

util.func private @module.matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs: !hal.buffer_view, %rhs: !hal.buffer_view, %acc: !hal.buffer_view) -> !hal.buffer_view
util.func private @module.matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs: !hal.buffer_view, %rhs: !hal.buffer_view) -> !hal.buffer_view

util.func @matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_acc_0() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 1 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 2 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_dim0 = arith.constant 512 : i64
  %acc_dim1 = arith.constant 512 : i64
  %acc_element_type = hal.element_type<f32> : i32
  %acc_seed = arith.constant 3 : i32
  %acc = util.call @matmul_test.generate_random_matrix(%device, %acc_dim0, %acc_dim1, %acc_element_type, %acc_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_copy_dim0 = arith.constant 512 : i64
  %acc_copy_dim1 = arith.constant 512 : i64
  %acc_copy_element_type = hal.element_type<f32> : i32
  %acc_copy_seed = arith.constant 3 : i32
  %acc_copy = util.call @matmul_test.generate_random_matrix(%device, %acc_copy_dim0, %acc_copy_dim1, %acc_copy_element_type, %acc_copy_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs, %acc) : (!hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc_copy, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_1() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %acc = util.null : !hal.buffer_view
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 4 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 5 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs) : (!hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_acc_2() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 6 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 7 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_dim0 = arith.constant 512 : i64
  %acc_dim1 = arith.constant 512 : i64
  %acc_element_type = hal.element_type<f32> : i32
  %acc_seed = arith.constant 8 : i32
  %acc = util.call @matmul_test.generate_random_matrix(%device, %acc_dim0, %acc_dim1, %acc_element_type, %acc_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_copy_dim0 = arith.constant 512 : i64
  %acc_copy_dim1 = arith.constant 512 : i64
  %acc_copy_element_type = hal.element_type<f32> : i32
  %acc_copy_seed = arith.constant 8 : i32
  %acc_copy = util.call @matmul_test.generate_random_matrix(%device, %acc_copy_dim0, %acc_copy_dim1, %acc_copy_element_type, %acc_copy_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs, %acc) : (!hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc_copy, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_3() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %acc = util.null : !hal.buffer_view
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 9 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 10 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs) : (!hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_acc_4() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 11 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 12 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_dim0 = arith.constant 512 : i64
  %acc_dim1 = arith.constant 512 : i64
  %acc_element_type = hal.element_type<f32> : i32
  %acc_seed = arith.constant 13 : i32
  %acc = util.call @matmul_test.generate_random_matrix(%device, %acc_dim0, %acc_dim1, %acc_element_type, %acc_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_copy_dim0 = arith.constant 512 : i64
  %acc_copy_dim1 = arith.constant 512 : i64
  %acc_copy_element_type = hal.element_type<f32> : i32
  %acc_copy_seed = arith.constant 13 : i32
  %acc_copy = util.call @matmul_test.generate_random_matrix(%device, %acc_copy_dim0, %acc_copy_dim1, %acc_copy_element_type, %acc_copy_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs, %acc) : (!hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc_copy, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_5() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %acc = util.null : !hal.buffer_view
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 14 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 15 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs) : (!hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_acc_6() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 16 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 17 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_dim0 = arith.constant 512 : i64
  %acc_dim1 = arith.constant 512 : i64
  %acc_element_type = hal.element_type<f32> : i32
  %acc_seed = arith.constant 18 : i32
  %acc = util.call @matmul_test.generate_random_matrix(%device, %acc_dim0, %acc_dim1, %acc_element_type, %acc_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_copy_dim0 = arith.constant 512 : i64
  %acc_copy_dim1 = arith.constant 512 : i64
  %acc_copy_element_type = hal.element_type<f32> : i32
  %acc_copy_seed = arith.constant 18 : i32
  %acc_copy = util.call @matmul_test.generate_random_matrix(%device, %acc_copy_dim0, %acc_copy_dim1, %acc_copy_element_type, %acc_copy_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs, %acc) : (!hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc_copy, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_7() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %acc = util.null : !hal.buffer_view
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 19 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 20 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs) : (!hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_acc_8() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 21 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 22 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_dim0 = arith.constant 512 : i64
  %acc_dim1 = arith.constant 512 : i64
  %acc_element_type = hal.element_type<f32> : i32
  %acc_seed = arith.constant 23 : i32
  %acc = util.call @matmul_test.generate_random_matrix(%device, %acc_dim0, %acc_dim1, %acc_element_type, %acc_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_copy_dim0 = arith.constant 512 : i64
  %acc_copy_dim1 = arith.constant 512 : i64
  %acc_copy_element_type = hal.element_type<f32> : i32
  %acc_copy_seed = arith.constant 23 : i32
  %acc_copy = util.call @matmul_test.generate_random_matrix(%device, %acc_copy_dim0, %acc_copy_dim1, %acc_copy_element_type, %acc_copy_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs, %acc) : (!hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc_copy, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_9() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %acc = util.null : !hal.buffer_view
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 24 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 25 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs) : (!hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_acc_10() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 26 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 27 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_dim0 = arith.constant 512 : i64
  %acc_dim1 = arith.constant 512 : i64
  %acc_element_type = hal.element_type<f32> : i32
  %acc_seed = arith.constant 28 : i32
  %acc = util.call @matmul_test.generate_random_matrix(%device, %acc_dim0, %acc_dim1, %acc_element_type, %acc_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_copy_dim0 = arith.constant 512 : i64
  %acc_copy_dim1 = arith.constant 512 : i64
  %acc_copy_element_type = hal.element_type<f32> : i32
  %acc_copy_seed = arith.constant 28 : i32
  %acc_copy = util.call @matmul_test.generate_random_matrix(%device, %acc_copy_dim0, %acc_copy_dim1, %acc_copy_element_type, %acc_copy_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs, %acc) : (!hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc_copy, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_11() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %acc = util.null : !hal.buffer_view
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 29 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 30 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs) : (!hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_acc_12() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 31 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 32 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_dim0 = arith.constant 512 : i64
  %acc_dim1 = arith.constant 512 : i64
  %acc_element_type = hal.element_type<f32> : i32
  %acc_seed = arith.constant 33 : i32
  %acc = util.call @matmul_test.generate_random_matrix(%device, %acc_dim0, %acc_dim1, %acc_element_type, %acc_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %acc_copy_dim0 = arith.constant 512 : i64
  %acc_copy_dim1 = arith.constant 512 : i64
  %acc_copy_element_type = hal.element_type<f32> : i32
  %acc_copy_seed = arith.constant 33 : i32
  %acc_copy = util.call @matmul_test.generate_random_matrix(%device, %acc_copy_dim0, %acc_copy_dim1, %acc_copy_element_type, %acc_copy_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_accumulate_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs, %acc) : (!hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc_copy, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}

util.func @matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse_512_128_512_13() attributes {
  iree.reflection = {description = "Matmul shape (MxKxN): 512x128x512"}
} {
  %device_index = arith.constant 0 : index
  %device = hal.devices.get %device_index : !hal.device
  %acc = util.null : !hal.buffer_view
  %lhs_dim0 = arith.constant 512 : i64
  %lhs_dim1 = arith.constant 128 : i64
  %lhs_element_type = hal.element_type<f16> : i32
  %lhs_seed = arith.constant 34 : i32
  %lhs = util.call @matmul_test.generate_random_matrix(%device, %lhs_dim0, %lhs_dim1, %lhs_element_type, %lhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %rhs_dim0 = arith.constant 512 : i64
  %rhs_dim1 = arith.constant 128 : i64
  %rhs_element_type = hal.element_type<f16> : i32
  %rhs_seed = arith.constant 35 : i32
  %rhs = util.call @matmul_test.generate_random_matrix(%device, %rhs_dim0, %rhs_dim1, %rhs_element_type, %rhs_seed) : (!hal.device, i64, i64, i32, i32) -> !hal.buffer_view
  %result = util.call @module.matmul_512x128xf16_times_512x128xf16_into_512x512xf32_for_TileAndFuse(%lhs, %rhs) : (!hal.buffer_view, !hal.buffer_view) -> !hal.buffer_view
  %m = arith.constant 512 : i64
  %k = arith.constant 128 : i64
  %n = arith.constant 512 : i64
  %transpose_rhs = arith.constant 1 : i32
  util.call @matmul_test.check_matmul_results(%device, %m, %k, %n, %transpose_rhs, %lhs, %rhs, %acc, %result) : (!hal.device, i64, i64, i64, i32,  !hal.buffer_view, !hal.buffer_view, !hal.buffer_view, !hal.buffer_view) -> ()
  util.return
}


}
