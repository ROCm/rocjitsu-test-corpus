#include "../../../third_party/hip-matmul/common.hip"

// HIP 7 exposes warpSize as a device-side object, while this upstream testbed
// also uses it as a non-type template argument.
#define warpSize ROCFUZZ_HIP_MATMUL_WARP_SIZE
#include "../../../third_party/hip-matmul/matvec.hip"
