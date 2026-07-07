#include "../../../third_party/hip-matmul/common.hip"

// HIP 7 exposes warpSize as a device-side object, while this upstream testbed
// also uses it as a non-type template argument.
#define warpSize KERNEL_CORPUS_HIP_MATMUL_WARP_SIZE
#define main kernel_corpus_hip_matmul_upstream_main
#include "../../../third_party/hip-matmul/matvec.hip"
#undef main

int main(int argc, char **argv) {
  applyMNKArgs(argc, argv);
  return kernel_corpus_hip_matmul_upstream_main();
}
