// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#pragma once

// Integer matrix CTS follows the FPSan LayoutMatchesHardware shape: construct
// logical A/B/C matrices, pack them into the documented RDNA4 per-lane fragment
// layout, call the raw LLVM builtin, then compare against a scalar ISA oracle.

#include "hip_test_utils.hpp"
#include "int_isa_test_utils.hpp"

#include <gtest/gtest.h>
#include <hip/hip_runtime.h>

#include <cstdint>
#include <limits>
#include <memory>
#include <type_traits>
#include <vector>

namespace
{
constexpr int kM = 16;
constexpr int kN = 16;

#if defined(INT_ISA_TEST_WAVE64)
constexpr int kWaveLanes      = 64;
constexpr int kCValuesPerLane = 4;
#else
constexpr int kWaveLanes = 32;
constexpr int kCValuesPerLane = 8;
#endif

using v2i32 = int __attribute__((ext_vector_type(2)));
using v4i32 = int __attribute__((ext_vector_type(4)));
using v8i32 = int __attribute__((ext_vector_type(8)));
using v16i32 = int __attribute__((ext_vector_type(16)));

#if defined(INT_ISA_TEST_WAVE64)
using cfrag_t = v4i32;
#else
using cfrag_t = v8i32;
#endif

struct HipDeviceDeleter
{
    template <class T>
    void operator()(T* device) const noexcept
    {
        if(device != nullptr)
            (void)hipFree(device);
    }
};

template <class T>
using DevicePtr = std::unique_ptr<T, HipDeviceDeleter>;

template <class T>
DevicePtr<T> allocate_device(std::size_t count)
{
    T* device = nullptr;
    const hipError_t status = hipMalloc(&device, count * sizeof(T));
    EXPECT_EQ(status, hipSuccess) << hipGetErrorString(status);
    if(status != hipSuccess)
        return {};

    return DevicePtr<T>(device);
}

template <class T>
DevicePtr<T> to_device(const std::vector<T>& host)
{
    DevicePtr<T> device = allocate_device<T>(host.size());
    if(!device)
        return {};

    const hipError_t status =
        hipMemcpy(device.get(), host.data(), host.size() * sizeof(T), hipMemcpyHostToDevice);
    EXPECT_EQ(status, hipSuccess) << hipGetErrorString(status);
    if(status != hipSuccess)
        return {};

    return device;
}

template <class Frag>
__device__ void set_frag_word(Frag& frag, int word, std::uint32_t value)
{
    if constexpr(std::is_same<Frag, int>::value)
        frag = static_cast<int>(value);
    else
        frag[word] = static_cast<int>(value);
}

template <class Frag>
__device__ Frag make_zero_frag()
{
    Frag frag{};
    return frag;
}

__host__ __device__ constexpr std::uint32_t packed_bits(std::int32_t value, int bits)
{
    return bits == 8 ? (static_cast<std::uint32_t>(value) & 0xffu)
                     : (static_cast<std::uint32_t>(value) & 0xfu);
}

__host__ __device__ constexpr std::int32_t matrix_value(bool is_signed, int bits, int a, int b, int seed)
{
    const int raw = (a * 11 + b * 7 + seed) % 9;
    if(is_signed)
        return bits == 8 ? raw - 4 : (raw % 7) - 3;
    return bits == 8 ? raw + 1 : (raw % 7) + 1;
}

__host__ __device__ constexpr int lane_k_block(int lane, int block_count)
{
    const int block = lane >> 4;
    if(block >= block_count)
        return -1;
#if defined(INT_ISA_TEST_WAVE64)
    if(block_count == 4)
        return ((block & 1) << 1) | (block >> 1);
#endif
    return block;
}

__host__ __device__ constexpr int cd_row_from_lane(int lane, int element)
{
#if defined(INT_ISA_TEST_WAVE64)
    return element + 8 * ((lane >> 4) & 1) + 4 * (lane >> 5);
#else
    return element + 8 * (lane >> 4);
#endif
}

template <class Trait>
struct MatrixData
{
    std::vector<std::int32_t> A;
    std::vector<std::int32_t> B;
    std::vector<std::int32_t> C;
};

template <class Trait>
void apply_dense_overflow_cases(MatrixData<Trait>& data)
{
    // Preserve the general input pattern while reserving outputs that
    // distinguish signed saturation from modulo-2^32 wrap.
    for(int k = 0; k < Trait::K; ++k)
    {
        data.A[k]       = 1;
        data.B[k * kN] = 1;
        if constexpr(Trait::ASigned)
            data.A[Trait::K + k] = -1;
        if constexpr(Trait::BSigned)
            data.B[k * kN + 1] = -1;
    }

    data.C[0] = std::numeric_limits<std::int32_t>::max() - 4;
    if constexpr(Trait::ASigned)
        data.C[kN] = std::numeric_limits<std::int32_t>::min() + 4;
    if constexpr(Trait::BSigned)
        data.C[1] = std::numeric_limits<std::int32_t>::min() + 4;
}

template <class Trait>
MatrixData<Trait> make_dense_inputs(int seed)
{
    MatrixData<Trait> data;
    data.A.resize(kM * Trait::K);
    data.B.resize(Trait::K * kN);
    data.C.resize(kM * kN);
    for(int m = 0; m < kM; ++m)
        for(int k = 0; k < Trait::K; ++k)
            data.A[m * Trait::K + k] =
                matrix_value(Trait::ASigned, Trait::Bits, m, k, seed);
    for(int k = 0; k < Trait::K; ++k)
        for(int n = 0; n < kN; ++n)
            data.B[k * kN + n] = matrix_value(Trait::BSigned, Trait::Bits, k, n, seed + 3);
    for(int m = 0; m < kM; ++m)
        for(int n = 0; n < kN; ++n)
            data.C[m * kN + n] = ((m * 5 + n * 3 + seed) % 11) - 5;
    apply_dense_overflow_cases<Trait>(data);
    return data;
}

template <class Trait>
std::vector<std::int32_t> dense_reference(const MatrixData<Trait>& data)
{
    std::vector<std::int32_t> ref(kM * kN);
    for(int m = 0; m < kM; ++m)
        for(int n = 0; n < kN; ++n)
        {
            std::int64_t acc = data.C[m * kN + n];
            for(int k = 0; k < Trait::K; ++k)
                acc += static_cast<std::int64_t>(data.A[m * Trait::K + k])
                       * data.B[k * kN + n];
            if(m == 0 && n == 0)
                EXPECT_GT(acc, std::numeric_limits<std::int32_t>::max());
            if constexpr(Trait::ASigned)
                if(m == 1 && n == 0)
                    EXPECT_LT(acc, std::numeric_limits<std::int32_t>::min());
            if constexpr(Trait::BSigned)
                if(m == 0 && n == 1)
                    EXPECT_LT(acc, std::numeric_limits<std::int32_t>::min());
            const std::uint32_t bits =
                Trait::Clamp ? int_isa_test::clamp_i32_bits(acc) : static_cast<std::uint32_t>(acc);
            ref[m * kN + n] = static_cast<std::int32_t>(bits);
        }
    return ref;
}

template <class Trait>
__device__ typename Trait::AFrag load_dense_a_frag(const std::int32_t* A, int lane)
{
    typename Trait::AFrag frag = make_zero_frag<typename Trait::AFrag>();
    std::uint32_t         words[Trait::AWords]{};
    const int             row  = lane & 15;
    const int             block =
        lane_k_block(lane, Trait::K / Trait::AValuesPerLane);
    if(block < 0)
        return frag;
    for(int idx = 0; idx < Trait::AValuesPerLane; ++idx)
    {
        const int k     = block * Trait::AValuesPerLane + idx;
        const int word  = idx / Trait::ValuesPerWord;
        const int shift = (idx % Trait::ValuesPerWord) * Trait::Bits;
        words[word] |= packed_bits(A[row * Trait::K + k], Trait::Bits) << shift;
    }
    for(int word = 0; word < Trait::AWords; ++word)
        set_frag_word(frag, word, words[word]);
    return frag;
}

template <class Trait>
__device__ typename Trait::BFrag load_dense_b_frag(const std::int32_t* B, int lane)
{
    typename Trait::BFrag frag = make_zero_frag<typename Trait::BFrag>();
    std::uint32_t         words[Trait::BWords]{};
    const int             col  = lane & 15;
    const int             block =
        lane_k_block(lane, Trait::K / Trait::BValuesPerLane);
    if(block < 0)
        return frag;
    for(int idx = 0; idx < Trait::BValuesPerLane; ++idx)
    {
        const int k     = block * Trait::BValuesPerLane + idx;
        const int word  = idx / Trait::ValuesPerWord;
        const int shift = (idx % Trait::ValuesPerWord) * Trait::Bits;
        words[word] |= packed_bits(B[k * kN + col], Trait::Bits) << shift;
    }
    for(int word = 0; word < Trait::BWords; ++word)
        set_frag_word(frag, word, words[word]);
    return frag;
}

template <class Trait>
__device__ typename Trait::CFrag load_c_frag(const std::int32_t* C, int lane)
{
    typename Trait::CFrag c{};
    const int             col = lane & 15;
    for(int e = 0; e < Trait::CValuesPerLane; ++e)
        c[e] = C[cd_row_from_lane(lane, e) * kN + col];
    return c;
}

template <class Trait>
__device__ void store_d_frag(const typename Trait::CFrag& d, std::int32_t* D, int lane)
{
    const int col = lane & 15;
    for(int e = 0; e < Trait::CValuesPerLane; ++e)
        D[cd_row_from_lane(lane, e) * kN + col] = d[e];
}

template <class Trait>
__global__ void dense_matrix_kernel(const std::int32_t* A,
                                    const std::int32_t* B,
                                    const std::int32_t* C,
                                    std::int32_t*       D)
{
    const int lane = threadIdx.x;
    auto      a    = load_dense_a_frag<Trait>(A, lane);
    auto      b    = load_dense_b_frag<Trait>(B, lane);
    auto      c    = load_c_frag<Trait>(C, lane);
    store_d_frag<Trait>(Trait::call(a, b, c), D, lane);
}

template <class Trait>
void run_dense_matrix_case(int seed)
{
    MatrixData<Trait>         data = make_dense_inputs<Trait>(seed);
    std::vector<std::int32_t> ref  = dense_reference<Trait>(data);
    auto                      dA   = to_device(data.A);
    auto                      dB   = to_device(data.B);
    auto                      dC   = to_device(data.C);
    if(!dA || !dB || !dC)
        FAIL() << "failed to initialize matrix inputs on device";

    auto dD = allocate_device<std::int32_t>(ref.size());
    if(!dD)
        return;

    dense_matrix_kernel<Trait><<<1, kWaveLanes>>>(dA.get(), dB.get(), dC.get(), dD.get());
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    std::vector<std::int32_t> got(ref.size());
    HIP_CHECK(hipMemcpy(
        got.data(), dD.get(), got.size() * sizeof(std::int32_t), hipMemcpyDeviceToHost));
    for(std::size_t i = 0; i < ref.size(); ++i)
        EXPECT_EQ(static_cast<std::uint32_t>(got[i]), static_cast<std::uint32_t>(ref[i]))
            << Trait::Name << " asigned=" << Trait::ASigned << " bsigned=" << Trait::BSigned
            << " clamp=" << Trait::Clamp << " element " << i;
}

template <class Trait>
struct SparseData
{
    std::vector<std::int32_t>  A;
    std::vector<std::int32_t>  B;
    std::vector<std::int32_t>  C;
    std::vector<std::uint32_t> idx;
    std::vector<std::int32_t>  p0;
    std::vector<std::int32_t>  p1;
};

template <class Trait>
void set_sparse_a_row(SparseData<Trait>& data, int row, std::int32_t value)
{
    for(int g = 0; g < Trait::Groups; ++g)
    {
        data.A[row * Trait::K + 4 * g + data.p0[row * Trait::Groups + g]] = value;
        data.A[row * Trait::K + 4 * g + data.p1[row * Trait::Groups + g]] = value;
    }
}

template <class Trait>
void apply_sparse_overflow_cases(SparseData<Trait>& data)
{
    set_sparse_a_row(data, 0, 1);
    for(int k = 0; k < Trait::K; ++k)
    {
        data.B[k * kN] = 1;
        if constexpr(Trait::BSigned)
            data.B[k * kN + 1] = -1;
    }
    data.C[0] = std::numeric_limits<std::int32_t>::max() - 4;

    if constexpr(Trait::ASigned)
    {
        set_sparse_a_row(data, 1, -1);
        data.C[kN] = std::numeric_limits<std::int32_t>::min() + 4;
    }
    if constexpr(Trait::BSigned)
        data.C[1] = std::numeric_limits<std::int32_t>::min() + 4;
}

template <class Trait>
SparseData<Trait> make_sparse_inputs(int seed)
{
    SparseData<Trait> data;
    data.A.assign(kM * Trait::K, 0);
    data.B.resize(Trait::K * kN);
    data.C.resize(kM * kN);
    data.idx.assign(kWaveLanes * Trait::IndexWords, 0);
    data.p0.resize(kM * Trait::Groups);
    data.p1.resize(kM * Trait::Groups);

    for(int k = 0; k < Trait::K; ++k)
        for(int n = 0; n < kN; ++n)
            data.B[k * kN + n] = matrix_value(Trait::BSigned, Trait::Bits, k, n, seed + 17);
    for(int m = 0; m < kM; ++m)
        for(int n = 0; n < kN; ++n)
            data.C[m * kN + n] = ((m * 3 + n * 5 + seed) % 13) - 6;
    constexpr int selector_pairs[6][2] = {
        {0, 1}, {0, 2}, {0, 3}, {1, 2}, {1, 3}, {2, 3}};
    for(int m = 0; m < kM; ++m)
        for(int g = 0; g < Trait::Groups; ++g)
        {
            const int pair   = (m * 5 + g * 3 + seed) % 6;
            const int first  = selector_pairs[pair][0];
            const int second = selector_pairs[pair][1];
            data.p0[m * Trait::Groups + g] = first;
            data.p1[m * Trait::Groups + g] = second;
            data.A[m * Trait::K + 4 * g + first] =
                matrix_value(Trait::ASigned, Trait::Bits, m, 4 * g + first, seed + 23);
            data.A[m * Trait::K + 4 * g + second] =
                matrix_value(Trait::ASigned, Trait::Bits, m, 4 * g + second, seed + 29);
        }

    apply_sparse_overflow_cases<Trait>(data);

    for(int lane = 0; lane < kWaveLanes; ++lane)
    {
        const int row  = lane & 15;
        const int block =
            lane_k_block(lane, Trait::Groups / Trait::GroupsPerLane);
        if(block >= 0)
        {
            for(int local_g = 0; local_g < Trait::GroupsPerLane; ++local_g)
            {
                const int g     = block * Trait::GroupsPerLane + local_g;
                const int field = (data.p0[row * Trait::Groups + g] & 3)
                                  | ((data.p1[row * Trait::Groups + g] & 3) << 2);
                const int bit = 4 * local_g;
                data.idx[lane * Trait::IndexWords + bit / 32] |=
                    static_cast<std::uint32_t>(field) << (bit % 32);
            }
        }
    }
    return data;
}

template <class Trait>
std::vector<std::int32_t> sparse_reference(const SparseData<Trait>& data)
{
    std::vector<std::int32_t> ref(kM * kN);
    for(int m = 0; m < kM; ++m)
        for(int n = 0; n < kN; ++n)
        {
            std::int64_t acc = data.C[m * kN + n];
            for(int g = 0; g < Trait::Groups; ++g)
            {
                const int k0 = 4 * g + data.p0[m * Trait::Groups + g];
                const int k1 = 4 * g + data.p1[m * Trait::Groups + g];
                acc += static_cast<std::int64_t>(data.A[m * Trait::K + k0])
                       * data.B[k0 * kN + n];
                acc += static_cast<std::int64_t>(data.A[m * Trait::K + k1])
                       * data.B[k1 * kN + n];
            }
            if(m == 0 && n == 0)
                EXPECT_GT(acc, std::numeric_limits<std::int32_t>::max());
            if constexpr(Trait::ASigned)
                if(m == 1 && n == 0)
                    EXPECT_LT(acc, std::numeric_limits<std::int32_t>::min());
            if constexpr(Trait::BSigned)
                if(m == 0 && n == 1)
                    EXPECT_LT(acc, std::numeric_limits<std::int32_t>::min());
            const std::uint32_t bits =
                Trait::Clamp ? int_isa_test::clamp_i32_bits(acc) : static_cast<std::uint32_t>(acc);
            ref[m * kN + n] = static_cast<std::int32_t>(bits);
        }
    return ref;
}

template <class Trait>
__device__ typename Trait::AFrag
    load_sparse_a_frag(const std::int32_t* A, const std::int32_t* p0, const std::int32_t* p1, int lane)
{
    typename Trait::AFrag frag = make_zero_frag<typename Trait::AFrag>();
    std::uint32_t         words[Trait::AWords]{};
    const int             row  = lane & 15;
    const int             block =
        lane_k_block(lane, Trait::Groups / Trait::GroupsPerLane);
    if(block < 0)
        return frag;
    for(int local_g = 0; local_g < Trait::GroupsPerLane; ++local_g)
    {
        const int g      = block * Trait::GroupsPerLane + local_g;
        const int first  = p0[row * Trait::Groups + g];
        const int second = p1[row * Trait::Groups + g];
        const int k0     = 4 * g + first;
        const int k1     = 4 * g + second;
        const std::uint32_t field = packed_bits(A[row * Trait::K + k0], Trait::Bits)
                                    | (packed_bits(A[row * Trait::K + k1], Trait::Bits)
                                       << Trait::Bits);
        const int bit_offset = local_g * Trait::SparseGroupBits;
        words[bit_offset / 32] |= field << (bit_offset % 32);
    }
    for(int word = 0; word < Trait::AWords; ++word)
        set_frag_word(frag, word, words[word]);
    return frag;
}

template <class Trait>
__device__ typename Trait::BFrag load_sparse_b_frag(const std::int32_t* B, int lane)
{
    typename Trait::BFrag frag = make_zero_frag<typename Trait::BFrag>();
    std::uint32_t         words[Trait::BWords]{};
    const int             col  = lane & 15;
    const int             block =
        lane_k_block(lane, Trait::K / Trait::BValuesPerLane);
    if(block < 0)
        return frag;
    for(int idx = 0; idx < Trait::BValuesPerLane; ++idx)
    {
        const int k     = block * Trait::BValuesPerLane + idx;
        const int word  = idx / Trait::ValuesPerWord;
        const int shift = (idx % Trait::ValuesPerWord) * Trait::Bits;
        words[word] |= packed_bits(B[k * kN + col], Trait::Bits) << shift;
    }
    for(int word = 0; word < Trait::BWords; ++word)
        set_frag_word(frag, word, words[word]);
    return frag;
}

template <class Trait>
__device__ typename Trait::IndexFrag load_sparse_index(const std::uint32_t* idx, int lane)
{
    typename Trait::IndexFrag frag = make_zero_frag<typename Trait::IndexFrag>();
    for(int word = 0; word < Trait::IndexWords; ++word)
        set_frag_word(frag, word, idx[lane * Trait::IndexWords + word]);
    return frag;
}

template <class Trait>
__global__ void sparse_matrix_kernel(const std::int32_t*  A,
                                     const std::int32_t*  B,
                                     const std::int32_t*  C,
                                     const std::int32_t*  p0,
                                     const std::int32_t*  p1,
                                     const std::uint32_t* idx,
                                     std::int32_t*        D)
{
    const int lane = threadIdx.x;
    auto      a    = load_sparse_a_frag<Trait>(A, p0, p1, lane);
    auto      b    = load_sparse_b_frag<Trait>(B, lane);
    auto      c    = load_c_frag<Trait>(C, lane);
    auto      index = load_sparse_index<Trait>(idx, lane);
    store_d_frag<Trait>(Trait::call(a, b, c, index), D, lane);
}

template <class Trait>
void run_sparse_matrix_case(int seed)
{
    SparseData<Trait>         data = make_sparse_inputs<Trait>(seed);
    std::vector<std::int32_t> ref  = sparse_reference<Trait>(data);
    auto                      dA   = to_device(data.A);
    auto                      dB   = to_device(data.B);
    auto                      dC   = to_device(data.C);
    auto                      dP0  = to_device(data.p0);
    auto                      dP1  = to_device(data.p1);
    auto                      dIdx = to_device(data.idx);
    if(!dA || !dB || !dC || !dP0 || !dP1 || !dIdx)
        FAIL() << "failed to initialize sparse matrix inputs on device";

    auto dD = allocate_device<std::int32_t>(ref.size());
    if(!dD)
        return;

    sparse_matrix_kernel<Trait><<<1, kWaveLanes>>>(
        dA.get(), dB.get(), dC.get(), dP0.get(), dP1.get(), dIdx.get(), dD.get());
    HIP_CHECK(hipGetLastError());
    HIP_CHECK(hipDeviceSynchronize());

    std::vector<std::int32_t> got(ref.size());
    HIP_CHECK(hipMemcpy(
        got.data(), dD.get(), got.size() * sizeof(std::int32_t), hipMemcpyDeviceToHost));
    for(std::size_t i = 0; i < ref.size(); ++i)
        EXPECT_EQ(static_cast<std::uint32_t>(got[i]), static_cast<std::uint32_t>(ref[i]))
            << Trait::Name << " asigned=" << Trait::ASigned << " bsigned=" << Trait::BSigned
            << " clamp=" << Trait::Clamp << " element " << i;
}

template <template <bool, bool, bool> class Trait>
void run_dense_matrix_modes(int seed)
{
    run_dense_matrix_case<Trait<false, false, false>>(seed + 0);
    run_dense_matrix_case<Trait<false, false, true>>(seed + 1);
    run_dense_matrix_case<Trait<false, true, false>>(seed + 2);
    run_dense_matrix_case<Trait<false, true, true>>(seed + 3);
    run_dense_matrix_case<Trait<true, false, false>>(seed + 4);
    run_dense_matrix_case<Trait<true, false, true>>(seed + 5);
    run_dense_matrix_case<Trait<true, true, false>>(seed + 6);
    run_dense_matrix_case<Trait<true, true, true>>(seed + 7);
}

template <template <bool, bool, bool> class Trait>
void run_sparse_matrix_modes(int seed)
{
    run_sparse_matrix_case<Trait<false, false, false>>(seed + 0);
    run_sparse_matrix_case<Trait<false, false, true>>(seed + 1);
    run_sparse_matrix_case<Trait<false, true, false>>(seed + 2);
    run_sparse_matrix_case<Trait<false, true, true>>(seed + 3);
    run_sparse_matrix_case<Trait<true, false, false>>(seed + 4);
    run_sparse_matrix_case<Trait<true, false, true>>(seed + 5);
    run_sparse_matrix_case<Trait<true, true, false>>(seed + 6);
    run_sparse_matrix_case<Trait<true, true, true>>(seed + 7);
}
} // namespace
