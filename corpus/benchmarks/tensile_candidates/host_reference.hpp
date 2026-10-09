// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
#pragma once

#include <Tensile/DataTypes.hpp>
#include <mxDataGenerator/PreSwizzle.hpp>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <stdexcept>
#include <string>
#include <vector>

namespace candidate {
inline uint16_t bf16(float value) {
    uint32_t bits;
    std::memcpy(&bits, &value, sizeof(bits));
    return (bits + 0x7fff + ((bits >> 16) & 1)) >> 16;
}
inline float fp32(uint16_t value) {
    uint32_t bits = uint32_t(value) << 16;
    float result;
    std::memcpy(&result, &bits, sizeof(result));
    return result;
}
inline float sign(size_t index) {
    return index % 2 ? -1.0f : 1.0f;
}
inline float mx_a_reduction_factor(size_t l) {
    return l % 3 ? 1.0f : 2.0f;
}
inline float mx_b_reduction_factor(size_t l) {
    return l % 5 ? 1.0f : 2.0f;
}
inline float mx_a_free_factor(size_t i) {
    return sign(i) * (i % 3 ? 1.0f : 0.5f);
}
inline float mx_b_free_factor(size_t j) {
    return sign(j) * (j % 5 ? 1.0f : 0.5f);
}
inline float mx_a_scale(size_t i, size_t q) {
    return std::ldexp(1.0f, -int(i % 2) - int((q % 7) % 2));
}
inline float mx_b_scale(size_t j, size_t q) {
    return std::ldexp(1.0f, -int(j % 3) - int((q % 11) % 2));
}
inline float bf16_a_free_factor(size_t i) {
    return sign(i) * std::ldexp(1.0f, int(i % 5) - 2);
}
inline float bf16_b_free_factor(size_t j) {
    return sign(j) * std::ldexp(1.0f, int(j % 7) - 3);
}

inline std::vector<uint8_t> packScales(const std::vector<uint8_t> &canonical, size_t freeDim,
                                       size_t kBlocks, int format) {
    if (format == 1)
        return DGen::preSwizzleScalesGFX950(canonical, {freeDim, kBlocks});
    if (format == 2)
        return DGen::preSwizzleScalesGFX1250(canonical, freeDim, kBlocks, 32);
    throw std::invalid_argument("unsupported MX scale format");
}

struct HostReference {
    size_t m, n, k, kBlocks;
    bool mx, fp4, transA, transB;
    float beta;
    double innerSum = 0;
    std::vector<uint8_t> a, b, c, canonicalScaleA, canonicalScaleB, scaleA, scaleB;

