#include "test_support.hpp"

#include <bit>
#include <cmath>
#include <cstdint>
#include <limits>

// Packed CLAMP=1 forms with low/high placement, stochastic rounding, and
// source modifiers in one independently runnable object.
extern "C" __global__ void
e5m3_pack(unsigned *packed_low, unsigned *packed_high, unsigned *stochastic,
          unsigned *modified, const float *in, const float *stochastic_in,
          const unsigned *seeds, int n, int fp16_ovfl) {
  if (fp16_ovfl)
    asm volatile("s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 23, 1), 1" ::
                     : "memory");
  else
    asm volatile("s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 23, 1), 0" ::
                     : "memory");

  const int tid = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
  if (tid >= n)
    return;
  const float x = in[tid];
  const float y = in[(tid + 1) % n];
  const float stochastic_x = stochastic_in[tid];

  unsigned low = 0xa5a50000u;
  asm volatile("v_cvt_pk_fp8_f32 %0, %1, %2 op_sel:[0,0,0] clamp"
               : "+v"(low)
               : "v"(x), "v"(y));

  unsigned high = 0x00005a5au;
  asm volatile("v_cvt_pk_fp8_f32 %0, %1, %2 op_sel:[0,0,1] clamp"
               : "+v"(high)
               : "v"(x), "v"(y));

  unsigned sr = 0x5a5aa5a5u;
  asm volatile("v_cvt_sr_fp8_f32 %0, %1, %2 byte_sel:3 clamp"
               : "+v"(sr)
               : "v"(stochastic_x), "v"(seeds[tid]));

  unsigned abs_neg = 0;
  asm volatile("v_cvt_pk_fp8_f32 %0, -|%1|, |%2| clamp"
               : "=v"(abs_neg)
               : "v"(x), "v"(y));

  packed_low[tid] = low;
  packed_high[tid] = high;
  stochastic[tid] = sr;
  modified[tid] = abs_neg & 0xffffu;
}

static unsigned encode_ue5m3(float value, bool fp16_ovfl) {
  if (std::isnan(value))
    return 0xff;
  if (std::isinf(value))
    return fp16_ovfl ? 0xfe : 0xff;
  const double magnitude = std::fabs(static_cast<double>(value));
  if (magnitude == 0.0f)
    return 0;

  // Independent RNE oracle: enumerate the 255 finite UE5M3 values and apply
  // nearest/ties-to-even directly rather than duplicating the device-side
  // bit-manipulation sequence. ISA section 17.6.92 makes the unsigned format
  // magnitude-only and reserves 0xff for NaN/overflow.
  const double maximum = corpus::decode_ue5m3(0xfe);
  const double previous = corpus::decode_ue5m3(0xfd);
  const double overflow_midpoint = maximum + (maximum - previous) * 0.5;
  if (magnitude > overflow_midpoint)
    return fp16_ovfl ? 0xfe : 0xff;

  unsigned best = 0;
  double best_error = std::numeric_limits<double>::infinity();
  for (unsigned code = 0; code <= 0xfe; ++code) {
    const double error =
        std::fabs(magnitude - corpus::decode_ue5m3(code));
    if (error < best_error ||
        (error == best_error && (code & 1u) == 0 && (best & 1u) != 0)) {
      best = code;
      best_error = error;
    }
  }
  return best;
}

static unsigned encode_ue5m3_sr(float value, unsigned seed, bool fp16_ovfl) {
  if (std::isnan(value))
    return 0xff;
  if (std::isinf(value))
    return fp16_ovfl ? 0xfe : 0xff;
  const float magnitude = std::fabs(value);
  if (magnitude == 0.0f)
    return 0;

  const unsigned bits = std::bit_cast<unsigned>(magnitude);
  // ISA section 17.6.94 defines SR by adding the high seed bits to the
  // discarded significand bits. Unlike RNE, that has no nearest-value
  // formulation, so this oracle spells out that arithmetic directly.
  const int f32_exponent = static_cast<int>((bits >> 23) & 0xffu);
  int exponent = f32_exponent - 127 + 15;
  const unsigned fraction = bits & 0x7fffffu;
  unsigned result = 0;
  if (exponent <= 0) {
    const unsigned full_mantissa = fraction | 0x800000u;
    const int shift = 21 - exponent;
    if (shift > 24)
      return 0;
    const unsigned truncated = full_mantissa >> shift;
    const unsigned truncated_bits = full_mantissa & ((1u << shift) - 1u);
    const unsigned random_add = seed >> (32 - shift);
    result = truncated + ((truncated_bits + random_add) >= (1u << shift));
    if (result >= 8)
      result = 0x08;
  } else if (exponent > 31) {
    result = 0xff;
  } else {
    unsigned mantissa = (fraction >> 20) & 7u;
    const unsigned truncated_bits = fraction & 0xfffffu;
    const unsigned random_add = seed >> 12;
    if (truncated_bits + random_add > 0xfffffu) {
      if (++mantissa > 7) {
        mantissa = 0;
        ++exponent;
      }
    }
    result = exponent > 31 || (exponent == 31 && mantissa >= 7)
                 ? 0xff
                 : (static_cast<unsigned>(exponent) << 3) | mantissa;
  }
  return fp16_ovfl && result == 0xff ? 0xfe : result;
}

