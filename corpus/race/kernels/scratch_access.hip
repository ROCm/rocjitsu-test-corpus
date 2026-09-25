// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include <hip/hip_runtime.h>

#include <cstddef>
#include <cstdlib>
#include <iostream>
#include <vector>

#include "utils.hpp"

// Scratch (private) memory test: a per-thread array is filled, then one slot is
// read back and used. The read is ordered against the fill by the wait counter
// that guards private memory, and removing that wait is the hazard this kernel
// exists to expose.
__global__ void scratch_access(const int* input, int* output, unsigned int n) {
    int          local_buf[64];
    unsigned int tid = blockIdx.x * blockDim.x + threadIdx.x;

    if (tid < n) {
        // Fill the private array: vectorized scratch stores.
        for (int j = 0; j < 64; ++j) {
            local_buf[j] = input[tid] + j;
        }

        // Read one slot at an index the compiler cannot resolve, so the array
        // must stay addressable in scratch. The load's result is used
        // immediately, so the wait between them is the one that matters.
        int idx = input[tid] & 63;
        output[tid] = local_buf[idx];
    }
}

int main() {
    constexpr unsigned int arraySize       = 256 * 256;
    constexpr int          threadsPerBlock = 256;
    constexpr int          numBlocks       = arraySize / threadsPerBlock;

    std::vector<int> input(arraySize), output(arraySize, 0);
    int *            d_in, *d_out;

    for (unsigned int i = 0; i < arraySize; ++i) {
        input[i] = static_cast<int>(i % 100);
    }

    HIP_CHECK(hipMalloc(&d_in, arraySize * sizeof(int)));
    HIP_CHECK(hipMalloc(&d_out, arraySize * sizeof(int)));
    HIP_CHECK(hipMemcpy(d_in, input.data(), arraySize * sizeof(int), hipMemcpyHostToDevice));

    scratch_access<<<numBlocks, threadsPerBlock>>>(d_in, d_out, arraySize);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    HIP_CHECK(hipMemcpy(output.data(), d_out, arraySize * sizeof(int), hipMemcpyDeviceToHost));
    HIP_CHECK(hipFree(d_in));
    HIP_CHECK(hipFree(d_out));

    std::cout << "[";
    for (unsigned int i = 0; i < arraySize; ++i) {
        if (i > 0)
            std::cout << ",";
        std::cout << output[i];
    }
    std::cout << "]" << std::endl;

    // Slot j holds input[i] + j, and the slot read is input[i] & 63, so the
    // result is input[i] + (input[i] & 63). The read index depends on the
    // loaded value, which is what keeps the compiler from folding the array
    // away -- see the kernel comment.
    bool pass = true;
    for (unsigned int i = 0; i < arraySize; ++i) {
        int expected = input[i] + (input[i] & 63);
        if (output[i] != expected) {
            std::cerr << "Mismatch at " << i << ": expected " << expected << " got " << output[i] << std::endl;
            pass = false;
            break;
        }
    }
    std::cerr << (pass ? "PASS" : "FAIL") << std::endl;
    return pass ? EXIT_SUCCESS : EXIT_FAILURE;
}
