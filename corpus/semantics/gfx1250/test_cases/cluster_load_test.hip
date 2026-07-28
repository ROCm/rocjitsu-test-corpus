#include "test_support.hpp"

#include <bit>
#include <cstdint>

using i32x2 = int __attribute__((ext_vector_type(2)));
using i32x4 = int __attribute__((ext_vector_type(4)));

// A clustered activation streamer. Synchronous variants vector-load directly;
// asynchronous variants stage global data in LDS before ordinary consumption.
extern "C" __global__ void cluster_activation_stream(float *out, unsigned *m0_after,
                                                      const float *in, int variant) {
  __shared__ alignas(16) unsigned char stage[2048];
  const int tid = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
  const unsigned long address = reinterpret_cast<unsigned long>(in + tid * 4);
  const unsigned byte_offset = static_cast<unsigned>(tid * 4 * sizeof(float));
  const unsigned long scalar_base = reinterpret_cast<unsigned long>(in);
  const unsigned lds = static_cast<unsigned>(
      reinterpret_cast<uintptr_t>(stage + threadIdx.x * 16));
  // Keep the cluster-multicast mask (M0[15:0]) neutral so the case isolates
  // data movement and M0 preservation. The high bits remain nonzero and
  // variant-specific.
  const unsigned m0_sentinel =
      0x12000000u | (static_cast<unsigned>(variant) << 16);
  int scalar = 0;
  i32x2 pair{};
  i32x4 quad{};
  // M0 is a reserved architectural register and cannot be named in Clang's
  // clobber list without invoking -Winline-asm's undefined-behaviour warning.
  // The explicit write/read bracket the only operations whose M0 state this
  // fixture observes.
  asm volatile("s_mov_b32 m0, %0" : : "s"(m0_sentinel));
  if (variant == 0)
    asm volatile("cluster_load_b32 %0, %1, off"
                 : "=v"(scalar) : "v"(address) : "memory");
  else if (variant == 1)
    asm volatile("cluster_load_b64 %0, %1, off"
                 : "=v"(pair) : "v"(address) : "memory");
  else if (variant == 2)
    asm volatile("cluster_load_b128 %0, %1, off"
                 : "=v"(quad) : "v"(address) : "memory");
  else if (variant == 3)
    asm volatile("cluster_load_async_to_lds_b8 %0, %1, off"
                 : : "v"(lds), "v"(address) : "memory");
  else if (variant == 4)
    asm volatile("cluster_load_async_to_lds_b32 %0, %1, off"
                 : : "v"(lds), "v"(address) : "memory");
  else if (variant == 5)
    asm volatile("cluster_load_async_to_lds_b64 %0, %1, off"
                 : : "v"(lds), "v"(address) : "memory");
  else if (variant == 6)
    asm volatile("cluster_load_async_to_lds_b128 %0, %1, off"
                 : : "v"(lds), "v"(address) : "memory");
  else if (variant == 7)
    asm volatile("cluster_load_b32 %0, %1, %2"
                 : "=v"(scalar)
                 : "v"(byte_offset), "s"(scalar_base)
                 : "memory");
  else if (variant == 8)
    asm volatile("cluster_load_b64 %0, %1, %2"
                 : "=v"(pair)
                 : "v"(byte_offset), "s"(scalar_base)
                 : "memory");
  else if (variant == 9)
    asm volatile("cluster_load_b128 %0, %1, %2"
                 : "=v"(quad)
                 : "v"(byte_offset), "s"(scalar_base)
                 : "memory");
  else if (variant == 10)
    asm volatile("cluster_load_async_to_lds_b8 %0, %1, %2"
                 :
                 : "v"(lds), "v"(byte_offset), "s"(scalar_base)
                 : "memory");
  else if (variant == 11)
    asm volatile("cluster_load_async_to_lds_b32 %0, %1, %2"
                 :
                 : "v"(lds), "v"(byte_offset), "s"(scalar_base)
                 : "memory");
  else if (variant == 12)
    asm volatile("cluster_load_async_to_lds_b64 %0, %1, %2"
                 :
                 : "v"(lds), "v"(byte_offset), "s"(scalar_base)
                 : "memory");
  else
    asm volatile("cluster_load_async_to_lds_b128 %0, %1, %2"
                 :
                 : "v"(lds), "v"(byte_offset), "s"(scalar_base)
                 : "memory");
  if (variant % 7 >= 3)
    asm volatile("s_wait_asynccnt 0" ::: "memory");
  else
    asm volatile("s_wait_loadcnt 0" ::: "memory");
  unsigned restored_m0;
  asm volatile("s_mov_b32 %0, m0" : "=s"(restored_m0));

  const int kind = variant % 7;
  if (kind == 0)
    out[tid] = __int_as_float(scalar);
  else if (kind == 1)
    out[tid] = __int_as_float(pair[0]) + __int_as_float(pair[1]);
  else if (kind == 2)
    out[tid] = __int_as_float(quad[0]) + __int_as_float(quad[1]) +
               __int_as_float(quad[2]) + __int_as_float(quad[3]);
  else if (kind == 3)
    out[tid] = static_cast<float>(*reinterpret_cast<volatile unsigned char *>(
        stage + threadIdx.x * 16));
  else {
    const int count = 1 << (kind - 4);
    float sum = 0.0f;
    for (int i = 0; i < count; ++i)
      sum += *reinterpret_cast<volatile float *>(stage + threadIdx.x * 16 + i * 4);
    out[tid] = sum;
  }
  m0_after[tid] = restored_m0;
}