    HostReference(const std::string &variant, size_t rows, size_t columns, size_t depth,
                  int scaleFormat = 0)
        : m(rows), n(columns), k(depth), kBlocks((k + 31) / 32),
          mx(variant == "mxfp8_subtile" || variant == "mxfp4_streamk"),
          fp4(variant == "mxfp4_streamk"), transA(variant != "bf16_streamk"), transB(!transA),
          beta((variant == "bf16_streamk" || fp4) ? 1.0f : 0.0f) {
        if (!mx && variant != "bf16_subtile" && variant != "bf16_streamk")
            throw std::invalid_argument("unknown native candidate");
        if (!m || !n || !k || m > 65536 || n > 65536 || k > 65536)
            throw std::invalid_argument("invalid candidate dimensions");
        if (mx && k % 32)
            throw std::invalid_argument("MX candidates require K divisible by 32");
        a.resize(m * k * (mx ? 1 : 2) / (fp4 ? 2 : 1));
        b.resize(n * k * (mx ? 1 : 2) / (fp4 ? 2 : 1));
        c.resize(m * n * (fp4 ? 4 : 2));
        for (size_t l = 0; l < k; ++l) {
            // All K products are positive and exactly representable. The powers of two
            // in free-axis factors preserve exact FP32 accumulation even at maximum K.
            innerSum += mx ? double(mx_a_reduction_factor(l)) * mx_b_reduction_factor(l) *
                                 mx_a_scale(0, l / 32) * mx_b_scale(0, l / 32)
                           : double(l % 7 + 1) * (l % 5 + 1) / 256.0;
            for (size_t i = 0; i < m; ++i)
                putInput(a, aIndex(i, l),
                         mx ? mx_a_free_factor(i) * mx_a_reduction_factor(l)
                            : bf16_a_free_factor(i) * float(l % 7 + 1) / 16.0f);
            for (size_t j = 0; j < n; ++j)
                putInput(b, bIndex(j, l),
                         mx ? mx_b_free_factor(j) * mx_b_reduction_factor(l)
                            : bf16_b_free_factor(j) * float(l % 5 + 1) / 16.0f);
        }
        for (size_t index = 0; index < m * n; ++index)
            putOutput(c, index, (int(index % 7) - 3) / 16.0f);
        if (mx) {
            canonicalScaleA.resize(m * kBlocks);
            canonicalScaleB.resize(n * kBlocks);
            for (size_t i = 0; i < m; ++i)
                for (size_t q = 0; q < kBlocks; ++q)
                    canonicalScaleA[i * kBlocks + q] = TensileLite::E8(mx_a_scale(i, q)).data;
            for (size_t j = 0; j < n; ++j)
                for (size_t q = 0; q < kBlocks; ++q)
                    canonicalScaleB[j * kBlocks + q] = TensileLite::E8(mx_b_scale(j, q)).data;
            scaleA = packScales(canonicalScaleA, m, kBlocks, scaleFormat);
            scaleB = packScales(canonicalScaleB, n, kBlocks, scaleFormat);
        }
    }
    size_t aIndex(size_t i, size_t l) const {
        return transA ? i * k + l : l * m + i;
    }
    size_t bIndex(size_t j, size_t l) const {
        return transB ? l * n + j : j * k + l;
    }
    void putInput(std::vector<uint8_t> &data, size_t index, float value) const {
        if (fp4) {
            // Pair construction and extraction use the pinned upstream FP4 conversion.
            TensileLite::Float4x2 pair;
            pair.data = data[index / 2];
            pair = index % 2 ? TensileLite::Float4x2(pair.getElement(0), value)
                             : TensileLite::Float4x2(value, pair.getElement(1));
            data[index / 2] = pair.data;
        } else if (mx) {
            const auto packed = TensileLite::Float8(value);
            static_assert(sizeof(packed) == 1);
            std::memcpy(data.data() + index, &packed, 1);
        } else {
            const auto packed = bf16(value);
            std::memcpy(data.data() + 2 * index, &packed, 2);
        }
    }
    float input(const std::vector<uint8_t> &data, size_t index) const {
        if (fp4) {
            TensileLite::Float4x2 pair;
            pair.data = data[index / 2];
            return pair.getElement(index % 2);
        }
        if (mx) {
            TensileLite::Float8 value;
            std::memcpy(&value, data.data() + index, 1);
            return float(value);
        }
        uint16_t value;
        std::memcpy(&value, data.data() + 2 * index, 2);
        return fp32(value);
    }
    void putOutput(std::vector<uint8_t> &data, size_t index, float value) const {
        if (fp4)
            std::memcpy(data.data() + 4 * index, &value, 4);
        else {
            const auto packed = bf16(value);
            std::memcpy(data.data() + 2 * index, &packed, 2);
        }
    }
    float output(const std::vector<uint8_t> &data, size_t index) const {
        if (fp4) {
            float value;
            std::memcpy(&value, data.data() + 4 * index, 4);
            return value;
        }
        uint16_t value;
        std::memcpy(&value, data.data() + 2 * index, 2);
        return fp32(value);
    }
    float expected(size_t i, size_t j) const {
        const double outer = mx ? double(mx_a_free_factor(i)) * mx_b_free_factor(j) *
                                      std::ldexp(1.0, -int(i % 2) - int(j % 3))
                                : double(bf16_a_free_factor(i)) * bf16_b_free_factor(j);
        const float reference = float(outer * innerSum) + beta * output(c, j * m + i);
        return fp4 ? reference : fp32(bf16(reference));
    }
    void validate(const std::vector<uint8_t> &result) const {
        if (result.size() != c.size())
            throw std::runtime_error("invalid GEMM output byte count");
        for (size_t j = 0; j < n; ++j)
            for (size_t i = 0; i < m; ++i) {
                const size_t index = j * m + i;
                const float actual = output(result, index), reference = expected(i, j);
                if (!std::isfinite(actual) || actual != reference)
                    throw std::runtime_error("GEMM mismatch at " + std::to_string(index) +
                                             ": expected " + std::to_string(reference) +
                                             ", actual " + std::to_string(actual));
            }
    }
    const char *pattern() const {
        return mx ? "separable_varying_block_mx_v1" : "separable_positive_k_bf16_v1";
    }
};
} // namespace candidate
