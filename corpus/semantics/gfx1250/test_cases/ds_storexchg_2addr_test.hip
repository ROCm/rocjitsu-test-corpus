#include "test_support.hpp"

#include <cstdint>

using i32x2 = int __attribute__((ext_vector_type(2)));
using i32x4 = int __attribute__((ext_vector_type(4)));

// Simulates an LDS producer/consumer handoff. Each atomic exchange must return
// the old payload and leave the new payload in the slot; ordinary accesses
// initialize and inspect the slots independently.
extern "C" __global__ void ds_exchange_handoff(double *out, const float *in,
                                               int variant) {
  const int lane = static_cast<int>(threadIdx.x);
  const unsigned lds = static_cast<unsigned>(lane * 16);
  const bool wide = variant >= 2;
  const bool stride64 = (variant & 1) != 0;
  const unsigned second = stride64 ? 2048u : (wide ? 8u : 4u);
  const double x = in[lane];

  if (wide) {
    const long initial0 = __double_as_longlong(x);
    const long initial1 = __double_as_longlong(x + 1.0);
    asm volatile("ds_store_b64 %0, %1" : : "v"(lds), "v"(initial0) : "memory");
    asm volatile("ds_store_b64 %0, %1"
                 :
                 : "v"(lds + second), "v"(initial1)
                 : "memory");
  } else {
    const int initial0 = __float_as_int(static_cast<float>(x));
    const int initial1 = __float_as_int(static_cast<float>(x + 1.0));
    asm volatile("ds_store_b32 %0, %1" : : "v"(lds), "v"(initial0) : "memory");
    asm volatile("ds_store_b32 %0, %1"
                 :
                 : "v"(lds + second), "v"(initial1)
                 : "memory");
  }
  asm volatile("s_wait_dscnt 0" ::: "memory");
  __syncthreads();

  double old0;
  double old1;
  if (!wide) {
    const i32x2 replacement{__float_as_int(static_cast<float>(x + 10.0)),
                            __float_as_int(static_cast<float>(x + 11.0))};
    i32x2 old;
    if (stride64)
      asm volatile("ds_storexchg_2addr_stride64_rtn_b32 %0, %1, %2, %3 "
                   "offset0:0 offset1:8"
                   : "=v"(old)
                   : "v"(lds), "v"(replacement[0]), "v"(replacement[1])
                   : "memory");
    else
      asm volatile(
          "ds_storexchg_2addr_rtn_b32 %0, %1, %2, %3 offset0:0 offset1:1"
          : "=v"(old)
          : "v"(lds), "v"(replacement[0]), "v"(replacement[1])
          : "memory");
    asm volatile("s_wait_dscnt 0" ::: "memory");
    old0 = __int_as_float(old[0]);
    old1 = __int_as_float(old[1]);
  } else {
    const long replacement0 = __double_as_longlong(x + 10.0);
    const long replacement1 = __double_as_longlong(x + 11.0);
    i32x4 old;
    if (stride64)
      asm volatile("ds_storexchg_2addr_stride64_rtn_b64 %0, %1, %2, %3 "
                   "offset0:0 offset1:4"
                   : "=v"(old)
                   : "v"(lds), "v"(replacement0), "v"(replacement1)
                   : "memory");
    else
      asm volatile(
          "ds_storexchg_2addr_rtn_b64 %0, %1, %2, %3 offset0:0 offset1:1"
          : "=v"(old)
          : "v"(lds), "v"(replacement0), "v"(replacement1)
          : "memory");
    asm volatile("s_wait_dscnt 0" ::: "memory");
    const unsigned long long a =
        static_cast<unsigned>(old[0]) |
        (static_cast<unsigned long long>(static_cast<unsigned>(old[1])) << 32);
    const unsigned long long b =
        static_cast<unsigned>(old[2]) |
        (static_cast<unsigned long long>(static_cast<unsigned>(old[3])) << 32);
    old0 = __longlong_as_double(a);
    old1 = __longlong_as_double(b);
  }

  double new0;
  double new1;
  if (wide) {
    long updated0;
    long updated1;
    asm volatile("ds_load_b64 %0, %2\n\t"
                 "ds_load_b64 %1, %3\n\t"
                 "s_wait_dscnt 0"
                 : "=&v"(updated0), "=&v"(updated1)
                 : "v"(lds), "v"(lds + second)
                 : "memory");
    new0 = __longlong_as_double(updated0);
    new1 = __longlong_as_double(updated1);
  } else {
    int updated0;
    int updated1;
    asm volatile("ds_load_b32 %0, %2\n\t"
                 "ds_load_b32 %1, %3\n\t"
                 "s_wait_dscnt 0"
                 : "=&v"(updated0), "=&v"(updated1)
                 : "v"(lds), "v"(lds + second)
                 : "memory");
    new0 = __int_as_float(updated0);
    new1 = __int_as_float(updated1);
  }
  out[4 * lane] = old0;
  out[4 * lane + 1] = old1;
  out[4 * lane + 2] = new0;
  out[4 * lane + 3] = new1;
}

int main() {
  constexpr int lanes = 64;
  corpus::DeviceBuffer<float> input(lanes);
  corpus::DeviceBuffer<double> output(4 * lanes);
  std::vector<double> expected(4 * lanes);
  for (int i = 0; i < lanes; ++i) {
    input.host[i] = static_cast<float>(i) * 0.25f - 3.0f;
    expected[4 * i] = input.host[i];
    expected[4 * i + 1] = input.host[i] + 1.0;
    expected[4 * i + 2] = input.host[i] + 10.0;
    expected[4 * i + 3] = input.host[i] + 11.0;
  }
  input.host_to_target();
  for (int variant = 0; variant < 4; ++variant) {
    output.clear();
    hipLaunchKernelGGL(ds_exchange_handoff, dim3(1), dim3(lanes), 4096, 0,
                       output.device, input.device, variant);
    output.target_to_host();
    if (!corpus::expect_near("LDS queue handoff", output.host, expected, 0.0,
                             variant))
      return 1;
  }
  return 0;
}
