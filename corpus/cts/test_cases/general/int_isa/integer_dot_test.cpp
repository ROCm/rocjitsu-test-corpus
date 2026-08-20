// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT

#include "int_isa_test_utils.hpp"
#include "value_test_harness.hpp"

#include <cstdint>
#include <vector>

namespace {
struct DotUnsignedInput {
  std::uint32_t a;
  std::uint32_t b;
  std::uint32_t accum;
};

struct DotSignedInput {
  std::uint32_t a;
  std::uint32_t b;
  std::int32_t accum;
};

template <bool Clamp> struct DotU8Trait {
  using Input = DotUnsignedInput;
  struct Output {
    std::uint32_t result;
  };

  __device__ static Output device(const Input &in) {
    return {static_cast<std::uint32_t>(__builtin_amdgcn_udot4(in.a, in.b, in.accum, Clamp))};
  }

  static Output oracle(const Input &in) {
#if defined(INT_ISA_TEST_DOT4_IGNORES_CLAMP)
    // CDNA5 DOT4 arithmetic is modulo 2^32; the encoded CLAMP bit does not
    // request saturation for V_DOT4_U32_U8 or V_DOT4_I32_IU8.
    constexpr bool OracleClamp = false;
#else
    constexpr bool OracleClamp = Clamp;
#endif
    return {int_isa_test::dot_u8x4(in.a, in.b, in.accum, OracleClamp)};
  }

  static void expect(const Output &actual, const Output &expected, std::size_t case_index) {
    int_isa_test::expect_equal("udot4_result", actual.result, expected.result, case_index);
  }
};

template <bool ASigned, bool BSigned, bool Clamp> struct DotIu8Trait {
  using Input = DotSignedInput;
  struct Output {
    std::uint32_t result_bits;
  };

  __device__ static Output device(const Input &in) {
    return {static_cast<std::uint32_t>(
        __builtin_amdgcn_sudot4(ASigned, in.a, BSigned, in.b, in.accum, Clamp))};
  }

  static Output oracle(const Input &in) {
#if defined(INT_ISA_TEST_DOT4_IGNORES_CLAMP)
    constexpr bool OracleClamp = false;
#else
    constexpr bool OracleClamp = Clamp;
#endif
    return {int_isa_test::dot_iu8x4_bits(in.a, ASigned, in.b, BSigned, in.accum, OracleClamp)};
  }

  static void expect(const Output &actual, const Output &expected, std::size_t case_index) {
    int_isa_test::expect_equal("sudot4_result_bits", actual.result_bits, expected.result_bits,
                               case_index);
  }
};

template <bool Clamp> struct DotU4Trait {
  using Input = DotUnsignedInput;
  struct Output {
    std::uint32_t result;
  };

  __device__ static Output device(const Input &in) {
    return {static_cast<std::uint32_t>(__builtin_amdgcn_udot8(in.a, in.b, in.accum, Clamp))};
  }

  static Output oracle(const Input &in) {
    return {int_isa_test::dot_u4x8(in.a, in.b, in.accum, Clamp)};
  }

  static void expect(const Output &actual, const Output &expected, std::size_t case_index) {
    int_isa_test::expect_equal("udot8_result", actual.result, expected.result, case_index);
  }
};

template <bool ASigned, bool BSigned, bool Clamp> struct DotIu4Trait {
  using Input = DotSignedInput;
  struct Output {
    std::uint32_t result_bits;
  };

  __device__ static Output device(const Input &in) {
    return {static_cast<std::uint32_t>(
        __builtin_amdgcn_sudot8(ASigned, in.a, BSigned, in.b, in.accum, Clamp))};
  }

  static Output oracle(const Input &in) {
    return {int_isa_test::dot_iu4x8_bits(in.a, ASigned, in.b, BSigned, in.accum, Clamp)};
  }

  static void expect(const Output &actual, const Output &expected, std::size_t case_index) {
    int_isa_test::expect_equal("sudot8_result_bits", actual.result_bits, expected.result_bits,
                               case_index);
  }
};

std::vector<DotUnsignedInput> dot_u8_inputs() {
  return {{0x00010203u, 0x04050607u, 0u},
          {0xff00aa55u, 0x0010aa00u, 17u},
          {0xffffffffu, 0x01010101u, 0xffff0000u},
          {0x800000ffu, 0x02030405u, 0x7ffffff0u},
          {0xffffffffu, 0xffffffffu, 0xfffffff0u}};
}

std::vector<DotSignedInput> dot_iu8_inputs() {
  return {{0x00010203u, 0x04050607u, 0},          {0xff00aa55u, 0x0010aa00u, -19},
          {0x807f01ffu, 0x7f80ff01u, 12345},      {0xffffffffu, 0x01010101u, -7},
          {0x80808080u, 0x80808080u, 2147483500}, {0x80808080u, 0xffffffffu, -2147483500}};
}

std::vector<DotUnsignedInput> dot_u4_inputs() {
  return {{0x01234567u, 0x76543210u, 0u},
          {0xffffffffu, 0x11111111u, 123u},
          {0x89abcdefu, 0xfedcba98u, 0x7ffffff0u},
          {0xffffffffu, 0xffffffffu, 0xfffffff0u}};
}

std::vector<DotSignedInput> dot_iu4_inputs() {
  return {{0x01234567u, 0x76543210u, 0},
          {0x89abcdefu, 0xfedcba98u, -17},
          {0x88888888u, 0x88888888u, 2147483500},
          {0x88888888u, 0x77777777u, -2147483500},
          {0xffffffffu, 0x11111111u, 321}};
}
} // namespace