int main() {
  constexpr int blocks = 2;
  constexpr int lanes = 32;
  constexpr int n = blocks * lanes;
  corpus::DeviceBuffer<float> input(n * 4);
  corpus::DeviceBuffer<float> output(n);
  corpus::DeviceBuffer<unsigned> m0_after(n);
  for (int i = 0; i < n * 4; ++i) {
    const unsigned bits =
        0x3f000000u | ((static_cast<unsigned>(i) + 1u) * 0x101u);
    input.host[i] = std::bit_cast<float>(bits);
  }
  input.host_to_target();

  hipLaunchConfig_t config{};
  config.gridDim = dim3(blocks);
  config.blockDim = dim3(lanes);
  hipLaunchAttribute attribute{};
  attribute.id = hipLaunchAttributeClusterDimension;
  attribute.value.clusterDim.x = blocks;
  attribute.value.clusterDim.y = 1;
  attribute.value.clusterDim.z = 1;
  config.attrs = &attribute;
  config.numAttrs = 1;

  for (int variant = 0; variant < 14; ++variant) {
    output.clear();
    m0_after.clear();
    HIP_CHECK(hipLaunchKernelEx(&config, cluster_activation_stream, output.device,
                                m0_after.device, input.device, variant));
    output.target_to_host();
    m0_after.target_to_host();
    std::vector<float> expected(n);
    std::vector<unsigned> expected_m0(
        n, 0x12000000u | (static_cast<unsigned>(variant) << 16));
    const int kind = variant % 7;
    for (int tid = 0; tid < n; ++tid) {
      if (kind == 3)
        expected[tid] = static_cast<float>(
            static_cast<unsigned char *>(static_cast<void *>(input.host.data()))[tid * 16]);
      else {
        const int count = (kind == 1 || kind == 5) ? 2
                          : (kind == 2 || kind == 6) ? 4
                                                    : 1;
        for (int i = 0; i < count; ++i)
          expected[tid] += input.host[tid * 4 + i];
      }
    }
    if (!corpus::expect_near("cluster activation stream", output.host, expected,
                             0.0, variant))
      return 1;
    if (!corpus::expect_equal("cluster M0 preservation", m0_after.host,
                              expected_m0, variant))
      return 1;
  }
  return 0;
}
