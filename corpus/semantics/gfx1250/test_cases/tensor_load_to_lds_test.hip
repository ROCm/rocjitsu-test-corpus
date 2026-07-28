#include "test_support.hpp"

#include <cstdint>

using u32x4 = unsigned __attribute__((ext_vector_type(4)));
using u32x8 = unsigned __attribute__((ext_vector_type(8)));

// A tensor-DMA prefetch of one contiguous int tile followed by ordinary
// per-lane consumption from LDS.
extern "C" __global__ void tensor_tile_prefetch_fallback(
    int *out, unsigned *descriptor_after, u32x4 tensor_desc,
    u32x8 group_desc) {
  extern __shared__ int tile[];
  asm volatile("tensor_load_to_lds %0, %1"
               : : "s"(tensor_desc), "s"(group_desc) : "memory");
  asm volatile("s_wait_tensorcnt 0" ::: "memory");
  if (threadIdx.x < 16) {
    int value;
    asm volatile("ds_load_b32 %0, %1"
                 : "=v"(value)
                 : "v"(static_cast<unsigned>(threadIdx.x) * 4)
                 : "memory");
    asm volatile("s_wait_dscnt 0" ::: "memory");
    out[threadIdx.x] = value;
  }
  if (threadIdx.x == 0)
    descriptor_after[0] = group_desc[0];
}

// This shape constructs the descriptor mask in the kernel and keeps it dead
// after the tensor operation, isolating the descriptor bits consumed by the
// instruction.
extern "C" __global__ void tensor_tile_prefetch_definition(
    int *out, u32x4 tensor_desc, u32x8 group_desc, unsigned dynamic_mask) {
  extern __shared__ int tile[];
  group_desc[0] = 0;
  group_desc[0] &= 0xfffcffffu;
  group_desc[0] |= (2u << 16) | dynamic_mask;
  group_desc[0] &= 0xfff7ffffu;
  asm volatile("tensor_load_to_lds %0, %1"
               : : "s"(tensor_desc), "s"(group_desc) : "memory");
  asm volatile("s_wait_tensorcnt 0" ::: "memory");
  if (threadIdx.x < 16) {
    int value;
    asm volatile("ds_load_b32 %0, %1"
                 : "=v"(value)
                 : "v"(static_cast<unsigned>(threadIdx.x) * 4)
                 : "memory");
    asm volatile("s_wait_dscnt 0" ::: "memory");
    out[threadIdx.x] = value;
  }
}

int main() {
  constexpr unsigned elements = 16;
  corpus::DeviceBuffer<int> input(elements);
  corpus::DeviceBuffer<int> fallback_output(elements);
  corpus::DeviceBuffer<int> definition_output(elements);
  corpus::DeviceBuffer<unsigned> descriptor_after(1);
  for (unsigned i = 0; i < elements; ++i)
    input.host[i] = static_cast<int>(3 * i + 7);
  input.host_to_target();
  fallback_output.clear();
  definition_output.clear();
  descriptor_after.clear();

  const uintptr_t address = reinterpret_cast<uintptr_t>(input.device);
  u32x4 tensor_desc{1u, 0u, static_cast<unsigned>(address),
                    static_cast<unsigned>((address >> 32) & 0x01ffffffu) |
                        0x80000000u};
  u32x8 group_desc{};
  constexpr unsigned multicast_mask = 0x5a5au;
  group_desc[0] = (2u << 16) | multicast_mask; // i32 type plus multicast mask
  group_desc[1] = elements << 16;  // tensor extent
  group_desc[3] = elements << 16;  // tile extent

  hipLaunchKernelGGL(tensor_tile_prefetch_fallback, dim3(1), dim3(32),
                     elements * sizeof(int), 0,
                     fallback_output.device, descriptor_after.device,
                     tensor_desc, group_desc);
  fallback_output.target_to_host();
  descriptor_after.target_to_host();
  if (!corpus::expect_equal("tensor-DMA live-descriptor fallback",
                            fallback_output.host, input.host))
    return 1;
  const std::vector<unsigned> expected_descriptor{group_desc[0]};
  if (!corpus::expect_equal("tensor descriptor preserved",
                            descriptor_after.host, expected_descriptor))
    return 1;

  hipLaunchKernelGGL(tensor_tile_prefetch_definition, dim3(1), dim3(32),
                     elements * sizeof(int), 0, definition_output.device,
                     tensor_desc, group_desc, multicast_mask);
  definition_output.target_to_host();
  return corpus::expect_equal("tensor-DMA definition-time mask",
                              definition_output.host, input.host)
             ? 0
             : 1;
}