TEST(IntIsaIntegerDot, U8MatchesOracle) {
  if (!have_device())
    GTEST_SKIP() << "no HIP device available";
  int_isa_test::run_value_test_cases<DotU8Trait<false>>(dot_u8_inputs());
  int_isa_test::run_value_test_cases<DotU8Trait<true>>(dot_u8_inputs());
}

TEST(IntIsaIntegerDot, Iu8SignModesMatchOracle) {
  if (!have_device())
    GTEST_SKIP() << "no HIP device available";
  int_isa_test::run_value_test_cases<DotIu8Trait<true, true, false>>(dot_iu8_inputs());
  int_isa_test::run_value_test_cases<DotIu8Trait<true, false, false>>(dot_iu8_inputs());
  int_isa_test::run_value_test_cases<DotIu8Trait<false, true, false>>(dot_iu8_inputs());
  int_isa_test::run_value_test_cases<DotIu8Trait<false, false, false>>(dot_iu8_inputs());
}

TEST(IntIsaIntegerDot, Iu8ClampModesMatchOracle) {
  if (!have_device())
    GTEST_SKIP() << "no HIP device available";
  int_isa_test::run_value_test_cases<DotIu8Trait<true, true, true>>(dot_iu8_inputs());
  int_isa_test::run_value_test_cases<DotIu8Trait<true, false, true>>(dot_iu8_inputs());
  int_isa_test::run_value_test_cases<DotIu8Trait<false, true, true>>(dot_iu8_inputs());
  int_isa_test::run_value_test_cases<DotIu8Trait<false, false, true>>(dot_iu8_inputs());
}

TEST(IntIsaIntegerDot, U4MatchesOracle) {
  if (!have_device())
    GTEST_SKIP() << "no HIP device available";
  int_isa_test::run_value_test_cases<DotU4Trait<false>>(dot_u4_inputs());
  int_isa_test::run_value_test_cases<DotU4Trait<true>>(dot_u4_inputs());
}

TEST(IntIsaIntegerDot, Iu4SignAndClampModesMatchOracle) {
  if (!have_device())
    GTEST_SKIP() << "no HIP device available";
  int_isa_test::run_value_test_cases<DotIu4Trait<true, true, false>>(dot_iu4_inputs());
  int_isa_test::run_value_test_cases<DotIu4Trait<true, false, false>>(dot_iu4_inputs());
  int_isa_test::run_value_test_cases<DotIu4Trait<false, true, false>>(dot_iu4_inputs());
  int_isa_test::run_value_test_cases<DotIu4Trait<false, false, false>>(dot_iu4_inputs());
  int_isa_test::run_value_test_cases<DotIu4Trait<true, true, true>>(dot_iu4_inputs());
  int_isa_test::run_value_test_cases<DotIu4Trait<true, false, true>>(dot_iu4_inputs());
  int_isa_test::run_value_test_cases<DotIu4Trait<false, true, true>>(dot_iu4_inputs());
  int_isa_test::run_value_test_cases<DotIu4Trait<false, false, true>>(dot_iu4_inputs());
}
