#include "test_support.hpp"

#include <cstdint>

using i32x2 = int __attribute__((ext_vector_type(2)));
using i32x4 = int __attribute__((ext_vector_type(4)));

// Models a wave-cooperative LDS tile with two fields per lane. Load variants
// are initialized with ordinary C++ stores; store variants are observed with
// ordinary C++ loads, so the affected operations never validate one another.
extern "C" __global__ void ds_2addr_tile(double *out, const float *in,
                                         int variant) {
  __shared__ alignas(16) unsigned char tile[4096];
  const int lane = static_cast<int>(threadIdx.x);
  const unsigned lds =
      static_cast<unsigned>(reinterpret_cast<uintptr_t>(tile + lane * 16));
  const bool wide = variant >= 4;
  const bool stride64 = (variant & 1) != 0;
  const bool affected_store = (variant & 2) != 0;
  const unsigned second = stride64 ? 2048u : (wide ? 8u : 4u);
  const double x = static_cast<double>(in[lane]);

  if (!affected_store) {
    if (wide) {
      *reinterpret_cast<volatile double *>(tile + lane * 16) = x;
      *reinterpret_cast<volatile double *>(tile + lane * 16 + second) = x + 1.0;
    } else {
      *reinterpret_cast<volatile float *>(tile + lane * 16) =
          static_cast<float>(x);
      *reinterpret_cast<volatile float *>(tile + lane * 16 + second) =
          static_cast<float>(x + 1.0);
    }
  }
  __syncthreads();

  if (!affected_store && !wide) {
    i32x2 value;
    if (stride64)
      asm volatile("ds_load_2addr_stride64_b32 %0, %1 offset0:0 offset1:8"
                   : "=v"(value)
                   : "v"(lds)
                   : "memory");
    else
      asm volatile("ds_load_2addr_b32 %0, %1 offset0:0 offset1:1"
                   : "=v"(value)
                   : "v"(lds)
                   : "memory");
    asm volatile("s_wait_dscnt 0" ::: "memory");
    out[2 * lane] = static_cast<double>(__int_as_float(value[0]));
    out[2 * lane + 1] = static_cast<double>(__int_as_float(value[1]));
  } else if (!affected_store) {
    i32x4 value;
    if (stride64)
      asm volatile("ds_load_2addr_stride64_b64 %0, %1 offset0:0 offset1:4"
                   : "=v"(value)
                   : "v"(lds)
                   : "memory");
    else
      asm volatile("ds_load_2addr_b64 %0, %1 offset0:0 offset1:1"
                   : "=v"(value)
                   : "v"(lds)
                   : "memory");
    asm volatile("s_wait_dscnt 0" ::: "memory");
    const unsigned long long lo =
        static_cast<unsigned>(value[0]) |
        (static_cast<unsigned long long>(static_cast<unsigned>(value[1]))
         << 32);
    const unsigned long long hi =
        static_cast<unsigned>(value[2]) |
        (static_cast<unsigned long long>(static_cast<unsigned>(value[3]))
         << 32);
    out[2 * lane] = __longlong_as_double(lo);
    out[2 * lane + 1] = __longlong_as_double(hi);
  } else if (!wide) {
    const i32x2 value{__float_as_int(static_cast<float>(x)),
                      __float_as_int(static_cast<float>(x + 1.0))};
    if (stride64)
      asm volatile("ds_store_2addr_stride64_b32 %0, %1, %2 offset0:0 offset1:8"
                   :
                   : "v"(lds), "v"(value[0]), "v"(value[1])
                   : "memory");
    else
      asm volatile("ds_store_2addr_b32 %0, %1, %2 offset0:0 offset1:1"
                   :
                   : "v"(lds), "v"(value[0]), "v"(value[1])
                   : "memory");
    asm volatile("s_wait_dscnt 0" ::: "memory");
    out[2 * lane] = static_cast<double>(
        *reinterpret_cast<volatile float *>(tile + lane * 16));
    out[2 * lane + 1] = static_cast<double>(
        *reinterpret_cast<volatile float *>(tile + lane * 16 + second));
  } else {
    const long lo = __double_as_longlong(x);
    const long hi = __double_as_longlong(x + 1.0);
    if (stride64)
      asm volatile("ds_store_2addr_stride64_b64 %0, %1, %2 offset0:0 offset1:4"
                   :
                   : "v"(lds), "v"(lo), "v"(hi)
                   : "memory");
    else
      asm volatile("ds_store_2addr_b64 %0, %1, %2 offset0:0 offset1:1"
                   :
                   : "v"(lds), "v"(lo), "v"(hi)
                   : "memory");
    asm volatile("s_wait_dscnt 0" ::: "memory");
    out[2 * lane] = *reinterpret_cast<volatile double *>(tile + lane * 16);
    out[2 * lane + 1] =
        *reinterpret_cast<volatile double *>(tile + lane * 16 + second);
  }
}

int main() {
  constexpr int lanes = 64;
  corpus::DeviceBuffer<float> input(lanes);
  corpus::DeviceBuffer<double> output(2 * lanes);
  std::vector<double> expected(2 * lanes);
  for (int i = 0; i < lanes; ++i) {
    input.host[i] = static_cast<float>(i) * 0.25f - 3.0f;
    expected[2 * i] = input.host[i];
    expected[2 * i + 1] = input.host[i] + 1.0;
  }
  input.host_to_target();
  for (int variant = 0; variant < 8; ++variant) {
    output.clear();
    hipLaunchKernelGGL(ds_2addr_tile, dim3(1), dim3(lanes), 0, 0, output.device,
                       input.device, variant);
    output.target_to_host();
    if (!corpus::expect_near("two-field LDS tile", output.host, expected, 0.0,
                             variant))
      return 1;
  }
  return 0;
}
