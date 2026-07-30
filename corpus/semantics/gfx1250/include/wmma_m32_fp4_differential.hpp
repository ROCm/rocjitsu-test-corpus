#pragma once

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <vector>

namespace wmma_m32_fp4 {

constexpr int lanes = 32;
constexpr int matrix_regs = 16;
constexpr int columns = 16;
constexpr int neutral_scale_word = 0x7f7f7f7f;

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
  for (int row = 0; row < 32; ++row)
    for (int k = 0; k <= row; ++k)
      set_a(a, row, k, 0x2); // FP4 1.0
  for (int col = 0; col < columns; ++col)
    for (int k = 0; k < 32; ++k)
      set_b(b, col, k, 0x2); // FP4 1.0
}

inline void make_scale_probe_inputs(std::vector<int> &a,
                                    std::vector<int> &b) {
  std::fill(a.begin(), a.end(), 0);
  std::fill(b.begin(), b.end(), 0);
  for (int row = 0; row < 32; ++row)
    set_a(a, row, 0, 0x2);
  for (int col = 0; col < columns; ++col)
    set_b(b, col, 0, 0x2);
}

inline std::vector<float> row_fingerprint_expected() {
  std::vector<float> expected(lanes * matrix_regs);
  for (int lane = 0; lane < lanes; ++lane) {
    for (int reg = 0; reg < matrix_regs; ++reg) {
      const int row = dbt_row(lane, reg);
      const int col = lane % columns;
      expected[lane * matrix_regs + reg] =
          static_cast<float>(1024 + 32 * row + col + row + 1);
    }
  }
  return expected;
}

inline std::vector<float> scale_probe_expected() {
  std::vector<float> expected(lanes * matrix_regs);
  for (int lane = 0; lane < lanes; ++lane)
    for (int reg = 0; reg < matrix_regs; ++reg)
      expected[lane * matrix_regs + reg] =
          std::ldexp(1.0f, dbt_row(lane, reg) - 16);
  return expected;
}

__host__ __device__ inline int scale_word_for_lane(int lane) {
  const uint32_t raw = static_cast<uint32_t>(0x7f + lane - 16);
  return static_cast<int>(UINT32_C(0x7f7f7f00) | raw);
}

} // namespace wmma_m32_fp4