int main() {
  constexpr int n = 64;
  corpus::DeviceBuffer<float> input(n), stochastic_input(n);
  corpus::DeviceBuffer<unsigned> seeds(n), low(n), high(n), stochastic(n),
      modified(n);
  const float boundary_values[] = {
      0.0f,
      0x1p-17f,
      0x1.8p-17f,
      0x1.cp-15f,
      0.5f,
      1.0f,
      0x1.1p0f,
      0x1.3p0f,
      1.5f,
      0x1.ep15f,
      0x1.cp16f,
      0x1.ep16f,
      std::numeric_limits<float>::infinity(),
      std::numeric_limits<float>::quiet_NaN(),
      -0.0f,
      -1.0f,
      std::bit_cast<float>(0x3fc80205u),
      std::bit_cast<float>(0x38f7ffbfu),
      std::bit_cast<float>(0x40b7fe26u),
      std::bit_cast<float>(0x470800efu),
      2.0f,
      4.0f,
      8.0f,
      16.0f,
      32.0f,
  };
  constexpr int value_count =
      static_cast<int>(sizeof(boundary_values) / sizeof(boundary_values[0]));
  constexpr float stochastic_values[] = {
      0x1.08p-8f, 0x1.08p-8f, 0x1.2p-16f, 0x1.2p-16f, 0x1p-17f,  0x1p-17f,
      0x1.cp-15f, 0x1.cp-15f, 0.5f,       0.5f,       120000.0f, 120000.0f,
      0x1.ep16f,  0x1.ep16f,  1.0f,       1.5f,
  };
  constexpr unsigned seed_values[] = {
      0u, 0xffffffffu, 0u,          0xffffffffu, 0x12345678u, 0xabcdef01u,
      0u, 0xffffffffu, 0x13579bdfu, 0x2468ace0u, 0u,          0xffffffffu,
      0u, 0xffffffffu, 0x55555555u, 0xaaaaaaaau,
  };
  std::vector<unsigned> expected_low(n), expected_high(n), expected_sr(n),
      expected_modified(n);
  for (int i = 0; i < n; ++i) {
    input.host[i] = boundary_values[i % value_count];
    stochastic_input.host[i] = stochastic_values[i % 16];
    seeds.host[i] = seed_values[i % 16];
  }

  input.host_to_target();
  stochastic_input.host_to_target();
  seeds.host_to_target();
  bool ok = true;
  for (int fp16_ovfl = 0; fp16_ovfl < 2; ++fp16_ovfl) {
    for (int i = 0; i < n; ++i) {
      const unsigned x = encode_ue5m3(input.host[i], fp16_ovfl != 0);
      const unsigned y = encode_ue5m3(input.host[(i + 1) % n], fp16_ovfl != 0);
      expected_low[i] = 0xa5a50000u | x | (y << 8);
      expected_high[i] = 0x00005a5au | (x << 16) | (y << 24);
      expected_sr[i] = (0x5a5aa5a5u & 0x00ffffffu) |
                       (encode_ue5m3_sr(stochastic_input.host[i], seeds.host[i],
                                        fp16_ovfl != 0)
                        << 24);
      // UE5M3 is an unsigned magnitude format. NEG and ABS affect only the
      // discarded sign, so their semantic result is intentionally identical;
      // source-assembly coverage checks the modifier encodings themselves.
      expected_modified[i] =
          encode_ue5m3(-std::fabs(input.host[i]), fp16_ovfl != 0) |
          (encode_ue5m3(std::fabs(input.host[(i + 1) % n]), fp16_ovfl != 0)
           << 8);
    }

    low.clear();
    high.clear();
    stochastic.clear();
    modified.clear();
    hipLaunchKernelGGL(e5m3_pack, dim3(1), dim3(64), 0, 0, low.device,
                       high.device, stochastic.device, modified.device,
                       input.device, stochastic_input.device, seeds.device, n,
                       fp16_ovfl);
    low.target_to_host();
    high.target_to_host();
    stochastic.target_to_host();
    modified.target_to_host();
    ok &= corpus::expect_equal("UE5M3 packed low half", low.host, expected_low,
                               fp16_ovfl);
    ok &= corpus::expect_equal("UE5M3 packed high half", high.host,
                               expected_high, fp16_ovfl);
    ok &= corpus::expect_equal("UE5M3 stochastic byte selection",
                               stochastic.host, expected_sr, fp16_ovfl);
    ok &= corpus::expect_equal("UE5M3 source modifiers", modified.host,
                               expected_modified, fp16_ovfl);
  }
  return ok ? 0 : 1;
}
