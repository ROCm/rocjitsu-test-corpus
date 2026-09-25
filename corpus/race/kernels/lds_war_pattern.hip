// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include <hip/hip_runtime.h>

#include <cstddef>
#include <cstdlib>
#include <iostream>
#include <vector>

#include "utils.hpp"

// LDS WAR (Write-After-Read) pattern.
//
// Each thread reads its slot from shared memory (ds_read, DScnt increments),
// then writes a new value back to the *same* slot (ds_write).  A write that
// landed before the in-flight read had captured its data would corrupt the
// slot — a classic intra-wave LDS WAR hazard.
//
// As compiled the sequence is safe: the write consumes the value the read
// produced, so the compiler places s_wait_dscnt between them and the read is
// guaranteed to have completed first.  Removing that wait is what exposes the
// WAR, so the hazard belongs to the mutants rather than to this kernel.
__global__ void lds_war_pattern(const int* input, int* output, unsigned int n) {
    __shared__ int sdata[256];
    unsigned int   tid = threadIdx.x;
    unsigned int   i   = blockIdx.x * blockDim.x + tid;

    sdata[tid] = (i < n) ? input[i] : 0;
    __syncthreads();

    // Intra-wave LDS WAR: read sdata[tid] then overwrite sdata[tid].  The
    // s_wait_dscnt the compiler places between them is the mutation target.
    int val    = sdata[tid];       // ds_read  — DScnt increments
    sdata[tid] = val + 1;          // ds_write — same slot, ordered by the wait
    __syncthreads();

    if (tid == 0) {
        output[blockIdx.x] = sdata[0];
    }
}

int main() {
    constexpr unsigned int arraySize       = 256 * 256;
    constexpr int          threadsPerBlock = 256;
    constexpr int          numBlocks       = arraySize / threadsPerBlock;

    // Distinct values per element, so the slot each block reports back is tied
    // to the input it was filled from rather than to a constant.
    std::vector<int> input(arraySize);
    for (unsigned int i = 0; i < arraySize; ++i)
        input[i] = static_cast<int>(i);

    std::vector<int> output(numBlocks, 0);
    int *            d_in, *d_out;

    HIP_CHECK(hipMalloc(&d_in, arraySize * sizeof(int)));
    HIP_CHECK(hipMalloc(&d_out, numBlocks * sizeof(int)));
    HIP_CHECK(hipMemcpy(d_in, input.data(), arraySize * sizeof(int), hipMemcpyHostToDevice));

    lds_war_pattern<<<numBlocks, threadsPerBlock>>>(d_in, d_out, arraySize);
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    HIP_CHECK(hipMemcpy(output.data(), d_out, numBlocks * sizeof(int), hipMemcpyDeviceToHost));
    HIP_CHECK(hipFree(d_in));
    HIP_CHECK(hipFree(d_out));

    std::cout << "[";
    for (int i = 0; i < numBlocks; ++i) {
        if (i > 0)
            std::cout << ",";
        std::cout << output[i];
    }
    std::cout << "]" << std::endl;

    // Each block sums threadsPerBlock values of 1, then each thread increments
    // its slot by 1. The first thread's slot ends at 1+1 = 2; output[b] = 2.
    bool pass = true;
    for (int i = 0; i < numBlocks; ++i) {
        // Thread 0 of each block reports its slot after the read-modify-write.
        int expected = input[i * threadsPerBlock] + 1;
        if (output[i] != expected) {
            std::cerr << "Mismatch at block " << i << ": expected " << expected << " got " << output[i]
                      << std::endl;
            pass = false;
        }
    }
    std::cerr << (pass ? "PASS" : "FAIL") << std::endl;
    return pass ? EXIT_SUCCESS : EXIT_FAILURE;
}
