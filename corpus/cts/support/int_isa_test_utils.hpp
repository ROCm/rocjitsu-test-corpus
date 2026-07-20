// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#ifndef ROCJITSU_CTS_SUPPORT_INT_ISA_TEST_UTILS_HPP
#define ROCJITSU_CTS_SUPPORT_INT_ISA_TEST_UTILS_HPP

#include <cmath>
#include <cstdint>

namespace int_isa_test
{
// Packed-field helpers used by the host oracle. These operate on plain integer
// bits so the oracle does not depend on compiler AMDGPU builtins.
constexpr std::uint32_t low_mask(unsigned width)
{
    return width >= 32 ? 0xffffffffu : ((1u << width) - 1u);
}

constexpr std::uint8_t byte32(std::uint32_t value, unsigned index)
{
    return static_cast<std::uint8_t>((value >> (index * 8)) & 0xffu);
}

constexpr std::uint8_t byte64(std::uint64_t value, unsigned index)
{
    return static_cast<std::uint8_t>((value >> (index * 8)) & 0xffu);
}

constexpr std::uint8_t nibble32(std::uint32_t value, unsigned index)
{
    return static_cast<std::uint8_t>((value >> (index * 4)) & 0xfu);
}

constexpr std::int32_t i8_lane(std::uint32_t value, unsigned index)
{
    const std::uint32_t lane = byte32(value, index);
    return (lane & 0x80u) != 0 ? static_cast<std::int32_t>(lane) - 0x100
                               : static_cast<std::int32_t>(lane);
}

constexpr std::int32_t i4_lane(std::uint32_t value, unsigned index)
{
    const std::uint32_t lane = nibble32(value, index);
    return (lane & 0x8u) != 0 ? static_cast<std::int32_t>(lane) - 0x10
                              : static_cast<std::int32_t>(lane);
}

constexpr std::uint16_t half32(std::uint32_t value, unsigned index)
{
    return static_cast<std::uint16_t>((value >> (index * 16)) & 0xffffu);
}

constexpr std::uint16_t half64(std::uint64_t value, unsigned index)
{
    return static_cast<std::uint16_t>((value >> (index * 16)) & 0xffffu);
}

constexpr std::int32_t i16_lane(std::uint32_t value, unsigned index)
{
    const std::uint32_t lane = half32(value, index);
    return (lane & 0x8000u) != 0 ? static_cast<std::int32_t>(lane) - 0x10000
                                 : static_cast<std::int32_t>(lane);
}

constexpr std::uint32_t pack_u16_pair(std::uint32_t lane0, std::uint32_t lane1)
{
    return (lane0 & 0xffffu) | ((lane1 & 0xffffu) << 16);
}

constexpr std::uint32_t pack_i16_pair(std::int32_t lane0, std::int32_t lane1)
{
    return pack_u16_pair(static_cast<std::uint32_t>(lane0),
                         static_cast<std::uint32_t>(lane1));
}

constexpr std::uint32_t cvt_i16_lane_bits(std::int32_t value)
{
    if(value > 32767)
        return 0x7fffu;
    if(value < -32768)
        return 0x8000u;
    return static_cast<std::uint32_t>(value) & 0xffffu;
}

constexpr std::uint32_t cvt_u16_lane_bits(std::uint32_t value)
{
    return value > 0xffffu ? 0xffffu : value;
}

constexpr std::uint32_t cvt_pk_i16_pair(std::int32_t lane0, std::int32_t lane1)
{
    return pack_u16_pair(cvt_i16_lane_bits(lane0), cvt_i16_lane_bits(lane1));
}

constexpr std::uint32_t cvt_pk_u16_pair(std::uint32_t lane0, std::uint32_t lane1)
{
    return pack_u16_pair(cvt_u16_lane_bits(lane0), cvt_u16_lane_bits(lane1));
}

constexpr std::uint32_t alignbit_u32(std::uint32_t src0,
                                     std::uint32_t src1,
                                     std::uint32_t bit_offset)
{
    const std::uint64_t joined = (static_cast<std::uint64_t>(src0) << 32) | src1;
    return static_cast<std::uint32_t>(joined >> (bit_offset & 31u));
}

constexpr std::uint32_t alignbyte_u32(std::uint32_t src0,
                                      std::uint32_t src1,
                                      std::uint32_t byte_offset)
{
    const std::uint64_t joined = (static_cast<std::uint64_t>(src0) << 32) | src1;
    return static_cast<std::uint32_t>(joined >> ((byte_offset & 3u) * 8u));
}

constexpr std::uint8_t perm_selector_byte(std::uint32_t src0,
                                          std::uint32_t src1,
                                          std::uint8_t  selector)
{
    // V_PERM_B32 views the 64-bit source as src0:src1. Selector values 0..7
    // address source bytes. Selectors 8..11 sign-extend source bytes
    // 1, 3, 5, and 7 respectively; 12 pads with zero; 13 and above pad with
    // one bits.
    if(selector < 4)
        return byte32(src1, selector);
    if(selector < 8)
        return byte32(src0, selector - 4);
    if(selector < 12)
    {
        const unsigned source_byte = 1u + 2u * static_cast<unsigned>(selector - 8);
        const std::uint8_t value =
            source_byte < 4 ? byte32(src1, source_byte) : byte32(src0, source_byte - 4);
        return (value & 0x80u) != 0 ? 0xffu : 0x00u;
    }
    if(selector == 12)
        return 0x00u;
    return 0xffu;
}

constexpr std::uint32_t perm_b32(std::uint32_t src0, std::uint32_t src1, std::uint32_t selector)
{
    std::uint32_t out = 0;
    for(unsigned lane = 0; lane < 4; ++lane)
        out |= static_cast<std::uint32_t>(
                   perm_selector_byte(src0, src1, byte32(selector, lane)))
               << (lane * 8);
    return out;
}

constexpr std::uint32_t mbcnt_lo_u32(std::uint32_t mask, std::uint32_t add, unsigned lane)
{
    const std::uint32_t lower = lane == 0 ? 0u : low_mask(lane);
    return add + static_cast<std::uint32_t>(__builtin_popcount(mask & lower));
}

constexpr std::uint32_t mbcnt_hi_u32(std::uint32_t mask, std::uint32_t add, unsigned lane)
{
    if(lane < 32)
        return add;
    return add + static_cast<std::uint32_t>(__builtin_popcount(mask & low_mask(lane - 32)));
}

inline std::uint32_t round_clamp_u32(float value, float lo, float hi)
{
    if(std::isnan(value))
        value = lo;
    if(value < lo)
        value = lo;
    if(value > hi)
        value = hi;
    return static_cast<std::uint32_t>(std::nearbyint(value));
}

inline std::uint32_t cvt_pknorm_i16_lane_bits(float value)
{
    if(std::isnan(value))
        value = 0.0f;
    if(value < -1.0f)
        value = -1.0f;
    if(value > 1.0f)
        value = 1.0f;
    const int rounded = static_cast<int>(std::nearbyint(value * 32767.0f));
    return cvt_i16_lane_bits(rounded);
}

inline std::uint32_t cvt_pknorm_u16_lane_bits(float value)
{
    if(std::isnan(value))
        value = 0.0f;
    if(value < 0.0f)
        value = 0.0f;
    if(value > 1.0f)
        value = 1.0f;
    return cvt_u16_lane_bits(static_cast<std::uint32_t>(std::nearbyint(value * 65535.0f)));
}

inline std::uint32_t cvt_pknorm_i16_pair(float lo, float hi)
{
    return pack_u16_pair(cvt_pknorm_i16_lane_bits(lo), cvt_pknorm_i16_lane_bits(hi));
}

inline std::uint32_t cvt_pknorm_u16_pair(float lo, float hi)
{
    return pack_u16_pair(cvt_pknorm_u16_lane_bits(lo), cvt_pknorm_u16_lane_bits(hi));
}

inline std::uint32_t cvt_pk_u8_f32(float value, std::uint32_t byte_select, std::uint32_t src)
{
    const std::uint32_t packed =
        round_clamp_u32(value, 0.0f, 255.0f) & 0xffu;
    const unsigned lane = byte_select & 3u;
    const std::uint32_t mask = 0xffu << (lane * 8);
    return (src & ~mask) | (packed << (lane * 8));
}

// RDNA4 BFE reads offset and width from five-bit operand fields. Signed
// extraction returns the raw two's-complement result bits.
constexpr std::uint32_t bfe_u32(std::uint32_t value, unsigned offset, unsigned width)
{
    offset &= 31u;
    width &= 31u;
    if(width == 0)
        return 0;
    const std::uint32_t shifted = value >> offset;
    return shifted & low_mask(width);
}

constexpr std::uint32_t bfe_i32_bits(std::uint32_t value, unsigned offset, unsigned width)
{
    offset &= 31u;
    width &= 31u;
    if(width == 0)
        return 0;
    const std::uint32_t field = bfe_u32(value, offset, width);
    const std::uint32_t sign = 1u << (width - 1);
    return (field & sign) != 0 ? (field | ~low_mask(width)) : field;
}

// Byte interpolation and SAD-style helpers mirror the instruction descriptions:
// operate per packed lane, accumulate absolute differences, then let the caller
// add or pack the instruction-specific accumulator.
constexpr std::uint32_t lerp_u8(std::uint32_t a, std::uint32_t b, std::uint32_t rounding)
{
    std::uint32_t out = 0;
    for(unsigned i = 0; i < 4; ++i)
    {
        const std::uint32_t sum = byte32(a, i) + byte32(b, i) + (byte32(rounding, i) & 1u);
        out |= ((sum >> 1) & 0xffu) << (i * 8);
    }
    return out;
}

constexpr std::uint32_t abs_diff_u8(std::uint8_t a, std::uint8_t b)
{
    return a > b ? static_cast<std::uint32_t>(a - b) : static_cast<std::uint32_t>(b - a);
}

constexpr std::uint32_t abs_diff_u16(std::uint16_t a, std::uint16_t b)
{
    return a > b ? static_cast<std::uint32_t>(a - b) : static_cast<std::uint32_t>(b - a);
}

constexpr std::uint32_t sad_u8_sum(std::uint32_t a, std::uint32_t b)
{
    std::uint32_t sum = 0;
    for(unsigned i = 0; i < 4; ++i)
        sum += abs_diff_u8(byte32(a, i), byte32(b, i));
    return sum;
}

constexpr std::uint32_t msad_u8_sum(std::uint32_t a, std::uint32_t reference)
{
    std::uint32_t sum = 0;
    for(unsigned i = 0; i < 4; ++i)
    {
        const std::uint8_t ref = byte32(reference, i);
        if(ref != 0)
            sum += abs_diff_u8(byte32(a, i), ref);
    }
    return sum;
}

constexpr std::uint32_t sad_u16_sum(std::uint32_t a, std::uint32_t b)
{
    return abs_diff_u16(half32(a, 0), half32(b, 0)) + abs_diff_u16(half32(a, 1), half32(b, 1));
}

constexpr std::uint32_t clamp_u32(std::uint64_t value)
{
    return value > 0xffffffffull ? 0xffffffffu : static_cast<std::uint32_t>(value);
}

constexpr std::uint32_t clamp_i32_bits(std::int64_t value)
{
    constexpr std::int64_t kI32Max = 2147483647ll;
    constexpr std::int64_t kI32Min = -2147483647ll - 1ll;
    if(value > kI32Max)
        return 0x7fffffffu;
    if(value < kI32Min)
        return 0x80000000u;
    return static_cast<std::uint32_t>(value);
}

constexpr std::uint32_t dot_u8x4(std::uint32_t a,
                                 std::uint32_t b,
                                 std::uint32_t accum,
                                 bool          clamp)
{
    std::uint64_t sum = accum;
    for(unsigned i = 0; i < 4; ++i)
        sum += static_cast<std::uint32_t>(byte32(a, i)) * byte32(b, i);
    return clamp ? clamp_u32(sum) : static_cast<std::uint32_t>(sum);
}

constexpr std::uint32_t dot_iu8x4_bits(std::uint32_t a,
                                       bool          a_signed,
                                       std::uint32_t b,
                                       bool          b_signed,
                                       std::int32_t  accum,
                                       bool          clamp)
{
    std::int64_t sum = accum;
    for(unsigned i = 0; i < 4; ++i)
    {
        const std::int32_t lhs = a_signed ? i8_lane(a, i) : byte32(a, i);
        const std::int32_t rhs = b_signed ? i8_lane(b, i) : byte32(b, i);
        sum += static_cast<std::int64_t>(lhs) * rhs;
    }
    return clamp ? clamp_i32_bits(sum) : static_cast<std::uint32_t>(sum);
}

constexpr std::uint32_t dot_u4x8(std::uint32_t a,
                                 std::uint32_t b,
                                 std::uint32_t accum,
                                 bool          clamp)
{
    std::uint64_t sum = accum;
    for(unsigned i = 0; i < 8; ++i)
        sum += static_cast<std::uint32_t>(nibble32(a, i)) * nibble32(b, i);
    return clamp ? clamp_u32(sum) : static_cast<std::uint32_t>(sum);
}

constexpr std::uint32_t dot_iu4x8_bits(std::uint32_t a,
                                       bool          a_signed,
                                       std::uint32_t b,
                                       bool          b_signed,
                                       std::int32_t  accum,
                                       bool          clamp)
{
    std::int64_t sum = accum;
    for(unsigned i = 0; i < 8; ++i)
    {
        const std::int32_t lhs = a_signed ? i4_lane(a, i) : nibble32(a, i);
        const std::int32_t rhs = b_signed ? i4_lane(b, i) : nibble32(b, i);
        sum += static_cast<std::int64_t>(lhs) * rhs;
    }
    return clamp ? clamp_i32_bits(sum) : static_cast<std::uint32_t>(sum);
}

// QSAD/MQSAD compare a four-byte reference against sliding four-byte windows in
// the 64-bit source. The packed variants store four accumulated 16-bit lanes.
constexpr std::uint32_t qsad_u8_window_sum(std::uint64_t a, std::uint32_t b, unsigned window)
{
    std::uint32_t sum = 0;
    for(unsigned i = 0; i < 4; ++i)
        sum += abs_diff_u8(byte64(a, window + i), byte32(b, i));
    return sum;
}

constexpr std::uint32_t mqsad_u8_window_sum(std::uint64_t a, std::uint32_t reference, unsigned window)
{
    std::uint32_t sum = 0;
    for(unsigned i = 0; i < 4; ++i)
    {
        const std::uint8_t ref = byte32(reference, i);
        if(ref != 0)
            sum += abs_diff_u8(byte64(a, window + i), ref);
    }
    return sum;
}

constexpr std::uint64_t pack_u16_lanes(std::uint32_t lane0,
                                       std::uint32_t lane1,
                                       std::uint32_t lane2,
                                       std::uint32_t lane3)
{
    return (static_cast<std::uint64_t>(lane0 & 0xffffu) << 0)
           | (static_cast<std::uint64_t>(lane1 & 0xffffu) << 16)
           | (static_cast<std::uint64_t>(lane2 & 0xffffu) << 32)
           | (static_cast<std::uint64_t>(lane3 & 0xffffu) << 48);
}

constexpr std::uint64_t qsad_pk_u16_u8(std::uint64_t a, std::uint32_t b, std::uint64_t accum)
{
    return pack_u16_lanes(qsad_u8_window_sum(a, b, 0) + half64(accum, 0),
                          qsad_u8_window_sum(a, b, 1) + half64(accum, 1),
                          qsad_u8_window_sum(a, b, 2) + half64(accum, 2),
                          qsad_u8_window_sum(a, b, 3) + half64(accum, 3));
}

constexpr std::uint64_t mqsad_pk_u16_u8(std::uint64_t a, std::uint32_t b, std::uint64_t accum)
{
    return pack_u16_lanes(mqsad_u8_window_sum(a, b, 0) + half64(accum, 0),
                          mqsad_u8_window_sum(a, b, 1) + half64(accum, 1),
                          mqsad_u8_window_sum(a, b, 2) + half64(accum, 2),
                          mqsad_u8_window_sum(a, b, 3) + half64(accum, 3));
}
} // namespace int_isa_test

#endif // ROCJITSU_CTS_SUPPORT_INT_ISA_TEST_UTILS_HPP
