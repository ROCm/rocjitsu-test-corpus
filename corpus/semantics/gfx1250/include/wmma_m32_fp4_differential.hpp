#pragma once

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <vector>

namespace wmma_m32_fp4 {

constexpr int lanes = 32;
constexpr int matrix_regs = 16;
constexpr int columns = 16;
constexpr int neutral_scale_word = 0x7f7f7f7f;
// Preserve this ordering: each FP4 encoding matches its value, and the
// intended weighted sum has no collision among permutations of the first four
// entries (regular Scale) or all eight entries (Scale16).
inline constexpr std::array<uint32_t, 8> scale_probe_fp4 = {
    0x1, 0x3, 0x9, 0x2, 0x4, 0x5, 0x6, 0x7};
inline constexpr std::array<float, 8> scale_probe_values = {
    0.5f, 1.5f, -0.5f, 1.0f, 2.0f, 3.0f, 4.0f, 6.0f};

__host__ __device__ inline int dbt_row(int lane, int reg) {
  return (reg / 8) * 16 + (lane / 16) * 8 + reg % 8;
}

inline int packed_slot(int k) {
  const int reg = ((k >> 1) & 1) + 2 * ((k >> 3) & 1) +
                  4 * ((k >> 4) & 1) + 8 * ((k >> 5) & 1) +
                  16 * ((k >> 6) & 1);
  return 2 * reg + (k & 1);
}

inline void set_nibble(std::vector<int> &words, int lane, int reg, int slot,
                       uint32_t value) {
  const int shift = 4 * (slot % 8);
  uint32_t word = static_cast<uint32_t>(words[lane * matrix_regs + reg]);
  word = (word & ~(UINT32_C(0xf) << shift)) | ((value & 0xfu) << shift);
  words[lane * matrix_regs + reg] = static_cast<int>(word);
}

inline void set_a(std::vector<int> &words, int row, int k, uint32_t value) {
  const int local_row = row % 16;
  const int lane = local_row + 16 * ((k >> 2) & 1);
  const int slot = packed_slot(k);
  set_nibble(words, lane, (row / 16) * 8 + slot / 8, slot, value);
}

inline void set_b(std::vector<int> &words, int col, int k, uint32_t value) {
  const int lane = col + 16 * ((k >> 2) & 1);
  const int slot = packed_slot(k);
  set_nibble(words, lane, slot / 8, slot, value);
}

inline void make_row_fingerprint_inputs(std::vector<int> &a,
                                        std::vector<int> &b) {
  std::fill(a.begin(), a.end(), 0);
  std::fill(b.begin(), b.end(), 0);
  for (int block = 0; block < 4; ++block) {
    const int base_k = 32 * block;
    for (int row = 0; row < 32; ++row)
      for (int offset = 0; offset <= row; ++offset)
        set_a(a, row, base_k + offset, 0x2); // FP4 1.0
    for (int col = 0; col < columns; ++col)
      for (int offset = 0; offset <= col; ++offset)
        set_b(b, col, base_k + offset, 0x2); // FP4 1.0
  }
}

inline int scale_byte_for_k(int k, int scale_bytes) {
  if (scale_bytes == 4)
    return 2 * (k >> 6) + ((k >> 2) & 1);
  return 4 * (k >> 6) + 2 * ((k >> 2) & 1) + ((k >> 5) & 1);
}

// This dense probe exercises every K position and fingerprints aggregate
// scale-byte-group behavior. Positions in the same expected byte group share
// a value, so compensating position-level remaps and common A/B permutations
// within a group are intentionally outside this oracle's coverage.
inline void make_scale_probe_inputs(std::vector<int> &a,
                                    std::vector<int> &b, int scale_bytes) {
  std::fill(a.begin(), a.end(), 0);
  std::fill(b.begin(), b.end(), 0);
  for (int k = 0; k < 128; ++k) {
    const int byte = scale_byte_for_k(k, scale_bytes);
    for (int row = 0; row < 32; ++row)
      set_a(a, row, k, scale_probe_fp4[byte]);
    for (int col = 0; col < columns; ++col)
      set_b(b, col, k, 0x2); // FP4 1.0
  }
}

inline std::vector<float> row_fingerprint_expected() {
  std::vector<float> expected(lanes * matrix_regs);
  for (int lane = 0; lane < lanes; ++lane) {
    for (int reg = 0; reg < matrix_regs; ++reg) {
      const int row = dbt_row(lane, reg);
      const int col = lane % columns;
      const int products_per_block = std::min(row + 1, col + 1);
      expected[lane * matrix_regs + reg] =
          static_cast<float>(4096 + 256 * row + 4 * products_per_block);
    }
  }
  return expected;
}

inline std::vector<float> scale_probe_expected(int scale_bytes, bool matrix_a) {
  std::vector<float> expected(lanes * matrix_regs);
  float byte_sum = 0.0f;
  for (int byte = 0; byte < scale_bytes; ++byte)
    byte_sum += std::ldexp(scale_probe_values[byte], byte);
  byte_sum *= 128 / scale_bytes;
  for (int lane = 0; lane < lanes; ++lane) {
    for (int reg = 0; reg < matrix_regs; ++reg) {
      const int row = dbt_row(lane, reg);
      const int col = lane % columns;
      const int exponent = matrix_a ? row - 16 : col - 8;
      expected[lane * matrix_regs + reg] = std::ldexp(byte_sum, exponent);
    }
  }
  return expected;
}

__host__ __device__ inline int scale_word_for_lane(int lane, int exponent_bias,
                                                   int first_byte = 0) {
  uint32_t word = 0;
  for (int byte = 0; byte < 4; ++byte) {
    const uint32_t raw =
        static_cast<uint32_t>(0x7f + lane + exponent_bias + first_byte + byte);
    word |= raw << (8 * byte);
  }
  return static_cast<int>(word);
}

} // namespace wmma_m32_fp4
