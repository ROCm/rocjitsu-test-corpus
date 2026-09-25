// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include <hip/hip_runtime.h>

#include <cstddef>
#include <cstdlib>
#include <iostream>
#include <vector>

#include "utils.hpp"

// WAR (Write-After-Read) pattern: each thread reads data[i], then overwrites
// data[i]. The read and overwrite target the same VGPR, exercising RAW/WAR
// hazard paths. Result is stored in a separate output buffer for validation.
__global__ void war_pattern(int* data, int* result, unsigned int n) {
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        int val   = data[i];     // read (global_load -> VGPR)
        result[i] = val * 3 + 1; // use loaded value (depends on s_wait_loadcnt)
        data[i]   = val + 100;   // write back (WAR on the global address)
    }
}

int main() {
    constexpr unsigned int arraySize       = 256 * 256;
    constexpr int          threadsPerBlock = 256;
    constexpr int          numBlocks       = arraySize / threadsPerBlock;

    std::vector<int> data(arraySize), result(arraySize);
    int *            d_data, *d_result;

    for (unsigned int i = 0; i < arraySize; ++i) {
        data[i] = static_cast<int>(i);
    }

    HIP_CHECK(hipMalloc(&d_data, arraySize * sizeof(int)));
    HIP_CHECK(hipMalloc(&d_result, arraySize * sizeof(int)));
    HIP_CHECK(hipMemcpy(d_data, data.data(), arraySize * sizeof(int), hipMemcpyHostToDevice));

    war_pattern<<<numBlocks, threadsPerBlock>>>(d_data, d_result, arraySize);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    // Both buffers come back. d_data carries the write-after-read this kernel
    // exists to exercise, so checking only d_result would let that store vanish
    // entirely without the test noticing.
    std::vector<int> written(arraySize);
    HIP_CHECK(hipMemcpy(result.data(), d_result, arraySize * sizeof(int), hipMemcpyDeviceToHost));
    HIP_CHECK(hipMemcpy(written.data(), d_data, arraySize * sizeof(int), hipMemcpyDeviceToHost));
    HIP_CHECK(hipFree(d_data));
    HIP_CHECK(hipFree(d_result));

    std::cout << "[";
    for (unsigned int i = 0; i < arraySize; ++i) {
        if (i > 0)
            std::cout << ",";
        std::cout << result[i];
    }
    std::cout << "]" << std::endl;

    bool pass = true;
    for (unsigned int i = 0; i < arraySize; ++i) {
        int expected_result = static_cast<int>(i) * 3 + 1;
        if (result[i] != expected_result) {
            std::cerr << "result mismatch at " << i << ": expected " << expected_result << " got "
                      << result[i] << std::endl;
            pass = false;
            break;
        }
        // data[i] started at i and the kernel writes back val + 100.
        int expected_written = static_cast<int>(i) + 100;
        if (written[i] != expected_written) {
            std::cerr << "data mismatch at " << i << ": expected " << expected_written << " got "
                      << written[i] << std::endl;
            pass = false;
            break;
        }
    }
    std::cerr << (pass ? "PASS" : "FAIL") << std::endl;
    return pass ? EXIT_SUCCESS : EXIT_FAILURE;
}
